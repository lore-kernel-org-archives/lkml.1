Return-Path: <linux-kernel-owner+w=401wt.eu-S935882AbXGMNvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935882AbXGMNvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 09:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935591AbXGMNuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 09:50:52 -0400
Received: from gw.goop.org ([64.81.55.164]:44428 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934976AbXGMNuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 09:50:51 -0400
Message-ID: <46978303.6030004@goop.org>
Date: Fri, 13 Jul 2007 06:49:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: ak@suse.de, linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: x86: Convert cpu_core_map to be a per cpu variable
References: <Pine.LNX.4.64.0707122354340.17278@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0707122354340.17278@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> cpu_core_map is currently an array defined using NR_CPUS. This means that
> we overallocate since we will rarely really use the maximum 
> number of configured cpus. This may become a problem when we need to 
> increase the NR_CPUs on x86_64 for our new product line.
>
> If we put the cpu_core_map into the per cpu area then it will be allocated
> for each processor as it comes online.
>
> However, this means that the core map cannot be accessed until the per cpu 
> area has been allocated. Xen does a weird thing here looping over all 
> processors and zeroing the masks that are not yet allocated and that will 
> be zeroed when they are allocated. I commented the code out. Maybe there 
> is another purpose? Jeremy?
>   

That code is identical to the code in smp_boot_cpus().  Not sure why it 
needs to be there twice though.  Perhaps it doesn't need to be there at all.

> @@ -1107,11 +1107,11 @@ static void __init smp_boot_cpus(unsigne
>  	 */
>  	for (cpu = 0; cpu < NR_CPUS; cpu++) {
>  		cpus_clear(cpu_sibling_map[cpu]);
> -		cpus_clear(cpu_core_map[cpu]);
> +		cpus_clear(per_cpu(cpu_core_map, cpu));
>  	}
>  
>  	cpu_set(0, cpu_sibling_map[0]);
> -	cpu_set(0, cpu_core_map[0]);
> +	cpu_set(0, per_cpu(cpu_core_map, 0));
>   

> ===================================================================
> --- linux-2.6.22-rc6-mm1.orig/arch/i386/xen/smp.c	2007-07-12 23:32:37.000000000 -0700
> +++ linux-2.6.22-rc6-mm1/arch/i386/xen/smp.c	2007-07-12 23:52:08.000000000 -0700
> @@ -150,7 +150,12 @@ void __init xen_smp_prepare_boot_cpu(voi
>  
>  	for (cpu = 0; cpu < NR_CPUS; cpu++) {
>  		cpus_clear(cpu_sibling_map[cpu]);
> -		cpus_clear(cpu_core_map[cpu]);
> +		/*
> +		 * cpu_core_map lives in a per cpu area that is cleared
> +		 * when the per cpu array is allocated.
> +		 *
> +		 * cpus_clear(per_cpu(cpu_core_map, cpu));
> +		 */
>  	}
>  }
>  
> @@ -160,7 +165,11 @@ void __init xen_smp_prepare_cpus(unsigne
>  
>  	for (cpu = 0; cpu < NR_CPUS; cpu++) {
>  		cpus_clear(cpu_sibling_map[cpu]);
> -		cpus_clear(cpu_core_map[cpu]);
> +		/*
> +		 * cpu_core_ map will be zeroed when the per cpu area is allocated.
> +		 *
> +		 * cpus_clear(per_cpu(cpu_core_map, cpu));
> +		 */
>  	}
>  
>  	smp_store_cpu_info(0);
>   

    J
