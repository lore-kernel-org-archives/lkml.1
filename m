Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYE3Lpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYE3Lpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 07:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYE3Lpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 07:45:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49953 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbYE3Lpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 07:45:38 -0400
Subject: [PATCH] keyspan: use request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org,
       hugh@misc.nu, greg@kroah.com
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
Content-Type: text/plain
Date: Fri, 30 May 2008 14:45:33 +0300
Message-Id: <1212147933.7948.8.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 3df8a66..4a28d91 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -105,6 +105,8 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/firmware.h>
+#include <linux/ihex.h>
 #include <asm/uaccess.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
@@ -1339,13 +1341,13 @@ static void keyspan_close(struct usb_serial_port *port, struct file *filp)
 	port->tty = NULL;
 }
 
-
 	/* download the firmware to a pre-renumeration device */
 static int keyspan_fake_startup (struct usb_serial *serial)
 {
 	int 				response;
-	const struct ezusb_hex_record 	*record;
+	const struct ihex_binrec 	*record;
 	char				*fw_name;
+	const struct firmware		*fw;
 
 	dbg("Keyspan startup version %04x product %04x",
 	    le16_to_cpu(serial->dev->descriptor.bcdDevice),
@@ -1359,72 +1361,60 @@ static int keyspan_fake_startup (struct usb_serial *serial)
 		/* Select firmware image on the basis of idProduct */
 	switch (le16_to_cpu(serial->dev->descriptor.idProduct)) {
 	case keyspan_usa28_pre_product_id:
-		record = &keyspan_usa28_firmware[0];
-		fw_name = "USA28";
+		fw_name = "keyspan/usa28.fw";
 		break;
 
 	case keyspan_usa28x_pre_product_id:
-		record = &keyspan_usa28x_firmware[0];
-		fw_name = "USA28X";
+		fw_name = "keyspan/usa28x.fw";
 		break;
 
 	case keyspan_usa28xa_pre_product_id:
-		record = &keyspan_usa28xa_firmware[0];
-		fw_name = "USA28XA";
+		fw_name = "keyspan/usa28xa.fw";
 		break;
 
 	case keyspan_usa28xb_pre_product_id:
-		record = &keyspan_usa28xb_firmware[0];
-		fw_name = "USA28XB";
+		fw_name = "keyspan/usa28xb.fw";
 		break;
 
 	case keyspan_usa19_pre_product_id:
-		record = &keyspan_usa19_firmware[0];
-		fw_name = "USA19";
+		fw_name = "keyspan/usa19.fw";
 		break;
 			     
 	case keyspan_usa19qi_pre_product_id:
-		record = &keyspan_usa19qi_firmware[0];
-		fw_name = "USA19QI";
+		fw_name = "keyspan/usa19qi.fw";
 		break;
 			     
 	case keyspan_mpr_pre_product_id:
-		record = &keyspan_mpr_firmware[0];
-		fw_name = "MPR";
+		fw_name = "keyspan/mpr.fw";
 		break;
 
 	case keyspan_usa19qw_pre_product_id:
-		record = &keyspan_usa19qw_firmware[0];
-		fw_name = "USA19QI";
+		fw_name = "keyspan/usa19qw.fw";
 		break;
 			     
 	case keyspan_usa18x_pre_product_id:
-		record = &keyspan_usa18x_firmware[0];
-		fw_name = "USA18X";
+		fw_name = "keyspan/usa18x.fw";
 		break;
 			     
 	case keyspan_usa19w_pre_product_id:
-		record = &keyspan_usa19w_firmware[0];
-		fw_name = "USA19W";
+		fw_name = "keyspan/usa19w.fw";
 		break;
 		
 	case keyspan_usa49w_pre_product_id:
-		record = &keyspan_usa49w_firmware[0];
-		fw_name = "USA49W";
+		fw_name = "keyspan/usa49w.fw";
 		break;
 
 	case keyspan_usa49wlc_pre_product_id:
-		record = &keyspan_usa49wlc_firmware[0];
-		fw_name = "USA49WLC";
+		fw_name = "keyspan/usa49wlc.fw";
 		break;
 
 	default:
-		record = NULL;
-		fw_name = "Unknown";
-		break;
+		dev_err(&serial->dev->dev, "Unknown product ID (%04x)\n",
+			le16_to_cpu(serial->dev->descriptor.idProduct));
+		return 1;
 	}
 
-	if (record == NULL) {
+	if (request_firmware(&fw, fw_name, &serial->dev->dev)) {
 		dev_err(&serial->dev->dev, "Required keyspan firmware image (%s) unavailable.\n", fw_name);
 		return(1);
 	}
@@ -1434,19 +1424,22 @@ static int keyspan_fake_startup (struct usb_serial *serial)
 		/* download the firmware image */
 	response = ezusb_set_reset(serial, 1);
 
-	while(record->address != 0xffff) {
-		response = ezusb_writememory(serial, record->address,
+	record = (const struct ihex_binrec *)fw->data;
+
+	while (record) {
+		response = ezusb_writememory(serial, be32_to_cpu(record->addr),
 					     (unsigned char *)record->data,
-					     record->data_size, 0xa0);
+					     record->len, 0xa0);
 		if (response < 0) {
 			dev_err(&serial->dev->dev, "ezusb_writememory failed for Keyspan"
 				"firmware (%d %04X %p %d)\n",
-				response, 
-				record->address, record->data, record->data_size);
+				response, be32_to_cpu(record->addr), 
+				record->data, record->len);
 			break;
 		}
-		record++;
+		record = ihex_next_binrec(record);
 	}
+	release_firmware(fw);
 		/* bring device out of reset. Renumeration will occur in a
 		   moment and the new device will bind to the real driver */
 	response = ezusb_set_reset(serial, 0);
@@ -2756,6 +2749,19 @@ MODULE_AUTHOR( DRIVER_AUTHOR );
 MODULE_DESCRIPTION( DRIVER_DESC );
 MODULE_LICENSE("GPL");
 
+MODULE_FIRMWARE("keyspan/usa28.fw");
+MODULE_FIRMWARE("keyspan/usa28x.fw");
+MODULE_FIRMWARE("keyspan/usa28xa.fw");
+MODULE_FIRMWARE("keyspan/usa28xb.fw");
+MODULE_FIRMWARE("keyspan/usa19.fw");
+MODULE_FIRMWARE("keyspan/usa19qi.fw");
+MODULE_FIRMWARE("keyspan/mpr.fw");
+MODULE_FIRMWARE("keyspan/usa19qw.fw");
+MODULE_FIRMWARE("keyspan/usa18x.fw");
+MODULE_FIRMWARE("keyspan/usa19w.fw");
+MODULE_FIRMWARE("keyspan/usa49w.fw");
+MODULE_FIRMWARE("keyspan/usa49wlc.fw");
+
 module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug enabled or not");
 
diff --git a/drivers/usb/serial/keyspan.h b/drivers/usb/serial/keyspan.h
index 8d6ed02..b52fb65 100644
--- a/drivers/usb/serial/keyspan.h
+++ b/drivers/usb/serial/keyspan.h
@@ -103,90 +103,6 @@ static int  keyspan_usa67_send_setup	(struct usb_serial *serial,
 					 struct usb_serial_port *port,
 					 int reset_port);
 
-/* Struct used for firmware - increased size of data section
-   to allow Keyspan's 'C' firmware struct to be used unmodified */
-struct ezusb_hex_record {
-	__u16 address;
-	__u8 data_size;
-	__u8 data[64];
-};
-
-/* Conditionally include firmware images, if they aren't
-   included create a null pointer instead.  Current 
-   firmware images aren't optimised to remove duplicate
-   addresses in the image itself. */
-#ifdef CONFIG_USB_SERIAL_KEYSPAN_USA28
-	#include "keyspan_usa28_fw.h"
-#else
-	static const struct ezusb_hex_record *keyspan_usa28_firmware = NULL;
-#endif
-
-#ifdef CONFIG_USB_SERIAL_KEYSPAN_USA28X
-	#include "keyspan_usa28x_fw.h"
-#else
-	static const struct ezusb_hex_record *keyspan_usa28x_firmware = NULL;
-#endif
-
-#ifdef CONFIG_USB_SERIAL_KEYSPAN_USA28XA
-	#include "keyspan_usa28xa_fw.h"
-#else
-	static const struct ezusb_hex_record *keyspan_usa28xa_firmware = NULL;
-#endif
-
-#ifdef CONFIG_USB_SERIAL_KEYSPAN_USA28XB
-	#include "keyspan_usa28xb_fw.h"
-#else
-	static const struct ezusb_hex_record *keyspan_usa28xb_firmware = NULL;
-#endif
-
-#ifdef CONFIG_USB_SERIAL_KEYSPAN_USA19
-	#include "keyspan_usa19_fw.h"
-#else
-	static const struct ezusb_hex_record *keyspan_usa19_firmware = NULL;
-#endif
-
-#ifdef CONFIG_USB_SERIAL_KEYSPAN_USA19QI
-	#include "keyspan_usa19qi_fw.h"
-#else
-	static const struct ezusb_hex_record *keyspan_usa19qi_firmware = NULL;
-#endif
-
-#ifdef CONFIG_USB_SERIAL_KEYSPAN_MPR
-        #include "keyspan_mpr_fw.h"
-#else
-	static const struct ezusb_hex_record *keyspan_mpr_firmware = NULL;
-#endif
-
-#ifdef CONFIG_USB_SERIAL_KEYSPAN_USA19QW
-	#include "keyspan_usa19qw_fw.h"
-#else
-	static const struct ezusb_hex_record *keyspan_usa19qw_firmware = NULL;
-#endif
-
-#ifdef CONFIG_USB_SERIAL_KEYSPAN_USA18X
-	#include "keyspan_usa18x_fw.h"
-#else
-	static const struct ezusb_hex_record *keyspan_usa18x_firmware = NULL;
-#endif
-
-#ifdef CONFIG_USB_SERIAL_KEYSPAN_USA19W
-	#include "keyspan_usa19w_fw.h"
-#else
-	static const struct ezusb_hex_record *keyspan_usa19w_firmware = NULL;
-#endif
-
-#ifdef CONFIG_USB_SERIAL_KEYSPAN_USA49W
-	#include "keyspan_usa49w_fw.h"
-#else
-	static const struct ezusb_hex_record *keyspan_usa49w_firmware = NULL;
-#endif
-
-#ifdef CONFIG_USB_SERIAL_KEYSPAN_USA49WLC
-        #include "keyspan_usa49wlc_fw.h"
-#else
-	static const struct ezusb_hex_record *keyspan_usa49wlc_firmware = NULL;
-#endif
-
 /* Values used for baud rate calculation - device specific */
 #define	KEYSPAN_INVALID_BAUD_RATE		(-1)
 #define	KEYSPAN_BAUD_RATE_OK			(0)
diff --git a/firmware/Makefile b/firmware/Makefile
index 30b6ef4..eb3b992 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -18,6 +18,18 @@ fw-shipped-$(CONFIG_USB_KAWETH_FIRMWARE) += kaweth/new_code.bin \
 		kaweth/new_code_fix.bin kaweth/trigger_code.bin \
 		kaweth/trigger_code_fix.bin
 fw-shipped-$(CONFIG_DVB_TTUSB_BUDGET_FIRMWARE) += ttusb-budget-dspbootcode.bin
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_MPR) += keyspan/mpr.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA18X) += keyspan/usa18x.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA19) += keyspan/usa19.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA19QI) += keyspan/usa19qi.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA19QW) += keyspan/usa19qw.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA19W) += keyspan/usa19w.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA28) += keyspan/usa28.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA28XA) += keyspan/usa28xa.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA28XB) += keyspan/usa28xb.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA28X) += keyspan/usa28x.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA49W) += keyspan/usa49w.fw
+fw-shipped-$(CONFIG_USB_SERIAL_KEYSPAN_USA49WLC) += keyspan/usa49wlc.fw
 
 firmware-y    := $(fw-external-y) $(fw-shipped-y)
 firmware-dirs := $(sort $(patsubst %,$(objtree)/$(obj)/%/,$(dir $(firmware-y))))
diff --git a/include/linux/ihex.h b/include/linux/ihex.h
new file mode 100644
index 0000000..902222f
--- /dev/null
+++ b/include/linux/ihex.h
@@ -0,0 +1,28 @@
+/*
+ * Compact binary representation of ihex records. Some devices need their
+ * firmware loaded in strange orders rather than a single big blob, but 
+ * actually parsing ihex-as-text within the kernel seems silly. Thus,...
+ */
+
+#ifndef __LINUX_IHEX_H__
+#define __LINUX_IHEX_H__
+
+#include <linux/types.h>
+
+struct ihex_binrec {
+	__be32 addr;
+	uint8_t len;
+	uint8_t data[0];
+} __attribute__((aligned(4)));
+
+/* Find the next record, taking into account the 4-byte alignment */
+static inline const struct ihex_binrec *
+ihex_next_binrec(const struct ihex_binrec *rec)
+{
+	int next = ((rec->len + 4) & ~3) - 1;
+	rec = (void *)&rec->data[next];
+
+	return rec->len ? rec : NULL;
+}
+
+#endif /* __LINUX_IHEX_H__ */

-- 
dwmw2

