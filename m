Return-Path: <linux-kernel-owner+w=401wt.eu-S933200AbZHDSTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933200AbZHDSTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933119AbZHDSTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:19:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933108AbZHDSTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:19:18 -0400
Date: Tue, 4 Aug 2009 14:19:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: John Reiser <jreiser@bitwagon.com>
cc: Steven Rostedt <srostedt@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, Tejun Heo <tj@kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ftrace: __start_mcount_loc should be .init.rodata
In-Reply-To: <4A6E4222.4080302@bitwagon.com>
Message-ID: <alpine.DEB.2.00.0908041418370.21700@gandalf.stny.rr.com>
References: <4A6DF0B6.7080402@bitwagon.com> <alpine.DEB.2.00.0907271641260.30108@gandalf.stny.rr.com> <4A6E4222.4080302@bitwagon.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 27 Jul 2009, John Reiser wrote:

> Steven Rostedt wrote:
> > 
> > 
> > On Mon, 27 Jul 2009, John Reiser wrote:
> > 
> >> __start_mcount_loc[] is unused after init, yet occupies RAM forever
> >> as part of .rodata.  152kiB is typical on a 64-bit architecture.  Instead,
> >> __start_mcount_loc should be in the interval [__init_begin, __init_end)
> >> so that the space is reclaimed after init.
> > 
> > Are you sure about that?
> 
> Data follows from a direct A<->B comparison.
> 
> My .config is same as Fedora Project, except for CONFIG_DEBUG_PAGEALLOC=y.
> ----- /var/log/messages
> ftrace: allocating 18889 entries ...
> 	    # 18889 * 8 = 151112 bytes (147kiB) for __start_mcount_loc[]
> 		on 64-bit architecture
> -----
> 
> With MCOUNT_REC() in original RO_DATA in include/asm-generic/vmlinux.lds.h:
> ===================================
> ----- /var/log/messages
> kernel: Freeing initrd memory: 3134k freed
> kernel: debug: unmapping init memory ffffffff8163d000..ffffffff81783000
> 	## The only message about unmapping;  length is 0x146000 or 1335296 bytes
> kernel: Write protecting the kernel read-only data: 1844k   ## 148kiB more than later
> -----
> 
> ----- System.map
> ffffffff8155c850 R __start_mcount_loc  # below unmapped range
> ffffffff81581698 R __stop_mcount_loc
> -----
> 
> ----- "readelf --sections vmlinux" has these "\.init" strings:
>   [12] __init_rodata     PROGBITS         ffffffff8155c850  0075c850  # _below_ unmapped range
>   [15] .init.rodata      PROGBITS         ffffffff815f01c0  007f01c0  # _below_ unmapped range
>   [25] .data.init_task   PROGBITS         ffffffff81612000  00a12000
>   [28] .init.text        PROGBITS         ffffffff8163d000  00a3d000  # low end of unmapped range
>   [29] .init.data        PROGBITS         ffffffff81675620  00a75620
>   [30] .init.setup       PROGBITS         ffffffff8175d980  00b5d980
>   [31] .initcall.init    PROGBITS         ffffffff8175eca0  00b5eca0
>   [33] .x86_cpu_dev.init PROGBITS         ffffffff8175fa00  00b5fa00
>   [39] .init.ramfs       PROGBITS         ffffffff81776000  00b76000  # still in unmapped range
>    01     .data .init.rodata .data.cacheline_aligned .data.read_mostly
> ## Note that .init.rodata is in segment 1, with .data
>    03     .data.init_task .data.page_aligned .smp_locks .init.text .init.data .init.setup .initcall.init .con_initcall.init .x86_cpu_dev.init .secu
> rity_initcall.init .parainstructions .altinstructions .altinstr_replacement .exit.text .init.ramfs .data.percpu .data_nosave .bss
> ## Note that .init.text and .init.data are in segment 3
> -----
> 
> 
> With MCOUNT_REC() moved to INIT_DATA as patched to include/asm-generic/vmlinux.lds.h:
> ==================================
> ----- /var/log/messages:
> kernel: Freeing initrd memory: 3134k freed
> kernel: debug: unmapping init memory ffffffff81619000..ffffffff81784000
> 	## The only message about unmapping;  length is 0x16b000 or 1486848 bytes
> kernel: Write protecting the kernel read-only data: 1696k   ## 148kiB less than before
> -----
> 
> ----- System.map
> ffffffff816a28d0 T __start_mcount_loc  # within unmapped range
> ffffffff816c7718 T __stop_mcount_loc
> -----
> 
> ----- "readelf --sections vmlinux" has these "\.init" strings:
>   [14] .init.rodata      PROGBITS         ffffffff815cb1c0  007cb1c0  # _below_ unmapped range
>   [24] .data.init_task   PROGBITS         ffffffff815ee000  009ee000
>   [27] .init.text        PROGBITS         ffffffff81619000  00a19000  # low end of unmapped range
>   [28] .init.data        PROGBITS         ffffffff81651620  00a51620
>   [29] .init.setup       PROGBITS         ffffffff8175e7c0  00b5e7c0
>   [30] .initcall.init    PROGBITS         ffffffff8175fae0  00b5fae0
>   [32] .x86_cpu_dev.init PROGBITS         ffffffff81760840  00b60840
>   [38] .init.ramfs       PROGBITS         ffffffff81777000  00b77000  # still in unmapped range
>    01     .data .init.rodata .data.cacheline_aligned .data.read_mostly
>    03     .data.init_task .data.page_aligned .smp_locks .init.text .init.data .init.setup .initcall.init .con_initcall.init .x86_cpu_dev.init .secu
> rity_initcall.init .parainstructions .altinstructions .altinstr_replacement .exit.text .init.ramfs .data.percpu .data_nosave .bss
> -----
> 
> Perusing the source:
> arch/x86/mm/init_64.c: free_init_pages() called from
>    ./arch/x86/kernel/alternative.c:		free_init_pages("SMP alternatives",
>    ./arch/x86/mm/init_64.c:	free_init_pages("unused kernel memory",
>    ./arch/x86/mm/init_64.c:	free_init_pages("initrd memory", start, end);
> All other calls also are architecture-specific and in other architectures,
> and also are similar to these.
> 
> 
> >> @@ -331,7 +332,6 @@
> >>  	/* __*init sections */						\
> >>  	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
> > 
> > Isn't this in __init_rodata? Doesn't this get removed too?
> 
> In my vmlinux it is _not_ removed; it is with .rodata, not .init.rodata
> (and not .init.data), and is outside (below) the removed range.

Thanks for this detailed explanation, I'll pull your patch in an run it 
through my tests, and then push it off.

-- Steve

