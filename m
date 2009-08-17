Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbZHQMni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbZHQMni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 08:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753829AbZHQMnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 08:43:37 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:61638 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbZHQMng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 08:43:36 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org
Subject: [PATCH 1/2] ACPI processor: force throttling state when BIOS returns incorrect value
Date: Mon, 17 Aug 2009 14:43:34 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, lenb@intel.com,
       rui.zhang@intel.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908171443.35622.elendil@planet.nl>
X-OriginalArrivalTime: 17 Aug 2009 12:43:36.0588 (UTC) FILETIME=[56A6C4C0:01CA1F38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the BIOS reports an invalid throttling state (which seems to be
fairly common after system boot), a reset is done to state T0.
Because of a check in acpi_processor_get_throttling_ptc(), the reset
never actually gets executed, which results in the error reoccurring
on every access of for example /proc/acpi/processor/CPU0/throttling.

Add a 'force' option to acpi_processor_set_throttling() to ensure
the reset really takes effect.

http://bugzilla.kernel.org/show_bug.cgi?id=13389

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Zhang Rui <rui.zhang@intel.com>
---

This patch, together with the next one, fixes a regression introduced in
2.6.30, listed on the regression list. They have been available for 2.5
months now in bugzilla, but have not been picked up, despite various
reminders and without any reason given.

Google shows that numerous people are hitting this issue. The issue is in
itself relatively minor, but the bug in the code is clear.

The patches have been in all mu kernels and today testing has shown that
throttling works correctly with the patches applied when the system
overheats (http://bugzilla.kernel.org/show_bug.cgi?id=13918#c14).

Cheers,
FJP

diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index 39838c6..31adda1 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -66,7 +66,7 @@ static int acpi_processor_apply_limit(struct acpi_processor *pr)
 		if (pr->limit.thermal.tx > tx)
 			tx = pr->limit.thermal.tx;
 
-		result = acpi_processor_set_throttling(pr, tx);
+		result = acpi_processor_set_throttling(pr, tx, false);
 		if (result)
 			goto end;
 	}
@@ -421,12 +421,12 @@ processor_set_cur_state(struct thermal_cooling_device *cdev,
 
 	if (state <= max_pstate) {
 		if (pr->flags.throttling && pr->throttling.state)
-			result = acpi_processor_set_throttling(pr, 0);
+			result = acpi_processor_set_throttling(pr, 0, false);
 		cpufreq_set_cur_state(pr->id, state);
 	} else {
 		cpufreq_set_cur_state(pr->id, max_pstate);
 		result = acpi_processor_set_throttling(pr,
-				state - max_pstate);
+				state - max_pstate, false);
 	}
 	return result;
 }
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 2275437..841be4e 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -62,7 +62,8 @@ struct throttling_tstate {
 #define THROTTLING_POSTCHANGE      (2)
 
 static int acpi_processor_get_throttling(struct acpi_processor *pr);
-int acpi_processor_set_throttling(struct acpi_processor *pr, int state);
+int acpi_processor_set_throttling(struct acpi_processor *pr,
+						int state, bool force);
 
 static int acpi_processor_update_tsd_coord(void)
 {
@@ -361,7 +362,7 @@ int acpi_processor_tstate_has_changed(struct acpi_processor *pr)
 		 */
 		target_state = throttling_limit;
 	}
-	return acpi_processor_set_throttling(pr, target_state);
+	return acpi_processor_set_throttling(pr, target_state, false);
 }
 
 /*
@@ -842,7 +843,7 @@ static int acpi_processor_get_throttling_ptc(struct acpi_processor *pr)
 			ACPI_WARNING((AE_INFO,
 				"Invalid throttling state, reset"));
 			state = 0;
-			ret = acpi_processor_set_throttling(pr, state);
+			ret = acpi_processor_set_throttling(pr, state, true);
 			if (ret)
 				return ret;
 		}
@@ -915,7 +916,7 @@ static int acpi_processor_get_fadt_info(struct acpi_processor *pr)
 }
 
 static int acpi_processor_set_throttling_fadt(struct acpi_processor *pr,
-					      int state)
+					      int state, bool force)
 {
 	u32 value = 0;
 	u32 duty_mask = 0;
@@ -930,7 +931,7 @@ static int acpi_processor_set_throttling_fadt(struct acpi_processor *pr,
 	if (!pr->flags.throttling)
 		return -ENODEV;
 
-	if (state == pr->throttling.state)
+	if (!force && (state == pr->throttling.state))
 		return 0;
 
 	if (state < pr->throttling_platform_limit)
@@ -988,7 +989,7 @@ static int acpi_processor_set_throttling_fadt(struct acpi_processor *pr,
 }
 
 static int acpi_processor_set_throttling_ptc(struct acpi_processor *pr,
-					     int state)
+					     int state, bool force)
 {
 	int ret;
 	acpi_integer value;
@@ -1002,7 +1003,7 @@ static int acpi_processor_set_throttling_ptc(struct acpi_processor *pr,
 	if (!pr->flags.throttling)
 		return -ENODEV;
 
-	if (state == pr->throttling.state)
+	if (!force && (state == pr->throttling.state))
 		return 0;
 
 	if (state < pr->throttling_platform_limit)
@@ -1018,7 +1019,8 @@ static int acpi_processor_set_throttling_ptc(struct acpi_processor *pr,
 	return 0;
 }
 
-int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
+int acpi_processor_set_throttling(struct acpi_processor *pr,
+						int state, bool force)
 {
 	cpumask_var_t saved_mask;
 	int ret = 0;
@@ -1070,7 +1072,7 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 		/* FIXME: use work_on_cpu() */
 		set_cpus_allowed_ptr(current, cpumask_of(pr->id));
 		ret = p_throttling->acpi_processor_set_throttling(pr,
-						t_state.target_state);
+						t_state.target_state, force);
 	} else {
 		/*
 		 * When the T-state coordination is SW_ALL or HW_ALL,
@@ -1103,7 +1105,7 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 			set_cpus_allowed_ptr(current, cpumask_of(i));
 			ret = match_pr->throttling.
 				acpi_processor_set_throttling(
-				match_pr, t_state.target_state);
+				match_pr, t_state.target_state, force);
 		}
 	}
 	/*
@@ -1201,7 +1203,7 @@ int acpi_processor_get_throttling_info(struct acpi_processor *pr)
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Disabling throttling (was T%d)\n",
 				  pr->throttling.state));
-		result = acpi_processor_set_throttling(pr, 0);
+		result = acpi_processor_set_throttling(pr, 0, false);
 		if (result)
 			goto end;
 	}
@@ -1307,7 +1309,7 @@ static ssize_t acpi_processor_write_throttling(struct file *file,
 	if (strcmp(tmpbuf, charp) != 0)
 		return -EINVAL;
 
-	result = acpi_processor_set_throttling(pr, state_val);
+	result = acpi_processor_set_throttling(pr, state_val, false);
 	if (result)
 		return result;
 
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index baf1e0a..740ac3a 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -174,7 +174,7 @@ struct acpi_processor_throttling {
 	cpumask_var_t shared_cpu_map;
 	int (*acpi_processor_get_throttling) (struct acpi_processor * pr);
 	int (*acpi_processor_set_throttling) (struct acpi_processor * pr,
-					      int state);
+					      int state, bool force);
 
 	u32 address;
 	u8 duty_offset;
@@ -321,7 +321,8 @@ static inline int acpi_processor_ppc_has_changed(struct acpi_processor *pr)
 /* in processor_throttling.c */
 int acpi_processor_tstate_has_changed(struct acpi_processor *pr);
 int acpi_processor_get_throttling_info(struct acpi_processor *pr);
-extern int acpi_processor_set_throttling(struct acpi_processor *pr, int state);
+extern int acpi_processor_set_throttling(struct acpi_processor *pr,
+					 int state, bool force);
 extern const struct file_operations acpi_processor_throttling_fops;
 extern void acpi_processor_throttling_init(void);
 /* in processor_idle.c */
