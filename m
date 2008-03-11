Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbYCKA76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbYCKA76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbYCKA70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:59:26 -0400
Received: from ns.suse.de ([195.135.220.2]:60527 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445AbYCKA7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:59:25 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/6] USB: make USB-PERSIST work after every system sleep
Date: Mon, 10 Mar 2008 17:59:09 -0700
Message-Id: <1205197152-18146-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080311004239.GD17890@suse.de>
References: <20080311004239.GD17890@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1046) makes USB-PERSIST work more in accordance with
the documentation.  Currently it takes effect only in cases where the
root hub has lost power or been reset, but it is supposed to operate
whenever a power session was dropped during a system sleep.

A new hub_restart() routine carries out the duties required during a
reset or a reset-resume.  It checks to see whether occupied ports are
still enabled, and if they aren't then it clears the enable-change and
connect-change features (to prevent interference by khubd) and sets
the child device's reset_resume flag.  It also checks ports that are
supposed to be unoccupied to verify that the firmware hasn't left the
port in an enabled state.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/hub.c |  114 +++++++++++++++++++++++++++++++++--------------
 1 files changed, 80 insertions(+), 34 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 98c39fb..a0fd307 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -645,6 +645,81 @@ static void hub_stop(struct usb_hub *hub)
 	hub_quiesce(hub);
 }
 
+#define HUB_RESET		1
+#define HUB_RESUME		2
+#define HUB_RESET_RESUME	3
+
+#ifdef CONFIG_PM
+
+static void hub_restart(struct usb_hub *hub, int type)
+{
+	struct usb_device *hdev = hub->hdev;
+	int port1;
+
+	/* Check each of the children to see if they require
+	 * USB-PERSIST handling or disconnection.  Also check
+	 * each unoccupied port to make sure it is still disabled.
+	 */
+	for (port1 = 1; port1 <= hdev->maxchild; ++port1) {
+		struct usb_device *udev = hdev->children[port1-1];
+		int status = 0;
+		u16 portstatus, portchange;
+
+		if (!udev || udev->state == USB_STATE_NOTATTACHED) {
+			if (type != HUB_RESET) {
+				status = hub_port_status(hub, port1,
+						&portstatus, &portchange);
+				if (status == 0 && (portstatus &
+						USB_PORT_STAT_ENABLE))
+					clear_port_feature(hdev, port1,
+							USB_PORT_FEAT_ENABLE);
+			}
+			continue;
+		}
+
+		/* Was the power session lost while we were suspended? */
+		switch (type) {
+		case HUB_RESET_RESUME:
+			portstatus = 0;
+			portchange = USB_PORT_STAT_C_CONNECTION;
+			break;
+
+		case HUB_RESET:
+		case HUB_RESUME:
+			status = hub_port_status(hub, port1,
+					&portstatus, &portchange);
+			break;
+		}
+
+		/* For "USB_PERSIST"-enabled children we must
+		 * mark the child device for reset-resume and
+		 * turn off the various status changes to prevent
+		 * khubd from disconnecting it later.
+		 */
+		if (USB_PERSIST && udev->persist_enabled && status == 0 &&
+				!(portstatus & USB_PORT_STAT_ENABLE)) {
+			if (portchange & USB_PORT_STAT_C_ENABLE)
+				clear_port_feature(hub->hdev, port1,
+						USB_PORT_FEAT_C_ENABLE);
+			if (portchange & USB_PORT_STAT_C_CONNECTION)
+				clear_port_feature(hub->hdev, port1,
+						USB_PORT_FEAT_C_CONNECTION);
+			udev->reset_resume = 1;
+		}
+
+		/* Otherwise for a reset_resume we must disconnect the child,
+		 * but as we may not lock the child device here
+		 * we have to do a "logical" disconnect.
+		 */
+		else if (type == HUB_RESET_RESUME)
+			hub_port_logical_disconnect(hub, port1);
+	}
+
+	hub_activate(hub);
+}
+
+#endif	/* CONFIG_PM */
+
 /* caller has locked the hub device */
 static int hub_pre_reset(struct usb_interface *intf)
 {
@@ -2016,49 +2091,20 @@ static int hub_suspend(struct usb_interface *intf, pm_message_t msg)
 
 static int hub_resume(struct usb_interface *intf)
 {
-	struct usb_hub		*hub = usb_get_intfdata (intf);
-
-	dev_dbg(&intf->dev, "%s\n", __FUNCTION__);
+	struct usb_hub *hub = usb_get_intfdata(intf);
 
-	/* tell khubd to look for changes on this hub */
-	hub_activate(hub);
+	dev_dbg(&intf->dev, "%s\n", __func__);
+	hub_restart(hub, HUB_RESUME);
 	return 0;
 }
 
 static int hub_reset_resume(struct usb_interface *intf)
 {
 	struct usb_hub *hub = usb_get_intfdata(intf);
-	struct usb_device *hdev = hub->hdev;
-	int port1;
 
+	dev_dbg(&intf->dev, "%s\n", __func__);
 	hub_power_on(hub);
-
-	for (port1 = 1; port1 <= hdev->maxchild; ++port1) {
-		struct usb_device *child = hdev->children[port1-1];
-
-		if (child) {
-
-			/* For "USB_PERSIST"-enabled children we must
-			 * mark the child device for reset-resume and
-			 * turn off the connect-change status to prevent
-			 * khubd from disconnecting it later.
-			 */
-			if (USB_PERSIST && child->persist_enabled) {
-				child->reset_resume = 1;
-				clear_port_feature(hdev, port1,
-						USB_PORT_FEAT_C_CONNECTION);
-
-			/* Otherwise we must disconnect the child,
-			 * but as we may not lock the child device here
-			 * we have to do a "logical" disconnect.
-			 */
-			} else {
-				hub_port_logical_disconnect(hub, port1);
-			}
-		}
-	}
-
-	hub_activate(hub);
+	hub_restart(hub, HUB_RESET_RESUME);
 	return 0;
 }
 
-- 
1.5.4.3

