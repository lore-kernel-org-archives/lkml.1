Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbZAVNe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbZAVNe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 08:34:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbZAVNdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 08:33:37 -0500
Received: from rv-out-0506.google.com ([209.85.198.239]:23575 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318AbZAVNdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 08:33:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GuRai7vf7txSDeST9EaK8Khs+Ym5lE6uwKmFBUuNnBqBAAQBJrTfmnS/la+/Opzo1G
         b/DdP1wEuNURVgr8LK7NM4SwECSIjdqQIrg1v1P0V5PCTWL8srZEf3TQsX4fSDaKZW7T
         d8z96ijXbpUl9L+Q1+GGwiJFBNHarLieJNbwo=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 3/5] x86: Sync hardirq_{32,64}.h
Date: Thu, 22 Jan 2009 08:33:36 -0500
Message-Id: <1232631218-5092-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com>
References: <73c1f2160901220533n53cdbb33q2eec14d47176533d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general, use the 64-bit version.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/hardirq_32.h |   14 ++++++++++----
 arch/x86/include/asm/hardirq_64.h |   10 +++++-----
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/hardirq_32.h b/arch/x86/include/asm/hardirq_32.h
index a70ed05..e5a332c 100644
--- a/arch/x86/include/asm/hardirq_32.h
+++ b/arch/x86/include/asm/hardirq_32.h
@@ -14,6 +14,7 @@ typedef struct {
 	unsigned int irq_tlb_count;
 	unsigned int irq_thermal_count;
 	unsigned int irq_spurious_count;
+	unsigned int irq_threshold_count;
 } ____cacheline_aligned irq_cpustat_t;
 
 DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
@@ -22,11 +23,16 @@ DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
 #define MAX_HARDIRQS_PER_CPU NR_VECTORS
 
 #define __ARCH_IRQ_STAT
-#define __IRQ_STAT(cpu, member) (per_cpu(irq_stat, cpu).member)
 
-#define inc_irq_stat(member)	(__get_cpu_var(irq_stat).member++)
+#define inc_irq_stat(member)	percpu_add(irq_stat.member, 1)
 
-void ack_bad_irq(unsigned int irq);
-#include <linux/irq_cpustat.h>
+#define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
+
+#define __ARCH_SET_SOFTIRQ_PENDING
+
+#define set_softirq_pending(x)	percpu_write(irq_stat.__softirq_pending, (x))
+#define or_softirq_pending(x)	percpu_or(irq_stat.__softirq_pending, (x))
+
+extern void ack_bad_irq(unsigned int irq);
 
 #endif /* _ASM_X86_HARDIRQ_32_H */
diff --git a/arch/x86/include/asm/hardirq_64.h b/arch/x86/include/asm/hardirq_64.h
index 873c3c7..392e7d6 100644
--- a/arch/x86/include/asm/hardirq_64.h
+++ b/arch/x86/include/asm/hardirq_64.h
@@ -22,16 +22,16 @@ DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
 /* We can have at most NR_VECTORS irqs routed to a cpu at a time */
 #define MAX_HARDIRQS_PER_CPU NR_VECTORS
 
-#define __ARCH_IRQ_STAT 1
+#define __ARCH_IRQ_STAT
 
 #define inc_irq_stat(member)	percpu_add(irq_stat.member, 1)
 
-#define local_softirq_pending() percpu_read(irq_stat.__softirq_pending)
+#define local_softirq_pending()	percpu_read(irq_stat.__softirq_pending)
 
-#define __ARCH_SET_SOFTIRQ_PENDING 1
+#define __ARCH_SET_SOFTIRQ_PENDING
 
-#define set_softirq_pending(x) percpu_write(irq_stat.__softirq_pending, (x))
-#define or_softirq_pending(x)  percpu_or(irq_stat.__softirq_pending, (x))
+#define set_softirq_pending(x)	percpu_write(irq_stat.__softirq_pending, (x))
+#define or_softirq_pending(x)	percpu_or(irq_stat.__softirq_pending, (x))
 
 extern void ack_bad_irq(unsigned int irq);
 
-- 
1.6.1

