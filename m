Return-Path: <linux-kernel-owner+w=401wt.eu-S934148AbXGSVcg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148AbXGSVcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762250AbXGSVcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:32:23 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37588 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758590AbXGSVcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:32:21 -0400
Date: Thu, 19 Jul 2007 16:30:06 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, tchicks@us.ibm.com,
       trevor.highland@gmail.com, pregan@ic.sunysb.edu, toml@us.ibm.com,
       sergeh@us.ibm.com, mike@halcrow.us
Subject: [PATCH 7/8] eCryptfs: Fix Tag 11 writing code
Message-ID: <20070719213006.GH13821@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070719212453.GA13821@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070719212453.GA13821@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the Tag 11 writing code to handle size limits and boundaries
more explicitly. It looks like the packet length was 1 shorter than it
should have been, chopping off the last byte of the key
identifier. This is largely inconsequential, since it is not much more
likely that a key identifier collision will occur with 7 bytes rather
than 8. This patch fixes the packet to use the full number of bytes
that were originally intended to be used for the key identifier.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/keystore.c |   39 ++++++++++++++++++++++-----------------
 1 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 8c695e3..8485e77 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1449,47 +1449,52 @@ out:
  * Returns zero on success; non-zero on error.
  */
 static int
-write_tag_11_packet(char *dest, int max, char *contents, size_t contents_length,
-		    size_t *packet_length)
+write_tag_11_packet(char *dest, int *remaining_bytes, char *contents,
+		    size_t contents_length, size_t *packet_length)
 {
 	size_t packet_size_length;
+	size_t max_packet_size;
 	int rc = 0;
 
 	(*packet_length) = 0;
-	if ((13 + contents_length) > max) {
+	/* This format is inspired by OpenPGP; see RFC 2440
+	 * packet tag 11 */
+	max_packet_size = (1                   /* Tag 11 identifier */
+			   + 3                 /* Max Tag 11 packet size */
+			   + 1                 /* Binary format specifier */
+			   + 1                 /* Filename length */
+			   + 8                 /* Filename ("_CONSOLE") */
+			   + 4                 /* Modification date */
+			   + contents_length); /* Literal data */
+	if (max_packet_size > (*remaining_bytes)) {
+		printk(KERN_ERR "Packet length larger than maximum allowable; "
+		       "need up to [%d] bytes, but there are only [%d] "
+		       "available\n", max_packet_size, (*remaining_bytes));
 		rc = -EINVAL;
-		ecryptfs_printk(KERN_ERR, "Packet length larger than "
-				"maximum allowable\n");
 		goto out;
 	}
-	/* General packet header */
-	/* Packet tag */
 	dest[(*packet_length)++] = ECRYPTFS_TAG_11_PACKET_TYPE;
-	/* Packet length */
 	rc = write_packet_length(&dest[(*packet_length)],
-				 (13 + contents_length), &packet_size_length);
+				 (max_packet_size - 4), &packet_size_length);
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error generating tag 11 packet "
-				"header; cannot generate packet length\n");
+		printk(KERN_ERR "Error generating tag 11 packet header; cannot "
+		       "generate packet length. rc = [%d]\n", rc);
 		goto out;
 	}
 	(*packet_length) += packet_size_length;
-	/* Tag 11 specific */
-	/* One-octet field that describes how the data is formatted */
-	dest[(*packet_length)++] = 0x62; /* binary data */
-	/* One-octet filename length followed by filename */
+	dest[(*packet_length)++] = 0x62; /* binary data format specifier */
 	dest[(*packet_length)++] = 8;
 	memcpy(&dest[(*packet_length)], "_CONSOLE", 8);
 	(*packet_length) += 8;
-	/* Four-octet number indicating modification date */
 	memset(&dest[(*packet_length)], 0x00, 4);
 	(*packet_length) += 4;
-	/* Remainder is literal data */
 	memcpy(&dest[(*packet_length)], contents, contents_length);
 	(*packet_length) += contents_length;
  out:
 	if (rc)
 		(*packet_length) = 0;
+	else
+		(*remaining_bytes) -= (*packet_length);
 	return rc;
 }
 
-- 
1.4.4.4

