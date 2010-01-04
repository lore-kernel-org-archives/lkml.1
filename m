Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446Ab0ADRQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab0ADRQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172Ab0ADRQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:16:09 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:43221 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab0ADRQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:16:07 -0500
Date: Mon, 04 Jan 2010 12:15:35 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Christian Hofstaedtler <ch@zeha.at>
Cc: x86@kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
In-reply-to: <20100104162114.GA30113@percival.namespace.at>
Message-id: <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain>
References: <20100104162114.GA30113@percival.namespace.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010, Christian Hofstaedtler wrote:

> From: Christian Hofstaedtler <ch+git@zeha.at>
> 
> The Intel DP55KG mainboard cannot reboot using the keyboard controller,
> but ACPI works fine. Auto-select ACPI for this board.
> 
> Signed-off-by: Christian Hofstaedtler <ch@zeha.at>
> ---
>  arch/x86/kernel/reboot.c |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index 1545bc0..b7fcf59 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -427,6 +427,19 @@ static int __init set_pci_reboot(const struct dmi_system_id *d)
>  	return 0;
>  }
>  
> +/*
> + * Some Intel mainboards need reboot=a to actually reboot
> + */
> +static int __init set_acpi_reboot(const struct dmi_system_id *d)
> +{
> +	if (reboot_type != BOOT_ACPI) {
> +		reboot_type = BOOT_ACPI;
> +		printk(KERN_INFO "%s hardware detected. "
> +		       "Selecting ACPI-method for reboots.\n", d->ident);
> +	}
> +	return 0;
> +}
> +
>  static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
>  	{	/* Handle problems with rebooting on Apple MacBook5 */
>  		.callback = set_pci_reboot,
> @@ -452,6 +465,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
>  		},
>  	},
> +	{	/* Handle problems with rebooting on Intel DP55KG mainboard */
> +		.callback = set_acpi_reboot,
> +		.ident = "Intel DP55KG Mainboard",
> +		.matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
> +			DMI_MATCH(DMI_BOARD_NAME, "DP55KG"),
> +		},
> +	},
>  	{ }
>  };
>  
> -- 
> 1.6.4.4


I believe that Venki is sending a patch to make all recent
motherboards use acpi reset by default; and I'd rather
see that kind of patch than this one.

I've had the patch below patch in acpi-test, and thus linus-next,
and -mm since Nov 2008 to change the default for
all systems w/ no issues.

commit 2cb758c617833c18c533e1c4c31167e59d092235
Author: Len Brown <len.brown@intel.com>
Date:   Thu Nov 6 22:43:21 2008 -0500

    x86, ACPI: default to reboot via ACPI (again)
    
    We've run into systems which do not reboot properly
    without using the ACPI reset mechanism.  So lets
    try this in linux-next for a while and see
    how many existing machines stop rebooting
    because they can't handle ACPI reboot.
    
    Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d2d1ce8..4c53aeb 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -32,7 +32,7 @@ EXPORT_SYMBOL(pm_power_off);
 
 static const struct desc_ptr no_idt = {};
 static int reboot_mode;
-enum reboot_type reboot_type = BOOT_KBD;
+enum reboot_type reboot_type = BOOT_ACPI;
 int reboot_force;
 
 #if defined(CONFIG_X86_32) && defined(CONFIG_SMP)



