Return-Path: <linux-kernel-owner+w=401wt.eu-S1757928AbYFQMrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928AbYFQMrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbYFQMrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:47:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:60268 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118AbYFQMrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:47:12 -0400
Subject: Re: [BUG: NULL pointer dereference] cgroups
	and	RT	scheduling	interact badly.
From: Peter Zijlstra <peterz@infradead.org>
To: "Daniel K." <dk@uw.no>
Cc: mingo@elte.hu, menage@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <4857AD38.2090601@uw.no>
References: <485445AE.2010602@uw.no> <1213612447.16944.99.camel@twins>
	 <4856671B.1020304@uw.no>  <1213624312.16944.104.camel@twins>
	 <1213627148.16944.106.camel@twins>  <485682B0.8010805@uw.no>
	 <1213629536.16944.109.camel@twins> <1213692557.16944.153.camel@twins>
	 <4857AD38.2090601@uw.no>
Content-Type: text/plain
Date: Tue, 17 Jun 2008 14:46:55 +0200
Message-Id: <1213706815.16944.180.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-17 at 14:25 +0200, Daniel K. wrote:
> Peter Zijlstra wrote:
> > How's this [patch] work for you? (includes the previuos patchlet too)
> 
> Thanks,
> 
> this patch fixed the obvious problem, namely
> 
> # echo $$ > /dev/cgroup/burn/oops/tasks
> # schedtool -R -p 1 -e burnP6 &
> 
> now works again. However, the last step below
> 
> # echo $$ > /dev/cgroup/tasks
> # burnP6 &
> [1] 3414
> # echo 3414 > /dev/cgroup/burn/oops/tasks
> # schedtool -R -p 1 3414
> 
> gives this new and shiny Oops instead.
>
> > [  189.274997] BUG: unable to handle kernel NULL pointer dereference at 0000000000000064
> > [  189.274997] IP: [<ffffffff8022e165>] __enqueue_rt_entity+0x55/0x1d0
> > [  189.274997] PGD 21e451067 PUD 220d19067 PMD 0 
> > [  189.274997] Oops: 0002 [1] SMP 
> > [  189.274997] CPU 1 
> > [  189.274997] Modules linked in: netconsole configfs ipmi_msghandler kvm_amd kvm ipv6 iptable_filter ip_tables x_tables af_packet loop evdev usbhid hid i2c_nforce2 button pcspkr i2c_core k8temp shpchp pci_hotplug tg3 sd_mod forcedeth sg ohci_hcd ehci_hcd usbcore thermal processor fan
> > [  189.274997] Pid: 3415, comm: schedtool Not tainted 2.6.26-rc6 #3
> > [  189.274997] RIP: 0010:[<ffffffff8022e165>]  [<ffffffff8022e165>] __enqueue_rt_entity+0x55/0x1d0
> > [  189.274997] RSP: 0018:ffff81021e477e48  EFLAGS: 00010012
> > [  189.274997] RAX: ffff810001056d08 RBX: ffff810220dbc060 RCX: ffff810220dbbfc0
> > [  189.274997] RDX: 0000000000000064 RSI: ffff81022120ec60 RDI: ffff810220dbc060
> > [  189.274997] RBP: ffff81021e477e58 R08: 44b0000000000000 R09: 0000000000000001
> > [  189.274997] R10: 0000000000000000 R11: 0000000000000206 R12: ffff8100010566b8
> > [  189.274997] R13: 0000000000000001 R14: 0000000000000001 R15: ffff81021e477f38
> > [  189.274997] FS:  00007f71ec2146e0(0000) GS:ffff810223022580(0000) knlGS:0000000000000000
> > [  189.274997] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [  189.274997] CR2: 0000000000000064 CR3: 000000021e439000 CR4: 00000000000006e0
> > [  189.274997] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [  189.274997] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [  189.274997] Process schedtool (pid: 3415, threadinfo ffff81021e476000, task ffff810221daf920)
> > [  189.274997] Stack:  ffff810220dbc060 ffff81022120ec60 ffff81021e477e78 ffffffff8022e34e
> > [  189.274997]  0000000000000001 ffff81022120ec60 ffff81021e477e98 ffffffff802299e3
> > [  189.274997]  ffff81021e477f38 ffff8100010565c0 ffff81021e477eb8 ffffffff80229a60
> > [  189.274997] Call Trace:
> > [  189.274997]  [<ffffffff8022e34e>] enqueue_rt_entity+0x1e/0x30
> > [  189.274997]  [<ffffffff802299e3>] enqueue_task+0x13/0x30
> > [  189.274998]  [<ffffffff80229a60>] activate_task+0x30/0x50
> > [  189.274998]  [<ffffffff80232ebf>] sched_setscheduler+0x28f/0x3b0
> > [  189.274998]  [<ffffffff8028b368>] ? do_munmap+0x278/0x2d0
> > [  189.274998]  [<ffffffff8023305d>] do_sched_setscheduler+0x7d/0x90
> > [  189.274998]  [<ffffffff802330a4>] sys_sched_setscheduler+0x14/0x20
> > [  189.274998]  [<ffffffff8020b77a>] system_call_after_swapgs+0x8a/0x8f
> > [  189.274998] 
> > [  189.274998] 
> > [  189.274998] Code: 85 c9 0f 84 76 01 00 00 8b 81 58 06 00 00 48 98 48 8d 8b 60 ff ff ff 48 c1 e0 04 4a 8d 44 20 10 48 8b 50 08 48 89 03 48 89 58 08 <48> 89 1a 48 89 53 08 48 8b 53 40 48 8d 82 58 06 00 00 48 85 d2 
> > [  189.274998] RIP  [<ffffffff8022e165>] __enqueue_rt_entity+0x55/0x1d0
> > [  189.274998]  RSP <ffff81021e477e48>
> > [  189.274998] CR2: 0000000000000064
> 
> If I switch the order of calling schedtool and assigning the task to a
> cgroup, then it works OK.
> 
> # echo $$ > /dev/cgroup/tasks
> # burnP6 &
> [1] 3414
> # schedtool -R -p 1 3414
> # echo 3414 > /dev/cgroup/burn/oops/tasks
> 
> Note the distinct lack of an Oops here.
> 
> But all is not well. If I now use schedtool (obvoiusly redundantly)
> 
> # schedtool -R -p 1 3414
> 
> I get a new Oops, which looks essentially tha same as the one above.

Fun, I could not reproduce with chrt, but I can with schedtool.

Thanks for testing,. and I guess I'm back to poking at it.. :-)

