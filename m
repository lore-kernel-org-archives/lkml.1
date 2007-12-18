Return-Path: <linux-kernel-owner+w=401wt.eu-S1765580AbXLRGLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765580AbXLRGLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 01:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbXLRGLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 01:11:36 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:60723 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbXLRGLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 01:11:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:to:content-type:date:message-id:mime-version:x-mailer:from;
        b=cJ5kF5BgCChNVaLelF8pcHSVHgPFUOzrjpieN0ZsX1megaISuXEqekZfWPD6lmufM9+m+UbqBUTUpPrjQJwMdTUhm6/9KijxyOrxoPH5VvcixFcyV7zqBJhWxxnMqSofe58JqEGoNUPXpzp4GeeAsQ6Qs1rZzVAbxXy7oeLHbdU=
Subject: [PATCH] eCryptfs: Load each file decryption key only once
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net, mhalcrow@us.ibm.com
Content-Type: multipart/mixed; boundary="=-yXFusFlUp6OHBFiBhGLU"
Date: Tue, 18 Dec 2007 00:11:37 -0600
Message-Id: <1197958297.10903.10.camel@buster2>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
From: Trevor Highland <thighlan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yXFusFlUp6OHBFiBhGLU
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

There is no need to set the decryption key every time eCryptfs decrypts
an extent.

Trevor

--=-yXFusFlUp6OHBFiBhGLU
Content-Disposition: attachment; filename=0001-eCryptfs-Load-each-file-decryption-key-only-once.patch
Content-Type: application/mbox; name=0001-eCryptfs-Load-each-file-decryption-key-only-once.patch
Content-Transfer-Encoding: 7bit

>From e09d7a07ef3d34762cc1f850cf255961f74712d6 Mon Sep 17 00:00:00 2001
From: Trevor Highland <trevor.highland@gmail.com>
Date: Thu, 13 Dec 2007 00:31:11 -0600
Subject: [PATCH] [PATCH] eCryptfs: Load each file decryption key only once

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


--=-yXFusFlUp6OHBFiBhGLU--

