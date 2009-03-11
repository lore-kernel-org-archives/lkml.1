Return-Path: <linux-kernel-owner+w=401wt.eu-S1753861AbZCKGEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbZCKGEZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 02:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZCKGEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 02:04:13 -0400
Received: from ozlabs.org ([203.10.76.45]:59752 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbZCKGEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 02:04:12 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pekka Paalanen <pq@iki.fi>
Subject: [PATCH] cpumask: x86 mmio-mod.c use cpumask_var_t for downed_cpus.
Date: Wed, 11 Mar 2009 16:33:55 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903111633.55952.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce memory usage for CONFIG_CPUMASK_OFFSTACK=y

Part of the "getting rid of obsolete cpumask_t" patch:
1) Use cpumask_var_t: this is a pointer if CONFIG_CPUMASK_OFFSTACK=y
2) Call alloc_cpumask_var() on first entry into enter_uniprocessor()
3) Use modern cpumask_* functions.

To: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/mm/mmio-mod.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -378,27 +378,34 @@ static void clear_trace_list(void)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static cpumask_t downed_cpus;
+static cpumask_var_t downed_cpus;
 
 static void enter_uniprocessor(void)
 {
 	int cpu;
 	int err;
 
+	if (downed_cpus == NULL &&
+	    !alloc_cpumask_var(&downed_cpus, GFP_KERNEL)) {
+		pr_notice(NAME "Failed to allocate mask\n");
+		goto out;
+	}
+
 	get_online_cpus();
-	downed_cpus = cpu_online_map;
-	cpu_clear(first_cpu(cpu_online_map), downed_cpus);
+	cpumask_copy(downed_cpus, cpu_online_mask);
+	cpumask_clear_cpu(cpumask_first(cpu_online_mask), downed_cpus);
 	if (num_online_cpus() > 1)
 		pr_notice(NAME "Disabling non-boot CPUs...\n");
 	put_online_cpus();
 
-	for_each_cpu_mask(cpu, downed_cpus) {
+	for_each_cpu(cpu, downed_cpus) {
 		err = cpu_down(cpu);
 		if (!err)
 			pr_info(NAME "CPU%d is down.\n", cpu);
 		else
 			pr_err(NAME "Error taking CPU%d down: %d\n", cpu, err);
 	}
+out:
 	if (num_online_cpus() > 1)
 		pr_warning(NAME "multiple CPUs still online, "
 						"may miss events.\n");
@@ -411,10 +418,10 @@ static void __ref leave_uniprocessor(voi
 	int cpu;
 	int err;
 
-	if (cpus_weight(downed_cpus) == 0)
+	if (downed_cpus == NULL || cpumask_weight(downed_cpus) == 0)
 		return;
 	pr_notice(NAME "Re-enabling CPUs...\n");
-	for_each_cpu_mask(cpu, downed_cpus) {
+	for_each_cpu(cpu, downed_cpus) {
 		err = cpu_up(cpu);
 		if (!err)
 			pr_info(NAME "enabled CPU%d.\n", cpu);
