Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbYE2FmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbYE2FmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 01:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbYE2FmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 01:42:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbYE2FmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 01:42:08 -0400
Date: Wed, 28 May 2008 22:42:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-input@vger.kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, carlos@strangeworlds.co.uk
Subject: Re: RESEND: [PATCH 3/3] Misc: Add HP WMI laptop extras driver
Message-Id: <20080528224200.0c740819.akpm@linux-foundation.org>
In-Reply-To: <20080528132900.GC32646@srcf.ucam.org>
References: <20080528132152.GB32646@srcf.ucam.org>
	<20080528132900.GC32646@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008 14:34:25 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> This driver adds support for reading and configuring certain information 
> on modern HP laptops with WMI BIOS interfaces. It supports enabling and 
> disabling the ambient light sensor, querying attached displays and hard 
> drive temperature, sending events on docking and querying the state of 
> the dock and toggling the state of the wifi, bluetooth and wwan hardware 
> via rfkill. It also makes the little "(i)" button work on machines that 
> send that via WMI rather than via the keyboard controller.
> 
> ...
>
> --- /dev/null
> +++ b/drivers/misc/hp-wmi.c

I see no Kconfig or Makefile updates.

>
> ...
>
> +static struct key_entry hp_wmi_keymap[] = {
> +	{KE_SW, 0x01, SW_DOCK},
> +	{KE_KEY, 0x02, KEY_BRIGHTNESSUP},
> +	{KE_KEY, 0x03, KEY_BRIGHTNESSDOWN},
> +	{KE_KEY, 0x04, KEY_HELP},
> +	{KE_END, 0}
> +};

Could be made const.  hp_wmi_input_setup() already honours that,
others will need tweaks.

> +static struct input_dev *hp_wmi_input_dev;
> +static struct platform_device *hp_wmi_platform_dev;
> +
> +static struct rfkill *wifi_rfkill;
> +static struct rfkill *bluetooth_rfkill;
> +static struct rfkill *wwan_rfkill;

It will be interesting to see the Kconfig rules for this driver..

> +static struct platform_driver hp_wmi_driver = {
> +	.driver = {
> +		   .name = "hp-wmi",
> +		   .owner = THIS_MODULE,
> +		   },

	.driver = {
		   .name = "hp-wmi",
		   .owner = THIS_MODULE,
	},

would be more conventional layout.

> +	.probe = hp_wmi_bios_setup,
> +	.remove = hp_wmi_bios_remove,
> +};
> +
> +static int hp_wmi_perform_query(int query, int write, int value)
> +{
> +	struct acpi_buffer input, output = { ACPI_ALLOCATE_BUFFER, NULL };

The NULL isn't strictly needed.

> +	struct bios_args args;
> +	struct bios_return bios_return;
> +	acpi_status status;
> +	union acpi_object *obj;
> +
> +	args.signature = 0x55434553;
> +	args.command = write ? 0x2 : 0x1;
> +	args.commandtype = query;
> +	args.datasize = write ? 0x4 : 0;
> +	args.data = value;

Could have populated args with `= { .name = value, ... }'?

> +	input.length = sizeof(struct bios_args);
> +	input.pointer = &args;

And `input', perhaps.

> +	status = wmi_evaluate_method(HPWMI_BIOS_GUID, 0, 0x3, &input, &output);
> +
> +	obj = output.pointer;
> +
> +	if (!obj || obj->type != ACPI_TYPE_BUFFER)
> +		return -EINVAL;
> +
> +	bios_return = *((struct bios_return *)obj->buffer.pointer);
> +	if (bios_return.return_code > 0)
> +		return bios_return.return_code * -1;
> +	else
> +		return bios_return.value;
> +}
> +
>
> ...
>
> +static int hp_wmi_setkeycode(struct input_dev *dev, int scancode, int keycode)
> +{
> +	struct key_entry *key;
> +
> +	int old_keycode;

Unneeded newline.

> +	if (keycode < 0 || keycode > KEY_MAX)
> +		return -EINVAL;
> +
> +	key = hp_wmi_get_entry_by_scancode(scancode);
> +	if (key && key->type == KE_KEY) {
> +		old_keycode = key->keycode;
> +		key->keycode = keycode;
> +		set_bit(keycode, dev->keybit);
> +		if (!hp_wmi_get_entry_by_keycode(old_keycode))
> +			clear_bit(old_keycode, dev->keybit);
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
>
> ...
>
> +static int __init hp_wmi_bios_setup(struct platform_device *device)
> +{
> +	device_create_file(&device->dev, &dev_attr_display);
> +	device_create_file(&device->dev, &dev_attr_hddtemp);
> +	device_create_file(&device->dev, &dev_attr_als);
> +	device_create_file(&device->dev, &dev_attr_dock);

wham, four new warnings.

Please check and suitably handle errors.


