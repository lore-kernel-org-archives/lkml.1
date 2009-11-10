Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbZKJP14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbZKJP14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbZKJP1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:27:54 -0500
Received: from smtp.nokia.com ([192.100.122.230]:36875 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756044AbZKJP1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:27:46 -0500
From: Ilkka Koskinen <ilkka.koskinen@nokia.com>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: linux-omap@vger.kernel.org, ext-ari.kauppi@nokia.com
Subject: [PATCH v3] mfd: Initial support for twl5031
Date: Tue, 10 Nov 2009 17:26:15 +0200
Message-Id: <1257866775-2638-1-git-send-email-ilkka.koskinen@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 10 Nov 2009 15:27:31.0207 (UTC) FILETIME=[51A74970:01CA621A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TWL5031 introduces two new interrupts in PIH. Moreover, BCI
has changed remarkably and, thus, it's disabled when TWL5031
is in use.

Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
---
 drivers/mfd/twl4030-core.c  |   13 ++++-
 drivers/mfd/twl4030-irq.c   |  131 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/i2c/twl4030.h |   47 +++++++++++++--
 3 files changed, 180 insertions(+), 11 deletions(-)

diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index 9b74f88..61c2bb7 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -152,6 +152,10 @@
 #define TWL4030_BASEADD_PWMB		0x00F1
 #define TWL4030_BASEADD_KEYPAD		0x00D2
 
+#define TWL5031_BASEADD_ACCESSORY	0x0074 /* Replaces Main Charge */
+#define TWL5031_BASEADD_INTERRUPTS	0x00B9 /* Different than TWL4030's
+						  one */
+
 /* subchip/slave 3 - POWER ID */
 #define TWL4030_BASEADD_BACKUP		0x0014
 #define TWL4030_BASEADD_INT		0x002E
@@ -183,6 +187,7 @@
 /* chip-specific feature flags, for i2c_device_id.driver_data */
 #define TWL4030_VAUX2		BIT(0)	/* pre-5030 voltage ranges */
 #define TPS_SUBSET		BIT(1)	/* tps659[23]0 have fewer LDOs */
+#define TWL5031			BIT(2)  /* twl5031 has different registers */
 
 /*----------------------------------------------------------------------*/
 
@@ -235,6 +240,8 @@ static struct twl4030mapping twl4030_map[TWL4030_MODULE_LAST + 1] = {
 	{ 2, TWL4030_BASEADD_PWM1 },
 	{ 2, TWL4030_BASEADD_PWMA },
 	{ 2, TWL4030_BASEADD_PWMB },
+	{ 2, TWL5031_BASEADD_ACCESSORY },
+	{ 2, TWL5031_BASEADD_INTERRUPTS },
 
 	{ 3, TWL4030_BASEADD_BACKUP },
 	{ 3, TWL4030_BASEADD_INT },
@@ -482,7 +489,8 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 {
 	struct device	*child;
 
-	if (twl_has_bci() && pdata->bci && !(features & TPS_SUBSET)) {
+	if (twl_has_bci() && pdata->bci &&
+	    !(features & (TPS_SUBSET | TWL5031))) {
 		child = add_child(3, "twl4030_bci",
 				pdata->bci, sizeof(*pdata->bci),
 				false,
@@ -746,6 +754,7 @@ static void clocks_init(struct device *dev,
 
 int twl_init_irq(int irq_num, unsigned irq_base, unsigned irq_end);
 int twl_exit_irq(void);
+int twl_init_chip_irq(const char *chip);
 
 static int twl4030_remove(struct i2c_client *client)
 {
@@ -821,6 +830,7 @@ twl4030_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (client->irq
 			&& pdata->irq_base
 			&& pdata->irq_end > pdata->irq_base) {
+		twl_init_chip_irq(id->name);
 		status = twl_init_irq(client->irq, pdata->irq_base, pdata->irq_end);
 		if (status < 0)
 			goto fail;
@@ -836,6 +846,7 @@ fail:
 static const struct i2c_device_id twl4030_ids[] = {
 	{ "twl4030", TWL4030_VAUX2 },	/* "Triton 2" */
 	{ "twl5030", 0 },		/* T2 updated */
+	{ "twl5031", TWL5031 },		/* TWL5030 updated */
 	{ "tps65950", 0 },		/* catalog version of twl5030 */
 	{ "tps65930", TPS_SUBSET },	/* fewer LDOs and DACs; no charger */
 	{ "tps65920", TPS_SUBSET },	/* fewer LDOs; no codec or charger */
diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
index fb194fe..0b73302 100644
--- a/drivers/mfd/twl4030-irq.c
+++ b/drivers/mfd/twl4030-irq.c
@@ -74,6 +74,8 @@ struct sih {
 	u8	edr_offset;
 	u8	bytes_edr;		/* bytelen of EDR */
 
+	u8	irq_lines;		/* number of supported irq lines */
+
 	/* SIR ignored -- set interrupt, for testing only */
 	struct irq_data {
 		u8	isr_offset;
@@ -82,6 +84,9 @@ struct sih {
 	/* + 2 bytes padding */
 };
 
+static const struct sih *sih_modules;
+static int nr_sih_modules;
+
 #define SIH_INITIALIZER(modname, nbits) \
 	.module		= TWL4030_MODULE_ ## modname, \
 	.control_offset = TWL4030_ ## modname ## _SIH_CTRL, \
@@ -89,6 +94,7 @@ struct sih {
 	.bytes_ixr	= DIV_ROUND_UP(nbits, 8), \
 	.edr_offset	= TWL4030_ ## modname ## _EDR, \
 	.bytes_edr	= DIV_ROUND_UP((2*(nbits)), 8), \
+	.irq_lines	= 2, \
 	.mask = { { \
 		.isr_offset	= TWL4030_ ## modname ## _ISR1, \
 		.imr_offset	= TWL4030_ ## modname ## _IMR1, \
@@ -107,7 +113,8 @@ struct sih {
 /* Order in this table matches order in PIH_ISR.  That is,
  * BIT(n) in PIH_ISR is sih_modules[n].
  */
-static const struct sih sih_modules[6] = {
+/* sih_modules_twl4030 is used both in twl4030 and twl5030 */
+static const struct sih sih_modules_twl4030[6] = {
 	[0] = {
 		.name		= "gpio",
 		.module		= TWL4030_MODULE_GPIO,
@@ -118,6 +125,7 @@ static const struct sih sih_modules[6] = {
 		/* Note: *all* of these IRQs default to no-trigger */
 		.edr_offset	= REG_GPIO_EDR1,
 		.bytes_edr	= 5,
+		.irq_lines	= 2,
 		.mask = { {
 			.isr_offset	= REG_GPIO_ISR1A,
 			.imr_offset	= REG_GPIO_IMR1A,
@@ -140,6 +148,7 @@ static const struct sih sih_modules[6] = {
 		.edr_offset	= TWL4030_INTERRUPTS_BCIEDR1,
 		/* Note: most of these IRQs default to no-trigger */
 		.bytes_edr	= 3,
+		.irq_lines	= 2,
 		.mask = { {
 			.isr_offset	= TWL4030_INTERRUPTS_BCIISR1A,
 			.imr_offset	= TWL4030_INTERRUPTS_BCIIMR1A,
@@ -164,6 +173,99 @@ static const struct sih sih_modules[6] = {
 		/* there are no SIH modules #6 or #7 ... */
 };
 
+static const struct sih sih_modules_twl5031[8] = {
+	[0] = {
+		.name		= "gpio",
+		.module		= TWL4030_MODULE_GPIO,
+		.control_offset	= REG_GPIO_SIH_CTRL,
+		.set_cor	= true,
+		.bits		= TWL4030_GPIO_MAX,
+		.bytes_ixr	= 3,
+		/* Note: *all* of these IRQs default to no-trigger */
+		.edr_offset	= REG_GPIO_EDR1,
+		.bytes_edr	= 5,
+		.irq_lines	= 2,
+		.mask = { {
+			.isr_offset	= REG_GPIO_ISR1A,
+			.imr_offset	= REG_GPIO_IMR1A,
+		}, {
+			.isr_offset	= REG_GPIO_ISR1B,
+			.imr_offset	= REG_GPIO_IMR1B,
+		}, },
+	},
+	[1] = {
+		.name		= "keypad",
+		.set_cor	= true,
+		SIH_INITIALIZER(KEYPAD_KEYP, 4)
+	},
+	[2] = {
+		.name		= "bci",
+		.module		= TWL5031_MODULE_INTERRUPTS,
+		.control_offset	= TWL5031_INTERRUPTS_BCISIHCTRL,
+		.bits		= 7,
+		.bytes_ixr	= 1,
+		.edr_offset	= TWL5031_INTERRUPTS_BCIEDR1,
+		/* Note: most of these IRQs default to no-trigger */
+		.bytes_edr	= 2,
+		.irq_lines	= 2,
+		.mask = { {
+			.isr_offset	= TWL5031_INTERRUPTS_BCIISR1,
+			.imr_offset	= TWL5031_INTERRUPTS_BCIIMR1,
+		}, {
+			.isr_offset	= TWL5031_INTERRUPTS_BCIISR2,
+			.imr_offset	= TWL5031_INTERRUPTS_BCIIMR2,
+		}, },
+	},
+	[3] = {
+		.name		= "madc",
+		SIH_INITIALIZER(MADC, 4)
+	},
+	[4] = {
+		/* USB doesn't use the same SIH organization */
+		.name		= "usb",
+	},
+	[5] = {
+		.name		= "power",
+		.set_cor	= true,
+		SIH_INITIALIZER(INT_PWR, 8)
+	},
+	[6] = {
+		/*
+		 * ACI doesn't use the same SIH organization.
+		 * For example, it supports only one interrupt line
+		 */
+		.name		= "aci",
+		.module		= TWL5031_MODULE_ACCESSORY,
+		.bits		= 9,
+		.bytes_ixr	= 2,
+		.irq_lines	= 1,
+		.mask = { {
+			.isr_offset	= TWL5031_ACIIDR_LSB,
+			.imr_offset	= TWL5031_ACIIMR_LSB,
+		}, },
+
+	},
+	[7] = {
+		/* Accessory */
+		.name		= "acc",
+		.module		= TWL5031_MODULE_ACCESSORY,
+		.control_offset	= TWL5031_ACCSIHCTRL,
+		.bits		= 2,
+		.bytes_ixr	= 1,
+		.edr_offset	= TWL5031_ACCEDR1,
+		/* Note: most of these IRQs default to no-trigger */
+		.bytes_edr	= 1,
+		.irq_lines	= 2,
+		.mask = { {
+			.isr_offset	= TWL5031_ACCISR1,
+			.imr_offset	= TWL5031_ACCIMR1,
+		}, {
+			.isr_offset	= TWL5031_ACCISR2,
+			.imr_offset	= TWL5031_ACCIMR2,
+		}, },
+	},
+};
+
 #undef TWL4030_MODULE_KEYPAD_KEYP
 #undef TWL4030_MODULE_INT_PWR
 #undef TWL4030_INT_PWR_EDR
@@ -284,12 +386,16 @@ static int twl4030_init_sih_modules(unsigned line)
 	/* disable all interrupts on our line */
 	memset(buf, 0xff, sizeof buf);
 	sih = sih_modules;
-	for (i = 0; i < ARRAY_SIZE(sih_modules); i++, sih++) {
+	for (i = 0; i < nr_sih_modules; i++, sih++) {
 
 		/* skip USB -- it's funky */
 		if (!sih->bytes_ixr)
 			continue;
 
+		/* Not all the SIH modules support multiple interrupt lines */
+		if (sih->irq_lines <= line)
+			continue;
+
 		status = twl4030_i2c_write(sih->module, buf,
 				sih->mask[line].imr_offset, sih->bytes_ixr);
 		if (status < 0)
@@ -314,7 +420,7 @@ static int twl4030_init_sih_modules(unsigned line)
 	}
 
 	sih = sih_modules;
-	for (i = 0; i < ARRAY_SIZE(sih_modules); i++, sih++) {
+	for (i = 0; i < nr_sih_modules; i++, sih++) {
 		u8 rxbuf[4];
 		int j;
 
@@ -322,6 +428,10 @@ static int twl4030_init_sih_modules(unsigned line)
 		if (!sih->bytes_ixr)
 			continue;
 
+		/* Not all the SIH modules support multiple interrupt lines */
+		if (sih->irq_lines <= line)
+			continue;
+
 		/* Clear pending interrupt status.  Either the read was
 		 * enough, or we need to write those bits.  Repeat, in
 		 * case an IRQ is pending (PENDDIS=0) ... that's not
@@ -611,7 +721,7 @@ int twl4030_sih_setup(int module)
 
 	/* only support modules with standard clear-on-read for now */
 	for (sih_mod = 0, sih = sih_modules;
-			sih_mod < ARRAY_SIZE(sih_modules);
+			sih_mod < nr_sih_modules;
 			sih_mod++, sih++) {
 		if (sih->module == module && sih->set_cor) {
 			if (!WARN((irq_base + sih->bits) > NR_IRQS,
@@ -756,3 +866,16 @@ int twl_exit_irq(void)
 	}
 	return 0;
 }
+
+int twl_init_chip_irq(const char *chip)
+{
+	if (!strcmp(chip, "twl5031")) {
+		sih_modules = sih_modules_twl5031;
+		nr_sih_modules = ARRAY_SIZE(sih_modules_twl5031);
+	} else {
+		sih_modules = sih_modules_twl4030;
+		nr_sih_modules = ARRAY_SIZE(sih_modules_twl4030);
+	}
+
+	return 0;
+}
diff --git a/include/linux/i2c/twl4030.h b/include/linux/i2c/twl4030.h
index 10e68cb..5de9b45 100644
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -61,13 +61,16 @@
 #define TWL4030_MODULE_PWMA		0x0E
 #define TWL4030_MODULE_PWMB		0x0F
 
+#define TWL5031_MODULE_ACCESSORY	0x10
+#define TWL5031_MODULE_INTERRUPTS	0x11
+
 /* Slave 3 (i2c address 0x4b) */
-#define TWL4030_MODULE_BACKUP		0x10
-#define TWL4030_MODULE_INT		0x11
-#define TWL4030_MODULE_PM_MASTER	0x12
-#define TWL4030_MODULE_PM_RECEIVER	0x13
-#define TWL4030_MODULE_RTC		0x14
-#define TWL4030_MODULE_SECURED_REG	0x15
+#define TWL4030_MODULE_BACKUP		0x12
+#define TWL4030_MODULE_INT		0x13
+#define TWL4030_MODULE_PM_MASTER	0x14
+#define TWL4030_MODULE_PM_RECEIVER	0x15
+#define TWL4030_MODULE_RTC		0x16
+#define TWL4030_MODULE_SECURED_REG	0x17
 
 /*
  * Read and write single 8-bit registers
@@ -221,6 +224,38 @@ int twl4030_i2c_read(u8 mod_no, u8 *value, u8 reg, unsigned num_bytes);
 
 /*----------------------------------------------------------------------*/
 
+/*
+ * Accessory Interrupts
+ */
+#define TWL5031_ACIIMR_LSB		0x05
+#define TWL5031_ACIIMR_MSB		0x06
+#define TWL5031_ACIIDR_LSB		0x07
+#define TWL5031_ACIIDR_MSB		0x08
+#define TWL5031_ACCISR1			0x0F
+#define TWL5031_ACCIMR1			0x10
+#define TWL5031_ACCISR2			0x11
+#define TWL5031_ACCIMR2			0x12
+#define TWL5031_ACCSIR			0x13
+#define TWL5031_ACCEDR1			0x14
+#define TWL5031_ACCSIHCTRL		0x15
+
+/*----------------------------------------------------------------------*/
+
+/*
+ * Battery Charger Controller
+ */
+
+#define TWL5031_INTERRUPTS_BCIISR1	0x0
+#define TWL5031_INTERRUPTS_BCIIMR1	0x1
+#define TWL5031_INTERRUPTS_BCIISR2	0x2
+#define TWL5031_INTERRUPTS_BCIIMR2	0x3
+#define TWL5031_INTERRUPTS_BCISIR	0x4
+#define TWL5031_INTERRUPTS_BCIEDR1	0x5
+#define TWL5031_INTERRUPTS_BCIEDR2	0x6
+#define TWL5031_INTERRUPTS_BCISIHCTRL	0x7
+
+/*----------------------------------------------------------------------*/
+
 /* Power bus message definitions */
 
 /* The TWL4030/5030 splits its power-management resources (the various
-- 
1.6.0.4

