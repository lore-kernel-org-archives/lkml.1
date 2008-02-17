Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbYBQVU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbYBQVU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 16:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYBQVUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 16:20:11 -0500
Received: from 1wt.eu ([62.212.114.60]:2017 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbYBQVUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 16:20:08 -0500
Date: Sun, 17 Feb 2008 22:20:04 +0100
From: Willy Tarreau <w@1wt.eu>
To: jeff@garzik.org
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] libata: implement support for 32-bit PIO transfers
Message-ID: <20080217212004.GB15327@1wt.eu>
References: <20080217211810.GA15001@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217211810.GA15001@1wt.eu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 4ea313fe6a3c46a90226cf40d0e3ece4b36b48f9 Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Sun, 17 Feb 2008 21:28:25 +0100
Subject: [PATCH 2/2] libata: implement support for 32-bit PIO transfers

When ATA_DFLAG_32BIT_PIO is set in ata flags, PIO transfers
will be performed in 32-bit, just like with the plain old IDE
drivers.

16-bit transfers in libata are as slow as 16-bit transfers in
plain old IDE drivers, which are about 35% slower than 32-bit
transfers with various CF and DOM. This patch restores the
performance to pre-libata level, which is a nice improvement
for many small systems relying on such hardware.

This patch relies on previous patch which implements the
ATA_DFLAG_32BIT_PIO ioctl.

To enable 32-bit transfers, simply proceed like before with
IDE :

  # hdparm -c 1 /dev/sda

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/ata/libata-core.c |   46 +++++++++++++++++++++++++++++++-------------
 1 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index beaa3a9..2651130 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4936,7 +4936,7 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
 }
 
 /**
- *	ata_data_xfer - Transfer data by PIO
+ *	ata_data_xfer - Transfer data by PIO (16 or 32-bit)
  *	@dev: device to target
  *	@buf: data buffer
  *	@buflen: buffer length
@@ -4955,30 +4955,48 @@ unsigned int ata_data_xfer(struct ata_device *dev, unsigned char *buf,
 {
 	struct ata_port *ap = dev->link->ap;
 	void __iomem *data_addr = ap->ioaddr.data_addr;
-	unsigned int words = buflen >> 1;
+	unsigned int words;
 
-	/* Transfer multiple of 2 bytes */
-	if (rw == READ)
-		ioread16_rep(data_addr, buf, words);
-	else
-		iowrite16_rep(data_addr, buf, words);
+	if (dev->flags & ATA_DFLAG_32BIT_PIO) {
+		/* Transfer in 32-bit words */
+		words = buflen >> 2;
+		if (rw == READ)
+			ioread32_rep(data_addr, buf, words);
+		else
+			iowrite32_rep(data_addr, buf, words);
+		words <<= 2;
+	} else {
+		/* Transfer in 16-bit words */
+		words = buflen >> 1;
+		if (rw == READ)
+			ioread16_rep(data_addr, buf, words);
+		else
+			iowrite16_rep(data_addr, buf, words);
+		words <<= 1;
+	}
 
-	/* Transfer trailing 1 byte, if any. */
-	if (unlikely(buflen & 0x01)) {
+	/* Transfer trailing 1, 2 or 3 bytes, if any. We know how many bytes
+	 * remain because <words> now contains the number of bytes transferred.
+	 */
+	while (buflen > words) {
 		__le16 align_buf[1] = { 0 };
-		unsigned char *trailing_buf = buf + buflen - 1;
+		unsigned char *trailing_buf = buf + words;
+		int len = buflen - words;
+
+		if (len > 2)
+			len = 2;
 
 		if (rw == READ) {
 			align_buf[0] = cpu_to_le16(ioread16(data_addr));
-			memcpy(trailing_buf, align_buf, 1);
+			memcpy(trailing_buf, align_buf, len);
 		} else {
-			memcpy(align_buf, trailing_buf, 1);
+			memcpy(align_buf, trailing_buf, len);
 			iowrite16(le16_to_cpu(align_buf[0]), data_addr);
 		}
-		words++;
+		words += len;
 	}
 
-	return words << 1;
+	return words;
 }
 
 /**
-- 
1.5.3.8

