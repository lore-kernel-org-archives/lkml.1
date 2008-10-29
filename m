Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbYJ2Wtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbYJ2Wtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbYJ2Woc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:44:32 -0400
Received: from kroah.org ([198.145.64.141]:43780 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755446AbYJ2Wo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:44:26 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/49] Staging: w35und: usb_put_dev() is missing from wb35_disconnect()
Date: Wed, 29 Oct 2008 15:39:45 -0700
Message-Id: <1225320016-21803-18-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223832.GC21657@kroah.com>
References: <20081029223832.GC21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The wb35_probe() function does usb_get_dev() so add a missing usb_put_dev() to
the wb35_disconnect() function. Also fix error handling paths in wb35_probe()
to call usb_put_dev() as well.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/winbond/linux/wbusb.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
index eb11503..d9c3a16 100644
--- a/drivers/staging/winbond/linux/wbusb.c
+++ b/drivers/staging/winbond/linux/wbusb.c
@@ -275,6 +275,7 @@ error_free_hw:
 error_free_adapter:
 	kfree(adapter);
 error:
+	usb_put_dev(udev);
 	return err;
 }
 
@@ -308,12 +309,12 @@ void packet_came(char *pRxBufferAddress, int PacketSize)
 
 static void wb35_disconnect(struct usb_interface *intf)
 {
-	struct wb35_adapter * adapter = usb_get_intfdata(intf);
-	usb_set_intfdata(intf, NULL);
+	struct wb35_adapter *adapter = usb_get_intfdata(intf);
 
-	// Card remove
 	WbWlanHalt(adapter);
 
+	usb_set_intfdata(intf, NULL);
+	usb_put_dev(interface_to_usbdev(intf));
 }
 
 static struct usb_driver wb35_driver = {
-- 
1.6.0.2

