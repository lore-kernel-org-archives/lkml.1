Return-Path: <linux-kernel-owner+w=401wt.eu-S1767232AbXDEUkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767232AbXDEUkS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 16:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767301AbXDEUkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 16:40:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767232AbXDEUkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 16:40:15 -0400
Date: Thu, 5 Apr 2007 13:38:40 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dtor@insightbb.com>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       stuart_hayes@dell.com, zaitcev@redhat.com
Subject: Re: usb hid: reset NumLock
Message-Id: <20070405133840.0d67303f.zaitcev@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0704051049010.4173@jikos.suse.cz>
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
	<20070402161225.2866c002.zaitcev@redhat.com>
	<Pine.LNX.4.64.0704031046320.3808@jikos.suse.cz>
	<200704042324.56345.dtor@insightbb.com>
	<Pine.LNX.4.64.0704051049010.4173@jikos.suse.cz>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On a certain keyboard, when BIOS sets NumLock LED on, it survives the takeover
by Linux and thus confuses users.

Eating of an increasibly scarce quirk bit is unfortunate. We do it for safety,
given the history of nervous input devices which crash if anything unusual
happens.

Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>

---

diff --git a/drivers/usb/input/hid-core.c b/drivers/usb/input/hid-core.c
index 827a75a..23b1e70 100644
--- a/drivers/usb/input/hid-core.c
+++ b/drivers/usb/input/hid-core.c
@@ -545,6 +545,45 @@ void usbhid_init_reports(struct hid_device *hid)
 		warn("timeout initializing reports");
 }
 
+/*
+ * Reset LEDs which BIOS might have left on. For now, just NumLock (0x01).
+ */
+
+static int hid_find_field_early(struct hid_device *hid, unsigned int page,
+    unsigned int hid_code, struct hid_field **pfield)
+{
+	struct hid_report *report;
+	struct hid_field *field;
+	struct hid_usage *usage;
+	int i, j;
+
+	list_for_each_entry(report, &hid->report_enum[HID_OUTPUT_REPORT].report_list, list) {
+		for (i = 0; i < report->maxfield; i++) {
+			field = report->field[i];
+			for (j = 0; j < field->maxusage; j++) {
+				usage = &field->usage[j];
+				if ((usage->hid & HID_USAGE_PAGE) == page &&
+				    (usage->hid & 0xFFFF) == hid_code) {
+					*pfield = field;
+					return j;
+				}
+			}
+		}
+	}
+	return -1;
+}
+
+static void usbhid_set_leds(struct hid_device *hid)
+{
+	struct hid_field *field;
+	int offset;
+
+	if ((offset = hid_find_field_early(hid, HID_UP_LED, 0x01, &field)) != -1) {
+		hid_set_field(field, offset, 0);
+		usbhid_submit_report(hid, field->report, USB_DIR_OUT);
+	}
+}
+
 #define USB_VENDOR_ID_GTCO		0x078c
 #define USB_DEVICE_ID_GTCO_90		0x0090
 #define USB_DEVICE_ID_GTCO_100		0x0100
@@ -765,6 +804,9 @@ void usbhid_init_reports(struct hid_device *hid)
 #define USB_VENDOR_ID_SONY			0x054c
 #define USB_DEVICE_ID_SONY_PS3_CONTROLLER	0x0268
 
+#define USB_VENDOR_ID_DELL		0x413c
+#define USB_DEVICE_ID_DELL_W7658	0x2005
+
 /*
  * Alphabetically sorted blacklist by quirk type.
  */
@@ -947,6 +989,8 @@ static const struct hid_blacklist {
 
 	{ USB_VENDOR_ID_CIDC, 0x0103, HID_QUIRK_IGNORE },
 
+	{ USB_VENDOR_ID_DELL, USB_DEVICE_ID_DELL_W7658, HID_QUIRK_RESET_LEDS },
+
 	{ 0, 0 }
 };
 
@@ -1334,6 +1378,8 @@ static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	usbhid_init_reports(hid);
 	hid_dump_device(hid);
+	if (hid->quirks & HID_QUIRK_RESET_LEDS)
+		usbhid_set_leds(hid);
 
 	if (!hidinput_connect(hid))
 		hid->claimed |= HID_CLAIMED_INPUT;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 8c97d4d..3e8dcb0 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -269,6 +269,7 @@ struct hid_item {
 #define HID_QUIRK_SONY_PS3_CONTROLLER		0x00080000
 #define HID_QUIRK_LOGITECH_S510_DESCRIPTOR	0x00100000
 #define HID_QUIRK_DUPLICATE_USAGES		0x00200000
+#define HID_QUIRK_RESET_LEDS			0x00400000
 
 /*
  * This is the global environment of the parser. This information is
