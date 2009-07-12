Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbZGLVVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbZGLVVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 17:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZGLVVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 17:21:04 -0400
Received: from smtprelay10.ispgateway.de ([80.67.31.44]:53739 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbZGLVVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 17:21:03 -0400
Date: Sun, 12 Jul 2009 23:21:04 +0200
From: Peter Feuerer <peter@piie.net>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andreas Mohr <andi@lisas.de>,
       Borislav Petkov <petkovbb@googlemail.com>
Subject: [PATCH] Acerhdf: fix fan control for AOA150 model
Message-Id: <20090712232104.4f2fbf46.peter@piie.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: 650477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

please apply,

-- 
	peter

Changed:
 o Applied Borislav Petkov's patch (convert the fancmd[] array to a real 
   struct thus disambiguating command handling and making code more readable.)
 o Added BIOS product to BIOS table as AOA110 and AOA150 have
   different register values
 o Added force_product parameter to allow forcing different
   product
 o fixed linker warning caused by "acerhdf_drv" not being named
   "acerhdf_driver"

Signed-off-by: Peter Feuerer <peter@piie.net>
---
diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index bdfee17..aa298d6 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -52,7 +52,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.13"
+#define DRV_VER "0.5.16"
 
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
@@ -107,34 +108,58 @@ module_param(verbose, uint, 0600);
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
+	/* AOA110 */
+	{"Acer", "AOA110", "v0.3109", 0x55, 0x58, {0x1f, 0x00} },
+	{"Acer", "AOA110", "v0.3114", 0x55, 0x58, {0x1f, 0x00} },
+	{"Acer", "AOA110", "v0.3301", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3304", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3305", 0x55, 0x58, {0xaf, 0x00} },
+	{"Acer", "AOA110", "v0.3308", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "AOA110", "v0.3309", 0x55, 0x58, {0x21, 0x00} },
+	{"Acer", "AOA110", "v0.3310", 0x55, 0x58, {0x21, 0x00} },
+	/* AOA150 */
+	{"Acer", "AOA150", "v0.3114", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3304", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3305", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3308", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3309", 0x55, 0x58, {0x20, 0x00} },
+	{"Acer", "AOA150", "v0.3310", 0x55, 0x58, {0x20, 0x00} },
+	/* special BIOS / other */
+	{"Gateway", "AOA110", "v0.3103", 0x55, 0x58, {0x21, 0x00} },
+	{"Gateway", "AOA150", "v0.3103", 0x55, 0x58, {0x20, 0x00} },
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
@@ -150,13 +175,14 @@ static int acerhdf_get_temp(int *temp)
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
@@ -175,7 +201,8 @@ static void acerhdf_change_fanstate(int state)
 		state = ACERHDF_FAN_AUTO;
 	}
 
-	cmd = bios_cfg->fancmd[state];
+	cmd = (state == ACERHDF_FAN_OFF) ? bios_cfg->cmd.cmd_off
+					 : bios_cfg->cmd.cmd_auto;
 	fanstate = state;
 
 	ec_write(bios_cfg->fanreg, cmd);
@@ -437,7 +464,7 @@ static int acerhdf_remove(struct platform_device *device)
 	return 0;
 }
 
-struct platform_driver acerhdf_drv = {
+static struct platform_driver acerhdf_driver = {
 	.driver = {
 		.name = "acerhdf",
 		.owner = THIS_MODULE,
@@ -454,32 +481,40 @@ static int acerhdf_check_hardware(void)
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
@@ -487,8 +522,8 @@ static int acerhdf_check_hardware(void)
 	}
 
 	if (!bios_cfg) {
-		pr_err("unknown (unsupported) BIOS version %s/%s, "
-			"please report, aborting!\n", vendor, version);
+		pr_err("unknown (unsupported) BIOS version %s/%s/%s, "
+			"please report, aborting!\n", vendor, product, version);
 		return -EINVAL;
 	}
 
@@ -509,7 +544,7 @@ static int acerhdf_register_platform(void)
 {
 	int err = 0;
 
-	err = platform_driver_register(&acerhdf_drv);
+	err = platform_driver_register(&acerhdf_driver);
 	if (err)
 		return err;
 
@@ -525,7 +560,7 @@ static void acerhdf_unregister_platform(void)
 		return;
 
 	platform_device_del(acerhdf_dev);
-	platform_driver_unregister(&acerhdf_drv);
+	platform_driver_unregister(&acerhdf_driver);
 }
 
 static int acerhdf_register_thermal(void)
