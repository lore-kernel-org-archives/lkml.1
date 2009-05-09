Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbZEIDbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbZEIDbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbZEIDaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:30:05 -0400
Received: from kroah.org ([198.145.64.141]:41395 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753741AbZEIDaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:30:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Pavel Machek <pavel@ucw.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 1/4] Staging: w35und: unregister device from the ieee80211 stack upon ->disconnect()
Date: Fri,  8 May 2009 20:26:50 -0700
Message-Id: <1241839613-9243-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20090509032443.GC9000@kroah.com>
References: <20090509032443.GC9000@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/winbond/wbusb.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 9c3f943..3b2d528 100644
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
1.6.3

