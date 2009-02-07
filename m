Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbZBGDXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbZBGDXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 22:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZBGDXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 22:23:23 -0500
Received: from ozlabs.org ([203.10.76.45]:57541 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbZBGDXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 22:23:22 -0500
To: Richard Henderson <rth@twiddle.net>
Cc: linux-kernel@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Travis <travis@sgi.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 7 Feb 2009 13:53:11 +1030
Subject: [PATCH] cpumask: Use cpu_*_mask accessors code: alpha
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902071353.12571.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use new API, fix SMP bug.

Use the new accessors rather than frobbing bits directly.

This also removes the bug introduced in ee0c468b (alpha: compile
fixes) which had Alpha setting bits on an on-stack cpumask, not the
cpu_online_map.

(Trivial, but untested!)

Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/alpha/kernel/process.c |    8 ++++----
 arch/alpha/kernel/smp.c     |   11 ++++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -93,8 +93,8 @@ common_shutdown_1(void *generic_ptr)
 	if (cpuid != boot_cpuid) {
 		flags |= 0x00040000UL; /* "remain halted" */
 		*pflags = flags;
-		cpu_clear(cpuid, cpu_present_map);
-		cpu_clear(cpuid, cpu_possible_map);
+		set_cpu_present(cpuid, false);
+		set_cpu_possible(cpuid, false);
 		halt();
 	}
 #endif
@@ -120,8 +120,8 @@ common_shutdown_1(void *generic_ptr)
 
 #ifdef CONFIG_SMP
 	/* Wait for the secondaries to halt. */
-	cpu_clear(boot_cpuid, cpu_present_map);
-	cpu_clear(boot_cpuid, cpu_possible_map);
+	set_cpu_present(boot_cpuid, false);
+	set_cpu_possible(boot_cpuid, false);
 	while (cpus_weight(cpu_present_map))
 		barrier();
 #endif
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -120,12 +120,12 @@ smp_callin(void)
 smp_callin(void)
 {
 	int cpuid = hard_smp_processor_id();
-	cpumask_t mask = cpu_online_map;
 
-	if (cpu_test_and_set(cpuid, mask)) {
+	if (cpu_online(cpuid)) {
 		printk("??, cpu 0x%x already present??\n", cpuid);
 		BUG();
 	}
+	set_cpu_online(cpuid, true);
 
 	/* Turn on machine checks.  */
 	wrmces(7);
@@ -436,8 +436,8 @@ setup_smp(void)
 				((char *)cpubase + i*hwrpb->processor_size);
 			if ((cpu->flags & 0x1cc) == 0x1cc) {
 				smp_num_probed++;
-				cpu_set(i, cpu_possible_map);
-				cpu_set(i, cpu_present_map);
+				set_cpu_possible(i, true);
+				set_cpu_present(i, true);
 				cpu->pal_revision = boot_cpu_palrev;
 			}
 
@@ -470,8 +470,8 @@ smp_prepare_cpus(unsigned int max_cpus)
 
 	/* Nothing to do on a UP box, or when told not to.  */
 	if (smp_num_probed == 1 || max_cpus == 0) {
-		cpu_possible_map = cpumask_of_cpu(boot_cpuid);
-		cpu_present_map = cpumask_of_cpu(boot_cpuid);
+		init_cpu_possible(cpumask_of(boot_cpuid));
+		init_cpu_present(cpumask_of(boot_cpuid));
 		printk(KERN_INFO "SMP mode deactivated.\n");
 		return;
 	}

