Return-Path: <linux-kernel-owner+w=401wt.eu-S1763261AbZJOWv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763261AbZJOWv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758736AbZJOWv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:51:56 -0400
Received: from lucidpixels.com ([75.144.35.66]:58130 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758708AbZJOWvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:51:55 -0400
Date: Thu, 15 Oct 2009 18:51:19 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Bryan Donlan <bdonlan@gmail.com>
cc: bruce.w.allan@intel.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] Add quirk for ACPI reboots on Intel DP55KG boards.
In-Reply-To: <1255645796-29944-1-git-send-email-bdonlan@gmail.com>
Message-ID: <alpine.DEB.2.00.0910151831020.15317@p34.internal.lan>
References: <alpine.DEB.2.00.0910151655590.4808@p34.internal.lan> <1255645796-29944-1-git-send-email-bdonlan@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Oct 2009, Bryan Donlan wrote:

> Keyboard-based and BIOS-based reboots don't work on Intel DP55KG boards;
> use ACPI reboots instead.
>
> Reported-By: Justin Piszcz <jpiszcz@lucidpixels.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Signed-off-by: Bryan Donlan <bdonlan@gmail.com>
> ---
> arch/x86/kernel/reboot.c |   23 +++++++++++++++++++++++
> 1 files changed, 23 insertions(+), 0 deletions(-)
>
> Justin, could you give this patch a try? It should make the reboot=acpi
> workaround automatic.
> (x86 maintainers CC'd)
>
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index a1a3cdd..67bfcef 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -134,6 +134,21 @@ static int __init set_bios_reboot(const struct dmi_system_id *d)
> 	return 0;
> }
>
> +/*
> + * Some machines require the "reboot=a" commandline option.
> + * This quirk makes that automatic.
> + */
> +static int __init set_acpi_reboot(const struct dmi_system_id *d)
> +{
> +	if (reboot_type != BOOT_ACPI) {
> +		reboot_type = BOOT_ACPI;
> +		printk(KERN_INFO "%s series board detected. Selecting ACPI "
> +				"method for reboots.\n", d->ident);
> +	}
> +	return 0;
> +}
> +
> +
> static struct dmi_system_id __initdata reboot_dmi_table[] = {
> 	{	/* Handle problems with rebooting on Dell E520's */
> 		.callback = set_bios_reboot,
> @@ -259,6 +274,14 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
> 			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
> 		},
> 	},
> +	{	/* Handle problems with rebooting on Intel DP55KG */
> +		.callback = set_acpi_reboot,
> +		.ident = "Intel DP55KG",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "DP55KG"),
> +		},
> +	},
> 	{ }
> };
>
> -- 
> 1.6.3.3
>

Hello,

# patch -p1 < /home/jpiszcz/patch 
patching file arch/x86/kernel/reboot.c
Hunk #1 succeeded at 132 (offset -2 lines).
Hunk #2 succeeded at 272 (offset -2 lines).

# uname -a
Linux p34.internal.lan 2.6.31.3 #8 SMP Wed Oct 14 14:37:37 EDT 2009 x86_64 GNU/Linux

# ls -l /usr/src/linux/.config-* | tail -n 1
-rw-r--r-- 1 root root 45762 2009-10-15 18:31 /usr/src/linux/.config-2.6.31.3-9

Hi,

Thanks for the patch-- tested, but unfortunately it still hanged at the 
reboot process (when I did not use reboot=a).

I see in the patch:
> +             printk(KERN_INFO "%s series board detected. Selecting ACPI

But..

$ dmesg | grep -i 'series board'
$

$ uname -a
Linux p34.internal.lan 2.6.31.3 #9 SMP Thu Oct 15 18:31:29 EDT 2009 x86_64 GNU/Linux

$ cat /proc/cmdline 
auto BOOT_IMAGE=2.6.31.3-9 ro root=812 3w-9xxx.use_msi=1

> +			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "DP55KG"),

But..

# dmidecode|grep -i dp55
         Product Name: DP55KG

Stops at Corp.

# dmidecode|grep -i vendor
         Vendor: Intel Corp.

Changed that line to:
+     DMI_MATCH(DMI_SYS_VENDOR, "Intel Corp."),

That did not work either, ideas?

Justin.
