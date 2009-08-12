Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbZHLRUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbZHLRUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZHLRUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:20:06 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:37501 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbZHLRUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:20:05 -0400
Date: Wed, 12 Aug 2009 19:20:03 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [patch] Fixes for the Winbond WPCD376I driver
Message-ID: <20090812172003.GA21145@hardeman.nu>
Mail-Followup-To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a couple of fixes for the IR RX handling in the 
drivers/input/misc/winbond-cir.c driver.

Most importantly, the hardware forces a FIFO RX/TX buffer size of 16 
even though this isn't documented in the specs (meaning that an 
interrupt is generated when 8 bytes are loaded, not when 16 bytes are 
loaded).

Second, a loop was using the wrong parameter.

Third, it makes more sense to disable RX before draining the RX buffer 
rather than the other way around.

This patch applies on top of the patches already in the -mm tree.

Signed-off-by: David Härdeman <david@hardeman.nu>


Index: linux-2.6/drivers/input/misc/winbond-cir.c
===================================================================
--- linux-2.6.orig/drivers/input/misc/winbond-cir.c	2009-08-12 19:02:40.000000000 +0200
+++ linux-2.6/drivers/input/misc/winbond-cir.c	2009-08-12 19:11:16.000000000 +0200
@@ -941,7 +941,7 @@
  	struct device *dev = &device->dev;
  	u8 status;
  	unsigned long flags;
-	u8 irdata[16];
+	u8 irdata[8];
  	int i;
  	unsigned int hw;
  
@@ -962,11 +962,10 @@
  	if (!(status & WBCIR_IRQ_RX))
  		goto out;
  
-	/* Since RXHDLEV is set, at least 16 bytes are in the FIFO */
+	/* Since RXHDLEV is set, at least 8 bytes are in the FIFO */
  	insb(data->sbase + WBCIR_REG_SP3_RXDATA, &irdata[0], 8);
-	insb(data->sbase + WBCIR_REG_SP3_RXDATA, &irdata[8], 8);
  
-	for (i = 0; i < sizeof(data); i++) {
+	for (i = 0; i < sizeof(irdata); i++) {
  		hw = hweight8(irdata[i]);
  		if (hw > 4)
  			add_irdata_bit(data, 0);
@@ -980,13 +979,13 @@
  	}
  
  	if (data->idle_count > WBCIR_MAX_IDLE_BYTES) {
-		/* Drain the FIFO */
+		/* Set RXINACTIVE... */
+		outb(WBCIR_RX_DISABLE, data->sbase + WBCIR_REG_SP3_ASCR);
+
+		/* ...and drain the FIFO */
  		while (inb(data->sbase + WBCIR_REG_SP3_LSR) & WBCIR_RX_AVAIL)
  			inb(data->sbase + WBCIR_REG_SP3_RXDATA);
  
-		/* And set RXINACTIVE */
-		outb(WBCIR_RX_DISABLE, data->sbase + WBCIR_REG_SP3_ASCR);
-
  		dev_dbg(dev, "IRDATA:\n");
  		for (i = 0; i < data->irdata_count; i += BITS_PER_LONG)
  			dev_dbg(dev, "0x%08lX\n", data->irdata[i/BITS_PER_LONG]);
@@ -1438,10 +1437,13 @@
  	 *
  	 * The ECIR registers include a flag to change the
  	 * 24Mhz clock freq to 48Mhz.
+	 *
+	 * It's not documented in the specs, but fifo levels
+	 * other than 16 seem to be unsupported.
  	 */
  
-	/* prescaler 1.0, tx/rx fifo lvl 32 */
-	outb(0x35, data->sbase + WBCIR_REG_SP3_EXCR2);
+	/* prescaler 1.0, tx/rx fifo lvl 16 */
+	outb(0x30, data->sbase + WBCIR_REG_SP3_EXCR2);
  
  	/* Set baud divisor to generate one byte per bit/cell */
  	switch (protocol) {
@@ -1490,7 +1492,7 @@
  	else
  		outb(0x00, data->sbase + WBCIR_REG_SP3_IRCFG4);
  
-	/* Set FIFO thresholds (RX = 16, TX = 7), reset RX/TX */
+	/* Set FIFO thresholds (RX = 8, TX = 3), reset RX/TX */
  	wbcir_select_bank(data, WBCIR_BANK_0);
  	outb(0x97, data->sbase + WBCIR_REG_SP3_FCR);
  
@@ -1498,7 +1500,6 @@
  	outb(0xE0, data->sbase + WBCIR_REG_SP3_ASCR);
  
  	/* Enable interrupts */
-	wbcir_select_bank(data, WBCIR_BANK_0);
  	outb(WBCIR_IRQ_RX | WBCIR_IRQ_ERR, data->sbase + WBCIR_REG_SP3_IER);
  
  	return 0;
