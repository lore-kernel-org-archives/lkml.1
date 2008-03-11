Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbYCKA7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbYCKA7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbYCKA7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:59:22 -0400
Received: from mx1.suse.de ([195.135.220.2]:60521 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbYCKA7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:59:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/6] USB: reorganize code in hub.c
Date: Mon, 10 Mar 2008 17:59:08 -0700
Message-Id: <1205197152-18146-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <20080311004239.GD17890@suse.de>
References: <20080311004239.GD17890@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1045) reorganizes some code in the hub driver.
hub_port_status() is moved earlier in the file, and a new hub_stop()
routine is created to do the work currently in hub_preset() (i.e.,
disconnect all child devices and quiesce the hub).

There are no functional changes.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/core/hub.c |   58 ++++++++++++++++++++++++++---------------------
 1 files changed, 32 insertions(+), 26 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index acd4658..98c39fb 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -334,6 +334,27 @@ static int get_port_status(struct usb_device *hdev, int port1,
 	return status;
 }
 
+static int hub_port_status(struct usb_hub *hub, int port1,
+		u16 *status, u16 *change)
+{
+	int ret;
+
+	mutex_lock(&hub->status_mutex);
+	ret = get_port_status(hub->hdev, port1, &hub->status->port);
+	if (ret < 4) {
+		dev_err(hub->intfdev,
+			"%s failed (err = %d)\n", __func__, ret);
+		if (ret >= 0)
+			ret = -EIO;
+	} else {
+		*status = le16_to_cpu(hub->status->port.wPortStatus);
+		*change = le16_to_cpu(hub->status->port.wPortChange);
+		ret = 0;
+	}
+	mutex_unlock(&hub->status_mutex);
+	return ret;
+}
+
 static void kick_khubd(struct usb_hub *hub)
 {
 	unsigned long	flags;
@@ -611,9 +632,8 @@ static void hub_port_logical_disconnect(struct usb_hub *hub, int port1)
 }
 
 /* caller has locked the hub device */
-static int hub_pre_reset(struct usb_interface *intf)
+static void hub_stop(struct usb_hub *hub)
 {
-	struct usb_hub *hub = usb_get_intfdata(intf);
 	struct usb_device *hdev = hub->hdev;
 	int i;
 
@@ -623,6 +643,14 @@ static int hub_pre_reset(struct usb_interface *intf)
 			usb_disconnect(&hdev->children[i]);
 	}
 	hub_quiesce(hub);
+}
+
+/* caller has locked the hub device */
+static int hub_pre_reset(struct usb_interface *intf)
+{
+	struct usb_hub *hub = usb_get_intfdata(intf);
+
+	hub_stop(hub);
 	return 0;
 }
 
@@ -911,7 +939,7 @@ static void hub_disconnect(struct usb_interface *intf)
 
 	/* Disconnect all children and quiesce the hub */
 	hub->error = 0;
-	hub_pre_reset(intf);
+	hub_stop(hub);
 
 	usb_set_intfdata (intf, NULL);
 
@@ -1511,28 +1539,6 @@ out_authorized:
 }
 
 
-static int hub_port_status(struct usb_hub *hub, int port1,
-			       u16 *status, u16 *change)
-{
-	int ret;
-
-	mutex_lock(&hub->status_mutex);
-	ret = get_port_status(hub->hdev, port1, &hub->status->port);
-	if (ret < 4) {
-		dev_err (hub->intfdev,
-			"%s failed (err = %d)\n", __FUNCTION__, ret);
-		if (ret >= 0)
-			ret = -EIO;
-	} else {
-		*status = le16_to_cpu(hub->status->port.wPortStatus);
-		*change = le16_to_cpu(hub->status->port.wPortChange); 
-		ret = 0;
-	}
-	mutex_unlock(&hub->status_mutex);
-	return ret;
-}
-
-
 /* Returns 1 if @hub is a WUSB root hub, 0 otherwise */
 static unsigned hub_is_wusb(struct usb_hub *hub)
 {
@@ -2727,7 +2733,7 @@ static void hub_events(void)
 		/* If the hub has died, clean up after it */
 		if (hdev->state == USB_STATE_NOTATTACHED) {
 			hub->error = -ENODEV;
-			hub_pre_reset(intf);
+			hub_stop(hub);
 			goto loop;
 		}
 
-- 
1.5.4.3

