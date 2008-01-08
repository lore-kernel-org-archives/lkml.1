Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbYAHVWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbYAHVWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbYAHVSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:18:05 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:58896 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688AbYAHVSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:18:01 -0500
Date: Tue, 8 Jan 2008 15:17:33 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.sourceforge.net,
       Trevor Highland <thighlan@gmail.com>
Subject: Re: [PATCH] eCryptfs: Load each file decryption key only once
Message-ID: <20080108211733.GD10989@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <1198289130.8560.14.camel@buster2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198289130.8560.14.camel@buster2>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2007 at 08:05:30PM -0600, Trevor Highland wrote:
> eCryptfs: Load each file decryption key only once
> 
> There is no need to keep re-setting the same key for any given
> eCryptfs inode. This patch optimizes the use of the crypto API and
> helps performance a bit.

There is no reason for the crypt_stat->key value for any given
eCryptfs inode to change during the life of the inode, and each
crypt_stat gets its own crypto transform, so I do not see a problem
with Trevor's suggestion. It will save unnecessary calls to
crypto_blkcipher_setkey(), and I expect it will speed things up a
little.

I include an updated patch against 2.6.24-rc7.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c          |   40 ++++++++++++++++++++++------------------
 fs/ecryptfs/ecryptfs_kernel.h |    1 +
 2 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index f8ef0af..40849cf 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -353,16 +353,18 @@ static int encrypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 		ecryptfs_dump_hex(crypt_stat->key,
 				  crypt_stat->key_size);
 	}
-	/* Consider doing this once, when the file is opened */
 	mutex_lock(&crypt_stat->cs_tfm_mutex);
-	rc = crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
-				     crypt_stat->key_size);
-	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error setting key; rc = [%d]\n",
-				rc);
-		mutex_unlock(&crypt_stat->cs_tfm_mutex);
-		rc = -EINVAL;
-		goto out;
+	if (!(crypt_stat->flags & ECRYPTFS_TFM_KEY_SET)) {
+		rc = crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
+					     crypt_stat->key_size);
+		if (rc) {
+			printk(KERN_ERR "%s: Error setting key; rc = [%d]\n",
+			       __FUNCTION__, rc);
+			mutex_unlock(&crypt_stat->cs_tfm_mutex);
+			rc = -EINVAL;
+			goto out;
+		}
+		crypt_stat->flags |= ECRYPTFS_TFM_KEY_SET;
 	}
 	ecryptfs_printk(KERN_DEBUG, "Encrypting [%d] bytes.\n", size);
 	crypto_blkcipher_encrypt_iv(&desc, dest_sg, src_sg, size);
@@ -685,16 +687,18 @@ static int decrypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 	};
 	int rc = 0;
 
-	/* Consider doing this once, when the file is opened */
 	mutex_lock(&crypt_stat->cs_tfm_mutex);
-	rc = crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
-				     crypt_stat->key_size);
-	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error setting key; rc = [%d]\n",
-				rc);
-		mutex_unlock(&crypt_stat->cs_tfm_mutex);
-		rc = -EINVAL;
-		goto out;
+	if (!(crypt_stat->flags & ECRYPTFS_TFM_KEY_SET)) {
+		rc = crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
+					     crypt_stat->key_size);
+		if (rc) {
+			printk(KERN_ERR "%s: Error setting key; rc = [%d]\n",
+			       __FUNCTION__, rc);
+			mutex_unlock(&crypt_stat->cs_tfm_mutex);
+			rc = -EINVAL;
+			goto out;
+		}
+		crypt_stat->flags |= ECRYPTFS_TFM_KEY_SET;
 	}
 	ecryptfs_printk(KERN_DEBUG, "Decrypting [%d] bytes.\n", size);
 	rc = crypto_blkcipher_decrypt_iv(&desc, dest_sg, src_sg, size);
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index ce7a5d4..2abb110 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -234,6 +234,7 @@ struct ecryptfs_crypt_stat {
 #define ECRYPTFS_KEY_VALID          0x00000080
 #define ECRYPTFS_METADATA_IN_XATTR  0x00000100
 #define ECRYPTFS_VIEW_AS_ENCRYPTED  0x00000200
+#define ECRYPTFS_TFM_KEY_SET        0x00000400
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
-- 
1.5.0.6



> Signed-off-by: Trevor Highland <trevor.highland@gmail.com>
> ---
>  fs/ecryptfs/crypto.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> index 70f7aab..949fe44 100644
> --- a/fs/ecryptfs/crypto.c
> +++ b/fs/ecryptfs/crypto.c
> @@ -353,7 +353,6 @@ static int encrypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
>  		ecryptfs_dump_hex(crypt_stat->key,
>  				  crypt_stat->key_size);
>  	}
> -	/* Consider doing this once, when the file is opened */
>  	mutex_lock(&crypt_stat->cs_tfm_mutex);
>  	if (!(crypt_stat->flags & ECRYPTFS_KEY_SET)) {
>  		rc = crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
> @@ -687,10 +686,12 @@ static int decrypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
>  	};
>  	int rc = 0;
> 
> -	/* Consider doing this once, when the file is opened */
>  	mutex_lock(&crypt_stat->cs_tfm_mutex);
> -	rc = crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
> -				     crypt_stat->key_size);
> +	if (!(crypt_stat->flags & ECRYPTFS_KEY_SET)) {
> +		rc = crypto_blkcipher_setkey(crypt_stat->tfm, crypt_stat->key,
> +					     crypt_stat->key_size);
> +		crypt_stat->flags |= ECRYPTFS_KEY_SET;
> +	}
>  	if (rc) {
>  		ecryptfs_printk(KERN_ERR, "Error setting key; rc = [%d]\n",
>  				rc);
