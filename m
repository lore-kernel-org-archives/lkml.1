Return-Path: <linux-kernel-owner+w=401wt.eu-S1762354AbXEUKLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762354AbXEUKLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761046AbXEUKJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:17 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:5145 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbXEUKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:11 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="30505442:sNHT23617384"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 17/32] Blackfin arch: move board specific setup out of common init code and into the board specific init code
Date: Mon, 21 May 2007 18:09:25 +0800
Message-Id: <11797421851258-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/kernel/setup.c            |   20 ++------------------
 arch/blackfin/mach-bf533/boards/stamp.c |   19 ++++++++++++++++---
 arch/blackfin/mach-bf561/boards/ezkit.c |   15 ++++++++++-----
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index c456ee5..b6ac6f8 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -383,35 +383,19 @@ void __init setup_arch(char **cmdline_p)
 
 	bf53x_cache_init();
 
-#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
-# if defined(CONFIG_BFIN_SHARED_FLASH_ENET) && defined(CONFIG_BFIN533_STAMP)
-	/* setup BF533_STAMP CPLD to route AMS3 to Ethernet MAC */
-	bfin_write_FIO_DIR(bfin_read_FIO_DIR() | (1 << CONFIG_ENET_FLASH_PIN));
-	bfin_write_FIO_FLAG_S(1 << CONFIG_ENET_FLASH_PIN);
-	SSYNC();
-# endif
-# if defined (CONFIG_BFIN561_EZKIT)
-	bfin_write_FIO0_DIR(bfin_read_FIO0_DIR() | (1 << 12));
-	SSYNC();
-# endif /* defined (CONFIG_BFIN561_EZKIT) */
-#endif
-
 	printk(KERN_INFO "Hardware Trace Enabled\n");
 	bfin_write_TBUFCTL(0x03);
 }
 
-#if defined(CONFIG_BF561)
-static struct cpu cpu[2];
-#else
-static struct cpu cpu[1];
-#endif
 static int __init topology_init(void)
 {
 #if defined (CONFIG_BF561)
+	static struct cpu cpu[2];
 	register_cpu(&cpu[0], 0);
 	register_cpu(&cpu[1], 1);
 	return 0;
 #else
+	static struct cpu cpu[1];
 	return register_cpu(cpu, 0);
 #endif
 }
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index 7d3dfcb..9a472fe 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -338,12 +338,25 @@ static struct platform_device *stamp_devices[] __initdata = {
 
 static int __init stamp_init(void)
 {
+	int ret;
+
 	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
-	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
+	ret = platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
+	if (ret < 0)
+		return ret;
+
+#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+# if defined(CONFIG_BFIN_SHARED_FLASH_ENET)
+	/* setup BF533_STAMP CPLD to route AMS3 to Ethernet MAC */
+	bfin_write_FIO_DIR(bfin_read_FIO_DIR() | (1 << CONFIG_ENET_FLASH_PIN));
+	bfin_write_FIO_FLAG_S(1 << CONFIG_ENET_FLASH_PIN);
+	SSYNC();
+# endif
+#endif
+
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
-	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
+	return spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 #endif
-	return 0;
 }
 
 arch_initcall(stamp_init);
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index e8d4058..9720b5c 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -184,13 +184,18 @@ static int __init ezkit_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
-	ret = platform_add_devices(ezkit_devices,
-		 ARRAY_SIZE(ezkit_devices));
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
+
+	ret = platform_add_devices(ezkit_devices, ARRAY_SIZE(ezkit_devices));
 	if (ret < 0)
 		return ret;
-	return spi_register_board_info(bfin_spi_board_info,
-				ARRAY_SIZE(bfin_spi_board_info));
+
+#if defined(CONFIG_SMC91X) || defined(CONFIG_SMC91X_MODULE)
+	bfin_write_FIO0_DIR(bfin_read_FIO0_DIR() | (1 << 12));
+	SSYNC();
+#endif
+
+	return spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
 }
 
 arch_initcall(ezkit_init);
-- 
1.5.1.2
