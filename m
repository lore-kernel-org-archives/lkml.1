Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580Ab0AZX7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab0AZX7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:59:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494Ab0AZX7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:59:37 -0500
Received: from kroah.org ([198.145.64.141]:35240 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754466Ab0AZXn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:43:29 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:25 2010
Message-Id: <20100126233925.611466380@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Kosina <jkosina@suse.cz>
Subject: [36/98] HID: fixup quirk for NCR devices
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 5b915d9e6dc3d22fedde91dfef1cb1a8fa9a1870 upstream.

NCR devices are terminally broken by design -- they claim themselves to contain
proper input applications in their HID report descriptor, but behave very badly
if treated in standard way.

According to NCR developers, the devices get confused when queried for reports
in a standard way, rendering them unusable.

NCR is shipping application called "RPSL" that can be used to drive these
devices through hiddev, under the assumption that in-kernel driver doesn't
perform initial report query.
If it does, neither in-kernel nor hiddev-based driver can operate with these
devices any more.

Introduce a quirk that skips the report query for all NCR devices. The previous
NOGET quirk was wrong and had been introduced because I misunderstood the nature
of brokenness of these devices.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hid/usbhid/hid-core.c   |    3 ++-
 drivers/hid/usbhid/hid-quirks.c |    2 +-
 include/linux/hid.h             |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -998,7 +998,8 @@ static int usbhid_start(struct hid_devic
 	usbhid->urbctrl->transfer_dma = usbhid->ctrlbuf_dma;
 	usbhid->urbctrl->transfer_flags |= (URB_NO_TRANSFER_DMA_MAP | URB_NO_SETUP_DMA_MAP);
 
-	usbhid_init_reports(hid);
+	if (!(hid->quirks & HID_QUIRK_NO_INIT_REPORTS))
+		usbhid_init_reports(hid);
 
 	set_bit(HID_STARTED, &usbhid->iofl);
 
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -280,7 +280,7 @@ u32 usbhid_lookup_quirk(const u16 idVend
 	if (idVendor == USB_VENDOR_ID_NCR &&
 			idProduct >= USB_DEVICE_ID_NCR_FIRST &&
 			idProduct <= USB_DEVICE_ID_NCR_LAST)
-			return HID_QUIRK_NOGET;
+			return HID_QUIRK_NO_INIT_REPORTS;
 
 	down_read(&dquirks_rwsem);
 	bl_entry = usbhid_exists_dquirk(idVendor, idProduct);
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -312,6 +312,7 @@ struct hid_item {
 #define HID_QUIRK_MULTI_INPUT			0x00000040
 #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
 #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
+#define HID_QUIRK_NO_INIT_REPORTS		0x20000000
 
 /*
  * This is the global environment of the parser. This information is


