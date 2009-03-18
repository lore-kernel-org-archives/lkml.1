Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbZCREXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbZCREXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 00:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbZCREWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 00:22:24 -0400
Received: from ozlabs.org ([203.10.76.45]:59276 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbZCREWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 00:22:20 -0400
To: Len Brown <lenb@kernel.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 18 Mar 2009 10:40:25 +1030
Subject: [PATCH 8/9] work_on_cpu: use for drivers/acpi/processor_throttling.c
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@redhat.com>
Message-Id: <20090318042218.32769DDF3D@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: don't play with current's cpumask

It's generally a very bad idea to mug some process's cpumask: it could
legitimately and reasonably be changed by root, which could break us
(if done before our code) or them (if we restore the wrong value).

So we use work_on_cpu in two places instead of cpumask games.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/acpi/processor_throttling.c |   72 ++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 40 deletions(-)

diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -829,32 +829,22 @@ static int acpi_processor_get_throttling
 	return 0;
 }
 
+static long get_throttling(void *_pr)
+{
+	struct acpi_processor *pr = _pr;
+
+	return pr->throttling.acpi_processor_get_throttling(pr);
+}
+
 static int acpi_processor_get_throttling(struct acpi_processor *pr)
 {
-	cpumask_var_t saved_mask;
-	int ret;
-
 	if (!pr)
 		return -EINVAL;
 
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
+	return work_on_cpu(pr->id, get_throttling, pr);
 }
 
 static int acpi_processor_get_fadt_info(struct acpi_processor *pr)
@@ -995,9 +985,22 @@ static int acpi_processor_set_throttling
 	return 0;
 }
 
+struct set_throttling_info {
+	struct acpi_processor *pr;
+	struct acpi_processor_throttling *p_throttling;
+	int target_state;
+};
+
+static long set_throttling(void *_sti)
+{
+	struct set_throttling_info *s = _sti;
+
+	return s->p_throttling->acpi_processor_set_throttling(s->pr,
+							      s->target_state);
+}
+
 int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 {
-	cpumask_var_t saved_mask;
 	int ret = 0;
 	unsigned int i;
 	struct acpi_processor *match_pr;
@@ -1014,15 +1017,9 @@ int acpi_processor_set_throttling(struct
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
@@ -1044,10 +1041,9 @@ int acpi_processor_set_throttling(struct
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		/* FIXME: use work_on_cpu() */
-		set_cpus_allowed_ptr(current, cpumask_of(pr->id));
-		ret = p_throttling->acpi_processor_set_throttling(pr,
-						t_state.target_state);
+		struct set_throttling_info sti
+			= { pr, p_throttling, t_state.target_state };
+		ret = work_on_cpu(pr->id, set_throttling, &sti);
 	} else {
 		/*
 		 * When the T-state coordination is SW_ALL or HW_ALL,
@@ -1055,6 +1051,8 @@ int acpi_processor_set_throttling(struct
 		 * cpus.
 		 */
 		for_each_cpu(i, online_throttling_cpus) {
+			struct set_throttling_info sti;
+
 			match_pr = per_cpu(processors, i);
 			/*
 			 * If the pointer is invalid, we will report the
@@ -1076,11 +1074,10 @@ int acpi_processor_set_throttling(struct
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
+			ret = work_on_cpu(i, set_throttling, &sti);
 		}
 	}
 	/*
@@ -1094,11 +1091,6 @@ int acpi_processor_set_throttling(struct
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
 

