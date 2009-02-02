Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbZBBJL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbZBBJL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 04:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZBBJLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 04:11:20 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:28305 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZBBJLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 04:11:18 -0500
Date: Mon, 2 Feb 2009 10:11:03 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Thomas Renninger <trenn@suse.de>, Hans de Goede <hdegoede@redhat.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090202101103.1208c035@hyperion.delvare>
In-Reply-To: <20090201212243.GA23852@dreamland.darkstar.lan>
References: <20090125210520.GA12963@dreamland.darkstar.lan>
	<200901291729.24859.trenn@suse.de>
	<4981FC38.205@redhat.com>
	<200901301529.14810.trenn@suse.de>
	<20090201212243.GA23852@dreamland.darkstar.lan>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luca,

On Sun, 1 Feb 2009 22:22:43 +0100, Luca Tettamanti wrote:
> I've rewritten the patch, the idea behind it is still the same but the
> solution is more generic. The code checks a list of DMI entries and
> (optionally) a HID for each entry; if the DMI data matches and the HID
> (if not NULL) is found then resource checking is set to strict, otherwise
> it falls back to lax.
> 
> ---
> Just RFC, it's still UNTESTED...
> 
>  drivers/acpi/osl.c |   79 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 76 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> index 6729a49..c6d1a1c 100644
> --- a/drivers/acpi/osl.c
> +++ b/drivers/acpi/osl.c
> @@ -1063,7 +1063,10 @@ __setup("acpi_wake_gpes_always_on", acpi_wake_gpes_always_on_setup);
>   * in arbitrary AML code and can interfere with legacy drivers.
>   * acpi_enforce_resources= can be set to:
>   *
> - *   - strict           (2)
> + *   - auto             (2)
> + *     -> detect possible conflicts with ACPI drivers and switch to
> + *     strict if needed, otherwise act like lax
> + *   - strict           (3)
>   *     -> further driver trying to access the resources will not load
>   *   - lax (default)    (1)
>   *     -> further driver trying to access the resources will load, but you
> @@ -1073,11 +1076,12 @@ __setup("acpi_wake_gpes_always_on", acpi_wake_gpes_always_on_setup);
>   *     -> ACPI Operation Region resources will not be registered
>   *
>   */
> -#define ENFORCE_RESOURCES_STRICT 2
> +#define ENFORCE_RESOURCES_STRICT 3
> +#define ENFORCE_RESOURCES_AUTO   2
>  #define ENFORCE_RESOURCES_LAX    1
>  #define ENFORCE_RESOURCES_NO     0

I don't see any reason to change ENFORCE_RESOURCES_STRICT from 2 to 3.
Just add ENFORCE_RESOURCES_AUTO as 3 and that's it, makes your patch
smaller.

>  
> -static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
> +static unsigned int acpi_enforce_resources = ENFORCE_RESOURCES_AUTO;
>  
>  static int __init acpi_enforce_resources_setup(char *str)
>  {
> @@ -1086,6 +1090,8 @@ static int __init acpi_enforce_resources_setup(char *str)
>  
>  	if (!strcmp("strict", str))
>  		acpi_enforce_resources = ENFORCE_RESOURCES_STRICT;
> +	else if (!strcmp("auto", str))
> +		acpi_enforce_resources = ENFORCE_RESOURCES_AUTO;
>  	else if (!strcmp("lax", str))
>  		acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
>  	else if (!strcmp("no", str))
> @@ -1096,6 +1102,73 @@ static int __init acpi_enforce_resources_setup(char *str)
>  
>  __setup("acpi_enforce_resources=", acpi_enforce_resources_setup);
>  
> +static acpi_status acpi_res_quick_check_hid_cb(acpi_handle obj_handle,
> +		u32 nesting_level, void *context, void **return_value)
> +{
> +	*((bool *)return_value) = true;
> +	return AE_CTRL_TERMINATE;
> +}
> +
> +static int acpi_res_quick_check_hid(const struct dmi_system_id *d)
> +{
> +	acpi_status ret;
> +	bool found = false;
> +	char *hid;
> +
> +	if (!d->driver_data)
> +		goto strict;
> +
> +	hid = d->driver_data;
> +	ret = acpi_get_devices(hid, acpi_res_quick_check_hid_cb,
> +				NULL, (void **)&found);
> +
> +	if (ret == AE_OK && found)
> +		goto strict;
> +
> +	return 0;
> +strict:
> +	printk(KERN_DEBUG "ACPI: detected %s system: "
> +			"enforcing strict resource checking\n", d->ident);

Should be pr_debug().

> +	return 1;
> +}
> +
> +/* The following systems have ACPI drivers that might overlap the
> + * functionality of native drivers (mostly in hwmon subsys). If
> + * acpi_enforce_resources is set to auto the following table is
> + * used to enforce strict checking in matching systems, in order
> + * to avoid conflicts.
> + * Note that driver_data and the acpi_res_quick_check_hid callback
> + * are used to further refine the match, checking for the presence
> + * of the given HID (driver_data) in the DSDT. Both fields are
> + * optional for DMI-only rules.
> + */
> +static const struct dmi_system_id resource_quirks[] = {

You must include <linux/dmi.h> for this.

I think it's better to tag this structure as __initdata than const, so
that it is cleaned up after initialization. Then I guess you can also
tag acpi_res_quick_check_hid_cb() and acpi_res_quick_check_hid() as
__init so the runtime memory overhead is zero.

> +	{
> +		.ident = "Asus",
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer"),
> +		},
> +		.driver_data = "ATK0110",
> +		.callback = acpi_res_quick_check_hid,
> +	},
> +	{ }
> +};
> +
> +static int __init acpi_apply_resource_quirk(void)
> +{
> +	if (acpi_enforce_resources != ENFORCE_RESOURCES_AUTO)
> +		return 0;
> +
> +	dmi_check_system(resource_quirks);
> +
> +	if (acpi_enforce_resources == ENFORCE_RESOURCES_AUTO)
> +		/* This system is not listed, fallback to 'lax' */
> +		acpi_enforce_resources = ENFORCE_RESOURCES_LAX;
> +
> +	return 0;
> +}
> +fs_initcall(acpi_apply_resource_quirk);
> +
>  /* Check for resource conflicts between ACPI OperationRegions and native
>   * drivers */
>  int acpi_check_resource_conflict(struct resource *res)

Otherwise it looks good to me, pretty clean and flexible. Good work!

-- 
Jean Delvare
