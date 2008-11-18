Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbYKQNZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbYKQNZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:25:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbYKQNZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:25:13 -0500
Received: from ozlabs.org ([203.10.76.45]:39402 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYKQNZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:25:10 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon Nov 17 23:47:44 CST 2008
CC: akpm@linux-foundation.org
Subject: [PATCH 3/3] Clean up alloc_percpu: change percpu_ptr to per_cpu_ptr
Cc: mingo@redhat.com
Cc: lenb@kernel.org
Cc: cpufreq@vger.kernel.org
Message-Id: <20081117132509.AB4B3DDDF5@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are two allocated per-cpu accessor macros with almost identical
spelling.  The original and far more popular is per_cpu_ptr, so change
over the other four files.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: mingo@redhat.com
Cc: lenb@kernel.org
Cc: cpufreq@vger.kernel.org
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +-
 drivers/acpi/processor_perflib.c           |    4 ++--
 kernel/sched.c                             |    6 +++---
 kernel/stop_machine.c                      |    2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff -r 4a008e8d6ea4 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c	Mon Nov 17 21:32:09 2008 +1030
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c	Mon Nov 17 21:33:07 2008 +1030
@@ -581,7 +581,7 @@
 	if (!data)
 		return -ENOMEM;
 
-	data->acpi_data = percpu_ptr(acpi_perf_data, cpu);
+	data->acpi_data = per_cpu_ptr(acpi_perf_data, cpu);
 	per_cpu(drv_data, cpu) = data;
 
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC))
diff -r 4a008e8d6ea4 drivers/acpi/processor_perflib.c
--- a/drivers/acpi/processor_perflib.c	Mon Nov 17 21:32:09 2008 +1030
+++ b/drivers/acpi/processor_perflib.c	Mon Nov 17 21:33:07 2008 +1030
@@ -611,12 +611,12 @@
 			continue;
 		}
 
-		if (!performance || !percpu_ptr(performance, i)) {
+		if (!performance || !per_cpu_ptr(performance, i)) {
 			retval = -EINVAL;
 			continue;
 		}
 
-		pr->performance = percpu_ptr(performance, i);
+		pr->performance = per_cpu_ptr(performance, i);
 		cpu_set(i, pr->performance->shared_cpu_map);
 		if (acpi_processor_get_psd(pr)) {
 			retval = -EINVAL;
diff -r 4a008e8d6ea4 kernel/sched.c
--- a/kernel/sched.c	Mon Nov 17 21:32:09 2008 +1030
+++ b/kernel/sched.c	Mon Nov 17 21:33:07 2008 +1030
@@ -9306,7 +9306,7 @@
 	int i;
 
 	for_each_possible_cpu(i) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, i);
+		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, i);
 
 		/*
 		 * Take rq->lock to make 64-bit addition safe on 32-bit
@@ -9333,7 +9333,7 @@
 	}
 
 	for_each_possible_cpu(i) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, i);
+		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, i);
 
 		spin_lock_irq(&cpu_rq(i)->lock);
 		*cpuusage = 0;
@@ -9370,7 +9370,7 @@
 
 	ca = task_ca(tsk);
 	if (ca) {
-		u64 *cpuusage = percpu_ptr(ca->cpuusage, task_cpu(tsk));
+		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, task_cpu(tsk));
 
 		*cpuusage += cputime;
 	}
diff -r 4a008e8d6ea4 kernel/stop_machine.c
--- a/kernel/stop_machine.c	Mon Nov 17 21:32:09 2008 +1030
+++ b/kernel/stop_machine.c	Mon Nov 17 21:33:07 2008 +1030
@@ -130,7 +130,7 @@
 	 * doesn't hit this CPU until we're ready. */
 	get_cpu();
 	for_each_online_cpu(i) {
-		sm_work = percpu_ptr(stop_machine_work, i);
+		sm_work = per_cpu_ptr(stop_machine_work, i);
 		INIT_WORK(sm_work, stop_cpu);
 		queue_work_on(i, stop_machine_wq, sm_work);
 	}

