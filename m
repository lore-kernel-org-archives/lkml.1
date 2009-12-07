Return-Path: <linux-kernel-owner+w=401wt.eu-S1758752AbZLGARB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752AbZLGARB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934384AbZLGAQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:16:40 -0500
Received: from kroah.org ([198.145.64.141]:34782 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819AbZLGAOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:04 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:59 2009
Message-Id: <20091207000659.782998635@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Feuerer <peter@piie.net>, Andreas Mohr <andi@lisas.de>,
       Borislav Petkov <petkovbb@gmail.com>, Len Brown <len.brown@intel.com>,
       Adrian von Bidder <avbidder@fortytwo.ch>
Subject: [109/119] acerhdf: fix fan control for AOA150 model
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=acerhdf-fix-fan-control-for-aoa150-model.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Peter Feuerer <peter@piie.net>

commit ded0cdfc6a7673916b0878c32fa8ba566b4f8cdb upstream.

- Apply Borislav Petkov's patch (convert the fancmd[] array to a real
  struct thus disambiguating command handling and making code more
  readable.)

- Add BIOS product to BIOS table as AOA110 and AOA150 have different
  register values

- Add force_product parameter to allow forcing different product

- fix linker warning caused by "acerhdf_drv" not being named
  "acerhdf_driver"

Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>
Acked-by: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Adrian von Bidder <avbidder@fortytwo.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/acerhdf.c |   97 +++++++++++++++++++++++++++--------------
 1 file changed, 66 insertions(+), 31 deletions(-)

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
@@ -175,7 +201,8 @@ static void acerhdf_change_fanstate(int 
 		state = ACERHDF_FAN_AUTO;
 	}
 
-	cmd = bios_cfg->fancmd[state];
+	cmd = (state == ACERHDF_FAN_OFF) ? bios_cfg->cmd.cmd_off
+					 : bios_cfg->cmd.cmd_auto;
 	fanstate = state;
 
 	ec_write(bios_cfg->fanreg, cmd);
@@ -437,7 +464,7 @@ static int acerhdf_remove(struct platfor
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
 
@@ -509,7 +544,7 @@ static int acerhdf_register_platform(voi
 {
 	int err = 0;
 
-	err = platform_driver_register(&acerhdf_drv);
+	err = platform_driver_register(&acerhdf_driver);
 	if (err)
 		return err;
 
@@ -525,7 +560,7 @@ static void acerhdf_unregister_platform(
 		return;
 
 	platform_device_del(acerhdf_dev);
-	platform_driver_unregister(&acerhdf_drv);
+	platform_driver_unregister(&acerhdf_driver);
 }
 
 static int acerhdf_register_thermal(void)


