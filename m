Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYLTBB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYLTBB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 20:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYLTBAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 20:00:54 -0500
Received: from relay3.sgi.com ([192.48.171.31]:40107 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753044AbYLTBAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 20:00:52 -0500
Message-Id: <20081220010044.846063000@polaris-admin.engr.sgi.com>
References: <20081220010043.879277000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 17:00:50 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] cpumask: use percpu allocations instead of array in arch/x86/kernel/nmi.c From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:percpu_alloc-nmi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: reduce memory usage, use alloc_percpu().

Instead of allocating an nr_cpu_ids array, most places should be using
percpu_alloc().  This doesn't waste space if cpu numbers aren't
contiguous.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/nmi.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/nmi.c
+++ linux-2.6-for-ingo/arch/x86/kernel/nmi.c
@@ -114,13 +114,13 @@ static __init void nmi_cpu_busy(void *da
 }
 #endif
 
-static void report_broken_nmi(int cpu, int *prev_nmi_count)
+static void report_broken_nmi(int cpu, int prev_nmi_count)
 {
 	printk(KERN_CONT "\n");
 
 	printk(KERN_WARNING
 		"WARNING: CPU#%d: NMI appears to be stuck (%d->%d)!\n",
-			cpu, prev_nmi_count[cpu], get_nmi_count(cpu));
+			cpu, prev_nmi_count, get_nmi_count(cpu));
 
 	printk(KERN_WARNING
 		"Please report this to bugzilla.kernel.org,\n");
@@ -139,7 +139,7 @@ int __init check_nmi_watchdog(void)
 	if (!nmi_watchdog_active() || !atomic_read(&nmi_active))
 		return 0;
 
-	prev_nmi_count = kmalloc(nr_cpu_ids * sizeof(int), GFP_KERNEL);
+	prev_nmi_count = alloc_percpu(unsigned int);
 	if (!prev_nmi_count)
 		goto error;
 
@@ -151,19 +151,19 @@ int __init check_nmi_watchdog(void)
 #endif
 
 	for_each_possible_cpu(cpu)
-		prev_nmi_count[cpu] = get_nmi_count(cpu);
+		*per_cpu_ptr(prev_nmi_count, cpu) = get_nmi_count(cpu);
 	local_irq_enable();
 	mdelay((20 * 1000) / nmi_hz); /* wait 20 ticks */
 
 	for_each_online_cpu(cpu) {
 		if (!per_cpu(wd_enabled, cpu))
 			continue;
-		if (get_nmi_count(cpu) - prev_nmi_count[cpu] <= 5)
-			report_broken_nmi(cpu, prev_nmi_count);
+		if (get_nmi_count(cpu) - *per_cpu_ptr(prev_nmi_count, cpu) <= 5)
+			report_broken_nmi(cpu, *per_cpu_ptr(prev_nmi_count,cpu));
 	}
 	endflag = 1;
 	if (!atomic_read(&nmi_active)) {
-		kfree(prev_nmi_count);
+		free_percpu(prev_nmi_count);
 		atomic_set(&nmi_active, -1);
 		goto error;
 	}
@@ -176,7 +176,7 @@ int __init check_nmi_watchdog(void)
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		nmi_hz = lapic_adjust_nmi_hz(1);
 
-	kfree(prev_nmi_count);
+	free_percpu(prev_nmi_count);
 	return 0;
 error:
 	if (nmi_watchdog == NMI_IO_APIC && !timer_through_8259)

-- 
