Return-Path: <linux-kernel-owner+w=401wt.eu-S932181AbYF2UAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932181AbYF2UAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 16:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759065AbYF2T7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 15:59:55 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:4284 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758980AbYF2T7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 15:59:54 -0400
Date: Sun, 29 Jun 2008 21:59:23 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Riku Voipio <riku.voipio@iki.fi>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       buytenh@wantstofly.org
Subject: Re: LEDs: how to handle gpios that control brightness for all LEDs
Message-ID: <20080629195923.GF2518@deprecation.cyrius.com>
References: <20080628153109.GA20215@deprecation.cyrius.com> <20080628175225.GA32176@kos.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080628175225.GA32176@kos.to>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Riku Voipio <riku.voipio@iki.fi> [2008-06-28 20:52]:
> > I have a device that has various gpios that correspond to the colours
> > (blue, red) of various LEDs.  They only accept 0/1, not the actual
> > brightness.  However, there are two other gpios that can be used to
> > control the brightness (of all LEDs): gpio V_LED 5V is bright, gpio
> > V_LED 3.3V is dimmed and if neither of these two gpios are set, all
> > LEDs stay off.
> 
> > Can I simply export these brightness gpios to userland or would it be
> > better to handle the brightness setting in the kernel so that setting
> > e.g. 100 to a LED would automatically set the V_LED 3.3V gpio and 255
> > would set V_LED 5V.  If so, how should this be done?
> 
> There is a enum led_brightness, which defines LED_HALF and LED_FULL. You
> would need a custom brightness function. Leds-gpio driver would need to
> be extended for it. The main problem with this approach is the
> unexpected effect for enduser, that adjusting brighntess of one led
> affects all of them.

OK, this sounds to me like I should simply export the gpios that
influence the brightness.

> default-on trigger is probably the easiest way.

This works for me, thanks.

New patch below.  Any comments Richard?


diff --git a/arch/arm/mach-orion5x/mv2120-setup.c b/arch/arm/mach-orion5x/mv2120-setup.c
index d838bdb..0ac5209 100644
--- a/arch/arm/mach-orion5x/mv2120-setup.c
+++ b/arch/arm/mach-orion5x/mv2120-setup.c
@@ -137,6 +137,50 @@ static struct i2c_board_info __initdata mv2120_i2c_rtc = {
 	.irq	= 0,
 };
 
+static struct gpio_led mv2120_led_pins[] = {
+	{
+		.name			= "mv2120:blue:health",
+		.gpio			= 0,
+	},
+	{
+		.name			= "mv2120:red:health",
+		.gpio			= 1,
+	},
+	{
+		.name			= "mv2120:led:bright",
+		.gpio			= 4,
+		.default_trigger	= "default-on",
+	},
+	{
+		.name			= "mv2120:led:dimmed",
+		.gpio			= 5,
+	},
+	{
+		.name			= "mv2120:red:sata0",
+		.gpio			= 8,
+		.active_low		= 1,
+	},
+	{
+		.name			= "mv2120:red:sata1",
+		.gpio			= 9,
+		.active_low		= 1,
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
@@ -172,6 +216,7 @@ static void __init mv2120_init(void)
 			gpio_free(MV2120_GPIO_RTC_IRQ);
 	}
 	i2c_register_board_info(0, &mv2120_i2c_rtc, 1);
+	platform_device_register(&mv2120_leds);
 
 	/* register mv2120 specific power-off method */
 	if (gpio_request(MV2120_GPIO_POWER_OFF, "POWEROFF") != 0 ||

-- 
Martin Michlmayr
http://www.cyrius.com/
