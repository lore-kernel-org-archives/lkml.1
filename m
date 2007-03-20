Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbXCTR7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbXCTR7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbXCTR73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:59:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:50599 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbXCTR72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:59:28 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Date: Tue, 20 Mar 2007 13:57:49 -0400
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Subject: Fwd: [PATCH 7/9] ACPI: Only use IPI on known broken machines (AMD, Dothan/BaniasPentium M)
To: tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Thomas Renninger <trenn@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_eCCAG/I6lnA42CF"
Message-Id: <200703201357.50103.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_eCCAG/I6lnA42CF
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Thomas/Ingo/Andi/Andrew,
This one in my tree merits your review and comment.

thanks,
-Len


----------  Forwarded Message  ----------

Subject: [PATCH 7/9] ACPI: Only use IPI on known broken machines (AMD, Dothan/BaniasPentium M)
Date: Tuesday 20 March 2007 11:27
From: Len Brown <len.brown@intel.com>
To: linux-acpi@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Len Brown <len.brown@intel.com>

From: Thomas Renninger <trenn@suse.de>

Use IPI for blacklisted CPUs, add parameter IPI vs LAPIC

Currently, Linux disables lapic timer for all machines with C2 and higher
C-state support.

According to Intel only specific Intel models (Banias/Dothan) are broken
in respect of not waking up from C2 with lapic.

However, I am not sure about the naming of the parameter and how it
could/should get integrated into the dyntick part
(CONFIG_GENERIC_CLOCKEVENTS). There, a more fine grained check (TSC
still running?, ..) is needed? Does this make sense (always use
CLOCK_EVT_NOTIFY_BROADCAST_ON, but use OFF if forced by use_ipi=0:
clockevents_notify(use_ipi ? CLOCK_EVT_NOTIFY_BROADCAST_ON :
CLOCK_EVT_NOTIFY_BROADCAST_OFF, &pr->id);

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_idle.c |   38 +++++++++++++++++++++++++++++---------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 6077300..562124e 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -89,6 +89,12 @@ module_param(nocst, uint, 0000);
 static unsigned int bm_history __read_mostly =
     (HZ >= 800 ? 0xFFFFFFFF : ((1U << (HZ / 25)) - 1));
 module_param(bm_history, uint, 0644);
+
+static unsigned use_ipi = 2;
+module_param(use_ipi, uint, 0644);
+MODULE_PARM_DESC(use_ipi, "IPI (vs. LAPIC) irqs for not waking up from C2/C3"
+		 " machines. 0=apic, 1=ipi, 2=auto\n");
+
 /* --------------------------------------------------------------------------
                                 Power Management
    -------------------------------------------------------------------------- */
@@ -260,9 +266,8 @@ static void acpi_cstate_enter(struct acpi_processor_cx *cstate)
 
 /*
  * Some BIOS implementations switch to C3 in the published C2 state.
- * This seems to be a common problem on AMD boxen, but other vendors
- * are affected too. We pick the most conservative approach: we assume
- * that the local APIC stops in both C2 and C3.
+ * This seems to be a common problem on AMD boxen and Intel Dothan/Banias
+ * Pentium M machines.
  */
 static void acpi_timer_check_state(int state, struct acpi_processor *pr,
 				   struct acpi_processor_cx *cx)
@@ -276,8 +281,17 @@ static void acpi_timer_check_state(int state, struct acpi_processor *pr,
 	if (pwr->timer_broadcast_on_state < state)
 		return;
 
-	if (cx->type >= ACPI_STATE_C2)
-		pr->power.timer_broadcast_on_state = state;
+	if (cx->type >= ACPI_STATE_C2) {
+		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+			pr->power.timer_broadcast_on_state = state;
+		else if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+			  boot_cpu_data.x86 == 6) &&
+			 (boot_cpu_data.x86_model == 13 ||
+			  boot_cpu_data.x86_model == 9))
+		{
+			pr->power.timer_broadcast_on_state = state;
+		}
+	}
 }
 
 static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
@@ -292,10 +306,16 @@ static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
 #else
 	cpumask_t mask = cpumask_of_cpu(pr->id);
 
-	if (pr->power.timer_broadcast_on_state < INT_MAX)
+	if (use_ipi == 0)
 		on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1, 1);
-	else
+	else if (use_ipi == 1)
 		on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1, 1);
+	else {
+		if (pr->power.timer_broadcast_on_state < INT_MAX)
+			on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1, 1);
+		else
+			on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1, 1);
+	}
 #endif
 }
 
@@ -1013,13 +1033,13 @@ static int acpi_processor_power_verify(struct acpi_processor *pr)
 
 		case ACPI_STATE_C2:
 			acpi_processor_power_verify_c2(cx);
-			if (cx->valid)
+			if (cx->valid && use_ipi != 0 && use_ipi != 1)
 				acpi_timer_check_state(i, pr, cx);
 			break;
 
 		case ACPI_STATE_C3:
 			acpi_processor_power_verify_c3(pr, cx);
-			if (cx->valid)
+			if (cx->valid && use_ipi != 0 && use_ipi != 1)
 				acpi_timer_check_state(i, pr, cx);
 			break;
 		}
-- 
1.5.0.3.382.g34572
-
To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-------------------------------------------------------

--Boundary-00=_eCCAG/I6lnA42CF
Content-Type: text/plain;
  name="[PATCH 7/9] ACPI: Only use IPI on known broken machines (AMD, Dothan/BaniasPentium M)"
Content-Transfer-Encoding: 7bit

From: Thomas Renninger <trenn@suse.de>

Use IPI for blacklisted CPUs, add parameter IPI vs LAPIC

Currently, Linux disables lapic timer for all machines with C2 and higher
C-state support.

According to Intel only specific Intel models (Banias/Dothan) are broken
in respect of not waking up from C2 with lapic.

However, I am not sure about the naming of the parameter and how it
could/should get integrated into the dyntick part
(CONFIG_GENERIC_CLOCKEVENTS). There, a more fine grained check (TSC
still running?, ..) is needed? Does this make sense (always use
CLOCK_EVT_NOTIFY_BROADCAST_ON, but use OFF if forced by use_ipi=0:
clockevents_notify(use_ipi ? CLOCK_EVT_NOTIFY_BROADCAST_ON :
CLOCK_EVT_NOTIFY_BROADCAST_OFF, &pr->id);

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_idle.c |   38 +++++++++++++++++++++++++++++---------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 6077300..562124e 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -89,6 +89,12 @@ module_param(nocst, uint, 0000);
 static unsigned int bm_history __read_mostly =
     (HZ >= 800 ? 0xFFFFFFFF : ((1U << (HZ / 25)) - 1));
 module_param(bm_history, uint, 0644);
+
+static unsigned use_ipi = 2;
+module_param(use_ipi, uint, 0644);
+MODULE_PARM_DESC(use_ipi, "IPI (vs. LAPIC) irqs for not waking up from C2/C3"
+		 " machines. 0=apic, 1=ipi, 2=auto\n");
+
 /* --------------------------------------------------------------------------
                                 Power Management
    -------------------------------------------------------------------------- */
@@ -260,9 +266,8 @@ static void acpi_cstate_enter(struct acpi_processor_cx *cstate)
 
 /*
  * Some BIOS implementations switch to C3 in the published C2 state.
- * This seems to be a common problem on AMD boxen, but other vendors
- * are affected too. We pick the most conservative approach: we assume
- * that the local APIC stops in both C2 and C3.
+ * This seems to be a common problem on AMD boxen and Intel Dothan/Banias
+ * Pentium M machines.
  */
 static void acpi_timer_check_state(int state, struct acpi_processor *pr,
 				   struct acpi_processor_cx *cx)
@@ -276,8 +281,17 @@ static void acpi_timer_check_state(int state, struct acpi_processor *pr,
 	if (pwr->timer_broadcast_on_state < state)
 		return;
 
-	if (cx->type >= ACPI_STATE_C2)
-		pr->power.timer_broadcast_on_state = state;
+	if (cx->type >= ACPI_STATE_C2) {
+		if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
+			pr->power.timer_broadcast_on_state = state;
+		else if ((boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
+			  boot_cpu_data.x86 == 6) &&
+			 (boot_cpu_data.x86_model == 13 ||
+			  boot_cpu_data.x86_model == 9))
+		{
+			pr->power.timer_broadcast_on_state = state;
+		}
+	}
 }
 
 static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
@@ -292,10 +306,16 @@ static void acpi_propagate_timer_broadcast(struct acpi_processor *pr)
 #else
 	cpumask_t mask = cpumask_of_cpu(pr->id);
 
-	if (pr->power.timer_broadcast_on_state < INT_MAX)
+	if (use_ipi == 0)
 		on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1, 1);
-	else
+	else if (use_ipi == 1)
 		on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1, 1);
+	else {
+		if (pr->power.timer_broadcast_on_state < INT_MAX)
+			on_each_cpu(switch_APIC_timer_to_ipi, &mask, 1, 1);
+		else
+			on_each_cpu(switch_ipi_to_APIC_timer, &mask, 1, 1);
+	}
 #endif
 }
 
@@ -1013,13 +1033,13 @@ static int acpi_processor_power_verify(struct acpi_processor *pr)
 
 		case ACPI_STATE_C2:
 			acpi_processor_power_verify_c2(cx);
-			if (cx->valid)
+			if (cx->valid && use_ipi != 0 && use_ipi != 1)
 				acpi_timer_check_state(i, pr, cx);
 			break;
 
 		case ACPI_STATE_C3:
 			acpi_processor_power_verify_c3(pr, cx);
-			if (cx->valid)
+			if (cx->valid && use_ipi != 0 && use_ipi != 1)
 				acpi_timer_check_state(i, pr, cx);
 			break;
 		}
-- 
1.5.0.3.382.g34572
-
To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Boundary-00=_eCCAG/I6lnA42CF--
