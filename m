Return-Path: <linux-kernel-owner+w=401wt.eu-S966095AbXDBXON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966095AbXDBXON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 19:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966096AbXDBXON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 19:14:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966095AbXDBXOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 19:14:11 -0400
Date: Mon, 2 Apr 2007 16:12:25 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: dtor@insightbb.com, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stuart_hayes@dell.com, zaitcev@redhat.com
Subject: Re: usb hid: reset NumLock
Message-Id: <20070402161225.2866c002.zaitcev@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0704021641190.3808@jikos.suse.cz>
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
	<Pine.LNX.4.64.0703312122100.6040@jikos.suse.cz>
	<20070401222410.2ff7ecd7.zaitcev@redhat.com>
	<Pine.LNX.4.64.0704021641190.3808@jikos.suse.cz>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2007 16:48:24 +0200 (CEST), Jiri Kosina <jkosina@suse.cz> wrote:
> On Sun, 1 Apr 2007, Pete Zaitcev wrote:

> could you please change the order of the two functions, so that you 
> don't have to put the forward declaration here?
>[...]
> I'd say this is a little bit overcommented.
>[...]
> So as soon as you have the VIDs and PIDs of the hardware which 
> requires this, could you please update the patch and send it to me again?

How about this?

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

I wasn't sure where to place the function, so I just put it above its
user, to signify that it's special-casing. Also, it's unclear where
to put the quirk entry and defines. There's a comment saying that they
are sorted alphabetically by quirk, but apparently the order was violated
with more recent additions.

-- Pete
