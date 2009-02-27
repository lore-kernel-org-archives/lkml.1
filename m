Return-Path: <linux-kernel-owner+w=401wt.eu-S1756969AbZB0N2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbZB0N2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 08:28:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757908AbZB0N2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 08:28:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44569 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862AbZB0N2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 08:28:01 -0500
Date: Fri, 27 Feb 2009 14:27:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alexandre Rostovtsev <tetromino@gmail.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lenovo-sl-laptop : driver for review
Message-ID: <20090227132752.GG1482@ucw.cz>
References: <20090216025918.66d7a466@leftboat.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216025918.66d7a466@leftboat.lan>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> lenovo-sl-laptop is a new driver that adds support for hotkeys, bluetooth,
> LEDs, fan speed and screen brightness on the Lenovo ThinkPad SL series
> laptops. [1] These laptops are not supported by the normal thinkpad_acpi
> driver because their firmware is quite different from the "real"
> ThinkPads. [2] Based on advice from linux-thinkpad and linux-kernel
> mailing lists, I am posting it to linux-acpi for review and, hopefully,
> eventual inclusion.

Thanks for doing that.

> One important note concerning the backlight. Currently, the ACPI video
> driver has poor support for the ThinkPad SL series because their _BCL
> and _BQC methods violate the ACPI spec. Thus, the lenovo-sl-laptop
> driver adds optional (controlled via module parameter, default off)
> support for setting the backlight brightness.
> Zhang Rui has stated that he will be working on making the ACPI video
> driver properly support the ThinkPad SL series and other laptops with
> non-standard backlight brightness interfaces. When he is finished,
> backlight functionality can probably be safely removed from
> lenovo-sl-laptop. [3]

Well, it should probably be removed now so that a) we don't confuse
users and b) keep the review easy. ...if users start to rely on
lenovo-sl for their brightness and deconfigure acpi-video, it will be
a regression when you remove that support...  


> +Reporting bugs
> +--------------
> +
> +You can report bugs to me by email, or use the Linux ThinkPad mailing list:
> +http://mailman.linux-thinkpad.org/mailman/listinfo/linux-thinkpad
> +You will need to subscribe to the mailing list to post.

Add MAINTAINERS entry?


> +/sys/devices/platform/lenovo-sl-laptop/hwmon/hwmon*/
> + Fan control. fan1_input is the fan speed, in RPM. If pwm1_enable is zero,
> + fan is in automatic mode; setting pwm1_enable to 1 lets you control fan
> + speed manually. Manual control is via pwm1 file; values are in the range
> + 0-255, where 0 is fan off, 255 is max (corresponds to ~ 4600 RPM), and
> + default is 126 (corresponds to ~ 2700 RPM).

Maybe using /sys/class/hwmon here is cleaner?

> +/sys/class/backlight/thinkpad_screen/
> + The backlight brightness interface. Only available if the control_backlight
> + parameter is on. This interface will very likely disappear in a future
> + driver version, after the ACPI video driver properly supports the
> SL series.

...and this will change when acpi-video is fixed. Better remove that
before merge.

> +bluetooth_auto_enable:
> + If this parameter is set to 1 and your laptop supports bluetooth, then
> + bluetooth will be activated immediately when you load this driver. If
> + the parameter is set to 0, bluetooth will not be automatically activated,
> + and you will need to enable it manually:
> + cat 1 > /sys/devices/platform/lenovo-sl-laptop/rfkill/rfkill*/state
> + Default is 1.

Is this really needed?> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> index 9436311..be6faaa 100644
> --- a/drivers/platform/x86/Kconfig
> +++ b/drivers/platform/x86/Kconfig
> @@ -288,6 +288,24 @@ config THINKPAD_ACPI_HOTKEY_POLL
>  	  If you are not sure, say Y here.  The driver enables polling only if
>  	  it is strictly necessary to do so.
>  
> +config LENOVO_SL_LAPTOP
> +	tristate "Lenovo ThinkPad SL Series Laptop Extras (EXPERIMENTAL)"
> +	depends on ACPI
> +	depends on EXPERIMENTAL
> +	select BACKLIGHT_CLASS_DEVICE
> +	select HWMON
> +	select INPUT
> +	select NEW_LEDS
> +	select LEDS_CLASS
> +	select RFKILL

The driver is huge... and I'm not sure if all those options can be
simply selected. Maybe it should be split to parts?

...if (for example) LEDS_CLASS depends on something, you can't just
select it...

> +#define LENSL_LAPTOP_VERSION "0.02"

You should not need this in mainline.

> +/* #define instead of enum needed for macro */
> +#define LENSL_EMERG	0
> +#define LENSL_ALERT	1
> +#define LENSL_CRIT	2
> +#define LENSL_ERR	3
> +#define LENSL_WARNING	4
> +#define LENSL_NOTICE	5
> +#define LENSL_INFO	6
> +#define LENSL_DEBUG	7
> +
> +#define vdbg_printk_(a_dbg_level, format, arg...) \
> +	do { if (dbg_level >= a_dbg_level) \
> +		printk("<" #a_dbg_level ">" LENSL_MODULE_NAME ": " \
> +			format, ## arg); \
> +	} while (0)
> +#define vdbg_printk(a_dbg_level, format, arg...) \
> +	vdbg_printk_(a_dbg_level, format, ## arg)

Custom debugging infrastructure. Please use generic one.

> +module_param(debug_ec, bool, S_IRUGO);
> +MODULE_PARM_DESC(debug_ec,
> +	"Present EC debugging interface in procfs. WARNING: writing to the "
> +	"EC can hang your system and possibly damage your hardware.");


Sounds dangerous and clearly does not belong to /proc. Please drop it.

> +/*************************************************************************
> +    bluetooth sysfs - copied nearly verbatim from thinkpad_acpi.c
> + *************************************************************************/

That's quite a lot of code for verbatim copy; create shared helper?


> +/*************************************************************************
> +    LEDs
> + *************************************************************************/
> +
> +#ifdef CONFIG_NEW_LEDS



I thought you SELECT-ed that?


> +static void led_tv_worker(struct work_struct *work)
> +{
> +	if (!led_tv.supported)
> +		return;
> +	set_tvls(led_tv.new_code);
> +	if (led_tv.new_code)
> +		led_tv.brightness = LED_FULL;
> +	else
> +		led_tv.brightness = LED_OFF;
> +}
> +
> +static void led_tv_brightness_set_sysfs(struct led_classdev *led_cdev,
> +				enum led_brightness brightness)
> +{
> +	switch (brightness) {
> +	case LED_OFF:
> +		led_tv.new_code = LENSL_LED_TV_OFF;
> +		break;
> +	case LED_FULL:
> +		led_tv.new_code = LENSL_LED_TV_ON;
> +		break;
> +	default:
> +		return;
> +	}
> +	queue_work(lensl_wq, &led_tv.work);
> +}


Can you use delayed-leds.h?

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
