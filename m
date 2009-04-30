Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbZD3AKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbZD3AKA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbZD3AJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:09:49 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:38752 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbZD3AJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:09:48 -0400
X-IronPort-AV: E=Sophos;i="4.40,269,1238976000"; 
   d="scan'208";a="178788300"
Date: Wed, 29 Apr 2009 17:09:48 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: linux-usb@vger.kernel.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] USB: Provide USB boot device availability notification
Message-ID: <20090430000948.GA3408@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-3; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

Use boot device discovery infrastructure to report availability of USB
devices.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: David VomLehn <dvomlehn@cisco.com>
---
 drivers/usb/core/hub.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index be86ae3..01a9b76 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -37,6 +37,20 @@
 #endif
 #endif
 
+/* The mask of possible USB boot devices depends on what drivers and
+ * options have been configured into the kernel.  There are too many
+ * USB network config options to list here, so just assume it is always
+ * possible to have a USB network device.
+ */
+static int usb_bootdev_mask = 0
+#ifdef CONFIG_USB_SERIAL_CONSOLE
+				| BOOTDEV_CONSOLE_MASK
+#endif
+#if defined(CONFIG_USB_STORAGE) | defined(CONFIG_BLK_DEV_UB)
+				| BOOTDEV_BLOCK_MASK
+#endif
+				| BOOTDEV_NETDEV_MASK;
+
 struct usb_hub {
 	struct device		*intfdev;	/* the "interface" device */
 	struct usb_device	*hdev;
@@ -73,6 +87,7 @@ struct usb_hub {
 	unsigned		limited_power:1;
 	unsigned		quiescing:1;
 	unsigned		disconnected:1;
+	unsigned		probing:1;
 
 	unsigned		has_indicators:1;
 	u8			indicator[USB_MAXCHILDREN];
@@ -1079,6 +1094,9 @@ static int hub_configure(struct usb_hub *hub,
 	if (hub->has_indicators && blinkenlights)
 		hub->indicator [0] = INDICATOR_CYCLE;
 
+	hub->probing = 1;
+	bootdev_found(usb_bootdev_mask);
+
 	hub_activate(hub, HUB_INIT);
 	return 0;
 
@@ -1124,6 +1142,9 @@ static void hub_disconnect(struct usb_interface *intf)
 	usb_buffer_free(hub->hdev, sizeof(*hub->buffer), hub->buffer,
 			hub->buffer_dma);
 
+	if (hub->probing)
+		bootdev_probe_done(usb_bootdev_mask);
+
 	kref_put(&hub->kref, hub_release);
 }
 
@@ -3135,6 +3156,11 @@ static void hub_events(void)
 						portstatus, portchange);
 		} /* end for i */
 
+		if (hub->probing) {
+			hub->probing = 0;
+			bootdev_probe_done(usb_bootdev_mask);
+		}
+
 		/* deal with hub status changes */
 		if (test_and_clear_bit(0, hub->event_bits) == 0)
 			;	/* do nothing */
