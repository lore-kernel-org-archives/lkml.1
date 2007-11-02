Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbXKBSzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbXKBSzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 14:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbXKBSzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 14:55:45 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50592 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757528AbXKBSzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 14:55:44 -0400
Date: Fri, 2 Nov 2007 13:53:08 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.sourceforge.net,
       trevor.highland@gmail.com
Subject: [PATCH 3/3] eCryptfs: Set inode key only once per crypto operation
Message-ID: <20071102185308.GC30760@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20071102185033.GB30487@localhost.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102185033.GB30487@localhost.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to keep re-setting the same key for any given
eCryptfs inode. This patch optimizes the use of the crypto API and
helps performance a bit.

Signed-off-by: Trevor Highland <trevor.highland@gmail.com>
Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c          |    7 +++++--
 fs/ecryptfs/ecryptfs_kernel.h |    1 +
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 4f14d4c..a0f53aa 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -337,8 +337,11 @@ static int encrypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 	}
 	/* Consider doing this once, when the file is opened */
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
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 78b7916..114cb86 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -234,6 +234,7 @@ struct ecryptfs_crypt_stat {
 #define ECRYPTFS_KEY_VALID          0x00000080
 #define ECRYPTFS_METADATA_IN_XATTR  0x00000100
 #define ECRYPTFS_VIEW_AS_ENCRYPTED  0x00000200
+#define ECRYPTFS_KEY_SET            0x00000400
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
-- 
1.5.0.6

