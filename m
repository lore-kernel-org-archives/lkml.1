Return-Path: <linux-kernel-owner+w=401wt.eu-S1763725AbZFKXBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763725AbZFKXBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 19:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763017AbZFKW7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:59:36 -0400
Received: from ozlabs.org ([203.10.76.45]:37888 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758562AbZFKW71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:59:27 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 11 Jun 2009 22:59:58 +0930
Subject: [PATCH 5/6] acpi: don't play with current's cpumask in drivers/acpi/processor_throttling.c
Cc: Len Brown <lenb@kernel.org>
Message-Id: <20090611225929.2A113DDDA2@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It's generally a very bad idea to mug some process's cpumask: it could
legitimately and reasonably be changed by root, which could break us
(if done before our code) or them (if we restore the wrong value).

So we use smp_call_function_single in two places instead of cpumask games.
If this code isn't interrupt safe, it will now break.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/acpi/processor_throttling.c |   82 ++++++++++++++++++------------------
 1 file changed, 43 insertions(+), 39 deletions(-)

diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -852,10 +852,21 @@ static int acpi_processor_get_throttling
 	return 0;
 }
 
+struct get_throttling {
+	struct acpi_processor *pr;
+	int ret;
+};
+
+static void get_throttling(void *_gt)
+{
+	struct get_throttling *gt = _gt;
+
+	gt->ret = gt->pr->throttling.acpi_processor_get_throttling(gt->pr);
+}
+
 static int acpi_processor_get_throttling(struct acpi_processor *pr)
 {
-	cpumask_var_t saved_mask;
-	int ret;
+	struct get_throttling gt;
 
 	if (!pr)
 		return -EINVAL;
@@ -863,21 +874,9 @@ static int acpi_processor_get_throttling
 	if (!pr->flags.throttling)
 		return -ENODEV;
 
-	if (!alloc_cpumask_var(&saved_mask, GFP_KERNEL))
-		return -ENOMEM;
-
-	/*
-	 * Migrate task to the cpu pointed by pr.
-	 */
-	cpumask_copy(saved_mask, &current->cpus_allowed);
-	/* FIXME: use work_on_cpu() */
-	set_cpus_allowed_ptr(current, cpumask_of(pr->id));
-	ret = pr->throttling.acpi_processor_get_throttling(pr);
-	/* restore the previous state */
-	set_cpus_allowed_ptr(current, saved_mask);
-	free_cpumask_var(saved_mask);
-
-	return ret;
+	gt.pr = pr;
+	smp_call_function_single(pr->id, get_throttling, &gt, 1);
+	return gt.ret;
 }
 
 static int acpi_processor_get_fadt_info(struct acpi_processor *pr)
@@ -1018,9 +1017,23 @@ static int acpi_processor_set_throttling
 	return 0;
 }
 
+struct set_throttling_info {
+	struct acpi_processor *pr;
+	struct acpi_processor_throttling *p_throttling;
+	int target_state;
+	int ret;
+};
+
+static void set_throttling(void *_sti)
+{
+	struct set_throttling_info *s = _sti;
+
+	s->ret = s->p_throttling->acpi_processor_set_throttling(s->pr,
+								s->target_state);
+}
+
 int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 {
-	cpumask_var_t saved_mask;
 	int ret = 0;
 	unsigned int i;
 	struct acpi_processor *match_pr;
@@ -1037,15 +1050,9 @@ int acpi_processor_set_throttling(struct
 	if ((state < 0) || (state > (pr->throttling.state_count - 1)))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&saved_mask, GFP_KERNEL))
+	if (!alloc_cpumask_var(&online_throttling_cpus, GFP_KERNEL))
 		return -ENOMEM;
 
-	if (!alloc_cpumask_var(&online_throttling_cpus, GFP_KERNEL)) {
-		free_cpumask_var(saved_mask);
-		return -ENOMEM;
-	}
-
-	cpumask_copy(saved_mask, &current->cpus_allowed);
 	t_state.target_state = state;
 	p_throttling = &(pr->throttling);
 	cpumask_and(online_throttling_cpus, cpu_online_mask,
@@ -1067,10 +1074,10 @@ int acpi_processor_set_throttling(struct
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		/* FIXME: use work_on_cpu() */
-		set_cpus_allowed_ptr(current, cpumask_of(pr->id));
-		ret = p_throttling->acpi_processor_set_throttling(pr,
-						t_state.target_state);
+		struct set_throttling_info sti
+			= { pr, p_throttling, t_state.target_state };
+		smp_call_function_single(pr->id, set_throttling, &sti, 1);
+		ret = sti.ret;
 	} else {
 		/*
 		 * When the T-state coordination is SW_ALL or HW_ALL,
@@ -1078,6 +1085,8 @@ int acpi_processor_set_throttling(struct
 		 * cpus.
 		 */
 		for_each_cpu(i, online_throttling_cpus) {
+			struct set_throttling_info sti;
+
 			match_pr = per_cpu(processors, i);
 			/*
 			 * If the pointer is invalid, we will report the
@@ -1099,11 +1108,11 @@ int acpi_processor_set_throttling(struct
 				continue;
 			}
 			t_state.cpu = i;
-			/* FIXME: use work_on_cpu() */
-			set_cpus_allowed_ptr(current, cpumask_of(i));
-			ret = match_pr->throttling.
-				acpi_processor_set_throttling(
-				match_pr, t_state.target_state);
+			sti.pr = match_pr;
+			sti.p_throttling = &match_pr->throttling;
+			sti.target_state = t_state.target_state;
+			smp_call_function_single(i, set_throttling, &sti, 1);
+			ret = sti.ret;
 		}
 	}
 	/*
@@ -1117,11 +1126,6 @@ int acpi_processor_set_throttling(struct
 		acpi_processor_throttling_notifier(THROTTLING_POSTCHANGE,
 							&t_state);
 	}
-	/* restore the previous state */
-	/* FIXME: use work_on_cpu() */
-	set_cpus_allowed_ptr(current, saved_mask);
-	free_cpumask_var(online_throttling_cpus);
-	free_cpumask_var(saved_mask);
 	return ret;
 }
 

