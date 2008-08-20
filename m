Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYHTGr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYHTGr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 02:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYHTGrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 02:47:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbYHTGrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 02:47:16 -0400
Date: Tue, 19 Aug 2008 23:46:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, michael_e_brown@dell.com
Subject: Re: [PATCH 2/2] Add Dell laptop driver
Message-Id: <20080819234637.c6075e16.akpm@linux-foundation.org>
In-Reply-To: <20080816203027.GC3331@srcf.ucam.org>
References: <20080816202452.GA3331@srcf.ucam.org>
	<20080816202640.GB3331@srcf.ucam.org>
	<20080816203027.GC3331@srcf.ucam.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008 21:30:27 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> This driver provides in-kernel control for the backlight and rfkill 
> functionality on Dell laptops. It's based on the publically available 
> information in the libsmbios package.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
> ---
> 
> commit 472d8eed1891ba440f8e6ffde4787f6308390f7d
> Author: Matthew Garrett <mjg59@m6300.(none)>
> Date:   Sat Aug 16 21:12:51 2008 +0100
> 
>     Add Dell laptop driver
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index a726f3b..c77eab3 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -475,4 +475,16 @@ config SGI_GRU_DEBUG
>  	This option enables addition debugging code for the SGI GRU driver. If
>  	you are unsure, say N.
>  
> +config DELL_LAPTOP
> +        tristate "Dell Laptop Extras (EXPERIMENTAL)"
> +        depends on X86
> +        depends on DCDBAS
> +	depends on EXPERIMENTAL
> +	depends on BACKLIGHT_CLASS_DEVICE
> +	depends on RFKILL
> +	default n
> +	---help---
> +	This driver adds support for rfkill and backlight control to Dell
> +	laptops.

whitespace gone wild.

>  endif # MISC_DEVICES
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index c6c13f6..865343d 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -30,3 +30,4 @@ obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
>  obj-$(CONFIG_SGI_XP)		+= sgi-xp/
>  obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
>  obj-$(CONFIG_HP_ILO)		+= hpilo.o
> +obj-$(CONFIG_DELL_LAPTOP)	+= dell-laptop.o
> \ No newline at end of file
> diff --git a/drivers/misc/dell-laptop.c b/drivers/misc/dell-laptop.c
> new file mode 100644
> index 0000000..ab09a69
> --- /dev/null
> +++ b/drivers/misc/dell-laptop.c
> @@ -0,0 +1,356 @@
> +/*
> + *  Driver for Dell laptop extras
> + *
> + *  Copyright (c) Red Hat <mjg@redhat.com>
> + *
> + *  Based on documentation in the libsmbios package, Copyright (C) 2005 Dell
> + *  Inc.
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/backlight.h>
> +#include <linux/err.h>
> +#include <linux/dmi.h>
> +#include <linux/io.h>
> +#include <linux/rfkill.h>
> +#include "../firmware/dcdbas.h"
> +
> +struct calling_interface_buffer {
> +	u16 class;
> +	u16 select;
> +	volatile u32 input[4];
> +	volatile u32 output[4];
> +} __attribute__ ((packed));

checkpatch will direct you to a fine document.

If the `volatiles' are unavoidable then I'd suggest that both the
changelog and code comments explain the reason(s) for their addition.

> +struct calling_interface_token {
> +	u16 tokenID;
> +	u16 location;
> +	union {
> +		u16 value;
> +		u16 stringlength;
> +	};
> +};
> +
> +struct calling_interface_structure {
> +	u8 type;
> +	u8 length;
> +	u16 handle;

Make the above three members a `struct dmi_header' ...

> +	u16 cmdIOAddress;
> +	u8 cmdIOCode;
> +	u32 supportedCmds;
> +	struct calling_interface_token tokens[];
> +} __attribute__ ((packed));
> +
> +static int da_command_address;
> +static int da_command_code;
> +static int da_num_tokens;
> +static struct calling_interface_token *da_tokens;
> +
> +static struct backlight_device *dell_backlight_device;
> +static struct rfkill *wifi_rfkill;
> +static struct rfkill *bluetooth_rfkill;
> +static struct rfkill *wwan_rfkill;
> +
> +static struct dmi_system_id __initdata dell_device_table[] = {
> +	{
> +		.ident = "Dell laptop",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +			DMI_MATCH(DMI_CHASSIS_TYPE, "8"),
> +		},
> +	},
> +	{ }
> +};
> +
> +static void parse_da_table(const struct dmi_header *dm)
> +{
> +	/* Final token is a terminator, so we don't want to copy it */
> +	int tokens = (dm->length-11)/sizeof(struct calling_interface_token)-1;
> +	struct calling_interface_structure *table =
> +		(struct calling_interface_structure *)dm;

... and switch this to container_of().

> +	/* 4 bytes of table header, plus 7 bytes of Dell header, plus at least
> +	   6 bytes of entry */
> +
> +	if (dm->length < 17)
> +		return;
> +
> +	da_command_address = table->cmdIOAddress;
> +	da_command_code = table->cmdIOCode;
> +
> +	da_tokens = krealloc(da_tokens, (da_num_tokens + tokens) *
> +			     sizeof(struct calling_interface_token),
> +			     GFP_KERNEL);
> +
> +	memcpy(da_tokens+da_num_tokens, table->tokens,
> +	       sizeof(struct calling_interface_token) * tokens);

krealloc() can fail.

> +	da_num_tokens += tokens;
> +}
> +
> +static void find_tokens(const struct dmi_header *dm)
> +{
> +	switch (dm->type) {
> +	case 0xd4: /* Indexed IO */
> +		break;
> +	case 0xd5: /* Protected Area Type 1 */
> +		break;
> +	case 0xd6: /* Protected Area Type 2 */
> +		break;
> +	case 0xda: /* Calling interface */
> +		parse_da_table(dm);
> +		break;
> +	}
> +}
> +
> +static int find_token_location(int tokenid)
> +{
> +	int i;
> +	for (i = 0; i < da_num_tokens; i++) {
> +		if (da_tokens[i].tokenID == tokenid)
> +			return da_tokens[i].location;
> +	}
> +	return -1;
> +}
> +
> +static struct calling_interface_buffer *dell_send_request(
> +	struct calling_interface_buffer *buffer, int class, int select)

static struct calling_interface_buffer *
dell_send_request(struct calling_interface_buffer *buffer, int class,
		  int select)

would be more typical layout, although not vastly better.

> +{
> +	struct smi_cmd *command = kzalloc(sizeof(struct smi_cmd), GFP_KERNEL);
> +	command->magic = SMI_CMD_MAGIC;
> +	command->command_address = da_command_address;
> +	command->command_code = da_command_code;
> +	command->ebx = virt_to_phys(buffer);
> +	command->ecx = 0x42534931;

Please put a blank line between end-of-locals and start-of-code. 
Everywhere, all the time.

kzalloc() can fail and must be checked.

> +	buffer->class = class;
> +	buffer->select = select;
> +
> +	dcdbas_smi_request(command);
> +
> +	kfree(command);

Can we make `command' a local?  It's pretty small.  Perhaps
dcdbas_smi_request() (nee smi_request()) has some secret, undocumented
alignment restriction, similar to DMA?

> +	return buffer;
> +}
> +
> +static int dell_rfkill_set(int radio, enum rfkill_state state)
> +{
> +	struct calling_interface_buffer *buffer =
> +		kzalloc(sizeof(struct calling_interface_buffer), GFP_KERNEL);
> +	int disable = (state == RFKILL_STATE_UNBLOCKED) ? 0 : 1;
> +	buffer->input[0] = (1 | (radio<<8) | (disable << 16));
> +	dell_send_request(buffer, 17, 11);
> +	kfree(buffer);
> +	return 0;
> +}

kzalloc() can fail.

calling_interface_buffer is small enough to be a local.

coding-style.

> +static int dell_wifi_set(void *data, enum rfkill_state state)
> +{
> +	return dell_rfkill_set(1, state);
> +}
> +
> +static int dell_bluetooth_set(void *data, enum rfkill_state state)
> +{
> +	return dell_rfkill_set(2, state);
> +}
> +
> +static int dell_wwan_set(void *data, enum rfkill_state state)
> +{
> +	return dell_rfkill_set(3, state);
> +}
> +
> +static int dell_rfkill_get(int bit, enum rfkill_state *state)
> +{
> +	struct calling_interface_buffer *buffer =
> +		kzalloc(sizeof(struct calling_interface_buffer), GFP_KERNEL);
> +	int status;
> +	int new_state = RFKILL_STATE_HARD_BLOCKED;
> +
> +	dell_send_request(buffer, 17, 11);
> +	status = buffer->output[1];

kzalloc() can fail.

> +	if (status & (1<<16))
> +		new_state = RFKILL_STATE_SOFT_BLOCKED;
> +
> +	if (status & (1<<bit))
> +		*state = new_state;
> +	else
> +		*state = RFKILL_STATE_UNBLOCKED;
> +
> +	kfree(buffer);

`buffer' is small enough to be a local.

> +	return 0;
> +}
> +
> +static int dell_wifi_get(void *data, enum rfkill_state *state)
> +{
> +	return dell_rfkill_get(17, state);
> +}
> +
> +static int dell_bluetooth_get(void *data, enum rfkill_state *state)
> +{
> +	return dell_rfkill_get(18, state);
> +}
> +
> +static int dell_wwan_get(void *data, enum rfkill_state *state)
> +{
> +	return dell_rfkill_get(19, state);
> +}
> +
> +static void dell_setup_rfkill(void)
> +{
> +	struct calling_interface_buffer *buffer =
> +		kzalloc(sizeof(struct calling_interface_buffer), GFP_KERNEL);

ditto, ditto

> +	int status;
> +
> +	dell_send_request(buffer, 17, 11);
> +	status = buffer->output[1];
> +
> +	if ((status & (1<<2|1<<8)) == (1<<2|1<<8)) {

Where does the reader go to find the meaning of these bits?

(code comment needed)

> +		wifi_rfkill = rfkill_allocate(NULL, RFKILL_TYPE_WLAN);
> +		wifi_rfkill->name = "dell-wifi";
> +		wifi_rfkill->toggle_radio = dell_wifi_set;
> +		wifi_rfkill->get_state = dell_wifi_get;
> +		rfkill_register(wifi_rfkill);
> +	}
> +
> +	if ((status & (1<<3|1<<9)) == (1<<3|1<<9)) {
> +		bluetooth_rfkill = rfkill_allocate(NULL, RFKILL_TYPE_BLUETOOTH);
> +		bluetooth_rfkill->name = "dell-bluetooth";
> +		bluetooth_rfkill->toggle_radio = dell_bluetooth_set;
> +		bluetooth_rfkill->get_state = dell_bluetooth_get;
> +		rfkill_register(bluetooth_rfkill);
> +	}
> +
> +	if ((status & (1<<4|1<<10)) == (1<<4|1<<10)) {
> +		wwan_rfkill = rfkill_allocate(NULL, RFKILL_TYPE_WWAN);
> +		wwan_rfkill->name = "dell-wwan";
> +		wwan_rfkill->toggle_radio = dell_wwan_set;
> +		wwan_rfkill->get_state = dell_wwan_get;
> +		rfkill_register(wwan_rfkill);
> +	}

dittoes

> +	kfree(buffer);
> +}
> +
> +static int dell_send_intensity(struct backlight_device *bd)
> +{
> +	int intensity = bd->props.brightness;
> +	struct calling_interface_buffer *buffer =
> +		kzalloc(sizeof(struct calling_interface_buffer), GFP_KERNEL);

blah

> +	buffer->input[0] = find_token_location(0x7d);
> +	buffer->input[1] = intensity;

I don't think we really needed local variable `intensity'.  I guess it
has some commentary value.

> +	if (buffer->input[0] == -1) {
> +		kfree(buffer);
> +		return -ENODEV;
> +	}
> +
> +	dell_send_request(buffer, 1, 1);
> +	dell_send_request(buffer, 1, 2);
> +
> +	kfree(buffer);
> +
> +	return 0;
> +}
> +
> +static int dell_get_intensity(struct backlight_device *bd)
> +{
> +	struct calling_interface_buffer *buffer =
> +		kzalloc(sizeof(struct calling_interface_buffer), GFP_KERNEL);

ditto, ditto

> +	int brightness;
> +
> +	buffer->input[0] = find_token_location(0x7d);
> +
> +	if (buffer->input[0] == -1) {
> +		kfree(buffer);
> +		return -ENODEV;
> +	}
> +
> +	dell_send_request(buffer, 0, 1);
> +
> +	brightness = buffer->output[1];
> +
> +	kfree(buffer);
> +
> +	return brightness;
> +}
> +
> +static struct backlight_ops dell_ops = {
> +	.get_brightness = dell_get_intensity,
> +	.update_status  = dell_send_intensity,
> +};
> +
> +static int __init dell_init(void)
> +{
> +	struct calling_interface_buffer *buffer;
> +	int max_intensity = 0;
> +
> +	if (!dmi_check_system(dell_device_table))
> +		return -ENODEV;
> +
> +	dmi_walk(find_tokens);
> +
> +	if (!da_tokens)
> +		return -ENODEV;
> +
> +	buffer = kzalloc(sizeof(struct calling_interface_buffer), GFP_KERNEL);

ditto

> +	buffer->input[0] = find_token_location(0x7d);
> +
> +	if (buffer->input[0] != -1) {
> +		dell_send_request(buffer, 2, 1);
> +		max_intensity = buffer->output[3];
> +	}
> +
> +	kfree(buffer);
> +
> +	if (max_intensity) {
> +		dell_backlight_device = backlight_device_register(
> +			"dell_backlight",
> +			NULL, NULL,
> +			&dell_ops);
> +
> +		if (IS_ERR(dell_backlight_device)) {
> +			dell_backlight_device = NULL;
> +			goto out;

Should propagate PTR_ERR(dell_backlight_device) back to caller.

> +		}
> +
> +		dell_backlight_device->props.max_brightness = max_intensity;
> +		dell_backlight_device->props.brightness =
> +			dell_get_intensity(dell_backlight_device);
> +		backlight_update_status(dell_backlight_device);
> +	}
> +
> +	dell_setup_rfkill();
> +
> +out:
> +	return 0;
> +}
> +
> +static void __exit dell_exit(void)
> +{
> +	if (dell_backlight_device)
> +		backlight_device_unregister(dell_backlight_device);

backlight_device_unregister(NULL) is legal

> +	if (wifi_rfkill)
> +		rfkill_unregister(wifi_rfkill);
> +	if (bluetooth_rfkill)
> +		rfkill_unregister(bluetooth_rfkill);
> +	if (wwan_rfkill)
> +		rfkill_unregister(wwan_rfkill);
> +}
> +
> +module_init(dell_init);
> +module_exit(dell_exit);
> +
> +MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
> +MODULE_DESCRIPTION("Dell laptop driver");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("dmi:*svnDellInc.:*:ct8:*");

