Return-Path: <linux-kernel-owner+w=401wt.eu-S933359AbXKOHBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359AbXKOHBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932522AbXKOGrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:47:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58039 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516AbXKOGrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:47:31 -0500
Date: Wed, 14 Nov 2007 22:44:57 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       linux-usb-devel@lists.sourceforge.net
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 20/40] USB: remove USB_QUIRK_NO_AUTOSUSPEND
Message-ID: <20071115064457.GU19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-remove-usb_quirk_no_autosuspend.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

patch a691efa9888e71232dfb4088fb8a8304ffc7b0f9 in mainline.

This patch (as995) cleans up the remains of the former NO_AUTOSUSPEND
quirk.  Since autosuspend is disabled by default, we will let
userspace worry about which devices can safely be suspended.  Thus the
lengthy series of quirk entries is no longer needed, and neither is
the quirk ID.  I suppose someone might eventually run across a hub
that can't be suspended; let's ignore the possibility for now.

The patch also cleans up the hasty way in which autosuspend gets
disabled.  Setting udev->autosuspend_delay to -1 wasn't quite right,
because the value is always supposed to be a multiple of HZ.  It's
better to leave the delay value alone and set autosuspend_disabled,
which is what the quirk routine used to do.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/quirks.c  |   81 ---------------------------------------------
 include/linux/usb/quirks.h |    7 +--
 2 files changed, 3 insertions(+), 85 deletions(-)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -32,52 +32,6 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0204, 0x6025), .driver_info = USB_QUIRK_RESET_RESUME },
 	/* HP 5300/5370C scanner */
 	{ USB_DEVICE(0x03f0, 0x0701), .driver_info = USB_QUIRK_STRING_FETCH_255 },
-	/* Hewlett-Packard PhotoSmart 720 / PhotoSmart 935 (storage) */
-	{ USB_DEVICE(0x03f0, 0x4002), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-
-	/* SGS Thomson Microelectronics 4in1 card reader */
-	{ USB_DEVICE(0x0483, 0x0321), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-
-	/* Acer Peripherals Inc. (now BenQ Corp.) Prisa 640BU */
-	{ USB_DEVICE(0x04a5, 0x207e), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Benq S2W 3300U */
-	{ USB_DEVICE(0x04a5, 0x20b0), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Canon, Inc. CanoScan N1240U/LiDE30 */
-	{ USB_DEVICE(0x04a9, 0x220e), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Canon, Inc. CanoScan N650U/N656U */
-	{ USB_DEVICE(0x04a9, 0x2206), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Canon, Inc. CanoScan 1220U */
-	{ USB_DEVICE(0x04a9, 0x2207), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Canon, Inc. CanoScan N670U/N676U/LiDE 20 */
-	{ USB_DEVICE(0x04a9, 0x220d), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* old Cannon scanner */
-	{ USB_DEVICE(0x04a9, 0x2220), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Seiko Epson Corp. Perfection 1200 */
-	{ USB_DEVICE(0x04b8, 0x0104), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Seiko Epson Corp. Perfection 660 */
-	{ USB_DEVICE(0x04b8, 0x0114), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Epson Perfection 1260 Photo */
-	{ USB_DEVICE(0x04b8, 0x011d), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Seiko Epson Corp - Perfection 1670 */
-	{ USB_DEVICE(0x04b8, 0x011f), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* EPSON Perfection 2480 */
-	{ USB_DEVICE(0x04b8, 0x0121), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Seiko Epson Corp.*/
-	{ USB_DEVICE(0x04b8, 0x0122), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Samsung ML-2010 printer */
-	{ USB_DEVICE(0x04e8, 0x326c), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Samsung ML-2510 Series printer */
-	{ USB_DEVICE(0x04e8, 0x327e), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Elsa MicroLink 56k (V.250) */
-	{ USB_DEVICE(0x05cc, 0x2267), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Ultima Electronics Corp.*/
-	{ USB_DEVICE(0x05d8, 0x4005), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-
-	/* Genesys USB-to-IDE */
-	{ USB_DEVICE(0x0503, 0x0702), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-
-	/* USB Graphical LCD - EEH Datalink GmbH */
-	{ USB_DEVICE(0x060c, 0x04eb), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
 
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
@@ -85,44 +39,15 @@ static const struct usb_device_id usb_qu
 	/* M-Systems Flash Disk Pioneers */
 	{ USB_DEVICE(0x08ec, 0x1000), .driver_info = USB_QUIRK_RESET_RESUME },
 
-	/* Agfa Snapscan1212u */
-	{ USB_DEVICE(0x06bd, 0x2061), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Seagate RSS LLC */
-	{ USB_DEVICE(0x0bc2, 0x3000), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	/* Umax [hex] Astra 3400U */
-	{ USB_DEVICE(0x1606, 0x0060), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-
 	/* Philips PSC805 audio device */
 	{ USB_DEVICE(0x0471, 0x0155), .driver_info = USB_QUIRK_RESET_RESUME },
 
-	/* Alcor multi-card reader */
-	{ USB_DEVICE(0x058f, 0x6366), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-
-	/* Canon EOS 5D in PC Connection mode */
-	{ USB_DEVICE(0x04a9, 0x3101), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-
-	/* RIM Blackberry */
-	{ USB_DEVICE(0x0fca, 0x0001), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	{ USB_DEVICE(0x0fca, 0x0004), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-	{ USB_DEVICE(0x0fca, 0x0006), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-
-	/* Apple iPhone */
-	{ USB_DEVICE(0x05ac, 0x1290), .driver_info = USB_QUIRK_NO_AUTOSUSPEND },
-
 	/* SKYMEDI USB_DRIVE */
 	{ USB_DEVICE(0x1516, 0x8628), .driver_info = USB_QUIRK_RESET_RESUME },
 
 	{ }  /* terminating entry must be last */
 };
 
-static void usb_autosuspend_quirk(struct usb_device *udev)
-{
-#ifdef	CONFIG_USB_SUSPEND
-	/* disable autosuspend, but allow the user to re-enable it via sysfs */
-	udev->autosuspend_disabled = 1;
-#endif
-}
-
 static const struct usb_device_id *find_id(struct usb_device *udev)
 {
 	const struct usb_device_id *id = usb_quirk_list;
@@ -149,13 +74,9 @@ void usb_detect_quirks(struct usb_device
 		dev_dbg(&udev->dev, "USB quirks for this device: %x\n",
 				udev->quirks);
 
-	/* do any special quirk handling here if needed */
-	if (udev->quirks & USB_QUIRK_NO_AUTOSUSPEND)
-		usb_autosuspend_quirk(udev);
-
 	/* By default, disable autosuspend for all non-hubs */
 #ifdef	CONFIG_USB_SUSPEND
 	if (udev->descriptor.bDeviceClass != USB_CLASS_HUB)
-		udev->autosuspend_delay = -1;
+		udev->autosuspend_disabled = 1;
 #endif
 }
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -4,11 +4,8 @@
  * belong here.
  */
 
-/* device must not be autosuspended */
-#define USB_QUIRK_NO_AUTOSUSPEND	0x00000001
-
 /* string descriptors must not be fetched using a 255-byte read */
-#define USB_QUIRK_STRING_FETCH_255	0x00000002
+#define USB_QUIRK_STRING_FETCH_255	0x00000001
 
 /* device can't resume correctly so reset it instead */
-#define USB_QUIRK_RESET_RESUME		0x00000004
+#define USB_QUIRK_RESET_RESUME		0x00000002

-- 
