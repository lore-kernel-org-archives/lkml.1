Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbYKDRHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbYKDRHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbYKDRHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:07:46 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:33391 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531AbYKDRHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:07:45 -0500
Date: Tue, 4 Nov 2008 18:07:44 +0100
From: Marc Zyngier <maz@misterjones.org>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] Port Arcom/Eurotech Viper over the
 gpio_request_set API
Message-ID: <20081104180744.5ce2f360@not-of-this-earth.wild-wind.fr.eu.org>
In-Reply-To: <20081104175725.1872b4ed@not-of-this-earth.wild-wind.fr.eu.org>
References: <20081104175725.1872b4ed@not-of-this-earth.wild-wind.fr.eu.org>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 81.53.103.82
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As a proof of concept, use the gpio_request_set/gpio_free_set
functions in place of the open-coded stuff used on the Viper SBC.

Signed-off-by: Marc Zyngier <maz@misterjones.org>
---
 arch/arm/mach-pxa/viper.c     |   87 +++++++++++++----------------------------
 drivers/pcmcia/pxa2xx_viper.c |   49 +++++++++--------------
 2 files changed, 46 insertions(+), 90 deletions(-)

diff --git a/arch/arm/mach-pxa/viper.c b/arch/arm/mach-pxa/viper.c
index f5d1757..1355f91 100644
--- a/arch/arm/mach-pxa/viper.c
+++ b/arch/arm/mach-pxa/viper.c
@@ -343,35 +343,21 @@ static struct pxafb_mach_info fb_info = {
 	.lcd_conn		= LCD_COLOR_TFT_16BPP | LCD_PCLK_EDGE_FALL,
 };
 
+/* GPIO9 and 10 control FB backlight. Initialise to off */
+static struct gpio_config viper_backlight_gpio[] = {
+	{ VIPER_BCKLIGHT_EN_GPIO, "Backlight", GPIO_CONFIG_DIRECTION_OUTPUT, 0 },
+	{ VIPER_LCD_EN_GPIO, "LCD", GPIO_CONFIG_DIRECTION_OUTPUT, 0 },
+};
+
 static int viper_backlight_init(struct device *dev)
 {
 	int ret;
+	struct gpio_config *failed;
 
-	/* GPIO9 and 10 control FB backlight. Initialise to off */
-	ret = gpio_request(VIPER_BCKLIGHT_EN_GPIO, "Backlight");
-	if (ret)
-		goto err_request_bckl;
-
-	ret = gpio_request(VIPER_LCD_EN_GPIO, "LCD");
-	if (ret)
-		goto err_request_lcd;
-
-	ret = gpio_direction_output(VIPER_BCKLIGHT_EN_GPIO, 0);
-	if (ret)
-		goto err_dir;
+	ret = gpio_request_set(ARRAY_AND_SIZE(viper_backlight_gpio), &failed);
 
-	ret = gpio_direction_output(VIPER_LCD_EN_GPIO, 0);
 	if (ret)
-		goto err_dir;
-
-	return 0;
-
-err_dir:
-	gpio_free(VIPER_LCD_EN_GPIO);
-err_request_lcd:
-	gpio_free(VIPER_BCKLIGHT_EN_GPIO);
-err_request_bckl:
-	dev_err(dev, "Failed to setup LCD GPIOs\n");
+	        dev_err(dev, "Failed to setup %s GPIO\n", failed->label);
 
 	return ret;
 }
@@ -386,8 +372,7 @@ static int viper_backlight_notify(int brightness)
 
 static void viper_backlight_exit(struct device *dev)
 {
-	gpio_free(VIPER_LCD_EN_GPIO);
-	gpio_free(VIPER_BCKLIGHT_EN_GPIO);
+	gpio_free_set(ARRAY_AND_SIZE(viper_backlight_gpio));
 }
 
 static struct platform_pwm_backlight_data viper_backlight_data = {
@@ -817,51 +802,33 @@ error_tpm:
 	pr_err("viper: Couldn't %s, giving up\n", errstr);
 }
 
+static struct gpio_config __initdata viper_vcore_gpios[] = {
+	{ VIPER_PSU_DATA_GPIO, "PSU data", GPIO_CONFIG_DIRECTION_OUTPUT, 0, },
+	{ VIPER_PSU_CLK_GPIO, "PSU clock", GPIO_CONFIG_DIRECTION_OUTPUT, 0, },
+	{ VIPER_PSU_nCS_LD_GPIO, "PSU cs", GPIO_CONFIG_DIRECTION_OUTPUT, 0, },
+};
+
 static void __init viper_init_vcore_gpios(void)
 {
-	if (gpio_request(VIPER_PSU_DATA_GPIO, "PSU data"))
-		goto err_request_data;
-
-	if (gpio_request(VIPER_PSU_CLK_GPIO, "PSU clock"))
-		goto err_request_clk;
+	struct gpio_config *failed;
 
-	if (gpio_request(VIPER_PSU_nCS_LD_GPIO, "PSU cs"))
-		goto err_request_cs;
-
-	if (gpio_direction_output(VIPER_PSU_DATA_GPIO, 0) ||
-	    gpio_direction_output(VIPER_PSU_CLK_GPIO, 0) ||
-	    gpio_direction_output(VIPER_PSU_nCS_LD_GPIO, 0))
-		goto err_dir;
+	if (gpio_request_set(ARRAY_AND_SIZE(viper_vcore_gpios), &failed)) {
+		pr_err("viper: Failed to setup %s GPIO\n", failed->label);
+		return;
+	}
 
 	/* c/should assume redboot set the correct level ??? */
 	viper_set_core_cpu_voltage(get_clk_frequency_khz(0), 1);
-
-	return;
-
-err_dir:
-	gpio_free(VIPER_PSU_nCS_LD_GPIO);
-err_request_cs:
-	gpio_free(VIPER_PSU_CLK_GPIO);
-err_request_clk:
-	gpio_free(VIPER_PSU_DATA_GPIO);
-err_request_data:
-	pr_err("viper: Failed to setup vcore control GPIOs\n");
 }
 
+static struct gpio_config __initdata viper_serial_gpio[] = {
+	{ VIPER_UART_SHDN_GPIO, "UARTs shutdown", GPIO_CONFIG_DIRECTION_OUTPUT, 0, },
+};
+
 static void __init viper_init_serial_gpio(void)
 {
-	if (gpio_request(VIPER_UART_SHDN_GPIO, "UARTs shutdown"))
-		goto err_request;
-
-	if (gpio_direction_output(VIPER_UART_SHDN_GPIO, 0))
-		goto err_dir;
-
-	return;
-
-err_dir:
-	gpio_free(VIPER_UART_SHDN_GPIO);
-err_request:
-	pr_err("viper: Failed to setup UART shutdown GPIO\n");
+	if (gpio_request_set(ARRAY_AND_SIZE(viper_serial_gpio), NULL))
+		pr_err("viper: Failed to setup UART shutdown GPIO\n");
 }
 
 #ifdef CONFIG_CPU_FREQ
diff --git a/drivers/pcmcia/pxa2xx_viper.c b/drivers/pcmcia/pxa2xx_viper.c
index dd10481..0f39558 100644
--- a/drivers/pcmcia/pxa2xx_viper.c
+++ b/drivers/pcmcia/pxa2xx_viper.c
@@ -37,44 +37,35 @@ static struct pcmcia_irqs irqs[] = {
 	{ 0, gpio_to_irq(VIPER_CF_CD_GPIO),  "PCMCIA_CD" }
 };
 
+/* GPIO 82 is the CF power enable line. initially off */
+static struct gpio_config viper_pcmcia_gpios[] = {
+	{ VIPER_CF_CD_GPIO, "CF detect", GPIO_CONFIG_DIRECTION_INPUT, },
+	{ VIPER_CF_RDY_GPIO, "CF ready", GPIO_CONFIG_DIRECTION_INPUT, },
+	{ VIPER_CF_POWER_GPIO, "CF power", GPIO_CONFIG_DIRECTION_OUTPUT, 0, },
+};
+
 static int viper_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 {
 	unsigned long flags;
+	int ret;
+	struct gpio_config *failed;
 
 	skt->irq = gpio_to_irq(VIPER_CF_RDY_GPIO);
 
-	if (gpio_request(VIPER_CF_CD_GPIO, "CF detect"))
-		goto err_request_cd;
-
-	if (gpio_request(VIPER_CF_RDY_GPIO, "CF ready"))
-		goto err_request_rdy;
-
-	if (gpio_request(VIPER_CF_POWER_GPIO, "CF power"))
-		goto err_request_pwr;
-
 	local_irq_save(flags);
 
-	/* GPIO 82 is the CF power enable line. initially off */
-	if (gpio_direction_output(VIPER_CF_POWER_GPIO, 0) ||
-	    gpio_direction_input(VIPER_CF_CD_GPIO) ||
-	    gpio_direction_input(VIPER_CF_RDY_GPIO)) {
-		local_irq_restore(flags);
-		goto err_dir;
-	}
-
+	ret = gpio_request_set(viper_pcmcia_gpios,
+			       ARRAY_SIZE(viper_pcmcia_gpios),
+			       &failed);
+	
 	local_irq_restore(flags);
 
-	return soc_pcmcia_request_irqs(skt, irqs, ARRAY_SIZE(irqs));
+	if (ret) {
+		pr_err("viper: Failed to setup %s GPIOs\n", failed->label);
+		return ret;
+	}
 
-err_dir:
-	gpio_free(VIPER_CF_POWER_GPIO);
-err_request_pwr:
-	gpio_free(VIPER_CF_RDY_GPIO);
-err_request_rdy:
-	gpio_free(VIPER_CF_CD_GPIO);
-err_request_cd:
-	printk(KERN_ERR "viper: Failed to setup PCMCIA GPIOs\n");
-	return -1;
+	return soc_pcmcia_request_irqs(skt, irqs, ARRAY_SIZE(irqs));
 }
 
 /*
@@ -83,9 +74,7 @@ err_request_cd:
 static void viper_pcmcia_hw_shutdown(struct soc_pcmcia_socket *skt)
 {
 	soc_pcmcia_free_irqs(skt, irqs, ARRAY_SIZE(irqs));
-	gpio_free(VIPER_CF_POWER_GPIO);
-	gpio_free(VIPER_CF_RDY_GPIO);
-	gpio_free(VIPER_CF_CD_GPIO);
+	gpio_free_set(viper_pcmcia_gpios, ARRAY_SIZE(viper_pcmcia_gpios));
 }
 
 static void viper_pcmcia_socket_state(struct soc_pcmcia_socket *skt,
-- 
1.5.4.3


-- 
A rat a day keeps the plague away.
