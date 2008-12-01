Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbYLAI2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbYLAI2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 03:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYLAI2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 03:28:09 -0500
Received: from ozlabs.org ([203.10.76.45]:51520 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbYLAI2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 03:28:08 -0500
To: Len Brown <lenb@kernel.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 18:57:57 +1030
Subject: [PATCH 1/1] work_on_cpu: use for drivers/acpi/processor_throttling.c
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812011858.01745.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use work_on_cpu in two places instead of cpumask games.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/acpi/processor_throttling.c |   54 ++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff -r 6f4737048b99 drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c	Thu Oct 23 00:06:30 2008 +1100
+++ b/drivers/acpi/processor_throttling.c	Thu Oct 23 00:20:57 2008 +1100
@@ -824,26 +824,22 @@ static int acpi_processor_get_throttling
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
-	cpumask_t saved_mask;
-	int ret;
-
 	if (!pr)
 		return -EINVAL;
 
 	if (!pr->flags.throttling)
 		return -ENODEV;
-	/*
-	 * Migrate task to the cpu pointed by pr.
-	 */
-	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
-	ret = pr->throttling.acpi_processor_get_throttling(pr);
-	/* restore the previous state */
-	set_cpus_allowed_ptr(current, &saved_mask);
 
-	return ret;
+	return work_on_cpu(pr->id, get_throttling, pr);
 }
 
 static int acpi_processor_get_fadt_info(struct acpi_processor *pr)
@@ -984,9 +980,22 @@ static int acpi_processor_set_throttling
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
-	cpumask_t saved_mask;
 	int ret = 0;
 	unsigned int i;
 	struct acpi_processor *match_pr;
@@ -1003,7 +1012,6 @@ int acpi_processor_set_throttling(struct
 	if ((state < 0) || (state > (pr->throttling.state_count - 1)))
 		return -EINVAL;
 
-	saved_mask = current->cpus_allowed;
 	t_state.target_state = state;
 	p_throttling = &(pr->throttling);
 	cpus_and(online_throttling_cpus, cpu_online_map,
@@ -1025,9 +1033,9 @@ int acpi_processor_set_throttling(struct
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
-		ret = p_throttling->acpi_processor_set_throttling(pr,
-						t_state.target_state);
+		struct set_throttling_info sti
+			= { pr, p_throttling, t_state.target_state };
+		ret = work_on_cpu(pr->id, set_throttling, &sti);
 	} else {
 		/*
 		 * When the T-state coordination is SW_ALL or HW_ALL,
@@ -1035,6 +1043,8 @@ int acpi_processor_set_throttling(struct
 		 * cpus.
 		 */
 		for_each_cpu_mask_nr(i, online_throttling_cpus) {
+			struct set_throttling_info sti;
+
 			match_pr = per_cpu(processors, i);
 			/*
 			 * If the pointer is invalid, we will report the
@@ -1056,10 +1066,10 @@ int acpi_processor_set_throttling(struct
 				continue;
 			}
 			t_state.cpu = i;
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
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
@@ -1073,8 +1083,6 @@ int acpi_processor_set_throttling(struct
 		acpi_processor_throttling_notifier(THROTTLING_POSTCHANGE,
 							&t_state);
 	}
-	/* restore the previous state */
-	set_cpus_allowed_ptr(current, &saved_mask);
 	return ret;
 }
 


