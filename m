Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbXDBFZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbXDBFZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 01:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbXDBFZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 01:25:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbXDBFZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 01:25:53 -0400
Date: Sun, 1 Apr 2007 22:24:10 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: dtor@insightbb.com, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, stuart_hayes@dell.com, zaitcev@redhat.com
Subject: Re: usb hid: reset NumLock
Message-Id: <20070401222410.2ff7ecd7.zaitcev@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0703312122100.6040@jikos.suse.cz>
References: <20070330105924.01a16dd6.zaitcev@redhat.com>
	<Pine.LNX.4.64.0703312122100.6040@jikos.suse.cz>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2007 21:35:19 +0200 (CEST), Jiri Kosina <jkosina@suse.cz> wrote:

> I think I see an issue here. Imagine that you boot a system initially with 
> one keyboard connected (usb, ps/2, doesn't matter), and after some time 
> you connect second USB keyboard (the NumLock is 'on' on the first keyboard 
> when you connect the second one).

OK. I toyed with a return to the Stuart's idea: defeat filtering
somehow, but it wasn't working well, too much duplication. So, I created
a clone of hidinput_find_field() instead. It's still an annoying
duplication, but a lesser one, I think.

diff --git a/drivers/usb/input/hid-core.c b/drivers/usb/input/hid-core.c
index ef09952..7338e81 100644
--- a/drivers/usb/input/hid-core.c
+++ b/drivers/usb/input/hid-core.c
@@ -548,6 +548,28 @@ void usbhid_init_reports(struct hid_device *hid)
 		warn("timeout initializing reports");
 }
 
+/*
+ * Reset LEDs which BIOS might have left on.
+ */
+static int hid_find_field_early(struct hid_device *hid, unsigned int page,
+    unsigned int hid_code, struct hid_field **field);
+
+static void usbhid_set_leds(struct hid_device *hid)
+{
+	struct hid_field *field;
+	int offset;
+
+	/*
+	 * Just reset Num Lock for now.
+	 * This is called for non-keyboard devices too, so no printk if field
+	 * is not found.
+	 */
+	if ((offset = hid_find_field_early(hid, HID_UP_LED, 0x01, &field)) != -1) {
+		hid_set_field(field, offset, 0);
+		usbhid_submit_report(hid, field->report, USB_DIR_OUT);
+	}
+}
+
 #define USB_VENDOR_ID_GTCO		0x078c
 #define USB_DEVICE_ID_GTCO_90		0x0090
 #define USB_DEVICE_ID_GTCO_100		0x0100
@@ -971,6 +993,30 @@ static void hid_find_max_report(struct hid_device *hid, unsigned int type, int *
 	}
 }
 
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
 static int hid_alloc_buffers(struct usb_device *dev, struct hid_device *hid)
 {
 	struct usbhid_device *usbhid = hid->driver_data;
@@ -1314,6 +1360,8 @@ static int hid_probe(struct usb_interface *intf, const struct usb_device_id *id)
 
 	usbhid_init_reports(hid);
 	hid_dump_device(hid);
+	/* if (hid->quirks & HID_QUIRK_RESET_LEDS) */
+	usbhid_set_leds(hid);
 
 	if (!hidinput_connect(hid))
 		hid->claimed |= HID_CLAIMED_INPUT;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index d26b08f..f592f01 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -267,6 +267,7 @@ struct hid_item {
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00020000
 #define HID_QUIRK_IGNORE_MOUSE			0x00040000
 #define HID_QUIRK_SONY_PS3_CONTROLLER		0x00080000
+#define HID_QUIRK_RESET_LEDS			0x00100000
 
 /*
  * This is the global environment of the parser. This information is

> > +++ b/include/linux/hid.h
> > @@ -267,6 +267,7 @@ struct hid_item {
> >  #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00020000
> >  #define HID_QUIRK_IGNORE_MOUSE			0x00040000
> >  #define HID_QUIRK_SONY_PS3_CONTROLLER		0x00080000
> > +#define HID_QUIRK_RESET_LEDS			0x00100000
> 
> I think this is not worth a quirk - when we get it working properly, why 
> not do it unconditionally for all keyboards?

The main reason is, I have a USB-to-PS/2 adapter where early acces to
LEDs does not work. Apparently, it is still initializing the PS/2 part
when it reports to USB that it's ready, and needs a delay. So, I figured
that I may be breaking some odd devices. Some may crash or whatnot.
This is why I asked Stuart to get me VID/PID for involved keyboards.

> > URL with details, discussion, rejected patch to read BIOS byte at 0x417:
> > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=228674
> 
> "You are not authorized to access bug #228674. To see this bug, you must 
> first log in to an account with the appropriate permissions." 

Sorry. I missed that the bug has access flags set...

-- Pete
