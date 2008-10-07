Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbYJGXU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbYJGXU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 19:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbYJGXUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 19:20:21 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:31905 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754926AbYJGXUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 19:20:20 -0400
Date: Tue, 07 Oct 2008 17:20:19 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 1/1] edac mpc85xx add support for mpc8572
Message-ID: <48ebeeb3.G6XTY/C+L/iDN42o%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Kilkenny <akilkenny@xes-inc.com>

This adds support for the dual-core MPC8572 processor.  We have
to support making SPR changes on each core.  Also, since we can
have multiple memory controllers sharing an interrupt, flag the
interrupts with IRQF_SHARED.


Saw this on ppc-dev. I'm guessing we probably should be the one submitting it 
since it's the driver change?
Dave Jiang


Signed-off-by: Andrew Kilkenny <akilkenny@xes-inc.com>
Signed-off-by: Nate Case <ncase@xes-inc.com>
Acked-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
  drivers/edac/mpc85xx_edac.c |   28 +++++++++++++++++++++++-----
  1 files changed, 23 insertions(+), 5 deletions(-)

Index: linux-2.6.27-rc5-mm1/drivers/edac/mpc85xx_edac.c
===================================================================
--- linux-2.6.27-rc5-mm1.orig/drivers/edac/mpc85xx_edac.c
+++ linux-2.6.27-rc5-mm1/drivers/edac/mpc85xx_edac.c
@@ -17,6 +17,7 @@
 #include <linux/io.h>
 #include <linux/mod_devicetable.h>
 #include <linux/edac.h>
+#include <linux/smp.h>
 
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
@@ -40,7 +41,7 @@ static u32 orig_pci_err_en;
 #endif
 
 static u32 orig_l2_err_disable;
-static u32 orig_hid1;
+static u32 orig_hid1[2];
 
 /************************ MC SYSFS parts ***********************************/
 
@@ -647,6 +648,9 @@ static struct of_device_id mpc85xx_l2_er
 	{
 	 .compatible = "fsl,8568-l2-cache-controller",
 	 },
+	{
+	 .compatible = "fsl,mpc8572-l2-cache-controller",
+	 },
 	{},
 };
 
@@ -912,7 +916,8 @@ static int __devinit mpc85xx_mc_err_prob
 		/* register interrupts */
 		pdata->irq = irq_of_parse_and_map(op->node, 0);
 		res = devm_request_irq(&op->dev, pdata->irq,
-				       mpc85xx_mc_isr, IRQF_DISABLED,
+				       mpc85xx_mc_isr,
+					IRQF_DISABLED | IRQF_SHARED,
 				       "[EDAC] MC err", mci);
 		if (res < 0) {
 			printk(KERN_ERR "%s: Unable to request irq %d for "
@@ -980,6 +985,9 @@ static struct of_device_id mpc85xx_mc_er
 	{
 	 .compatible = "fsl,8568-memory-controller",
 	 },
+	{
+	 .compatible = "fsl,mpc8572-memory-controller",
+	 },
 	{},
 };
 
@@ -995,6 +1003,14 @@ static struct of_platform_driver mpc85xx
 		   },
 };
 
+
+static void __init mpc85xx_mc_clear_rfxe(void *data)
+{
+	orig_hid1[smp_processor_id()] = mfspr(SPRN_HID1);
+	mtspr(SPRN_HID1, (orig_hid1[smp_processor_id()] & ~0x20000));
+}
+
+
 static int __init mpc85xx_mc_init(void)
 {
 	int res = 0;
@@ -1030,19 +1046,22 @@ static int __init mpc85xx_mc_init(void)
 	 * need to clear HID1[RFXE] to disable machine check int
 	 * so we can catch it
 	 */
-	if (edac_op_state == EDAC_OPSTATE_INT) {
-		orig_hid1 = mfspr(SPRN_HID1);
-		mtspr(SPRN_HID1, (orig_hid1 & ~0x20000));
-	}
+	if (edac_op_state == EDAC_OPSTATE_INT)
+		on_each_cpu(mpc85xx_mc_clear_rfxe, NULL, 0);
 
 	return 0;
 }
 
 module_init(mpc85xx_mc_init);
 
+static void __exit mpc85xx_mc_restore_hid1(void *data)
+{
+	mtspr(SPRN_HID1, orig_hid1[smp_processor_id()]);
+}
+
 static void __exit mpc85xx_mc_exit(void)
 {
-	mtspr(SPRN_HID1, orig_hid1);
+	on_each_cpu(mpc85xx_mc_restore_hid1, NULL, 0);
 #ifdef CONFIG_PCI
 	of_unregister_platform_driver(&mpc85xx_pci_err_driver);
 #endif
