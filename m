Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbYCNJTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbYCNJTw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 05:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYCNJTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 05:19:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbYCNJTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 05:19:44 -0400
Message-ID: <47DA431C.3010502@redhat.com>
Date: Fri, 14 Mar 2008 10:19:24 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: dm-crypt@saout.de
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-crypt] Kernel 2.6.25-rc4: lock up when writing onto DM-Crypt
 volume
References: <47D075FD.9040200@datenparkplatz.de>
In-Reply-To: <47D075FD.9040200@datenparkplatz.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Lukas wrote:

> I observed a reproducible bug after switching from Linux 2.6.24 to the
> latest 2.6.25-rc4 kernel. On Linux 2.6.24 I had no such problem.
>
> When writing to a slightly bigger DM-Crypt-LUKS volume, I experience
> lock-ups in the form of stuck, non-terminating, non-"kill -9"-able
> processes
Please could you try patch below?
Milan

--
dm-crypt: Fix reference counting in crypto context.

Fix regression in dm-crypt introduced in commit
3a7f6c990ad04e6f576a159876c602d14d6f7fef
(dm crypt: use async crypto).

If the write request is splitted, ctx->context
is not properly initialized again and crypt_convert
return incorrectly processed return value like
asynchronous request.

Fix by moving pending counter manipulation
directly to crypt_convert call.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-crypt.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b04f98d..47bbb03 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -331,14 +331,7 @@ static void crypt_convert_init(struct crypt_config *cc,
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
+	atomic_set(&ctx->pending, 0);
 }
 
 static int crypt_convert_block(struct crypt_config *cc,
@@ -413,6 +406,15 @@ static int crypt_convert(struct crypt_config *cc,
 {
 	int r = 0;
 
+	/*
+	 * Crypto operation can be asynchronous,
+	 * ctx->pending is increased after request submission.
+	 * We need to ensure that we don't call the crypt finish
+	 * operation before pending got incremented
+	 * (dependent on crypt submission return code).
+	 */
+	atomic_add(2, &ctx->pending);
+
 	while(ctx->idx_in < ctx->bio_in->bi_vcnt &&
 	      ctx->idx_out < ctx->bio_out->bi_vcnt) {
 


