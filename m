Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbYBECy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbYBECy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 21:54:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYBECyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 21:54:50 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:4652 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753261AbYBECyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 21:54:49 -0500
Date: Mon, 4 Feb 2008 18:51:44 -0800
From: Daniel Walker <dwalker@dwalker1.mvista.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org
Subject: Re: CPU hotplug and IRQ affinity with 2.6.24-rt1
Message-ID: <20080205025144.GA31774@dwalker1.mvista.com>
References: <47A7A131.8040800@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A7A131.8040800@qualcomm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 03:35:13PM -0800, Max Krasnyanskiy wrote:
> This is just an FYI. As part of the "Isolated CPU extensions" thread Daniel suggest for me
> to check out latest RT kernels. So I did or at least tried to and immediately spotted a couple
> of issues.
>
> The machine I'm running it on is:
> 	HP xw9300, Dual Opteron, NUMA
>
> It looks like with -rt kernel IRQ affinity masks are ignored on that 
> system. ie I write 1 to lets say /proc/irq/23/smp_affinity but the 
> interrupts keep coming to CPU1. Vanilla 2.6.24 does not have that issue.

I tried this, and it works according to /proc/interrupts .. Are you
looking at the interrupt threads affinity?

> Also the first thing I tried was to bring CPU1 off-line. Thats the fastest 
> way to get irqs, soft-irqs, timers, etc of a CPU. But the box hung 
> completely. It also managed to mess up my ext3 filesystem to the point 
> where it required manual fsck (have not see that for a couple of
> years now). I tried the same thing (ie echo 0 > 
> /sys/devices/cpu/cpu1/online) from the console. It hang again with the 
> message that looked something like:
> 	CPU1 is now off-line
> 	Thread IRQ-23 is on CPU1 ...

I get the following when I tried it,

BUG: sleeping function called from invalid context bash(5126) at
kernel/rtmutex.c:638
in_atomic():1 [00000001], irqs_disabled():1
Pid: 5126, comm: bash Not tainted 2.6.24-rt1 #1
 [<c010506b>] show_trace_log_lvl+0x1d/0x3a
 [<c01059cd>] show_trace+0x12/0x14
 [<c0106151>] dump_stack+0x6c/0x72
 [<c011d153>] __might_sleep+0xe8/0xef
 [<c03b2326>] __rt_spin_lock+0x24/0x59
 [<c03b2363>] rt_spin_lock+0x8/0xa
 [<c0165b2f>] kfree+0x2c/0x8d
 [<c011eacb>] rq_attach_root+0x67/0xba
 [<c01209ae>] cpu_attach_domain+0x2b6/0x2f7
 [<c0120a12>] detach_destroy_domains+0x23/0x37
 [<c0121368>] update_sched_domains+0x2d/0x40
 [<c013b482>] notifier_call_chain+0x2b/0x55
 [<c013b4d9>] __raw_notifier_call_chain+0x19/0x1e
 [<c01420d3>] _cpu_down+0x84/0x24c
 [<c01422c3>] cpu_down+0x28/0x3a
 [<c029f59e>] store_online+0x27/0x5a
 [<c029c9dc>] sysdev_store+0x20/0x25
 [<c019a695>] sysfs_write_file+0xad/0xde
 [<c0169929>] vfs_write+0x82/0xb8
 [<c0169e2a>] sys_write+0x3d/0x61
 [<c0104072>] sysenter_past_esp+0x5f/0x85
 =======================
---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<c03b25e2>] .... __spin_lock_irqsave+0x14/0x3b
.....[<c011ea76>] ..   ( <= rq_attach_root+0x12/0xba)

Which is clearly a problem .. 

(I added linux-rt-users to the CC)

Daniel
