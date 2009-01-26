Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbZAZGRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbZAZGRJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZAZGPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:15:42 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:35843 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369AbZAZGPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:15:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fPAg1mRi5VoNh6vnR6ncT6MVvxhIs+2YSO78boplIbm1uu+UkpeRRqDKFivzi7VHPE
         sfuFNZQ4X03wBzB04MoCHsr3xV4ltoRb/bEyPvKYeuuCyNf8YBfweFI5oTf0wDCi+1/E
         uLwW5kTrdxQFTIiDhp6wLlYV+3R5vk6K5lT/I=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/12] x86: Move apic variables to apic.c
Date: Mon, 26 Jan 2009 01:15:25 -0500
Message-Id: <1232950532-22923-5-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
References: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Code movement

Move the variable definitions to apic.c.  Ifdef the copying of
the two early per-cpu variables, since Voyager doesn't use them.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/apic.c         |   18 ++++++++++++++++++
 arch/x86/kernel/setup_percpu.c |   22 ++--------------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 1df341a..c6f1564 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -60,6 +60,24 @@
 # error SPURIOUS_APIC_VECTOR definition error
 #endif
 
+unsigned int num_processors;
+unsigned disabled_cpus __cpuinitdata;
+/* Processor that is doing the boot up */
+unsigned int boot_cpu_physical_apicid = -1U;
+EXPORT_SYMBOL(boot_cpu_physical_apicid);
+unsigned int max_physical_apicid;
+
+/* Bitmask of physically existing CPUs */
+physid_mask_t phys_cpu_present_map;
+
+/*
+ * Map cpu index to physical APIC ID
+ */
+DEFINE_EARLY_PER_CPU(u16, x86_cpu_to_apicid, BAD_APICID);
+DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid, BAD_APICID);
+EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
+EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
+
 #ifdef CONFIG_X86_32
 /*
  * Knob to control our willingness to enable the local APIC.
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 5d4a496..d367996 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -31,26 +31,6 @@ DEFINE_PER_CPU(int, cpu_number);
 EXPORT_PER_CPU_SYMBOL(cpu_number);
 #endif
 
-#ifdef CONFIG_X86_LOCAL_APIC
-unsigned int num_processors;
-unsigned disabled_cpus __cpuinitdata;
-/* Processor that is doing the boot up */
-unsigned int boot_cpu_physical_apicid = -1U;
-EXPORT_SYMBOL(boot_cpu_physical_apicid);
-unsigned int max_physical_apicid;
-
-/* Bitmask of physically existing CPUs */
-physid_mask_t phys_cpu_present_map;
-#endif
-
-/*
- * Map cpu index to physical APIC ID
- */
-DEFINE_EARLY_PER_CPU(u16, x86_cpu_to_apicid, BAD_APICID);
-DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid, BAD_APICID);
-EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
-EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
-
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 
 #ifdef CONFIG_X86_64
@@ -108,10 +88,12 @@ void __init setup_per_cpu_areas(void)
 		 * per cpu data areas.  These arrays then become expendable and the
 		 * *_early_ptr's are zeroed indicating that the static arrays are gone.
 		 */
+#ifdef CONFIG_X86_LOCAL_APIC
 		per_cpu(x86_cpu_to_apicid, cpu) =
 				early_per_cpu_map(x86_cpu_to_apicid, cpu);
 		per_cpu(x86_bios_cpu_apicid, cpu) =
 				early_per_cpu_map(x86_bios_cpu_apicid, cpu);
+#endif
 #ifdef CONFIG_X86_64
 		per_cpu(irq_stack_ptr, cpu) =
 			per_cpu(irq_stack_union.irq_stack, cpu) + IRQ_STACK_SIZE - 64;
-- 
1.6.1

