Return-Path: <linux-kernel-owner+w=401wt.eu-S1760974AbYCCRTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974AbYCCRTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754243AbYCCROh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:14:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758955AbYCCROg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:14:36 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, mingo@elte.hu,
       tglx@linutronix.de, Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 14/52] move prefill_possible_map to common file
Date: Mon,  3 Mar 2008 14:12:42 -0300
Message-Id: <1204564400-17636-15-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204564400-17636-14-git-send-email-gcosta@redhat.com>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
 <1204564400-17636-2-git-send-email-gcosta@redhat.com>
 <1204564400-17636-3-git-send-email-gcosta@redhat.com>
 <1204564400-17636-4-git-send-email-gcosta@redhat.com>
 <1204564400-17636-5-git-send-email-gcosta@redhat.com>
 <1204564400-17636-6-git-send-email-gcosta@redhat.com>
 <1204564400-17636-7-git-send-email-gcosta@redhat.com>
 <1204564400-17636-8-git-send-email-gcosta@redhat.com>
 <1204564400-17636-9-git-send-email-gcosta@redhat.com>
 <1204564400-17636-10-git-send-email-gcosta@redhat.com>
 <1204564400-17636-11-git-send-email-gcosta@redhat.com>
 <1204564400-17636-12-git-send-email-gcosta@redhat.com>
 <1204564400-17636-13-git-send-email-gcosta@redhat.com>
 <1204564400-17636-14-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patches moves prefill_possible_map() to smpboot.c
Right now it is x86_64-specific, but nothing intrinsically
prevents it to be used by i386

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/Makefile     |    2 +-
 arch/x86/kernel/smpboot.c    |   53 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/smpboot_64.c |   51 ----------------------------------------
 include/asm-x86/smp.h        |    1 +
 include/asm-x86/smp_64.h     |    1 -
 5 files changed, 55 insertions(+), 53 deletions(-)
 create mode 100644 arch/x86/kernel/smpboot.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index df10327..4c68bfc 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -46,7 +46,7 @@ obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 apm-y				:= apm_32.o
 obj-$(CONFIG_APM)		+= apm.o
-obj-$(CONFIG_X86_SMP)		+= smp_$(BITS).o smpboot_$(BITS).o tsc_sync.o
+obj-$(CONFIG_X86_SMP)		+= smp_$(BITS).o smpboot_$(BITS).o smpboot.o tsc_sync.o
 obj-$(CONFIG_X86_32_SMP)	+= smpcommon_32.o
 obj-$(CONFIG_X86_64_SMP)	+= smp_64.o smpboot_64.o tsc_sync.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline_$(BITS).o
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
new file mode 100644
index 0000000..bffe108
--- /dev/null
+++ b/arch/x86/kernel/smpboot.c
@@ -0,0 +1,53 @@
+#include <linux/init.h>
+#include <linux/smp.h>
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+int additional_cpus __initdata = -1;
+
+static __init int setup_additional_cpus(char *s)
+{
+	return s && get_option(&s, &additional_cpus) ? 0 : -EINVAL;
+}
+early_param("additional_cpus", setup_additional_cpus);
+
+/*
+ * cpu_possible_map should be static, it cannot change as cpu's
+ * are onlined, or offlined. The reason is per-cpu data-structures
+ * are allocated by some modules at init time, and dont expect to
+ * do this dynamically on cpu arrival/departure.
+ * cpu_present_map on the other hand can change dynamically.
+ * In case when cpu_hotplug is not compiled, then we resort to current
+ * behaviour, which is cpu_possible == cpu_present.
+ * - Ashok Raj
+ *
+ * Three ways to find out the number of additional hotplug CPUs:
+ * - If the BIOS specified disabled CPUs in ACPI/mptables use that.
+ * - The user can overwrite it with additional_cpus=NUM
+ * - Otherwise don't reserve additional CPUs.
+ * We do this because additional CPUs waste a lot of memory.
+ * -AK
+ */
+__init void prefill_possible_map(void)
+{
+	int i;
+	int possible;
+
+	if (additional_cpus == -1) {
+		if (disabled_cpus > 0)
+			additional_cpus = disabled_cpus;
+		else
+			additional_cpus = 0;
+	}
+	possible = num_processors + additional_cpus;
+	if (possible > NR_CPUS)
+		possible = NR_CPUS;
+
+	printk(KERN_INFO "SMP: Allowing %d CPUs, %d hotplug CPUs\n",
+		possible, max_t(int, possible - num_processors, 0));
+
+	for (i = 0; i < possible; i++)
+		cpu_set(i, cpu_possible_map);
+}
+#endif
+
diff --git a/arch/x86/kernel/smpboot_64.c b/arch/x86/kernel/smpboot_64.c
index fd0d3a9..953b0ff 100644
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -749,51 +749,6 @@ static __init void disable_smp(void)
 	cpu_set(0, per_cpu(cpu_core_map, 0));
 }
 
-#ifdef CONFIG_HOTPLUG_CPU
-
-int additional_cpus __initdata = -1;
-
-/*
- * cpu_possible_map should be static, it cannot change as cpu's
- * are onlined, or offlined. The reason is per-cpu data-structures
- * are allocated by some modules at init time, and dont expect to
- * do this dynamically on cpu arrival/departure.
- * cpu_present_map on the other hand can change dynamically.
- * In case when cpu_hotplug is not compiled, then we resort to current
- * behaviour, which is cpu_possible == cpu_present.
- * - Ashok Raj
- *
- * Three ways to find out the number of additional hotplug CPUs:
- * - If the BIOS specified disabled CPUs in ACPI/mptables use that.
- * - The user can overwrite it with additional_cpus=NUM
- * - Otherwise don't reserve additional CPUs.
- * We do this because additional CPUs waste a lot of memory.
- * -AK
- */
-__init void prefill_possible_map(void)
-{
-	int i;
-	int possible;
-
- 	if (additional_cpus == -1) {
- 		if (disabled_cpus > 0)
- 			additional_cpus = disabled_cpus;
- 		else
-			additional_cpus = 0;
- 	}
-	possible = num_processors + additional_cpus;
-	if (possible > NR_CPUS) 
-		possible = NR_CPUS;
-
-	printk(KERN_INFO "SMP: Allowing %d CPUs, %d hotplug CPUs\n",
-		possible,
-	        max_t(int, possible - num_processors, 0));
-
-	for (i = 0; i < possible; i++)
-		cpu_set(i, cpu_possible_map);
-}
-#endif
-
 /*
  * Various sanity checks.
  */
@@ -1087,12 +1042,6 @@ void __cpu_die(unsigned int cpu)
  	printk(KERN_ERR "CPU %u didn't die...\n", cpu);
 }
 
-static __init int setup_additional_cpus(char *s)
-{
-	return s && get_option(&s, &additional_cpus) ? 0 : -EINVAL;
-}
-early_param("additional_cpus", setup_additional_cpus);
-
 #else /* ... !CONFIG_HOTPLUG_CPU */
 
 int __cpu_disable(void)
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index be8a511..28cb1f8 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -63,6 +63,7 @@ void native_smp_cpus_done(unsigned int max_cpus);
 int native_cpu_up(unsigned int cpunum);
 
 extern unsigned disabled_cpus;
+extern void prefill_possible_map(void);
 #endif
 
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index c7a00ca..e5bc1be 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -43,7 +43,6 @@ static inline int cpu_present_to_apicid(int mps_cpu)
 
 extern int __cpu_disable(void);
 extern void __cpu_die(unsigned int cpu);
-extern void prefill_possible_map(void);
 
 #define raw_smp_processor_id()	read_pda(cpunumber)
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
-- 
1.5.0.6

