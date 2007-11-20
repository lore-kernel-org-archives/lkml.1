Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbXKTP3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbXKTP3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 10:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758863AbXKTP3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 10:29:23 -0500
Received: from ns2.suse.de ([195.135.220.15]:57818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760437AbXKTP3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 10:29:22 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: clameter@sgi.com
Subject: Re: [rfc 01/45] ACPI: Avoid references to impossible processors.
Date: Tue, 20 Nov 2007 16:29:14 +0100
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, lenb@kernel.org
References: <20071120011132.143632442@sgi.com> <20071120011331.944255657@sgi.com>
In-Reply-To: <20071120011331.944255657@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201629.14590.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007 02:11:33 clameter@sgi.com wrote:
> ACPI uses NR_CPUS in various loops and in some it accesses per cpu
> data of processors that are not present(!) and that will never be present.
> The pointers to per cpu data are typically not initialized for processors
> that are not present. So we seem to be reading something here from offset 0
> in memory.
> 
> Make ACPI use nr_cpu_ids instead. That stops at the end of the possible
> processors.

This is a needed bug fix even without your patches, since
non possible CPUs per CPU data is uninitialized already
in the current code. It might not be unmapped, but accessing
it is still not healthy.

I would suggest to separate that one and fast-track it, possibly even for 
2.6.24

[cc'ed Len]

-Andi


> 
> Convert one loop to NR_CPUS to use the cpu_possible map instead.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  drivers/acpi/processor_core.c |   14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/processor_core.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/processor_core.c	2007-11-19 15:45:05.041140492 -0800
> +++ linux-2.6/drivers/acpi/processor_core.c	2007-11-19 15:48:22.513639920 -0800
> @@ -494,7 +494,7 @@ static int get_cpu_id(acpi_handle handle
>  	if (apic_id == -1)
>  		return apic_id;
>  
> -	for (i = 0; i < NR_CPUS; ++i) {
> +	for_each_possible_cpu(i) {
>  		if (cpu_physical_id(i) == apic_id)
>  			return i;
>  	}
> @@ -638,7 +638,7 @@ static int __cpuinit acpi_processor_star
>  		return 0;
>  	}
>  
> -	BUG_ON((pr->id >= NR_CPUS) || (pr->id < 0));
> +	BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
>  
>  	/*
>  	 * Buggy BIOS check
> @@ -771,7 +771,7 @@ static int acpi_processor_remove(struct 
>  
>  	pr = acpi_driver_data(device);
>  
> -	if (pr->id >= NR_CPUS) {
> +	if (pr->id >= nr_cpu_ids) {
>  		kfree(pr);
>  		return 0;
>  	}
> @@ -842,7 +842,7 @@ int acpi_processor_device_add(acpi_handl
>  	if (!pr)
>  		return -ENODEV;
>  
> -	if ((pr->id >= 0) && (pr->id < NR_CPUS)) {
> +	if ((pr->id >= 0) && (pr->id < nr_cpu_ids)) {
>  		kobject_uevent(&(*device)->dev.kobj, KOBJ_ONLINE);
>  	}
>  	return 0;
> @@ -880,13 +880,13 @@ acpi_processor_hotplug_notify(acpi_handl
>  			break;
>  		}
>  
> -		if (pr->id >= 0 && (pr->id < NR_CPUS)) {
> +		if (pr->id >= 0 && (pr->id < nr_cpu_ids)) {
>  			kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
>  			break;
>  		}
>  
>  		result = acpi_processor_start(device);
> -		if ((!result) && ((pr->id >= 0) && (pr->id < NR_CPUS))) {
> +		if ((!result) && ((pr->id >= 0) && (pr->id < nr_cpu_ids))) {
>  			kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
>  		} else {
>  			printk(KERN_ERR PREFIX "Device [%s] failed to start\n",
> @@ -909,7 +909,7 @@ acpi_processor_hotplug_notify(acpi_handl
>  			return;
>  		}
>  
> -		if ((pr->id < NR_CPUS) && (cpu_present(pr->id)))
> +		if ((pr->id < nr_cpu_ids) && (cpu_present(pr->id)))
>  			kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
>  		break;
>  	default:
> 


