Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYKGMBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYKGMBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 07:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbYKGMBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 07:01:43 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:55192 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbYKGMBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 07:01:42 -0500
Date: Fri, 7 Nov 2008 13:01:36 +0100
From: Jesper Nilsson <Jesper.Nilsson@axis.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: chris: struct device - replace bus_id with dev_name(),
	dev_set_name()
Message-ID: <20081107120136.GD4013@axis.com>
References: <1226018320.3189.9.camel@nga>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226018320.3189.9.camel@nga>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2008 at 01:38:40AM +0100, Kay Sievers wrote:
> This patch is part of a larger patch series which will remove
> the "char bus_id[20]" name string from struct device. The device
> name is managed in the kobject anyway, and without any size
> limitation, and just needlessly copied into "struct device".

Thanks, but I think that since this driver has been broken a long time
it is high time to fix it, and I think the fix removes the need for your patch.

Greg, could you please look this patch over?


[CRISv32] Fix IOP fw-loader to use platform_device.

Change IOP fw-loader to use platform_device instead of
raw device, which should be more correct usage.

Signed-off-by: Stefan Andersson <stefan.andersson@axis.com>
Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---

 iop_fw_load.c |   69 ++++++++++++++++++++++++----------------------------------
 1 file changed, 29 insertions(+), 40 deletions(-)

diff --git a/arch/cris/arch-v32/drivers/iop_fw_load.c b/arch/cris/arch-v32/drivers/iop_fw_load.c
index 3b3857e..7376012 100644
--- a/arch/cris/arch-v32/drivers/iop_fw_load.c
+++ b/arch/cris/arch-v32/drivers/iop_fw_load.c
@@ -1,13 +1,14 @@
 /*
  * Firmware loader for ETRAX FS IO-Processor
  *
- * Copyright (C) 2004  Axis Communications AB
+ * Copyright (C) 2004-2008  Axis Communications AB
  */
 
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/device.h>
+#include <linux/platform_device.h>
 #include <linux/firmware.h>
 
 #include <hwregs/reg_rdwr.h>
@@ -20,16 +21,17 @@
 
 #define IOP_TIMEOUT 100
 
-#error "This driver is broken with regard to its driver core usage."
-#error "Please contact <greg@kroah.com> for details on how to fix it properly."
+int iop_fw_load_spu(const unsigned char *fw_name, unsigned int spu_inst);
+int iop_fw_load_mpu(unsigned char *fw_name);
+int iop_start_mpu(unsigned int start_addr);
 
-static struct device iop_spu_device[2] = {
-	{ .bus_id =     "iop-spu0", },
-	{ .bus_id =     "iop-spu1", },
+static struct platform_device iop_spu_device[2] = {
+	{ .name =     "iop-spu0", },
+	{ .name =     "iop-spu1", },
 };
 
-static struct device iop_mpu_device = {
-	.bus_id =       "iop-mpu",
+static struct platform_device iop_mpu_device = {
+	.name =       "iop-mpu",
 };
 
 static int wait_mpu_idle(void)
@@ -61,7 +63,7 @@ int iop_fw_load_spu(const unsigned char *fw_name, unsigned int spu_inst)
 		.fsm =            regk_iop_spu_no,
 	};
 	reg_iop_sw_cpu_r_mc_stat mc_stat;
-        const struct firmware *fw_entry;
+	const struct firmware *fw_entry;
 	u32 *data;
 	unsigned int timeout;
 	int retval, i;
@@ -72,9 +74,8 @@ int iop_fw_load_spu(const unsigned char *fw_name, unsigned int spu_inst)
 	/* get firmware */
 	retval = request_firmware(&fw_entry,
 				  fw_name,
-				  &iop_spu_device[spu_inst]);
-	if (retval != 0)
-	{
+				  &iop_spu_device[spu_inst].dev);
+	if (retval != 0) {
 		printk(KERN_ERR
 		       "iop_load_spu: Failed to load firmware \"%s\"\n",
 		       fw_name);
@@ -121,29 +122,29 @@ int iop_fw_load_spu(const unsigned char *fw_name, unsigned int spu_inst)
 	/* release ownership of memory controller */
 	(void) REG_RD(iop_sw_cpu, regi_iop_sw_cpu, rs_mc_data);
 
- out:
+out:
 	release_firmware(fw_entry);
 	return retval;
 }
+EXPORT_SYMBOL(iop_fw_load_spu);
 
 int iop_fw_load_mpu(unsigned char *fw_name)
 {
 	const unsigned int start_addr = 0;
 	reg_iop_mpu_rw_ctrl mpu_ctrl;
-        const struct firmware *fw_entry;
+	const struct firmware *fw_entry;
 	u32 *data;
 	int retval, i;
 
 	/* get firmware */
-	retval = request_firmware(&fw_entry, fw_name, &iop_mpu_device);
-	if (retval != 0)
-	{
+	retval = request_firmware(&fw_entry, fw_name, &iop_mpu_device.dev);
+	if (retval != 0) {
 		printk(KERN_ERR
 		       "iop_load_spu: Failed to load firmware \"%s\"\n",
 		       fw_name);
 		return retval;
 	}
-	data = (u32 *) fw_entry->data;
+	data = (u32 *)fw_entry->data;
 
 	/* disable MPU */
 	mpu_ctrl.en = regk_iop_mpu_no;
@@ -161,10 +162,11 @@ int iop_fw_load_mpu(unsigned char *fw_name)
 		data++;
 	}
 
- out:
+out:
 	release_firmware(fw_entry);
 	return retval;
 }
+EXPORT_SYMBOL(iop_fw_load_mpu);
 
 int iop_start_mpu(unsigned int start_addr)
 {
@@ -189,34 +191,24 @@ int iop_start_mpu(unsigned int start_addr)
 		goto out;
 	/* enable MPU */
 	REG_WR(iop_mpu, regi_iop_mpu, rw_ctrl, mpu_ctrl);
- out:
+out:
 	return retval;
 }
+EXPORT_SYMBOL(iop_start_mpu);
 
 static int __init iop_fw_load_init(void)
 {
-#if 0
-	/*
-	 * static struct devices can not be added directly to sysfs by ignoring
-	 * the driver model infrastructure.  To fix this properly, please use
-	 * the platform_bus to register these devices to be able to properly
-	 * use the firmware infrastructure.
-	 */
-	device_initialize(&iop_spu_device[0]);
-	kobject_set_name(&iop_spu_device[0].kobj, "iop-spu0");
-	kobject_add(&iop_spu_device[0].kobj);
-	device_initialize(&iop_spu_device[1]);
-	kobject_set_name(&iop_spu_device[1].kobj, "iop-spu1");
-	kobject_add(&iop_spu_device[1].kobj);
-	device_initialize(&iop_mpu_device);
-	kobject_set_name(&iop_mpu_device.kobj, "iop-mpu");
-	kobject_add(&iop_mpu_device.kobj);
-#endif
+	platform_device_register(&iop_mpu_device);
+	platform_device_register(&iop_spu_device[0]);
+	platform_device_register(&iop_spu_device[1]);
 	return 0;
 }
 
 static void __exit iop_fw_load_exit(void)
 {
+	platform_device_unregister(&iop_mpu_device);
+	platform_device_unregister(&iop_spu_device[0]);
+	platform_device_unregister(&iop_spu_device[1]);
 }
 
 module_init(iop_fw_load_init);
@@ -225,6 +217,3 @@ module_exit(iop_fw_load_exit);
 MODULE_DESCRIPTION("ETRAX FS IO-Processor Firmware Loader");
 MODULE_LICENSE("GPL");
 
-EXPORT_SYMBOL(iop_fw_load_spu);
-EXPORT_SYMBOL(iop_fw_load_mpu);
-EXPORT_SYMBOL(iop_start_mpu);


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
