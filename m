Return-Path: <linux-kernel-owner+w=401wt.eu-S1751826AbYLBTvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbYLBTvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:51:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYLBTvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:51:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714AbYLBTvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:51:44 -0500
Date: Tue, 2 Dec 2008 11:50:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, Matt_Domsch@dell.com, greg@kroah.com,
       linux-acpi@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
       Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 2/2] misc: Add dell-laptop driver
Message-Id: <20081202115029.2b9d1153.akpm@linux-foundation.org>
In-Reply-To: <20081127163444.GB22846@srcf.ucam.org>
References: <20081127163357.GA22846@srcf.ucam.org>
	<20081127163444.GB22846@srcf.ucam.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2008 16:34:44 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Add a driver for controling Dell-specific backlight and rfkill interfaces.
> This driver makes use of the dcdbas interface to the Dell firmware to allow
> the backlight and rfkill interfaces on Dell systems to be driven through the
> standardised sysfs interfaces.
>     
>
> ...
>
> +struct calling_interface_buffer {
> +	u16 class;
> +	u16 select;
> +	volatile u32 input[4];
> +	volatile u32 output[4];
> +} __attribute__ ((packed));

We have that little __packed helper for this.

I don't think it adds a ton of value personally, but the __attribute__
syntax is a bit of a mouthful, and consistency is nice.  I've suggested
that Andy add a checkpatch rule for open-coded use of the various
helpers which are defined in include/linux/compiler-gcc.h.

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
> +	struct dmi_header header;
> +	u16 cmdIOAddress;
> +	u8 cmdIOCode;
> +	u32 supportedCmds;
> +	struct calling_interface_token tokens[];
> +} __attribute__ ((packed));

ditto.

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

this can be made const.

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

lol.

> +	struct calling_interface_structure *table =
> +		container_of(dm, struct calling_interface_structure, header);
> +
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
> +	if (!da_tokens)
> +		return;
> +
> +	memcpy(da_tokens+da_num_tokens, table->tokens,
> +	       sizeof(struct calling_interface_token) * tokens);
> +
> +	da_num_tokens += tokens;
> +}

OK.  No locking is needed for updates to the global state?

>
> ...
>
> +static int __init dell_init(void)
> +{
> +	struct calling_interface_buffer buffer;
> +	int max_intensity = 0;
> +	int ret;
> +
> +	if (!dmi_check_system(dell_device_table))
> +		return -ENODEV;
> +
> +	dmi_walk(find_tokens);
> +
> +	if (!da_tokens)
> +		return -ENODEV;
> +
> +	ret = dell_setup_rfkill();
> +
> +	if (ret) {
> +		printk(KERN_WARNING "dell-laptop: Unable to setup rfkill\n");
> +		return ret;
> +	}
> +
> +#ifdef CONFIG_ACPI
> +	if (acpi_video_backlight_support())
> +		return 0;
> +#endif

Do we need the ifdefs here?  It looks like include/linux/acpi.h tries
to provide a suitable 0-returning stub?

If the ifdefs are needed, then perhaps include/linux/acpi.h needs fixing?

> +	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
> +	buffer.input[0] = find_token_location(BRIGHTNESS_TOKEN);
> +
> +	if (buffer.input[0] != -1) {
> +		dell_send_request(&buffer, 0, 2);
> +		max_intensity = buffer.output[3];
> +	}
> +
> +	if (max_intensity) {
> +		dell_backlight_device = backlight_device_register(
> +			"dell_backlight",
> +			NULL, NULL,
> +			&dell_ops);
> +
> +		if (IS_ERR(dell_backlight_device)) {
> +			dell_backlight_device = NULL;
> +			ret = PTR_ERR(dell_backlight_device);

The above two statements are in the wrong order.

> +			goto out;
> +		}
> +
> +		dell_backlight_device->props.max_brightness = max_intensity;
> +		dell_backlight_device->props.brightness =
> +			dell_get_intensity(dell_backlight_device);
> +		backlight_update_status(dell_backlight_device);
> +	}
> +
> +	return 0;
> +out:
> +	if (wifi_rfkill)
> +		rfkill_unregister(wifi_rfkill);
> +	if (bluetooth_rfkill)
> +		rfkill_unregister(bluetooth_rfkill);
> +	if (wwan_rfkill)
> +		rfkill_unregister(wwan_rfkill);
> +	return ret;
> +}
> +

