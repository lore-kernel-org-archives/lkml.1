Return-Path: <linux-kernel-owner+w=401wt.eu-S1758719AbZC2CHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbZC2CHb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 22:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757111AbZC2CEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 22:04:15 -0400
Received: from ozlabs.org ([203.10.76.45]:46574 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867AbZC2CEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 22:04:08 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sun, 29 Mar 2009 00:25:52 +1030
Subject: [PATCH 4/10] cpumask: use set_cpu_active in init/main.c
Message-Id: <20090329020406.0CE56DDE9E@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cpu_active_map is deprecated in favor of cpu_active_mask, which is
const for safety: we use accessors now (set_cpu_active) is we really
want to make a change.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 init/main.c  |    3 +--
 kernel/cpu.c |    6 +++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -401,8 +401,7 @@ static void __init smp_init(void)
 	 * Set up the current CPU as possible to migrate to.
 	 * The other ones will be done by cpu_up/cpu_down()
 	 */
-	cpu = smp_processor_id();
-	cpu_set(cpu, cpu_active_map);
+	set_cpu_active(smp_processor_id(), true);
 
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
diff --git a/kernel/cpu.c b/kernel/cpu.c
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -281,7 +281,7 @@ int __ref cpu_down(unsigned int cpu)
 		goto out;
 	}
 
-	cpu_clear(cpu, cpu_active_map);
+	set_cpu_active(cpu, false);
 
 	/*
 	 * Make sure the all cpus did the reschedule and are not
@@ -296,7 +296,7 @@ int __ref cpu_down(unsigned int cpu)
 	err = _cpu_down(cpu, 0);
 
 	if (cpu_online(cpu))
-		cpu_set(cpu, cpu_active_map);
+		set_cpu_active(cpu, true);
 
 out:
 	cpu_maps_update_done();
@@ -333,7 +333,7 @@ static int __cpuinit _cpu_up(unsigned in
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
 
-	cpu_set(cpu, cpu_active_map);
+	set_cpu_active(cpu, true);
 
 	/* Now call notifier in preparation. */
 	raw_notifier_call_chain(&cpu_chain, CPU_ONLINE | mod, hcpu);

