Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZKRNHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZKRNHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 08:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756980AbZKRNHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 08:07:33 -0500
Received: from mail.atmel.fr ([81.80.104.162]:63587 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756964AbZKRNHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 08:07:31 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dtor@mail.ru, linux-input@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, avictor.za@gmail.com
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3/4] at91/input: platform parameters for atmel_tsadcc in at91sam9rlek
Date: Wed, 18 Nov 2009 15:12:14 +0100
Message-Id: <453bec224c36844e26c6a79b312336549cf131ef.1258553002.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
References: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
In-Reply-To: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
References: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup platform parameters in at91sam9rl-ek board to be passed to atmel_tsadcc
touchscreen.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9rl_devices.c |   10 ++++++++--
 arch/arm/mach-at91/board-sam9rlek.c     |   12 +++++++++++-
 arch/arm/mach-at91/include/mach/board.h |    7 ++++++-
 3 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index d345f54..53aaa94 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -622,6 +622,7 @@ static void __init at91_add_device_tc(void) { }
 
 #if defined(CONFIG_TOUCHSCREEN_ATMEL_TSADCC) || defined(CONFIG_TOUCHSCREEN_ATMEL_TSADCC_MODULE)
 static u64 tsadcc_dmamask = DMA_BIT_MASK(32);
+static struct at91_tsadcc_data tsadcc_data;
 
 static struct resource tsadcc_resources[] = {
 	[0] = {
@@ -642,22 +643,27 @@ static struct platform_device at91sam9rl_tsadcc_device = {
 	.dev		= {
 				.dma_mask		= &tsadcc_dmamask,
 				.coherent_dma_mask	= DMA_BIT_MASK(32),
+				.platform_data		= &tsadcc_data,
 	},
 	.resource	= tsadcc_resources,
 	.num_resources	= ARRAY_SIZE(tsadcc_resources),
 };
 
-void __init at91_add_device_tsadcc(void)
+void __init at91_add_device_tsadcc(struct at91_tsadcc_data *data)
 {
+	if (!data)
+		return;
+
 	at91_set_A_periph(AT91_PIN_PA17, 0);	/* AD0_XR */
 	at91_set_A_periph(AT91_PIN_PA18, 0);	/* AD1_XL */
 	at91_set_A_periph(AT91_PIN_PA19, 0);	/* AD2_YT */
 	at91_set_A_periph(AT91_PIN_PA20, 0);	/* AD3_TB */
 
+	tsadcc_data = *data;
 	platform_device_register(&at91sam9rl_tsadcc_device);
 }
 #else
-void __init at91_add_device_tsadcc(void) {}
+void __init at91_add_device_tsadcc(struct at91_tsadcc_data *data) {}
 #endif
 
 
diff --git a/arch/arm/mach-at91/board-sam9rlek.c b/arch/arm/mach-at91/board-sam9rlek.c
index bd28e98..7ac20f3 100644
--- a/arch/arm/mach-at91/board-sam9rlek.c
+++ b/arch/arm/mach-at91/board-sam9rlek.c
@@ -243,6 +243,16 @@ static struct gpio_led ek_leds[] = {
 
 
 /*
+ * Touchscreen
+ */
+static struct at91_tsadcc_data ek_tsadcc_data = {
+	.adc_clock		= 1000000,
+	.pendet_debounce	= 0x0f,
+	.ts_sample_hold_time	= 0x03,
+};
+
+
+/*
  * GPIO Buttons
  */
 #if defined(CONFIG_KEYBOARD_GPIO) || defined(CONFIG_KEYBOARD_GPIO_MODULE)
@@ -310,7 +320,7 @@ static void __init ek_board_init(void)
 	/* AC97 */
 	at91_add_device_ac97(&ek_ac97_data);
 	/* Touch Screen Controller */
-	at91_add_device_tsadcc();
+	at91_add_device_tsadcc(&ek_tsadcc_data);
 	/* LEDs */
 	at91_gpio_leds(ek_leds, ARRAY_SIZE(ek_leds));
 	/* Push Buttons */
diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
index 2f4fced..6f1579f 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -186,7 +186,12 @@ extern void __init at91_add_device_ac97(struct ac97c_platform_data *data);
 extern void __init at91_add_device_isi(void);
 
  /* Touchscreen Controller */
-extern void __init at91_add_device_tsadcc(void);
+struct at91_tsadcc_data {
+	unsigned int    adc_clock;
+	u8		pendet_debounce;
+	u8		ts_sample_hold_time;
+};
+extern void __init at91_add_device_tsadcc(struct at91_tsadcc_data *data);
 
 /* CAN */
 struct at91_can_data {
-- 
1.5.6.5

