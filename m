Return-Path: <linux-kernel-owner+w=401wt.eu-S933423AbXGSVcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423AbXGSVcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762497AbXGSVbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:31:50 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:35373 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762250AbXGSVbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:31:49 -0400
Date: Thu, 19 Jul 2007 16:29:34 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tchicks@us.ibm.com,
       trevor.highland@gmail.com, pregan@ic.sunysb.edu, toml@us.ibm.com,
       sergeh@us.ibm.com, mike@halcrow.us
Subject: [PATCH 6/8] eCryptfs: Fix Tag 11 parsing code
Message-ID: <20070719212934.GG13821@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070719212453.GA13821@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719212453.GA13821@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the Tag 11 parsing code to handle size limits and boundaries
more explicitly. Pay attention to *8* bytes for the key identifier
(literal data), no more, no less.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/keystore.c |   76 +++++++++++++++++-------------------------------
 1 files changed, 27 insertions(+), 49 deletions(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 4caa45d..8c695e3 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -803,82 +803,60 @@ parse_tag_11_packet(unsigned char *data, unsigned char *contents,
 
 	(*packet_size) = 0;
 	(*tag_11_contents_size) = 0;
-
-	/* check that:
-	 *   one byte for the Tag 11 ID flag
-	 *   two bytes for the Tag 11 length
-	 * do not exceed the maximum_packet_size
+	/* This format is inspired by OpenPGP; see RFC 2440
+	 * packet tag 11
+	 *
+	 * Tag 11 identifier (1 byte)
+	 * Max Tag 11 packet size (max 3 bytes)
+	 * Binary format specifier (1 byte)
+	 * Filename length (1 byte)
+	 * Filename ("_CONSOLE") (8 bytes)
+	 * Modification date (4 bytes)
+	 * Literal data (arbitrary)
+	 *
+	 * We need at least 16 bytes of data for the packet to even be
+	 * valid.
 	 */
-	if (unlikely((*packet_size) + 3 > max_packet_size)) {
-		ecryptfs_printk(KERN_ERR, "Packet size exceeds max\n");
+	if (max_packet_size < 16) {
+		printk(KERN_ERR "Maximum packet size too small\n");
 		rc = -EINVAL;
 		goto out;
 	}
-
-	/* check for Tag 11 identifyer - one byte */
 	if (data[(*packet_size)++] != ECRYPTFS_TAG_11_PACKET_TYPE) {
-		ecryptfs_printk(KERN_WARNING,
-				"Invalid tag 11 packet format\n");
+		printk(KERN_WARNING "Invalid tag 11 packet format\n");
 		rc = -EINVAL;
 		goto out;
 	}
-
-	/* get Tag 11 content length - one or two bytes */
-	rc = parse_packet_length(&data[(*packet_size)], &body_size,
-				 &length_size);
-	if (rc) {
-		ecryptfs_printk(KERN_WARNING,
-				"Invalid tag 11 packet format\n");
+	if ((rc = parse_packet_length(&data[(*packet_size)], &body_size,
+				      &length_size))) {
+		printk(KERN_WARNING "Invalid tag 11 packet format\n");
 		goto out;
 	}
-	(*packet_size) += length_size;
-
-	if (body_size < 13) {
-		ecryptfs_printk(KERN_WARNING, "Invalid body size ([%d])\n",
-				body_size);
+	if (body_size < 14) {
+		printk(KERN_WARNING "Invalid body size ([%d])\n", body_size);
 		rc = -EINVAL;
 		goto out;
 	}
-	/* We have 13 bytes of surrounding packet values */
-	(*tag_11_contents_size) = (body_size - 13);
-
-	/* now we know the length of the remainting Tag 11 packet size:
-	 *   14 fix bytes for: special flag one, special flag two,
-	 *   		       12 skipped bytes
-	 *   body_size bytes minus the stuff above is the Tag 11 content
-	 */
-	/* FIXME why is the body size one byte smaller than the actual
-	 * size of the body?
-	 * this seems to be an error here as well as in
-	 * write_tag_11_packet() */
+	(*packet_size) += length_size;
+	(*tag_11_contents_size) = (body_size - 14);
 	if (unlikely((*packet_size) + body_size + 1 > max_packet_size)) {
-		ecryptfs_printk(KERN_ERR, "Packet size exceeds max\n");
+		printk(KERN_ERR "Packet size exceeds max\n");
 		rc = -EINVAL;
 		goto out;
 	}
-
-	/* special flag one - one byte */
 	if (data[(*packet_size)++] != 0x62) {
-		ecryptfs_printk(KERN_WARNING, "Unrecognizable packet\n");
+		printk(KERN_WARNING "Unrecognizable packet\n");
 		rc = -EINVAL;
 		goto out;
 	}
-
-	/* special flag two - one byte */
 	if (data[(*packet_size)++] != 0x08) {
-		ecryptfs_printk(KERN_WARNING, "Unrecognizable packet\n");
+		printk(KERN_WARNING "Unrecognizable packet\n");
 		rc = -EINVAL;
 		goto out;
 	}
-
-	/* skip the next 12 bytes */
-	(*packet_size) += 12; /* We don't care about the filename or
-			       * the timestamp */
-
-	/* get the Tag 11 contents - tag_11_contents_size bytes */
+	(*packet_size) += 12; /* Ignore filename and modification date */
 	memcpy(contents, &data[(*packet_size)], (*tag_11_contents_size));
 	(*packet_size) += (*tag_11_contents_size);
-
 out:
 	if (rc) {
 		(*packet_size) = 0;
-- 
1.4.4.4

