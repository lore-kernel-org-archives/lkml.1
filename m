Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbXJWJnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbXJWJnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 05:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXJWJn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 05:43:29 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:57614 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751658AbXJWJn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 05:43:27 -0400
Date: Tue, 23 Oct 2007 11:43:14 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: [GIT PULL]
Message-ID: <20071023114314.2348d5a0@dhcp-255-175.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git for-linus

to receive the following updates. This is mostly about connecting a few
loose ends that came in through other trees, that is make sure that the
new drivers can actually be used on avr32.

Alejandro Martinez Ruiz (1):
      [AVR32] ARRAY_SIZE() cleanup

Haavard Skinnemoen (3):
      [AVR32] Fix a couple of sparse warnings
      [AVR32] Implement more at32_add_device_foo() functions
      [AVR32] Implement at32_add_device_cf()

Hans-Christian Egtvedt (1):
      [AVR32] Wire up AT73C213 sound driver on ATSTK1000 board

Kristoffer Nyborg Gregertsen (1):
      [AVR32] Platform code for pata_at32

 arch/avr32/boards/atstk1000/atstk1002.c |   58 +++++
 arch/avr32/mach-at32ap/at32ap7000.c     |  344 +++++++++++++++++++++++++++++++
 arch/avr32/mach-at32ap/extint.c         |    2 +-
 arch/avr32/mach-at32ap/pm.h             |    4 +-
 arch/avr32/mach-at32ap/time-tc.c        |    2 +-
 include/asm-avr32/arch-at32ap/board.h   |   23 ++
 6 files changed, 429 insertions(+), 4 deletions(-)

diff --git a/arch/avr32/boards/atstk1000/atstk1002.c b/arch/avr32/boards/atstk1000/atstk1002.c
index 6b9e466..5be0d13 100644
--- a/arch/avr32/boards/atstk1000/atstk1002.c
+++ b/arch/avr32/boards/atstk1000/atstk1002.c
@@ -16,6 +16,7 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/spi/spi.h>
+#include <linux/spi/at73c213.h>
 
 #include <video/atmel_lcdc.h>
 
@@ -49,7 +50,26 @@ static struct eth_platform_data __initdata eth_data[2] = {
 };
 
 #ifndef CONFIG_BOARD_ATSTK1002_SW1_CUSTOM
+#ifndef CONFIG_BOARD_ATSTK1002_SW3_CUSTOM
+static struct at73c213_board_info at73c213_data = {
+	.ssc_id		= 0,
+	.shortname	= "AVR32 STK1000 external DAC",
+};
+#endif
+#endif
+
+#ifndef CONFIG_BOARD_ATSTK1002_SW1_CUSTOM
 static struct spi_board_info spi0_board_info[] __initdata = {
+#ifndef CONFIG_BOARD_ATSTK1002_SW3_CUSTOM
+	{
+		/* AT73C213 */
+		.modalias	= "at73c213",
+		.max_speed_hz	= 200000,
+		.chip_select	= 0,
+		.mode		= SPI_MODE_1,
+		.platform_data	= &at73c213_data,
+	},
+#endif
 	{
 		/* QVGA display */
 		.modalias	= "ltv350qv",
@@ -180,6 +200,38 @@ static void setup_j2_leds(void)
 }
 #endif
 
+#ifndef CONFIG_BOARD_ATSTK1002_SW1_CUSTOM
+#ifndef CONFIG_BOARD_ATSTK1002_SW3_CUSTOM
+static void __init at73c213_set_clk(struct at73c213_board_info *info)
+{
+	struct clk *gclk;
+	struct clk *pll;
+
+	gclk = clk_get(NULL, "gclk0");
+	if (IS_ERR(gclk))
+		goto err_gclk;
+	pll = clk_get(NULL, "pll0");
+	if (IS_ERR(pll))
+		goto err_pll;
+
+	if (clk_set_parent(gclk, pll)) {
+		pr_debug("STK1000: failed to set pll0 as parent for DAC clock\n");
+		goto err_set_clk;
+	}
+
+	at32_select_periph(GPIO_PIN_PA(30), GPIO_PERIPH_A, 0);
+	info->dac_clk = gclk;
+
+err_set_clk:
+	clk_put(pll);
+err_pll:
+	clk_put(gclk);
+err_gclk:
+	return;
+}
+#endif
+#endif
+
 void __init setup_board(void)
 {
 #ifdef	CONFIG_BOARD_ATSTK1002_SW2_CUSTOM
@@ -248,6 +300,12 @@ static int __init atstk1002_init(void)
 
 	setup_j2_leds();
 
+#ifndef CONFIG_BOARD_ATSTK1002_SW3_CUSTOM
+#ifndef CONFIG_BOARD_ATSTK1002_SW1_CUSTOM
+	at73c213_set_clk(&at73c213_data);
+#endif
+#endif
+
 	return 0;
 }
 postcore_initcall(atstk1002_init);
diff --git a/arch/avr32/mach-at32ap/at32ap7000.c b/arch/avr32/mach-at32ap/at32ap7000.c
index f6d154c..a9d9ec0 100644
--- a/arch/avr32/mach-at32ap/at32ap7000.c
+++ b/arch/avr32/mach-at32ap/at32ap7000.c
@@ -556,6 +556,17 @@ static struct clk pico_clk = {
 	.users		= 1,
 };
 
+static struct resource dmaca0_resource[] = {
+	{
+		.start	= 0xff200000,
+		.end	= 0xff20ffff,
+		.flags	= IORESOURCE_MEM,
+	},
+	IRQ(2),
+};
+DEFINE_DEV(dmaca, 0);
+DEV_CLK(hclk, dmaca0, hsb, 10);
+
 /* --------------------------------------------------------------------
  * HMATRIX
  * -------------------------------------------------------------------- */
@@ -655,6 +666,7 @@ void __init at32_add_system_devices(void)
 	platform_device_register(&at32_eic0_device);
 	platform_device_register(&smc0_device);
 	platform_device_register(&pdc_device);
+	platform_device_register(&dmaca0_device);
 
 	platform_device_register(&at32_systc0_device);
 
@@ -960,6 +972,96 @@ at32_add_device_spi(unsigned int id, struct spi_board_info *b, unsigned int n)
 }
 
 /* --------------------------------------------------------------------
+ *  TWI
+ * -------------------------------------------------------------------- */
+static struct resource atmel_twi0_resource[] __initdata = {
+	PBMEM(0xffe00800),
+	IRQ(5),
+};
+static struct clk atmel_twi0_pclk = {
+	.name		= "twi_pclk",
+	.parent		= &pba_clk,
+	.mode		= pba_clk_mode,
+	.get_rate	= pba_clk_get_rate,
+	.index		= 2,
+};
+
+struct platform_device *__init at32_add_device_twi(unsigned int id)
+{
+	struct platform_device *pdev;
+
+	if (id != 0)
+		return NULL;
+
+	pdev = platform_device_alloc("atmel_twi", id);
+	if (!pdev)
+		return NULL;
+
+	if (platform_device_add_resources(pdev, atmel_twi0_resource,
+				ARRAY_SIZE(atmel_twi0_resource)))
+		goto err_add_resources;
+
+	select_peripheral(PA(6),  PERIPH_A, 0);	/* SDA	*/
+	select_peripheral(PA(7),  PERIPH_A, 0);	/* SDL	*/
+
+	atmel_twi0_pclk.dev = &pdev->dev;
+
+	platform_device_add(pdev);
+	return pdev;
+
+err_add_resources:
+	platform_device_put(pdev);
+	return NULL;
+}
+
+/* --------------------------------------------------------------------
+ * MMC
+ * -------------------------------------------------------------------- */
+static struct resource atmel_mci0_resource[] __initdata = {
+	PBMEM(0xfff02400),
+	IRQ(28),
+};
+static struct clk atmel_mci0_pclk = {
+	.name		= "mci_clk",
+	.parent		= &pbb_clk,
+	.mode		= pbb_clk_mode,
+	.get_rate	= pbb_clk_get_rate,
+	.index		= 9,
+};
+
+struct platform_device *__init at32_add_device_mci(unsigned int id)
+{
+	struct platform_device *pdev;
+
+	if (id != 0)
+		return NULL;
+
+	pdev = platform_device_alloc("atmel_mci", id);
+	if (!pdev)
+		return NULL;
+
+	if (platform_device_add_resources(pdev, atmel_mci0_resource,
+				ARRAY_SIZE(atmel_mci0_resource)))
+		goto err_add_resources;
+
+	select_peripheral(PA(10), PERIPH_A, 0);	/* CLK	 */
+	select_peripheral(PA(11), PERIPH_A, 0);	/* CMD	 */
+	select_peripheral(PA(12), PERIPH_A, 0);	/* DATA0 */
+	select_peripheral(PA(13), PERIPH_A, 0);	/* DATA1 */
+	select_peripheral(PA(14), PERIPH_A, 0);	/* DATA2 */
+	select_peripheral(PA(15), PERIPH_A, 0);	/* DATA3 */
+
+	atmel_mci0_pclk.dev = &pdev->dev;
+
+	platform_device_add(pdev);
+	return pdev;
+
+err_add_resources:
+	platform_device_put(pdev);
+	return NULL;
+}
+
+/* --------------------------------------------------------------------
  *  LCDC
  * -------------------------------------------------------------------- */
 static struct atmel_lcdfb_info atmel_lcdfb0_data;
@@ -1228,6 +1330,241 @@ out_free_pdev:
 }
 
 /* --------------------------------------------------------------------
+ * IDE / CompactFlash
+ * -------------------------------------------------------------------- */
+static struct resource at32_smc_cs4_resource[] __initdata = {
+	{
+		.start	= 0x04000000,
+		.end	= 0x07ffffff,
+		.flags	= IORESOURCE_MEM,
+	},
+	IRQ(~0UL), /* Magic IRQ will be overridden */
+};
+static struct resource at32_smc_cs5_resource[] __initdata = {
+	{
+		.start	= 0x20000000,
+		.end	= 0x23ffffff,
+		.flags	= IORESOURCE_MEM,
+	},
+	IRQ(~0UL), /* Magic IRQ will be overridden */
+};
+
+static int __init at32_init_ide_or_cf(struct platform_device *pdev,
+		unsigned int cs, unsigned int extint)
+{
+	static unsigned int extint_pin_map[4] __initdata = {
+		GPIO_PIN_PB(25),
+		GPIO_PIN_PB(26),
+		GPIO_PIN_PB(27),
+		GPIO_PIN_PB(28),
+	};
+	static bool common_pins_initialized __initdata = false;
+	unsigned int extint_pin;
+	int ret;
+
+	if (extint >= ARRAY_SIZE(extint_pin_map))
+		return -EINVAL;
+	extint_pin = extint_pin_map[extint];
+
+	switch (cs) {
+	case 4:
+		ret = platform_device_add_resources(pdev,
+				at32_smc_cs4_resource,
+				ARRAY_SIZE(at32_smc_cs4_resource));
+		if (ret)
+			return ret;
+
+		select_peripheral(PE(21), PERIPH_A, 0); /* NCS4   -> OE_N  */
+		set_ebi_sfr_bits(HMATRIX_BIT(CS4A));
+		break;
+	case 5:
+		ret = platform_device_add_resources(pdev,
+				at32_smc_cs5_resource,
+				ARRAY_SIZE(at32_smc_cs5_resource));
+		if (ret)
+			return ret;
+
+		select_peripheral(PE(22), PERIPH_A, 0); /* NCS5   -> OE_N  */
+		set_ebi_sfr_bits(HMATRIX_BIT(CS5A));
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (!common_pins_initialized) {
+		select_peripheral(PE(19), PERIPH_A, 0);	/* CFCE1  -> CS0_N */
+		select_peripheral(PE(20), PERIPH_A, 0);	/* CFCE2  -> CS1_N */
+		select_peripheral(PE(23), PERIPH_A, 0); /* CFRNW  -> DIR   */
+		select_peripheral(PE(24), PERIPH_A, 0); /* NWAIT  <- IORDY */
+		common_pins_initialized = true;
+	}
+
+	at32_select_periph(extint_pin, GPIO_PERIPH_A, AT32_GPIOF_DEGLITCH);
+
+	pdev->resource[1].start = EIM_IRQ_BASE + extint;
+	pdev->resource[1].end = pdev->resource[1].start;
+
+	return 0;
+}
+
+struct platform_device *__init
+at32_add_device_ide(unsigned int id, unsigned int extint,
+		    struct ide_platform_data *data)
+{
+	struct platform_device *pdev;
+
+	pdev = platform_device_alloc("at32_ide", id);
+	if (!pdev)
+		goto fail;
+
+	if (platform_device_add_data(pdev, data,
+				sizeof(struct ide_platform_data)))
+		goto fail;
+
+	if (at32_init_ide_or_cf(pdev, data->cs, extint))
+		goto fail;
+
+	platform_device_add(pdev);
+	return pdev;
+
+fail:
+	platform_device_put(pdev);
+	return NULL;
+}
+
+struct platform_device *__init
+at32_add_device_cf(unsigned int id, unsigned int extint,
+		    struct cf_platform_data *data)
+{
+	struct platform_device *pdev;
+
+	pdev = platform_device_alloc("at32_cf", id);
+	if (!pdev)
+		goto fail;
+
+	if (platform_device_add_data(pdev, data,
+				sizeof(struct cf_platform_data)))
+		goto fail;
+
+	if (at32_init_ide_or_cf(pdev, data->cs, extint))
+		goto fail;
+
+	if (data->detect_pin != GPIO_PIN_NONE)
+		at32_select_gpio(data->detect_pin, AT32_GPIOF_DEGLITCH);
+	if (data->reset_pin != GPIO_PIN_NONE)
+		at32_select_gpio(data->reset_pin, 0);
+	if (data->vcc_pin != GPIO_PIN_NONE)
+		at32_select_gpio(data->vcc_pin, 0);
+	/* READY is used as extint, so we can't select it as gpio */
+
+	platform_device_add(pdev);
+	return pdev;
+
+fail:
+	platform_device_put(pdev);
+	return NULL;
+}
+
+/* --------------------------------------------------------------------
+ * AC97C
+ * -------------------------------------------------------------------- */
+static struct resource atmel_ac97c0_resource[] __initdata = {
+	PBMEM(0xfff02800),
+	IRQ(29),
+};
+static struct clk atmel_ac97c0_pclk = {
+	.name		= "pclk",
+	.parent		= &pbb_clk,
+	.mode		= pbb_clk_mode,
+	.get_rate	= pbb_clk_get_rate,
+	.index		= 10,
+};
+
+struct platform_device *__init at32_add_device_ac97c(unsigned int id)
+{
+	struct platform_device *pdev;
+
+	if (id != 0)
+		return NULL;
+
+	pdev = platform_device_alloc("atmel_ac97c", id);
+	if (!pdev)
+		return NULL;
+
+	if (platform_device_add_resources(pdev, atmel_ac97c0_resource,
+				ARRAY_SIZE(atmel_ac97c0_resource)))
+		goto err_add_resources;
+
+	select_peripheral(PB(20), PERIPH_B, 0);	/* SYNC	*/
+	select_peripheral(PB(21), PERIPH_B, 0);	/* SDO	*/
+	select_peripheral(PB(22), PERIPH_B, 0);	/* SDI	*/
+	select_peripheral(PB(23), PERIPH_B, 0);	/* SCLK	*/
+
+	atmel_ac97c0_pclk.dev = &pdev->dev;
+
+	platform_device_add(pdev);
+	return pdev;
+
+err_add_resources:
+	platform_device_put(pdev);
+	return NULL;
+}
+
+/* --------------------------------------------------------------------
+ * ABDAC
+ * -------------------------------------------------------------------- */
+static struct resource abdac0_resource[] __initdata = {
+	PBMEM(0xfff02000),
+	IRQ(27),
+};
+static struct clk abdac0_pclk = {
+	.name		= "pclk",
+	.parent		= &pbb_clk,
+	.mode		= pbb_clk_mode,
+	.get_rate	= pbb_clk_get_rate,
+	.index		= 8,
+};
+static struct clk abdac0_sample_clk = {
+	.name		= "sample_clk",
+	.mode		= genclk_mode,
+	.get_rate	= genclk_get_rate,
+	.set_rate	= genclk_set_rate,
+	.set_parent	= genclk_set_parent,
+	.index		= 6,
+};
+
+struct platform_device *__init at32_add_device_abdac(unsigned int id)
+{
+	struct platform_device *pdev;
+
+	if (id != 0)
+		return NULL;
+
+	pdev = platform_device_alloc("abdac", id);
+	if (!pdev)
+		return NULL;
+
+	if (platform_device_add_resources(pdev, abdac0_resource,
+				ARRAY_SIZE(abdac0_resource)))
+		goto err_add_resources;
+
+	select_peripheral(PB(20), PERIPH_A, 0);	/* DATA1	*/
+	select_peripheral(PB(21), PERIPH_A, 0);	/* DATA0	*/
+	select_peripheral(PB(22), PERIPH_A, 0);	/* DATAN1	*/
+	select_peripheral(PB(23), PERIPH_A, 0);	/* DATAN0	*/
+
+	abdac0_pclk.dev = &pdev->dev;
+	abdac0_sample_clk.dev = &pdev->dev;
+
+	platform_device_add(pdev);
+	return pdev;
+
+err_add_resources:
+	platform_device_put(pdev);
+	return NULL;
+}
+
+/* --------------------------------------------------------------------
  *  GCLK
  * -------------------------------------------------------------------- */
 static struct clk gclk0 = {
@@ -1290,6 +1627,7 @@ struct clk *at32_clock_list[] = {
 	&smc0_mck,
 	&pdc_hclk,
 	&pdc_pclk,
+	&dmaca0_hclk,
 	&pico_clk,
 	&pio0_mck,
 	&pio1_mck,
@@ -1307,6 +1645,8 @@ struct clk *at32_clock_list[] = {
 	&macb1_pclk,
 	&atmel_spi0_spi_clk,
 	&atmel_spi1_spi_clk,
+	&atmel_twi0_pclk,
+	&atmel_mci0_pclk,
 	&atmel_lcdfb0_hck1,
 	&atmel_lcdfb0_pixclk,
 	&ssc0_pclk,
@@ -1314,6 +1654,9 @@ struct clk *at32_clock_list[] = {
 	&ssc2_pclk,
 	&usba0_hclk,
 	&usba0_pclk,
+	&atmel_ac97c0_pclk,
+	&abdac0_pclk,
+	&abdac0_sample_clk,
 	&gclk0,
 	&gclk1,
 	&gclk2,
@@ -1355,6 +1698,7 @@ void __init at32_clock_init(void)
 	genclk_init_parent(&gclk3);
 	genclk_init_parent(&gclk4);
 	genclk_init_parent(&atmel_lcdfb0_pixclk);
+	genclk_init_parent(&abdac0_sample_clk);
 
 	/*
 	 * Turn on all clocks that have at least one user already, and
diff --git a/arch/avr32/mach-at32ap/extint.c b/arch/avr32/mach-at32ap/extint.c
index 8acd010..f5bfd4c 100644
--- a/arch/avr32/mach-at32ap/extint.c
+++ b/arch/avr32/mach-at32ap/extint.c
@@ -142,7 +142,7 @@ static int eic_set_irq_type(unsigned int irq, unsigned int flow_type)
 	return ret;
 }
 
-struct irq_chip eic_chip = {
+static struct irq_chip eic_chip = {
 	.name		= "eic",
 	.ack		= eic_ack_irq,
 	.mask		= eic_mask_irq,
diff --git a/arch/avr32/mach-at32ap/pm.h b/arch/avr32/mach-at32ap/pm.h
index 47efd0d..694d521 100644
--- a/arch/avr32/mach-at32ap/pm.h
+++ b/arch/avr32/mach-at32ap/pm.h
@@ -113,8 +113,8 @@
 
 /* Register access macros */
 #define pm_readl(reg)							\
-	__raw_readl((void __iomem *)AT32_PM_BASE + PM_##reg)
+	__raw_readl((void __iomem __force *)AT32_PM_BASE + PM_##reg)
 #define pm_writel(reg,value)						\
-	__raw_writel((value), (void __iomem *)AT32_PM_BASE + PM_##reg)
+	__raw_writel((value), (void __iomem __force *)AT32_PM_BASE + PM_##reg)
 
 #endif /* __ARCH_AVR32_MACH_AT32AP_PM_H__ */
diff --git a/arch/avr32/mach-at32ap/time-tc.c b/arch/avr32/mach-at32ap/time-tc.c
index e3070bd..1026586 100644
--- a/arch/avr32/mach-at32ap/time-tc.c
+++ b/arch/avr32/mach-at32ap/time-tc.c
@@ -79,7 +79,7 @@ static int avr32_timer_calc_div_and_set_jiffies(struct clk *pclk)
 {
 	unsigned int cycles_max = (clocksource_avr32.mask + 1) / 2;
 	unsigned int divs[] = { 4, 8, 16, 32 };
-	int divs_size = sizeof(divs) / sizeof(*divs);
+	int divs_size = ARRAY_SIZE(divs);
 	int i = 0;
 	unsigned long count_hz;
 	unsigned long shift;
diff --git a/include/asm-avr32/arch-at32ap/board.h b/include/asm-avr32/arch-at32ap/board.h
index 7dbd603..d6993a6 100644
--- a/include/asm-avr32/arch-at32ap/board.h
+++ b/include/asm-avr32/arch-at32ap/board.h
@@ -44,6 +44,13 @@ struct usba_platform_data {
 struct platform_device *
 at32_add_device_usba(unsigned int id, struct usba_platform_data *data);
 
+struct ide_platform_data {
+	u8      cs;
+};
+struct platform_device *
+at32_add_device_ide(unsigned int id, unsigned int extint,
+		    struct ide_platform_data *data);
+
 /* depending on what's hooked up, not all SSC pins will be used */
 #define	ATMEL_SSC_TK		0x01
 #define	ATMEL_SSC_TF		0x02
@@ -58,4 +65,20 @@ at32_add_device_usba(unsigned int id, struct usba_platform_data *data);
 struct platform_device *
 at32_add_device_ssc(unsigned int id, unsigned int flags);
 
+struct platform_device *at32_add_device_twi(unsigned int id);
+struct platform_device *at32_add_device_mci(unsigned int id);
+struct platform_device *at32_add_device_ac97c(unsigned int id);
+struct platform_device *at32_add_device_abdac(unsigned int id);
+
+struct cf_platform_data {
+	int	detect_pin;
+	int	reset_pin;
+	int	vcc_pin;
+	int	ready_pin;
+	u8	cs;
+};
+struct platform_device *
+at32_add_device_cf(unsigned int id, unsigned int extint,
+		struct cf_platform_data *data);
+
 #endif /* __ASM_ARCH_BOARD_H */
