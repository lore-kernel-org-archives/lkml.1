Return-Path: <linux-kernel-owner+w=401wt.eu-S1759980AbYGKNs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759980AbYGKNs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759400AbYGKNrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:47:53 -0400
Received: from zbr.yandex.ru ([213.180.219.33]:34962 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754597AbYGKNru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:47:50 -0400
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jul 2008 09:47:49 EDT
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, David Fries <david@fries.net>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 24/30] W1: ds2490.c ds_dump_status rework
Date: Fri, 11 Jul 2008 17:51:39 +0400
Message-Id: <12157843073199-git-send-email-johnpol@2ka.mipt.ru>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
References: <12157843054074-git-send-email-johnpol@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add result register #defines
- rename ds_dump_status to ds_print_msg
- rename ds_recv_status to ds_dump_status
- ds_dump_status prints the requested status and no longer reads the
  status, this is because the second status read can return different
  data for example the result register
- the result register will be printed, though limited to detecting a
  new device, detecting other values such as a short would require
  additional reporting methods
- ST_EPOF was moved to ds_wait_status to clear the error condition
  sooner

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

---
 drivers/w1/masters/ds2490.c |  134 +++++++++++++++++++++++++++----------------
 1 files changed, 84 insertions(+), 50 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index b1ae1a0..0bcdd3f 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -107,6 +107,17 @@
 #define ST_IDLE				0x20  /* DS2490 is currently idle */
 #define ST_EPOF				0x80
 
+/* Result Register flags */
+#define RR_DETECT			0xA5 /* New device detected */
+#define RR_NRS				0x01 /* Reset no presence or ... */
+#define RR_SH				0x02 /* short on reset or set path */
+#define RR_APP				0x04 /* alarming presence on reset */
+#define RR_VPP				0x08 /* 12V expected not seen */
+#define RR_CMP				0x10 /* compare error */
+#define RR_CRC				0x20 /* CRC error detected */
+#define RR_RDP				0x40 /* redirected page */
+#define RR_EOS				0x80 /* end of search error */
+
 #define SPEED_NORMAL			0x00
 #define SPEED_FLEXIBLE			0x01
 #define SPEED_OVERDRIVE			0x02
@@ -164,7 +175,6 @@ MODULE_DEVICE_TABLE(usb, ds_id_table);
 static int ds_probe(struct usb_interface *, const struct usb_device_id *);
 static void ds_disconnect(struct usb_interface *);
 
-static inline void ds_dump_status(unsigned char *, unsigned char *, int);
 static int ds_send_control(struct ds_device *, u16, u16);
 static int ds_send_control_cmd(struct ds_device *, u16, u16);
 
@@ -223,11 +233,6 @@ static int ds_send_control(struct ds_device *dev, u16 value, u16 index)
 	return err;
 }
 
-static inline void ds_dump_status(unsigned char *buf, unsigned char *str, int off)
-{
-	printk("%45s: %8x\n", str, buf[off]);
-}
-
 static int ds_recv_status_nodump(struct ds_device *dev, struct ds_status *st,
 				 unsigned char *buf, int size)
 {
@@ -248,54 +253,62 @@ static int ds_recv_status_nodump(struct ds_device *dev, struct ds_status *st,
 	return count;
 }
 
-static int ds_recv_status(struct ds_device *dev, struct ds_status *st)
+static inline void ds_print_msg(unsigned char *buf, unsigned char *str, int off)
 {
-	unsigned char buf[64];
-	int count, err = 0, i;
-
-	memcpy(st, buf, sizeof(*st));
+	printk(KERN_INFO "%45s: %8x\n", str, buf[off]);
+}
 
-	count = ds_recv_status_nodump(dev, st, buf, sizeof(buf));
-	if (count < 0)
-		return err;
+static void ds_dump_status(struct ds_device *dev, unsigned char *buf, int count)
+{
+	int i;
 
-	printk("0x%x: count=%d, status: ", dev->ep[EP_STATUS], count);
+	printk(KERN_INFO "0x%x: count=%d, status: ", dev->ep[EP_STATUS], count);
 	for (i=0; i<count; ++i)
 		printk("%02x ", buf[i]);
-	printk("\n");
+	printk(KERN_INFO "\n");
 
 	if (count >= 16) {
-		ds_dump_status(buf, "enable flag", 0);
-		ds_dump_status(buf, "1-wire speed", 1);
-		ds_dump_status(buf, "strong pullup duration", 2);
-		ds_dump_status(buf, "programming pulse duration", 3);
-		ds_dump_status(buf, "pulldown slew rate control", 4);
-		ds_dump_status(buf, "write-1 low time", 5);
-		ds_dump_status(buf, "data sample offset/write-0 recovery time", 6);
-		ds_dump_status(buf, "reserved (test register)", 7);
-		ds_dump_status(buf, "device status flags", 8);
-		ds_dump_status(buf, "communication command byte 1", 9);
-		ds_dump_status(buf, "communication command byte 2", 10);
-		ds_dump_status(buf, "communication command buffer status", 11);
-		ds_dump_status(buf, "1-wire data output buffer status", 12);
-		ds_dump_status(buf, "1-wire data input buffer status", 13);
-		ds_dump_status(buf, "reserved", 14);
-		ds_dump_status(buf, "reserved", 15);
+		ds_print_msg(buf, "enable flag", 0);
+		ds_print_msg(buf, "1-wire speed", 1);
+		ds_print_msg(buf, "strong pullup duration", 2);
+		ds_print_msg(buf, "programming pulse duration", 3);
+		ds_print_msg(buf, "pulldown slew rate control", 4);
+		ds_print_msg(buf, "write-1 low time", 5);
+		ds_print_msg(buf, "data sample offset/write-0 recovery time",
+			6);
+		ds_print_msg(buf, "reserved (test register)", 7);
+		ds_print_msg(buf, "device status flags", 8);
+		ds_print_msg(buf, "communication command byte 1", 9);
+		ds_print_msg(buf, "communication command byte 2", 10);
+		ds_print_msg(buf, "communication command buffer status", 11);
+		ds_print_msg(buf, "1-wire data output buffer status", 12);
+		ds_print_msg(buf, "1-wire data input buffer status", 13);
+		ds_print_msg(buf, "reserved", 14);
+		ds_print_msg(buf, "reserved", 15);
 	}
-
-	memcpy(st, buf, sizeof(*st));
-
-	if (st->status & ST_EPOF) {
-		printk(KERN_INFO "Resetting device after ST_EPOF.\n");
-		err = ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
-		if (err)
-			return err;
-		count = ds_recv_status_nodump(dev, st, buf, sizeof(buf));
-		if (count < 0)
-			return err;
+	for (i = 16; i < count; ++i) {
+		if (buf[i] == RR_DETECT) {
+			ds_print_msg(buf, "new device detect", i);
+			continue;
+		}
+		ds_print_msg(buf, "Result Register Value: ", i);
+		if (buf[i] & RR_NRS)
+			printk(KERN_INFO "NRS: Reset no presence or ...\n");
+		if (buf[i] & RR_SH)
+			printk(KERN_INFO "SH: short on reset or set path\n");
+		if (buf[i] & RR_APP)
+			printk(KERN_INFO "APP: alarming presence on reset\n");
+		if (buf[i] & RR_VPP)
+			printk(KERN_INFO "VPP: 12V expected not seen\n");
+		if (buf[i] & RR_CMP)
+			printk(KERN_INFO "CMP: compare error\n");
+		if (buf[i] & RR_CRC)
+			printk(KERN_INFO "CRC: CRC error detected\n");
+		if (buf[i] & RR_RDP)
+			printk(KERN_INFO "RDP: redirected page\n");
+		if (buf[i] & RR_EOS)
+			printk(KERN_INFO "EOS: end of search error\n");
 	}
-
-	return err;
 }
 
 static int ds_recv_data(struct ds_device *dev, unsigned char *buf, int size)
@@ -307,9 +320,14 @@ static int ds_recv_data(struct ds_device *dev, unsigned char *buf, int size)
 	err = usb_bulk_msg(dev->udev, usb_rcvbulkpipe(dev->udev, dev->ep[EP_DATA_IN]),
 				buf, size, &count, 1000);
 	if (err < 0) {
+		u8 buf[0x20];
+		int count;
+
 		printk(KERN_INFO "Clearing ep0x%x.\n", dev->ep[EP_DATA_IN]);
 		usb_clear_halt(dev->udev, usb_rcvbulkpipe(dev->udev, dev->ep[EP_DATA_IN]));
-		ds_recv_status(dev, &st);
+
+		count = ds_recv_status_nodump(dev, &st, buf, sizeof(buf));
+		ds_dump_status(dev, buf, count);
 		return err;
 	}
 
@@ -390,7 +408,7 @@ int ds_detect(struct ds_device *dev, struct ds_status *st)
 	if (err)
 		return err;
 
-	err = ds_recv_status(dev, st);
+	err = ds_dump_status(dev, st);
 
 	return err;
 }
@@ -415,11 +433,27 @@ static int ds_wait_status(struct ds_device *dev, struct ds_status *st)
 #endif
 	} while(!(buf[0x08] & 0x20) && !(err < 0) && ++count < 100);
 
+	if (err >= 16 && st->status & ST_EPOF) {
+		printk(KERN_INFO "Resetting device after ST_EPOF.\n");
+		ds_send_control_cmd(dev, CTL_RESET_DEVICE, 0);
+		/* Always dump the device status. */
+		count = 101;
+	}
+
+	/* Dump the status for errors or if there is extended return data.
+	 * The extended status includes new device detection (maybe someone
+	 * can do something with it).
+	 */
+	if (err > 16 || count >= 100 || err < 0)
+		ds_dump_status(dev, buf, err);
 
-	if (((err > 16) && (buf[0x10] & 0x01)) || count >= 100 || err < 0) {
-		ds_recv_status(dev, st);
+	/* Extended data isn't an error.  Well, a short is, but the dump
+	 * would have already told the user that and we can't do anything
+	 * about it in software anyway.
+	 */
+	if (count >= 100 || err < 0)
 		return -1;
-	} else
+	else
 		return 0;
 }
 
-- 
1.4.4.4

