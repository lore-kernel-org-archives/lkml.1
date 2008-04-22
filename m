Return-Path: <linux-kernel-owner+w=401wt.eu-S933381AbYDVNyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbYDVNyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760785AbYDVNx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:53:57 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:38845 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756564AbYDVNx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:53:56 -0400
Date: Tue, 22 Apr 2008 22:53:55 +0900 (JST)
Message-Id: <20080422.225355.07850141.taka@valinux.co.jp>
To: jens.axboe@oracle.com, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 3/10] I/O context inheritance
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080422.224935.00673711.taka@valinux.co.jp>
References: <20080422.224935.00673711.taka@valinux.co.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make every bio points the iocontext of the process which originally
generated an I/O request. (part 2)

 - Assign the iocontext which the source bio has to a bio when it is
   allocated as a bounce buffer.
 - Assign the iocontext which the source bio has to bios when the source
   bio is split into several ones, which some device mapper modules require.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/mm/bounce.c	2008-04-22 15:48:32.000000000 +0900
+++ linux-2.6.25/mm/bounce.c	2008-04-22 15:51:33.000000000 +0900
@@ -195,8 +195,11 @@ static void __blk_queue_bounce(struct re
 		/*
 		 * irk, bounce it
 		 */
-		if (!bio)
+		if (!bio) {
 			bio = bio_alloc(GFP_NOIO, (*bio_orig)->bi_vcnt);
+			put_io_context(bio->bi_io_context);
+			bio->bi_io_context = ioc_object_link((*bio_orig)->bi_io_context);
+		}
 
 		to = bio->bi_io_vec + i;
 
--- linux-2.6.25.bio0/drivers/md/dm.c	2008-04-22 15:48:33.000000000 +0900
+++ linux-2.6.25/drivers/md/dm.c	2008-04-22 17:16:49.000000000 +0900
@@ -665,6 +665,7 @@ static struct bio *split_bvec(struct bio
 	clone->bi_size = to_bytes(len);
 	clone->bi_io_vec->bv_offset = offset;
 	clone->bi_io_vec->bv_len = clone->bi_size;
+	clone->bi_io_context = ioc_object_link(bio->bi_io_context);
 
 	return clone;
 }
