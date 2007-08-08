Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbXHHLif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbXHHLif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 07:38:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751032AbXHHLi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 07:38:28 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35503 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbXHHLi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 07:38:26 -0400
Date: Wed, 8 Aug 2007 17:08:34 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: Haren Myneni <hbabu@us.ibm.com>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
Message-ID: <20070808113834.GA26145@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <46B73955.2080007@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B73955.2080007@fujitsu-siemens.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2007 at 05:08:05PM +0200, Martin Wilck wrote:
> PATCH/RFC: [kdump] fix APIC shutdown sequence
> 
> This patch fixes a problem that we have encountered
> with kdump under high I/O load on some machines.
> The machines showing the errors have an Intel ICH7
> chip set with a 6702PXH  PCI Express-to-PCI Bridge
> (8086:032c) containing an IO-APIC.
> 
> The bug symptom is that certain controllers connected
> to the 6702PXH bridge wouldn't receive any IRQs in the
> kdump kernel. In the error case (which is about 20% of
> all cases) the IRR bit of the IO-APIC pin for that
> controller is always set after the start of the kdump
> kernel, indicating an IRQ in progress. We haven't found
> a way to recover from this situation when it has once
> occured, except for a system reset.
> 
> The error is caused by IRQs arriving while the APIC
> subsystem is deactivated in machine_crash_shutdown().
> 
> Apparently, the IO-APIC gets stuck if it sends an IRQ
> message to a Local APIC and never receives an EOI for that
> message. This can have several possible reasons:
> 

Got this oops while testing your patch when I did
"echo c > /proc/sysrq-trigger"

[root@llm37 ~]# SysRq : Trigger a crashdump
Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:
 [<0000000000000000>]
PGD 22229b067 PUD 0
Oops: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 2947, comm: klogd Not tainted 2.6.23-rc1-apic-issue #2
RIP: 0010:[<0000000000000000>]  [<0000000000000000>]
RSP: 0018:ffffffff807daf50  EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffffff8073f480 RCX: ffffffff807ddea0
RDX: ffffffff807717c0 RSI: ffffffff8073f480 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff807ddd28 R11: 0000000000000150 R12: 0000000000000000
R13: ffffffff8073f4d0 R14: 000000000000000c R15: 0000000000000000
FS:  00002b204ea686f0(0000) GS:ffffffff8073c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000223e9e000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process klogd (pid: 2947, threadinfo ffff81021b7b8000, task ffff8102251a27b0)
Stack:  ffffffff8025afd0 0000000000000046 ffffffff807dddf8 0000000000000000
 0000000000000030 0000000000000000 ffffffff8020e1ae ffffffff807d15c8
 0000000000000000 ffffffff807dde20 0000000000000000 ffffffff807ddee8
Call Trace:
 <IRQ>  [<ffffffff8025afd0>] handle_edge_irq+0x5c/0x127
 [<ffffffff8020e1ae>] do_IRQ+0xf1/0x15f
 [<ffffffff8020c191>] ret_from_intr+0x0/0xa
 <EOI>  <NMI>  [<ffffffff80351ae3>] __delay+0x6/0x10
 [<ffffffff8021e328>] crash_nmi_callback+0x4b/0x77
 [<ffffffff80557075>] notifier_call_chain+0x29/0x4c
 [<ffffffff80249a11>] notify_die+0x2d/0x34
 [<ffffffff805555a3>] default_do_nmi+0x55/0x197
 [<ffffffff80555f0e>] do_nmi+0x2e/0x44
 [<ffffffff805553af>] nmi+0x7f/0x90
 [<ffffffff8022e00a>] find_busiest_group+0x20e/0x6b3
 <<EOE>>  [<ffffffff80552d13>] __sched_text_start+0x1cb/0x5ba
 [<ffffffff80282294>] do_sync_write+0xc9/0x10c
 [<ffffffff80235c32>] do_syslog+0x11d/0x3a9
 [<ffffffff80246a03>] autoremove_wake_function+0x0/0x2e
 [<ffffffff802731c6>] free_pages_and_swap_cache+0x73/0x8f
 [<ffffffff802bbeac>] kmsg_read+0x3a/0x44
 [<ffffffff802b5245>] proc_reg_read+0x7e/0x99
 [<ffffffff80282b08>] vfs_read+0xaa/0x132
 [<ffffffff80282ea4>] sys_read+0x45/0x6e
 [<ffffffff8020bc7e>] system_call+0x7e/0x83


Code:  Bad RIP value.
RIP  [<0000000000000000>]
 RSP <ffffffff807daf50>
CR2: 0000000000000000

Thanks
Vivek
