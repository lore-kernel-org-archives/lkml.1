Return-Path: <linux-kernel-owner+w=401wt.eu-S934178AbXCVSNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934178AbXCVSNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 14:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934176AbXCVSNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 14:13:07 -0400
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:36582 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934177AbXCVSNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 14:13:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MJ+DeO+fTU7Egrd+6DLmBJdmL4q1Ju07V3V23Vq8StOnZ0enYgeC+S0WLjAc7Ac5QxvUcjEjddOzyR6x2/hszqAj/iYP4FYZjA1kZvxx76ZlkirRMsgD2nq3X40oG5q0XbYP8x8TA32EifmJ+jhw30GqGI+IUhTLuTslQ37nWBE=  ;
X-YMail-OSG: xF4cIw8VM1kq2TjMJCNz2o2M0G90XO.8h4Dm74aCey0.frdykrQ200nPhErN34b6X.TfXEMRS6decYND9dkItI9vAjwGJJJb7yuMCrPunO8E.ToRlPVX7Y7u2PDzWazUcqIm.eqsu1eLGVq7Mw8WIiCG4Q--
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2/2] clk_must_disable() implementation on AT91
Date: Thu, 22 Mar 2007 11:08:21 -0700
User-Agent: KMail/1.7.1
Cc: Andrew Victor <andrew@sanpeople.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703221108.21861.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This supports the new clk_must_disable() interface for AT91 systems:

 - Implement the call, replacing at91_suspend_entering_slow_clock()
   and eliminating various "that's not exported" build warnings;

 - Use it in three drivers: USB Host, USB Peripheral, and RS232 serial.

Briefly, those are three of the drivers that need to act differently when
going into deeper sleep states (suspend-to-RAM, vs standby), since among
other things they can't act as wakeup event sources without using the
clocks which are disabled in those deeper sleep states.

(The at91_ethernet driver would be another such driver, but it doesn't
currently implement wake-on-LAN even in the "standby" mode.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 arch/arm/mach-at91/clock.c    |   18 ++++++++++++++++++
 arch/arm/mach-at91/generic.h  |    1 +
 arch/arm/mach-at91/pm.c       |    7 +------
 drivers/serial/atmel_serial.c |    3 ++-
 drivers/usb/gadget/at91_udc.c |    2 +-
 drivers/usb/host/ohci-at91.c  |    2 +-
 6 files changed, 24 insertions(+), 9 deletions(-)

Index: at91/arch/arm/mach-at91/clock.c
===================================================================
--- at91.orig/arch/arm/mach-at91/clock.c	2007-02-19 16:15:13.000000000 -0800
+++ at91/arch/arm/mach-at91/clock.c	2007-02-19 17:45:25.000000000 -0800
@@ -33,6 +33,7 @@
 #include <asm/arch/cpu.h>
 
 #include "clock.h"
+#include "generic.h"
 
 
 /*
@@ -255,6 +256,23 @@ EXPORT_SYMBOL(clk_get_rate);
 
 /*------------------------------------------------------------------------*/
 
+#ifdef CONFIG_PM
+
+int clk_must_disable(struct clk *clk)
+{
+	if (!at91_suspend_entering_slow_clock())
+		return 0;
+
+	while (clk->parent)
+		clk = clk->parent;
+	return clk != &clk32k;
+}
+EXPORT_SYMBOL(clk_must_disable);
+
+#endif
+
+/*------------------------------------------------------------------------*/
+
 #ifdef CONFIG_AT91_PROGRAMMABLE_CLOCKS
 
 /*
Index: at91/arch/arm/mach-at91/generic.h
===================================================================
--- at91.orig/arch/arm/mach-at91/generic.h	2007-02-19 17:30:37.000000000 -0800
+++ at91/arch/arm/mach-at91/generic.h	2007-02-19 17:45:25.000000000 -0800
@@ -38,6 +38,7 @@ extern void __init at91_clock_associate(
  /* Power Management */
 extern void at91_irq_suspend(void);
 extern void at91_irq_resume(void);
+extern int at91_suspend_entering_slow_clock(void);
 
  /* GPIO */
 #define AT91RM9200_PQFP		3	/* AT91RM9200 PQFP package has 3 banks */
Index: at91/arch/arm/mach-at91/pm.c
===================================================================
--- at91.orig/arch/arm/mach-at91/pm.c	2007-02-19 13:57:53.000000000 -0800
+++ at91/arch/arm/mach-at91/pm.c	2007-02-19 17:45:25.000000000 -0800
@@ -104,20 +104,15 @@ static int at91_pm_verify_clocks(void)
 }
 
 /*
- * Call this from platform driver suspend() to see how deeply to suspend.
+ * This is called from clk_must_disable(), to see how deeply to suspend.
  * For example, some controllers (like OHCI) need one of the PLL clocks
  * in order to act as a wakeup source, and those are not available when
  * going into slow clock mode.
- *
- * REVISIT: generalize as clk_will_be_available(clk)?  Other platforms have
- * the very same problem (but not using at91 main_clk), and it'd be better
- * to add one generic API rather than lots of platform-specific ones.
  */
 int at91_suspend_entering_slow_clock(void)
 {
 	return (target_state == PM_SUSPEND_MEM);
 }
-EXPORT_SYMBOL(at91_suspend_entering_slow_clock);
 
 
 static void (*slow_clock)(void);
Index: at91/drivers/serial/atmel_serial.c
===================================================================
--- at91.orig/drivers/serial/atmel_serial.c	2007-02-19 13:57:53.000000000 -0800
+++ at91/drivers/serial/atmel_serial.c	2007-02-19 17:45:25.000000000 -0800
@@ -888,7 +888,8 @@ static int atmel_serial_suspend(struct p
 	struct uart_port *port = platform_get_drvdata(pdev);
 	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
 
-	if (device_may_wakeup(&pdev->dev) && !at91_suspend_entering_slow_clock())
+	if (device_may_wakeup(&pdev->dev)
+			&& !clk_must_disable(atmel_port->clk))
 		enable_irq_wake(port->irq);
 	else {
 		uart_suspend_port(&atmel_uart, port);
Index: at91/drivers/usb/gadget/at91_udc.c
===================================================================
--- at91.orig/drivers/usb/gadget/at91_udc.c	2007-02-19 13:57:53.000000000 -0800
+++ at91/drivers/usb/gadget/at91_udc.c	2007-02-19 17:45:25.000000000 -0800
@@ -1804,7 +1804,7 @@ static int at91udc_suspend(struct platfo
 	 */
 	if ((!udc->suspended && udc->addr)
 			|| !wake
-			|| at91_suspend_entering_slow_clock()) {
+			|| clk_must_disable(udc->fclk)) {
 		pullup(udc, 0);
 		wake = 0;
 	} else
Index: at91/drivers/usb/host/ohci-at91.c
===================================================================
--- at91.orig/drivers/usb/host/ohci-at91.c	2007-02-19 13:57:53.000000000 -0800
+++ at91/drivers/usb/host/ohci-at91.c	2007-02-19 17:45:25.000000000 -0800
@@ -299,7 +299,7 @@ ohci_hcd_at91_drv_suspend(struct platfor
 	 *
 	 * REVISIT: some boards will be able to turn VBUS off...
 	 */
-	if (at91_suspend_entering_slow_clock()) {
+	if (clk_must_disable(fclk)) {
 		ohci_usb_reset (ohci);
 		at91_stop_clock();
 	}
