Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbYKZTVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbYKZTVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbYKZTVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:21:13 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:44314 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752567AbYKZTVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:21:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Zsh/KILtcr+K6alLaW55tewh2OGZfpf116KDZCIIH1hzHt+UaTqnOQnjj+398HWVB9iJyideR9qbeqvWd83cWJ6aLYqJDeWrBgdbTw0yYi5sYYvEZ9ULvIavMBEFZj4GXkDwhRKR0BmhSI7/2SzMNM8wauo5voqENQ832GOvrLo=  ;
X-YMail-OSG: fhkTJvIVM1lwZepGa113AZtzAwwWmn_UxG04DkPD6RNOFvMj9rYGnqP9RVuBMbsEAdW6UI3fEws6hmw1YHFDoNTeTK8nDooI2z5lGCko0MhS.yENXyccyN_9Gm8DTSFGBvtiSZ6TO67fCLfCCiLn4nMd
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Samuel Ortiz <sameo@openedhand.com>
Subject: [patch 2.6.28-rc6 3/3] mfd: twl4030: create some regulator devices
Date: Wed, 26 Nov 2008 11:00:55 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, Tony Lindgren <tony@atomide.com>,
       Mark Underwood <basicmark@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811261100.56059.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Initial code to create twl4030 voltage regulator devices, using
the new regulator framework.  Note that this now starts to care
what name is used to declare the TWL chip:

 - TWL4030 is the "old" chip; newer ones have a bigger variety
   of VAUX2 voltages.

 - TWL5030 is the core "new" chip; TPS65950 is its catalog version.

 - The TPS65930 and TPS65920 are cost-reduced catalog versions of
   TWL5030 parts ... fewer regulators, no battery charger, etc.

Board-specific regulator configuration should be provided, listing
which regulators are used and their constraints (e.g. 1.8V only).

Code that could ("should"?) leverage the regulator stuff includes
TWL4030 USB transceiver support and MMC glue, LCD support for the
3430SDP and Labrador boards, and S-Video output.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/mfd/twl4030-core.c  |  174 +++++++++++++++++++++++++++++++++++++++---
 include/linux/i2c/twl4030.h |   47 +++++++++++
 2 files changed, 211 insertions(+), 10 deletions(-)

--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -33,6 +33,8 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 
+#include <linux/regulator/machine.h>
+
 #include <linux/i2c.h>
 #include <linux/i2c/twl4030.h>
 
@@ -71,6 +73,13 @@
 #define twl_has_gpio()	false
 #endif
 
+#if defined(CONFIG_REGULATOR_TWL4030) \
+	|| defined(CONFIG_REGULATOR_TWL4030_MODULE)
+#define twl_has_regulator()	true
+#else
+#define twl_has_regulator()	false
+#endif
+
 #if defined(CONFIG_TWL4030_MADC) || defined(CONFIG_TWL4030_MADC_MODULE)
 #define twl_has_madc()	true
 #else
@@ -149,6 +158,10 @@
 #define HIGH_PERF_SQ			(1 << 3)
 
 
+/* chip-specific feature flags, for i2c_device_id.driver_data */
+#define TWL4030_VAUX2		BIT(0)	/* pre-5030 voltage ranges */
+#define TPS_SUBSET		BIT(1)	/* tps659[23]0 have fewer LDOs */
+
 /*----------------------------------------------------------------------*/
 
 /* is driver active, bound to a chip? */
@@ -352,7 +365,8 @@ EXPORT_SYMBOL(twl4030_i2c_read_u8);
 
 /*----------------------------------------------------------------------*/
 
-static struct device *add_child(unsigned chip, const char *name,
+static struct device *
+add_numbered_child(unsigned chip, const char *name, int num,
 		void *pdata, unsigned pdata_len,
 		bool can_wakeup, int irq0, int irq1)
 {
@@ -360,7 +374,7 @@ static struct device *add_child(unsigned
 	struct twl4030_client	*twl = &twl4030_modules[chip];
 	int			status;
 
-	pdev = platform_device_alloc(name, -1);
+	pdev = platform_device_alloc(name, num);
 	if (!pdev) {
 		dev_dbg(&twl->client->dev, "can't alloc dev\n");
 		status = -ENOMEM;
@@ -402,17 +416,52 @@ err:
 	return &pdev->dev;
 }
 
+static inline struct device *add_child(unsigned chip, const char *name,
+		void *pdata, unsigned pdata_len,
+		bool can_wakeup, int irq0, int irq1)
+{
+	return add_numbered_child(chip, name, -1, pdata, pdata_len,
+		can_wakeup, irq0, irq1);
+}
+
+static struct device *
+add_regulator_linked(int num, struct regulator_init_data *pdata,
+		struct regulator_consumer_supply *consumers,
+		unsigned num_consumers)
+{
+	/* regulator framework demands init_data ... */
+	if (!pdata)
+		return NULL;
+
+	if (consumers && !pdata->consumer_supplies) {
+		pdata->consumer_supplies = consumers;
+		pdata->num_consumer_supplies = num_consumers;
+	}
+
+	/* NOTE:  we currently ignore regulator IRQs, e.g. for short circuits */
+	return add_numbered_child(3, "twl4030_reg", num,
+		pdata, sizeof(*pdata), false, 0, 0);
+}
+
+static struct device *
+add_regulator(int num, struct regulator_init_data *pdata)
+{
+	return add_regulator_linked(num, pdata, NULL, 0);
+}
+
 /*
  * NOTE:  We know the first 8 IRQs after pdata->base_irq are
  * for the PIH, and the next are for the PWR_INT SIH, since
  * that's how twl_init_irq() sets things up.
  */
 
-static int add_children(struct twl4030_platform_data *pdata)
+static int
+add_children(struct twl4030_platform_data *pdata, unsigned long features)
 {
 	struct device	*child;
+	struct device	*usb_transceiver = NULL;
 
-	if (twl_has_bci() && pdata->bci) {
+	if (twl_has_bci() && pdata->bci && !(features & TPS_SUBSET)) {
 		child = add_child(3, "twl4030_bci",
 				pdata->bci, sizeof(*pdata->bci),
 				false,
@@ -469,6 +518,111 @@ static int add_children(struct twl4030_p
 				pdata->irq_base + 8 + 2, pdata->irq_base + 4);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
+
+		/* we need to connect regulators to this transceiver */
+		usb_transceiver = child;
+	}
+
+	if (twl_has_regulator()) {
+		/*
+		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+		*/
+
+		child = add_regulator(TWL4030_REG_VMMC1, pdata->vmmc1);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL4030_REG_VDAC, pdata->vdac);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator((features & TWL4030_VAUX2)
+					? TWL4030_REG_VAUX2_4030
+					: TWL4030_REG_VAUX2,
+				pdata->vaux2);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
+	if (twl_has_regulator() && usb_transceiver) {
+		static struct regulator_consumer_supply usb1v5 = {
+			.supply =	"usb1v5",
+		};
+		static struct regulator_consumer_supply usb1v8 = {
+			.supply =	"usb1v8",
+		};
+		static struct regulator_consumer_supply usb3v1 = {
+			.supply =	"usb3v1",
+		};
+		static struct regulator_consumer_supply usbcp = {
+			.supply =	"usbcp",
+		};
+
+		/* this is a template that gets copied */
+		struct regulator_init_data usb_fixed = {
+			.constraints.valid_modes_mask =
+				  REGULATOR_MODE_NORMAL
+				| REGULATOR_MODE_STANDBY,
+			.constraints.valid_ops_mask =
+				  REGULATOR_CHANGE_MODE
+				| REGULATOR_CHANGE_STATUS,
+		};
+
+		usb1v5.dev = usb_transceiver;
+		usb1v8.dev = usb_transceiver;
+		usb3v1.dev = usb_transceiver;
+		usbcp.dev = usb_transceiver;
+
+		child = add_regulator_linked(TWL4030_REG_VUSB1V5, &usb_fixed,
+				&usb1v5, 1);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator_linked(TWL4030_REG_VUSB1V8, &usb_fixed,
+				&usb1v8, 1);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator_linked(TWL4030_REG_VUSB3V1, &usb_fixed,
+				&usb3v1, 1);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator_linked(TWL4030_REG_VUSBCP, &usb_fixed,
+				&usbcp, 1);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
+	/* maybe add LDOs that are omitted on cost-reduced parts */
+	if (twl_has_regulator() && !(features & TPS_SUBSET)) {
+		/*
+		child = add_regulator(TWL4030_REG_VPLL2, pdata->vpll2);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+		*/
+
+		child = add_regulator(TWL4030_REG_VMMC2, pdata->vmmc2);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL4030_REG_VSIM, pdata->vsim);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL4030_REG_VAUX1, pdata->vaux1);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL4030_REG_VAUX3, pdata->vaux3);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+
+		child = add_regulator(TWL4030_REG_VAUX4, pdata->vaux4);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
 	}
 
 	return 0;
@@ -632,7 +786,7 @@ twl4030_probe(struct i2c_client *client,
 			goto fail;
 	}
 
-	status = add_children(pdata);
+	status = add_children(pdata, id->driver_data);
 fail:
 	if (status < 0)
 		twl4030_remove(client);
@@ -640,11 +794,11 @@ fail:
 }
 
 static const struct i2c_device_id twl4030_ids[] = {
-	{ "twl4030", 0 },	/* "Triton 2" */
-	{ "tps65950", 0 },	/* catalog version of twl4030 */
-	{ "tps65930", 0 },	/* fewer LDOs and DACs; no charger */
-	{ "tps65920", 0 },	/* fewer LDOs; no codec or charger */
-	{ "twl5030", 0 },	/* T2 updated */
+	{ "twl4030", TWL4030_VAUX2 },	/* "Triton 2" */
+	{ "twl5030", 0 },		/* T2 updated */
+	{ "tps65950", 0 },		/* catalog version of twl5030 */
+	{ "tps65930", TPS_SUBSET },	/* fewer LDOs and DACs; no charger */
+	{ "tps65920", TPS_SUBSET },	/* fewer LDOs; no codec or charger */
 	{ /* end of list */ },
 };
 MODULE_DEVICE_TABLE(i2c, twl4030_ids);
--- a/include/linux/i2c/twl4030.h
+++ b/include/linux/i2c/twl4030.h
@@ -278,6 +278,18 @@ struct twl4030_platform_data {
 	struct twl4030_keypad_data		*keypad;
 	struct twl4030_usb_data			*usb;
 
+	/* LDO regulators */
+	struct regulator_init_data		*vdac;
+	struct regulator_init_data		*vpll1;
+	struct regulator_init_data		*vpll2;
+	struct regulator_init_data		*vmmc1;
+	struct regulator_init_data		*vmmc2;
+	struct regulator_init_data		*vsim;
+	struct regulator_init_data		*vaux1;
+	struct regulator_init_data		*vaux2;
+	struct regulator_init_data		*vaux3;
+	struct regulator_init_data		*vaux4;
+
 	/* REVISIT more to come ... _nothing_ should be hard-wired */
 };
 
@@ -309,4 +321,39 @@ int twl4030_set_gpio_debounce(int gpio, 
 	static inline int twl4030charger_usb_en(int enable) { return 0; }
 #endif
 
+/*----------------------------------------------------------------------*/
+
+/* Linux-specific regulator identifiers ... for now, we only support
+ * the LDOs, and leave the three buck converters alone.  VDD1 and VDD2
+ * need to tie into hardware based voltage scaling (cpufreq etc), while
+ * VIO is generally fixed.
+ */
+
+/* EXTERNAL dc-to-dc buck converters */
+#define TWL4030_REG_VDD1	0
+#define TWL4030_REG_VDD2	1
+#define TWL4030_REG_VIO		2
+
+/* EXTERNAL LDOs */
+#define TWL4030_REG_VDAC	3
+#define TWL4030_REG_VPLL1	4
+#define TWL4030_REG_VPLL2	5	/* not on all chips */
+#define TWL4030_REG_VMMC1	6
+#define TWL4030_REG_VMMC2	7	/* not on all chips */
+#define TWL4030_REG_VSIM	8	/* not on all chips */
+#define TWL4030_REG_VAUX1	9	/* not on all chips */
+#define TWL4030_REG_VAUX2_4030	10	/* (twl4030-specific) */
+#define TWL4030_REG_VAUX2	11	/* (twl5030 and newer) */
+#define TWL4030_REG_VAUX3	12	/* not on all chips */
+#define TWL4030_REG_VAUX4	13	/* not on all chips */
+
+/* INTERNAL LDOs */
+#define TWL4030_REG_VINTANA1	14
+#define TWL4030_REG_VINTANA2	15
+#define TWL4030_REG_VINTDIG	16
+#define TWL4030_REG_VUSB1V5	17
+#define TWL4030_REG_VUSB1V8	18
+#define TWL4030_REG_VUSB3V1	19
+#define TWL4030_REG_VUSBCP	20
+
 #endif /* End of __TWL4030_H */
