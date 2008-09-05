Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbYIEVl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbYIEVl0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 17:41:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323AbYIEVkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 17:40:24 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54834 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751944AbYIEVkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 17:40:21 -0400
Message-Id: <20080905214020.115286000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Fri, 05 Sep 2008 14:40:20 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>, Jes Sorensen <jes@sgi.com>,
       David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] smp: reduce stack requirements for smp_call_function_mask
References: <20080905214019.821172000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=smp_call_function_mask
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Cleanup cpumask_t usages in smp_call_function_mask to remove stack
    overflow problem when NR_CPUS=4096.  This removes over 1000 bytes
    from the stack with NR_CPUS=4096.

Based on 2.6.27-rc5-git6.

Applies to linux-2.6.tip/master (with FUZZ).

Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/smp.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- linux-2.6.orig/kernel/smp.c
+++ linux-2.6/kernel/smp.c
@@ -303,7 +303,7 @@ static int check_stack_overflow(void)
  * If a faster scheme can be made, we could go back to preferring stack based
  * data -- the data allocation/free is non-zero cost.
  */
-static void smp_call_function_mask_quiesce_stack(cpumask_t mask)
+static void smp_call_function_mask_quiesce_stack(const cpumask_t *mask)
 {
 	struct call_single_data data;
 	int cpu;
@@ -311,7 +311,7 @@ static void smp_call_function_mask_quies
 	data.func = quiesce_dummy;
 	data.info = NULL;
 
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, *mask) {
 		data.flags = CSD_FLAG_WAIT;
 		generic_exec_single(cpu, &data);
 	}
@@ -339,7 +339,6 @@ int smp_call_function_mask(cpumask_t mas
 {
 	struct call_function_data d;
 	struct call_function_data *data = NULL;
-	cpumask_t allbutself;
 	unsigned long flags;
 	int cpu, num_cpus;
 	int slowpath = 0;
@@ -353,9 +352,8 @@ dump_stack();
 	WARN_ON(irqs_disabled());
 
 	cpu = smp_processor_id();
-	allbutself = cpu_online_map;
-	cpu_clear(cpu, allbutself);
-	cpus_and(mask, mask, allbutself);
+	cpus_and(mask, mask, cpu_online_map);
+	cpu_clear(cpu, mask);
 	num_cpus = cpus_weight(mask);
 
 	/*
@@ -398,7 +396,7 @@ dump_stack();
 	if (wait) {
 		csd_flag_wait(&data->csd);
 		if (unlikely(slowpath))
-			smp_call_function_mask_quiesce_stack(mask);
+			smp_call_function_mask_quiesce_stack(&mask);
 	}
 
 	return 0;

