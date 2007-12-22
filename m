Return-Path: <linux-kernel-owner+w=401wt.eu-S1751631AbXLVCFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbXLVCFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 21:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXLVCFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 21:05:22 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:13510 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbXLVCFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:05:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding:from;
        b=GhaHqGQxdtFu2Pj1nzmHVWE3I9O0K175bP4kCbOAClrkTvoWd/0h2Q17Bw1OohhMl02cUNBjNuUB/5U7KJM+pQYb1HByU4H8H27SylO+ERxs8qlsdEzzygbaFT3uVoJVsggWmm9mwy2aIJcwJD8YAJM7RG7mwoUDf29h+wdZjV8=
Subject: [PATCH] eCryptfs: Load each file decryption key only once
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net, mhalcrow@us.ibm.com
Content-Type: text/plain
Date: Fri, 21 Dec 2007 20:05:30 -0600
Message-Id: <1198289130.8560.14.camel@buster2>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
From: Trevor Highland <thighlan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eCryptfs: Load each file decryption key only once

There is no need to keep re-setting the same key for any given
eCryptfs inode. This patch optimizes the use of the crypto API and
helps performance a bit.

Signed-off-by: Trevor Highland <trevor.highland@gmail.com>
---
 fs/ecryptfs/crypto.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 70f7aab..949fe44 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -353,7 +353,6 @@ static int encrypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 		ecryptfs_dump_hex(crypt_stat->key,
 				  crypt_stat->key_size);
 	}
-	/* Consider doing this once, when the file is opened */
 	mutex_lock(&crypt_stat->cs_tfm_mutex);
 	if (!(crypt_stat->flags & ECRYPTFS_KEY_SET)) {
 		rc = crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
@@ -687,10 +686,12 @@ static int decrypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 	};
 	int rc = 0;
 
-	/* Consider doing this once, when the file is opened */
 	mutex_lock(&crypt_stat->cs_tfm_mutex);
-	rc = crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
-				     crypt_stat->key_size);
+	if (!(crypt_stat->flags & ECRYPTFS_KEY_SET)) {
+		rc = crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
+					     crypt_stat->key_size);
+		crypt_stat->flags |= ECRYPTFS_KEY_SET;
+	}
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error setting key; rc = [%d]\n",
 				rc);
-- 
1.5.2.5


