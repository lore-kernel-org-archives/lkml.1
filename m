Return-Path: <linux-kernel-owner+w=401wt.eu-S1761545AbZATNRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761545AbZATNRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758314AbZATNPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:15:54 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:20932 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609AbZATNPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:15:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=loMMtAh/i9BagMIxqnXqArIxFWlmLDiCu8Rj4z8Eqz+oZ/zNmAZsBSLZn74NU+y1Sy
         SET4rnrnWyN7tfWsSmScSnXS9SZDnxr9LQ4253SU2Ys/2yHeRssnYOUSYKnUTesH5cS8
         XnG5RTwyo5AQalFhW2fIjX5fNATJQCKCepKJE=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 5/6] x86: Merge hardirq.h
Date: Tue, 20 Jan 2009 08:15:44 -0500
Message-Id: <1232457345-12366-5-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused idle_timestamp field from 32-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/hardirq.h    |   42 ++++++++++++++++++++++++++++++++----
 arch/x86/include/asm/hardirq_32.h |   33 -----------------------------
 arch/x86/include/asm/hardirq_64.h |   39 ----------------------------------
 3 files changed, 37 insertions(+), 77 deletions(-)
 delete mode 100644 arch/x86/include/asm/hardirq_32.h
 delete mode 100644 arch/x86/include/asm/hardirq_64.h

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 000787d..4f77393 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -1,11 +1,43 @@
-#ifdef CONFIG_X86_32
-# include "hardirq_32.h"
-#else
-# include "hardirq_64.h"
-#endif
+#ifndef _ASM_X86_HARDIRQ_H
+#define _ASM_X86_HARDIRQ_H
+
+#include <linux/threads.h>
+#include <linux/irq.h>
+
+typedef struct {
+	unsigned int __softirq_pending;
+	unsigned int __nmi_count;	/* arch dependent */
+	unsigned int apic_timer_irqs;	/* arch dependent */
+	unsigned int irq0_irqs;
+	unsigned int irq_resched_count;
+	unsigned int irq_call_count;
+	unsigned int irq_tlb_count;
+	unsigned int irq_thermal_count;
+	unsigned int irq_spurious_count;
+	unsigned int irq_threshold_count;
+} ____cacheline_aligned irq_cpustat_t;
+
+DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
+
+/* We can have at most NR_VECTORS irqs routed to a cpu at a time */
+#define MAX_HARDIRQS_PER_CPU NR_VECTORS
+
+#define __ARCH_IRQ_STAT
+
+#define inc_irq_stat(member)	percpu_add(irq_stat.member, 1)
+
+#define __ARCH_SET_SOFTIRQ_PENDING 1
+
+#define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
+#define set_softirq_pending(x)	percpu_write(irq_stat.__softirq_pending, (x))
+#define or_softirq_pending(x)	percpu_or(irq_stat.__softirq_pending, (x))
+
+extern void ack_bad_irq(unsigned int irq);
 
 extern u64 arch_irq_stat_cpu(unsigned int cpu);
 #define arch_irq_stat_cpu	arch_irq_stat_cpu
 
 extern u64 arch_irq_stat(void);
 #define arch_irq_stat		arch_irq_stat
+
+#endif /* _ASM_X86_HARDIRQ_H */
diff --git a/arch/x86/include/asm/hardirq_32.h b/arch/x86/include/asm/hardirq_32.h
deleted file mode 100644
index d4b5d73..0000000
--- a/arch/x86/include/asm/hardirq_32.h
+++ /dev/null
@@ -1,33 +0,0 @@
-#ifndef _ASM_X86_HARDIRQ_32_H
-#define _ASM_X86_HARDIRQ_32_H
-
-#include <linux/threads.h>
-#include <linux/irq.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-	unsigned long idle_timestamp;
-	unsigned int __nmi_count;	/* arch dependent */
-	unsigned int apic_timer_irqs;	/* arch dependent */
-	unsigned int irq0_irqs;
-	unsigned int irq_resched_count;
-	unsigned int irq_call_count;
-	unsigned int irq_tlb_count;
-	unsigned int irq_thermal_count;
-	unsigned int irq_spurious_count;
-} ____cacheline_aligned irq_cpustat_t;
-
-DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
-
-/* We can have at most NR_VECTORS irqs routed to a cpu at a time */
-#define MAX_HARDIRQS_PER_CPU NR_VECTORS
-
-#define __ARCH_IRQ_STAT
-#define __IRQ_STAT(cpu, member) (per_cpu(irq_stat, cpu).member)
-
-#define inc_irq_stat(member)	(__get_cpu_var(irq_stat).member++)
-
-void ack_bad_irq(unsigned int irq);
-#include <linux/irq_cpustat.h>
-
-#endif /* _ASM_X86_HARDIRQ_32_H */
diff --git a/arch/x86/include/asm/hardirq_64.h b/arch/x86/include/asm/hardirq_64.h
deleted file mode 100644
index a65bab2..0000000
--- a/arch/x86/include/asm/hardirq_64.h
+++ /dev/null
@@ -1,39 +0,0 @@
-#ifndef _ASM_X86_HARDIRQ_64_H
-#define _ASM_X86_HARDIRQ_64_H
-
-#include <linux/threads.h>
-#include <linux/irq.h>
-#include <asm/apic.h>
-
-typedef struct {
-	unsigned int __softirq_pending;
-	unsigned int __nmi_count;	/* arch dependent */
-	unsigned int apic_timer_irqs;	/* arch dependent */
-	unsigned int irq0_irqs;
-	unsigned int irq_resched_count;
-	unsigned int irq_call_count;
-	unsigned int irq_tlb_count;
-	unsigned int irq_thermal_count;
-	unsigned int irq_spurious_count;
-	unsigned int irq_threshold_count;
-} ____cacheline_aligned irq_cpustat_t;
-
-DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
-
-/* We can have at most NR_VECTORS irqs routed to a cpu at a time */
-#define MAX_HARDIRQS_PER_CPU NR_VECTORS
-
-#define __ARCH_IRQ_STAT 1
-
-#define inc_irq_stat(member)	percpu_add(irq_stat.member, 1)
-
-#define local_softirq_pending() percpu_read(irq_stat.__softirq_pending)
-
-#define __ARCH_SET_SOFTIRQ_PENDING 1
-
-#define set_softirq_pending(x) percpu_write(irq_stat.__softirq_pending, (x))
-#define or_softirq_pending(x)  percpu_or(irq_stat.__softirq_pending, (x))
-
-extern void ack_bad_irq(unsigned int irq);
-
-#endif /* _ASM_X86_HARDIRQ_64_H */
-- 
1.6.1

