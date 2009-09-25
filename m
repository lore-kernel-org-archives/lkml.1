Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbZIYQyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbZIYQyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 12:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZIYQyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 12:54:38 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49114 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZIYQyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 12:54:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HspuHGOUCXrAWTTYLXsoy7EOG6O5UeQeXuHEEuS20hJQAhn/Zh+J5rT7bQXAHOhpAC
         +TICmtJ3Hgg0mAByNShWsVZlNIrOpTl6qBdFNp4PTjZ9wCeEp9ukSQn9rDs7b4jD886s
         HgqcckeXPmbZB90/jZiARPG4U1h5yQlDHb7ZM=
Message-ID: <4ABCF5C9.2030603@tuffmail.co.uk>
Date: Fri, 25 Sep 2009 17:54:33 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Ike Panhc <ike.pan@canonical.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexandre Rostovtsev <tetromino@gmail.com>
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
>
>

Hi again!  Here are a few comments on the non-rfkill bits of the driver.  It's not a comprehensive review, just a few nit-picks I noticed.


> +static const struct acpi_device_id hkey_ids[] = {
> +	{"LEN0014", 0},
> +	{"", 0},
> +};
> +
> +static struct acpi_driver hkey_driver = {
> +	.name = "lenovo-sl-laptop-hotkey",
> +	.class = "lenovo",
> +	.ids = hkey_ids,
> +	.ops = {
> +		.add = hkey_add,
> +		.remove = hkey_remove,
> +	},

I recently discovered a neglected .owner field in this struct.  Please set the .owner field to THIS_MODULE to get correct information under "/sys/module/leveno-sl-laptop/drivers"

> +};
> +
> +static void hkey_inputdev_exit(void)
> +{
> +	if (hkey_inputdev) {
> +		input_unregister_device(hkey_inputdev);
> +		input_free_device(hkey_inputdev);
> +		hkey_inputdev = NULL;
> +	}
> +}
> +
> +static int hkey_inputdev_init(void)
> +{
> +	int result;
> +	struct key_entry *key;
> +
> +	hkey_inputdev = input_allocate_device();
> +	if (!hkey_inputdev) {
> +		pr_err("Failed to allocate hotkey input device\n");
> +		return -ENODEV;
> +	}
> +	hkey_inputdev->name = "Lenovo ThinkPad SL Series extra buttons";
> +	hkey_inputdev->phys = LENSL_HKEY_FILE "/input0";
> +	hkey_inputdev->uniq = LENSL_HKEY_FILE;
> +	hkey_inputdev->id.bustype = BUS_HOST;
> +	hkey_inputdev->id.vendor = PCI_VENDOR_ID_LENOVO;

I never have any idea what these accomplish, but Dmitry didn't object to the values so I hope they're sane enough :-).  Anyway, how about adding

	hkey_inputdev->dev.parent = &lensl_pdev->dev;

It should make the input device show up under "/sys/devices/platform/lenovo-sl-laptop", instead of /sys/devices/virtual.

> +	set_bit(EV_KEY, hkey_inputdev->evbit);
> +
> +	for (key = ec_keymap; key->type != KE_END; key++)
> +		set_bit(key->keycode, hkey_inputdev->keybit);
> +
> +	result = input_register_device(hkey_inputdev);
> +	if (result) {
> +		pr_err("Failed to register hotkey input device\n");
> +		input_free_device(hkey_inputdev);
> +		hkey_inputdev = NULL;
> +		return -ENODEV;
> +	}
> +	pr_devel("Initialized hotkey subdriver\n");
> +	return 0;
> +}

...

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

What purpose does this message serve?

> +}
> +
> +MODULE_ALIAS("dmi:bvnLENOVO:*:svnLENOVO*:*:pvrThinkPad SL*:rvnLENOVO:*");
> +MODULE_ALIAS("dmi:bvnLENOVO:*:svnLENOVO*:*:pvrThinkPadSL*:rvnLENOVO:*");

Why can't you use

MODULE_DEVICE_TABLE(acpi, hkey_ids);

instead?

> +module_init(lenovo_sl_laptop_init);
> +module_exit(lenovo_sl_laptop_exit);

Best wishes
Alan
