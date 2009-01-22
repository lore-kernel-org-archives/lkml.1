Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZAVNes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZAVNes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754743AbZAVNdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:33:38 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:23575 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbZAVNdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:33:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=A1EB+HYmJLTl3lLZL/0kYVc1+VRJNj0Ls2i9SFjfMy4JLdjwfdflqfOG7qhwSNH/4d
         cX+JORgc2My3MI4Ss0F5Q3GrbjeICxD1J616s8eID/1t1sTMEYgy3xwt2EihBphePaLh
         bFtMhprulnZ4Hl6PGjZkrvfPeRLqYPOijVPsI=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 4/5] x86: Merge hardirq_{32,64}.h into hardirq.h
Date: Thu, 22 Jan 2009 08:33:37 -0500
Message-Id: <1232631218-5092-4-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com>
References: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/hardirq.h    |   43 ++++++++++++++++++++++++++++++++----
 arch/x86/include/asm/hardirq_32.h |   38 --------------------------------
 arch/x86/include/asm/hardirq_64.h |   38 --------------------------------
 3 files changed, 38 insertions(+), 81 deletions(-)
 delete mode 100644 arch/x86/include/asm/hardirq_32.h
 delete mode 100644 arch/x86/include/asm/hardirq_64.h

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 000787d..f4a95f2 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -1,11 +1,44 @@
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
+#define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
+
+#define __ARCH_SET_SOFTIRQ_PENDING
+
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
index e5a332c..0000000
--- a/arch/x86/include/asm/hardirq_32.h
+++ /dev/null
@@ -1,38 +0,0 @@
-#ifndef _ASM_X86_HARDIRQ_32_H
-#define _ASM_X86_HARDIRQ_32_H
-
-#include <linux/threads.h>
-#include <linux/irq.h>
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
-#define __ARCH_IRQ_STAT
-
-#define inc_irq_stat(member)	percpu_add(irq_stat.member, 1)
-
-#define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
-
-#define __ARCH_SET_SOFTIRQ_PENDING
-
-#define set_softirq_pending(x)	percpu_write(irq_stat.__softirq_pending, (x))
-#define or_softirq_pending(x)	percpu_or(irq_stat.__softirq_pending, (x))
-
-extern void ack_bad_irq(unsigned int irq);
-
-#endif /* _ASM_X86_HARDIRQ_32_H */
diff --git a/arch/x86/include/asm/hardirq_64.h b/arch/x86/include/asm/hardirq_64.h
deleted file mode 100644
index 392e7d6..0000000
--- a/arch/x86/include/asm/hardirq_64.h
+++ /dev/null
@@ -1,38 +0,0 @@
-#ifndef _ASM_X86_HARDIRQ_64_H
-#define _ASM_X86_HARDIRQ_64_H
-
-#include <linux/threads.h>
-#include <linux/irq.h>
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
-#define __ARCH_IRQ_STAT
-
-#define inc_irq_stat(member)	percpu_add(irq_stat.member, 1)
-
-#define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
-
-#define __ARCH_SET_SOFTIRQ_PENDING
-
-#define set_softirq_pending(x)	percpu_write(irq_stat.__softirq_pending, (x))
-#define or_softirq_pending(x)	percpu_or(irq_stat.__softirq_pending, (x))
-
-extern void ack_bad_irq(unsigned int irq);
-
-#endif /* _ASM_X86_HARDIRQ_64_H */
-- 
1.6.1

