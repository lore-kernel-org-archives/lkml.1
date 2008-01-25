Return-Path: <linux-kernel-owner+w=401wt.eu-S933048AbYAYImX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048AbYAYImX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761160AbYAYICH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:02:07 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:48254 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763763AbYAYICF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 03:02:05 -0500
From: "Mikael Starvik" <mikael.starvik@axis.com>
To: "'Greg Kroah-Hartman'" <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Cc: "Mikael Starvik" <mikael.starvik@axis.com>,
       "'Kay Sievers'" <kay.sievers@vrfy.org>
Subject: RE: [PATCH 128/196] Kobject: the cris iop_fw_load.c code is broken
Date: Fri, 25 Jan 2008 09:01:56 +0100
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C66804C403BB@exmail1.se.axis.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1106
In-Reply-To: <BFECAF9E178F144FAEF2BF4CE739C6680595315C@exmail1.se.axis.com>
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, we are currently in the process of cleaning this up for all our device
drivers.
Thanks!

-----Original Message-----
From: Greg Kroah-Hartman [mailto:gregkh@suse.de] 
Sent: Friday, January 25, 2008 8:33 AM
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman; Mikael Starvik; Kay Sievers
Subject: [PATCH 128/196] Kobject: the cris iop_fw_load.c code is broken


This code is really really really broken.  So much so that it's almost
impossible to fix with a simple patch, so just comment out the offending
registration with the kobject core, and mark the driver as broken.

The problem is that the code is trying to register a "raw" struct
device, which is not allowed.  struct device is only for use within the
driver model.  This is being done to try to use the firmware layer which
wants a struct device.  To properly fix this, use something easy, like a
platform device, which is a struct device and can be used for this kind
of thing.

Cc: Mikael Starvik <starvik@axis.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/cris/arch-v32/drivers/iop_fw_load.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/iop_fw_load.c
b/arch/cris/arch-v32/drivers/iop_fw_load.c
index 11f9895..f4bdc1d 100644
--- a/arch/cris/arch-v32/drivers/iop_fw_load.c
+++ b/arch/cris/arch-v32/drivers/iop_fw_load.c
@@ -20,6 +20,9 @@
 
 #define IOP_TIMEOUT 100
 
+#error "This driver is broken with regard to its driver core usage."
+#error "Please contact <greg@kroah.com> for details on how to fix it
properly."
+
 static struct device iop_spu_device[2] = {
 	{ .bus_id =     "iop-spu0", },
 	{ .bus_id =     "iop-spu1", },
@@ -192,6 +195,13 @@ int iop_start_mpu(unsigned int start_addr)
 
 static int __init iop_fw_load_init(void)
 {
+#if 0
+	/*
+	 * static struct devices can not be added directly to sysfs by
ignoring
+	 * the driver model infrastructure.  To fix this properly, please
use
+	 * the platform_bus to register these devices to be able to properly
+	 * use the firmware infrastructure.
+	 */
 	device_initialize(&iop_spu_device[0]);
 	kobject_set_name(&iop_spu_device[0].kobj, "iop-spu0");
 	kobject_add(&iop_spu_device[0].kobj);
@@ -201,6 +211,7 @@ static int __init iop_fw_load_init(void)
 	device_initialize(&iop_mpu_device);
 	kobject_set_name(&iop_mpu_device.kobj, "iop-mpu");
 	kobject_add(&iop_mpu_device.kobj);
+#endif
 	return 0;
 }
 
-- 
1.5.3.8

