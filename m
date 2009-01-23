Return-Path: <linux-kernel-owner+w=401wt.eu-S1760107AbZAWTww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbZAWTww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758005AbZAWTuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:50:44 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:63442 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757916AbZAWTun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:50:43 -0500
Date: Fri, 23 Jan 2009 22:50:41 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] powerpc/fsl_soc: Isolate legacy fsl_spi support to
	mpc832x_rdb boards
Message-ID: <20090123195041.GF21237@oksana.dev.rtsoft.ru>
References: <20090123194958.GA17355@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090123194958.GA17355@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantages of this:
- Don't encourage legacy support;
- Less external symbols, less code to compile-in for !MPC832x_RDB
  platforms.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/platforms/83xx/mpc832x_rdb.c |  107 +++++++++++++++++++++++++++++
 arch/powerpc/sysdev/fsl_soc.c             |  107 -----------------------------
 arch/powerpc/sysdev/fsl_soc.h             |    4 -
 3 files changed, 107 insertions(+), 111 deletions(-)

diff --git a/arch/powerpc/platforms/83xx/mpc832x_rdb.c b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
index e1e7eeb..567ded7 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
@@ -20,6 +20,7 @@
 #include <linux/spi/mmc_spi.h>
 #include <linux/mmc/host.h>
 #include <linux/of_platform.h>
+#include <linux/fsl_devices.h>
 
 #include <asm/time.h>
 #include <asm/ipic.h>
@@ -39,6 +40,112 @@
 #endif
 
 #ifdef CONFIG_QUICC_ENGINE
+static int __init of_fsl_spi_probe(char *type, char *compatible, u32 sysclk,
+				   struct spi_board_info *board_infos,
+				   unsigned int num_board_infos,
+				   void (*cs_control)(struct spi_device *dev,
+						      bool on))
+{
+	struct device_node *np;
+	unsigned int i = 0;
+
+	for_each_compatible_node(np, type, compatible) {
+		int ret;
+		unsigned int j;
+		const void *prop;
+		struct resource res[2];
+		struct platform_device *pdev;
+		struct fsl_spi_platform_data pdata = {
+			.cs_control = cs_control,
+		};
+
+		memset(res, 0, sizeof(res));
+
+		pdata.sysclk = sysclk;
+
+		prop = of_get_property(np, "reg", NULL);
+		if (!prop)
+			goto err;
+		pdata.bus_num = *(u32 *)prop;
+
+		prop = of_get_property(np, "cell-index", NULL);
+		if (prop)
+			i = *(u32 *)prop;
+
+		prop = of_get_property(np, "mode", NULL);
+		if (prop && !strcmp(prop, "cpu-qe"))
+			pdata.qe_mode = 1;
+
+		for (j = 0; j < num_board_infos; j++) {
+			if (board_infos[j].bus_num == pdata.bus_num)
+				pdata.max_chipselect++;
+		}
+
+		if (!pdata.max_chipselect)
+			continue;
+
+		ret = of_address_to_resource(np, 0, &res[0]);
+		if (ret)
+			goto err;
+
+		ret = of_irq_to_resource(np, 0, &res[1]);
+		if (ret == NO_IRQ)
+			goto err;
+
+		pdev = platform_device_alloc("mpc83xx_spi", i);
+		if (!pdev)
+			goto err;
+
+		ret = platform_device_add_data(pdev, &pdata, sizeof(pdata));
+		if (ret)
+			goto unreg;
+
+		ret = platform_device_add_resources(pdev, res,
+						    ARRAY_SIZE(res));
+		if (ret)
+			goto unreg;
+
+		ret = platform_device_add(pdev);
+		if (ret)
+			goto unreg;
+
+		goto next;
+unreg:
+		platform_device_del(pdev);
+err:
+		pr_err("%s: registration failed\n", np->full_name);
+next:
+		i++;
+	}
+
+	return i;
+}
+
+static int __init fsl_spi_init(struct spi_board_info *board_infos,
+			       unsigned int num_board_infos,
+			       void (*cs_control)(struct spi_device *spi,
+						  bool on))
+{
+	u32 sysclk = -1;
+	int ret;
+
+	/* SPI controller is either clocked from QE or SoC clock */
+	sysclk = get_brgfreq();
+	if (sysclk == -1) {
+		sysclk = fsl_get_sys_freq();
+		if (sysclk == -1)
+			return -ENODEV;
+	}
+
+	ret = of_fsl_spi_probe(NULL, "fsl,spi", sysclk, board_infos,
+			       num_board_infos, cs_control);
+	if (!ret)
+		of_fsl_spi_probe("spi", "fsl_spi", sysclk, board_infos,
+				 num_board_infos, cs_control);
+
+	return spi_register_board_info(board_infos, num_board_infos);
+}
+
 static void mpc83xx_spi_cs_control(struct spi_device *spi, bool on)
 {
 	pr_debug("%s %d %d\n", __func__, spi->chip_select, on);
diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 0a545a9..18e49ef 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -413,113 +413,6 @@ err:
 
 arch_initcall(fsl_usb_of_init);
 
-static int __init of_fsl_spi_probe(char *type, char *compatible, u32 sysclk,
-				   struct spi_board_info *board_infos,
-				   unsigned int num_board_infos,
-				   void (*cs_control)(struct spi_device *dev,
-						      bool on))
-{
-	struct device_node *np;
-	unsigned int i = 0;
-
-	for_each_compatible_node(np, type, compatible) {
-		int ret;
-		unsigned int j;
-		const void *prop;
-		struct resource res[2];
-		struct platform_device *pdev;
-		struct fsl_spi_platform_data pdata = {
-			.cs_control = cs_control,
-		};
-
-		memset(res, 0, sizeof(res));
-
-		pdata.sysclk = sysclk;
-
-		prop = of_get_property(np, "reg", NULL);
-		if (!prop)
-			goto err;
-		pdata.bus_num = *(u32 *)prop;
-
-		prop = of_get_property(np, "cell-index", NULL);
-		if (prop)
-			i = *(u32 *)prop;
-
-		prop = of_get_property(np, "mode", NULL);
-		if (prop && !strcmp(prop, "cpu-qe"))
-			pdata.qe_mode = 1;
-
-		for (j = 0; j < num_board_infos; j++) {
-			if (board_infos[j].bus_num == pdata.bus_num)
-				pdata.max_chipselect++;
-		}
-
-		if (!pdata.max_chipselect)
-			continue;
-
-		ret = of_address_to_resource(np, 0, &res[0]);
-		if (ret)
-			goto err;
-
-		ret = of_irq_to_resource(np, 0, &res[1]);
-		if (ret == NO_IRQ)
-			goto err;
-
-		pdev = platform_device_alloc("mpc83xx_spi", i);
-		if (!pdev)
-			goto err;
-
-		ret = platform_device_add_data(pdev, &pdata, sizeof(pdata));
-		if (ret)
-			goto unreg;
-
-		ret = platform_device_add_resources(pdev, res,
-						    ARRAY_SIZE(res));
-		if (ret)
-			goto unreg;
-
-		ret = platform_device_add(pdev);
-		if (ret)
-			goto unreg;
-
-		goto next;
-unreg:
-		platform_device_del(pdev);
-err:
-		pr_err("%s: registration failed\n", np->full_name);
-next:
-		i++;
-	}
-
-	return i;
-}
-
-int __init fsl_spi_init(struct spi_board_info *board_infos,
-			unsigned int num_board_infos,
-			void (*cs_control)(struct spi_device *spi, bool on))
-{
-	u32 sysclk = -1;
-	int ret;
-
-#ifdef CONFIG_QUICC_ENGINE
-	/* SPI controller is either clocked from QE or SoC clock */
-	sysclk = get_brgfreq();
-#endif
-	if (sysclk == -1) {
-		sysclk = fsl_get_sys_freq();
-		if (sysclk == -1)
-			return -ENODEV;
-	}
-
-	ret = of_fsl_spi_probe(NULL, "fsl,spi", sysclk, board_infos,
-			       num_board_infos, cs_control);
-	if (!ret)
-		of_fsl_spi_probe("spi", "fsl_spi", sysclk, board_infos,
-				 num_board_infos, cs_control);
-
-	return spi_register_board_info(board_infos, num_board_infos);
-}
-
 #if defined(CONFIG_PPC_85xx) || defined(CONFIG_PPC_86xx)
 static __be32 __iomem *rstcr;
 
diff --git a/arch/powerpc/sysdev/fsl_soc.h b/arch/powerpc/sysdev/fsl_soc.h
index b5f3456..42381bb 100644
--- a/arch/powerpc/sysdev/fsl_soc.h
+++ b/arch/powerpc/sysdev/fsl_soc.h
@@ -19,10 +19,6 @@ extern u32 fsl_get_sys_freq(void);
 struct spi_board_info;
 struct device_node;
 
-extern int fsl_spi_init(struct spi_board_info *board_infos,
-			unsigned int num_board_infos,
-			void (*cs_control)(struct spi_device *spi, bool on));
-
 extern void fsl_rstcr_restart(char *cmd);
 
 #if defined(CONFIG_FB_FSL_DIU) || defined(CONFIG_FB_FSL_DIU_MODULE)
-- 
1.5.6.5
