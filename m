Return-Path: <linux-kernel-owner+w=401wt.eu-S936457AbZLQEWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936457AbZLQEWn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935775AbZLQEWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:22:06 -0500
Received: from kroah.org ([198.145.64.141]:55825 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935960AbZLQEFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:07 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:56 2009
Message-Id: <20091217035656.608211741@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [105/151] dm crypt: separate essiv allocation from initialisation
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Milan Broz <mbroz@redhat.com>

commit b95bf2d3d5a48b095bffe2a0cd8c40453cf59557 upstream.

This patch separates the construction of IV from its initialisation.
(For ESSIV it is a hash calculation based on volume key.)

Constructor code now preallocates hash tfm and salt array
and saves it in a private IV structure.

The next patch requires this to reinitialise the wiped IV
without reallocating memory when resuming a suspended device.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-crypt.c |   69 +++++++++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 26 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -71,11 +71,14 @@ struct crypt_iv_operations {
 	int (*ctr)(struct crypt_config *cc, struct dm_target *ti,
 		   const char *opts);
 	void (*dtr)(struct crypt_config *cc);
+	int (*init)(struct crypt_config *cc);
 	int (*generator)(struct crypt_config *cc, u8 *iv, sector_t sector);
 };
 
 struct iv_essiv_private {
 	struct crypto_cipher *tfm;
+	struct crypto_hash *hash_tfm;
+	u8 *salt;
 };
 
 struct iv_benbi_private {
@@ -176,12 +179,38 @@ static int crypt_iv_plain_gen(struct cry
 	return 0;
 }
 
+/* Initialise ESSIV - compute salt but no local memory allocations */
+static int crypt_iv_essiv_init(struct crypt_config *cc)
+{
+	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
+	struct hash_desc desc;
+	struct scatterlist sg;
+	int err;
+
+	sg_init_one(&sg, cc->key, cc->key_size);
+	desc.tfm = essiv->hash_tfm;
+	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	err = crypto_hash_digest(&desc, &sg, cc->key_size, essiv->salt);
+	if (err)
+		return err;
+
+	return crypto_cipher_setkey(essiv->tfm, essiv->salt,
+				    crypto_hash_digestsize(essiv->hash_tfm));
+}
+
 static void crypt_iv_essiv_dtr(struct crypt_config *cc)
 {
 	struct iv_essiv_private *essiv = &cc->iv_gen_private.essiv;
 
 	crypto_free_cipher(essiv->tfm);
 	essiv->tfm = NULL;
+
+	crypto_free_hash(essiv->hash_tfm);
+	essiv->hash_tfm = NULL;
+
+	kzfree(essiv->salt);
+	essiv->salt = NULL;
 }
 
 static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
@@ -189,9 +218,6 @@ static int crypt_iv_essiv_ctr(struct cry
 {
 	struct crypto_cipher *essiv_tfm = NULL;
 	struct crypto_hash *hash_tfm = NULL;
-	struct hash_desc desc;
-	struct scatterlist sg;
-	unsigned int saltsize;
 	u8 *salt = NULL;
 	int err;
 
@@ -200,7 +226,7 @@ static int crypt_iv_essiv_ctr(struct cry
 		return -EINVAL;
 	}
 
-	/* Hash the cipher key with the given hash algorithm */
+	/* Allocate hash algorithm */
 	hash_tfm = crypto_alloc_hash(opts, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(hash_tfm)) {
 		ti->error = "Error initializing ESSIV hash";
@@ -208,27 +234,14 @@ static int crypt_iv_essiv_ctr(struct cry
 		goto bad;
 	}
 
-	saltsize = crypto_hash_digestsize(hash_tfm);
-	salt = kzalloc(saltsize, GFP_KERNEL);
+	salt = kzalloc(crypto_hash_digestsize(hash_tfm), GFP_KERNEL);
 	if (!salt) {
 		ti->error = "Error kmallocing salt storage in ESSIV";
 		err = -ENOMEM;
 		goto bad;
 	}
 
-	sg_init_one(&sg, cc->key, cc->key_size);
-	desc.tfm = hash_tfm;
-	desc.flags = CRYPTO_TFM_REQ_MAY_SLEEP;
-	err = crypto_hash_digest(&desc, &sg, cc->key_size, salt);
-	crypto_free_hash(hash_tfm);
-	hash_tfm = NULL;
-
-	if (err) {
-		ti->error = "Error calculating hash in ESSIV";
-		goto bad;
-	}
-
-	/* Setup the essiv_tfm with the given salt */
+	/* Allocate essiv_tfm */
 	essiv_tfm = crypto_alloc_cipher(cc->cipher, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(essiv_tfm)) {
 		ti->error = "Error allocating crypto tfm for ESSIV";
@@ -242,14 +255,11 @@ static int crypt_iv_essiv_ctr(struct cry
 		err = -EINVAL;
 		goto bad;
 	}
-	err = crypto_cipher_setkey(essiv_tfm, salt, saltsize);
-	if (err) {
-		ti->error = "Failed to set key for ESSIV cipher";
-		goto bad;
-	}
-	kzfree(salt);
 
+	cc->iv_gen_private.essiv.salt = salt;
 	cc->iv_gen_private.essiv.tfm = essiv_tfm;
+	cc->iv_gen_private.essiv.hash_tfm = hash_tfm;
+
 	return 0;
 
 bad:
@@ -257,7 +267,7 @@ bad:
 		crypto_free_cipher(essiv_tfm);
 	if (hash_tfm && !IS_ERR(hash_tfm))
 		crypto_free_hash(hash_tfm);
-	kzfree(salt);
+	kfree(salt);
 	return err;
 }
 
@@ -323,6 +333,7 @@ static struct crypt_iv_operations crypt_
 static struct crypt_iv_operations crypt_iv_essiv_ops = {
 	.ctr       = crypt_iv_essiv_ctr,
 	.dtr       = crypt_iv_essiv_dtr,
+	.init      = crypt_iv_essiv_init,
 	.generator = crypt_iv_essiv_gen
 };
 
@@ -1054,6 +1065,12 @@ static int crypt_ctr(struct dm_target *t
 	    cc->iv_gen_ops->ctr(cc, ti, ivopts) < 0)
 		goto bad_ivmode;
 
+	if (cc->iv_gen_ops && cc->iv_gen_ops->init &&
+	    cc->iv_gen_ops->init(cc) < 0) {
+		ti->error = "Error initialising IV";
+		goto bad_slab_pool;
+	}
+
 	cc->iv_size = crypto_ablkcipher_ivsize(tfm);
 	if (cc->iv_size)
 		/* at least a 64 bit sector number should fit in our buffer */


