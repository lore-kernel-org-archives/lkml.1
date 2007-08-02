Return-Path: <linux-kernel-owner+w=401wt.eu-S1760281AbXHBX4a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760281AbXHBX4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:56:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbXHBX4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:56:22 -0400
Received: from 78-32-9-130.no-dns-yet.enta.net ([78.32.9.130]:38160 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbXHBX4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:56:21 -0400
Date: Fri, 3 Aug 2007 00:56:13 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-usb-devel@lists.sourceforge.net
Cc: gregkh@suse.de, amitk@ubuntu.com, linux-kernel@vger.kernel.org
Message-ID: <20070802235613.GA9487@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: [PATCH] USB: Only enable autosuspend by default on certain device classes
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We're seeing a large number of problems with devices not appreciating 
USB autosuspend, especially printers and scanners. According to 
http://www.microsoft.com/whdc/system/bus/USB/USBFAQ_intro.mspx only a 
subset of drivers support it in Windows XP, meaning that most devices 
are probably untested in this situation. This patch alters the behaviour 
to match that of Windows. Userspace can still whitelist devices as 
appropriate, and the set of classes supporting autosuspend probably 
covers pretty much every driver likely to be found on any portable 
device.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

---

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index caaa46f..12ba789 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1278,6 +1278,22 @@ int usb_new_device(struct usb_device *udev)
 {
 	int err;
 
+#ifdef CONFIG_USB_SUSPEND
+	/* Disable autosuspend for most devices - Windows only enables it
+	   for a small subset of classes, so most hardware hasn't been tested
+	   with it. Userspace can always reenable at a later point */
+
+	switch (udev->descriptor.bDeviceClass) {
+	case USB_CLASS_HID:
+	case USB_CLASS_COMM:
+	case USB_CLASS_WIRELESS_CONTROLLER:
+	case USB_CLASS_HUB:
+		break;
+	default:
+		udev->autosuspend_disabled = 1;
+	}
+#endif
+
 	/* Determine quirks */
 	usb_detect_quirks(udev);


-- 
Matthew Garrett | mjg59@srcf.ucam.org
