Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbZLGMSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbZLGMSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 07:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756381AbZLGMSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 07:18:36 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:48561 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934680AbZLGMSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 07:18:32 -0500
Message-Id: <20091207121827.642709465@fluff.org.uk>
User-Agent: quilt/0.48-1
Date: Mon, 07 Dec 2009 12:17:29 +0000
From: Ben Dooks <ben@simtec.co.uk>
To: netdev@vger.kernel.org
Cc: linux@simtec.co.uk, doong.ping@micrel.com, tristram.ha@micrel.com,
       Wolfram Sang <w.sang@pengutronix.de>, Jean Delvare <khali@linux-fr.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [patch 2/9] eeprom_93cx6: Add write support
References: <20091207121727.016092171@fluff.org.uk>
Content-Disposition: inline; filename=93c-eeprom-add-write.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for writing data to EEPROM.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>

---
 drivers/misc/eeprom/eeprom_93cx6.c |   86 +++++++++++++++++++++++++++++++++++++
 include/linux/eeprom_93cx6.h       |    7 +++
 2 files changed, 93 insertions(+)

Index: b/drivers/misc/eeprom/eeprom_93cx6.c
===================================================================
--- a/drivers/misc/eeprom/eeprom_93cx6.c	2009-10-06 15:51:18.000000000 +0100
+++ b/drivers/misc/eeprom/eeprom_93cx6.c	2009-10-06 15:54:36.000000000 +0100
@@ -241,3 +241,89 @@ void eeprom_93cx6_multiread(struct eepro
 }
 EXPORT_SYMBOL_GPL(eeprom_93cx6_multiread);
 
+
+/**
+ * eeprom_93cx6_wren - set the write enable state
+ * @eeprom: Pointer to eeprom structure
+ * @enable: true to enable writes, otherwise disable writes
+ *
+ * Set the EEPROM write enable state to either allow or deny
+ * writes depending on the @enable value.
+ */
+void eeprom_93cx6_wren(struct eeprom_93cx6 *eeprom, bool enable)
+{
+	u16 command;
+
+	/* start the command */
+	eeprom_93cx6_startup(eeprom);
+
+	/* create command to enable/disable */
+
+	command = enable ? PCI_EEPROM_EWEN_OPCODE : PCI_EEPROM_EWDS_OPCODE;
+	command <<= (eeprom->width - 2);
+
+	eeprom_93cx6_write_bits(eeprom, command,
+				PCI_EEPROM_WIDTH_OPCODE + eeprom->width);
+
+	eeprom_93cx6_cleanup(eeprom);
+}
+EXPORT_SYMBOL_GPL(eeprom_93cx6_wren);
+
+/**
+ * eeprom_93cx6_write - write data to the EEPROM
+ * @eeprom: Pointer to eeprom structure
+ * @addr: Address to write data to.
+ * @data: The data to write to address @addr.
+ *
+ * Write the @data to the specified @addr in the EEPROM and
+ * waiting for the device to finish writing.
+ *
+ * Note, since we do not expect large number of write operations
+ * we use msleep() to delay in between parts of the operation to
+ * avoid using excessive amounts of CPU time busy waiting.
+ */
+void eeprom_93cx6_write(struct eeprom_93cx6 *eeprom, u8 addr, u16 data)
+{
+	int timeout = 100;
+	u16 command;
+
+	/* start the command */
+	eeprom_93cx6_startup(eeprom);
+
+	command = PCI_EEPROM_WRITE_OPCODE << eeprom->width;
+	command |= addr;
+
+	/* send write command */
+	eeprom_93cx6_write_bits(eeprom, command,
+				PCI_EEPROM_WIDTH_OPCODE + eeprom->width);
+
+	/* send data */
+	eeprom_93cx6_write_bits(eeprom, data, 16);
+
+	/* get ready to check for busy */
+	eeprom->drive_data = 0;
+	eeprom->reg_chip_select = 1;
+	eeprom->register_write(eeprom);
+
+	/* wait at-least 250ns to get DO to be the busy signal */
+	msleep(1);
+
+	/* wait for DO to go high to signify finish */
+
+	while (true) {
+		eeprom->register_read(eeprom);
+
+		if (eeprom->reg_data_out)
+			break;
+
+		msleep(1);
+
+		if (--timeout <= 0) {
+			printk(KERN_ERR "%s: timeout\n", __func__);
+			break;
+		}			
+	}
+
+	eeprom_93cx6_cleanup(eeprom);
+}
+EXPORT_SYMBOL_GPL(eeprom_93cx6_write);
Index: b/include/linux/eeprom_93cx6.h
===================================================================
--- a/include/linux/eeprom_93cx6.h	2009-10-06 15:51:18.000000000 +0100
+++ b/include/linux/eeprom_93cx6.h	2009-10-06 15:53:16.000000000 +0100
@@ -32,6 +32,7 @@
 #define PCI_EEPROM_WIDTH_93C66	8
 #define PCI_EEPROM_WIDTH_OPCODE	3
 #define PCI_EEPROM_WRITE_OPCODE	0x05
+#define PCI_EEPROM_ERASE_OPCODE 0x07
 #define PCI_EEPROM_READ_OPCODE	0x06
 #define PCI_EEPROM_EWDS_OPCODE	0x10
 #define PCI_EEPROM_EWEN_OPCODE	0x13
@@ -73,3 +74,9 @@ extern void eeprom_93cx6_read(struct eep
 	const u8 word, u16 *data);
 extern void eeprom_93cx6_multiread(struct eeprom_93cx6 *eeprom,
 	const u8 word, __le16 *data, const u16 words);
+
+extern void eeprom_93cx6_wren(struct eeprom_93cx6 *eeprom, bool enable);
+
+extern void eeprom_93cx6_write(struct eeprom_93cx6 *eeprom,
+			       u8 addr, u16 data);
+

