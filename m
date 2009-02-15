Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbZBOTa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbZBOTa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbZBOTaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:30:17 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:26210 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751095AbZBOTaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:30:16 -0500
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
To: jgarzik@pobox.com
Subject: [PATCH 2/2 resend] libata-sff: avoid byte swapping in ata_sff_data_xfer()
Date: Sun, 15 Feb 2009 23:30:38 +0400
User-Agent: KMail/1.5
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200902152230.38271.sshtylyov@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handling of the trailing byte in ata_sff_data_xfer() is suboptimal bacause:

- it always initializes the padding buffer to 0 which is not really needed in
  both the read and write cases;

- it has to use memcpy() to transfer a single byte from/to the padding buffer;

- it uses io{read|write}16() accessors which swap bytes on the big endian CPUs
  and so have to additionally convert the data from/to the little endian format
  instead of using io{read|write}16_rep() accessors which are not supposed to
  change the byte ordering.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
Oops, the subject got truncated -- resending...
The patch is against the recent Linus' tree but should apply to applicable
branch in the libata tree where it should probably wait for the next merge
window...

 drivers/ata/libata-sff.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/ata/libata-sff.c
===================================================================
--- linux-2.6.orig/drivers/ata/libata-sff.c
+++ linux-2.6/drivers/ata/libata-sff.c
@@ -723,17 +723,23 @@ unsigned int ata_sff_data_xfer(struct at
 	else
 		iowrite16_rep(data_addr, buf, words);
 
-	/* Transfer trailing 1 byte, if any. */
+	/* Transfer trailing byte, if any. */
 	if (unlikely(buflen & 0x01)) {
-		__le16 align_buf[1] = { 0 };
-		unsigned char *trailing_buf = buf + buflen - 1;
+		unsigned char pad[2];
 
+		/* Point buf to the tail of buffer */
+		buf += buflen - 1;
+
+		/*
+		 * Use io*16_rep() accessors here as well to avoid pointlessly
+		 * swapping bytes to and fro on the big endian machines...
+		 */
 		if (rw == READ) {
-			align_buf[0] = cpu_to_le16(ioread16(data_addr));
-			memcpy(trailing_buf, align_buf, 1);
+			ioread16_rep(data_addr, pad, 1);
+			*buf = pad[0];
 		} else {
-			memcpy(align_buf, trailing_buf, 1);
-			iowrite16(le16_to_cpu(align_buf[0]), data_addr);
+			pad[0] = *buf;
+			iowrite16_rep(data_addr, pad, 1);
 		}
 		words++;
 	}

