Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbZJVWMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbZJVWMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757016AbZJVWME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:12:04 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55498 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966AbZJVWMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:12:02 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18w7R+TqXMVNLusR8DmOeoz
Subject: [PATCH 04/10] omap1: Fix redundant UARTs pin muxing that can break
	other hardware support
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Date: Thu, 22 Oct 2009 15:12:01 -0700
Message-ID: <20091022221201.27408.65141.stgit@localhost>
In-Reply-To: <20091022221013.27408.443.stgit@localhost>
References: <20091022221013.27408.443.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

Commit 15ac408ee5a509053a765b816e9179515329369f removed enabled_uart
and OMAP_TAG_UART. This works for mach-omap2, but causes issues on
mach-omap1 for some boards as the mach-omap1 serial.c was muxing
pins based on the enabled_uart flag for 15xx.

Fix this by muxing pins in board-*.c files for the 15xx boards for
the uart ports that had enabled_uart flag set before the commit
above.

Tested on Amsdtrad Delta only.

Note that in the future we should add support for powering down
the uarts with a timer like mach-omap2/serial.c does. Otherwise
the enabled uarts will be blocking retention-while-idle.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-ams-delta.c |    4 ++++
 arch/arm/mach-omap1/board-generic.c   |    8 ++++++++
 arch/arm/mach-omap1/board-innovator.c |   20 ++++++++++++++++++++
 arch/arm/mach-omap1/board-palmte.c    |    8 ++++++++
 arch/arm/mach-omap1/board-palmtt.c    |    8 ++++++++
 arch/arm/mach-omap1/board-palmz71.c   |    8 ++++++++
 arch/arm/mach-omap1/board-sx1.c       |    8 ++++++++
 arch/arm/mach-omap1/board-voiceblue.c |    8 ++++++++
 arch/arm/mach-omap1/serial.c          |   26 --------------------------
 9 files changed, 72 insertions(+), 26 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index 42920f9..972499e 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -219,6 +219,10 @@ static struct platform_device *ams_delta_devices[] __initdata = {
 
 static void __init ams_delta_init(void)
 {
+	/* mux pins for uarts */
+	omap_cfg_reg(UART1_TX);
+	omap_cfg_reg(UART1_RTS);
+
 	iotable_init(ams_delta_io_desc, ARRAY_SIZE(ams_delta_io_desc));
 
 	omap_board_config = ams_delta_config;
diff --git a/arch/arm/mach-omap1/board-generic.c b/arch/arm/mach-omap1/board-generic.c
index fb47239..6c8a41f 100644
--- a/arch/arm/mach-omap1/board-generic.c
+++ b/arch/arm/mach-omap1/board-generic.c
@@ -64,6 +64,14 @@ static void __init omap_generic_init(void)
 {
 #ifdef CONFIG_ARCH_OMAP15XX
 	if (cpu_is_omap15xx()) {
+		/* mux pins for uarts */
+		omap_cfg_reg(UART1_TX);
+		omap_cfg_reg(UART1_RTS);
+		omap_cfg_reg(UART2_TX);
+		omap_cfg_reg(UART2_RTS);
+		omap_cfg_reg(UART3_TX);
+		omap_cfg_reg(UART3_RX);
+
 		omap_usb_init(&generic1510_usb_config);
 	}
 #endif
diff --git a/arch/arm/mach-omap1/board-innovator.c b/arch/arm/mach-omap1/board-innovator.c
index cc2abbb..cd6c395 100644
--- a/arch/arm/mach-omap1/board-innovator.c
+++ b/arch/arm/mach-omap1/board-innovator.c
@@ -376,6 +376,26 @@ static void __init innovator_init(void)
 {
 #ifdef CONFIG_ARCH_OMAP15XX
 	if (cpu_is_omap1510()) {
+		unsigned char reg;
+
+		/* mux pins for uarts */
+		omap_cfg_reg(UART1_TX);
+		omap_cfg_reg(UART1_RTS);
+		omap_cfg_reg(UART2_TX);
+		omap_cfg_reg(UART2_RTS);
+		omap_cfg_reg(UART3_TX);
+		omap_cfg_reg(UART3_RX);
+
+		reg = fpga_read(OMAP1510_FPGA_POWER);
+		reg |= OMAP1510_FPGA_PCR_COM1_EN;
+		fpga_write(reg, OMAP1510_FPGA_POWER);
+		udelay(10);
+
+		reg = fpga_read(OMAP1510_FPGA_POWER);
+		reg |= OMAP1510_FPGA_PCR_COM2_EN;
+		fpga_write(reg, OMAP1510_FPGA_POWER);
+		udelay(10);
+
 		platform_add_devices(innovator1510_devices, ARRAY_SIZE(innovator1510_devices));
 		spi_register_board_info(innovator1510_boardinfo,
 				ARRAY_SIZE(innovator1510_boardinfo));
diff --git a/arch/arm/mach-omap1/board-palmte.c b/arch/arm/mach-omap1/board-palmte.c
index 90dd043..4de2584 100644
--- a/arch/arm/mach-omap1/board-palmte.c
+++ b/arch/arm/mach-omap1/board-palmte.c
@@ -342,6 +342,14 @@ static void __init palmte_misc_gpio_setup(void)
 
 static void __init omap_palmte_init(void)
 {
+	/* mux pins for uarts */
+	omap_cfg_reg(UART1_TX);
+	omap_cfg_reg(UART1_RTS);
+	omap_cfg_reg(UART2_TX);
+	omap_cfg_reg(UART2_RTS);
+	omap_cfg_reg(UART3_TX);
+	omap_cfg_reg(UART3_RX);
+
 	omap_board_config = palmte_config;
 	omap_board_config_size = ARRAY_SIZE(palmte_config);
 
diff --git a/arch/arm/mach-omap1/board-palmtt.c b/arch/arm/mach-omap1/board-palmtt.c
index 8256139..d972cf9 100644
--- a/arch/arm/mach-omap1/board-palmtt.c
+++ b/arch/arm/mach-omap1/board-palmtt.c
@@ -289,6 +289,14 @@ static void __init omap_mpu_wdt_mode(int mode) {
 
 static void __init omap_palmtt_init(void)
 {
+	/* mux pins for uarts */
+	omap_cfg_reg(UART1_TX);
+	omap_cfg_reg(UART1_RTS);
+	omap_cfg_reg(UART2_TX);
+	omap_cfg_reg(UART2_RTS);
+	omap_cfg_reg(UART3_TX);
+	omap_cfg_reg(UART3_RX);
+
 	omap_mpu_wdt_mode(0);
 
 	omap_board_config = palmtt_config;
diff --git a/arch/arm/mach-omap1/board-palmz71.c b/arch/arm/mach-omap1/board-palmz71.c
index 81b6bde..986bd4d 100644
--- a/arch/arm/mach-omap1/board-palmz71.c
+++ b/arch/arm/mach-omap1/board-palmz71.c
@@ -307,6 +307,14 @@ palmz71_gpio_setup(int early)
 static void __init
 omap_palmz71_init(void)
 {
+	/* mux pins for uarts */
+	omap_cfg_reg(UART1_TX);
+	omap_cfg_reg(UART1_RTS);
+	omap_cfg_reg(UART2_TX);
+	omap_cfg_reg(UART2_RTS);
+	omap_cfg_reg(UART3_TX);
+	omap_cfg_reg(UART3_RX);
+
 	palmz71_gpio_setup(1);
 	omap_mpu_wdt_mode(0);
 
diff --git a/arch/arm/mach-omap1/board-sx1.c b/arch/arm/mach-omap1/board-sx1.c
index 02c85ca..056ae64 100644
--- a/arch/arm/mach-omap1/board-sx1.c
+++ b/arch/arm/mach-omap1/board-sx1.c
@@ -377,6 +377,14 @@ static struct omap_board_config_kernel sx1_config[] __initdata = {
 
 static void __init omap_sx1_init(void)
 {
+	/* mux pins for uarts */
+	omap_cfg_reg(UART1_TX);
+	omap_cfg_reg(UART1_RTS);
+	omap_cfg_reg(UART2_TX);
+	omap_cfg_reg(UART2_RTS);
+	omap_cfg_reg(UART3_TX);
+	omap_cfg_reg(UART3_RX);
+
 	platform_add_devices(sx1_devices, ARRAY_SIZE(sx1_devices));
 
 	omap_board_config = sx1_config;
diff --git a/arch/arm/mach-omap1/board-voiceblue.c b/arch/arm/mach-omap1/board-voiceblue.c
index c06e7a5..07b0752 100644
--- a/arch/arm/mach-omap1/board-voiceblue.c
+++ b/arch/arm/mach-omap1/board-voiceblue.c
@@ -152,6 +152,14 @@ static void __init voiceblue_init_irq(void)
 
 static void __init voiceblue_init(void)
 {
+	/* mux pins for uarts */
+	omap_cfg_reg(UART1_TX);
+	omap_cfg_reg(UART1_RTS);
+	omap_cfg_reg(UART2_TX);
+	omap_cfg_reg(UART2_RTS);
+	omap_cfg_reg(UART3_TX);
+	omap_cfg_reg(UART3_RX);
+
 	/* Watchdog */
 	gpio_request(0, "Watchdog");
 	/* smc91x reset */
diff --git a/arch/arm/mach-omap1/serial.c b/arch/arm/mach-omap1/serial.c
index d496e50..d23979b 100644
--- a/arch/arm/mach-omap1/serial.c
+++ b/arch/arm/mach-omap1/serial.c
@@ -131,8 +131,6 @@ void __init omap_serial_init(void)
 	}
 
 	for (i = 0; i < OMAP_MAX_NR_PORTS; i++) {
-		unsigned char reg;
-
 		switch (i) {
 		case 0:
 			uart1_ck = clk_get(NULL, "uart1_ck");
@@ -143,16 +141,6 @@ void __init omap_serial_init(void)
 				if (cpu_is_omap15xx())
 					clk_set_rate(uart1_ck, 12000000);
 			}
-			if (cpu_is_omap15xx()) {
-				omap_cfg_reg(UART1_TX);
-				omap_cfg_reg(UART1_RTS);
-				if (machine_is_omap_innovator()) {
-					reg = fpga_read(OMAP1510_FPGA_POWER);
-					reg |= OMAP1510_FPGA_PCR_COM1_EN;
-					fpga_write(reg, OMAP1510_FPGA_POWER);
-					udelay(10);
-				}
-			}
 			break;
 		case 1:
 			uart2_ck = clk_get(NULL, "uart2_ck");
@@ -165,16 +153,6 @@ void __init omap_serial_init(void)
 				else
 					clk_set_rate(uart2_ck, 48000000);
 			}
-			if (cpu_is_omap15xx()) {
-				omap_cfg_reg(UART2_TX);
-				omap_cfg_reg(UART2_RTS);
-				if (machine_is_omap_innovator()) {
-					reg = fpga_read(OMAP1510_FPGA_POWER);
-					reg |= OMAP1510_FPGA_PCR_COM2_EN;
-					fpga_write(reg, OMAP1510_FPGA_POWER);
-					udelay(10);
-				}
-			}
 			break;
 		case 2:
 			uart3_ck = clk_get(NULL, "uart3_ck");
@@ -185,10 +163,6 @@ void __init omap_serial_init(void)
 				if (cpu_is_omap15xx())
 					clk_set_rate(uart3_ck, 12000000);
 			}
-			if (cpu_is_omap15xx()) {
-				omap_cfg_reg(UART3_TX);
-				omap_cfg_reg(UART3_RX);
-			}
 			break;
 		}
 		omap_serial_reset(&serial_platform_data[i]);

