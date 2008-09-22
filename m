Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbYIVQkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbYIVQkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 12:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753923AbYIVQi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 12:38:57 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:35086 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791AbYIVQiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 12:38:52 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH 2/4] atmel-mci: Platform code for supporting multiple mmc slots
Date: Mon, 22 Sep 2008 18:38:15 +0200
Message-Id: <1222101497-21183-3-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1222101497-21183-2-git-send-email-haavard.skinnemoen@atmel.com>
References: <1222101497-21183-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1222101497-21183-2-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 22 Sep 2008 16:38:05.0970 (UTC) FILETIME=[96C05720:01C91CD1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary platform infrastructure to support multiple mmc/sdcard
slots all at once through a single controller. Currently, the driver
will use the first valid slot it finds and stick with that, but later
patches will add support for switching between several slots on the fly.

Extend the platform data structure with per-slot information: MMC/SDcard
bus width and card detect/write protect pins. This will affect the pin
muxing as well as the capabilities announced to the mmc core.

Note that board code is now required to supply a mci_platform_data
struct to at32_add_device_mci().

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 arch/avr32/boards/atngw100/setup.c      |    7 ++-
 arch/avr32/boards/atstk1000/atstk1002.c |   18 +++++---
 arch/avr32/boards/atstk1000/atstk1003.c |   12 +++++-
 arch/avr32/boards/atstk1000/atstk1004.c |   12 +++++-
 arch/avr32/include/asm/atmel-mci.h      |   23 +++++++++-
 arch/avr32/mach-at32ap/at32ap700x.c     |   74 +++++++++++++++++++++++--------
 drivers/mmc/host/atmel-mci-regs.h       |    6 ++-
 drivers/mmc/host/atmel-mci.c            |   26 +++++++++--
 8 files changed, 140 insertions(+), 38 deletions(-)

diff --git a/arch/avr32/boards/atngw100/setup.c b/arch/avr32/boards/atngw100/setup.c
index b8286f1..f308520 100644
--- a/arch/avr32/boards/atngw100/setup.c
+++ b/arch/avr32/boards/atngw100/setup.c
@@ -53,8 +53,11 @@ static struct spi_board_info spi0_board_info[] __initdata = {
 };
 
 static struct mci_platform_data __initdata mci0_data = {
-	.detect_pin	= GPIO_PIN_PC(25),
-	.wp_pin		= GPIO_PIN_PE(0),
+	.slot[0] = {
+		.bus_width	= 4,
+		.detect_pin	= GPIO_PIN_PC(25),
+		.wp_pin		= GPIO_PIN_PE(0),
+	},
 };
 
 /*
diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index dfc3443..4fedbc4 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -264,16 +264,20 @@ void __init setup_board(void)
 
 #ifndef CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
 
+static struct mci_platform_data __initdata mci0_data = {
+	.slot[0] = {
+		.bus_width	= 4,
+
 /* MMC card detect requires MACB0 *NOT* be used */
 #ifdef CONFIG_BOARD_ATSTK1002_SW6_CUSTOM
-static struct mci_platform_data __initdata mci0_data = {
-	.detect_pin	= GPIO_PIN_PC(14),	/* gpio30/sdcd */
-	.wp_pin		= GPIO_PIN_PC(15),	/* gpio31/sdwp */
-};
-#define MCI_PDATA	&mci0_data
+		.detect_pin	= GPIO_PIN_PC(14), /* gpio30/sdcd */
+		.wp_pin		= GPIO_PIN_PC(15), /* gpio31/sdwp */
 #else
-#define MCI_PDATA	NULL
+		.detect_pin	= -ENODEV,
+		.wp_pin		= -ENODEV,
 #endif	/* SW6 for sd{cd,wp} routing */
+	},
+};
 
 #endif	/* SW2 for MMC signal routing */
 
@@ -326,7 +330,7 @@ static int __init atstk1002_init(void)
 	at32_add_device_spi(1, spi1_board_info, ARRAY_SIZE(spi1_board_info));
 #endif
 #ifndef CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
-	at32_add_device_mci(0, MCI_PDATA);
+	at32_add_device_mci(0, &mci0_pdata);
 #endif
 #ifdef CONFIG_BOARD_ATSTK1002_SW5_CUSTOM
 	set_hw_addr(at32_add_device_eth(1, &eth_data[1]));
diff --git a/arch/avr32/boards/atstk1000/atstk1003.c b/arch/avr32/boards/atstk1000/atstk1003.c
index 0cf6641..acc6123 100644
--- a/arch/avr32/boards/atstk1000/atstk1003.c
+++ b/arch/avr32/boards/atstk1000/atstk1003.c
@@ -66,6 +66,16 @@ static struct spi_board_info spi1_board_info[] __initdata = { {
 } };
 #endif
 
+#ifndef CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
+static struct mci_platform_data __initdata mci0_data = {
+	.slot[0] = {
+		.bus_width	= 4,
+		.detect_pin	= -ENODEV,
+		.wp_pin		= -ENODEV,
+	},
+};
+#endif
+
 #ifdef CONFIG_BOARD_ATSTK1000_EXTDAC
 static void __init atstk1003_setup_extdac(void)
 {
@@ -154,7 +164,7 @@ static int __init atstk1003_init(void)
 	at32_add_device_spi(1, spi1_board_info, ARRAY_SIZE(spi1_board_info));
 #endif
 #ifndef CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
-	at32_add_device_mci(0, NULL);
+	at32_add_device_mci(0, &mci0_data);
 #endif
 	at32_add_device_usba(0, NULL);
 #ifndef CONFIG_BOARD_ATSTK100X_SW3_CUSTOM
diff --git a/arch/avr32/boards/atstk1000/atstk1004.c b/arch/avr32/boards/atstk1000/atstk1004.c
index 50a5273..d6a2d02 100644
--- a/arch/avr32/boards/atstk1000/atstk1004.c
+++ b/arch/avr32/boards/atstk1000/atstk1004.c
@@ -71,6 +71,16 @@ static struct spi_board_info spi1_board_info[] __initdata = { {
 } };
 #endif
 
+#ifndef CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
+static struct mci_platform_data __initdata mci0_data = {
+	.slot[0] = {
+		.bus_width	= 4,
+		.detect_pin	= -ENODEV,
+		.wp_pin		= -ENODEV,
+	},
+};
+#endif
+
 #ifdef CONFIG_BOARD_ATSTK1000_EXTDAC
 static void __init atstk1004_setup_extdac(void)
 {
@@ -137,7 +147,7 @@ static int __init atstk1004_init(void)
 	at32_add_device_spi(1, spi1_board_info, ARRAY_SIZE(spi1_board_info));
 #endif
 #ifndef CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
-	at32_add_device_mci(0, NULL);
+	at32_add_device_mci(0, &mci0_data);
 #endif
 	at32_add_device_lcdc(0, &atstk1000_lcdc_data,
 			     fbmem_start, fbmem_size, 0);
diff --git a/arch/avr32/include/asm/atmel-mci.h b/arch/avr32/include/asm/atmel-mci.h
index c2ea6e1..27371c2 100644
--- a/arch/avr32/include/asm/atmel-mci.h
+++ b/arch/avr32/include/asm/atmel-mci.h
@@ -1,9 +1,30 @@
 #ifndef __ASM_AVR32_ATMEL_MCI_H
 #define __ASM_AVR32_ATMEL_MCI_H
 
-struct mci_platform_data {
+/**
+ * struct mci_slot_pdata - board-specific per-slot configuration
+ * @bus_width: Number of data lines wired up the slot
+ * @detect_pin: GPIO pin wired to the card detect switch
+ * @wp_pin: GPIO pin wired to the write protect sensor
+ *
+ * If a given slot is not present on the board, @bus_width should be
+ * set to 0. The other fields are ignored in this case.
+ *
+ * Any pins that aren't available should be set to a negative value.
+ */
+struct mci_slot_pdata {
+	unsigned int		bus_width;
 	int			detect_pin;
 	int			wp_pin;
 };
 
+/**
+ * struct mci_platform_data - board-specific MMC/SDcard configuration
+ * @dma_slave: DMA slave interface to use in data transfers, or NULL.
+ * @slot: Per-slot configuration data.
+ */
+struct mci_platform_data {
+	struct mci_slot_pdata	slot[2];
+};
+
 #endif /* __ASM_AVR32_ATMEL_MCI_H */
diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
index e01dbe4..9967d5a 100644
--- a/arch/avr32/mach-at32ap/at32ap700x.c
+++ b/arch/avr32/mach-at32ap/at32ap700x.c
@@ -1272,10 +1272,13 @@ static struct clk atmel_mci0_pclk = {
 struct platform_device *__init
 at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 {
-	struct mci_platform_data	_data;
 	struct platform_device		*pdev;
 
-	if (id != 0)
+	if (id != 0 || !data)
+		return NULL;
+
+	/* Must have at least one usable slot */
+	if (!data->slot[0].bus_width && !data->slot[1].bus_width)
 		return NULL;
 
 	pdev = platform_device_alloc("atmel_mci", id);
@@ -1286,28 +1289,61 @@ at32_add_device_mci(unsigned int id, struct mci_platform_data *data)
 				ARRAY_SIZE(atmel_mci0_resource)))
 		goto fail;
 
-	if (!data) {
-		data = &_data;
-		memset(data, -1, sizeof(struct mci_platform_data));
-		data->detect_pin = GPIO_PIN_NONE;
-		data->wp_pin = GPIO_PIN_NONE;
-	}
 
 	if (platform_device_add_data(pdev, data,
 				sizeof(struct mci_platform_data)))
 		goto fail;
 
-	select_peripheral(PA(10), PERIPH_A, 0);	/* CLK	 */
-	select_peripheral(PA(11), PERIPH_A, 0);	/* CMD	 */
-	select_peripheral(PA(12), PERIPH_A, 0);	/* DATA0 */
-	select_peripheral(PA(13), PERIPH_A, 0);	/* DATA1 */
-	select_peripheral(PA(14), PERIPH_A, 0);	/* DATA2 */
-	select_peripheral(PA(15), PERIPH_A, 0);	/* DATA3 */
+	/* CLK line is common to both slots */
+	select_peripheral(PA(10), PERIPH_A, 0);
 
-	if (gpio_is_valid(data->detect_pin))
-		at32_select_gpio(data->detect_pin, 0);
-	if (gpio_is_valid(data->wp_pin))
-		at32_select_gpio(data->wp_pin, 0);
+	switch (data->slot[0].bus_width) {
+	case 4:
+		select_peripheral(PA(13), PERIPH_A, 0);	/* DATA1 */
+		select_peripheral(PA(14), PERIPH_A, 0);	/* DATA2 */
+		select_peripheral(PA(15), PERIPH_A, 0);	/* DATA3 */
+		/* fall through */
+	case 1:
+		select_peripheral(PA(11), PERIPH_A, 0);	/* CMD	 */
+		select_peripheral(PA(12), PERIPH_A, 0);	/* DATA0 */
+
+		if (gpio_is_valid(data->slot[0].detect_pin))
+			at32_select_gpio(data->slot[0].detect_pin, 0);
+		if (gpio_is_valid(data->slot[0].wp_pin))
+			at32_select_gpio(data->slot[0].wp_pin, 0);
+		break;
+	case 0:
+		/* Slot is unused */
+		break;
+	default:
+		goto fail;
+	}
+
+	switch (data->slot[1].bus_width) {
+	case 4:
+		select_peripheral(PB(8),  PERIPH_B, 0);	/* DATA1 */
+		select_peripheral(PB(9),  PERIPH_B, 0);	/* DATA2 */
+		select_peripheral(PB(10), PERIPH_B, 0);	/* DATA3 */
+		/* fall through */
+	case 1:
+		select_peripheral(PB(6),  PERIPH_B, 0); /* CMD	 */
+		select_peripheral(PB(7),  PERIPH_B, 0); /* DATA0 */
+
+		if (gpio_is_valid(data->slot[1].detect_pin))
+			at32_select_gpio(data->slot[1].detect_pin, 0);
+		if (gpio_is_valid(data->slot[1].wp_pin))
+			at32_select_gpio(data->slot[1].wp_pin, 0);
+		break;
+	case 0:
+		/* Slot is unused */
+		break;
+	default:
+		if (!data->slot[0].bus_width)
+			goto fail;
+
+		data->slot[1].bus_width = 0;
+		break;
+	}
 
 	atmel_mci0_pclk.dev = &pdev->dev;
 
diff --git a/drivers/mmc/host/atmel-mci-regs.h b/drivers/mmc/host/atmel-mci-regs.h
index 26bd80e..b58364e 100644
--- a/drivers/mmc/host/atmel-mci-regs.h
+++ b/drivers/mmc/host/atmel-mci-regs.h
@@ -25,8 +25,10 @@
 #define MCI_SDCR		0x000c	/* SD Card / SDIO */
 # define MCI_SDCSEL_SLOT_A	(  0 <<  0)	/* Select SD slot A */
 # define MCI_SDCSEL_SLOT_B	(  1 <<  0)	/* Select SD slot A */
-# define MCI_SDCBUS_1BIT	(  0 <<  7)	/* 1-bit data bus */
-# define MCI_SDCBUS_4BIT	(  1 <<  7)	/* 4-bit data bus */
+# define MCI_SDCSEL_MASK	(  3 <<  0)
+# define MCI_SDCBUS_1BIT	(  0 <<  6)	/* 1-bit data bus */
+# define MCI_SDCBUS_4BIT	(  2 <<  6)	/* 4-bit data bus */
+# define MCI_SDCBUS_MASK	(  3 <<  6)
 #define MCI_ARGR		0x0010	/* Command Argument */
 #define MCI_CMDR		0x0014	/* Command */
 # define MCI_CMDR_CMDNB(x)	((x) <<  0)	/* Command Opcode */
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index caa67fe..e2d321a 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -544,12 +544,13 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 					| MCI_MR_RDPROOF;
 	}
 
+	host->sdc_reg &= ~MCI_SDCBUS_MASK;
 	switch (ios->bus_width) {
 	case MMC_BUS_WIDTH_1:
-		host->sdc_reg = 0;
+		host->sdc_reg |= MCI_SDCBUS_1BIT;
 		break;
 	case MMC_BUS_WIDTH_4:
-		host->sdc_reg = MCI_SDCBUS_4BIT;
+		host->sdc_reg |= MCI_SDCBUS_4BIT;
 		break;
 	}
 
@@ -1028,9 +1029,11 @@ static irqreturn_t atmci_detect_interrupt(int irq, void *dev_id)
 static int __init atmci_probe(struct platform_device *pdev)
 {
 	struct mci_platform_data	*pdata;
+	struct mci_slot_pdata		*slot;
 	struct atmel_mci *host;
 	struct mmc_host *mmc;
 	struct resource *regs;
+	u32 sdc_reg;
 	int irq;
 	int ret;
 
@@ -1044,6 +1047,17 @@ static int __init atmci_probe(struct platform_device *pdev)
 	if (irq < 0)
 		return irq;
 
+	/* TODO: Allow using several slots at once */
+	if (pdata->slot[0].bus_width) {
+		sdc_reg = MCI_SDCSEL_SLOT_A;
+		slot = &pdata->slot[0];
+	} else if (pdata->slot[1].bus_width) {
+		sdc_reg = MCI_SDCSEL_SLOT_B;
+		slot = &pdata->slot[1];
+	} else {
+		return -EINVAL;
+	}
+
 	mmc = mmc_alloc_host(sizeof(struct atmel_mci), &pdev->dev);
 	if (!mmc)
 		return -ENOMEM;
@@ -1051,8 +1065,9 @@ static int __init atmci_probe(struct platform_device *pdev)
 	host = mmc_priv(mmc);
 	host->pdev = pdev;
 	host->mmc = mmc;
-	host->detect_pin = pdata->detect_pin;
-	host->wp_pin = pdata->wp_pin;
+	host->detect_pin = slot->detect_pin;
+	host->wp_pin = slot->wp_pin;
+	host->sdc_reg = sdc_reg;
 
 	host->mck = clk_get(&pdev->dev, "mci_clk");
 	if (IS_ERR(host->mck)) {
@@ -1076,7 +1091,8 @@ static int __init atmci_probe(struct platform_device *pdev)
 	mmc->f_min = (host->bus_hz + 511) / 512;
 	mmc->f_max = host->bus_hz / 2;
 	mmc->ocr_avail	= MMC_VDD_32_33 | MMC_VDD_33_34;
-	mmc->caps |= MMC_CAP_4_BIT_DATA;
+	if (slot->bus_width >= 4)
+		mmc->caps |= MMC_CAP_4_BIT_DATA;
 
 	mmc->max_hw_segs = 64;
 	mmc->max_phys_segs = 64;
-- 
1.5.6.5

