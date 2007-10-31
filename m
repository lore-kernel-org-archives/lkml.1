Return-Path: <linux-kernel-owner+w=401wt.eu-S1761174AbXJaPaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761174AbXJaPaq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759898AbXJaPZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:25:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33653 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017AbXJaPZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:25:10 -0400
Date: Wed, 31 Oct 2007 08:12:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [patch 23/26] hwmon/w83627hf: Fix setting fan min right after
	driver load
Message-ID: <20071031151219.GX2437@kroah.com>
References: <20071031150535.967437651@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hwmon-w83627hf-fix-setting-fan-min-right-after-driver-load.patch"
In-Reply-To: <20071031151015.GA2437@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Jean Delvare <khali@linux-fr.org>

Already in Linus' tree:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c09c5184a26158da32801e89d5849d774605f0dd

We need to read the fan clock dividers at initialization time,
otherwise the code in store_fan_min() may use uninitialized values.
That's pretty much the same bug and same fix as for the w83627ehf
driver last month.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Mark M. Hoffman <mhoffman@lightlink.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/w83627hf.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

--- a/drivers/hwmon/w83627hf.c
+++ b/drivers/hwmon/w83627hf.c
@@ -335,6 +335,7 @@ static int w83627hf_remove(struct platfo
 
 static int w83627hf_read_value(struct w83627hf_data *data, u16 reg);
 static int w83627hf_write_value(struct w83627hf_data *data, u16 reg, u16 value);
+static void w83627hf_update_fan_div(struct w83627hf_data *data);
 static struct w83627hf_data *w83627hf_update_device(struct device *dev);
 static void w83627hf_init_device(struct platform_device *pdev);
 
@@ -1127,6 +1128,7 @@ static int __devinit w83627hf_probe(stru
 	data->fan_min[0] = w83627hf_read_value(data, W83781D_REG_FAN_MIN(1));
 	data->fan_min[1] = w83627hf_read_value(data, W83781D_REG_FAN_MIN(2));
 	data->fan_min[2] = w83627hf_read_value(data, W83781D_REG_FAN_MIN(3));
+	w83627hf_update_fan_div(data);
 
 	/* Register common device attributes */
 	if ((err = sysfs_create_group(&dev->kobj, &w83627hf_group)))
@@ -1430,6 +1432,24 @@ static void __devinit w83627hf_init_devi
 			    | 0x01);
 }
 
+static void w83627hf_update_fan_div(struct w83627hf_data *data)
+{
+	int reg;
+
+	reg = w83627hf_read_value(data, W83781D_REG_VID_FANDIV);
+	data->fan_div[0] = (reg >> 4) & 0x03;
+	data->fan_div[1] = (reg >> 6) & 0x03;
+	if (data->type != w83697hf) {
+		data->fan_div[2] = (w83627hf_read_value(data,
+				       W83781D_REG_PIN) >> 6) & 0x03;
+	}
+	reg = w83627hf_read_value(data, W83781D_REG_VBAT);
+	data->fan_div[0] |= (reg >> 3) & 0x04;
+	data->fan_div[1] |= (reg >> 4) & 0x04;
+	if (data->type != w83697hf)
+		data->fan_div[2] |= (reg >> 5) & 0x04;
+}
+
 static struct w83627hf_data *w83627hf_update_device(struct device *dev)
 {
 	struct w83627hf_data *data = dev_get_drvdata(dev);
@@ -1493,18 +1513,8 @@ static struct w83627hf_data *w83627hf_up
 			  w83627hf_read_value(data, W83781D_REG_TEMP_HYST(3));
 		}
 
-		i = w83627hf_read_value(data, W83781D_REG_VID_FANDIV);
-		data->fan_div[0] = (i >> 4) & 0x03;
-		data->fan_div[1] = (i >> 6) & 0x03;
-		if (data->type != w83697hf) {
-			data->fan_div[2] = (w83627hf_read_value(data,
-					       W83781D_REG_PIN) >> 6) & 0x03;
-		}
-		i = w83627hf_read_value(data, W83781D_REG_VBAT);
-		data->fan_div[0] |= (i >> 3) & 0x04;
-		data->fan_div[1] |= (i >> 4) & 0x04;
-		if (data->type != w83697hf)
-			data->fan_div[2] |= (i >> 5) & 0x04;
+		w83627hf_update_fan_div(data);
+
 		data->alarms =
 		    w83627hf_read_value(data, W83781D_REG_ALARM1) |
 		    (w83627hf_read_value(data, W83781D_REG_ALARM2) << 8) |

-- 
