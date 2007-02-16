Return-Path: <linux-kernel-owner+w=401wt.eu-S1946149AbXBPSCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946149AbXBPSCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 13:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946162AbXBPSCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 13:02:11 -0500
Received: from mail.atmel.fr ([81.80.104.162]:48653 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946149AbXBPSCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 13:02:09 -0500
X-Greylist: delayed 1491 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Feb 2007 13:02:06 EST
Message-ID: <45D5EBC3.8090208@rfo.atmel.com>
Date: Fri, 16 Feb 2007 18:37:07 +0100
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       linux-kernel@vger.kernel.org, Andrew Victor <andrew@sanpeople.com>
Subject: [PATCH] input/spi: add ads7843 support to ads7846 touchscreen driver
References: <20061222192536.A206A1F0CDB@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <200612281437.56888.david-b@pacbell.net>	
	 <200612290122.52752.dtor@insightbb.com> <200612291226.46984.david-b@pacbell.net>
In-Reply-To: <200612291226.46984.david-b@pacbell.net>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell :
[..]
> Thanks!  I'll be glad to see fewer versions of this driver floating around.
> And to see the next version of the ads7843 patches ... :) 

Hi,

Here is the ads7843 support for the ads7846 touchscreen driver. It is 
very little and takes great advantage of the previous rework.

Tested on Atmel at91sam926[13]ek board with atmel_spi underlying driver.

I also put a use case based on the at91sam9263ek init code. This code is 
just sent as an example, I will send those init patches trough AT91 
maintainer.

Index: linux-2.6.20-at91/drivers/input/touchscreen/ads7846.c
===================================================================
--- linux-2.6.20-at91.orig/drivers/input/touchscreen/ads7846.c
+++ linux-2.6.20-at91/drivers/input/touchscreen/ads7846.c
@@ -39,7 +39,8 @@
 /*
  * This code has been heavily tested on a Nokia 770, and lightly
  * tested on other ads7846 devices (OSK/Mistral, Lubbock).
- * Support for ads7843 and ads7845 has only been stubbed in.
+ * Support for ads7843 tested on Atmel at91sam926x-EK.
+ * Support for ads7845 has only been stubbed in.
  *
  * IRQ handling needs a workaround because of a shortcoming in handling
  * edge triggered IRQs on some platforms like the OMAP1/2. These
@@ -246,18 +247,15 @@ static int ads7846_read12_ser(struct dev
 
 	/* REVISIT:  take a few more samples, and compare ... */
 
-	/* maybe off internal vREF */
-	if (use_internal) {
-		req->ref_off = REF_OFF;
-		req->xfer[4].tx_buf = &req->ref_off;
-		req->xfer[4].len = 1;
-		spi_message_add_tail(&req->xfer[4], &req->msg);
-
-		req->xfer[5].rx_buf = &req->scratch;
-		req->xfer[5].len = 2;
-		CS_CHANGE(req->xfer[5]);
-		spi_message_add_tail(&req->xfer[5], &req->msg);
-	}
+	req->ref_off = REF_OFF;
+	req->xfer[4].tx_buf = &req->ref_off;
+	req->xfer[4].len = 1;
+	spi_message_add_tail(&req->xfer[4], &req->msg);
+
+	req->xfer[5].rx_buf = &req->scratch;
+	req->xfer[5].len = 2;
+	CS_CHANGE(req->xfer[5]);
+	spi_message_add_tail(&req->xfer[5], &req->msg);
 
 	ts->irq_disabled = 1;
 	disable_irq(spi->irq);
@@ -536,6 +534,10 @@ static void ads7846_rx(void *ads)
 	} else
 		Rt = 0;
 
+	if (ts->model == 7843)
+		Rt = ts->pressure_max / 2;
+
+
 	/* Sample found inconsistent by debouncing or pressure is beyond
 	 * the maximum. Don't report it to user space, repeat at least
 	 * once more the measurement


Index: linux-2.6.20-at91/arch/arm/mach-at91rm9200/board-sam9263ek.c
===================================================================
--- linux-2.6.20-at91.orig/arch/arm/mach-at91rm9200/board-sam9263ek.c
+++ linux-2.6.20-at91/arch/arm/mach-at91rm9200/board-sam9263ek.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
+#include <linux/spi/ads7846.h>
 
 #include <asm/hardware.h>
 #include <asm/setup.h>
@@ -84,6 +85,40 @@ static struct at91_udc_data __initdata e
 	.pullup_pin	= 0,		/* pull-up driven by UDC */
 };
 
+/*
+ * Touchscreen ads7843
+ */
+#if defined(CONFIG_TOUCHSCREEN_ADS7846) || defined(CONFIG_TOUCHSCREEN_ADS7846_MODULE)
+
+int ads7843_pendown_state(void)
+{
+	return !at91_get_gpio_value(AT91_PIN_PA15);
+}
+
+static struct ads7846_platform_data ads_info = {
+	.model			= 7843,
+	.x_min	= 150,	.x_max	= 3830,
+	.y_min	= 190,	.y_max	= 3830,
+	.vref_delay_usecs	= 100,
+	.x_plate_ohms		= 450,
+	.y_plate_ohms		= 250,
+	.pressure_max		= 15000,
+	.debounce_max		= 1,
+	.debounce_rep		= 0,
+	.debounce_tol		= (~0),
+	.get_pendown_state	= ads7843_pendown_state,
+};
+
+void __init at91_add_device_ts(void)
+{
+	/* Configure Interrupt 1 as external IRQ, with pullup */
+	at91_set_B_periph(AT91_PIN_PA15, 1);		/* IRQ1 */
+	/* ts busy */
+	at91_set_gpio_input(AT91_PIN_PA31, 1);
+}
+#else
+void __init at91_add_device_ts(void) {}
+#endif
 
 /*
  * SPI devices.
@@ -97,6 +132,17 @@ static struct spi_board_info ek_spi_devi
 		.bus_num	= 0,
 	},
 #endif
+#if defined(CONFIG_TOUCHSCREEN_ADS7846) || defined(CONFIG_TOUCHSCREEN_ADS7846_MODULE)
+	{
+		.modalias	= "ads7846",
+		.chip_select	= 3,
+		.max_speed_hz	= 125000	/* max sample rate at 3V */
+					* 26,	/* command + data + overhead */
+		.bus_num	= 0,
+		.platform_data	= &ads_info,
+		.irq		= AT91SAM9263_ID_IRQ1,
+	},
+#endif
 };
 
 
@@ -164,6 +210,8 @@ static void __init ek_board_init(void)
 	at91_add_device_mmc(1, &ek_mmc_data);
 	/* NAND */
 	at91_add_device_nand(&ek_nand_data);
+	/* Touchscreen */
+	at91_add_device_ts();
 }
 
 MACHINE_START(AT91SAM9263EK, "Atmel AT91SAM9263-EK")


