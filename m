Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663AbZDGKCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbZDGKCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 06:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZDGKCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 06:02:38 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49113 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293AbZDGKCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 06:02:37 -0400
Date: Tue, 7 Apr 2009 15:32:25 +0530
From: Maneesh Soni <maneesh@in.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] tracing/wakeup: move access to wakeup_cpu
	into spinlock
Message-ID: <20090407100225.GC4138@in.ibm.com>
Reply-To: maneesh@in.ibm.com
References: <20090326122806.GA4188@in.ibm.com> <20090326132739.GB5960@nowhere> <alpine.DEB.2.00.0903260949340.17665@gandalf.stny.rr.com> <alpine.DEB.2.00.0903261032070.17665@gandalf.stny.rr.com> <20090327084144.GA23318@in.ibm.com> <20090327124532.GA9963@in.ibm.com> <alpine.DEB.2.00.0904011939170.30963@gandalf.stny.rr.com> <20090402060249.GH4620@in.ibm.com> <alpine.DEB.2.00.0904020915280.30963@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904020915280.30963@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 09:18:35AM -0400, Steven Rostedt wrote:
[..]
> 
> > 
> > BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> > IP: [<ffffffff80292349>] probe_wakeup_sched_switch+0x11f/0x1e8
> > PGD 0 
> > Oops: 0000 [#1] SMP 
> > last sysfs file: /sys/devices/pci0000:01/0000:01:01.1/irq
> > CPU 3 
> > Modules linked in: autofs4 hidp rfcomm l2cap bluetooth iptable_filter ip_tables ip6t_REJECT xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod sbs sbshc battery ac parport_pc lp parport sg sr_mod ide_cd_mod cdrom serio_raw acpi_memhotplug button tg3 libphy i2c_piix4 i2c_core pcspkr usb_storage uhci_hcd ohci_hcd ehci_hcd aacraid sd_mod scsi_mod ext3 jbd
> > Pid: 16589, comm: sshd Not tainted 2.6.29-tip-test #3 eserver xSeries 366-[88632RA]-
> > RIP: 0010:[<ffffffff80292349>]  [<ffffffff80292349>] probe_wakeup_sched_switch+0x11f/0x1e8
> > RSP: 0018:ffff8801da1b5e90  EFLAGS: 00010046
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000046
> > RDX: 0000000000000000 RSI: ffffffff8020bf85 RDI: ffffffff80d6f460
> > RBP: ffff8801da1b5ed0 R08: 0000000000000000 R09: 0000000100000003
> > R10: ffff8801da1b5ed0 R11: ffff88022d152078 R12: 0000000000000046
> > R13: ffff88022f352040 R14: 0000000000000000 R15: 0000000000000003
> > FS:  00007f748364d710(0000) GS:ffff880028155000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > CR2: 0000000000000008 CR3: 00000001cfd8e000 CR4: 00000000000006e0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: ffffffff80d91980 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> > Process sshd (pid: 16589, threadinfo ffff8801da1b4000, task ffff88022d152040)
> > Stack:
> >  ffff88022d152040 ffff88022d152040 ffff880028162960 ffff880224d79810
> >  ffff880028167d00 00007fff8b6c7190 0000000000000005 00007fff8b6c7190
> >  ffff8801da1b5f70 ffffffff805210b7 ffff8802295b8558 0000000000000001
> > Call Trace:
> >  [<ffffffff805210b7>] schedule+0x82f/0xb39
> >  [<ffffffff802d95a4>] ? sys_write+0x72/0x8d
> >  [<ffffffff8020bf85>] sysret_careful+0xd/0x10
> 
> This is what I was afraid of. Your other crashes were intret_careful, 
> now we are hitting sysret_careful. I'm going to pull out all references to 
> CALLER_ADDR2. The above patch was simply me manually putting in a call 
> frame in intret_careful. But this is unreliable, any caller from an 
> interrupt (or syscall) to schedule will cause an error. I'm not sure we 
> need the CALLER_ADDR2 anyway.
> 

I had also tested with passing 0 instead of CALLER_ADDR2 and didn't see any crash.

Thanks
Maneesh

-- 
Maneesh Soni
Linux Technology Center
IBM India Systems and Technology Lab,
Bangalore, India.
