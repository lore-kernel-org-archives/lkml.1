Return-Path: <linux-kernel-owner+w=401wt.eu-S1764271AbXHVJPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764271AbXHVJPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760844AbXHVI5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:57:38 -0400
Received: from 1wt.eu ([62.212.114.60]:2195 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758038AbXHVI5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:57:36 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822083951.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:38:58 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 14/58] USB: fix warning caused by autosuspend counter going negative
Content-Disposition: inline; filename=0014-USB-fix-warning-caused-by-autosuspend-counter-going.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch (as937) fixes a minor bug in the autosuspend usage-counting
code.  Each hub's usage counter keeps track of the number of
unsuspended children.  However the current driver increments the
counter after registering a new child, by which time the child may
already have been suspended and caused the counter to go negative.
The obvious solution is to increment the counter before registering
the child.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/core/hub.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 8ddeed3..d5890d5 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1356,6 +1356,10 @@ static int __usb_new_device(void *void_data)
 	}
 #endif
 
+	/* Increment the parent's count of unsuspended children */
+	if (udev->parent)
+		usb_autoresume_device(udev->parent);
+
 	/* Register the device.  The device driver is responsible
 	 * for adding the device files to usbfs and sysfs and for
 	 * configuring the device.
@@ -1363,13 +1367,11 @@ static int __usb_new_device(void *void_data)
 	err = device_add (&udev->dev);
 	if (err) {
 		dev_err(&udev->dev, "can't device_add, error %d
", err);
+		if (udev->parent)
+			usb_autosuspend_device(udev->parent);
 		goto fail;
 	}
 
-	/* Increment the parent's count of unsuspended children */
-	if (udev->parent)
-		usb_autoresume_device(udev->parent);
-
 exit:
 	module_put(THIS_MODULE);
 	return err;
-- 
1.5.2.5

-- 
