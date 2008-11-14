Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYKNQlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYKNQlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 11:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYKNQlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 11:41:03 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:55321 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYKNQlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 11:41:01 -0500
Date: Fri, 14 Nov 2008 10:40:53 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: pjssilva@ime.usp.br, akpm@linux-foundation.org, dustin.kirkland@gmail.com,
       sandeen@redhat.com
Subject: [PATCH] eCryptfs: Allocate up to two scatterlists for crypto ops
	on keys
Message-ID: <20081114164053.GC6624@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have received some reports of out-of-memory errors on some older AMD
architectures. These errors are what I would expect to see if
crypt_stat->key were split between two separate pages. eCryptfs should
not assume that any of the memory sent through virt_to_scatterlist()
is all contained in a single page, and so this patch allocates two
scatterlist structs instead of one when processing keys. I have
received confirmation from one person affected by this bug that this
patch resolves the issue for him, and so I am submitting it for
inclusion in a future stable release.

Note that virt_to_scatterlist() runs sg_init_table() on the
scatterlist structs passed to it, so the calls to sg_init_table() in
decrypt_passphrase_encrypted_session_key() are redundant.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Reported-by: Paulo J. S. Silva <pjssilva@ime.usp.br>

---
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index e22bc39..0d713b6 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1037,17 +1037,14 @@ static int
 decrypt_passphrase_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 					 struct ecryptfs_crypt_stat *crypt_stat)
 {
-	struct scatterlist dst_sg;
-	struct scatterlist src_sg;
+	struct scatterlist dst_sg[2];
+	struct scatterlist src_sg[2];
 	struct mutex *tfm_mutex;
 	struct blkcipher_desc desc = {
 		.flags = CRYPTO_TFM_REQ_MAY_SLEEP
 	};
 	int rc = 0;
 
-	sg_init_table(&dst_sg, 1);
-	sg_init_table(&src_sg, 1);
-
 	if (unlikely(ecryptfs_verbosity > 0)) {
 		ecryptfs_printk(
 			KERN_DEBUG, "Session key encryption key (size [%d]):\n",
@@ -1066,8 +1063,8 @@ decrypt_passphrase_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 	}
 	rc = virt_to_scatterlist(auth_tok->session_key.encrypted_key,
 				 auth_tok->session_key.encrypted_key_size,
-				 &src_sg, 1);
-	if (rc != 1) {
+				 src_sg, 2);
+	if (rc < 1 || rc > 2) {
 		printk(KERN_ERR "Internal error whilst attempting to convert "
 			"auth_tok->session_key.encrypted_key to scatterlist; "
 			"expected rc = 1; got rc = [%d]. "
@@ -1079,8 +1076,8 @@ decrypt_passphrase_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 		auth_tok->session_key.encrypted_key_size;
 	rc = virt_to_scatterlist(auth_tok->session_key.decrypted_key,
 				 auth_tok->session_key.decrypted_key_size,
-				 &dst_sg, 1);
-	if (rc != 1) {
+				 dst_sg, 2);
+	if (rc < 1 || rc > 2) {
 		printk(KERN_ERR "Internal error whilst attempting to convert "
 			"auth_tok->session_key.decrypted_key to scatterlist; "
 			"expected rc = 1; got rc = [%d]\n", rc);
@@ -1096,7 +1093,7 @@ decrypt_passphrase_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 		rc = -EINVAL;
 		goto out;
 	}
-	rc = crypto_blkcipher_decrypt(&desc, &dst_sg, &src_sg,
+	rc = crypto_blkcipher_decrypt(&desc, dst_sg, src_sg,
 				      auth_tok->session_key.encrypted_key_size);
 	mutex_unlock(tfm_mutex);
 	if (unlikely(rc)) {
@@ -1539,8 +1536,8 @@ write_tag_3_packet(char *dest, size_t *remaining_bytes,
 	size_t i;
 	size_t encrypted_session_key_valid = 0;
 	char session_key_encryption_key[ECRYPTFS_MAX_KEY_BYTES];
-	struct scatterlist dst_sg;
-	struct scatterlist src_sg;
+	struct scatterlist dst_sg[2];
+	struct scatterlist src_sg[2];
 	struct mutex *tfm_mutex = NULL;
 	u8 cipher_code;
 	size_t packet_size_length;
@@ -1619,8 +1616,8 @@ write_tag_3_packet(char *dest, size_t *remaining_bytes,
 		ecryptfs_dump_hex(session_key_encryption_key, 16);
 	}
 	rc = virt_to_scatterlist(crypt_stat->key, key_rec->enc_key_size,
-				 &src_sg, 1);
-	if (rc != 1) {
+				 src_sg, 2);
+	if (rc < 1 || rc > 2) {
 		ecryptfs_printk(KERN_ERR, "Error generating scatterlist "
 				"for crypt_stat session key; expected rc = 1; "
 				"got rc = [%d]. key_rec->enc_key_size = [%d]\n",
@@ -1629,8 +1626,8 @@ write_tag_3_packet(char *dest, size_t *remaining_bytes,
 		goto out;
 	}
 	rc = virt_to_scatterlist(key_rec->enc_key, key_rec->enc_key_size,
-				 &dst_sg, 1);
-	if (rc != 1) {
+				 dst_sg, 2);
+	if (rc < 1 || rc > 2) {
 		ecryptfs_printk(KERN_ERR, "Error generating scatterlist "
 				"for crypt_stat encrypted session key; "
 				"expected rc = 1; got rc = [%d]. "
@@ -1651,7 +1648,7 @@ write_tag_3_packet(char *dest, size_t *remaining_bytes,
 	rc = 0;
 	ecryptfs_printk(KERN_DEBUG, "Encrypting [%d] bytes of the key\n",
 			crypt_stat->key_size);
-	rc = crypto_blkcipher_encrypt(&desc, &dst_sg, &src_sg,
+	rc = crypto_blkcipher_encrypt(&desc, dst_sg, src_sg,
 				      (*key_rec).enc_key_size);
 	mutex_unlock(tfm_mutex);
 	if (rc) {
