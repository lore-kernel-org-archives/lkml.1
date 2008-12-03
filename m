Return-Path: <linux-kernel-owner+w=401wt.eu-S1751037AbYLCTxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037AbYLCTxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:53:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYLCTuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:17 -0500
Received: from kroah.org ([198.145.64.141]:34564 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754501AbYLCTuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:10 -0500
Date: Wed, 3 Dec 2008 11:48:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Michael Halcrow <mhalcrow@us.ibm.com>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       Tim Gardner <tim.gardner@canonical.com>
Subject: [patch 009/104] eCryptfs: Allocate up to two scatterlists for
	crypto ops on keys
Message-ID: <20081203194833.GJ8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ecryptfs-allocate-up-to-two-scatterlists-for-crypto-ops-on-keys.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Halcrow <mhalcrow@us.ibm.com>

commit ac97b9f9a2d0b83488e0bbcb8517b229d5c9b142 upstream.

I have received some reports of out-of-memory errors on some older AMD
architectures.  These errors are what I would expect to see if
crypt_stat->key were split between two separate pages.  eCryptfs should
not assume that any of the memory sent through virt_to_scatterlist() is
all contained in a single page, and so this patch allocates two
scatterlist structs instead of one when processing keys.  I have received
confirmation from one person affected by this bug that this patch resolves
the issue for him, and so I am submitting it for inclusion in a future
stable release.

Note that virt_to_scatterlist() runs sg_init_table() on the scatterlist
structs passed to it, so the calls to sg_init_table() in
decrypt_passphrase_encrypted_session_key() are redundant.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
Reported-by: Paulo J. S. Silva <pjssilva@ime.usp.br>
Cc: "Leon Woestenberg" <leon.woestenberg@gmail.com>
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/keystore.c |   31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

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
@@ -1066,8 +1063,8 @@ decrypt_passphrase_encrypted_session_key
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
@@ -1079,8 +1076,8 @@ decrypt_passphrase_encrypted_session_key
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
@@ -1096,7 +1093,7 @@ decrypt_passphrase_encrypted_session_key
 		rc = -EINVAL;
 		goto out;
 	}
-	rc = crypto_blkcipher_decrypt(&desc, &dst_sg, &src_sg,
+	rc = crypto_blkcipher_decrypt(&desc, dst_sg, src_sg,
 				      auth_tok->session_key.encrypted_key_size);
 	mutex_unlock(tfm_mutex);
 	if (unlikely(rc)) {
@@ -1541,8 +1538,8 @@ write_tag_3_packet(char *dest, size_t *r
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
@@ -1621,8 +1618,8 @@ write_tag_3_packet(char *dest, size_t *r
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
@@ -1631,8 +1628,8 @@ write_tag_3_packet(char *dest, size_t *r
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
@@ -1653,7 +1650,7 @@ write_tag_3_packet(char *dest, size_t *r
 	rc = 0;
 	ecryptfs_printk(KERN_DEBUG, "Encrypting [%d] bytes of the key\n",
 			crypt_stat->key_size);
-	rc = crypto_blkcipher_encrypt(&desc, &dst_sg, &src_sg,
+	rc = crypto_blkcipher_encrypt(&desc, dst_sg, src_sg,
 				      (*key_rec).enc_key_size);
 	mutex_unlock(tfm_mutex);
 	if (rc) {

