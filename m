Return-Path: <linux-kernel-owner+w=401wt.eu-S1763352AbZA2AQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763352AbZA2AQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 19:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758755AbZA1Xqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:46:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:53256 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758744AbZA1XqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:46:24 -0500
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 080/114] x86, smp: remove mach_ipi.h
Date: Wed, 28 Jan 2009 23:42:26 +0000
Message-Id: <1233186180-29883-81-git-send-email-mingo@elte.hu>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1233186180-29883-1-git-send-email-mingo@elte.hu>
References: <1233186180-29883-1-git-send-email-mingo@elte.hu>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 28 Jan 2009 23:46:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move mach_ipi.h definitions into genapic.h.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/genapic.h                   |    1 +
 arch/x86/include/asm/ipi.h                       |   61 +++++++++++++++++++++-
 arch/x86/include/asm/mach-default/mach_ipi.h     |   58 --------------------
 arch/x86/include/asm/mach-generic/gpio.h         |   15 -----
 arch/x86/include/asm/mach-generic/mach_ipi.h     |    6 --
 arch/x86/include/asm/mach-generic/mach_wakecpu.h |    4 --
 arch/x86/kernel/apic.c                           |    2 +-
 arch/x86/kernel/crash.c                          |    2 +-
 arch/x86/kernel/io_apic.c                        |    1 -
 arch/x86/kernel/ipi.c                            |    1 -
 arch/x86/kernel/kgdb.c                           |    2 +-
 arch/x86/kernel/reboot.c                         |    2 +-
 arch/x86/kernel/smp.c                            |    1 -
 arch/x86/kernel/visws_quirks.c                   |    2 +-
 arch/x86/mach-default/setup.c                    |    2 +-
 arch/x86/mach-generic/default.c                  |    2 +-
 arch/x86/mm/tlb.c                                |    2 +-
 17 files changed, 68 insertions(+), 96 deletions(-)
 delete mode 100644 arch/x86/include/asm/mach-default/mach_ipi.h
 delete mode 100644 arch/x86/include/asm/mach-generic/gpio.h
 delete mode 100644 arch/x86/include/asm/mach-generic/mach_ipi.h
 delete mode 100644 arch/x86/include/asm/mach-generic/mach_wakecpu.h

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index ce3655a..4bbcf26 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -259,4 +259,5 @@ static inline physid_mask_t default_apicid_to_cpu_present(int phys_apicid)
 }
 
 #endif /* CONFIG_X86_LOCAL_APIC */
+
 #endif /* _ASM_X86_GENAPIC_64_H */
diff --git a/arch/x86/include/asm/ipi.h b/arch/x86/include/asm/ipi.h
index a8d717f..e2e8e4e 100644
--- a/arch/x86/include/asm/ipi.h
+++ b/arch/x86/include/asm/ipi.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_IPI_H
 #define _ASM_X86_IPI_H
 
+#ifdef CONFIG_X86_LOCAL_APIC
+
 /*
  * Copyright 2004 James Cleverdon, IBM.
  * Subject to the GNU Public License, v.2
@@ -56,8 +58,7 @@ static inline void __xapic_wait_icr_idle(void)
 }
 
 static inline void
-__default_send_IPI_shortcut(unsigned int shortcut,
-			    int vector, unsigned int dest)
+__default_send_IPI_shortcut(unsigned int shortcut, int vector, unsigned int dest)
 {
 	/*
 	 * Subtle. In the case of the 'never do double writes' workaround
@@ -156,4 +157,60 @@ default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 	local_irq_restore(flags);
 }
 
+
+/* Avoid include hell */
+#define NMI_VECTOR 0x02
+
+void default_send_IPI_mask_bitmask(const struct cpumask *mask, int vector);
+void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
+
+extern int no_broadcast;
+
+#ifdef CONFIG_X86_64
+#include <asm/genapic.h>
+#else
+static inline void default_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	default_send_IPI_mask_bitmask(mask, vector);
+}
+void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
+#endif
+
+static inline void __default_local_send_IPI_allbutself(int vector)
+{
+	if (no_broadcast || vector == NMI_VECTOR)
+		apic->send_IPI_mask_allbutself(cpu_online_mask, vector);
+	else
+		__default_send_IPI_shortcut(APIC_DEST_ALLBUT, vector, apic->dest_logical);
+}
+
+static inline void __default_local_send_IPI_all(int vector)
+{
+	if (no_broadcast || vector == NMI_VECTOR)
+		apic->send_IPI_mask(cpu_online_mask, vector);
+	else
+		__default_send_IPI_shortcut(APIC_DEST_ALLINC, vector, apic->dest_logical);
+}
+
+#ifdef CONFIG_X86_32
+static inline void default_send_IPI_allbutself(int vector)
+{
+	/*
+	 * if there are no other CPUs in the system then we get an APIC send 
+	 * error if we try to broadcast, thus avoid sending IPIs in this case.
+	 */
+	if (!(num_online_cpus() > 1))
+		return;
+
+	__default_local_send_IPI_allbutself(vector);
+}
+
+static inline void default_send_IPI_all(int vector)
+{
+	__default_local_send_IPI_all(vector);
+}
+#endif
+
+#endif
+
 #endif /* _ASM_X86_IPI_H */
diff --git a/arch/x86/include/asm/mach-default/mach_ipi.h b/arch/x86/include/asm/mach-default/mach_ipi.h
deleted file mode 100644
index 85dec63..0000000
--- a/arch/x86/include/asm/mach-default/mach_ipi.h
+++ /dev/null
@@ -1,58 +0,0 @@
-#ifndef _ASM_X86_MACH_DEFAULT_MACH_IPI_H
-#define _ASM_X86_MACH_DEFAULT_MACH_IPI_H
-
-/* Avoid include hell */
-#define NMI_VECTOR 0x02
-
-void default_send_IPI_mask_bitmask(const struct cpumask *mask, int vector);
-void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
-void __default_send_IPI_shortcut(unsigned int shortcut, int vector);
-
-extern int no_broadcast;
-
-#ifdef CONFIG_X86_64
-#include <asm/genapic.h>
-#else
-static inline void default_send_IPI_mask(const struct cpumask *mask, int vector)
-{
-	default_send_IPI_mask_bitmask(mask, vector);
-}
-void default_send_IPI_mask_allbutself(const struct cpumask *mask, int vector);
-#endif
-
-static inline void __default_local_send_IPI_allbutself(int vector)
-{
-	if (no_broadcast || vector == NMI_VECTOR)
-		apic->send_IPI_mask_allbutself(cpu_online_mask, vector);
-	else
-		__default_send_IPI_shortcut(APIC_DEST_ALLBUT, vector);
-}
-
-static inline void __default_local_send_IPI_all(int vector)
-{
-	if (no_broadcast || vector == NMI_VECTOR)
-		apic->send_IPI_mask(cpu_online_mask, vector);
-	else
-		__default_send_IPI_shortcut(APIC_DEST_ALLINC, vector);
-}
-
-#ifdef CONFIG_X86_32
-static inline void default_send_IPI_allbutself(int vector)
-{
-	/*
-	 * if there are no other CPUs in the system then we get an APIC send 
-	 * error if we try to broadcast, thus avoid sending IPIs in this case.
-	 */
-	if (!(num_online_cpus() > 1))
-		return;
-
-	__default_local_send_IPI_allbutself(vector);
-}
-
-static inline void default_send_IPI_all(int vector)
-{
-	__default_local_send_IPI_all(vector);
-}
-#endif
-
-#endif /* _ASM_X86_MACH_DEFAULT_MACH_IPI_H */
diff --git a/arch/x86/include/asm/mach-generic/gpio.h b/arch/x86/include/asm/mach-generic/gpio.h
deleted file mode 100644
index 995c45e..0000000
--- a/arch/x86/include/asm/mach-generic/gpio.h
+++ /dev/null
@@ -1,15 +0,0 @@
-#ifndef _ASM_X86_MACH_GENERIC_GPIO_H
-#define _ASM_X86_MACH_GENERIC_GPIO_H
-
-int gpio_request(unsigned gpio, const char *label);
-void gpio_free(unsigned gpio);
-int gpio_direction_input(unsigned gpio);
-int gpio_direction_output(unsigned gpio, int value);
-int gpio_get_value(unsigned gpio);
-void gpio_set_value(unsigned gpio, int value);
-int gpio_to_irq(unsigned gpio);
-int irq_to_gpio(unsigned irq);
-
-#include <asm-generic/gpio.h>           /* cansleep wrappers */
-
-#endif /* _ASM_X86_MACH_GENERIC_GPIO_H */
diff --git a/arch/x86/include/asm/mach-generic/mach_ipi.h b/arch/x86/include/asm/mach-generic/mach_ipi.h
deleted file mode 100644
index 5691c09..0000000
--- a/arch/x86/include/asm/mach-generic/mach_ipi.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef _ASM_X86_MACH_GENERIC_MACH_IPI_H
-#define _ASM_X86_MACH_GENERIC_MACH_IPI_H
-
-#include <asm/genapic.h>
-
-#endif /* _ASM_X86_MACH_GENERIC_MACH_IPI_H */
diff --git a/arch/x86/include/asm/mach-generic/mach_wakecpu.h b/arch/x86/include/asm/mach-generic/mach_wakecpu.h
deleted file mode 100644
index 0b884c0..0000000
--- a/arch/x86/include/asm/mach-generic/mach_wakecpu.h
+++ /dev/null
@@ -1,4 +0,0 @@
-#ifndef _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
-#define _ASM_X86_MACH_GENERIC_MACH_WAKECPU_H
-
-#endif /* _ASM_X86_MACH_GENERIC_MACH_APIC_H */
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 41a0ba3..81efe86 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -49,7 +49,7 @@
 #include <asm/i8259.h>
 #include <asm/smp.h>
 
-#include <mach_ipi.h>
+#include <asm/genapic.h>
 
 /*
  * Sanity check
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 11b93ca..ad7f2a6 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -28,7 +28,7 @@
 #include <asm/reboot.h>
 #include <asm/virtext.h>
 
-#include <mach_ipi.h>
+#include <asm/genapic.h>
 
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index e0744ea..241a01d 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -62,7 +62,6 @@
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_irq.h>
 
-#include <mach_ipi.h>
 #include <asm/genapic.h>
 
 #define __apicdebuginit(type) static type __init
diff --git a/arch/x86/kernel/ipi.c b/arch/x86/kernel/ipi.c
index 50076d9..0893fa1 100644
--- a/arch/x86/kernel/ipi.c
+++ b/arch/x86/kernel/ipi.c
@@ -20,7 +20,6 @@
 
 #ifdef CONFIG_X86_32
 #include <asm/genapic.h>
-#include <mach_ipi.h>
 
 /*
  * the following functions deal with sending IPIs between CPUs.
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index b62a381..5c4f554 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -46,7 +46,7 @@
 #include <asm/apicdef.h>
 #include <asm/system.h>
 
-#include <mach_ipi.h>
+#include <asm/genapic.h>
 
 /*
  * Put the error code here just in case the user cares:
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 38dace2..32e8f0a 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -24,7 +24,7 @@
 # include <asm/iommu.h>
 #endif
 
-#include <mach_ipi.h>
+#include <asm/genapic.h>
 
 /*
  * Power off function, if any
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 892e7c3..0eb32ae 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -26,7 +26,6 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/proto.h>
-#include <mach_ipi.h>
 #include <asm/genapic.h>
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
index 3bd7f47..4fd646e 100644
--- a/arch/x86/kernel/visws_quirks.c
+++ b/arch/x86/kernel/visws_quirks.c
@@ -32,7 +32,7 @@
 #include <asm/e820.h>
 #include <asm/io.h>
 
-#include <mach_ipi.h>
+#include <asm/genapic.h>
 
 #include <asm/genapic.h>
 
diff --git a/arch/x86/mach-default/setup.c b/arch/x86/mach-default/setup.c
index df167f2..b65ff0b 100644
--- a/arch/x86/mach-default/setup.c
+++ b/arch/x86/mach-default/setup.c
@@ -10,7 +10,7 @@
 #include <asm/e820.h>
 #include <asm/setup.h>
 
-#include <mach_ipi.h>
+#include <asm/genapic.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
 #define DEFAULT_SEND_IPI	(1)
diff --git a/arch/x86/mach-generic/default.c b/arch/x86/mach-generic/default.c
index 7d5123e..d9d44c8 100644
--- a/arch/x86/mach-generic/default.c
+++ b/arch/x86/mach-generic/default.c
@@ -13,7 +13,7 @@
 #include <linux/smp.h>
 #include <linux/init.h>
 #include <asm/genapic.h>
-#include <asm/mach-default/mach_ipi.h>
+#include <asm/ipi.h>
 
 static void default_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 6348e11..14c5af4 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -14,7 +14,7 @@
 DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate)
 			= { &init_mm, 0, };
 
-#include <mach_ipi.h>
+#include <asm/genapic.h>
 /*
  *	Smarter SMP flushing macros.
  *		c/o Linus Torvalds.
-- 
1.6.0.2

