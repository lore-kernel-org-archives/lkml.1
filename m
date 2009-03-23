Return-Path: <linux-kernel-owner+w=401wt.eu-S1759170AbZCWVMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbZCWVMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 17:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbZCWVLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 17:11:55 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:58750 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392AbZCWVLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:11:54 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-usb@vger.kernel.org
Subject: [PATCH] usb: avoid PM error messages during resume if a device was disconnected
Date: Mon, 23 Mar 2009 22:11:49 +0100
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903232211.51154.elendil@planet.nl>
X-OriginalArrivalTime: 23 Mar 2009 21:11:52.0067 (UTC) FILETIME=[FCA65530:01C9ABFB]
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

I've walked through the code and AFAICT just returning 0 does not make any
difference for the PM core code.

In a first version of this patch I had the following included just before
the 'return 0':
	pr_info("usb %s: failed to resume: no longer connected\n",
						dev_name(&udev->dev));

Problem with that was that the message got printed twice for each device,
once for .resume and once for .complete. Given that the disconnects are
reported shortly after anyway, I decided the simpler patch might do just
as well.

Cheers,
FJP

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index d0a21a5..97ea69b 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -1727,6 +1727,10 @@ int usb_external_resume_device(struct usb_device *udev, pm_message_t msg)
 	status = usb_resume_both(udev, msg);
 	udev->last_busy = jiffies;
 	usb_pm_unlock(udev);
+
+	if (status == -ENODEV)
+		return 0;
+
 	if (status == 0)
 		do_unbind_rebind(udev, DO_REBIND);
 
