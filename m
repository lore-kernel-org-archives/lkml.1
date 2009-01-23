Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbZAWTvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbZAWTvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbZAWTuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:50:37 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:63416 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757605AbZAWTuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:50:35 -0500
Date: Fri, 23 Jan 2009 22:50:33 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] spi_mpc83xx: Rework chip selects handling
Message-ID: <20090123195033.GB21237@oksana.dev.rtsoft.ru>
References: <20090123194958.GA17355@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090123194958.GA17355@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main purpose of this patch is to pass 'struct spi_device' to the
chip select handling routines. This is needed so that we could implement
full-fledged OpenFirmware support for this driver.

While at it, also:
- Replace two {de,activate}_cs routines by single cs_contol().
- Don't duplicate platform data callbacks in mpc83xx_spi struct.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 arch/powerpc/platforms/83xx/mpc832x_rdb.c |   16 ++++------------
 arch/powerpc/sysdev/fsl_soc.c             |   14 ++++++--------
 arch/powerpc/sysdev/fsl_soc.h             |    5 +++--
 drivers/spi/spi_mpc83xx.c                 |   20 +++++++-------------
 include/linux/fsl_devices.h               |    5 +++--
 5 files changed, 23 insertions(+), 37 deletions(-)

diff --git a/arch/powerpc/platforms/83xx/mpc832x_rdb.c b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
index 2a1295f..28e23cd 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_rdb.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_rdb.c
@@ -39,16 +39,10 @@
 #endif
 
 #ifdef CONFIG_QUICC_ENGINE
-static void mpc83xx_spi_activate_cs(u8 cs, u8 polarity)
+static void mpc83xx_spi_cs_control(struct spi_device *spi, bool on)
 {
-	pr_debug("%s %d %d\n", __func__, cs, polarity);
-	par_io_data_set(3, 13, polarity);
-}
-
-static void mpc83xx_spi_deactivate_cs(u8 cs, u8 polarity)
-{
-	pr_debug("%s %d %d\n", __func__, cs, polarity);
-	par_io_data_set(3, 13, !polarity);
+	pr_debug("%s %d %d\n", __func__, spi->chip_select, on);
+	par_io_data_set(3, 13, on);
 }
 
 static struct mmc_spi_platform_data mpc832x_mmc_pdata = {
@@ -74,9 +68,7 @@ static int __init mpc832x_spi_init(void)
 	par_io_config_pin(3, 14, 2, 0, 0, 0); /* SD_INSERT, I */
 	par_io_config_pin(3, 15, 2, 0, 0, 0); /* SD_PROTECT,I */
 
-	return fsl_spi_init(&mpc832x_spi_boardinfo, 1,
-			    mpc83xx_spi_activate_cs,
-			    mpc83xx_spi_deactivate_cs);
+	return fsl_spi_init(&mpc832x_spi_boardinfo, 1, mpc83xx_spi_cs_control);
 }
 machine_device_initcall(mpc832x_rdb, mpc832x_spi_init);
 #endif /* CONFIG_QUICC_ENGINE */
diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index 115cb16..0a545a9 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -416,8 +416,8 @@ arch_initcall(fsl_usb_of_init);
 static int __init of_fsl_spi_probe(char *type, char *compatible, u32 sysclk,
 				   struct spi_board_info *board_infos,
 				   unsigned int num_board_infos,
-				   void (*activate_cs)(u8 cs, u8 polarity),
-				   void (*deactivate_cs)(u8 cs, u8 polarity))
+				   void (*cs_control)(struct spi_device *dev,
+						      bool on))
 {
 	struct device_node *np;
 	unsigned int i = 0;
@@ -429,8 +429,7 @@ static int __init of_fsl_spi_probe(char *type, char *compatible, u32 sysclk,
 		struct resource res[2];
 		struct platform_device *pdev;
 		struct fsl_spi_platform_data pdata = {
-			.activate_cs = activate_cs,
-			.deactivate_cs = deactivate_cs,
+			.cs_control = cs_control,
 		};
 
 		memset(res, 0, sizeof(res));
@@ -497,8 +496,7 @@ next:
 
 int __init fsl_spi_init(struct spi_board_info *board_infos,
 			unsigned int num_board_infos,
-			void (*activate_cs)(u8 cs, u8 polarity),
-			void (*deactivate_cs)(u8 cs, u8 polarity))
+			void (*cs_control)(struct spi_device *spi, bool on))
 {
 	u32 sysclk = -1;
 	int ret;
@@ -514,10 +512,10 @@ int __init fsl_spi_init(struct spi_board_info *board_infos,
 	}
 
 	ret = of_fsl_spi_probe(NULL, "fsl,spi", sysclk, board_infos,
-			       num_board_infos, activate_cs, deactivate_cs);
+			       num_board_infos, cs_control);
 	if (!ret)
 		of_fsl_spi_probe("spi", "fsl_spi", sysclk, board_infos,
-				 num_board_infos, activate_cs, deactivate_cs);
+				 num_board_infos, cs_control);
 
 	return spi_register_board_info(board_infos, num_board_infos);
 }
diff --git a/arch/powerpc/sysdev/fsl_soc.h b/arch/powerpc/sysdev/fsl_soc.h
index 9c744e4..b5f3456 100644
--- a/arch/powerpc/sysdev/fsl_soc.h
+++ b/arch/powerpc/sysdev/fsl_soc.h
@@ -4,6 +4,8 @@
 
 #include <asm/mmu.h>
 
+struct spi_device;
+
 extern phys_addr_t get_immrbase(void);
 #if defined(CONFIG_CPM2) || defined(CONFIG_QUICC_ENGINE) || defined(CONFIG_8xx)
 extern u32 get_brgfreq(void);
@@ -19,8 +21,7 @@ struct device_node;
 
 extern int fsl_spi_init(struct spi_board_info *board_infos,
 			unsigned int num_board_infos,
-			void (*activate_cs)(u8 cs, u8 polarity),
-			void (*deactivate_cs)(u8 cs, u8 polarity));
+			void (*cs_control)(struct spi_device *spi, bool on));
 
 extern void fsl_rstcr_restart(char *cmd);
 
diff --git a/drivers/spi/spi_mpc83xx.c b/drivers/spi/spi_mpc83xx.c
index 6ef8937..056d200 100644
--- a/drivers/spi/spi_mpc83xx.c
+++ b/drivers/spi/spi_mpc83xx.c
@@ -89,9 +89,6 @@ struct mpc83xx_spi {
 
 	bool qe_mode;
 
-	void (*activate_cs) (u8 cs, u8 polarity);
-	void (*deactivate_cs) (u8 cs, u8 polarity);
-
 	u8 busy;
 
 	struct workqueue_struct *workqueue;
@@ -153,15 +150,14 @@ MPC83XX_SPI_TX_BUF(u32)
 
 static void mpc83xx_spi_chipselect(struct spi_device *spi, int value)
 {
-	struct mpc83xx_spi *mpc83xx_spi;
-	u8 pol = spi->mode & SPI_CS_HIGH ? 1 : 0;
+	struct mpc83xx_spi *mpc83xx_spi = spi_master_get_devdata(spi->master);
+	struct fsl_spi_platform_data *pdata = spi->dev.parent->platform_data;
+	bool pol = spi->mode & SPI_CS_HIGH;
 	struct spi_mpc83xx_cs	*cs = spi->controller_state;
 
-	mpc83xx_spi = spi_master_get_devdata(spi->master);
-
 	if (value == BITBANG_CS_INACTIVE) {
-		if (mpc83xx_spi->deactivate_cs)
-			mpc83xx_spi->deactivate_cs(spi->chip_select, pol);
+		if (pdata->cs_control)
+			pdata->cs_control(spi, !pol);
 	}
 
 	if (value == BITBANG_CS_ACTIVE) {
@@ -186,8 +182,8 @@ static void mpc83xx_spi_chipselect(struct spi_device *spi, int value)
 			mpc83xx_spi_write_reg(mode, regval);
 			local_irq_restore(flags);
 		}
-		if (mpc83xx_spi->activate_cs)
-			mpc83xx_spi->activate_cs(spi->chip_select, pol);
+		if (pdata->cs_control)
+			pdata->cs_control(spi, pol);
 	}
 }
 
@@ -582,8 +578,6 @@ static int __init mpc83xx_spi_probe(struct platform_device *dev)
 	master->cleanup = mpc83xx_spi_cleanup;
 
 	mpc83xx_spi = spi_master_get_devdata(master);
-	mpc83xx_spi->activate_cs = pdata->activate_cs;
-	mpc83xx_spi->deactivate_cs = pdata->deactivate_cs;
 	mpc83xx_spi->qe_mode = pdata->qe_mode;
 	mpc83xx_spi->get_rx = mpc83xx_spi_rx_buf_u8;
 	mpc83xx_spi->get_tx = mpc83xx_spi_tx_buf_u8;
diff --git a/include/linux/fsl_devices.h b/include/linux/fsl_devices.h
index d9051d7..7bc1b64 100644
--- a/include/linux/fsl_devices.h
+++ b/include/linux/fsl_devices.h
@@ -95,14 +95,15 @@ struct fsl_usb2_platform_data {
 #define FSL_USB2_PORT0_ENABLED	0x00000001
 #define FSL_USB2_PORT1_ENABLED	0x00000002
 
+struct spi_device;
+
 struct fsl_spi_platform_data {
 	u32 	initial_spmode;	/* initial SPMODE value */
 	u16	bus_num;
 	bool	qe_mode;
 	/* board specific information */
 	u16	max_chipselect;
-	void	(*activate_cs)(u8 cs, u8 polarity);
-	void	(*deactivate_cs)(u8 cs, u8 polarity);
+	void	(*cs_control)(struct spi_device *spi, bool on);
 	u32	sysclk;
 };
 
-- 
1.5.6.5

