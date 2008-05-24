Return-Path: <linux-kernel-owner+w=401wt.eu-S1759780AbYEXRlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780AbYEXRlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 13:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbYEXRl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 13:41:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617AbYEXRl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 13:41:26 -0400
Date: Sat, 24 May 2008 10:40:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch, -git] pcie hotplug bootup crash fix
Message-Id: <20080524104024.a33116a3.akpm@linux-foundation.org>
In-Reply-To: <20080524165828.GA29993@elte.hu>
References: <20080524165828.GA29993@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008 18:58:28 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> -tip tree testing found that the the PCI hotplug ISR routine crashes 
> with a NULL pointer dereference under certain circumstances.
> 
> The situation under which it occurs is hw and timing related: it appears 
> to happen on a system that has PCI hotplug hardware but with no active 
> hotplug cards, and another interrupt in the same (shared) IRQ line 
> arrives too early, before the hotplug-slot entry has been set up - as 
> triggered by CONFIG_DEBUG_SHIRQ=y:
> 
> pciehp: HPC vendor_id 8086 device_id 27d0 ss_vid 0 ss_did 0
> pciehp: pciehp_find_slot: slot (device=0x0) not found
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000070
> IP: [<ffffffff80494a8b>] pciehp_handle_presence_change+0x7e/0x113
> PGD 0
> Oops: 0000 [1]
> CPU 0
> Modules linked in:
> Pid: 1, comm: swapper Tainted: G        W 2.6.26-rc3-sched-devel.git-00001-g2b99b26-dirty #170
> RIP: 0010:[<ffffffff80494a8b>]  [<ffffffff80494a8b>] pciehp_handle_presence_change+0x7e/0x113
> RSP: 0000:ffff81003f83fbb0  EFLAGS: 00010046
> RAX: 0000000000000039 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000046
> RBP: ffff81003f83fbd0 R08: 0000000000000001 R09: ffffffff80245103
> R10: 0000000000000020 R11: 0000000000000000 R12: ffff81003ea53a30
> R13: 0000000000000000 R14: 0000000000000011 R15: ffffffff80495926
> FS:  0000000000000000(0000) GS:ffffffff80be7400(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000070 CR3: 0000000000201000 CR4: 00000000000006a0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff81003f83e000, task ffff81003f840000)
> Stack:  0000000000000008 ffff81003f83fbf6 ffff81003ea53a30 0000000000000008
>  ffff81003f83fc10 ffffffff80495ab4 0000000000000011 0000000000000002
>  0000000000000202 0000000000000202 00000000fffffff4 ffff81003ea53a30
> Call Trace:
>  [<ffffffff80495ab4>] pcie_isr+0x18e/0x1bc
>  [<ffffffff80260831>] request_irq+0x106/0x12f
>  [<ffffffff80495fb6>] pcie_init+0x15e/0x6cc
>  [<ffffffff804933a3>] pciehp_probe+0x64/0x541
>  [<ffffffff8048f4e7>] pcie_port_probe_service+0x4c/0x76
>  [<ffffffff8054af70>] driver_probe_device+0xd4/0x1f0
>  [<ffffffff8054b108>] __driver_attach+0x7c/0x7e
>  [<ffffffff8054b08c>] ? __driver_attach+0x0/0x7e
>  [<ffffffff8054a4b6>] bus_for_each_dev+0x53/0x7d
>  [<ffffffff8054ad3c>] driver_attach+0x1c/0x1e
>  [<ffffffff8054a9c2>] bus_add_driver+0xdd/0x25b
>  [<ffffffff80c09d3d>] ? pcied_init+0x0/0x8b
>  [<ffffffff8054b288>] driver_register+0x5f/0x13e
>  [<ffffffff80c09d3d>] ? pcied_init+0x0/0x8b
>  [<ffffffff8048f441>] pcie_port_service_register+0x47/0x49
>  [<ffffffff80c09d52>] pcied_init+0x15/0x8b
>  [<ffffffff80bf3938>] kernel_init+0x75/0x243
>  [<ffffffff808639d2>] ? _spin_unlock_irq+0x2b/0x3a
>  [<ffffffff80228d1f>] ? finish_task_switch+0x57/0x9a
>  [<ffffffff8020c258>] child_rip+0xa/0x12
>  [<ffffffff8020bcec>] ? restore_args+0x0/0x30
>  [<ffffffff80bf38c3>] ? kernel_init+0x0/0x243
>  [<ffffffff8020c24e>] ? child_rip+0x0/0x12
> 
> Code: 83 80 00 00 00 48 39 f0 75 e1 0f b6 c9 48 c7 c2 00 0e 8d 80 48 c7 c6 8a 60 a6 80 48 c7 c7 10 db a8 80 31 c0 e8 3f 8d d9 ff 31 db <48> 8b 43 70 48 8d 75 ef 48 89 df ff 50 30 80 7d ef 00 74 37 48
> RIP  [<ffffffff80494a8b>] pciehp_handle_presence_change+0x7e/0x113
>  RSP <ffff81003f83fbb0>
> CR2: 0000000000000070
> Kernel panic - not syncing: Fatal exception

This looks to me like CONFIG_DEBUG_SHIRQ doing its job.

> the config with which it occurs is:
> 
>   http://redhat.com/~mingo/misc/config-Sat_May_24_18_17_56_CEST_2008.bad
> 
> the fix is to check for NULL slots.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/pci/hotplug/pciehp_ctrl.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux/drivers/pci/hotplug/pciehp_ctrl.c
> ===================================================================
> --- linux.orig/drivers/pci/hotplug/pciehp_ctrl.c
> +++ linux/drivers/pci/hotplug/pciehp_ctrl.c
> @@ -118,6 +118,9 @@ u8 pciehp_handle_presence_change(u8 hp_s
>  
>  	p_slot = pciehp_find_slot(ctrl, hp_slot + ctrl->slot_device_offset);
>  
> +	if (!p_slot || !p_slot->hpc_ops)
> +		return 0;
> +
>  	/* Switch is open, assume a presence change
>  	 * Save the presence state
>  	 */

It is fishy that pcie_init() calls pciehp_request_irq() before calling
pcie_init_hardware_part2().  That looks like the classic "lets die
horridly if a shared IRQ comes in at the wrong time" sequence.
