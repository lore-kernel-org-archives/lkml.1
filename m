Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758691Ab0AOXts (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 18:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758648Ab0AOXtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 18:49:45 -0500
Received: from kroah.org ([198.145.64.141]:44753 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758639Ab0AOXtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 18:49:43 -0500
Date: Fri, 15 Jan 2010 15:47:52 -0800
From: Greg KH <greg@kroah.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Chun-Yi <jlee@novell.com>, linux-kernel@vger.kernel.org
Subject: [01/02] msi-laptop: Support standard ec 66/62 command on MSI
 notebook and nebook
Message-ID: <20100115234752.GB22890@kroah.com>
References: <20100115234710.GA22890@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100115234710.GA22890@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Lee, Chun-Yi <jlee@novell.com>

Suppport standard ec 66/62 command on MSI notebook and nebook. MSI
netbook and notebook already support 66/62 command, so, add new
get_state function, and put the old model to non-standard model, but
driver still support those old model.

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -66,6 +66,11 @@
 #define MSI_EC_COMMAND_WIRELESS 0x10
 #define MSI_EC_COMMAND_LCD_LEVEL 0x11
 
+#define MSI_STANDARD_EC_COMMAND_ADDRESS	0x2e
+#define MSI_STANDARD_EC_BLUETOOTH_MASK	(1 << 0)
+#define MSI_STANDARD_EC_WEBCAM_MASK	(1 << 1)
+#define MSI_STANDARD_EC_WLAN_MASK	(1 << 3)
+
 static int force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
@@ -74,6 +79,9 @@ static int auto_brightness;
 module_param(auto_brightness, int, 0);
 MODULE_PARM_DESC(auto_brightness, "Enable automatic brightness control (0: disabled; 1: enabled; 2: don't touch)");
 
+static bool old_ec_model;
+static int wlan_s, bluetooth_s;
+
 /* Hardware access */
 
 static int set_lcd_level(int level)
@@ -148,6 +156,22 @@ static int get_wireless_state(int *wlan, int *bluetooth)
 	return 0;
 }
 
+static int get_wireless_state_ec_standard(void)
+{
+	u8 rdata;
+	int result;
+
+	result = ec_read(MSI_STANDARD_EC_COMMAND_ADDRESS, &rdata);
+	if (result < 0)
+		return -1;
+
+	wlan_s = !!(rdata & MSI_STANDARD_EC_WLAN_MASK);
+
+	bluetooth_s = !!(rdata & MSI_STANDARD_EC_BLUETOOTH_MASK);
+
+	return 0;
+}
+
 /* Backlight device stuff */
 
 static int bl_get_brightness(struct backlight_device *b)
@@ -176,7 +200,12 @@ static ssize_t show_wlan(struct device *dev,
 
 	int ret, enabled;
 
-	ret = get_wireless_state(&enabled, NULL);
+	if (old_ec_model) {
+		ret = get_wireless_state(&enabled, NULL);
+	} else {
+		ret = get_wireless_state_ec_standard();
+		enabled = wlan_s;
+	}
 	if (ret < 0)
 		return ret;
 
@@ -189,7 +218,12 @@ static ssize_t show_bluetooth(struct device *dev,
 
 	int ret, enabled;
 
-	ret = get_wireless_state(NULL, &enabled);
+	if (old_ec_model) {
+		ret = get_wireless_state(NULL, &enabled);
+	} else {
+		ret = get_wireless_state_ec_standard();
+		enabled = bluetooth_s;
+	}
 	if (ret < 0)
 		return ret;
 
@@ -339,8 +373,8 @@ static int __init msi_init(void)
 	if (acpi_disabled)
 		return -ENODEV;
 
-	if (!force && !dmi_check_system(msi_dmi_table))
-		return -ENODEV;
+	if (force || dmi_check_system(msi_dmi_table))
+		old_ec_model = 1;
 
 	if (auto_brightness < 0 || auto_brightness > 2)
 		return -EINVAL;
@@ -435,3 +469,4 @@ MODULE_ALIAS("dmi:*:svnMICRO-STARINT'LCO.,LTD:pnMS-1013:pvr0131*:cvnMICRO-STARIN
 MODULE_ALIAS("dmi:*:svnMicro-StarInternational:pnMS-1058:pvr0581:rvnMSI:rnMS-1058:*:ct10:*");
 MODULE_ALIAS("dmi:*:svnMicro-StarInternational:pnMS-1412:*:rvnMSI:rnMS-1412:*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
 MODULE_ALIAS("dmi:*:svnNOTEBOOK:pnSAM2000:pvr0131*:cvnMICRO-STARINT'LCO.,LTD:ct10:*");
+MODULE_ALIAS("dmi:*:svnMICRO-STARINTERNATIONAL*:pnMS-N034:*");
-- 
1.6.0.2

