Return-Path: <linux-kernel-owner+w=401wt.eu-S1751001AbZCFF1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001AbZCFF1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 00:27:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZCFFYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 00:24:06 -0500
Received: from ozlabs.org ([203.10.76.45]:35498 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZCFFX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 00:23:59 -0500
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 05 Mar 2009 17:27:23 +1030
Subject: [PATCH 2/10] use smp_call_function_single() in arch/x86/kernel/acpi/cstate.c
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20090306052355.03F38DDF61@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Attempting to rid us of the problematic work_on_cpu().  Just use
smp_call_function_single() here.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/acpi/cstate.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff -puN arch/x86/kernel/acpi/cstate.c~arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu arch/x86/kernel/acpi/cstate.c
--- a/arch/x86/kernel/acpi/cstate.c~arch-x86-kernel-acpi-cstatec-avoid-using-work_on_cpu
+++ a/arch/x86/kernel/acpi/cstate.c
@@ -61,6 +61,12 @@ struct cstate_entry {
 };
 static struct cstate_entry *cpu_cstate_entry;	/* per CPU ptr */
 
+/* Used for the cross-CPU calls */
+struct acpi_processor_cx_cross_cpu {
+	struct acpi_processor_cx *cx;
+	long retval;
+};
+
 static short mwait_supported[ACPI_PROCESSOR_MAX_POWER];
 
 #define MWAIT_SUBSTATE_MASK	(0xf)
@@ -75,10 +81,10 @@ static short mwait_supported[ACPI_PROCES
 
 #define NATIVE_CSTATE_BEYOND_HALT	(2)
 
-static long acpi_processor_ffh_cstate_probe_cpu(void *_cx)
+static void acpi_processor_ffh_cstate_probe_cpu(void *_cxcc)
 {
-	struct acpi_processor_cx *cx = _cx;
-	long retval;
+	struct acpi_processor_cx_cross_cpu *cxcc = _cxcc;
+	struct acpi_processor_cx *cx = cxcc->cx;
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int edx_part;
 	unsigned int cstate_type; /* C-state type and not ACPI C-state type */
@@ -92,16 +98,16 @@ static long acpi_processor_ffh_cstate_pr
 	edx_part = edx >> (cstate_type * MWAIT_SUBSTATE_SIZE);
 	num_cstate_subtype = edx_part & MWAIT_SUBSTATE_MASK;
 
-	retval = 0;
+	cxcc->retval = 0;
 	if (num_cstate_subtype < (cx->address & MWAIT_SUBSTATE_MASK)) {
-		retval = -1;
+		cxcc->retval = -1;
 		goto out;
 	}
 
 	/* mwait ecx extensions INTERRUPT_BREAK should be supported for C2/C3 */
 	if (!(ecx & CPUID5_ECX_EXTENSIONS_SUPPORTED) ||
 	    !(ecx & CPUID5_ECX_INTERRUPT_BREAK)) {
-		retval = -1;
+		cxcc->retval = -1;
 		goto out;
 	}
 
@@ -115,7 +121,7 @@ static long acpi_processor_ffh_cstate_pr
 			ACPI_CX_DESC_LEN, "ACPI FFH INTEL MWAIT 0x%x",
 			cx->address);
 out:
-	return retval;
+	return;
 }
 
 int acpi_processor_ffh_cstate_probe(unsigned int cpu,
@@ -123,6 +129,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 {
 	struct cstate_entry *percpu_entry;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	struct acpi_processor_cx_cross_cpu cxcc = { .cx = cx, };
 	long retval;
 
 	if (!cpu_cstate_entry || c->cpuid_level < CPUID_MWAIT_LEAF)
@@ -135,13 +142,18 @@ int acpi_processor_ffh_cstate_probe(unsi
 	percpu_entry->states[cx->index].eax = 0;
 	percpu_entry->states[cx->index].ecx = 0;
 
-	/* Make sure we are running on right CPU */
+	/* Run acpi_processor_ffh_cstate_probe_cpu() on the target CPU */
 
-	retval = work_on_cpu(cpu, acpi_processor_ffh_cstate_probe_cpu, cx);
+	retval = smp_call_function_single(cpu,
+				acpi_processor_ffh_cstate_probe_cpu, cx, 1);
 	if (retval == 0) {
-		/* Use the hint in CST */
-		percpu_entry->states[cx->index].eax = cx->address;
-		percpu_entry->states[cx->index].ecx = MWAIT_ECX_INTERRUPT_BREAK;
+		retval = cxcc.retval;
+		if (retval == 0) {
+			/* Use the hint in CST */
+			percpu_entry->states[cx->index].eax = cx->address;
+			percpu_entry->states[cx->index].ecx =
+					MWAIT_ECX_INTERRUPT_BREAK;
+		}
 	}
 	return retval;
 }
_

