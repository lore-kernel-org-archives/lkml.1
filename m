Return-Path: <linux-kernel-owner+w=401wt.eu-S932389AbXGQHKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbXGQHKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762682AbXGQHKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:10:25 -0400
Received: from nn7.de ([85.214.94.156]:40714 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757987AbXGQHKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:10:22 -0400
Subject: [PATCH] appletouch powersaving - please apply for 2.6.23-rc1
From: Soeren Sonnenburg <kernel@nn7.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nicolas Boichat <nicolas@boichat.ch>,
       Michael Hanselmann <linux-kernel@hansmi.ch>,
       Peter Osterlund <petero2@telia.com>,
       Frank Arnold <frank@scirocco-5v-turbo.de>,
       Stelian Pop <stelian@popies.net>,
       Johannes Berg <johannes@sipsolutions.net>,
       Greg Kroah-Hartman <greg@kroah.com>
Content-Type: multipart/mixed; boundary="=-cDCXNbFAcq/tnuaRA8ot"
Date: Tue, 17 Jul 2007 09:10:18 +0200
Message-Id: <1184656218.14051.43.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cDCXNbFAcq/tnuaRA8ot
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

the attached minimally intrusive patch is based on Matthew Garret's
patch 'Make appletouch shut up when it has nothing to say' patches (e.g.
http://lkml.org/lkml/2007/5/13/117): Matthews description follows /
second paragraph lists my additional changes.

The appletouch geyser3 devices found in the Intel Macs (and possibly some later 
PPC ones?) send a constant stream of packets after the first touch. This 
results in the kernel waking up around once every couple of milliseconds 
to process them, making it almost impossible to spend any significant 
period of time in C3 state on a dynamic HZ kernel. Sending the mode 
initialization code makes the device shut up until it's touched again. 
This patch does so after receiving 10 packets with no interesting 
content.

In addition it now empties the work queue via cancel_work_sync on module
exit, keeps all error checking and only reports BTN_LEFT presses if bit
1 in the status byte (last byte in packet) is set. This fixes the random
left clicks issue. Furthermore it invalidates touchpad data before the
mode switch, which fixes the touchpad runs amok issue.

Credits:
Sven Anders found out that one should only check for bit 1 for BTN_LEFT.
Matthew Garrett did the initial 'Make appletouch shut up when it has
nothing to say' so I am adding him to the signed-off lines (hope that is
the correct way).

Patch follows inline and attached.

Soeren.

Signed-off-by: Soeren Sonnenburg <kernel@nn7.de>
Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appletouch.c
index e321526..0426054 100644
--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -155,6 +155,8 @@ struct atp {
 	int			xy_acc[ATP_XSENSORS + ATP_YSENSORS];
 	int			overflowwarn;	/* overflow warning printed? */
 	int			datalen;	/* size of an USB urb transfer */
+	int                     idlecount;      /* number of empty packets */
+	struct work_struct      work;
 };
 
 #define dbg_dump(msg, tab) \
@@ -208,6 +210,64 @@ static inline int atp_is_geyser_3(struct atp *dev)
 		(productId == GEYSER4_JIS_PRODUCT_ID);
 }
 
+/*
+ * By default Geyser 3 device sends standard USB HID mouse
+ * packets (Report ID 2). This code changes device mode, so it
+ * sends raw sensor reports (Report ID 5).
+ */
+static int atp_geyser3_init(struct usb_device *udev)
+{
+	char data[8];
+	int size;
+	int i;
+
+	size = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+			       ATP_GEYSER3_MODE_READ_REQUEST_ID,
+			       USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+			       ATP_GEYSER3_MODE_REQUEST_VALUE,
+			       ATP_GEYSER3_MODE_REQUEST_INDEX, &data, 8, 5000);
+
+
+	if (size != 8) {
+		printk("appletouch atp_geyser3_init READ error\n");
+		for (i=0; i<8; i++)
+			printk("appletouch[%d]: %d\n", i, (int) data[i]);
+
+		err("Could not do mode read request from device"
+		    " (Geyser 3 mode)");
+		return -EIO;
+	}
+
+	/* Apply the mode switch */
+	data[0] = ATP_GEYSER3_MODE_VENDOR_VALUE;
+
+	size = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+			       ATP_GEYSER3_MODE_WRITE_REQUEST_ID,
+			       USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+			       ATP_GEYSER3_MODE_REQUEST_VALUE,
+			       ATP_GEYSER3_MODE_REQUEST_INDEX, &data, 8, 5000);
+	
+	if (size != 8) {
+		printk("appletouch atp_geyser3_init WRITE error\n");
+		for (i=0; i<8; i++)
+			printk("appletouch[%d]: %d\n", i, (int) data[i]);
+		err("Could not do mode write request to device"
+		    " (Geyser 3 mode)");
+		return -EIO;
+	}
+	return 0;
+}
+
+/* Reinitialise the device if it's a geyser 3 */
+static void atp_reinit(struct work_struct *work)
+{
+	struct atp *dev = container_of(work, struct atp, work);
+	struct usb_device *udev = dev->udev;
+
+	dev->idlecount = 0;
+	atp_geyser3_init(udev);
+}
+
 static int atp_calculate_abs(int *xy_sensors, int nb_sensors, int fact,
 			     int *z, int *fingers)
 {
@@ -418,6 +478,8 @@ static void atp_complete(struct urb* urb)
 	y = atp_calculate_abs(dev->xy_acc + ATP_XSENSORS, ATP_YSENSORS,
 			      ATP_YFACT, &y_z, &y_f);
 
+	input_report_key(dev->input, BTN_LEFT, dev->data[dev->datalen-1] & 1);
+
 	if (x && y) {
 		if (dev->x_old != -1) {
 			x = (dev->x_old * 3 + x) >> 2;
@@ -449,10 +511,19 @@ static void atp_complete(struct urb* urb)
 
 		/* reset the accumulator on release */
 		memset(dev->xy_acc, 0, sizeof(dev->xy_acc));
-	}
 
-	input_report_key(dev->input, BTN_LEFT,
-			 !!dev->data[dev->datalen - 1]);
+		/* Geyser 3 will continue to send packets continually after
+		   the first touch unless reinitialised. Do so if it's been
+		   idle for a while in order to avoid waking the kernel up
+		   several hundred times a second */
+		if (atp_is_geyser_3(dev)) {
+			dev->idlecount++;
+			if (dev->idlecount == 10) {
+				dev->valid=0;
+				schedule_work (&dev->work);
+			}
+		}
+	}
 
 	input_sync(dev->input);
 
@@ -528,40 +599,10 @@ static int atp_probe(struct usb_interface *iface, const struct usb_device_id *id
 		dev->datalen = 81;
 
 	if (atp_is_geyser_3(dev)) {
-		/*
-		 * By default Geyser 3 device sends standard USB HID mouse
-		 * packets (Report ID 2). This code changes device mode, so it
-		 * sends raw sensor reports (Report ID 5).
-		 */
-		char data[8];
-		int size;
-
-		size = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
-			ATP_GEYSER3_MODE_READ_REQUEST_ID,
-			USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-			ATP_GEYSER3_MODE_REQUEST_VALUE,
-			ATP_GEYSER3_MODE_REQUEST_INDEX, &data, 8, 5000);
-
-		if (size != 8) {
-			err("Could not do mode read request from device"
-							" (Geyser 3 mode)");
+		/* switch to raw sensor mode */
+		if (atp_geyser3_init(udev))
 			goto err_free_devs;
-		}
-
-		/* Apply the mode switch */
-		data[0] = ATP_GEYSER3_MODE_VENDOR_VALUE;
 
-		size = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
-			ATP_GEYSER3_MODE_WRITE_REQUEST_ID,
-			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-			ATP_GEYSER3_MODE_REQUEST_VALUE,
-			ATP_GEYSER3_MODE_REQUEST_INDEX, &data, 8, 5000);
-
-		if (size != 8) {
-			err("Could not do mode write request to device"
-							" (Geyser 3 mode)");
-			goto err_free_devs;
-		}
 		printk("appletouch Geyser 3 inited.\n");
 	}
 
@@ -636,6 +677,8 @@ static int atp_probe(struct usb_interface *iface, const struct usb_device_id *id
 	/* save our data pointer in this interface device */
 	usb_set_intfdata(iface, dev);
 
+	INIT_WORK(&dev->work, atp_reinit);
+
 	return 0;
 
  err_free_buffer:
@@ -656,6 +699,7 @@ static void atp_disconnect(struct usb_interface *iface)
 
 	usb_set_intfdata(iface, NULL);
 	if (dev) {
+		cancel_work_sync(&dev->work);
 		usb_kill_urb(dev->urb);
 		input_unregister_device(dev->input);
 		usb_buffer_free(dev->udev, dev->datalen,

-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.

--=-cDCXNbFAcq/tnuaRA8ot
Content-Disposition: attachment; filename=appletouch.patch
Content-Type: text/x-patch; name=appletouch.patch; charset=ISO-8859-15
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvaW5wdXQvbW91c2UvYXBwbGV0b3VjaC5jIGIvZHJpdmVycy9p
bnB1dC9tb3VzZS9hcHBsZXRvdWNoLmMNCmluZGV4IGUzMjE1MjYuLjA0MjYwNTQgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL2lucHV0L21vdXNlL2FwcGxldG91Y2guYw0KKysrIGIvZHJpdmVycy9pbnB1
dC9tb3VzZS9hcHBsZXRvdWNoLmMNCkBAIC0xNTUsNiArMTU1LDggQEAgc3RydWN0IGF0cCB7DQog
CWludAkJCXh5X2FjY1tBVFBfWFNFTlNPUlMgKyBBVFBfWVNFTlNPUlNdOw0KIAlpbnQJCQlvdmVy
Zmxvd3dhcm47CS8qIG92ZXJmbG93IHdhcm5pbmcgcHJpbnRlZD8gKi8NCiAJaW50CQkJZGF0YWxl
bjsJLyogc2l6ZSBvZiBhbiBVU0IgdXJiIHRyYW5zZmVyICovDQorCWludCAgICAgICAgICAgICAg
ICAgICAgIGlkbGVjb3VudDsgICAgICAvKiBudW1iZXIgb2YgZW1wdHkgcGFja2V0cyAqLw0KKwlz
dHJ1Y3Qgd29ya19zdHJ1Y3QgICAgICB3b3JrOw0KIH07DQogDQogI2RlZmluZSBkYmdfZHVtcCht
c2csIHRhYikgXA0KQEAgLTIwOCw2ICsyMTAsNjQgQEAgc3RhdGljIGlubGluZSBpbnQgYXRwX2lz
X2dleXNlcl8zKHN0cnVjdCBhdHAgKmRldikNCiAJCShwcm9kdWN0SWQgPT0gR0VZU0VSNF9KSVNf
UFJPRFVDVF9JRCk7DQogfQ0KIA0KKy8qDQorICogQnkgZGVmYXVsdCBHZXlzZXIgMyBkZXZpY2Ug
c2VuZHMgc3RhbmRhcmQgVVNCIEhJRCBtb3VzZQ0KKyAqIHBhY2tldHMgKFJlcG9ydCBJRCAyKS4g
VGhpcyBjb2RlIGNoYW5nZXMgZGV2aWNlIG1vZGUsIHNvIGl0DQorICogc2VuZHMgcmF3IHNlbnNv
ciByZXBvcnRzIChSZXBvcnQgSUQgNSkuDQorICovDQorc3RhdGljIGludCBhdHBfZ2V5c2VyM19p
bml0KHN0cnVjdCB1c2JfZGV2aWNlICp1ZGV2KQ0KK3sNCisJY2hhciBkYXRhWzhdOw0KKwlpbnQg
c2l6ZTsNCisJaW50IGk7DQorDQorCXNpemUgPSB1c2JfY29udHJvbF9tc2codWRldiwgdXNiX3Jj
dmN0cmxwaXBlKHVkZXYsIDApLA0KKwkJCSAgICAgICBBVFBfR0VZU0VSM19NT0RFX1JFQURfUkVR
VUVTVF9JRCwNCisJCQkgICAgICAgVVNCX0RJUl9JTiB8IFVTQl9UWVBFX0NMQVNTIHwgVVNCX1JF
Q0lQX0lOVEVSRkFDRSwNCisJCQkgICAgICAgQVRQX0dFWVNFUjNfTU9ERV9SRVFVRVNUX1ZBTFVF
LA0KKwkJCSAgICAgICBBVFBfR0VZU0VSM19NT0RFX1JFUVVFU1RfSU5ERVgsICZkYXRhLCA4LCA1
MDAwKTsNCisNCisNCisJaWYgKHNpemUgIT0gOCkgew0KKwkJcHJpbnRrKCJhcHBsZXRvdWNoIGF0
cF9nZXlzZXIzX2luaXQgUkVBRCBlcnJvclxuIik7DQorCQlmb3IgKGk9MDsgaTw4OyBpKyspDQor
CQkJcHJpbnRrKCJhcHBsZXRvdWNoWyVkXTogJWRcbiIsIGksIChpbnQpIGRhdGFbaV0pOw0KKw0K
KwkJZXJyKCJDb3VsZCBub3QgZG8gbW9kZSByZWFkIHJlcXVlc3QgZnJvbSBkZXZpY2UiDQorCQkg
ICAgIiAoR2V5c2VyIDMgbW9kZSkiKTsNCisJCXJldHVybiAtRUlPOw0KKwl9DQorDQorCS8qIEFw
cGx5IHRoZSBtb2RlIHN3aXRjaCAqLw0KKwlkYXRhWzBdID0gQVRQX0dFWVNFUjNfTU9ERV9WRU5E
T1JfVkFMVUU7DQorDQorCXNpemUgPSB1c2JfY29udHJvbF9tc2codWRldiwgdXNiX3NuZGN0cmxw
aXBlKHVkZXYsIDApLA0KKwkJCSAgICAgICBBVFBfR0VZU0VSM19NT0RFX1dSSVRFX1JFUVVFU1Rf
SUQsDQorCQkJICAgICAgIFVTQl9ESVJfT1VUIHwgVVNCX1RZUEVfQ0xBU1MgfCBVU0JfUkVDSVBf
SU5URVJGQUNFLA0KKwkJCSAgICAgICBBVFBfR0VZU0VSM19NT0RFX1JFUVVFU1RfVkFMVUUsDQor
CQkJICAgICAgIEFUUF9HRVlTRVIzX01PREVfUkVRVUVTVF9JTkRFWCwgJmRhdGEsIDgsIDUwMDAp
Ow0KKwkNCisJaWYgKHNpemUgIT0gOCkgew0KKwkJcHJpbnRrKCJhcHBsZXRvdWNoIGF0cF9nZXlz
ZXIzX2luaXQgV1JJVEUgZXJyb3JcbiIpOw0KKwkJZm9yIChpPTA7IGk8ODsgaSsrKQ0KKwkJCXBy
aW50aygiYXBwbGV0b3VjaFslZF06ICVkXG4iLCBpLCAoaW50KSBkYXRhW2ldKTsNCisJCWVycigi
Q291bGQgbm90IGRvIG1vZGUgd3JpdGUgcmVxdWVzdCB0byBkZXZpY2UiDQorCQkgICAgIiAoR2V5
c2VyIDMgbW9kZSkiKTsNCisJCXJldHVybiAtRUlPOw0KKwl9DQorCXJldHVybiAwOw0KK30NCisN
CisvKiBSZWluaXRpYWxpc2UgdGhlIGRldmljZSBpZiBpdCdzIGEgZ2V5c2VyIDMgKi8NCitzdGF0
aWMgdm9pZCBhdHBfcmVpbml0KHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCit7DQorCXN0cnVj
dCBhdHAgKmRldiA9IGNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3QgYXRwLCB3b3JrKTsNCisJc3Ry
dWN0IHVzYl9kZXZpY2UgKnVkZXYgPSBkZXYtPnVkZXY7DQorDQorCWRldi0+aWRsZWNvdW50ID0g
MDsNCisJYXRwX2dleXNlcjNfaW5pdCh1ZGV2KTsNCit9DQorDQogc3RhdGljIGludCBhdHBfY2Fs
Y3VsYXRlX2FicyhpbnQgKnh5X3NlbnNvcnMsIGludCBuYl9zZW5zb3JzLCBpbnQgZmFjdCwNCiAJ
CQkgICAgIGludCAqeiwgaW50ICpmaW5nZXJzKQ0KIHsNCkBAIC00MTgsNiArNDc4LDggQEAgc3Rh
dGljIHZvaWQgYXRwX2NvbXBsZXRlKHN0cnVjdCB1cmIqIHVyYikNCiAJeSA9IGF0cF9jYWxjdWxh
dGVfYWJzKGRldi0+eHlfYWNjICsgQVRQX1hTRU5TT1JTLCBBVFBfWVNFTlNPUlMsDQogCQkJICAg
ICAgQVRQX1lGQUNULCAmeV96LCAmeV9mKTsNCiANCisJaW5wdXRfcmVwb3J0X2tleShkZXYtPmlu
cHV0LCBCVE5fTEVGVCwgZGV2LT5kYXRhW2Rldi0+ZGF0YWxlbi0xXSAmIDEpOw0KKw0KIAlpZiAo
eCAmJiB5KSB7DQogCQlpZiAoZGV2LT54X29sZCAhPSAtMSkgew0KIAkJCXggPSAoZGV2LT54X29s
ZCAqIDMgKyB4KSA+PiAyOw0KQEAgLTQ0OSwxMCArNTExLDE5IEBAIHN0YXRpYyB2b2lkIGF0cF9j
b21wbGV0ZShzdHJ1Y3QgdXJiKiB1cmIpDQogDQogCQkvKiByZXNldCB0aGUgYWNjdW11bGF0b3Ig
b24gcmVsZWFzZSAqLw0KIAkJbWVtc2V0KGRldi0+eHlfYWNjLCAwLCBzaXplb2YoZGV2LT54eV9h
Y2MpKTsNCi0JfQ0KIA0KLQlpbnB1dF9yZXBvcnRfa2V5KGRldi0+aW5wdXQsIEJUTl9MRUZULA0K
LQkJCSAhIWRldi0+ZGF0YVtkZXYtPmRhdGFsZW4gLSAxXSk7DQorCQkvKiBHZXlzZXIgMyB3aWxs
IGNvbnRpbnVlIHRvIHNlbmQgcGFja2V0cyBjb250aW51YWxseSBhZnRlcg0KKwkJICAgdGhlIGZp
cnN0IHRvdWNoIHVubGVzcyByZWluaXRpYWxpc2VkLiBEbyBzbyBpZiBpdCdzIGJlZW4NCisJCSAg
IGlkbGUgZm9yIGEgd2hpbGUgaW4gb3JkZXIgdG8gYXZvaWQgd2FraW5nIHRoZSBrZXJuZWwgdXAN
CisJCSAgIHNldmVyYWwgaHVuZHJlZCB0aW1lcyBhIHNlY29uZCAqLw0KKwkJaWYgKGF0cF9pc19n
ZXlzZXJfMyhkZXYpKSB7DQorCQkJZGV2LT5pZGxlY291bnQrKzsNCisJCQlpZiAoZGV2LT5pZGxl
Y291bnQgPT0gMTApIHsNCisJCQkJZGV2LT52YWxpZD0wOw0KKwkJCQlzY2hlZHVsZV93b3JrICgm
ZGV2LT53b3JrKTsNCisJCQl9DQorCQl9DQorCX0NCiANCiAJaW5wdXRfc3luYyhkZXYtPmlucHV0
KTsNCiANCkBAIC01MjgsNDAgKzU5OSwxMCBAQCBzdGF0aWMgaW50IGF0cF9wcm9iZShzdHJ1Y3Qg
dXNiX2ludGVyZmFjZSAqaWZhY2UsIGNvbnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkICppZA0KIAkJ
ZGV2LT5kYXRhbGVuID0gODE7DQogDQogCWlmIChhdHBfaXNfZ2V5c2VyXzMoZGV2KSkgew0KLQkJ
LyoNCi0JCSAqIEJ5IGRlZmF1bHQgR2V5c2VyIDMgZGV2aWNlIHNlbmRzIHN0YW5kYXJkIFVTQiBI
SUQgbW91c2UNCi0JCSAqIHBhY2tldHMgKFJlcG9ydCBJRCAyKS4gVGhpcyBjb2RlIGNoYW5nZXMg
ZGV2aWNlIG1vZGUsIHNvIGl0DQotCQkgKiBzZW5kcyByYXcgc2Vuc29yIHJlcG9ydHMgKFJlcG9y
dCBJRCA1KS4NCi0JCSAqLw0KLQkJY2hhciBkYXRhWzhdOw0KLQkJaW50IHNpemU7DQotDQotCQlz
aXplID0gdXNiX2NvbnRyb2xfbXNnKHVkZXYsIHVzYl9yY3ZjdHJscGlwZSh1ZGV2LCAwKSwNCi0J
CQlBVFBfR0VZU0VSM19NT0RFX1JFQURfUkVRVUVTVF9JRCwNCi0JCQlVU0JfRElSX0lOIHwgVVNC
X1RZUEVfQ0xBU1MgfCBVU0JfUkVDSVBfSU5URVJGQUNFLA0KLQkJCUFUUF9HRVlTRVIzX01PREVf
UkVRVUVTVF9WQUxVRSwNCi0JCQlBVFBfR0VZU0VSM19NT0RFX1JFUVVFU1RfSU5ERVgsICZkYXRh
LCA4LCA1MDAwKTsNCi0NCi0JCWlmIChzaXplICE9IDgpIHsNCi0JCQllcnIoIkNvdWxkIG5vdCBk
byBtb2RlIHJlYWQgcmVxdWVzdCBmcm9tIGRldmljZSINCi0JCQkJCQkJIiAoR2V5c2VyIDMgbW9k
ZSkiKTsNCisJCS8qIHN3aXRjaCB0byByYXcgc2Vuc29yIG1vZGUgKi8NCisJCWlmIChhdHBfZ2V5
c2VyM19pbml0KHVkZXYpKQ0KIAkJCWdvdG8gZXJyX2ZyZWVfZGV2czsNCi0JCX0NCi0NCi0JCS8q
IEFwcGx5IHRoZSBtb2RlIHN3aXRjaCAqLw0KLQkJZGF0YVswXSA9IEFUUF9HRVlTRVIzX01PREVf
VkVORE9SX1ZBTFVFOw0KIA0KLQkJc2l6ZSA9IHVzYl9jb250cm9sX21zZyh1ZGV2LCB1c2Jfc25k
Y3RybHBpcGUodWRldiwgMCksDQotCQkJQVRQX0dFWVNFUjNfTU9ERV9XUklURV9SRVFVRVNUX0lE
LA0KLQkJCVVTQl9ESVJfT1VUIHwgVVNCX1RZUEVfQ0xBU1MgfCBVU0JfUkVDSVBfSU5URVJGQUNF
LA0KLQkJCUFUUF9HRVlTRVIzX01PREVfUkVRVUVTVF9WQUxVRSwNCi0JCQlBVFBfR0VZU0VSM19N
T0RFX1JFUVVFU1RfSU5ERVgsICZkYXRhLCA4LCA1MDAwKTsNCi0NCi0JCWlmIChzaXplICE9IDgp
IHsNCi0JCQllcnIoIkNvdWxkIG5vdCBkbyBtb2RlIHdyaXRlIHJlcXVlc3QgdG8gZGV2aWNlIg0K
LQkJCQkJCQkiIChHZXlzZXIgMyBtb2RlKSIpOw0KLQkJCWdvdG8gZXJyX2ZyZWVfZGV2czsNCi0J
CX0NCiAJCXByaW50aygiYXBwbGV0b3VjaCBHZXlzZXIgMyBpbml0ZWQuXG4iKTsNCiAJfQ0KIA0K
QEAgLTYzNiw2ICs2NzcsOCBAQCBzdGF0aWMgaW50IGF0cF9wcm9iZShzdHJ1Y3QgdXNiX2ludGVy
ZmFjZSAqaWZhY2UsIGNvbnN0IHN0cnVjdCB1c2JfZGV2aWNlX2lkICppZA0KIAkvKiBzYXZlIG91
ciBkYXRhIHBvaW50ZXIgaW4gdGhpcyBpbnRlcmZhY2UgZGV2aWNlICovDQogCXVzYl9zZXRfaW50
ZmRhdGEoaWZhY2UsIGRldik7DQogDQorCUlOSVRfV09SSygmZGV2LT53b3JrLCBhdHBfcmVpbml0
KTsNCisNCiAJcmV0dXJuIDA7DQogDQogIGVycl9mcmVlX2J1ZmZlcjoNCkBAIC02NTYsNiArNjk5
LDcgQEAgc3RhdGljIHZvaWQgYXRwX2Rpc2Nvbm5lY3Qoc3RydWN0IHVzYl9pbnRlcmZhY2UgKmlm
YWNlKQ0KIA0KIAl1c2Jfc2V0X2ludGZkYXRhKGlmYWNlLCBOVUxMKTsNCiAJaWYgKGRldikgew0K
KwkJY2FuY2VsX3dvcmtfc3luYygmZGV2LT53b3JrKTsNCiAJCXVzYl9raWxsX3VyYihkZXYtPnVy
Yik7DQogCQlpbnB1dF91bnJlZ2lzdGVyX2RldmljZShkZXYtPmlucHV0KTsNCiAJCXVzYl9idWZm
ZXJfZnJlZShkZXYtPnVkZXYsIGRldi0+ZGF0YWxlbiwNCg==


--=-cDCXNbFAcq/tnuaRA8ot--
