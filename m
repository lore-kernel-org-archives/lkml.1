Return-Path: <linux-kernel-owner+w=401wt.eu-S1761695AbXGYMIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761695AbXGYMIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763125AbXGYMIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:08:37 -0400
Received: from rex.snapgear.com ([203.143.235.140]:33035 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762800AbXGYMIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:08:35 -0400
Date: Wed, 25 Jul 2007 22:07:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200707251207.l6PC7KkE032186@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: remove legacy power managament from 68328 serial driver
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the legacy power management code from the 68328 serial driver.
It is not used, and there is no current kernel support for power
management on the 68328.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naur linux-2.6.22/drivers/serial/68328serial.c linux-2.6.22-uc0/drivers/serial/68328serial.c
--- linux-2.6.22/drivers/serial/68328serial.c	2007-07-12 15:22:34.000000000 +1000
+++ linux-2.6.22-uc0/drivers/serial/68328serial.c	2007-07-12 15:25:25.000000000 +1000
@@ -33,7 +33,6 @@
 #include <linux/keyboard.h>
 #include <linux/init.h>
 #include <linux/pm.h>
-#include <linux/pm_legacy.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
 
@@ -1324,59 +1323,6 @@
 	printk("MC68328 serial driver version 1.00\n");
 }
 
-#ifdef CONFIG_PM_LEGACY
-/* Serial Power management
- *  The console (currently fixed at line 0) is a special case for power
- *  management because the kernel is so chatty. The console will be 
- *  explicitly disabled my our power manager as the last minute, so we won't
- *  mess with it here.
- */
-static struct pm_dev *serial_pm[NR_PORTS];
-
-static int serial_pm_callback(struct pm_dev *dev, pm_request_t request, void *data)
-{
-	struct m68k_serial *info = (struct m68k_serial *)dev->data;
-
-	if(info == NULL)
-		return -1;
-
-	/* special case for line 0 - pm restores it */
-	if(info->line == 0)
-		return 0; 
-
-	switch (request) {
-	case PM_SUSPEND:
-		shutdown(info);
-		break;
-
-	case PM_RESUME:
-		startup(info);
-		break;
-	}
-	return 0;
-}
-
-void shutdown_console(void)
-{
-	struct m68k_serial *info = &m68k_soft[0];
-
-	/* HACK: wait a bit for any pending printk's to be dumped */
-	{
-		int i = 10000;
-		while(i--);
-	}
-
-	shutdown(info);
-}
-
-void startup_console(void)
-{
-	struct m68k_serial *info = &m68k_soft[0];
-	startup(info);
-}
-#endif /* CONFIG_PM_LEGACY */
-
-
 static const struct tty_operations rs_ops = {
 	.open = rs_open,
 	.close = rs_close,
@@ -1467,11 +1413,6 @@
 			    IRQ_FLG_STD,
 			    "M68328_UART", NULL))
                 panic("Unable to attach 68328 serial interrupt\n");
-#ifdef CONFIG_PM_LEGACY
-	    serial_pm[i] = pm_register(PM_SYS_DEV, PM_SYS_COM, serial_pm_callback);
-	    if (serial_pm[i])
-		    serial_pm[i]->data = info;
-#endif
 	}
 	local_irq_restore(flags);
 	return 0;
