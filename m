Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbYF1Pc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbYF1Pc2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 11:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402AbYF1PcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 11:32:15 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:3901 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040AbYF1PcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 11:32:07 -0400
Date: Sat, 28 Jun 2008 17:31:09 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Cc: buytenh@wantstofly.org
Subject: LEDs: how to handle gpios that control brightness for all LEDs
Message-ID: <20080628153109.GA20215@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

I have a device that has various gpios that correspond to the colours
(blue, red) of various LEDs.  They only accept 0/1, not the actual
brightness.  However, there are two other gpios that can be used to
control the brightness (of all LEDs): gpio V_LED 5V is bright, gpio
V_LED 3.3V is dimmed and if neither of these two gpios are set, all
LEDs stay off.

Can I simply export these brightness gpios to userland or would it be
better to handle the brightness setting in the kernel so that setting
e.g. 100 to a LED would automatically set the V_LED 3.3V gpio and 255
would set V_LED 5V.  If so, how should this be done?  If I can simply
export them to userland, would mv2120:led:dimmed and mv2120:led:bright
be appropriate names?

Second, the LEDS class sets all gpios to off by default.  This is bad
in my case because if neither of the brightness gpios (3.3V or 5V) are
on, the SATA lights won't be shown either.  Is there a way to specify
in the platform code that one gpio should be turned on by default?

Thanks.


For the reference, here is my current work-in-progress patch (I use
numbers rather than #defines for the gpio values because there's a
table listing all gpios in the source file).

--- a/arch/arm/mach-orion5x/mv2120-setup.c
+++ b/arch/arm/mach-orion5x/mv2120-setup.c
@@ -137,6 +137,49 @@ static struct i2c_board_info __initdata mv2120_i2c_rtc = {
 	.irq	= 0,
 };
 
+static struct gpio_led mv2120_led_pins[] = {
+	{
+		.name		= "mv2120:blue:sys",
+		.gpio		= 0,
+	},
+	{
+		.name		= "mv2120:red:sys",
+		.gpio		= 1,
+	},
+	{
+		.name		= "mv2120:led5v",
+		.gpio		= 4,
+	},
+	{
+		.name		= "mv2120:led3.3v",
+		.gpio		= 5,
+	},
+	{
+		.name		= "mv2120:red:sata0",
+		.gpio		= 8,
+		.active_low	= 1,
+	},
+	{
+		.name		= "mv2120:red:sata1",
+		.gpio		= 9,
+		.active_low	= 1,
+	},
+
+};
+
+static struct gpio_led_platform_data mv2120_led_data = {
+	.leds		= mv2120_led_pins,
+	.num_leds	= ARRAY_SIZE(mv2120_led_pins),
+};
+
+static struct platform_device mv2120_leds = {
+	.name	= "leds-gpio",
+	.id	= -1,
+	.dev	= {
+		.platform_data	= &mv2120_led_data,
+	}
+};
+
 static void mv2120_power_off(void)
 {
 	pr_info("%s: triggering power-off...\n", __func__);
@@ -172,6 +215,7 @@ static void __init mv2120_init(void)
 			gpio_free(MV2120_GPIO_RTC_IRQ);
 	}
 	i2c_register_board_info(0, &mv2120_i2c_rtc, 1);
+	platform_device_register(&mv2120_leds);
 
 	/* register mv2120 specific power-off method */
 	if (gpio_request(MV2120_GPIO_POWER_OFF, "POWEROFF") != 0 ||

-- 
Martin Michlmayr
http://www.cyrius.com/
