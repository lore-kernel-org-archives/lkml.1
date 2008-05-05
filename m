Return-Path: <linux-kernel-owner+w=401wt.eu-S1761786AbYEEUZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761786AbYEEUZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759655AbYEEUZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:25:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45861 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759444AbYEEUZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:25:03 -0400
Message-ID: <481F6D1D.2050407@sgi.com>
Date: Mon, 05 May 2008 13:25:01 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [BUG] sysfs cpu?/topology is empty in 2.6.25 (32-bit Intel system)
References: <20080505135215.GD5420@dirshya.in.ibm.com>
In-Reply-To: <20080505135215.GD5420@dirshya.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've tried this patch on an x86_64 system and it seems to be ok.
One thing I've noticed is that turning on ENABLE_TOPO_DEFINES
will turn on "arch_provides_topology_pointers".  This indicates
that the support functions can provide a pointer to various
topology related cpu masks.  I haven't checked the i386 arch
code yet to determine if this is in fact true (or if the arch
wants it to be true.  It is a low impact area used for showing
the cpu core and thread siblings.)

Thanks,
Mike

Vaidyanathan Srinivasan wrote:
> Hi,
> 
> System topology on intel based system needs to be exported 
> for non-numa case as well.
> 
> All parts of asm-i386/topology.h has come under 
> #ifdef CONFIG_NUMA after the merge to asm-x86/topology.h
> 
> /sys/devices/system/cpu/cpu?/topology/* is populated based on 
> ENABLE_TOPO_DEFINES
> 
> The sysfs cpu topology is not being populated on my dual socket
> dual core xeon 5160 processor based (x86 32 bit) system.
> 
> CONFIG_NUMA is not set in my case yet the topology is relevant
> and useful.
> 
> irqbalance daemon application depends on topology to build the
> cpus and package list and it fails on Fedora9 beta since the 
> sysfs topology was not being populated in the 2.6.25 kernel.
> 
> I am not sure if it was intentional to not define ENABLE_TOPO_DEFINES
> for non-numa systems.
> 
> This fix has been tested on the above mentioned dual core, dual socket
> system.
> 
> Comments? Did I miss already posted fix?
> 
> --Vaidy
> 
> Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> 
> ---
>  include/asm-x86/topology.h |   18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> --- linux-2.6.25.1.orig/include/asm-x86/topology.h
> +++ linux-2.6.25.1/include/asm-x86/topology.h
> @@ -25,6 +25,16 @@
>  #ifndef _ASM_X86_TOPOLOGY_H
>  #define _ASM_X86_TOPOLOGY_H
>  
> +#ifdef CONFIG_X86_32
> +# ifdef CONFIG_X86_HT
> +#  define ENABLE_TOPO_DEFINES
> +# endif
> +#else
> +# ifdef CONFIG_SMP
> +#  define ENABLE_TOPO_DEFINES
> +# endif
> +#endif
> +
>  #ifdef CONFIG_NUMA
>  #include <linux/cpumask.h>
>  #include <asm/mpspec.h>
> @@ -112,10 +122,6 @@ extern unsigned long node_end_pfn[];
>  extern unsigned long node_remap_size[];
>  #define node_has_online_mem(nid) (node_start_pfn[nid] != node_end_pfn[nid])
>  
> -# ifdef CONFIG_X86_HT
> -#  define ENABLE_TOPO_DEFINES
> -# endif
> -
>  # define SD_CACHE_NICE_TRIES	1
>  # define SD_IDLE_IDX		1
>  # define SD_NEWIDLE_IDX		2
> @@ -123,10 +129,6 @@ extern unsigned long node_remap_size[];
>  
>  #else
>  
> -# ifdef CONFIG_SMP
> -#  define ENABLE_TOPO_DEFINES
> -# endif
> -
>  # define SD_CACHE_NICE_TRIES	2
>  # define SD_IDLE_IDX		2
>  # define SD_NEWIDLE_IDX		0

