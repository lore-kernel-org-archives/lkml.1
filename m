Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543Ab0ALX5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0ALX5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 18:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965Ab0ALX5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 18:57:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:55121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab0ALX5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 18:57:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,264,1262592000"; 
   d="scan'208";a="763685286"
Subject: Re: [PATCH -v2 5/5] x86: use dmi check to treat disabled cpus as
 hotplug cpus.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1263338274-6485-5-git-send-email-yinghai@kernel.org>
References: <1263338274-6485-1-git-send-email-yinghai@kernel.org>
	 <1263338274-6485-5-git-send-email-yinghai@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 12 Jan 2010 15:56:02 -0800
Message-Id: <1263340563.2854.1011.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 15:17 -0800, Yinghai Lu wrote:
> some systems that have disable cpus entries because same
>   BIOS will support 2 sockets and 4 sockets and more at
>   same time, BIOS just leave some disable entries, but
>   those system do not support cpu hotplug. we don't need
>   treat disabled_cpus as hotplug cpus.
> so we can make nr_cpu_ids smaller and save more space
>   (pcpu data allocations), and could make some systems run
>   with logical flat instead of physical flat apic mode
> 
> -v2: change to black list instead

I don't think this list will work because every HT system with HT
disabled in the bios shows that logical cpu as disabled.

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/smpboot.c |   76 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 74 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/smpboot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/smpboot.c
> +++ linux-2.6/arch/x86/kernel/smpboot.c
> @@ -47,6 +47,7 @@
>  #include <linux/bootmem.h>
>  #include <linux/err.h>
>  #include <linux/nmi.h>
> +#include <linux/dmi.h>
>  #include <linux/tboot.h>
>  
>  #include <asm/acpi.h>
> @@ -1178,6 +1179,59 @@ static int __init _setup_possible_cpus(c
>  }
>  early_param("possible_cpus", _setup_possible_cpus);
>  
> +static __initdata int treat_disabled_cpus_as_hotplug = 1;
> +static __init int hotplug_cpus_check(const struct dmi_system_id *d)
> +{
> +        printk(KERN_NOTICE "%s detected: treat disabled cpus as hotplug ones\n", d->ident);
> +        treat_disabled_cpus_as_hotplug = 0;
> +
> +        return 0;
> +}
> +
> +static struct dmi_system_id hotplug_cpus_dmi_table[] __initdata = {
> +        {
> +                .callback = hotplug_cpus_check,
> +                .ident = "Sun Microsystems Sun Fire X4440",
> +                .matches = {
> +                        DMI_MATCH(DMI_SYS_VENDOR, "Sun Microsystems"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Sun Fire X4440"),
> +                },
> +        },
> +        {
> +                .callback = hotplug_cpus_check,
> +                .ident = "Sun Microsystems Sun Fire X4240",
> +                .matches = {
> +                        DMI_MATCH(DMI_SYS_VENDOR, "Sun Microsystems"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Sun Fire X4240"),
> +                },
> +        },
> +        {
> +                .callback = hotplug_cpus_check,
> +                .ident = "Sun Microsystems Sun Fire X4140",
> +                .matches = {
> +                        DMI_MATCH(DMI_SYS_VENDOR, "Sun Microsystems"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Sun Fire X4140"),
> +                },
> +        },
> +        {
> +                .callback = hotplug_cpus_check,
> +                .ident = "Sun Microsystems Sun Fire X4600",
> +                .matches = {
> +                        DMI_MATCH(DMI_SYS_VENDOR, "Sun Microsystems"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Sun Fire X4600"),
> +                },
> +        },
> +        {
> +                .callback = hotplug_cpus_check,
> +                .ident = "Sun Microsystems Sun Fire X4640",
> +                .matches = {
> +                        DMI_MATCH(DMI_SYS_VENDOR, "Sun Microsystems"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Sun Fire X4640"),
> +                },
> +        },
> +        { } /* NULL entry stops DMI scanning */
> +};
> +
>  
>  /*
>   * cpu_possible_mask should be static, it cannot change as cpu's
> @@ -1204,8 +1258,26 @@ __init void prefill_possible_map(void)
>  	if (!num_processors)
>  		num_processors = 1;
>  
> -	if (setup_possible_cpus == -1)
> -		possible = num_processors + disabled_cpus;
> +	if (setup_possible_cpus == -1) {
> +		possible = num_processors;
> +		/*
> +		 * do we have better way to detect hotplug cpus?
> +		 *
> +		 * some systems that have disable cpus entries because same
> +		 *  BIOS will support 2 sockets and 4 sockets and more at
> +		 *  same time, BIOS just leave some disabled entries with wild
> +		 *  apicid, but those system do not support cpu hotplug.
> +		 *  we don't need treat disabled_cpus as hotplug cpus.
> +		 * so we can make nr_cpu_ids smaller and save more space
> +		 *  (pcpu data allocations), and could make some systems run
> +		 *  with logical flat instead of physical flat apic mode
> +		 */
> +		if (disabled_cpus) {
> +			dmi_check_system(hotplug_cpus_dmi_table);
> +			if (treat_disabled_cpus_as_hotplug)
> +				possible += disabled_cpus;
> +		}
> +	}
>  	else
>  		possible = setup_possible_cpus;
>  

