Return-Path: <linux-kernel-owner+w=401wt.eu-S1760079AbZADNU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079AbZADNU7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 08:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbZADNSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 08:18:16 -0500
Received: from relay1.sgi.com ([192.48.179.29]:54024 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751475AbZADNSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 08:18:09 -0500
Message-Id: <20090104131800.967154000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Sun, 04 Jan 2009 05:18:07 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Dave Jones <davej@redhat.com>
Subject: [PATCH 08/11] cpumask: use work_on_cpu in acpi/cstate.c
References: <20090104131759.865331000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=cpumask:use-work_on_cpu-in-acpi_cstate.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce stack usage, use new cpumask API.

Replace the saving of current->cpus_allowed and set_cpus_allowed_ptr() with
a work_on_cpu function for the acpi_processor_ffh_cstate_probe() function.

Basically splits acpi_processor_ffh_cstate_probe() into two functions, the
other being acpi_processor_ffh_cstate_probe_cpu which is the work function
run on the designated cpu.

Signed-off-by: Mike Travis <travis@sgi.com>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Jones <davej@redhat.com>
---
 arch/x86/kernel/acpi/cstate.c |   70 ++++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 33 deletions(-)

--- linux-2.6-for-ingo.orig/arch/x86/kernel/acpi/cstate.c
+++ linux-2.6-for-ingo/arch/x86/kernel/acpi/cstate.c
@@ -66,35 +66,15 @@ static short mwait_supported[ACPI_PROCES
 
 #define NATIVE_CSTATE_BEYOND_HALT	(2)
 
-int acpi_processor_ffh_cstate_probe(unsigned int cpu,
-		struct acpi_processor_cx *cx, struct acpi_power_register *reg)
+static long acpi_processor_ffh_cstate_probe_cpu(void *_cx)
 {
-	struct cstate_entry *percpu_entry;
-	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
-	cpumask_t saved_mask;
-	int retval;
+	struct acpi_processor_cx *cx = _cx;
+	long retval;
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int edx_part;
 	unsigned int cstate_type; /* C-state type and not ACPI C-state type */
 	unsigned int num_cstate_subtype;
 
-	if (!cpu_cstate_entry || c->cpuid_level < CPUID_MWAIT_LEAF )
-		return -1;
-
-	if (reg->bit_offset != NATIVE_CSTATE_BEYOND_HALT)
-		return -1;
-
-	percpu_entry = per_cpu_ptr(cpu_cstate_entry, cpu);
-	percpu_entry->states[cx->index].eax = 0;
-	percpu_entry->states[cx->index].ecx = 0;
-
-	/* Make sure we are running on right CPU */
-	saved_mask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
-	if (retval)
-		return -1;
-
 	cpuid(CPUID_MWAIT_LEAF, &eax, &ebx, &ecx, &edx);
 
 	/* Check whether this particular cx_type (in CST) is supported or not */
@@ -114,21 +94,45 @@ int acpi_processor_ffh_cstate_probe(unsi
 		retval = -1;
 		goto out;
 	}
-	percpu_entry->states[cx->index].ecx = MWAIT_ECX_INTERRUPT_BREAK;
-
-	/* Use the hint in CST */
-	percpu_entry->states[cx->index].eax = cx->address;
 
 	if (!mwait_supported[cstate_type]) {
 		mwait_supported[cstate_type] = 1;
-		printk(KERN_DEBUG "Monitor-Mwait will be used to enter C-%d "
-		       "state\n", cx->type);
+		printk(KERN_DEBUG
+			"Monitor-Mwait will be used to enter C-%d "
+			"state\n", cx->type);
 	}
-	snprintf(cx->desc, ACPI_CX_DESC_LEN, "ACPI FFH INTEL MWAIT 0x%x",
-		 cx->address);
-
+	snprintf(cx->desc,
+			ACPI_CX_DESC_LEN, "ACPI FFH INTEL MWAIT 0x%x",
+			cx->address);
 out:
-	set_cpus_allowed_ptr(current, &saved_mask);
+	return retval;
+}
+
+int acpi_processor_ffh_cstate_probe(unsigned int cpu,
+		struct acpi_processor_cx *cx, struct acpi_power_register *reg)
+{
+	struct cstate_entry *percpu_entry;
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
+	long retval;
+
+	if (!cpu_cstate_entry || c->cpuid_level < CPUID_MWAIT_LEAF)
+		return -1;
+
+	if (reg->bit_offset != NATIVE_CSTATE_BEYOND_HALT)
+		return -1;
+
+	percpu_entry = per_cpu_ptr(cpu_cstate_entry, cpu);
+	percpu_entry->states[cx->index].eax = 0;
+	percpu_entry->states[cx->index].ecx = 0;
+
+	/* Make sure we are running on right CPU */
+
+	retval = work_on_cpu(cpu, acpi_processor_ffh_cstate_probe_cpu, cx);
+	if (retval == 0) {
+		/* Use the hint in CST */
+		percpu_entry->states[cx->index].eax = cx->address;
+		percpu_entry->states[cx->index].ecx = MWAIT_ECX_INTERRUPT_BREAK;
+	}
 	return retval;
 }
 EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);

