Return-Path: <linux-kernel-owner+w=401wt.eu-S1765825AbYAYI2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765825AbYAYI2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761324AbYAYIBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:13 -0500
Received: from ns1.suse.de ([195.135.220.2]:59480 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759876AbYAYH75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Mikael Starvik <starvik@axis.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 128/196] Kobject: the cris iop_fw_load.c code is broken
Date: Thu, 24 Jan 2008 23:32:37 -0800
Message-Id: <1201246425-5058-49-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/arch/cris/arch-v32/drivers/iop_fw_load.c b/arch/cris/arch-v32/drivers/iop_fw_load.c
index 11f9895..f4bdc1d 100644
--- a/arch/cris/arch-v32/drivers/iop_fw_load.c
+++ b/arch/cris/arch-v32/drivers/iop_fw_load.c
@@ -20,6 +20,9 @@
 
 #define IOP_TIMEOUT 100
 
+#error "This driver is broken with regard to its driver core usage."
+#error "Please contact <greg@kroah.com> for details on how to fix it properly."
+
 static struct device iop_spu_device[2] = {
 	{ .bus_id =     "iop-spu0", },
 	{ .bus_id =     "iop-spu1", },
@@ -192,6 +195,13 @@ int iop_start_mpu(unsigned int start_addr)
 
 static int __init iop_fw_load_init(void)
 {
+#if 0
+	/*
+	 * static struct devices can not be added directly to sysfs by ignoring
+	 * the driver model infrastructure.  To fix this properly, please use
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

