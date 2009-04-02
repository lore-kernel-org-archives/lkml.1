Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbZDBNSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbZDBNSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 09:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZDBNSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 09:18:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbZDBNSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 09:18:37 -0400
Date: Thu, 2 Apr 2009 09:18:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Maneesh Soni <maneesh@in.ibm.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] tracing/wakeup: move access to wakeup_cpu into
 spinlock
In-Reply-To: <20090402060249.GH4620@in.ibm.com>
Message-ID: <alpine.DEB.2.00.0904020915280.30963@gandalf.stny.rr.com>
References: <20090326122806.GA4188@in.ibm.com> <20090326132739.GB5960@nowhere> <alpine.DEB.2.00.0903260949340.17665@gandalf.stny.rr.com> <alpine.DEB.2.00.0903261032070.17665@gandalf.stny.rr.com> <20090327084144.GA23318@in.ibm.com> <20090327124532.GA9963@in.ibm.com>
 <alpine.DEB.2.00.0904011939170.30963@gandalf.stny.rr.com> <20090402060249.GH4620@in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2 Apr 2009, Maneesh Soni wrote:

> On Wed, Apr 01, 2009 at 07:42:58PM -0400, Steven Rostedt wrote:
> 
> ....
> 
> > 
> > 
> > 
> > Hi Maneesh,
> > 
> > Could you try this patch and see if it keeps your system from crashing?
> > 
> > Thanks,
> > 
> > -- Steve
> > 
> > diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> > index a331ec3..dbf3f8f 100644
> > --- a/arch/x86/kernel/entry_64.S
> > +++ b/arch/x86/kernel/entry_64.S
> > @@ -917,10 +917,15 @@ retint_careful:
> >  	TRACE_IRQS_ON
> >  	ENABLE_INTERRUPTS(CLBR_NONE)
> >  	pushq %rdi
> > -	CFI_ADJUST_CFA_OFFSET	8
> > +	pushq %rbp
> > +	call  1f
> > +1:	mov  %rsp, %rbp
> > +	CFI_ADJUST_CFA_OFFSET	24
> >  	call  schedule
> > +	addq $8, %rsp /* skip call */
> > +	popq %rbp
> >  	popq %rdi
> > -	CFI_ADJUST_CFA_OFFSET	-8
> > +	CFI_ADJUST_CFA_OFFSET	-24
> >  	GET_THREAD_INFO(%rcx)
> >  	DISABLE_INTERRUPTS(CLBR_NONE)
> >  	TRACE_IRQS_OFF
> 
> 
> 
> Hi Steve
> 
> I tried the above patch but similar oops again

Thanks, that helps a lot.

> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> IP: [<ffffffff80292349>] probe_wakeup_sched_switch+0x11f/0x1e8
> PGD 0 
> Oops: 0000 [#1] SMP 
> last sysfs file: /sys/devices/pci0000:01/0000:01:01.1/irq
> CPU 3 
> Modules linked in: autofs4 hidp rfcomm l2cap bluetooth iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod sbs sbshc battery ac parport_pc lp parport sg sr_mod ide_cd_mod cdrom serio_raw acpi_memhotplug button tg3 libphy i2c_piix4 i2c_core pcspkr usb_storage uhci_hcd ohci_hcd ehci_hcd aacraid sd_mod scsi_mod ext3 jbd
> Pid: 16589, comm: sshd Not tainted 2.6.29-tip-test #3 eserver xSeries 366-[88632RA]-
> RIP: 0010:[<ffffffff80292349>]  [<ffffffff80292349>] probe_wakeup_sched_switch+0x11f/0x1e8
> RSP: 0018:ffff8801da1b5e90  EFLAGS: 00010046
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000046
> RDX: 0000000000000000 RSI: ffffffff8020bf85 RDI: ffffffff80d6f460
> RBP: ffff8801da1b5ed0 R08: 0000000000000000 R09: 0000000100000003
> R10: ffff8801da1b5ed0 R11: ffff88022d152078 R12: 0000000000000046
> R13: ffff88022f352040 R14: 0000000000000000 R15: 0000000000000003
> FS:  00007f748364d710(0000) GS:ffff880028155000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000008 CR3: 00000001cfd8e000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: ffffffff80d91980 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> Process sshd (pid: 16589, threadinfo ffff8801da1b4000, task ffff88022d152040)
> Stack:
>  ffff88022d152040 ffff88022d152040 ffff880028162960 ffff880224d79810
>  ffff880028167d00 00007fff8b6c7190 0000000000000005 00007fff8b6c7190
>  ffff8801da1b5f70 ffffffff805210b7 ffff8802295b8558 0000000000000001
> Call Trace:
>  [<ffffffff805210b7>] schedule+0x82f/0xb39
>  [<ffffffff802d95a4>] ? sys_write+0x72/0x8d
>  [<ffffffff8020bf85>] sysret_careful+0xd/0x10

This is what I was afraid of. Your other crashes were intret_careful, 
now we are hitting sysret_careful. I'm going to pull out all references to 
CALLER_ADDR2. The above patch was simply me manually putting in a call 
frame in intret_careful. But this is unreliable, any caller from an 
interrupt (or syscall) to schedule will cause an error. I'm not sure we 
need the CALLER_ADDR2 anyway.

Thanks!

-- Steve
