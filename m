Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZIYQUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZIYQUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 12:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbZIYQUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 12:20:36 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:59633 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbZIYQUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 12:20:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=OE5ehDhGIH4nZOyF9v9H34U6sf0egWkXTRDT32OKGrnn7NzJGM8g2eh0h355YEWSbq
         XcGEQ4By1fdCrV6272qUi7QoodEx3t4Du0oV8lJAblvuz7oCCJIpG3c8in5vc1wgpyYT
         fz+V//NOOumrpVxsk3ORt0XAs5gxPOJrpv1PU=
Message-ID: <4ABCEDCE.4060305@tuffmail.co.uk>
Date: Fri, 25 Sep 2009 17:20:30 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Ike Panhc <ike.pan@canonical.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexandre Rostovtsev <tetromino@gmail.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ACPI: New driver for Lenovo SL laptops
References: <1253805163-12493-1-git-send-email-ike.pan@canonical.com>
In-Reply-To: <1253805163-12493-1-git-send-email-ike.pan@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/24/09, Ike Panhc <ike.pan@canonical.com> wrote:
> lenovo-sl-laptop is a new driver that provides support for hotkeys,
> bluetooth,
> LenovoCare LEDs and fan speed on the Lenovo ThinkPad SL series laptops. The
> original author is Alexandre Rostovtsev. [1] In February 2009 Alexandre has
> posted the driver on the linux-acpi mailing list and and there was some
> feedback suggesting further modifications. [2] I would like to see Linux
> working properly on these laptops. I was encouraged to push this driver
> again
> with the modifications that where suggested in the responses to the initial
> post in order to allow me and others interested in that driver to improve it
> and hopefully get it included upstream.
>
> [1] homepage : http://github.com/tetromino/lenovo-sl-laptop/tree/master
> [2] http://patchwork.kernel.org/patch/7427/
>
> Following the suggestions when last time the origin author has posted on the
> linux-acpi mailing list. The major modification of this driver is listed
> below.
>  - Remove backlight control
>  - Remove procfs EC debug
>  - Remove fan control function
>  - Using generic debugging infrastructure
>  - Support for lastest rfkill infrastructure (by Alexandre)
>  - Register query function into EC for detecting hotkey event
>
> Patch against current checkout of linux-acpi 2.6.31 is below.

I have some comments on the rfkill code.

> +/*************************************************************************
> +    Bluetooth, WWAN, UWB
> + *************************************************************************/
> +
> +enum {
> +	/* ACPI GBDC/SBDC, GWAN/SWAN, GUWB/SUWB bits */
> +	LENSL_RADIO_HWPRESENT	= 0x01, /* hardware is available */
> +	LENSL_RADIO_RADIOSSW	= 0x02, /* radio is enabled */
> +	LENSL_RADIO_RESUMECTRL	= 0x04, /* state at resume: off/last state */
> +};
> +
> +typedef enum {
> +	LENSL_BLUETOOTH = 0,
> +	LENSL_WWAN,
> +	LENSL_UWB,
> +} lensl_radio_type;
> +
> +/* pretend_blocked indicates whether we pretend that the device is
> +   hardware-blocked (used primarily to prevent the device from coming
> +   online when the module is loaded) */

Where do I find pretend_blocked?

> +struct lensl_radio {
> +	lensl_radio_type type;
> +	enum rfkill_type rfktype;
> +	int present;
> +	char *name;
> +	char *rfkname;
> +	struct rfkill *rfk;
> +	int (*get_acpi)(int *);
> +	int (*set_acpi)(int);
> +	int *auto_enable;
> +};
> +
> +static inline int get_wlsw(int *value)
> +{
> +	return lensl_acpi_int_func(hkey_handle, "WLSW", value, 0);
> +}
> +
> +static inline int get_gbdc(int *value)
> +{
> +	return lensl_acpi_int_func(hkey_handle, "GBDC", value, 0);
> +}
> +
> +static inline int get_gwan(int *value)
> +{
> +	return lensl_acpi_int_func(hkey_handle, "GWAN", value, 0);
> +}
> +
> +static inline int get_guwb(int *value)
> +{
> +	return lensl_acpi_int_func(hkey_handle, "GUWB", value, 0);
> +}
> +
> +static inline int set_sbdc(int value)
> +{
> +	return lensl_acpi_int_func(hkey_handle, "SBDC", NULL, 1, value);
> +}
> +
> +static inline int set_swan(int value)
> +{
> +	return lensl_acpi_int_func(hkey_handle, "SWAN", NULL, 1, value);
> +}
> +
> +static inline int set_suwb(int value)
> +{
> +	return lensl_acpi_int_func(hkey_handle, "SUWB", NULL, 1, value);
> +}
> +
> +static int lensl_radio_get(struct lensl_radio *radio, int *hw_blocked,
> +				int *value)
> +{
> +	int wlsw;
> +
> +	*hw_blocked = 0;
> +	if (!radio)
> +		return -EINVAL;

> +	if (!radio->present)
> +		return -ENODEV;

How does this ever happen?  Is this "present" bit really needed?

> +	if (!get_wlsw(&wlsw) && !wlsw)
> +		*hw_blocked = 1;
> +	if (radio->get_acpi(value))
> +		return -EIO;
> +	return 0;
> +}
> +
> +static int lensl_radio_set_on(struct lensl_radio *radio, int *hw_blocked,
> +				bool on)
> +{
> +	int value, ret;
> +	ret = lensl_radio_get(radio, hw_blocked, &value);
> +	if (ret < 0)
> +		return ret;
> +	/* WLSW overrides radio in firmware/hardware, but there is
> +	   no reason to risk weird behaviour. */
> +	if (*hw_blocked)
> +		return ret;
> +	if (on)
> +		value |= LENSL_RADIO_RADIOSSW;
> +	else
> +		value &= ~LENSL_RADIO_RADIOSSW;
> +	if (radio->set_acpi(value))
> +		return -EIO;
> +	return 0;
> +}
> +
> +/* Bluetooth/WWAN/UWB rfkill interface */
> +
> +static void lensl_radio_rfkill_query(struct rfkill *rfk, void *data)
> +{
> +	int ret, value = 0;
> +	ret = get_wlsw(&value);
> +	if (ret)
> +		return;
> +	rfkill_set_hw_state(rfk, !value);
> +}
> +
> +static int lensl_radio_rfkill_set_block(void *data, bool blocked)
> +{
> +	int ret, hw_blocked = 0;
> +	ret = lensl_radio_set_on((struct lensl_radio *)data,
> +		&hw_blocked, !blocked);
> +	/* rfkill spec: just return 0 on hard block */
> +	return ret;
> +}
> +
> +static struct rfkill_ops rfkops = {
> +	NULL,
> +	lensl_radio_rfkill_query,
> +	lensl_radio_rfkill_set_block,
> +};

Unlike thinkpad_acpi or eeepc-laptop, I don't see any support for rfkill notifications.  Can you get a notification when the hardware block changes?  (I assume it's associated with a switch the user can change).  If there's an ACPI notification you should be able to reverse engineer it in the time honoured way :-).

If there's no obvious notification, you should probably use polling, i.e. set .poll() as well as .query().

The third alternative is that you're like dell-laptop, you're planning to get events via the keyboard controller, and you're waiting until Matthew Garret gets the necessary hooks into the linux input stack.  If that's the case you should just add a TODO comment so we know what's going on.

> +static int lensl_radio_new_rfkill(struct lensl_radio *radio,
> +			struct rfkill **rfk, bool sw_blocked,
> +			bool hw_blocked)
> +{
> +	int res;
> +
> +	*rfk = rfkill_alloc(radio->rfkname, &lensl_pdev->dev, radio->rfktype,
> +			&rfkops, radio);
> +	if (!*rfk) {
> +		pr_err("Failed to allocate memory for rfkill class\n");
> +		return -ENOMEM;
> +	}
> +
> +	rfkill_set_hw_state(*rfk, hw_blocked);
> +	rfkill_set_sw_state(*rfk, sw_blocked);

You could do this in one call

rfkill_set_states(*rfk, sw_blocked, hw_blocked);

> +
> +	res = rfkill_register(*rfk);
> +	if (res < 0) {
> +		pr_err("Failed to register %s rfkill switch: %d\n",
> +			radio->rfkname, res);
> +		rfkill_destroy(*rfk);
> +		*rfk = NULL;
> +		return res;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Bluetooth/WWAN/UWB init and exit */
> +
> +static struct lensl_radio lensl_radios[3] = {
> +	{
> +		LENSL_BLUETOOTH,
> +		RFKILL_TYPE_BLUETOOTH,
> +		0,
> +		"bluetooth",

Ugh, I lose track of fields.  How about using named initializers, e.g.

		.name = "bluetooth",

And this first "name" field doesn't seem to be used for anything useful.  Can we get rid of it please?

> +		"lensl_bluetooth_sw",
> +		NULL,

> +		get_gbdc,
> +		set_sbdc,

The getter and setter callbacks seem a bit over-engineered.  Can't we just use something like

		.acpi_method = "SBDC",

> +		&bluetooth_auto_enable,
> +	},
> +	{
> +		LENSL_WWAN,
> +		RFKILL_TYPE_WWAN,
> +		0,
> +		"WWAN",
> +		"lensl_wwan_sw",
> +		NULL,
> +		get_gwan,
> +		set_swan,
> +		&wwan_auto_enable,
> +	},
> +	{
> +		LENSL_UWB,
> +		RFKILL_TYPE_UWB,
> +		0,
> +		"UWB",
> +		"lensl_uwb_sw",
> +		NULL,
> +		get_guwb,
> +		set_suwb,
> +		&uwb_auto_enable,
> +	},
> +};
> +
> +static void radio_exit(lensl_radio_type type)
> +{
> +	if (lensl_radios[type].rfk)
> +		rfkill_unregister(lensl_radios[type].rfk);
> +}
> +
> +static int radio_init(lensl_radio_type type)
> +{
> +	int value, res, hw_blocked = 0, sw_blocked;
> +
> +	if (!hkey_handle)
> +		return -ENODEV;
> +	lensl_radios[type].present = 1; /* need for lensl_radio_get */
> +	res = lensl_radio_get(&lensl_radios[type], &hw_blocked, &value);
> +	lensl_radios[type].present = 0;
> +	if (res && !hw_blocked)
> +		return -EIO;
> +	if (!(value & LENSL_RADIO_HWPRESENT))
> +		return -ENODEV;
> +	lensl_radios[type].present = 1;
> +
> +	if (*lensl_radios[type].auto_enable) {
> +		sw_blocked = 0;
> +		value |= LENSL_RADIO_RADIOSSW;
> +		lensl_radios[type].set_acpi(value);
> +	} else {
> +		sw_blocked = 1;
> +		value &= ~LENSL_RADIO_RADIOSSW;
> +		lensl_radios[type].set_acpi(value);
> +	}

This is very suspicious.  The rfkill core supports two possibilities here:

1) Platform preserves soft-blocked state even when power is removed.  Driver calls rfkill_init_sw_state(rfk, sw_blocked) before registration.  Rfkill core will respect this value (userspace may have other ideas though :-).

It sounds like your hardware could support this first case, but here's the other one for comparison -

2) Platform does not preserve soft-blocked state, or perhaps there is some problem which means we can't trust the platform.  Instead, the *rfkill core* will call set_block() at registration time, with a value taken from the rfkill.default_state module parameter.  The driver should not attempt to initialise the soft blocked state itself.

In either case, the driver should report the current hardware-blocked state before registration.  That seems to be missing here as well.

> +
> +	res = lensl_radio_new_rfkill(&lensl_radios[type],
> +				     &lensl_radios[type].rfk,
> +				     sw_blocked, hw_blocked);
> +
> +	if (res) {
> +		radio_exit(type);
> +		return res;
> +	}
> +	pr_devel("Initialized %s subdriver\n", lensl_radios[type].name);
> +
> +	return 0;
> +}
> +

> +/*************************************************************************
> +    init/exit
> + *************************************************************************/
> +
> +static int __init lenovo_sl_laptop_init(void)
> +{
> +	int ret;
> +	acpi_status status;
> +
> +	if (acpi_disabled)
> +		return -ENODEV;
> +
> +	lensl_wq = create_singlethread_workqueue(LENSL_WORKQUEUE_NAME);
> +	if (!lensl_wq) {
> +		pr_err("Failed to create a workqueue\n");
> +		return -ENOMEM;
> +	}
> +
> +	hkey_handle = ec0_handle = NULL;
> +	status = acpi_get_handle(NULL, LENSL_HKEY, &hkey_handle);
> +	if (ACPI_FAILURE(status)) {
> +		pr_err("Failed to get ACPI handle for %s\n", LENSL_HKEY);
> +		return -ENODEV;
> +	}
> +	status = acpi_get_handle(NULL, LENSL_EC0, &ec0_handle);
> +	if (ACPI_FAILURE(status)) {
> +		pr_err("Failed to get ACPI handle for %s\n", LENSL_EC0);
> +		return -ENODEV;
> +	}
> +
> +	lensl_pdev = platform_device_register_simple(LENSL_DRVR_NAME, -1,
> +						     NULL, 0);
> +	if (IS_ERR(lensl_pdev)) {
> +		ret = PTR_ERR(lensl_pdev);
> +		lensl_pdev = NULL;
> +		pr_err("Failed to register platform device\n");
> +		return ret;
> +	}
> +
> +	radio_init(LENSL_BLUETOOTH);
> +	radio_init(LENSL_WWAN);
> +	radio_init(LENSL_UWB);
> +
> +	hkey_register_notify();
> +	led_init();
> +	hwmon_init();
> +
> +	pr_info("Loaded Lenovo ThinkPad SL Series driver\n");
> +	return 0;
> +}
> +
> +static void __exit lenovo_sl_laptop_exit(void)
> +{
> +	hwmon_exit();
> +	led_exit();
> +	hkey_unregister_notify();
> +
> +	radio_exit(LENSL_UWB);
> +	radio_exit(LENSL_WWAN);
> +	radio_exit(LENSL_BLUETOOTH);
> +
> +	if (lensl_pdev)
> +		platform_device_unregister(lensl_pdev);
> +	destroy_workqueue(lensl_wq);
> +
> +	pr_info("Unloaded Lenovo ThinkPad SL Series driver\n");
> +}
> +
> +MODULE_ALIAS("dmi:bvnLENOVO:*:svnLENOVO*:*:pvrThinkPad SL*:rvnLENOVO:*");
> +MODULE_ALIAS("dmi:bvnLENOVO:*:svnLENOVO*:*:pvrThinkPadSL*:rvnLENOVO:*");
> +
> +module_init(lenovo_sl_laptop_init);
> +module_exit(lenovo_sl_laptop_exit);

