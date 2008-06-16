Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbYFPNLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbYFPNLu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYFPNLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:11:41 -0400
Received: from in.cluded.net ([195.159.98.120]:52507 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbYFPNLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:11:41 -0400
X-OS: [Linux] 2.6.8 and newer (?)
Message-ID: <4856671B.1020304@uw.no>
Date: Mon, 16 Jun 2008 15:14:03 +0200
From: "Daniel K." <dk@uw.no>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, menage@google.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG: NULL pointer dereference] cgroups and RT scheduling	interact
 badly.
References: <485445AE.2010602@uw.no> <1213612447.16944.99.camel@twins>
In-Reply-To: <1213612447.16944.99.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Does the below work for you?
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -7784,7 +7784,6 @@ static void init_tg_rt_entry(struct task
>  	else
>  		rt_se->rt_rq = parent->my_q;
>  
> -	rt_se->rt_rq = &rq->rt;
>  	rt_se->my_q = rt_rq;
>  	rt_se->parent = parent;
>  	INIT_LIST_HEAD(&rt_se->run_list);

Although this patch seems to be correct, this is what shows up on my
netconsole, when applying it -- with an offset, do you have other fixes
applied as well?


Daniel K.

> [  129.390189] ------------[ cut here ]------------
> [  129.390370] Kernel BUG at ffffffff8022acea [verbose debug info unavailable]
> [  129.390489] invalid opcode: 0000 [1] SMP 
> [  129.390672] CPU 3 
> [  129.390811] Modules linked in: netconsole configfs ipmi_msghandler kvm_amd kvm ipv6 iptable_filter ip_tables x_tables af_packet usbhid hid loop evdev ehci_hcd tg3 ohci_hcd i2c_nforce2 forcedeth shpchp pci_hotplug button pcspkr k8temp thermal usbcore processor i2c_core sd_mod sg fan thermal_sys
> [  129.393446] Pid: 3375, comm: burnP6 Not tainted 2.6.26-rc6 #3
> [  129.393560] RIP: 0010:[<ffffffff8022acea>]  [<ffffffff8022acea>] pick_next_task_rt+0x5a/0x90
> [  129.393784] RSP: 0000:ffff81021eda5ea0  EFLAGS: 00010002
> [  129.393896] RAX: 0000000000000064 RBX: ffffffff8049ec00 RCX: ffff810221495000
> [  129.393920] RDX: ffff81022113f9c0 RSI: 0000000000000003 RDI: ffff810001056600
> [  129.393920] RBP: ffff81021eda5ea0 R08: ffff810001050660 R09: 0000000000001280
> [  129.393920] R10: 0000000000000001 R11: 00000000ffffffff R12: 0000000000000000
> [  129.393920] R13: ffff810001056600 R14: 0000000000000003 R15: 0000000000000000
> [  129.393920] FS:  00007f36635536e0(0000) GS:ffff810223022980(0000) knlGS:0000000000000000
> [  129.393920] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
> [  129.393920] CR2: 0000000008049130 CR3: 0000000221d08000 CR4: 00000000000006e0
> [  129.393920] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  129.393920] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  129.393920] Process burnP6 (pid: 3375, threadinfo ffff81021eda4000, task ffff810220ded2e0)
> [  129.393920] Stack:  ffff81021eda5f70 ffffffff8048c302 0000000000000000 ffff81021ec1da00
> [  129.393920]  ffffffff80689600 ffffffff80689600 ffffffff806858a0 ffffffff80689600
> [  129.393920]  ffff810220ded558 0000000000000000 0000000000000292 ffff810220ded2e0
> [  129.393920] Call Trace:
> [  129.393920]  [<ffffffff8048c302>] thread_return+0x101/0x4af
> [  129.393921]  [<ffffffff80343761>] ? __up_read+0x21/0xb0
> [  129.393921]  [<ffffffff8020bdee>] retint_careful+0x1c/0x42
> [  129.393921] 
> [  129.393921] 
> [  129.393921] Code: 48 c1 e0 04 48 8b 14 08 48 85 d2 74 49 48 8b 4a 40 48 85 c9 74 1b 48 8b 01 48 85 c0 75 d4 48 0f bc 41 08 83 c0 40 83 f8 63 7e d0 <0f> 0b eb fe 66 90 48 8b 87 f8 07 00 00 48 8d 8a 40 ff ff ff 48 
> [  129.400164] RIP  [<ffffffff8022acea>] pick_next_task_rt+0x5a/0x90
> [  129.400164]  RSP <ffff81021eda5ea0>
