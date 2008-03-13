Return-Path: <linux-kernel-owner+w=401wt.eu-S1756599AbYCMQLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599AbYCMQLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 12:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753218AbYCMQL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 12:11:26 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:27732 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbYCMQLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 12:11:24 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: kernel@avr32linux.org
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>,
       David Brownell <david-b@pacbell.net>
Subject: [PATCH 03/10] avr32: Move setup_platform() into chip-specific file
Date: Thu, 13 Mar 2008 15:39:38 +0100
Message-Id: <1205419185-26395-4-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1205419185-26395-3-git-send-email-hskinnemoen@atmel.com>
References: <>
 <1205419185-26395-1-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-2-git-send-email-hskinnemoen@atmel.com>
 <1205419185-26395-3-git-send-email-hskinnemoen@atmel.com>
X-OriginalArrivalTime: 13 Mar 2008 14:39:46.0383 (UTC) FILETIME=[155795F0:01C88518]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combine at32_clock_init() and at32_portmux_init() into
setup_platform() and remove setup_platform() from at32ap.c. No
functional change since all setup_platform() ever did was call those
two functions.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/mach-at32ap/at32ap.c      |    8 --------
 arch/avr32/mach-at32ap/at32ap700x.c  |   18 ++++++++----------
 include/asm-avr32/arch-at32ap/init.h |    4 ----
 3 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/arch/avr32/mach-at32ap/at32ap.c b/arch/avr32/mach-at32ap/at32ap.c
index 7c4987f..1040bda 100644
--- a/arch/avr32/mach-at32ap/at32ap.c
+++ b/arch/avr32/mach-at32ap/at32ap.c
@@ -11,14 +11,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 
-#include <asm/arch/init.h>
-
-void __init setup_platform(void)
-{
-	at32_clock_init();
-	at32_portmux_init();
-}
-
 static int __init pdc_probe(struct platform_device *pdev)
 {
 	struct clk *pclk, *hclk;
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index 0f24b4f..1af9c1d 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1935,16 +1935,7 @@ struct clk *at32_clock_list[] = {
 };
 unsigned int at32_nr_clocks = ARRAY_SIZE(at32_clock_list);
 
-void __init at32_portmux_init(void)
-{
-	at32_init_pio(&pio0_device);
-	at32_init_pio(&pio1_device);
-	at32_init_pio(&pio2_device);
-	at32_init_pio(&pio3_device);
-	at32_init_pio(&pio4_device);
-}
-
-void __init at32_clock_init(void)
+void __init setup_platform(void)
 {
 	u32 cpu_mask = 0, hsb_mask = 0, pba_mask = 0, pbb_mask = 0;
 	int i;
@@ -1999,4 +1990,11 @@ void __init at32_clock_init(void)
 	pm_writel(HSB_MASK, hsb_mask);
 	pm_writel(PBA_MASK, pba_mask);
 	pm_writel(PBB_MASK, pbb_mask);
+
+	/* Initialize the port muxes */
+	at32_init_pio(&pio0_device);
+	at32_init_pio(&pio1_device);
+	at32_init_pio(&pio2_device);
+	at32_init_pio(&pio3_device);
+	at32_init_pio(&pio4_device);
 }
diff --git a/include/asm-avr32/arch-at32ap/init.h b/include/asm-avr32/arch-at32ap/init.h
index 5e75d85..bc40e3d 100644
--- a/include/asm-avr32/arch-at32ap/init.h
+++ b/include/asm-avr32/arch-at32ap/init.h
@@ -13,10 +13,6 @@
 void setup_platform(void);
 void setup_board(void);
 
-/* Called by setup_platform */
-void at32_clock_init(void);
-void at32_portmux_init(void);
-
 void at32_setup_serial_console(unsigned int usart_id);
 
 #endif /* __ASM_AVR32_AT32AP_INIT_H__ */
-- 
1.5.4.3

