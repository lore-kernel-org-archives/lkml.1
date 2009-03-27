Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZC0Nl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZC0Nl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 09:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbZC0Nlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 09:41:45 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:47468 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbZC0Nlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 09:41:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cotc1WIJhClYVRX9SrVoMMO/LesMWo3O76aqDhp9KNia2Yp4NQGeBpr0dNJDJJFYle
         c+CGljY41OHMKU1E133KHznDhp8tThrKY0vsRGnoSd1zhcKT/mMphSQvxLLtJP3csxcn
         Z8qiOFPrvE38CS4gOBrwP2KChqop5VAuU0Sf4=
Date: Fri, 27 Mar 2009 14:41:37 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Maneesh Soni <maneesh@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] tracing/wakeup: move access to wakeup_cpu
	into spinlock
Message-ID: <20090327134136.GG5976@nowhere>
References: <20090326122806.GA4188@in.ibm.com> <20090326132739.GB5960@nowhere> <alpine.DEB.2.00.0903260949340.17665@gandalf.stny.rr.com> <alpine.DEB.2.00.0903261032070.17665@gandalf.stny.rr.com> <20090327084144.GA23318@in.ibm.com> <20090327124532.GA9963@in.ibm.com> <alpine.DEB.2.00.0903270904260.1917@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903270904260.1917@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 09:15:29AM -0400, Steven Rostedt wrote:
> 
> On Fri, 27 Mar 2009, Maneesh Soni wrote:
> > > 
> > > Hi Steven,
> > > 
> > > I still the oops with the patch,
> > > 
> > > BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> > > IP: [<ffffffff802d2259>] probe_wakeup_sched_switch+0xd2/0x1ac
> > > PGD 1d68e9067 PUD 1e6cdf067 PMD 0 
> > > Oops: 0000 [#1] SMP 
> > > last sysfs file: /sys/devices/pci0000:0c/0000:0c:00.0/irq
> > > CPU 5 
> > > Modules linked in: autofs4 hidp rfcomm l2cap bluetooth iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod sbs sbshc battery ac parport_pc lp parport sg sr_mod ide_cd_mod cdrom serio_raw acpi_memhotplug button tg3 libphy i2c_piix4 i2c_core pcspkr usb_storage uhci_hcd ohci_hcd ehci_hcd aacraid sd_mod scsi_mod ext3 jbd
> > > Pid: 6095, comm: cat Not tainted 2.6.29-tip-test #2 eserver xSeries 366-[88632RA]-
> > > RIP: 0010:[<ffffffff802d2259>]  [<ffffffff802d2259>] probe_wakeup_sched_switch+0xd2/0x1ac
> > > RSP: 0000:ffff8801e6d03ea0  EFLAGS: 00010046
> > > RAX: 0000000000000000 RBX: ffff8800281989a0 RCX: 0000000000000046
> > > RDX: ffff8800281989a0 RSI: ffffffff8020d56d RDI: ffffffff811de480
> > > RBP: ffff8801e6d03ed0 R08: 0000000000000000 R09: 0000000000000000



RBP is very close to RSP, so it's very likely that FRAME_POINTER is enabled.




> > > R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000046
> > > R13: ffff88022f232820 R14: 0000000000000000 R15: 0000000000000005
> > > FS:  00007f98b94cb6e0(0000) GS:ffff88002818b000(0000) knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > CR2: 0000000000000008 CR3: 0000000224595000 CR4: 00000000000006e0
> > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > > Process cat (pid: 6095, threadinfo ffff8801e6d02000, task ffff8801d6935040)
> > > Stack:
> > >  ffff8801d6935040 ffff880224981230 ffff88002819dd40 0000003b4ae00aa0
> > >  00007fffc14df830 ffff88002819dd40 ffff8801e6d03f70 ffffffff806f8264
> > >  0000000000000002 ffff8801e6d03f48 ffff8801d6935040 ffff88022f232820
> > > Call Trace:
> > >  [<ffffffff806f8264>] schedule+0xd99/0x10f9
> > >  [<ffffffff806fb61b>] ? trace_hardirqs_on_thunk+0x3a/0x3c
> > >  [<ffffffff8027d2cb>] ? delayed_work_timer_fn+0x0/0x38
> > >  [<ffffffff8020d56d>] retint_careful+0x12/0x2e
> > > Code: 2d ad de f2 00 75 77 48 63 05 ac de f2 00 48 8b 4d 00 45 89 f0 48 8b 3d 8e de f2 00 48 8b 71 08 48 8b 5c c7 28 48 8b 01 4c 89 e1 <48> 8b 50 08 e8 f6 9f ff ff 48 8b 3d 6f de f2 00 48 8b 75 d0 45 
> > > RIP  [<ffffffff802d2259>] probe_wakeup_sched_switch+0xd2/0x1ac
> > >  RSP <ffff8801e6d03ea0>
> > > CR2: 0000000000000008
> > > 
> > 
> > I could get a kdump in my next attempt. Let me know if you want me to upload the dump
> > somewhere. (700 MB compressed)
> > 
> > Some info from the dump using gdb & crash-utility.
> 
> Thanks, this is indeed helpful.
> 
> > 
> > (gdb) bt full
> > #0  0xffffffff802d2259 in probe_wakeup_sched_switch (rq=<value optimized out>, 
> >     prev=Cannot access memory at address 0xffff8801d05c7ea0
> > ) at kernel/trace/trace_sched_wakeup.c:157
> > 	data = (struct trace_array_cpu *) 0xffff8800281629a0
> > 	T0 = <value optimized out>
> > 	T1 = <value optimized out>
> > 	delta = <value optimized out>
> > 	flags = 70
> > 	pc = 0
> > Cannot access memory at address 0xffff8801d05c7ed8
> > (gdb) print wakeup_trace
> > $7 = (struct trace_array *) 0xffffffff811de480
> > (gdb) print *(struct trace_array *) 0xffffffff811de480
> > $8 = {buffer = 0xffff88022f090440, entries = 1441792, cpu = 0, 
> >   time_start = 437360893965, waiter = 0x0, data = {0xffff8800281119a0, 
> >     0xffff88002812c9a0, 0xffff8800281479a0, 0xffff8800281629a0, 
> >     0xffff88002817d9a0, 0xffff8800281989a0, 0xffff8800281b39a0, 
> >     0xffff8800281ce9a0, 0x0 <repeats 247 times>}}
> > (gdb) print tracer_enabled
> > $9 = 1
> > (gdb) print wakeup_cpu
> > $10 = 3
> > (gdb) info threads
> >   8 process 0  0xffffffff80217024 in mwait_idle ()
> >     at /home/maneesh/linux-2.6-tip/arch/x86/include/asm/processor.h:732
> >   7 process 0  0xffffffff80217024 in mwait_idle ()
> >     at /home/maneesh/linux-2.6-tip/arch/x86/include/asm/processor.h:732
> >   6 process 0  0xffffffff80217024 in mwait_idle ()
> >     at /home/maneesh/linux-2.6-tip/arch/x86/include/asm/processor.h:732
> >   5 process 0  0xffffffff80217024 in mwait_idle ()
> >     at /home/maneesh/linux-2.6-tip/arch/x86/include/asm/processor.h:732
> > * 4 process 5773  0xffffffff802d2259 in probe_wakeup_sched_switch (
> >     rq=<value optimized out>, prev=Cannot access memory at address 0xffff8801d05c7ea0
> > ) at kernel/trace/trace_sched_wakeup.c:157
> >   3 process 0  0xffffffff80217024 in mwait_idle ()
> >     at /home/maneesh/linux-2.6-tip/arch/x86/include/asm/processor.h:732
> >   2 process 0  0xffffffff80217024 in mwait_idle ()
> >     at /home/maneesh/linux-2.6-tip/arch/x86/include/asm/processor.h:732
> >   1 process 0  0xffffffff80217024 in mwait_idle ()
> >     at /home/maneesh/linux-2.6-tip/arch/x86/include/asm/processor.h:732
> > (gdb) info registers
> > rax            0x0	0
> > rbx            0xffff8800281629a0	-131940722792032
> > rcx            0x46	70
> > rdx            0xffff8800281629a0	-131940722792032
> > rsi            0xffffffff8020d56d	-2145331859
> > rdi            0xffffffff811de480	-2128747392
> > rbp            0xffff8801d05c7ed0	0xffff8801d05c7ed0
> > rsp            0xffff8801d05c7ea0	0xffff8801d05c7ea0
> > r8             0x0	0
> > r9             0x0	0
> > r10            0xffff8801d05c7eb0	-131933604643152
> > r11            0x1	1
> > r12            0x46	70
> > r13            0xffff88022f21d820	-131932014651360
> > r14            0x0	0
> > r15            0x3	3
> > rip            0xffffffff802d2259	0xffffffff802d2259 <probe_wakeup_sched_switch+210>
> > eflags         0x10046	[ PF ZF RF ]
> > cs             0x10	16
> > ss             0x0	0
> > ds             0x0	0
> > es             0x0	0
> > fs             0x0	0
> > gs             0x0	0
> > fctrl          0x0	0
> > fstat          0x0	0
> > ftag           0x0	0
> > fiseg          0x0	0
> > fioff          0x0	0
> > foseg          0x0	0
> > fooff          0x0	0
> > fop            0x0	0
> > mxcsr          0x0	[ ]
> > (gdb) 
> > ...
> > ...
> > 0xffffffff802d2208 <probe_wakeup_sched_switch+129>:	lock xadd %ax,0xf2debf(%rip)        # 0xffffffff812000d0 <wakeup_lock>
> > 0xffffffff802d2211 <probe_wakeup_sched_switch+138>:	cmp    %ah,%al
> > 0xffffffff802d2213 <probe_wakeup_sched_switch+140>:	je     0xffffffff802d221f <probe_wakeup_sched_switch+152>
> > 0xffffffff802d2215 <probe_wakeup_sched_switch+142>:	pause  
> > 0xffffffff802d2217 <probe_wakeup_sched_switch+144>:	mov    0xf2deb3(%rip),%al        # 0xffffffff812000d0 <wakeup_lock>
> > 0xffffffff802d221d <probe_wakeup_sched_switch+150>:	jmp    0xffffffff802d2211 <probe_wakeup_sched_switch+138>
> > 0xffffffff802d221f <probe_wakeup_sched_switch+152>:	cmpl   $0x0,0x9fb02a(%rip)        # 0xffffffff80ccd250 <tracer_enabled>
> > 0xffffffff802d2226 <probe_wakeup_sched_switch+159>:	je     0xffffffff802d22ac <probe_wakeup_sched_switch+293>
> > 0xffffffff802d222c <probe_wakeup_sched_switch+165>:	cmp    0xf2dead(%rip),%r13        # 0xffffffff812000e0 <wakeup_task>
> > 0xffffffff802d2233 <probe_wakeup_sched_switch+172>:	jne    0xffffffff802d22ac <probe_wakeup_sched_switch+293>
> > 0xffffffff802d2235 <probe_wakeup_sched_switch+174>:	movslq 0xf2deac(%rip),%rax        # 0xffffffff812000e8 <wakeup_cpu>
> 
> > 0xffffffff802d223c <probe_wakeup_sched_switch+181>:	mov    0x0(%rbp),%rcx
> 
> Here we load the frame pointer into %rcx.
> 
> > 0xffffffff802d2240 <probe_wakeup_sched_switch+185>:	mov    %r14d,%r8d
> > 0xffffffff802d2243 <probe_wakeup_sched_switch+188>:	mov    0xf2de8e(%rip),%rdi        # 0xffffffff812000d8 <wakeup_trace>
> 
> > 0xffffffff802d224a <probe_wakeup_sched_switch+195>:	mov    0x8(%rcx),%rsi
> 
> CALLER_ADDR1 gets loaded into %rsi
> 
> > 0xffffffff802d224e <probe_wakeup_sched_switch+199>:	mov    0x28(%rdi,%rax,8),%rbx
> 
> 
> > 0xffffffff802d2253 <probe_wakeup_sched_switch+204>:	mov    (%rcx),%rax
> 
> We move what should be the caller of the next frame into %rax but this 
> ends up being NULL?
> 
> > 0xffffffff802d2256 <probe_wakeup_sched_switch+207>:	mov    %r12,%rcx
> > 0xffffffff802d2259 <probe_wakeup_sched_switch+210>:	mov    0x8(%rax),%rdx   <<<<<<<<<===================== Here.
> 
> Hence, we crash.
> 
> This is really strange. CALLER_ADDR* are internal gcc 
> __builtin_return_address(*) functions.
> 
> Do you have CONFIG_FRAME_POINTER set?
> 
> Is this running in a virtual box or bare metal? (probably should not matter)
> 
> What version of gcc do you have?
> 
> Hmm, looking back at the call stack:
> 
> > >  [<ffffffff806f8264>] schedule+0xd99/0x10f9
> > >  [<ffffffff806fb61b>] ? trace_hardirqs_on_thunk+0x3a/0x3c
> > >  [<ffffffff8027d2cb>] ? delayed_work_timer_fn+0x0/0x38
> > >  [<ffffffff8020d56d>] retint_careful+0x12/0x2e
> 
> I wonder if we do not set up a stack frame properly. retint_careful is 
> called by assembly. I'll have a look at that


Aah, indeed.
May be should probe_kernel_address before saving
the addresses.


Frederic.

.
> 
> Thanks,
> 
> -- Steve
> 
> 
> 
> 
> > 0xffffffff802d225d <probe_wakeup_sched_switch+214>:	callq  0xffffffff802cc258 <trace_function>
> > 0xffffffff802d2262 <probe_wakeup_sched_switch+219>:	mov    0xf2de6f(%rip),%rdi        # 0xffffffff812000d8 <wakeup_trace>
> > 0xffffffff802d2269 <probe_wakeup_sched_switch+226>:	mov    -0x30(%rbp),%rsi
> > 0xffffffff802d226d <probe_wakeup_sched_switch+230>:	mov    %r14d,%r8d
> > 0xffffffff802d2270 <probe_wakeup_sched_switch+233>:	mov    %r13,%rdx
> > 0xffffffff802d2273 <probe_wakeup_sched_switch+236>:	mov    %r12,%rcx
> > 0xffffffff802d2276 <probe_wakeup_sched_switch+239>:	callq  0xffffffff802cd5b---Type <return> to continue, or q <return> to quit---
> > 2 <tracing_sched_switch_trace>
> > 
> > 
> > Some stack from rbp
> > 
> > crash> rd 0xffff8801d05c7ed0 50
> > ffff8801d05c7ed0:  ffff8801d05c7f70 ffffffff806f8264   p.\.....d.o.....
> > ffff8801d05c7ee0:  0000000000000002 ffff8801d05c7f48   ........H.\.....
> > ffff8801d05c7ef0:  ffff8801d043d040 ffff88022f21d820   @.C..... .!/....
> > ffff8801d05c7f00:  ffff8801d043d3e8 0000000300000000   ..C.............
> > ffff8801d05c7f10:  00007fff656c34d0 0000000000000000   .4le............
> > ffff8801d05c7f20:  0000000000000000 0000000000000000   ................
> > ffff8801d05c7f30:  ffffffff806fb61b 00000000000cf7bd   ..o.............
> > ffff8801d05c7f40:  0000000000000857 00000000008c3fc0   W........?......
> > ffff8801d05c7f50:  0000000000000000 00007fff656c34d0   .........4le....
> > ffff8801d05c7f60:  0000000000000000 0000000000000000   ................
> > ffff8801d05c7f70:  0000000000000000 ffffffff8020d56d   ........m. .....
> > ffff8801d05c7f80:  000000000000fe2e 0000000000000202   ................
> > ffff8801d05c7f90:  0000003b4b151a30 0000000000000003   0..K;...........
> > ffff8801d05c7fa0:  0000000000000004 00000000008c3fc0   .........?......
> > ffff8801d05c7fb0:  00000000008c30b0 0000000000000000   .0..............
> > ffff8801d05c7fc0:  00007f8e5a102de8 0000000000000000   .-.Z............
> > ffff8801d05c7fd0:  ffffffffffffffff 00000000004533f6   .........3E.....
> > ffff8801d05c7fe0:  0000000000000033 0000000000010206   3...............
> > ffff8801d05c7ff0:  00007fff656c3270 000000000000002b   p2le....+.......
> > ffff8801d05c8000:  0000000000000000 0000000000000000   ................
> > 
> > and some relvant text addresses
> > crash> sym ffffffff806f8264
> > ffffffff806f8264 (T) schedule+3481  include/trace/sched_event_types.h: 149
> > crash> sym ffffffff8020d56d
> > ffffffff8020d56d (t) retint_careful+18  include/linux/kdev_t.h: 52
> > crash> sym ffffffff806fb61b
> > ffffffff806fb61b (T) trace_hardirqs_on_thunk+58  include/linux/hrtimer.h: 199
> > crash> sym ffff880028167d40
> > 
> > It seems CALLER_ADDR is not correct? 
> > 
> > Thanks
> > Maneesh
> > 
> > 
> > -- 
> > Maneesh Soni
> > Linux Technology Center
> > IBM India Systems and Technology Lab,
> > Bangalore, India.
> > 

