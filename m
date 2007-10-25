Return-Path: <linux-kernel-owner+w=401wt.eu-S1762404AbXJYUIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762404AbXJYUIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761940AbXJYUHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:07:23 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:59240 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759612AbXJYUHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:07:20 -0400
Message-ID: <4720F775.8030702@hp.com>
Date: Thu, 25 Oct 2007 16:07:17 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, jens.axboe@oracle.com
Subject: [PATCH] [CRYPTO]: Fix hmac_digest from the SG breakage.
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Crypto now uses SG helper functions.  Fix hmac_digest to use those
functions correctly and fix the oops associated with it.

Signed-off-by: Vlad Yasevich <vladislav.yasevich@hp.com>
---
 crypto/hmac.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/hmac.c b/crypto/hmac.c
index e4eb6ac..8b7a832 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -158,10 +158,12 @@ static int hmac_digest(struct hash_desc *pdesc, struct scatterlist *sg,
 	desc.tfm = ctx->child;
 	desc.flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
+	sg_init_table(sg1, 2);
 	sg_set_buf(sg1, ipad, bs);
-
-	sg_set_page(&sg[1], (void *) sg);
+	sg_set_page(&sg1[1], (void *) sg);
 	sg1[1].length = 0;
+
+	sg_init_table(sg2, 1);
 	sg_set_buf(sg2, opad, bs + ds);
 
 	err = crypto_hash_digest(&desc, sg1, nbytes + bs, digest);
-- 
1.5.2.4

