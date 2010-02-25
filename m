Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab0BYJfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 04:35:32 -0500
Received: from mail.gmx.net ([213.165.64.20]:35648 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753604Ab0BYJfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 04:35:30 -0500
X-Authenticated: #5115406
X-Provags-ID: V01U2FsdGVkX1+LtaQXCkOLiUMg+axTamk1LGYeFj5pi03afunPoK
	JBdKjhI7MaYzdF
From: Thomas Weber <swirl@gmx.li>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <swirl@gmx.li>, Tony Lindgren <tony@atomide.com>,
       Russell King <linux@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Vikram Pandita <vikram.pandita@ti.com>,
       Syed Rafiuddin <rafiuddin.syed@ti.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Thomas Weber <weber@corscience.de>
Subject: 
Date: Thu, 25 Feb 2010 10:36:13 +0100
Message-Id: <1267090573-17708-1-git-send-email-swirl@gmx.li>
X-Mailer: git-send-email 1.6.4.4
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH/RFC] OMAP2: serial.c: Fix number of uarts in early_init

The omap_serial_early_init prints the following errors:

Could not get uart4_ick
Could not get uart4_fck

because all the uarts available in omap_uart[] will be initialized.
Only omap4430 and omap3630 have 4 uarts at the moment.
This patch reduces the number of uarts when cpu is not omap4430 or
omap3630.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/serial.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index b79bc89..da77930 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -644,16 +644,21 @@ static void serial_out_override(struct uart_port *up, int offset, int value)
 }
 void __init omap_serial_early_init(void)
 {
-	int i;
+	int i, nr_ports;
 	char name[16];
 
+	if (!(cpu_is_omap3630() || cpu_is_omap4430()))
+		nr_ports = 3;
+	else
+		nr_ports = ARRAY_SIZE(omap_uart);
+
 	/*
 	 * Make sure the serial ports are muxed on at this point.
 	 * You have to mux them off in device drivers later on
 	 * if not needed.
 	 */
 
-	for (i = 0; i < ARRAY_SIZE(omap_uart); i++) {
+	for (i = 0; i < nr_ports; i++) {
 		struct omap_uart_state *uart = &omap_uart[i];
 		struct platform_device *pdev = &uart->pdev;
 		struct device *dev = &pdev->dev;
@@ -669,17 +674,17 @@ void __init omap_serial_early_init(void)
 			continue;
 		}
 
-		sprintf(name, "uart%d_ick", i+1);
+		sprintf(name, "uart%d_ick", i + 1);
 		uart->ick = clk_get(NULL, name);
 		if (IS_ERR(uart->ick)) {
-			printk(KERN_ERR "Could not get uart%d_ick\n", i+1);
+			printk(KERN_ERR "Could not get uart%d_ick\n", i + 1);
 			uart->ick = NULL;
 		}
 
 		sprintf(name, "uart%d_fck", i+1);
 		uart->fck = clk_get(NULL, name);
 		if (IS_ERR(uart->fck)) {
-			printk(KERN_ERR "Could not get uart%d_fck\n", i+1);
+			printk(KERN_ERR "Could not get uart%d_fck\n", i + 1);
 			uart->fck = NULL;
 		}
 
-- 
1.6.4.4

