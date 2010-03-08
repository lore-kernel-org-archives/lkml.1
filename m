Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab0CHFft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 00:35:49 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:50460 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab0CHFfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 00:35:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=t6ZlrndZQnXI4S9mxtd9TRr2D6csKSRjMunsRpaXfHRDdKTOcPDPFYBljdoxtPR/hv
         0kpmpL7tD5r5l7HF9O8/2k1AkzCRqef21tdOSEOz31JgXnzCqIcsFQP9j600YbUE3GvV
         TCWSFgQI35Zr16B0umyjXjgSgpajRp2//7uoc=
MIME-Version: 1.0
In-Reply-To: <20100305092338.GA32433@atrey.karlin.mff.cuni.cz>
References: <20100106071026.GD1382@ucw.cz> <f17812d71001052317h2bf25fady6bd729b35ef6db63@mail.gmail.com> 
	<20100107065230.GA1303@ucw.cz> <f17812d71001062333y2e49fa21scf91718da9ae3091@mail.gmail.com> 
	<20100305092338.GA32433@atrey.karlin.mff.cuni.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 8 Mar 2010 13:35:23 +0800
Message-ID: <f17812d71003072135wcc7165m31a302b7da75c36e@mail.gmail.com>
Subject: Re: sharp c-3000 aka spitz: fix warn_on introduced in 2.6.32-rc1
To: Pavel Machek <pavel@ucw.cz>
Cc: dtor@mail.ru, linux-input@vger.kernel.org, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 5:23 PM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >> > Sharp-SL code uses strange, complex grouping of gpios for wakeups
>> >> > toggling. Fortunately, it is unneeded in recent kernels (and actually
>> >> > provokes WARN_ONs during resume). Remove it.
>> >> >
>> >> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
>> >>
>> >> Pavel,
>> >>
>> >> The code to be removed below is used to support pxa27x_keypad
>> >> to be able to resume from sleep. What's the exact reason to remove
>> >> this on spitz?
>> >
>> > Well, otherwise I get this during resume: (2.6.32 regression)
>> >
>> > (and similar for matrix-keypad, but dmitry worked around that
>> > already).
>> >
>> > Problem is that gpio-keys and matrix-keypad want to set_wake for each
>> > gpio individually, hw can do that, but pxa27x.c breaks it.
>> >
>> > I don't get it; what is pxa27x_keypad used on? It looks like
>> > matrix-keypad subset.
>>
>> pxa27x has its own specific keypad controller. And since we now
>> use enable_irq_wake, and the keypad controller has only one
>> such IRQ_KEYPAD, will have to setup the keypad GPIO wakeup
>> as a whole.
>
> But pxa27x keypad controlled is not used on spitz, right? So why do we
> break spitz by tying GPIO wakeup settings together?

We are not typing, it's an option only for pxa27x keypad controller driver.
I'm going to modify corgi_pm.c as follows, please check if it's doable to
spitz as well:

commit 1864fa1398440577f7c84e7370a99f773d2d3089
Author: Eric Miao <eric.y.miao@gmail.com>
Date:   Mon Jan 11 21:27:21 2010 +0800

    [ARM] pxa/corgi: cleanup GPIO configurations and low power mode settings

    Signed-off-by: Eric Miao <eric.y.miao@gmail.com>

diff --git a/arch/arm/mach-pxa/corgi.c b/arch/arm/mach-pxa/corgi.c
index ae496b6..adb8ce0 100644
--- a/arch/arm/mach-pxa/corgi.c
+++ b/arch/arm/mach-pxa/corgi.c
@@ -106,18 +106,18 @@ static unsigned long corgi_pin_config[] __initdata = {
 	GPIO8_MMC_CS0,

 	/* GPIO Matrix Keypad */
-	GPIO66_GPIO,	/* column 0 */
-	GPIO67_GPIO,	/* column 1 */
-	GPIO68_GPIO,	/* column 2 */
-	GPIO69_GPIO,	/* column 3 */
-	GPIO70_GPIO,	/* column 4 */
-	GPIO71_GPIO,	/* column 5 */
-	GPIO72_GPIO,	/* column 6 */
-	GPIO73_GPIO,	/* column 7 */
-	GPIO74_GPIO,	/* column 8 */
-	GPIO75_GPIO,	/* column 9 */
-	GPIO76_GPIO,	/* column 10 */
-	GPIO77_GPIO,	/* column 11 */
+	GPIO66_GPIO | MFP_LPM_DRIVE_HIGH,	/* column 0 */
+	GPIO67_GPIO | MFP_LPM_DRIVE_HIGH,	/* column 1 */
+	GPIO68_GPIO | MFP_LPM_DRIVE_HIGH,	/* column 2 */
+	GPIO69_GPIO | MFP_LPM_DRIVE_HIGH,	/* column 3 */
+	GPIO70_GPIO | MFP_LPM_DRIVE_HIGH,	/* column 4 */
+	GPIO71_GPIO | MFP_LPM_DRIVE_HIGH,	/* column 5 */
+	GPIO72_GPIO | MFP_LPM_DRIVE_HIGH,	/* column 6 */
+	GPIO73_GPIO | MFP_LPM_DRIVE_HIGH,	/* column 7 */
+	GPIO74_GPIO | MFP_LPM_DRIVE_HIGH,	/* column 8 */
+	GPIO75_GPIO | MFP_LPM_DRIVE_HIGH,	/* column 9 */
+	GPIO76_GPIO | MFP_LPM_DRIVE_HIGH,	/* column 10 */
+	GPIO77_GPIO | MFP_LPM_DRIVE_HIGH,	/* column 11 */
 	GPIO58_GPIO,	/* row 0 */
 	GPIO59_GPIO,	/* row 1 */
 	GPIO60_GPIO,	/* row 2 */
@@ -128,17 +128,20 @@ static unsigned long corgi_pin_config[] __initdata = {
 	GPIO65_GPIO,	/* row 7 */

 	/* GPIO */
-	GPIO9_GPIO,	/* CORGI_GPIO_nSD_DETECT */
-	GPIO7_GPIO,	/* CORGI_GPIO_nSD_WP */
-	GPIO21_GPIO,	/* CORGI_GPIO_ADC_TEMP */
-	GPIO22_GPIO,	/* CORGI_GPIO_IR_ON */
-	GPIO33_GPIO,	/* CORGI_GPIO_SD_PWR */
-	GPIO38_GPIO,	/* CORGI_GPIO_CHRG_ON */
-	GPIO43_GPIO,	/* CORGI_GPIO_CHRG_UKN */
-	GPIO44_GPIO,	/* CORGI_GPIO_HSYNC */
+	GPIO9_GPIO,				/* CORGI_GPIO_nSD_DETECT */
+	GPIO7_GPIO,				/* CORGI_GPIO_nSD_WP */
+	GPIO11_GPIO | WAKEUP_ON_EDGE_BOTH,	/* CORGI_GPIO_MAIN_BAT_{LOW,COVER} */
+	GPIO13_GPIO | MFP_LPM_KEEP_OUTPUT,	/* CORGI_GPIO_LED_ORANGE */
+	GPIO21_GPIO,				/* CORGI_GPIO_ADC_TEMP */
+	GPIO22_GPIO,				/* CORGI_GPIO_IR_ON */
+	GPIO33_GPIO,				/* CORGI_GPIO_SD_PWR */
+	GPIO38_GPIO | MFP_LPM_KEEP_OUTPUT,	/* CORGI_GPIO_CHRG_ON */
+	GPIO43_GPIO | MFP_LPM_KEEP_OUTPUT,	/* CORGI_GPIO_CHRG_UKN */
+	GPIO44_GPIO,				/* CORGI_GPIO_HSYNC */

 	GPIO0_GPIO | WAKEUP_ON_EDGE_BOTH,	/* CORGI_GPIO_KEY_INT */
 	GPIO1_GPIO | WAKEUP_ON_EDGE_RISE,	/* CORGI_GPIO_AC_IN */
+	GPIO3_GPIO | WAKEUP_ON_EDGE_BOTH,	/* CORGI_GPIO_WAKEUP */
 };

 /*
@@ -675,6 +678,15 @@ static void __init corgi_init(void)

 	pxa2xx_mfp_config(ARRAY_AND_SIZE(corgi_pin_config));

+	/* allow wakeup from various GPIOs */
+	gpio_set_wake(CORGI_GPIO_KEY_INT, 1);
+	gpio_set_wake(CORGI_GPIO_WAKEUP, 1);
+	gpio_set_wake(CORGI_GPIO_AC_IN, 1);
+	gpio_set_wake(CORGI_GPIO_CHRG_FULL, 1);
+
+	if (!machine_is_corgi())
+		gpio_set_wake(CORGI_GPIO_MAIN_BAT_LOW, 1);
+
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);
diff --git a/arch/arm/mach-pxa/corgi_pm.c b/arch/arm/mach-pxa/corgi_pm.c
index bb68347..3f1dc74 100644
--- a/arch/arm/mach-pxa/corgi_pm.c
+++ b/arch/arm/mach-pxa/corgi_pm.c
@@ -77,45 +77,6 @@ static void corgi_discharge(int on)

 static void corgi_presuspend(void)
 {
-	int i;
-	unsigned long wakeup_mask;
-
-	/* charging , so CHARGE_ON bit is HIGH during OFF. */
-	if (READ_GPIO_BIT(CORGI_GPIO_CHRG_ON))
-		PGSR1 |= GPIO_bit(CORGI_GPIO_CHRG_ON);
-	else
-		PGSR1 &= ~GPIO_bit(CORGI_GPIO_CHRG_ON);
-
-	if (READ_GPIO_BIT(CORGI_GPIO_LED_ORANGE))
-		PGSR0 |= GPIO_bit(CORGI_GPIO_LED_ORANGE);
-	else
-		PGSR0 &= ~GPIO_bit(CORGI_GPIO_LED_ORANGE);
-
-	if (READ_GPIO_BIT(CORGI_GPIO_CHRG_UKN))
-		PGSR1 |= GPIO_bit(CORGI_GPIO_CHRG_UKN);
-	else
-		PGSR1 &= ~GPIO_bit(CORGI_GPIO_CHRG_UKN);
-
-	/* Resume on keyboard power key */
-	PGSR2 = (PGSR2 & ~CORGI_GPIO_ALL_STROBE_BIT) | CORGI_GPIO_STROBE_BIT(0);
-
-	wakeup_mask = GPIO_bit(CORGI_GPIO_KEY_INT) |
GPIO_bit(CORGI_GPIO_WAKEUP) | GPIO_bit(CORGI_GPIO_AC_IN) |
GPIO_bit(CORGI_GPIO_CHRG_FULL);
-
-	if (!machine_is_corgi())
-		wakeup_mask |= GPIO_bit(CORGI_GPIO_MAIN_BAT_LOW);
-
-	PWER = wakeup_mask | PWER_RTC;
-	PRER = wakeup_mask;
-	PFER = wakeup_mask;
-
-	for (i = 0; i <=15; i++) {
-		if (PRER & PFER & GPIO_bit(i)) {
-			if (GPLR0 & GPIO_bit(i) )
-				PRER &= ~GPIO_bit(i);
-			else
-				PFER &= ~GPIO_bit(i);
-		}
-	}
 }

 static void corgi_postsuspend(void)
