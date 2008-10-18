Return-Path: <linux-kernel-owner+w=401wt.eu-S1754204AbYJRTSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbYJRTSP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYJRTFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:05:37 -0400
Received: from mail.suse.de ([195.135.220.2]:38674 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbYJRTFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:05:35 -0400
Date: Sat, 18 Oct 2008 11:48:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jean Delvare <khali@linux-fr.org>
Subject: [patch 23/26] hwmon: (it87) Prevent power-off on Shuttle SN68PT
Message-ID: <20081018184818.GX301@suse.de>
References: <20081018183853.004667035@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="hwmon-prevent-power-off-on-shuttle-sn68pt.patch"
In-Reply-To: <20081018184708.GA301@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Jean Delvare <khali@linux-fr.org>

based on commit 98dd22c3e086d76058083432d4d8fb85f04bab90 upstream

On the Shuttle SN68PT, FAN_CTL2 is apparently not connected to a fan,
but to something else. One user has reported instant system power-off
when changing the PWM2 duty cycle, so we disable it.

I use the board name string as the trigger in case the same board is
ever used in other systems.

This closes lm-sensors ticket #2349:
pwmconfig causes a hard poweroff
http://www.lm-sensors.org/ticket/2349

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/it87.c |   39 +++++++++++++++++++++++++++++++++------
 1 file changed, 33 insertions(+), 6 deletions(-)

--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -46,6 +46,8 @@
 #include <linux/err.h>
 #include <linux/mutex.h>
 #include <linux/sysfs.h>
+#include <linux/string.h>
+#include <linux/dmi.h>
 #include <asm/io.h>
 
 #define DRVNAME "it87"
@@ -235,6 +237,8 @@ struct it87_sio_data {
 	enum chips type;
 	/* Values read from Super-I/O config space */
 	u8 vid_value;
+	/* Values set based on DMI strings */
+	u8 skip_pwm;
 };
 
 /* For each registered chip, we need to keep some data in memory.
@@ -952,6 +956,7 @@ static int __init it87_find(unsigned sho
 {
 	int err = -ENODEV;
 	u16 chip_type;
+	const char *board_vendor, *board_name;
 
 	superio_enter();
 	chip_type = force_id ? force_id : superio_inw(DEVID);
@@ -1009,6 +1014,25 @@ static int __init it87_find(unsigned sho
 			pr_info("it87: in7 is VCCH (+5V Stand-By)\n");
 	}
 
+	sio_data->skip_pwm = 0;
+	/* Disable specific features based on DMI strings */
+	board_vendor = dmi_get_system_info(DMI_BOARD_VENDOR);
+	board_name = dmi_get_system_info(DMI_BOARD_NAME);
+	if (board_vendor && board_name) {
+		if (strcmp(board_vendor, "nVIDIA") == 0
+		 && strcmp(board_name, "FN68PT") == 0) {
+			/* On the Shuttle SN68PT, FAN_CTL2 is apparently not
+			   connected to a fan, but to something else. One user
+			   has reported instant system power-off when changing
+			   the PWM2 duty cycle, so we disable it.
+			   I use the board name string as the trigger in case
+			   the same board is ever used in other systems. */
+			pr_info("it87: Disabling pwm2 due to "
+				"hardware constraints\n");
+			sio_data->skip_pwm = (1 << 1);
+		}
+	}
+
 exit:
 	superio_exit();
 	return err;
@@ -1157,22 +1181,25 @@ static int __devinit it87_probe(struct p
 		if ((err = device_create_file(dev,
 		     &sensor_dev_attr_pwm1_enable.dev_attr))
 		 || (err = device_create_file(dev,
-		     &sensor_dev_attr_pwm2_enable.dev_attr))
-		 || (err = device_create_file(dev,
 		     &sensor_dev_attr_pwm3_enable.dev_attr))
 		 || (err = device_create_file(dev,
 		     &sensor_dev_attr_pwm1.dev_attr))
 		 || (err = device_create_file(dev,
-		     &sensor_dev_attr_pwm2.dev_attr))
-		 || (err = device_create_file(dev,
 		     &sensor_dev_attr_pwm3.dev_attr))
 		 || (err = device_create_file(dev,
 		     &dev_attr_pwm1_freq))
 		 || (err = device_create_file(dev,
-		     &dev_attr_pwm2_freq))
-		 || (err = device_create_file(dev,
 		     &dev_attr_pwm3_freq)))
 			goto ERROR4;
+		if (!(sio_data->skip_pwm & (1 << 1))) {
+			if ((err = device_create_file(dev,
+			     &sensor_dev_attr_pwm2_enable.dev_attr))
+			 || (err = device_create_file(dev,
+			     &sensor_dev_attr_pwm2.dev_attr))
+			 || (err = device_create_file(dev,
+			     &dev_attr_pwm2_freq)))
+				goto ERROR4;
+		}
 	}
 
 	if (data->type == it8712 || data->type == it8716

-- 
