Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbZCVXZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbZCVXZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 19:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbZCVXZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 19:25:24 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:11684 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182AbZCVXZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 19:25:24 -0400
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <49C6C8DE.7020405@tremplin-utc.net>
Date: Mon, 23 Mar 2009 00:25:18 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 4/5] lis3: solve dependency between core and ACPI
References: <49AD8B0A.90901@tremplin-utc.net> <1236131099-8082-1-git-send-email-daniel@caiaq.de> <1236131099-8082-2-git-send-email-daniel@caiaq.de>
In-Reply-To: <1236131099-8082-2-git-send-email-daniel@caiaq.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Mack schreef:
> This solves the dependency between lis3lv02d.[ch] and ACPI specific
> methods. It introduces a ->bus_priv pointer to the device struct which
> is casted to 'struct acpi_device' in the ACIP layer. Changed hp_accel.c
> accordingly.
Sorry for the long delay. Eventually I've found time to test the patch
and fix a bug: the axis conversion was set too late, preventing the
calibration to work.

The attached patch should make your modifications fully working with the
hp laptops :-)
I guess the best is to fold it into your patch and I'll ack the new
version.

Eric

=
Must put the axis info before using it.
---
 drivers/hwmon/hp_accel.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index 363220b..b6c32c5 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -287,11 +287,6 @@ static int lis3lv02d_add(struct acpi_device *device)
 	/* obtain IRQ number of our device from ACPI */
 	lis3lv02d_enum_resources(device);

-	/* call the core layer do its init */
-	ret = lis3lv02d_init_device(&lis3_dev);
-	if (ret)
-		return ret;
-
 	/* If possible use a "standard" axes order */
 	if (dmi_check_system(lis3lv02d_dmi_ids) == 0) {
 		printk(KERN_INFO DRIVER_NAME ": laptop model unknown, "
@@ -299,6 +294,11 @@ static int lis3lv02d_add(struct acpi_device *device)
 		lis3_dev.ac = lis3lv02d_axis_normal;
 	}

+	/* call the core layer do its init */
+	ret = lis3lv02d_init_device(&lis3_dev);
+	if (ret)
+		return ret;
+
 	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
 	ret = led_classdev_register(NULL, &hpled_led.led_classdev);
 	if (ret) {
-- 
1.6.2.1

