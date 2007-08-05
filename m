Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbXHEQZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbXHEQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 12:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbXHEQZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 12:25:17 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:5636 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbXHEQZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 12:25:15 -0400
Date: Sun, 5 Aug 2007 12:21:41 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
Message-ID: <20070805162141.GI6221@jupiter.solarsys.private>
References: <46B5B290.4040907@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B5B290.4040907@s5r6.in-berlin.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan:

* Stefan Richter <stefanr@s5r6.in-berlin.de> [2007-08-05 13:20:48 +0200]:
> Now that I booted from 2.6.22-rc5 to 2.6.23-rc2 I noticed that ksensors
> displayed 1/16 of the actual speed of the CPU fan (correct is ca. 1400
> RPM under light load) and 0 for the case fan (correct is ca. 480 RPM
> under light load).
> 
> I reverted patch
> 	hwmon/w83627ehf: No need to initialize fan_min
> and the behaviour changed as follows:  ksensors displays the correct CPU
> fan speed when loaded for the first time after the w83627ehf was loaded,
> then drops to 1/16th the next time it refreshes the display.  (I
> configured 30s update interval in ksensors.)  But the case fan's speed
> is now correctly displayed all the time.  Ksensors' fan speed
> multipliers are configured as 1.
> 
> I then also reverted
> 	hwmon/w83627ehf: Be quiet when no chip is found
> 	hwmon/w83627ehf: Export the thermal sensor types
> 	hwmon/w83627ehf: Enable VBAT monitoring
> 	hwmon/w83627ehf: Add support for the VID inputs
> 	hwmon/w83627ehf: Fix timing issues
> 	hwmon/w83627ehf: Add error messages for two error cases
> one after another but it didn't change anything.  More surprisingly, if
> I put all patches including "No need to initialize fan_min" back in, the
> behaviour remains like after referting that single patch, i.e. wrong CPU
> fan speed after first display update, correct case fan speed.  I didn't
> reboot between tests though, I only unloaded and reloaded w83627ehf.
> 
> I wasn't able to revert
> 	hwmon/w83627ehf: Convert to a platform driver
> to something that compiles but I didn't try very hard.
> 
> Kernel messages when I load the drivers:
> w83627ehf: unsupported chip ID: 0xffff
> w83627ehf: Found W83627EHG chip at 0x290
> The former message is normally suppressed by patch "Be quiet when no
> chip is found".  Mainboard is an MSI 945GT Speedster-A4R, userland is
> Gentoo's lm_sensors-2.10.1 and ksensors-0.7.3.
> 
> Booting back into 2.6.22-rc5 (which seems identical with 2.6.22 as far
> as w83627ehf is concerned) brings back the correct fan speeds.

Does this patch (against v2.6.23-rc2) fix it?

commit f15c50e703c14ff7d72c3cb34e8e55417476a290
Author: Mark M. Hoffman <mhoffman@lightlink.com>
Date:   Sun Aug 5 12:19:01 2007 -0400

    hwmon: read fan_div values during probe
    
    This patch forces the driver to read the fan divider values during early init.
    Otherwise, a call to store_fan_min() could access uninitialized variables.
    
    Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index c51ae2e..bca7fbc 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -421,6 +421,31 @@ static void w83627ehf_write_fan_div(struct w83627ehf_data *data, int nr)
 	}
 }
 
+static void w83627ehf_update_fan_div(struct w83627ehf_data *data)
+{
+	int i;
+
+	i = w83627ehf_read_value(data, W83627EHF_REG_FANDIV1);
+	data->fan_div[0] = (i >> 4) & 0x03;
+	data->fan_div[1] = (i >> 6) & 0x03;
+	i = w83627ehf_read_value(data, W83627EHF_REG_FANDIV2);
+	data->fan_div[2] = (i >> 6) & 0x03;
+	i = w83627ehf_read_value(data, W83627EHF_REG_VBAT);
+	data->fan_div[0] |= (i >> 3) & 0x04;
+	data->fan_div[1] |= (i >> 4) & 0x04;
+	data->fan_div[2] |= (i >> 5) & 0x04;
+	if (data->has_fan & ((1 << 3) | (1 << 4))) {
+		i = w83627ehf_read_value(data, W83627EHF_REG_DIODE);
+		data->fan_div[3] = i & 0x03;
+		data->fan_div[4] = ((i >> 2) & 0x03)
+				 | ((i >> 5) & 0x04);
+	}
+	if (data->has_fan & (1 << 3)) {
+		i = w83627ehf_read_value(data, W83627EHF_REG_SMI_OVT);
+		data->fan_div[3] |= (i >> 5) & 0x04;
+	}
+}
+
 static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 {
 	struct w83627ehf_data *data = dev_get_drvdata(dev);
@@ -432,25 +457,7 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 	if (time_after(jiffies, data->last_updated + HZ + HZ/2)
 	 || !data->valid) {
 		/* Fan clock dividers */
-		i = w83627ehf_read_value(data, W83627EHF_REG_FANDIV1);
-		data->fan_div[0] = (i >> 4) & 0x03;
-		data->fan_div[1] = (i >> 6) & 0x03;
-		i = w83627ehf_read_value(data, W83627EHF_REG_FANDIV2);
-		data->fan_div[2] = (i >> 6) & 0x03;
-		i = w83627ehf_read_value(data, W83627EHF_REG_VBAT);
-		data->fan_div[0] |= (i >> 3) & 0x04;
-		data->fan_div[1] |= (i >> 4) & 0x04;
-		data->fan_div[2] |= (i >> 5) & 0x04;
-		if (data->has_fan & ((1 << 3) | (1 << 4))) {
-			i = w83627ehf_read_value(data, W83627EHF_REG_DIODE);
-			data->fan_div[3] = i & 0x03;
-			data->fan_div[4] = ((i >> 2) & 0x03)
-					 | ((i >> 5) & 0x04);
-		}
-		if (data->has_fan & (1 << 3)) {
-			i = w83627ehf_read_value(data, W83627EHF_REG_SMI_OVT);
-			data->fan_div[3] |= (i >> 5) & 0x04;
-		}
+		w83627ehf_update_fan_div(data);
 
 		/* Measured voltages and limits */
 		for (i = 0; i < data->in_num; i++) {
@@ -1312,6 +1319,9 @@ static int __devinit w83627ehf_probe(struct platform_device *pdev)
 	if (!(i & (1 << 1)) && (!fan5pin))
 		data->has_fan |= (1 << 4);
 
+	/* Read fan clock dividers immediately */
+	w83627ehf_update_fan_div(data);
+
 	/* Register sysfs hooks */
   	for (i = 0; i < ARRAY_SIZE(sda_sf3_arrays); i++)
 		if ((err = device_create_file(dev,
-- 
Mark M. Hoffman
mhoffman@lightlink.com

