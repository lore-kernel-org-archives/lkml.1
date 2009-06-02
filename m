Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbZFBW0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbZFBW0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 18:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbZFBW0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 18:26:10 -0400
Received: from Cpsmtpm-eml108.kpnxchange.com ([195.121.3.12]:56052 "EHLO
	CPSMTPM-EML108.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894AbZFBW0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 18:26:08 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v2] usb: avoid PM error messages during resume if a device was disconnected
Date: Wed, 3 Jun 2009 00:26:07 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-usb@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906021745380.3960-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906021745380.3960-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906030026.08399.elendil@planet.nl>
X-OriginalArrivalTime: 02 Jun 2009 22:26:08.0825 (UTC) FILETIME=[2069E290:01C9E3D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if a laptop is suspended e.g. while docked and then resumed after
undocking it, the following errors get generated because the USB hub in the
docking station and the devices connected to it are no longer available:
pm_op(): usb_dev_resume+0x0/0x10 returns -19
PM: Device 1-2 failed to resume: error -19
pm_op(): usb_dev_resume+0x0/0x10 returns -19
PM: Device 1-2.2 failed to resume: error -19
pm_op(): usb_dev_resume+0x0/0x10 returns -19
PM: Device 1-2.3 failed to resume: error -19

As the removal of USB devices while a system is suspended is a relatively
common use case and in most cases not an error, just return success on
-ENODEV. The user gets informed anyway as the USB subsystem generates
regular disconnect messages for the devices shortly afterwards:
usb 1-2: USB disconnect, address 3
usb 1-2.2: USB disconnect, address 4
usblp0: removed
usb 1-2.3: USB disconnect, address 5

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---

On Tuesday 02 June 2009, Alan Stern wrote:
> If we change -ENODEV to 0, the change should be made in usb_resume()
> rather than usb_external_resume_device().

Like so?
Agreed that it's cleaner and tested that it works just as well :-)

Cheers,
FJP

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index d0a21a5..0aaf26e 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1762,6 +1762,7 @@ int usb_suspend(struct device *dev, pm_message_t msg)
 int usb_resume(struct device *dev, pm_message_t msg)
 {
 	struct usb_device	*udev;
+	int			status;
 
 	udev = to_usb_device(dev);
 
@@ -1771,7 +1772,14 @@ int usb_resume(struct device *dev, pm_message_t msg)
 	 */
 	if (udev->skip_sys_resume)
 		return 0;
-	return usb_external_resume_device(udev, msg);
+	status = usb_external_resume_device(udev, msg);
+
+	/* Avoid PM error messages for devices disconnected while suspended
+	 * as we'll display regular disconnect messages just a bit later.
+	 */
+	if (status == -ENODEV)
+		return 0;
+	return status;
 }
 
 #endif /* CONFIG_PM */
