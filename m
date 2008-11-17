Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYKQVMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYKQVMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:12:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYKQVMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:12:17 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:28126 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751700AbYKQVMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:12:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Reply-To:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kIwZ/mADFPPGymWaQ/ZEhtdCVqhOBMr+Wzgyf0FxwqZLRrw5sIffZtEZ9E41zAQCIcGs8vYYtzMkOZR78dYjjwL4UYZonZlko91WWs+r6xBDm98sbwjFMQqjdOpfTXz/OHI+naRqDdXtIS4Lyn+P20DzBJLLngrwMMimvG45Kbg=  ;
X-YMail-OSG: jBJrFMMVM1mry3IgY6LixHnvqs9bVDb4mweWAuOKxdmeI4X8_NVcr.PlOb66DKZKh31grtPf9hbCpBNfZTJQKSzdW1wMpSNtRqskcPHU7rRlC.lQu.4.xhoGMRzi2XnyZdZg91EKeea4pxfAIVf1Rk_e
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
To: Linux MTD <linux-mtd@lists.infradead.org>
Subject: [patch/resend 2.6.28-rc5] mtd m25p80: chip erase != block erase != sector erase
Date: Mon, 17 Nov 2008 11:38:48 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, Chen Gong <g.chen@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811171138.48884.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Gong <g.chen@freescale.com>

This fixes broken terminology added in the "m25p80.c erase enhance" patch,
which added a chip erase command but called it "block erase".  There are
already two block erase commands; blocks are 4KiB or 32KiB.  There's also
a sector erase (usually 64 KiB).  Chip erase typically covers Megabytes.

  OPCODE_BE   ==> OPCODE_CHIP_ERASE
  erase_block ==> erase_chip

[dbrownell@users.sourceforge.net: update sector erase comments too ]

Signed-Off-by: Chen Gong <clumsycg@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/mtd/devices/m25p80.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -37,9 +37,9 @@
 #define	OPCODE_NORM_READ	0x03	/* Read data bytes (low frequency) */
 #define	OPCODE_FAST_READ	0x0b	/* Read data bytes (high frequency) */
 #define	OPCODE_PP		0x02	/* Page program (up to 256 bytes) */
-#define	OPCODE_BE_4K 		0x20	/* Erase 4KiB block */
+#define	OPCODE_BE_4K		0x20	/* Erase 4KiB block */
 #define	OPCODE_BE_32K		0x52	/* Erase 32KiB block */
-#define	OPCODE_BE		0xc7	/* Erase whole flash block */
+#define	OPCODE_CHIP_ERASE	0xc7	/* Erase whole flash block */
 #define	OPCODE_SE		0xd8	/* Sector erase (usually 64KiB) */
 #define	OPCODE_RDID		0x9f	/* Read JEDEC ID */
 
@@ -167,7 +167,7 @@ static int wait_till_ready(struct m25p *
  *
  * Returns 0 if successful, non-zero otherwise.
  */
-static int erase_block(struct m25p *flash)
+static int erase_chip(struct m25p *flash)
 {
 	DEBUG(MTD_DEBUG_LEVEL3, "%s: %s %dKiB\n",
 			flash->spi->dev.bus_id, __func__,
@@ -181,7 +181,7 @@ static int erase_block(struct m25p *flas
 	write_enable(flash);
 
 	/* Set up command buffer. */
-	flash->command[0] = OPCODE_BE;
+	flash->command[0] = OPCODE_CHIP_ERASE;
 
 	spi_write(flash->spi, flash->command, 1);
 
@@ -250,15 +250,18 @@ static int m25p80_erase(struct mtd_info 
 
 	mutex_lock(&flash->lock);
 
-	/* REVISIT in some cases we could speed up erasing large regions
-	 * by using OPCODE_SE instead of OPCODE_BE_4K
-	 */
-
-	/* now erase those sectors */
-	if (len == flash->mtd.size && erase_block(flash)) {
+	/* whole-chip erase? */
+	if (len == flash->mtd.size && erase_chip(flash)) {
 		instr->state = MTD_ERASE_FAILED;
 		mutex_unlock(&flash->lock);
 		return -EIO;
+
+	/* REVISIT in some cases we could speed up erasing large regions
+	 * by using OPCODE_SE instead of OPCODE_BE_4K.  We may have set up
+	 * to use "small sector erase", but that's not always optimal.
+	 */
+
+	/* "sector"-at-a-time erase */
 	} else {
 		while (len) {
 			if (erase_sector(flash, addr)) {
