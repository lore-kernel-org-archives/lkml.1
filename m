Return-Path: <linux-kernel-owner+w=401wt.eu-S1756288AbYECXgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288AbYECXgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 19:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068AbYECXgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 19:36:03 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36083
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752931AbYECXgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 19:36:01 -0400
Date: Sat, 03 May 2008 16:36:00 -0700 (PDT)
Message-Id: <20080503.163600.93588714.davem@davemloft.net>
To: mingo@elte.hu
Cc: benh@kernel.crashing.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       elendil@planet.nl, parag.warudkar@gmail.com,
       linux-kernel@vger.kernel.org, guichaz@yahoo.fr, andi@firstfloor.org
Subject: Re: 'global' rq->clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080503.160408.238581868.davem@davemloft.net>
References: <1209853855.26383.28.camel@pasglop>
	<20080503223844.GA18344@elte.hu>
	<20080503.160408.238581868.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 03 May 2008 16:04:08 -0700 (PDT)

> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun, 4 May 2008 00:38:44 +0200
> 
> > the same bug existed on x86 too: that too does a few IPIs without 
> > irq_enter/irq_exit. We now removed the softlockup dependency so it 
> > should not be required to do an irq_enter()/exit anymore - unless the 
> > code that the IPI uses accesses jiffies. (but that would be unusual)
> 
> That move doesn't solve the problem, I'm strongly certain
> arch's still need to add the irq_{enter,exit}().
> 
> I'll revert the irq_{enter,exit}() changes on one of my
> sparc64 boxes to validate this later today.

False alarm, which is good news, thanks Ingo.  I can revert
the following it seems:

commit 2664ef44cf5053d2b7dff01cecac70bc601a5f68
Author: David S. Miller <davem@davemloft.net>
Date:   Fri Apr 25 03:11:37 2008 -0700

    [SPARC64]: Wrap SMP IPIs with irq_enter()/irq_exit().
    
    Otherwise all sorts of bad things can happen, including
    spurious softlockup reports.
    
    Other platforms have this same bug, in one form or
    another, just don't see the issue because they
    don't sleep as long as sparc64 can in NOHZ.
    
    Thanks to some brilliant debugging by Peter Zijlstra.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
index 524b889..409dd71 100644
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -866,14 +866,21 @@ void smp_call_function_client(int irq, struct pt_regs *regs)
 	void *info = call_data->info;
 
 	clear_softint(1 << irq);
+
+	irq_enter();
+
+	if (!call_data->wait) {
+		/* let initiator proceed after getting data */
+		atomic_inc(&call_data->finished);
+	}
+
+	func(info);
+
+	irq_exit();
+
 	if (call_data->wait) {
 		/* let initiator proceed only after completion */
-		func(info);
 		atomic_inc(&call_data->finished);
-	} else {
-		/* let initiator proceed after getting data */
-		atomic_inc(&call_data->finished);
-		func(info);
 	}
 }
 
@@ -1032,7 +1039,9 @@ void smp_receive_signal(int cpu)
 
 void smp_receive_signal_client(int irq, struct pt_regs *regs)
 {
+	irq_enter();
 	clear_softint(1 << irq);
+	irq_exit();
 }
 
 void smp_new_mmu_context_version_client(int irq, struct pt_regs *regs)
@@ -1040,6 +1049,8 @@ void smp_new_mmu_context_version_client(int irq, struct pt_regs *regs)
 	struct mm_struct *mm;
 	unsigned long flags;
 
+	irq_enter();
+
 	clear_softint(1 << irq);
 
 	/* See if we need to allocate a new TLB context because
@@ -1059,6 +1070,8 @@ void smp_new_mmu_context_version_client(int irq, struct pt_regs *regs)
 	load_secondary_context(mm);
 	__flush_tlb_mm(CTX_HWBITS(mm->context),
 		       SECONDARY_CONTEXT);
+
+	irq_exit();
 }
 
 void smp_new_mmu_context_version(void)
@@ -1217,6 +1230,8 @@ void smp_penguin_jailcell(int irq, struct pt_regs *regs)
 {
 	clear_softint(1 << irq);
 
+	irq_enter();
+
 	preempt_disable();
 
 	__asm__ __volatile__("flushw");
@@ -1229,6 +1244,8 @@ void smp_penguin_jailcell(int irq, struct pt_regs *regs)
 	prom_world(0);
 
 	preempt_enable();
+
+	irq_exit();
 }
 
 /* /proc/profile writes can call this, don't __init it please. */
