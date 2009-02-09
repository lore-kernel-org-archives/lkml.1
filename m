Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbZBISQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbZBISQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbZBISQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:16:19 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:1932 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbZBISQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:16:18 -0500
Date: Mon, 9 Feb 2009 11:16:16 -0700
From: Alex Chiang <achiang@hp.com>
To: tony.luck@intel.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       stable@kernel.org, linux-ia64@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] Revert "[IA64] prevent ia64 from invoking irq
	handlers on offline CPUs"
Message-ID: <20090209181616.GE19064@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, tony.luck@intel.com,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, stable@kernel.org,
	linux-ia64@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20090209181338.GD19064@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090209181338.GD19064@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit e7b140365b86aaf94374214c6f4e6decbee2eb0a.

Commit e7b14036 removes the targetted disabled CPU from the
cpu_online_map after calls to migrate_platform_irqs and fixup_irqs.

Paul McKenney states that the reasoning behind the patch was to
prevent irq handlers from running on CPUs marked offline because:

	RCU happily ignores CPUs that don't have their bits set in
	cpu_online_map, so if there are RCU read-side critical sections
	in the irq handlers being run, RCU will ignore them.  If the
	other CPUs were running, they might sequence through the RCU
	state machine, which could result in data structures being
	yanked out from under those irq handlers, which in turn could
	result in oopses or worse.

Unfortunately, both ia64 functions above look at cpu_online_map to find
a new CPU to migrate interrupts onto. This means we can potentially
migrate an interrupt off ourself back to... ourself. Uh oh.

This causes an oops when we finally try to process pending interrupts on
the CPU we want to disable. The oops results from calling __do_IRQ with
a NULL pt_regs:

Unable to handle kernel NULL pointer dereference (address 0000000000000040)
Call Trace:
 [<a000000100016930>] show_stack+0x50/0xa0
                                sp=e0000009c922fa00 bsp=e0000009c92214d0
 [<a0000001000171a0>] show_regs+0x820/0x860
                                sp=e0000009c922fbd0 bsp=e0000009c9221478
 [<a00000010003c700>] die+0x1a0/0x2e0
                                sp=e0000009c922fbd0 bsp=e0000009c9221438
 [<a0000001006e92f0>] ia64_do_page_fault+0x950/0xa80
                                sp=e0000009c922fbd0 bsp=e0000009c92213d8
 [<a00000010000c7a0>] ia64_native_leave_kernel+0x0/0x270
                                sp=e0000009c922fc60 bsp=e0000009c92213d8
 [<a0000001000ecdb0>] profile_tick+0xd0/0x1c0
                                sp=e0000009c922fe30 bsp=e0000009c9221398
 [<a00000010003bb90>] timer_interrupt+0x170/0x3e0
                                sp=e0000009c922fe30 bsp=e0000009c9221330
 [<a00000010013a800>] handle_IRQ_event+0x80/0x120
                                sp=e0000009c922fe30 bsp=e0000009c92212f8
 [<a00000010013aa00>] __do_IRQ+0x160/0x4a0
                                sp=e0000009c922fe30 bsp=e0000009c9221290
 [<a000000100012290>] ia64_process_pending_intr+0x2b0/0x360
                                sp=e0000009c922fe30 bsp=e0000009c9221208
 [<a0000001000112d0>] fixup_irqs+0xf0/0x2a0
                                sp=e0000009c922fe30 bsp=e0000009c92211a8
 [<a00000010005bd80>] __cpu_disable+0x140/0x240
                                sp=e0000009c922fe30 bsp=e0000009c9221168
 [<a0000001006c5870>] take_cpu_down+0x50/0xa0
                                sp=e0000009c922fe30 bsp=e0000009c9221148
 [<a000000100122610>] stop_cpu+0xd0/0x200
                                sp=e0000009c922fe30 bsp=e0000009c92210f0
 [<a0000001000e0440>] kthread+0xc0/0x140
                                sp=e0000009c922fe30 bsp=e0000009c92210c8
 [<a000000100014ab0>] kernel_thread_helper+0xd0/0x100
                                sp=e0000009c922fe30 bsp=e0000009c92210a0
 [<a00000010000a4c0>] start_kernel_thread+0x20/0x40
                                sp=e0000009c922fe30 bsp=e0000009c92210a0

I don't like this revert because it is fragile. ia64 is getting lucky
because we seem to only ever process timer interrupts in this path, but
if we ever race with an IPI here, we definitely use RCU and have the
potential of hitting an oops that Paul describes above.

Patching ia64's timer_interrupt() to check for NULL pt_regs is
insufficient though, as we still hit the above oops.

As a short term solution, I do think that this revert is the right
answer. The revert hold up under repeated testing (24+ hour test runs)
with this setup:

	- 8-way rx6600
	- randomly toggling CPU online/offline state every 2 seconds
	- running CPU exercisers, memory hog, disk exercisers, and
	  network stressors
	- average system load around ~160

In the long term, we really need to figure out why we set pt_regs = NULL
in ia64_process_pending_intr(). If it turns out that it is unnecessary
to do so, then we could safely re-introduce e7b14036 (along with some
other logic to be smarter about migrating interrupts).

One final note: x86 also removes the disabled CPU from cpu_online_map
and then re-enables interrupts for 1ms, presumably to handle any pending
interrupts:

arch/x86/kernel/irq_32.c (and irq_64.c):
cpu_disable_common:
	[remove cpu from cpu_online_map]

	fixup_irqs():
		for_each_irq:
			[break CPU affinities]

		local_irq_enable();
		mdelay(1);
		local_irq_disable();

So they are doing implicitly what ia64 is doing explicitly.

Cc: stable@kernel.org
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
 arch/ia64/kernel/smpboot.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 1146399..2ec5bbf 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -736,14 +736,16 @@ int __cpu_disable(void)
 			return -EBUSY;
 	}
 
+	cpu_clear(cpu, cpu_online_map);
+
 	if (migrate_platform_irqs(cpu)) {
 		cpu_set(cpu, cpu_online_map);
 		return (-EBUSY);
 	}
 
 	remove_siblinginfo(cpu);
-	fixup_irqs();
 	cpu_clear(cpu, cpu_online_map);
+	fixup_irqs();
 	local_flush_tlb_all();
 	cpu_clear(cpu, cpu_callin_map);
 	return 0;
-- 
1.6.0.1.161.g7f314

