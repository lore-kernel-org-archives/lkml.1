Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYIGJwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYIGJwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 05:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbYIGJwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 05:52:36 -0400
Received: from sing.entic.net ([208.64.63.147]:48388 "EHLO mail.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbYIGJwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 05:52:35 -0400
Message-Id: <200809070952.m879qXHi012439@mail.q-ag.de>
From: Manfred Spraul <manfred@colorfullife.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 7 Sep 2008 11:29:58 +0200
Subject: [PATCH] arch/x86/kernel/smpboot.c: Clarify when irq processing begins.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Secondary cpus start with local interrupts disabled.
start_secondary() first initializes the new cpu, then it enables the
local interrupts. (although interrupts are enabled within smp_callin()
as well).
Right now, the local interrupts are enabled as a side effect of calling
ipi_call_lock_irq().

The attached patch clarifies when local interrupts are enabled.

Signed-of-By: Manfred Spraul <manfred@colorfullife.com>
---
 arch/x86/kernel/smpboot.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3325127..9bfa037 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -327,14 +327,17 @@ static void __cpuinit start_secondary(void *unused)
 	 * lock helps us to not include this cpu in a currently in progress
 	 * smp_call_function().
 	 */
-	ipi_call_lock_irq();
+	ipi_call_lock();
 #ifdef CONFIG_X86_IO_APIC
 	setup_vector_irq(smp_processor_id());
 #endif
 	cpu_set(smp_processor_id(), cpu_online_map);
-	ipi_call_unlock_irq();
+	ipi_call_unlock();
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 
+	/* enable local interrupts */
+	local_irq_enable();
+
 	setup_secondary_clock();
 
 	wmb();
-- 
1.5.5.1

