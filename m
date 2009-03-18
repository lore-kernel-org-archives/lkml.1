Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbZCRM7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbZCRM7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 08:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbZCRM6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 08:58:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:58516 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217AbZCRM6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 08:58:54 -0400
Date: Wed, 18 Mar 2009 12:58:01 GMT
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, pq@iki.fi, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, pq@iki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200903111633.55952.rusty@rustcorp.com.au>
References: <200903111633.55952.rusty@rustcorp.com.au>
Subject: [tip:cpus4096] x86: cpumask: x86 mmio-mod.c use cpumask_var_t for downed_cpus
Message-ID: <tip-c38da5692e3a4d5d303c04cbf7e526f1eb761076@git.kernel.org>
Git-Commit-ID: c38da5692e3a4d5d303c04cbf7e526f1eb761076
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 18 Mar 2009 12:58:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c38da5692e3a4d5d303c04cbf7e526f1eb761076
Gitweb:     http://git.kernel.org/tip/c38da5692e3a4d5d303c04cbf7e526f1eb761076
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Wed, 11 Mar 2009 16:33:55 +1030
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 18 Mar 2009 13:51:51 +0100

x86: cpumask: x86 mmio-mod.c use cpumask_var_t for downed_cpus

Impact: cleanup, reduce memory usage for CONFIG_CPUMASK_OFFSTACK=y

Part of the "getting rid of obsolete cpumask_t" patch:

 1) Use cpumask_var_t: this is a pointer if CONFIG_CPUMASK_OFFSTACK=y
 2) Call alloc_cpumask_var() on first entry into enter_uniprocessor()
 3) Use modern cpumask_* functions.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pekka Paalanen <pq@iki.fi>
LKML-Reference: <200903111633.55952.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/mmio-mod.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index 2c4baa8..c9342ed 100644
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
@@ -411,10 +418,10 @@ static void __ref leave_uniprocessor(void)
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
