Return-Path: <linux-kernel-owner+w=401wt.eu-S1755878AbZDPLn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbZDPLn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 07:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZDPLnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 07:43:17 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35647 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbZDPLnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 07:43:17 -0400
Subject: [PATCH] w35und: unregister device from the ieee80211 stack upon
 ->disconnect()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Greg KH <greg@kroah.com>
Cc: luoyi.ly@gmail.com, sandro.bonazzola@gmail.com, pavel@ucw.cz,
       linux-kernel@vger.kernel.org
Date: Thu, 16 Apr 2009 14:43:14 +0300
Message-Id: <1239882194.28965.46.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: fix module removal

This patch fixes an oops when the w35und module is removed from the
kernel and added back.

Reported-by: luoyi <luoyi.ly@gmail.com>
Tested-by: Sandro Bonazzola <sandro.bonazzola@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
Greg, I think this should go into 2.6.30.

 drivers/staging/winbond/wbusb.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index f716b2e..7a7aa9a 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -386,7 +386,7 @@ static int wb35_probe(struct usb_interface *intf, const struct usb_device_id *id
 	if (err)
 		goto error_free_hw;
 
-	usb_set_intfdata(intf, priv);
+	usb_set_intfdata(intf, dev);
 
 	return 0;
 
@@ -415,10 +415,15 @@ static void wb35_hw_halt(struct wbsoft_priv *adapter)
 
 static void wb35_disconnect(struct usb_interface *intf)
 {
-	struct wbsoft_priv *priv = usb_get_intfdata(intf);
+	struct ieee80211_hw *hw = usb_get_intfdata(intf);
+	struct wbsoft_priv *priv = hw->priv;
 
 	wb35_hw_halt(priv);
 
+	ieee80211_stop_queues(hw);
+	ieee80211_unregister_hw(hw);
+	ieee80211_free_hw(hw);
+
 	usb_set_intfdata(intf, NULL);
 	usb_put_dev(interface_to_usbdev(intf));
 }
-- 
1.5.4.3




