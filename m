Return-Path: <linux-kernel-owner+w=401wt.eu-S1752231AbXBFPbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbXBFPbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 10:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932099AbXBFPbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 10:31:20 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47142 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752231AbXBFPbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 10:31:19 -0500
Date: Tue, 6 Feb 2007 10:31:18 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@osdl.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB: fix concurrent buffer access in the hub driver
Message-ID: <Pine.LNX.4.44L0.0702061028530.3421-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as849) fixes a bug in the hub driver.  A single
pre-allocated buffer is used for all port status reads, but nothing
guarantees exclusive use of the buffer.  A mutex is added to provide
this guarantee.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

This patch should go into Greg's USB development tree and -mm as well as
into the 2.6.20-stable queue (submitted separately).  It fixes the "usb
somehow broken (CONFIG_USB_SUSPEND)" bug reported by Prakash Punnoor.

Alan Stern



Index: usb-2.6/drivers/usb/core/hub.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/hub.c
+++ usb-2.6/drivers/usb/core/hub.c
@@ -44,6 +44,7 @@ struct usb_hub {
 		struct usb_hub_status	hub;
 		struct usb_port_status	port;
 	}			*status;	/* buffer for status reports */
+	struct mutex		status_mutex;	/* for the status buffer */
 
 	int			error;		/* last reported error */
 	int			nerrors;	/* track consecutive errors */
@@ -535,6 +536,7 @@ static int hub_hub_status(struct usb_hub
 {
 	int ret;
 
+	mutex_lock(&hub->status_mutex);
 	ret = get_hub_status(hub->hdev, &hub->status->hub);
 	if (ret < 0)
 		dev_err (hub->intfdev,
@@ -544,6 +546,7 @@ static int hub_hub_status(struct usb_hub
 		*change = le16_to_cpu(hub->status->hub.wHubChange); 
 		ret = 0;
 	}
+	mutex_unlock(&hub->status_mutex);
 	return ret;
 }
 
@@ -617,6 +620,7 @@ static int hub_configure(struct usb_hub 
 		ret = -ENOMEM;
 		goto fail;
 	}
+	mutex_init(&hub->status_mutex);
 
 	hub->descriptor = kmalloc(sizeof(*hub->descriptor), GFP_KERNEL);
 	if (!hub->descriptor) {
@@ -1394,6 +1398,7 @@ static int hub_port_status(struct usb_hu
 {
 	int ret;
 
+	mutex_lock(&hub->status_mutex);
 	ret = get_port_status(hub->hdev, port1, &hub->status->port);
 	if (ret < 4) {
 		dev_err (hub->intfdev,
@@ -1405,6 +1410,7 @@ static int hub_port_status(struct usb_hu
 		*change = le16_to_cpu(hub->status->port.wPortChange); 
 		ret = 0;
 	}
+	mutex_unlock(&hub->status_mutex);
 	return ret;
 }
 

