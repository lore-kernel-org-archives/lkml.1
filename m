Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbYCOAit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbYCOAit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 20:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYCOAii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 20:38:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34106 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbYCOAig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 20:38:36 -0400
Date: Sat, 15 Mar 2008 00:38:29 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: dm-crypt@saout.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [dm-crypt] Kernel 2.6.25-rc4: lock up when writing onto DM-Crypt volume
Message-ID: <20080315003829.GB29322@agk.fab.redhat.com>
Mail-Followup-To: dm-crypt@saout.de, linux-kernel@vger.kernel.org
References: <47D075FD.9040200@datenparkplatz.de> <47DA431C.3010502@redhat.com> <47DB1670.3060002@datenparkplatz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DB1670.3060002@datenparkplatz.de>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2008 at 01:21:04AM +0100, Ulrich Lukas wrote:
> With that patch applied, writing seems to work again.
 
Current version of the patch is below.  It's still not quite finished.

> Btw, is this a regression because of the changed 2.6.25(-rc) code or is
> it just a coincidence that it worked before?

Introduced during code changes to support async crypto interface.
 
Alasdair


From: Milan Broz <mbroz@redhat.com>

Fix regression in dm-crypt introduced in commit
3a7f6c990ad04e6f576a159876c602d14d6f7fef
(dm crypt: use async crypto).

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-crypt.c |   60 +++++++++++++++++++++++++-------------------------
 1 files changed, 31 insertions(+), 29 deletions(-)

Index: linux-2.6.25-rc4/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.25-rc4.orig/drivers/md/dm-crypt.c	2008-03-14 21:32:53.000000000 +0000
+++ linux-2.6.25-rc4/drivers/md/dm-crypt.c	2008-03-14 22:19:01.000000000 +0000
@@ -1,7 +1,7 @@
 /*
  * Copyright (C) 2003 Christophe Saout <christophe@saout.de>
  * Copyright (C) 2004 Clemens Fruhwirth <clemens@endorphin.org>
- * Copyright (C) 2006-2007 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2006-2008 Red Hat, Inc. All rights reserved.
  *
  * This file is released under the GPL.
  */
@@ -93,6 +93,8 @@ struct crypt_config {
 
 	struct workqueue_struct *io_queue;
 	struct workqueue_struct *crypt_queue;
+	wait_queue_head_t writeq;
+
 	/*
 	 * crypto related data
 	 */
@@ -331,14 +333,7 @@ static void crypt_convert_init(struct cr
 	ctx->idx_out = bio_out ? bio_out->bi_idx : 0;
 	ctx->sector = sector + cc->iv_offset;
 	init_completion(&ctx->restart);
-	/*
-	 * Crypto operation can be asynchronous,
-	 * ctx->pending is increased after request submission.
-	 * We need to ensure that we don't call the crypt finish
-	 * operation before pending got incremented
-	 * (dependent on crypt submission return code).
-	 */
-	atomic_set(&ctx->pending, 2);
+	atomic_set(&ctx->pending, 1);
 }
 
 static int crypt_convert_block(struct crypt_config *cc,
@@ -411,43 +406,42 @@ static void crypt_alloc_req(struct crypt
 static int crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx)
 {
-	int r = 0;
+	int r;
 
 	while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
 	      ctx->idx_out < ctx->bio_out->bi_vcnt) {
 
 		crypt_alloc_req(cc, ctx);
 
+		atomic_inc(&ctx->pending);
+
 		r = crypt_convert_block(cc, ctx, cc->req);
 
 		switch (r) {
+		/* async */
 		case -EBUSY:
 			wait_for_completion(&ctx->restart);
 			INIT_COMPLETION(ctx->restart);
 			/* fall through*/
 		case -EINPROGRESS:
-			atomic_inc(&ctx->pending);
 			cc->req = NULL;
-			r = 0;
-			/* fall through*/
+			ctx->sector++;
+			continue;
+
+		/* sync */
 		case 0:
+			atomic_dec(&ctx->pending);
 			ctx->sector++;
 			continue;
-		}
 
-		break;
+		/* error */
+		default:
+			atomic_dec(&ctx->pending);
+			return r;
+		}
 	}
 
-	/*
-	 * If there are pending crypto operation run async
-	 * code. Otherwise process return code synchronously.
-	 * The step of 2 ensures that async finish doesn't
-	 * call crypto finish too early.
-	 */
-	if (atomic_sub_return(2, &ctx->pending))
-		return -EINPROGRESS;
-
-	return r;
+	return 0;
 }
 
 static void dm_crypt_bio_destructor(struct bio *bio)
@@ -698,7 +692,8 @@ static void kcryptd_crypt_write_convert_
 
 		r = crypt_convert(cc, &io->ctx);
 
-		if (r != -EINPROGRESS) {
+		if (atomic_dec_and_test(&io->ctx.pending)) {
+			/* processed, no running async crypto  */
 			kcryptd_crypt_write_io_submit(io, r, 0);
 			if (unlikely(r < 0))
 				return;
@@ -706,8 +701,12 @@ static void kcryptd_crypt_write_convert_
 			atomic_inc(&io->pending);
 
 		/* out of memory -> run queues */
-		if (unlikely(remaining))
+		if (unlikely(remaining)) {
+			/* wait for async crypto and reinitialize pending counter */
+			wait_event(cc->writeq, !atomic_read(&io->ctx.pending));
+			atomic_set(&io->ctx.pending, 1);
 			congestion_wait(WRITE, HZ/100);
+		}
 	}
 }
 
@@ -746,7 +745,7 @@ static void kcryptd_crypt_read_convert(s
 
 	r = crypt_convert(cc, &io->ctx);
 
-	if (r != -EINPROGRESS)
+	if (atomic_dec_and_test(&io->ctx.pending))
 		kcryptd_crypt_read_done(io, r);
 
 	crypt_dec_pending(io);
@@ -771,8 +770,10 @@ static void kcryptd_async_done(struct cr
 
 	if (bio_data_dir(io->base_bio) == READ)
 		kcryptd_crypt_read_done(io, error);
-	else
+	else {
 		kcryptd_crypt_write_io_submit(io, error, 1);
+		wake_up(&cc->writeq);
+	}
 }
 
 static void kcryptd_crypt(struct work_struct *work)
@@ -1047,6 +1048,7 @@ static int crypt_ctr(struct dm_target *t
 		goto bad_crypt_queue;
 	}
 
+	init_waitqueue_head(&cc->writeq);
 	ti->private = cc;
 	return 0;
 
