Return-Path: <linux-kernel-owner+w=401wt.eu-S933583AbXGSVbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583AbXGSVbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763319AbXGSVbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:31:09 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48228 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933226AbXGSVbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:31:07 -0400
Date: Thu, 19 Jul 2007 16:28:48 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tchicks@us.ibm.com,
       trevor.highland@gmail.com, pregan@ic.sunysb.edu, toml@us.ibm.com,
       sergeh@us.ibm.com, mike@halcrow.us
Subject: [PATCH 5/8] eCryptfs: Fix Tag 3 parsing code
Message-ID: <20070719212848.GF13821@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070719212453.GA13821@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719212453.GA13821@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the Tag 3 parsing code to handle size limits and boundaries
more explicitly.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/keystore.c |   89 +++++++++++++++++++-----------------------------
 1 files changed, 35 insertions(+), 54 deletions(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index d84292d..4caa45d 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -643,22 +643,30 @@ parse_tag_3_packet(struct ecryptfs_crypt_stat *crypt_stat,
 
 	(*packet_size) = 0;
 	(*new_auth_tok) = NULL;
-
-	/* we check that:
-	 *   one byte for the Tag 3 ID flag
-	 *   two bytes for the body size
-	 * do not exceed the maximum_packet_size
+	/**
+	 *This format is inspired by OpenPGP; see RFC 2440
+	 * packet tag 3
+	 *
+	 * Tag 3 identifier (1 byte)
+	 * Max Tag 3 packet size (max 3 bytes)
+	 * Version (1 byte)
+	 * Cipher code (1 byte)
+	 * S2K specifier (1 byte)
+	 * Hash identifier (1 byte)
+	 * Salt (ECRYPTFS_SALT_SIZE)
+	 * Hash iterations (1 byte)
+	 * Encrypted key (arbitrary)
+	 *
+	 * (ECRYPTFS_SALT_SIZE + 7) minimum packet size
 	 */
-	if (unlikely((*packet_size) + 3 > max_packet_size)) {
-		ecryptfs_printk(KERN_ERR, "Packet size exceeds max\n");
+	if (max_packet_size < (ECRYPTFS_SALT_SIZE + 7)) {
+		printk(KERN_ERR "Max packet size too large\n");
 		rc = -EINVAL;
 		goto out;
 	}
-
-	/* check for Tag 3 identifyer - one byte */
 	if (data[(*packet_size)++] != ECRYPTFS_TAG_3_PACKET_TYPE) {
-		ecryptfs_printk(KERN_ERR, "Enter w/ first byte != 0x%.2x\n",
-				ECRYPTFS_TAG_3_PACKET_TYPE);
+		printk(KERN_ERR "First byte != 0x%.2x; invalid packet\n",
+		       ECRYPTFS_TAG_3_PACKET_TYPE);
 		rc = -EINVAL;
 		goto out;
 	}
@@ -667,56 +675,36 @@ parse_tag_3_packet(struct ecryptfs_crypt_stat *crypt_stat,
 	auth_tok_list_item =
 	    kmem_cache_zalloc(ecryptfs_auth_tok_list_item_cache, GFP_KERNEL);
 	if (!auth_tok_list_item) {
-		ecryptfs_printk(KERN_ERR, "Unable to allocate memory\n");
+		printk(KERN_ERR "Unable to allocate memory\n");
 		rc = -ENOMEM;
 		goto out;
 	}
 	(*new_auth_tok) = &auth_tok_list_item->auth_tok;
-
-	/* check for body size - one to two bytes */
-	rc = parse_packet_length(&data[(*packet_size)], &body_size,
-				 &length_size);
-	if (rc) {
-		ecryptfs_printk(KERN_WARNING, "Error parsing packet length; "
-				"rc = [%d]\n", rc);
+	if ((rc = parse_packet_length(&data[(*packet_size)], &body_size,
+				      &length_size))) {
+		printk(KERN_WARNING "Error parsing packet length; rc = [%d]\n",
+		       rc);
 		goto out_free;
 	}
-	if (unlikely(body_size < (0x05 + ECRYPTFS_SALT_SIZE))) {
-		ecryptfs_printk(KERN_WARNING, "Invalid body size ([%d])\n",
-				body_size);
+	if (unlikely(body_size < (ECRYPTFS_SALT_SIZE + 5))) {
+		printk(KERN_WARNING "Invalid body size ([%d])\n", body_size);
 		rc = -EINVAL;
 		goto out_free;
 	}
 	(*packet_size) += length_size;
-
-	/* now we know the length of the remainting Tag 3 packet size:
-	 *   5 fix bytes for: version string, cipher, S2K ID, hash algo,
-	 *                    number of hash iterations
-	 *   ECRYPTFS_SALT_SIZE bytes for salt
-	 *   body_size bytes minus the stuff above is the encrypted key size
-	 */
 	if (unlikely((*packet_size) + body_size > max_packet_size)) {
-		ecryptfs_printk(KERN_ERR, "Packet size exceeds max\n");
+		printk(KERN_ERR "Packet size exceeds max\n");
 		rc = -EINVAL;
 		goto out_free;
 	}
-
-	/* There are 5 characters of additional information in the
-	 * packet */
 	(*new_auth_tok)->session_key.encrypted_key_size =
-		body_size - (0x05 + ECRYPTFS_SALT_SIZE);
-	ecryptfs_printk(KERN_DEBUG, "Encrypted key size = [%d]\n",
-			(*new_auth_tok)->session_key.encrypted_key_size);
-
-	/* Version 4 (from RFC2440) - one byte */
+		(body_size - (ECRYPTFS_SALT_SIZE + 5));
 	if (unlikely(data[(*packet_size)++] != 0x04)) {
-		ecryptfs_printk(KERN_DEBUG, "Unknown version number "
-				"[%d]\n", data[(*packet_size) - 1]);
+		printk(KERN_WARNING "Unknown version number [%d]\n",
+		       data[(*packet_size) - 1]);
 		rc = -EINVAL;
 		goto out_free;
 	}
-
-	/* cipher - one byte */
 	ecryptfs_cipher_code_to_string(crypt_stat->cipher,
 				       (u16)data[(*packet_size)]);
 	/* A little extra work to differentiate among the AES key
@@ -730,33 +718,26 @@ parse_tag_3_packet(struct ecryptfs_crypt_stat *crypt_stat,
 			(*new_auth_tok)->session_key.encrypted_key_size;
 	}
 	ecryptfs_init_crypt_ctx(crypt_stat);
-	/* S2K identifier 3 (from RFC2440) */
 	if (unlikely(data[(*packet_size)++] != 0x03)) {
-		ecryptfs_printk(KERN_ERR, "Only S2K ID 3 is currently "
-				"supported\n");
+		printk(KERN_WARNING "Only S2K ID 3 is currently supported\n");
 		rc = -ENOSYS;
 		goto out_free;
 	}
-
 	/* TODO: finish the hash mapping */
-	/* hash algorithm - one byte */
 	switch (data[(*packet_size)++]) {
 	case 0x01: /* See RFC2440 for these numbers and their mappings */
 		/* Choose MD5 */
-		/* salt - ECRYPTFS_SALT_SIZE bytes */
 		memcpy((*new_auth_tok)->token.password.salt,
 		       &data[(*packet_size)], ECRYPTFS_SALT_SIZE);
 		(*packet_size) += ECRYPTFS_SALT_SIZE;
-
 		/* This conversion was taken straight from RFC2440 */
-		/* number of hash iterations - one byte */
 		(*new_auth_tok)->token.password.hash_iterations =
 			((u32) 16 + (data[(*packet_size)] & 15))
 				<< ((data[(*packet_size)] >> 4) + 6);
 		(*packet_size)++;
-
-		/* encrypted session key -
-		 *   (body_size-5-ECRYPTFS_SALT_SIZE) bytes */
+		/* Friendly reminder:
+		 * (*new_auth_tok)->session_key.encrypted_key_size =
+		 *         (body_size - (ECRYPTFS_SALT_SIZE + 5)); */
 		memcpy((*new_auth_tok)->session_key.encrypted_key,
 		       &data[(*packet_size)],
 		       (*new_auth_tok)->session_key.encrypted_key_size);
@@ -766,7 +747,7 @@ parse_tag_3_packet(struct ecryptfs_crypt_stat *crypt_stat,
 			~ECRYPTFS_CONTAINS_DECRYPTED_KEY;
 		(*new_auth_tok)->session_key.flags |=
 			ECRYPTFS_CONTAINS_ENCRYPTED_KEY;
-		(*new_auth_tok)->token.password.hash_algo = 0x01;
+		(*new_auth_tok)->token.password.hash_algo = 0x01; /* MD5 */
 		break;
 	default:
 		ecryptfs_printk(KERN_ERR, "Unsupported hash algorithm: "
-- 
1.4.4.4

