Return-Path: <linux-kernel-owner+w=401wt.eu-S934062AbYEHWNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934062AbYEHWNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 18:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933418AbYEHWMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 18:12:51 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46488 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933291AbYEHWMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 18:12:50 -0400
Message-ID: <48237ADE.3090703@sgi.com>
Date: Thu, 08 May 2008 15:12:46 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, lethal@linux-sh.org, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: sh migor_defconfig build breakage
References: <20080508203949.GC22887@cs181133002.pp.htv.fi> <48236E59.8070400@sgi.com> <4823711D.70401@sgi.com> <482376BC.2000404@sgi.com>
In-Reply-To: <482376BC.2000404@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Mike Travis wrote:
>> Mike Travis wrote:
>>> Adrian Bunk wrote:
>>>> Commit aa6b54461cc5c0019b9d792adf3176b444c10763
>>>> (asm-generic: add node_to_cpumask_ptr macro)
>>>> causes the following build error with migor_defconfig:
>>>>
>>>> <--  snip  -->
>>>>
>>>> ...
>>>>   CC      arch/sh/kernel/asm-offsets.s
>>>> In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mm.h:8,
>>>>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/kernel/asm-offsets.c:13:
>>>> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/gfp.h: In function 'alloc_pages_node':
>>>> /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/gfp.h:190: 
>>>> error: implicit declaration of function 'cpu_to_node'
>>>> make[2]: *** [arch/sh/kernel/asm-offsets.s] Error 1
>>>>
>>>> <--  snip  -->
>>>>
>>>> cu
>>>> Adrian
...
> 
> It looks like the migor_config has NUMA=y so is there not a cpu_to_node function?
> (looking with cscope didn't find it.)
> 
> I believe this may be the source of the error:
> 
> include/linux/gfp.h:
> 
> static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
>                                                 unsigned int order)
> {
> ...
>         /* Unknown node is current node */
>         if (nid < 0)
>                 nid = numa_node_id();
> 
> 
> include/linux/mmzone.h:
> 
> #include <linux/topology.h>
> /* Returns the number of the current Node. */
> #ifndef numa_node_id
> #define numa_node_id()          (cpu_to_node(raw_smp_processor_id()))
> #endif
> 
> 
> I can't put into include/linux/topology.h the catchall default:
> 
> #ifndef cpu_to_node
> #define cpu_to_node(cpu)	(0)
> #endif
> 
> Because some arch's have it defined as an inline function.  Perhaps the
> easiest would be to add to include/asm-sh/topology.h a simple define of
> cpu_to_node()?
> 
> Thanks,
> Mike


Ahh, this is what caused the error.  In include/asm-generic/topology.h
cpu_to_node is only defined now if NUMA is turned off.

#ifndef CONFIG_NUMA

/* Other architectures wishing to use this simple topology API should fill
   in the below functions as appropriate in their own <asm/topology.h> file. */
#ifndef cpu_to_node
#define cpu_to_node(cpu)        ((void)(cpu),0)
#endif
...

So before my change arch 'sh' used the default define whether NUMA was
set or not.

An alternative would be to change all the arch's that define cpu_to_node
as an inline to:

#define cpu_to_node(cpu)	_cpu_to_node(cpu)
static inline int _cpu_to_node(int cpu)
{
	...
}

Then include/linux/topology could define cpu_to_node if it's not already
defined.

Andrew or Ingo - do you have any preferences?

Thanks,
Mike

