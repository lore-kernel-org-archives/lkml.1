Return-Path: <linux-kernel-owner+w=401wt.eu-S1756696AbZKRNFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbZKRNFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 08:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZKRNFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 08:05:35 -0500
Received: from mail.atmel.fr ([81.80.104.162]:61573 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751690AbZKRNFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 08:05:34 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: dtor@mail.ru, linux-input@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, avictor.za@gmail.com
Cc: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/4] input: atmel_tsadcc touchscreen use platform parameters
Date: Wed, 18 Nov 2009 15:12:13 +0100
Message-Id: <4d405facf88db180225b149f4155bb6a37eff8e7.1258553002.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
References: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
In-Reply-To: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
References: <693b9933de6fe9eb7e4401ca56a8f9ab6a966666.1258553002.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a number of plafrom dependent parameters to atmel_tsadcc.
The touchscreeen driver can now take into account the slight differences that
exist between IPs included in diferent products.  This will also allow to adapt
its behaivior to the caracteristics of the resistive panel used.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/input/touchscreen/atmel_tsadcc.c |   41 +++++++++++++++++++++++++----
 1 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_tsadcc.c b/drivers/input/touchscreen/atmel_tsadcc.c
index 5a2af59..3d9b516 100644
--- a/drivers/input/touchscreen/atmel_tsadcc.c
+++ b/drivers/input/touchscreen/atmel_tsadcc.c
@@ -22,6 +22,8 @@
 #include <linux/clk.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <mach/board.h>
+#include <mach/cpu.h>
 
 /* Register definitions based on AT91SAM9RL64 preliminary draft datasheet */
 
@@ -36,7 +38,9 @@
 #define	  ATMEL_TSADCC_LOWRES	(1    <<  4)	/* Resolution selection */
 #define	  ATMEL_TSADCC_SLEEP	(1    <<  5)	/* Sleep mode */
 #define	  ATMEL_TSADCC_PENDET	(1    <<  6)	/* Pen Detect selection */
+#define	  ATMEL_TSADCC_PRES	(1    <<  7)	/* Pressure Measurement Selection */
 #define	  ATMEL_TSADCC_PRESCAL	(0x3f <<  8)	/* Prescalar Rate Selection */
+#define	  ATMEL_TSADCC_EPRESCAL	(0xff <<  8)	/* Prescalar Rate Selection (Extended) */
 #define	  ATMEL_TSADCC_STARTUP	(0x7f << 16)	/* Start Up time */
 #define	  ATMEL_TSADCC_SHTIM	(0xf  << 24)	/* Sample & Hold time */
 #define	  ATMEL_TSADCC_PENDBC	(0xf  << 28)	/* Pen Detect debouncing time */
@@ -84,7 +88,13 @@
 #define ATMEL_TSADCC_CDR4	0x40	/* Channel Data 4 */
 #define ATMEL_TSADCC_CDR5	0x44	/* Channel Data 5 */
 
-#define ADC_CLOCK	1000000
+#define ATMEL_TSADCC_XPOS	0x50
+#define ATMEL_TSADCC_Z1DAT	0x54
+#define ATMEL_TSADCC_Z2DAT	0x58
+
+#define PRESCALER_VAL(x)	((x) >> 8)
+
+#define ADC_DEFAULT_CLOCK	100000
 
 struct atmel_tsadcc {
 	struct input_dev	*input;
@@ -172,6 +182,7 @@ static int __devinit atmel_tsadcc_probe(struct platform_device *pdev)
 	struct atmel_tsadcc	*ts_dev;
 	struct input_dev	*input_dev;
 	struct resource		*res;
+	struct at91_tsadcc_data *pdata = pdev->dev.platform_data;
 	int		err = 0;
 	unsigned int	prsc;
 	unsigned int	reg;
@@ -254,19 +265,37 @@ static int __devinit atmel_tsadcc_probe(struct platform_device *pdev)
 	prsc = clk_get_rate(ts_dev->clk);
 	dev_info(&pdev->dev, "Master clock is set at: %d Hz\n", prsc);
 
-	prsc = prsc / ADC_CLOCK / 2 - 1;
+	if (!pdata)
+		goto err_fail;
+
+	if (!pdata->adc_clock)
+		pdata->adc_clock = ADC_DEFAULT_CLOCK;
+
+	prsc = (prsc / (2 * pdata->adc_clock)) - 1;
+
+	/* saturate if this value is too high */
+	if (cpu_is_at91sam9rl()) {
+		if (prsc > PRESCALER_VAL(ATMEL_TSADCC_PRESCAL))
+			prsc = PRESCALER_VAL(ATMEL_TSADCC_PRESCAL);
+	} else {
+		if (prsc > PRESCALER_VAL(ATMEL_TSADCC_EPRESCAL))
+			prsc = PRESCALER_VAL(ATMEL_TSADCC_EPRESCAL);
+	}
+
+	dev_info(&pdev->dev, "Prescaler is set at: %d\n", prsc);
 
 	reg = ATMEL_TSADCC_TSAMOD_TS_ONLY_MODE		|
 		((0x00 << 5) & ATMEL_TSADCC_SLEEP)	|	/* Normal Mode */
 		((0x01 << 6) & ATMEL_TSADCC_PENDET)	|	/* Enable Pen Detect */
-		((prsc << 8) & ATMEL_TSADCC_PRESCAL)	|	/* PRESCAL */
-		((0x13 << 16) & ATMEL_TSADCC_STARTUP)	|	/* STARTUP */
-		((0x0F << 28) & ATMEL_TSADCC_PENDBC);		/* PENDBC */
+		(prsc << 8)				|
+		((0x26 << 16) & ATMEL_TSADCC_STARTUP)	|
+		((pdata->pendet_debounce << 28) & ATMEL_TSADCC_PENDBC);
 
 	atmel_tsadcc_write(ATMEL_TSADCC_CR, ATMEL_TSADCC_SWRST);
 	atmel_tsadcc_write(ATMEL_TSADCC_MR, reg);
 	atmel_tsadcc_write(ATMEL_TSADCC_TRGR, ATMEL_TSADCC_TRGMOD_NONE);
-	atmel_tsadcc_write(ATMEL_TSADCC_TSR, (0x3 << 24) & ATMEL_TSADCC_TSSHTIM);
+	atmel_tsadcc_write(ATMEL_TSADCC_TSR,
+		(pdata->ts_sample_hold_time << 24) & ATMEL_TSADCC_TSSHTIM);
 
 	atmel_tsadcc_read(ATMEL_TSADCC_SR);
 	atmel_tsadcc_write(ATMEL_TSADCC_IER, ATMEL_TSADCC_PENCNT);
-- 
1.5.6.5

