Return-Path: <linux-kernel-owner+w=401wt.eu-S932862AbXGSVab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbXGSVab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbXGSVaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:30:19 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39550 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbXGSVaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:30:17 -0400
Date: Thu, 19 Jul 2007 16:28:01 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tchicks@us.ibm.com,
       trevor.highland@gmail.com, pregan@ic.sunysb.edu, toml@us.ibm.com,
       sergeh@us.ibm.com, mike@halcrow.us
Subject: [PATCH 4/8] eCryptfs: Fix Tag 1 parsing code
Message-ID: <20070719212801.GE13821@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070719212453.GA13821@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719212453.GA13821@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the Tag 1 parsing code to handle size limits and boundaries
more explicitly. Initialize the new auth_tok's flags.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/keystore.c |   78 ++++++++++++++++++++---------------------------
 1 files changed, 33 insertions(+), 45 deletions(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 590f29c..d84292d 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -512,72 +512,64 @@ parse_tag_1_packet(struct ecryptfs_crypt_stat *crypt_stat,
 
 	(*packet_size) = 0;
 	(*new_auth_tok) = NULL;
-
-	/* we check that:
-	 *   one byte for the Tag 1 ID flag
-	 *   two bytes for the body size
-	 * do not exceed the maximum_packet_size
+	/**
+	 * This format is inspired by OpenPGP; see RFC 2440
+	 * packet tag 1
+	 *
+	 * Tag 1 identifier (1 byte)
+	 * Max Tag 1 packet size (max 3 bytes)
+	 * Version (1 byte)
+	 * Key identifier (8 bytes; ECRYPTFS_SIG_SIZE)
+	 * Cipher identifier (1 byte)
+	 * Encrypted key size (arbitrary)
+	 *
+	 * 12 bytes minimum packet size
 	 */
-	if (unlikely((*packet_size) + 3 > max_packet_size)) {
-		ecryptfs_printk(KERN_ERR, "Packet size exceeds max\n");
+	if (unlikely(max_packet_size < 12)) {
+		printk(KERN_ERR "Invalid max packet size; must be >=12\n");
 		rc = -EINVAL;
 		goto out;
 	}
-	/* check for Tag 1 identifier - one byte */
 	if (data[(*packet_size)++] != ECRYPTFS_TAG_1_PACKET_TYPE) {
-		ecryptfs_printk(KERN_ERR, "Enter w/ first byte != 0x%.2x\n",
-				ECRYPTFS_TAG_1_PACKET_TYPE);
+		printk(KERN_ERR "Enter w/ first byte != 0x%.2x\n",
+		       ECRYPTFS_TAG_1_PACKET_TYPE);
 		rc = -EINVAL;
 		goto out;
 	}
 	/* Released: wipe_auth_tok_list called in ecryptfs_parse_packet_set or
 	 * at end of function upon failure */
 	auth_tok_list_item =
-		kmem_cache_alloc(ecryptfs_auth_tok_list_item_cache,
-				 GFP_KERNEL);
+		kmem_cache_zalloc(ecryptfs_auth_tok_list_item_cache,
+				  GFP_KERNEL);
 	if (!auth_tok_list_item) {
-		ecryptfs_printk(KERN_ERR, "Unable to allocate memory\n");
+		printk(KERN_ERR "Unable to allocate memory\n");
 		rc = -ENOMEM;
 		goto out;
 	}
-	memset(auth_tok_list_item, 0,
-	       sizeof(struct ecryptfs_auth_tok_list_item));
 	(*new_auth_tok) = &auth_tok_list_item->auth_tok;
-	/* check for body size - one to two bytes
-	 *
-	 *              ***** TAG 1 Packet Format *****
-	 *    | version number                     | 1 byte       |
-	 *    | key ID                             | 8 bytes      |
-	 *    | public key algorithm               | 1 byte       |
-	 *    | encrypted session key              | arbitrary    |
-	 */
-	rc = parse_packet_length(&data[(*packet_size)], &body_size,
-				 &length_size);
-	if (rc) {
-		ecryptfs_printk(KERN_WARNING, "Error parsing packet length; "
-				"rc = [%d]\n", rc);
+	if ((rc = parse_packet_length(&data[(*packet_size)], &body_size,
+				      &length_size))) {
+		printk(KERN_WARNING "Error parsing packet length; "
+		       "rc = [%d]\n", rc);
 		goto out_free;
 	}
-	if (unlikely(body_size < (0x02 + ECRYPTFS_SIG_SIZE))) {
-		ecryptfs_printk(KERN_WARNING, "Invalid body size ([%d])\n",
-				body_size);
+	if (unlikely(body_size < (ECRYPTFS_SIG_SIZE + 2))) {
+		printk(KERN_WARNING "Invalid body size ([%d])\n", body_size);
 		rc = -EINVAL;
 		goto out_free;
 	}
 	(*packet_size) += length_size;
 	if (unlikely((*packet_size) + body_size > max_packet_size)) {
-		ecryptfs_printk(KERN_ERR, "Packet size exceeds max\n");
+		printk(KERN_WARNING "Packet size exceeds max\n");
 		rc = -EINVAL;
 		goto out_free;
 	}
-	/* Version 3 (from RFC2440) - one byte */
 	if (unlikely(data[(*packet_size)++] != 0x03)) {
-		ecryptfs_printk(KERN_DEBUG, "Unknown version number "
-				"[%d]\n", data[(*packet_size) - 1]);
+		printk(KERN_WARNING "Unknown version number [%d]\n",
+		       data[(*packet_size) - 1]);
 		rc = -EINVAL;
 		goto out_free;
 	}
-	/* Read Signature */
 	ecryptfs_to_hex((*new_auth_tok)->token.private_key.signature,
 			&data[(*packet_size)], ECRYPTFS_SIG_SIZE);
 	*packet_size += ECRYPTFS_SIG_SIZE;
@@ -585,27 +577,23 @@ parse_tag_1_packet(struct ecryptfs_crypt_stat *crypt_stat,
 	 * know which public key encryption algorithm was used */
 	(*packet_size)++;
 	(*new_auth_tok)->session_key.encrypted_key_size =
-		body_size - (0x02 + ECRYPTFS_SIG_SIZE);
+		body_size - (ECRYPTFS_SIG_SIZE + 2);
 	if ((*new_auth_tok)->session_key.encrypted_key_size
 	    > ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES) {
-		ecryptfs_printk(KERN_ERR, "Tag 1 packet contains key larger "
-				"than ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES");
+		printk(KERN_WARNING "Tag 1 packet contains key larger "
+		       "than ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES");
 		rc = -EINVAL;
 		goto out;
 	}
-	ecryptfs_printk(KERN_DEBUG, "Encrypted key size = [%d]\n",
-			(*new_auth_tok)->session_key.encrypted_key_size);
 	memcpy((*new_auth_tok)->session_key.encrypted_key,
-	       &data[(*packet_size)], (body_size - 0x02 - ECRYPTFS_SIG_SIZE));
+	       &data[(*packet_size)], (body_size - (ECRYPTFS_SIG_SIZE + 2)));
 	(*packet_size) += (*new_auth_tok)->session_key.encrypted_key_size;
 	(*new_auth_tok)->session_key.flags &=
 		~ECRYPTFS_CONTAINS_DECRYPTED_KEY;
 	(*new_auth_tok)->session_key.flags |=
 		ECRYPTFS_CONTAINS_ENCRYPTED_KEY;
 	(*new_auth_tok)->token_type = ECRYPTFS_PRIVATE_KEY;
-	(*new_auth_tok)->flags |= ECRYPTFS_PRIVATE_KEY;
-	/* TODO: Why are we setting this flag here? Don't we want the
-	 * userspace to decrypt the session key? */
+	(*new_auth_tok)->flags = 0;
 	(*new_auth_tok)->session_key.flags &=
 		~(ECRYPTFS_USERSPACE_SHOULD_TRY_TO_DECRYPT);
 	(*new_auth_tok)->session_key.flags &=
-- 
1.4.4.4

