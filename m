Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYHZTmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYHZTmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYHZTmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:42:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769AbYHZTmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:42:01 -0400
Date: Tue, 26 Aug 2008 12:40:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <48B45387.8090205@sgi.com>
Message-ID: <alpine.LFD.1.10.0808261219050.3363@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808231313170.3363@nehalem.linux-foundation.org> <48B29F7B.6080405@hp.com> <48B2A421.7080705@hp.com> <alpine.LFD.1.10.0808251019380.3363@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0808251106270.3363@nehalem.linux-foundation.org> <48B313E0.1000501@hp.com> <alpine.LFD.1.10.0808251326500.3363@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808251344250.3363@nehalem.linux-foundation.org>
 <alpine.LFD.1.10.0808251401590.3363@nehalem.linux-foundation.org> <20080826072220.GB31876@elte.hu> <48B45387.8090205@sgi.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 26 Aug 2008, Mike Travis wrote:
> 
> I would be most interested in any tools to analyze call-trees and
> accumulated stack usages.  My current method of using kdb is really
> time consuming.

Well, even just scripts/checkstack.pl is quite relevant.

The fact is, anything with a stack footprint of more than a hundred bytes 
is suspect. We _do_ have a lot of cases of several hundred bytes, and some 
of them are even very intentional.

For an example of _intentional_ and valid large stacks, look at 
do_sys_poll and do_select. They both have a big stack footprint in a 
normal kernel, and that's on purpose - it's not pretty, but they are very 
common and performance-sensitive functions, and using a big stack allows 
some basic allocations to be much cheaper by default.

Same goes for early_printk(), although I don't think the reasons are 
really very strong in that case.

Sadly, while those functions are _fairly_ high up, they aren't at the top, 
and we do have a lot of other functions that have huge stack footprints 
for totally bogus reasons. But the intentional ones are at least in the 
top ten.

But the kernel that Alan had problems with was different. The 
_intentional_ ones were way down in the noise.  do_sys_poll wasn't in the 
top ten, it was barely even in the top 50! (It was in fact #49, to be 
exact).

So look at the top ten in my kernel:

     1  ide_generic_init [vmlinux]:             1384
     2  idefloppy_ioctl [vmlinux]:              1208
     3  e1000_check_options [vmlinux]:  	1152
     4  do_sys_poll [vmlinux]:          	904
     5  ide_floppy_get_capacity [vmlinux]:      872
     6  do_select [vmlinux]:                    744
     7  early_printk [vmlinux]:         	720
     8  do_task_stat [vmlinux]:         	680
     9  mmc_ioctl [vmlinux]:                    648
    10  elf_kcore_store_hdr [vmlinux]:  	576

.. and in Alan's kernel:

     1  smp_call_function_mask [vmlinux]:       2736
     2  __build_sched_domains [vmlinux]:        2232
     3  setup_IO_APIC_irq [vmlinux]:            1616
     4  arch_setup_ht_irq [vmlinux]:            1600
     5  arch_setup_msi_irq [vmlinux]:   	1600
     6  __assign_irq_vector [vmlinux]:  	1592
     7  move_task_off_dead_cpu [vmlinux]:       1592
     8  tick_handle_oneshot_broadcast [vmlinux]:1544
     9  store_scaling_governor [vmlinux]:       1376
    10  cpuset_write_resmask [vmlinux]:		1360

That's a big difference. The top #1 in my kernel would just _barely_ be in 
the top 10 in Alan's kernel (he doesn't have it at all, because he didn't 
compile the drives I did into the kernel).

And the top three in my kernel are just because of crap code. That 
"e1000_check_options" thing is there just because it creates multiple 
"struct e1000_option" structures. I wrote an ugly but totally trivial 
patch to get it down to ~600 bytes, and it would be less if I had bothered 
to waste any more time on it.

The others are similar issues of "people just didn't think".

But look at the top ones in Alan's kernel. Not only are they _much_ bigger 
than the top ones in a sane kernel, they are _all_ due to cpumask_t, I 
think.

			Linus
