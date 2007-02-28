Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbXB1KYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbXB1KYL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 05:24:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXB1KYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 05:24:10 -0500
Received: from ns2.suse.de ([195.135.220.15]:44517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbXB1KYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 05:24:09 -0500
Message-Id: <20070228102346.115707000@suse.de>
User-Agent: quilt/0.46-14
Date: Wed, 28 Feb 2007 11:23:46 +0100
From: Gerd Hoffmann <kraxel@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alex Williamson <alex.williamson@hp.com>,
       Kevin Stansell <kstansel@us.ibm.com>
Subject: [patch] Add insmod option to force the use of the backup timer.
Content-Disposition: inline; filename=serial-8250-backup-timerPatch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The test which automatically enables the backup timer on some HP
machines doesn't trigger on other hardware which needs the backup
timer too.

This patch add a way to enable it manually (8250.use_backup_timer=1)
to deal with these machines.

Signed-off-by: Gerd Hoffmann <kraxel@suse.de>
Cc: Alex Williamson <alex.williamson@hp.com>
Cc: Kevin Stansell <kstansel@us.ibm.com>
---
 drivers/serial/8250.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: vanilla-2.6.21-rc2/drivers/serial/8250.c
===================================================================
--- vanilla-2.6.21-rc2.orig/drivers/serial/8250.c
+++ vanilla-2.6.21-rc2/drivers/serial/8250.c
@@ -52,8 +52,8 @@
  *                is unsafe when used on edge-triggered interrupts.
  */
 static unsigned int share_irqs = SERIAL8250_SHARE_IRQS;
-
 static unsigned int nr_uarts = CONFIG_SERIAL_8250_RUNTIME_UARTS;
+static unsigned int use_backup_timer;
 
 /*
  * Debugging.
@@ -1729,7 +1729,7 @@ static int serial8250_startup(struct uar
 		 * If the interrupt is not reasserted, setup a timer to
 		 * kick the UART on a regular basis.
 		 */
-		if (iir & UART_IIR_NO_INT) {
+		if (iir & UART_IIR_NO_INT || use_backup_timer) {
 			pr_debug("ttyS%d - using backup timer\n", port->line);
 			up->timer.function = serial8250_backup_timeout;
 			up->timer.data = (unsigned long)up;
@@ -2805,6 +2805,9 @@ module_param(share_irqs, uint, 0644);
 MODULE_PARM_DESC(share_irqs, "Share IRQs with other non-8250/16x50 devices"
 	" (unsafe)");
 
+module_param(use_backup_timer, uint, 0644);
+MODULE_PARM_DESC(use_backup_timer, "use backup timer");
+
 module_param(nr_uarts, uint, 0644);
 MODULE_PARM_DESC(nr_uarts, "Maximum number of UARTs supported. (1-" __MODULE_STRING(CONFIG_SERIAL_8250_NR_UARTS) ")");
 

-- 
Gerd Hoffmann <kraxel@suse.de>

