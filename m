Return-Path: <linux-kernel-owner+w=401wt.eu-S1758280AbYAQXam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758280AbYAQXam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 18:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYAQXad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 18:30:33 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:31151 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022AbYAQXab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 18:30:31 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Fri, 18 Jan 2008 00:24:48 +0100
From: "Andreas Herrmann3" <andreas.herrmann3@amd.com>
To: "Venki Pallipadi" <venkatesh.pallipadi@intel.com>
cc: "Ingo Molnar" <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
 fixes
Message-ID: <20080117232448.GJ12631@alberich.amd.com>
References: <20080117191211.GA12631@alberich.amd.com>
 <20080117203600.GB27778@elte.hu>
 <20080117210301.GC12631@alberich.amd.com>
 <20080117211308.GA7858@elte.hu>
 <20080117213131.GA25389@linux-os.sc.intel.com>
 <20080117214209.GA12811@elte.hu>
 <20080117220650.GE12631@alberich.amd.com>
 <20080117221505.GB18883@elte.hu>
 <20080117225243.GH12631@alberich.amd.com>
 <20080117230410.GA8694@linux-os.sc.intel.com>
MIME-Version: 1.0
In-Reply-To: <20080117230410.GA8694@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Jan 2008 23:24:32.0594 (UTC)
 FILETIME=[1D741B20:01C85960]
X-WSS-ID: 6B913C3924S8213286-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 03:04:10PM -0800, Venki Pallipadi wrote:
> 
> Below is another potential fix for the problem here. Going through ACPI
> ioremap usages, we found at one place the mapping is cached for possible
> optimization reason and not unmapped later. Patch below always unmaps
> ioremap at this place in ACPICA.
> 
> Thanks,
> Venki
> 
> 
> Index: linux-2.6.git/drivers/acpi/executer/exregion.c
> ===================================================================
> --- linux-2.6.git.orig/drivers/acpi/executer/exregion.c	2008-01-17 03:18:39.000000000 -0800
> +++ linux-2.6.git/drivers/acpi/executer/exregion.c	2008-01-17 07:34:33.000000000 -0800
> @@ -48,6 +48,8 @@
>  #define _COMPONENT          ACPI_EXECUTER
>  ACPI_MODULE_NAME("exregion")
>  
> +static int ioremap_cache;
> +
>  /*******************************************************************************
>   *
>   * FUNCTION:    acpi_ex_system_memory_space_handler
> @@ -249,6 +251,13 @@
>  		break;
>  	}
>  
> +	if (!ioremap_cache) {
> +		acpi_os_unmap_memory(mem_info->mapped_logical_address,
> +		                     window_size);
> +		mem_info->mapped_logical_address = 0;
> +		mem_info->mapped_physical_address = 0;
> +		mem_info->mapped_length = 0;
> +	}
>  	return_ACPI_STATUS(status);
>  }
>  


Applying and compiling your patch I see:

  CC      drivers/acpi/executer/exregion.o
drivers/acpi/executer/exregion.c: In function 'acpi_ex_system_memory_space_handler':
drivers/acpi/executer/exregion.c:81: warning: 'window_size' may be used uninitialized in this function
 

After glancing through this file it seems that ioremap_cache is always 0
and acpi_os_unmap_memory will unconditionally be executed at end of this function.
I am not familiar with that code. But I just want to reinsure that this
is what you want. And if so, why is that variable needed?
But maybe I missed something ...
(I'll test it tomorrow, or I better should say later today.)


Andreas



