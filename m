Return-Path: <linux-kernel-owner+w=401wt.eu-S1762122AbZATNps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122AbZATNps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:45:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbZATNpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:45:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:49982 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761964AbZATNpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:45:33 -0500
Subject: Re: [BUG] kernel BUG at arch/x86/kernel/tlb_32.c:130!
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Nick Piggin <npiggin@suse.de>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <20090120082946.GC31473@elte.hu>
References: <49756F44.6040801@cn.fujitsu.com>
	 <20090120075440.GA29426@elte.hu> <20090120081759.GA30394@elte.hu>
	 <49758937.5070300@cn.fujitsu.com>  <20090120082946.GC31473@elte.hu>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 19:14:47 +0530
Message-Id: <1232459087.3088.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-20 at 09:29 +0100, Ingo Molnar wrote:
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > Ingo Molnar wrote:
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > >> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> > >>
> > >>> I was using mmotm 2009-01-16-16-18, and I ran into this BUG,
> > >>> the line is:
> > >>> 	BUG_ON(cpumask_empty(cpumask));
> > >>>
> > >>> I suspect it is caused by:
> > >>>
> > >>> commit 4595f9620cda8a1e973588e743cf5f8436dd20c6
> > >>> Author: Rusty Russell <rusty@rustcorp.com.au>
> > >>> Date:   Sat Jan 10 21:58:09 2009 -0800
> > >>>
> > >>>     x86: change flush_tlb_others to take a const struct cpumask
> > >>>
> > >>>     Impact: reduce stack usage, use new cpumask API.
> > >> Jaswinder reported a similar crash.
> > >>
> > >> Mike, Rusty, what's going on with this commit? Why does this code:
> > >>
> > >> +       if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
> > >> +               flush_tlb_others(&mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);
> > >>
> > >> Assume that mm->cpu_vm_mask wont change? TLB flushes go async and the 
> > >> MM's schedulability is not locked during that. I.e. mm->cpu_vm_mask can 
> > >> change under you while the TLB flush IPIs are flying around - while when 
> > >> the cpumask was passed on-stack this wouldnt happen.
> > > 
> > > okay, a testsystem of mine just triggered this crash too.
> > > 
> > > Li Zefan, Jaswinder, does the patch below fix it for you?
> > > 
> > 
> > I'll test it, but I have to run for several hours to confirm it, since 
> > the bug is not easy to trigger. :)
> 
> yes. It triggered on an old 32-bit dual-socket HyperThreading system for 
> me and that is because HyperThreading is very good at triggering narrow 
> SMP races. (which this one certainly is)
> 
> (I'd expect Nehalem to trigger this TLB flushing race more easily too, 
> where HyperThreading made a comeback.)
> 

I also got these crashes on Intel HT machine.

Earlier crash was:
Kernel failure message 1:
------------[ cut here ]------------
kernel BUG at arch/x86/kernel/tlb_32.c:130!
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/class/i2c-adapter/i2c-0/0-002e/fan1_input
Modules linked in:

Pid: 29533, comm: sh Not tainted (2.6.29-rc2-tip #10)         
EIP: 0060:[<c0110e7b>] EFLAGS: 00010246 CPU: 1
EIP is at native_flush_tlb_others+0x11/0x9a
EAX: f73458d4 EBX: f73458d4 ECX: ffffffff EDX: f7345780
ESI: f7345780 EDI: ffffffff EBP: e95fbcd4 ESP: e95fbcc8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process sh (pid: 29533, ti=e95fa000 task=f126d4c0 task.ti=e95fa000)
Stack:
 f7345780 f73458d4 00288000 e95fbce4 c0110fe3 c170d8dc 37e6b025 e95fbd44
 c01571ba c050e8dc 00000000 f3a59668 e95fbd5c 00000001 ffffffb9 00000000
 003c9000 f7379000 f7379000 c170d8ec f73457c4 00000000 fffffffa e96b4a1c
Call Trace:
 [<c0110fe3>] ? flush_tlb_mm+0x63/0x7c
 [<c01571ba>] ? unmap_vmas+0x3ce/0x500
 [<c015a485>] ? exit_mmap+0x91/0x110
 [<c011fed3>] ? mmput+0x21/0x85
 [<c0169fb3>] ? flush_old_exec+0x460/0x6fc
 [<c016642d>] ? vfs_read+0xed/0x101
 [<c016a2bc>] ? kernel_read+0x34/0x46
 [<c018fd59>] ? load_elf_binary+0x330/0x119f
 [<c01313b7>] ? autoremove_wake_function+0x0/0x33
 [<c016480b>] ? __dentry_open+0x14f/0x21d
 [<c016a467>] ? open_exec+0xbb/0xef
 [<c016642d>] ? vfs_read+0xed/0x101
 [<c0169983>] ? search_binary_handler+0xba/0x235
 [<c018fa29>] ? load_elf_binary+0x0/0x119f
 [<c018e845>] ? load_script+0x17d/0x190
 [<c0158063>] ? __get_user_pages+0x249/0x2ac
 [<c01580ef>] ? get_user_pages+0x29/0x30
 [<c0169628>] ? get_arg_page+0x2d/0x80
 [<c0169983>] ? search_binary_handler+0xba/0x235
 [<c018e6c8>] ? load_script+0x0/0x190
 [<c016aa0e>] ? do_execve+0x1ca/0x262
 [<c010152c>] ? sys_execve+0x29/0x55
 [<c0102df1>] ? sysenter_do_call+0x12/0x25
 [<c03a0000>] ? tpacket_rcv+0x1aa/0x439
Code: 00 e0 ff ff ff 48 14 b8 80 1d 51 c0 64 8b 15 80 e8 50 c0 ff 44 10 20 5b 5d c3 55 89 e5 57 89 cf 56 89 d6 53 89 c3 f6 00 03 75 04 <0f> 0b eb fe 85 d2 75 04 0f 0b eb fe b8 0c 05 52 c0 e8 06 e6 29 
EIP: [<c0110e7b>] native_flush_tlb_others+0x11/0x9a SS:ESP 0068:e95fbcc8
---[ end trace 340f988a03f08828 ]---


When I was compiling latest -tip kernel on HT machine I got another crash which totally freezes my machine:

Jan 20 18:57:56 ht ntpd[1718]: synchronized to 61.221.44.166, stratum 2
Jan 20 18:57:56 ht ntpd[1718]: time reset -5.950733 s
Jan 20 18:57:56 ht ntpd[1718]: kernel time sync status change 0001
Jan 20 18:59:41 ht kernel: ------------[ cut here ]------------
Jan 20 18:59:41 ht kernel: kernel BUG at arch/x86/kernel/tlb_32.c:130!
Jan 20 18:59:41 ht kernel: invalid opcode: 0000 [#1] PREEMPT SMP 
Jan 20 18:59:41 ht kernel: last sysfs file: /sys/class/net/eth0/statistics/collisions
Jan 20 18:59:41 ht kernel: Modules linked in:
Jan 20 18:59:41 ht kernel:
Jan 20 18:59:41 ht kernel: Pid: 287, comm: kswapd0 Not tainted (2.6.29-rc2-tip #10)         
Jan 20 18:59:41 ht kernel: EIP: 0060:[<c0110e7b>] EFLAGS: 00010246 CPU: 1
Jan 20 18:59:41 ht kernel: EIP is at native_flush_tlb_others+0x11/0x9a
Jan 20 18:59:41 ht kernel: EAX: e9a622d4 EBX: e9a622d4 ECX: b75f4000 EDX: e9a62180
Jan 20 18:59:41 ht kernel: ESI: e9a62180 EDI: b75f4000 EBP: f6e0fdf4 ESP: f6e0fde8
Jan 20 18:59:41 ht kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Jan 20 18:59:41 ht kernel: Process kswapd0 (pid: 287, ti=f6e0e000 task=f6deb3c0 task.ti=f6e0e000)
Jan 20 18:59:41 ht kernel: Stack:
Jan 20 18:59:41 ht kernel: e9a62180 e9a622d4 b75f4000 f6e0fe08 c0110f66 ffffffff c2891710 e9a62180
Jan 20 18:59:41 ht kernel: f6e0fe14 c0118726 b75f4000 f6e0fe34 c015cc37 f6e0fe48 c100e240 e9a621c4
Jan 20 18:59:41 ht kernel: c100e240 c2891710 00000000 f6e0fe58 c015d6b8 00000000 c280f810 c280f814
Jan 20 18:59:41 ht kernel: Call Trace:
Jan 20 18:59:41 ht kernel: [<c0110f66>] ? flush_tlb_page+0x62/0x7c
Jan 20 18:59:41 ht kernel: [<c0118726>] ? ptep_clear_flush_young+0x1b/0x20
Jan 20 18:59:41 ht kernel: [<c015cc37>] ? page_referenced_one+0x63/0xad
Jan 20 18:59:41 ht kernel: [<c015d6b8>] ? page_referenced+0x78/0xe0
Jan 20 18:59:41 ht kernel: [<c014fde8>] ? shrink_active_list+0x116/0x2a6
Jan 20 18:59:41 ht kernel: [<c015cb01>] ? page_unlock_anon_vma+0x8/0x1f
Jan 20 18:59:41 ht kernel: [<c015d6de>] ? page_referenced+0x9e/0xe0
Jan 20 18:59:41 ht kernel: [<c014ead4>] ? __pagevec_release+0x18/0x21
Jan 20 18:59:41 ht kernel: [<c014ff70>] ? shrink_active_list+0x29e/0x2a6
Jan 20 18:59:41 ht kernel: [<c0150ccb>] ? shrink_zone+0x277/0x28c
Jan 20 18:59:41 ht kernel: [<c01511a2>] ? kswapd+0x375/0x4dc
Jan 20 18:59:41 ht kernel: [<c014f374>] ? isolate_pages_global+0x0/0x1af
Jan 20 18:59:41 ht kernel: [<c01313b7>] ? autoremove_wake_function+0x0/0x33
Jan 20 18:59:41 ht kernel: [<c0150e2d>] ? kswapd+0x0/0x4dc
Jan 20 18:59:41 ht kernel: [<c0131125>] ? kthread+0x3b/0x61
Jan 20 18:59:41 ht kernel: [<c01310ea>] ? kthread+0x0/0x61
Jan 20 18:59:41 ht kernel: [<c01035fb>] ? kernel_thread_helper+0x7/0x10
Jan 20 18:59:41 ht kernel: Code: 00 e0 ff ff ff 48 14 b8 80 1d 51 c0 64 8b 15 80 e8 50 c0 ff 44 10 20 5b 5d c3 55 89 e5 57 89 cf 56 89 d6 53 89 c3 f6 00 03 75 04 <0f> 0b eb fe 85 d2 75 04 0f 0b eb fe b8 0c 05 52 c0 e8 06 e6 29 
Jan 20 18:59:41 ht kernel: EIP: [<c0110e7b>] native_flush_tlb_others+0x11/0x9a SS:ESP 0068:f6e0fde8
Jan 20 18:59:41 ht kernel: ---[ end trace 52e670669c1ba1a2 ]---
Jan 20 18:59:41 ht kernel: note: kswapd0[287] exited with preempt_count 4

Now I again started compilation and going to test this patch.

If I got any further crashes I will let you know :-)

Thanks

--
JSR



