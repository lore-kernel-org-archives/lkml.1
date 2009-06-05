Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbZFEIQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbZFEIQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755854AbZFEIGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37489 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511AbZFEIFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 30/62] Blackfin: BF518F-EZBRD: handle required portmuxing of async pins
Date: Fri,  5 Jun 2009 04:04:39 -0400
Message-Id: <1244189111-19639-31-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

The two high address lines on the BF51x are not dedicated which means we
need to handle them like any other peripheral pin if we want to access the
upper 2MB of parallel flash.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf518/boards/ezbrd.c         |    9 +++++++++
 arch/blackfin/mach-bf518/include/mach/portmux.h |    6 +++++-
 2 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/mach-bf518/boards/ezbrd.c b/arch/blackfin/mach-bf518/boards/ezbrd.c
index 41f2eac..602dce0 100644
--- a/arch/blackfin/mach-bf518/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf518/boards/ezbrd.c
@@ -82,7 +82,11 @@ static struct physmap_flash_data ezbrd_flash_data = {
 
 static struct resource ezbrd_flash_resource = {
 	.start = 0x20000000,
+#if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
+	.end   = 0x202fffff,
+#else
 	.end   = 0x203fffff,
+#endif
 	.flags = IORESOURCE_MEM,
 };
 
@@ -678,6 +682,11 @@ static int __init ezbrd_init(void)
 				ARRAY_SIZE(bfin_i2c_board_info));
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
+	/* setup BF518-EZBRD GPIO pin PG11 to AMS2, PG15 to AMS3. */
+	peripheral_request(P_AMS2, "ParaFlash");
+#if !defined(CONFIG_SPI_BFIN) && !defined(CONFIG_SPI_BFIN_MODULE)
+	peripheral_request(P_AMS3, "ParaFlash");
+#endif
 	return 0;
 }
 
diff --git a/arch/blackfin/mach-bf518/include/mach/portmux.h b/arch/blackfin/mach-bf518/include/mach/portmux.h
index f618b48..a0fc77f 100644
--- a/arch/blackfin/mach-bf518/include/mach/portmux.h
+++ b/arch/blackfin/mach-bf518/include/mach/portmux.h
@@ -185,6 +185,10 @@
 #define P_PTP_PPS		(P_DEFINED | P_IDENT(GPIO_PG12) | P_FUNCT(2))
 #define P_PTP_CLKOUT		(P_DEFINED | P_IDENT(GPIO_PG13) | P_FUNCT(2))
 
-#define P_HWAIT		(P_DEFINED | P_IDENT(GPIO_PG000000000) | P_FUNCT(1))
+/* AMS */
+#define P_AMS2			(P_DEFINED | P_IDENT(GPIO_PG11) | P_FUNCT(1))
+#define P_AMS3			(P_DEFINED | P_IDENT(GPIO_PG15) | P_FUNCT(2))
+
+#define P_HWAIT			(P_DEFINED | P_IDENT(GPIO_PG000000000) | P_FUNCT(1))
 
 #endif				/* _MACH_PORTMUX_H_ */
-- 
1.6.3.1

