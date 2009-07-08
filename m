Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbZGHUK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbZGHUK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 16:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755481AbZGHUKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 16:10:52 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.26]:53654 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753766AbZGHUKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 16:10:51 -0400
Date: Wed, 8 Jul 2009 22:10:49 +0200
From: Peter Feuerer <peter@piie.net>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH] Acerhdf: 0.5.15-2
Message-Id: <20090708221049.617f2b4e.peter@piie.net>
In-Reply-To: <20090707220756.384b1999.peter@piie.net>
References: <20090705135806.GB9778@liondog.tnic>
	<cone.1246812673.209196.4691.1000@onepiie>
	<20090706074341.GA27582@liondog.tnic>
	<20090707220756.384b1999.peter@piie.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: peter@piie.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

found a little Bug, the "strncmp" in BIOS detection was using the wrong length, here's a new patch...

--peter

On Tue, 7 Jul 2009 22:07:56 +0200
Peter Feuerer <peter@piie.net> wrote:

> Hi Boris,
> 
> On Mon, 6 Jul 2009 09:43:42 +0200
> Borislav Petkov <petkovbb@googlemail.com> wrote:
> 
> > The thing I'm observing here with the 0x21 command is that whenever it
> > is written into the ->fanreg, the fan gets turned on for maybe a second
> > or less and then off again. The 0x20 keeps it off just fine. What does
> > your BIOS version string say, here it is:
> > 
> > [33340.535861] acerhdf: Acer Aspire One Fan driver, v.0.5.14
> > [33340.537078] acerhdf: BIOS info: Acer v0.3309, product: AOA150
> 
> I tested your patch with value 0x20 on my machine ("AOA110" product, "v0.3309" version).
> The fan was freaking out and spinning high like a helicopter.
> 
> I think we have to distinguish between the BIOS products too. Here a patch, please have a look at it and test it.
> 
> cheers,
> 	peter

Peter:
 o Applied Borislav Petkov's patch
 o Added BIOS product to BIOS table as AOA110 and AOA150 have
   different register values
 o Added force_product parameter to allow forcing different
   product
 o fixed linker warning caused by "acerhdf_drv" not being named
   "acerhdf_driver"

Signed-off-by: Peter Feuerer <peter@piie.net>
---
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index bdfee17..388622c 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -52,7 +52,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.13"
+#define DRV_VER "0.5.15"
 
 /*
  * According to the Atom N270 datasheet,
@@ -90,6 +90,7 @@ static unsigned int fanoff = 58;
 static unsigned int verbose;
 static unsigned int fanstate = ACERHDF_FAN_AUTO;
 static char force_bios[16];
+static char force_product[16];
 static unsigned int prev_interval;
 struct thermal_zone_device *thz_dev;
 struct thermal_cooling_device *cl_dev;
@@ -107,34 +108,54 @@ module_param(verbose, uint, 0600);
 MODULE_PARM_DESC(verbose, "Enable verbose dmesg output");
 module_param_string(force_bios, force_bios, 16, 0);
 MODULE_PARM_DESC(force_bios, "Force BIOS version and omit BIOS check");
+module_param_string(force_product, force_product, 16, 0);
+MODULE_PARM_DESC(force_product, "Force BIOS product and omit BIOS check");
+
+/*
+ * cmd_off: to switch the fan completely off / to check if the fan is off
+ *	cmd_auto: to set the BIOS in control of the fan. The BIOS regulates then
+ *		the fan speed depending on the temperature
+ */
+struct fancmd {
+	u8 cmd_off;
+	u8 cmd_auto;
+};
 
 /* BIOS settings */
 struct bios_settings_t {
 	const char *vendor;
+	const char *product;
 	const char *version;
 	unsigned char fanreg;
 	unsigned char tempreg;
-	unsigned char fancmd[2]; /* fan off and auto commands */
+	struct fancmd cmd;
 };
 
 /* Register addresses and values for different BIOS versions */
 static const struct bios_settings_t bios_tbl[] = {
-	{"Acer", "v0.3109", 0x55, 0x58, {0x1f, 0x00} },
-	{"Acer", "v0.3114", 0x55, 0x58, {0x1f, 0x00} },
-	{"Acer", "v0.3301", 0x55, 0x58, {0xaf, 0x00} },
-	{"Acer", "v0.3304", 0x55, 0x58, {0xaf, 0x00} },
-	{"Acer", "v0.3305", 0x55, 0x58, {0xaf, 0x00} },
-	{"Acer", "v0.3308", 0x55, 0x58, {0x21, 0x00} },
-	{"Acer", "v0.3309", 0x55, 0x58, {0x21, 0x00} },
-	{"Acer", "v0.3310", 0x55, 0x58, {0x21, 0x00} },
-	{"Gateway", "v0.3103", 0x55, 0x58, {0x21, 0x00} },
-	{"Packard Bell", "v0.3105", 0x55, 0x58, {0x21, 0x00} },
-	{"", "", 0, 0, {0, 0} }
+	/* working for AOA110 and AOA150 and other */
+	{"Acer", "AO", "v0.3109", 0x55, 0x58, {0x1f, 0x00} },
+	{"Acer", "AO", "v0.3114", 0x55, 0x58, {0x1f, 0x00} },
+	{"Acer", "AO", "v0.3301", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AO", "v0.3304", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AO", "v0.3305", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AO", "v0.3308", 0x55, 0x58, {0x21, 0x00} },
+	/* AOA110 */
+	{"Acer", "AOA110", "v0.3309", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "AOA110", "v0.3310", 0x55, 0x58, {0x21, 0x00} },
+	/* AOA150 */
+	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
+	/* special BIOS / other */
+	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "DOA150", "v0.3104", 0x55, 0x58, {0x21, 0x00} },
+	{"Packard Bell", "AOA110", "v0.3105", 0x55, 0x58, {0x21, 0x00} },
+	/* pewpew-terminator */
+	{"", "", "", 0, 0, {0, 0} }
 };
 
 static const struct bios_settings_t *bios_cfg __read_mostly;
 
-
 static int acerhdf_get_temp(int *temp)
 {
 	u8 read_temp;
@@ -150,13 +171,14 @@ static int acerhdf_get_temp(int *temp)
 static int acerhdf_get_fanstate(int *state)
 {
 	u8 fan;
-	bool tmp;
 
 	if (ec_read(bios_cfg->fanreg, &fan))
 		return -EINVAL;
 
-	tmp = (fan == bios_cfg->fancmd[ACERHDF_FAN_OFF]);
-	*state = tmp ? ACERHDF_FAN_OFF : ACERHDF_FAN_AUTO;
+	if (fan != bios_cfg->cmd.cmd_off)
+		*state = ACERHDF_FAN_AUTO;
+	else
+		*state = ACERHDF_FAN_OFF;
 
 	return 0;
 }
@@ -175,7 +197,8 @@ static void acerhdf_change_fanstate(int state)
 		state = ACERHDF_FAN_AUTO;
 	}
 
-	cmd = bios_cfg->fancmd[state];
+	cmd = (state == ACERHDF_FAN_OFF) ? bios_cfg->cmd.cmd_off
+					 : bios_cfg->cmd.cmd_auto;
 	fanstate = state;
 
 	ec_write(bios_cfg->fanreg, cmd);
@@ -437,7 +460,7 @@ static int acerhdf_remove(struct platform_device *device)
 	return 0;
 }
 
-struct platform_driver acerhdf_drv = {
+static struct platform_driver acerhdf_driver = {
 	.driver = {
 		.name = "acerhdf",
 		.owner = THIS_MODULE,
@@ -454,32 +477,40 @@ static int acerhdf_check_hardware(void)
 {
 	char const *vendor, *version, *product;
 	int i;
+	unsigned long prod_len = 0;
 
 	/* get BIOS data */
 	vendor  = dmi_get_system_info(DMI_SYS_VENDOR);
 	version = dmi_get_system_info(DMI_BIOS_VERSION);
 	product = dmi_get_system_info(DMI_PRODUCT_NAME);
 
+
 	pr_info("Acer Aspire One Fan driver, v.%s\n", DRV_VER);
 
-	if (!force_bios[0]) {
-		if (strncmp(product, "AO", 2)) {
-			pr_err("no Aspire One hardware found\n");
-			return -EINVAL;
-		}
-	} else {
-		pr_info("forcing BIOS version: %s\n", version);
+	if (force_bios[0]) {
 		version = force_bios;
+		pr_info("forcing BIOS version: %s\n", version);
 		kernelmode = 0;
 	}
 
+	if (force_product[0]) {
+		product = force_product;
+		pr_info("forcing BIOS product: %s\n", product);
+		kernelmode = 0;
+	}
+
+	prod_len = strlen(product);
+
 	if (verbose)
 		pr_info("BIOS info: %s %s, product: %s\n",
 			vendor, version, product);
 
 	/* search BIOS version and vendor in BIOS settings table */
 	for (i = 0; bios_tbl[i].version[0]; i++) {
-		if (!strcmp(bios_tbl[i].vendor, vendor) &&
+		if (strlen(bios_tbl[i].product) >= prod_len &&
+		    !strncmp(bios_tbl[i].product, product,
+			   strlen(bios_tbl[i].product)) &&
+		    !strcmp(bios_tbl[i].vendor, vendor) &&
 		    !strcmp(bios_tbl[i].version, version)) {
 			bios_cfg = &bios_tbl[i];
 			break;
@@ -487,8 +518,8 @@ static int acerhdf_check_hardware(void)
 	}
 
 	if (!bios_cfg) {
-		pr_err("unknown (unsupported) BIOS version %s/%s, "
-			"please report, aborting!\n", vendor, version);
+		pr_err("unknown (unsupported) BIOS version %s/%s/%s, "
+			"please report, aborting!\n", vendor, product, version);
 		return -EINVAL;
 	}
 
@@ -509,7 +540,7 @@ static int acerhdf_register_platform(void)
 {
 	int err = 0;
 
-	err = platform_driver_register(&acerhdf_drv);
+	err = platform_driver_register(&acerhdf_driver);
 	if (err)
 		return err;
 
@@ -525,7 +556,7 @@ static void acerhdf_unregister_platform(void)
 		return;
 
 	platform_device_del(acerhdf_dev);
-	platform_driver_unregister(&acerhdf_drv);
+	platform_driver_unregister(&acerhdf_driver);
 }
 
 static int acerhdf_register_thermal(void)
