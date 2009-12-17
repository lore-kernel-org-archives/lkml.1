Return-Path: <linux-kernel-owner+w=401wt.eu-S935802AbZLQEYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935802AbZLQEYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935960AbZLQEXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:23:34 -0500
Received: from kroah.org ([198.145.64.141]:55803 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935803AbZLQEFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:03 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:56 2009
Message-Id: <20091217035656.222799487@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [102/151] dm crypt: restructure essiv error path
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Milan Broz <mbroz@redhat.com>

commit 5861f1be00b3b70f8ab5e5a81392a6cf69666cd2 upstream.

Use kzfree for salt deallocation because it is derived from the volume
key.  Use a common error path in ESSIV constructor.

Required by a later patch which fixes the way key material is wiped
from memory.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-crypt.c |   46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -187,15 +187,15 @@ static void crypt_iv_essiv_dtr(struct cr
 static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 			      const char *opts)
 {
-	struct crypto_cipher *essiv_tfm;
-	struct crypto_hash *hash_tfm;
+	struct crypto_cipher *essiv_tfm = NULL;
+	struct crypto_hash *hash_tfm = NULL;
 	struct hash_desc desc;
 	struct scatterlist sg;
 	unsigned int saltsize;
-	u8 *salt;
+	u8 *salt = NULL;
 	int err;
 
-	if (opts == NULL) {
+	if (!opts) {
 		ti->error = "Digest algorithm missing for ESSIV mode";
 		return -EINVAL;
 	}
@@ -204,15 +204,16 @@ static int crypt_iv_essiv_ctr(struct cry
 	hash_tfm = crypto_alloc_hash(opts, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(hash_tfm)) {
 		ti->error = "Error initializing ESSIV hash";
-		return PTR_ERR(hash_tfm);
+		err = PTR_ERR(hash_tfm);
+		goto bad;
 	}
 
 	saltsize = crypto_hash_digestsize(hash_tfm);
-	salt = kmalloc(saltsize, GFP_KERNEL);
-	if (salt == NULL) {
+	salt = kzalloc(saltsize, GFP_KERNEL);
+	if (!salt) {
 		ti->error = "Error kmallocing salt storage in ESSIV";
-		crypto_free_hash(hash_tfm);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto bad;
 	}
 
 	sg_init_one(&sg, cc->key, cc->key_size);
@@ -220,39 +221,44 @@ static int crypt_iv_essiv_ctr(struct cry
 	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
 	err = crypto_hash_digest(&desc, &sg, cc->key_size, salt);
 	crypto_free_hash(hash_tfm);
+	hash_tfm = NULL;
 
 	if (err) {
 		ti->error = "Error calculating hash in ESSIV";
-		kfree(salt);
-		return err;
+		goto bad;
 	}
 
 	/* Setup the essiv_tfm with the given salt */
 	essiv_tfm = crypto_alloc_cipher(cc->cipher, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(essiv_tfm)) {
 		ti->error = "Error allocating crypto tfm for ESSIV";
-		kfree(salt);
-		return PTR_ERR(essiv_tfm);
+		err = PTR_ERR(essiv_tfm);
+		goto bad;
 	}
 	if (crypto_cipher_blocksize(essiv_tfm) !=
 	    crypto_ablkcipher_ivsize(cc->tfm)) {
 		ti->error = "Block size of ESSIV cipher does "
 			    "not match IV size of block cipher";
-		crypto_free_cipher(essiv_tfm);
-		kfree(salt);
-		return -EINVAL;
+		err = -EINVAL;
+		goto bad;
 	}
 	err = crypto_cipher_setkey(essiv_tfm, salt, saltsize);
 	if (err) {
 		ti->error = "Failed to set key for ESSIV cipher";
-		crypto_free_cipher(essiv_tfm);
-		kfree(salt);
-		return err;
+		goto bad;
 	}
-	kfree(salt);
+	kzfree(salt);
 
 	cc->iv_gen_private.essiv.tfm = essiv_tfm;
 	return 0;
+
+bad:
+	if (essiv_tfm && !IS_ERR(essiv_tfm))
+		crypto_free_cipher(essiv_tfm);
+	if (hash_tfm && !IS_ERR(hash_tfm))
+		crypto_free_hash(hash_tfm);
+	kzfree(salt);
+	return err;
 }
 
 static int crypt_iv_essiv_gen(struct crypt_config *cc, u8 *iv, sector_t sector)


