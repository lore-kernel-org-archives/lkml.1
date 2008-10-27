Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYJ0V3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYJ0V3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 17:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYJ0V3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 17:29:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47612 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbYJ0V3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 17:29:33 -0400
Date: Mon, 27 Oct 2008 23:29:31 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
cc: pavel@suse.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] w35und: usb_put_dev() is missing from wb35_disconnect()
Message-ID: <Pine.LNX.4.64.0810272328430.8946@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The wb35_probe() function does usb_get_dev() so add a missing usb_put_dev() to
the wb35_disconnect() function. Also fix error handling paths in wb35_probe()
to call usb_put_dev() as well.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/linux/wbusb.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/winbond/linux/wbusb.c b/drivers/staging/winbond/linux/wbusb.c
index 582ede4..128b70a 100644
--- a/drivers/staging/winbond/linux/wbusb.c
+++ b/drivers/staging/winbond/linux/wbusb.c
@@ -277,6 +277,7 @@ error_free_hw:
 error_free_adapter:
 	kfree(adapter);
 error:
+	usb_put_dev(udev);
 	return err;
 }
 
@@ -310,12 +311,12 @@ void packet_came(char *pRxBufferAddress, int PacketSize)
 
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
1.5.3.7

