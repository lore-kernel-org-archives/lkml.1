Return-Path: <linux-kernel-owner+w=401wt.eu-S1763751AbZAUIrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763751AbZAUIrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 03:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932104AbZAUIqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 03:46:38 -0500
Received: from hera.kernel.org ([140.211.167.34]:38075 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932082AbZAUIqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 03:46:37 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/10] x86: merge irq_regs.h
Date: Wed, 21 Jan 2009 17:46:14 +0900
Message-Id: <1232527578-1960-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232527578-1960-1-git-send-email-tj@kernel.org>
References: <1232527578-1960-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 21 Jan 2009 08:46:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

Impact: cleanup, better irq_regs code generation for x86_64

Make 64-bit use the same optimizations as 32-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/irq_regs.h    |   36 +++++++++++++++++++++++++++++++-----
 arch/x86/include/asm/irq_regs_32.h |   31 -------------------------------
 arch/x86/include/asm/irq_regs_64.h |    1 -
 arch/x86/kernel/irq_64.c           |    3 +++
 4 files changed, 34 insertions(+), 37 deletions(-)
 delete mode 100644 arch/x86/include/asm/irq_regs_32.h
 delete mode 100644 arch/x86/include/asm/irq_regs_64.h

diff --git a/arch/x86/include/asm/irq_regs.h b/arch/x86/include/asm/irq_regs.h
index 89c898a..7784322 100644
--- a/arch/x86/include/asm/irq_regs.h
+++ b/arch/x86/include/asm/irq_regs.h
@@ -1,5 +1,31 @@
-#ifdef CONFIG_X86_32
-# include "irq_regs_32.h"
-#else
-# include "irq_regs_64.h"
-#endif
+/*
+ * Per-cpu current frame pointer - the location of the last exception frame on
+ * the stack, stored in the per-cpu area.
+ *
+ * Jeremy Fitzhardinge <jeremy@goop.org>
+ */
+#ifndef _ASM_X86_IRQ_REGS_H
+#define _ASM_X86_IRQ_REGS_H
+
+#include <asm/percpu.h>
+
+#define ARCH_HAS_OWN_IRQ_REGS
+
+DECLARE_PER_CPU(struct pt_regs *, irq_regs);
+
+static inline struct pt_regs *get_irq_regs(void)
+{
+	return percpu_read(irq_regs);
+}
+
+static inline struct pt_regs *set_irq_regs(struct pt_regs *new_regs)
+{
+	struct pt_regs *old_regs;
+
+	old_regs = get_irq_regs();
+	percpu_write(irq_regs, new_regs);
+
+	return old_regs;
+}
+
+#endif /* _ASM_X86_IRQ_REGS_32_H */
diff --git a/arch/x86/include/asm/irq_regs_32.h b/arch/x86/include/asm/irq_regs_32.h
deleted file mode 100644
index d7ed33e..0000000
--- a/arch/x86/include/asm/irq_regs_32.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * Per-cpu current frame pointer - the location of the last exception frame on
- * the stack, stored in the per-cpu area.
- *
- * Jeremy Fitzhardinge <jeremy@goop.org>
- */
-#ifndef _ASM_X86_IRQ_REGS_32_H
-#define _ASM_X86_IRQ_REGS_32_H
-
-#include <asm/percpu.h>
-
-#define ARCH_HAS_OWN_IRQ_REGS
-
-DECLARE_PER_CPU(struct pt_regs *, irq_regs);
-
-static inline struct pt_regs *get_irq_regs(void)
-{
-	return percpu_read(irq_regs);
-}
-
-static inline struct pt_regs *set_irq_regs(struct pt_regs *new_regs)
-{
-	struct pt_regs *old_regs;
-
-	old_regs = get_irq_regs();
-	percpu_write(irq_regs, new_regs);
-
-	return old_regs;
-}
-
-#endif /* _ASM_X86_IRQ_REGS_32_H */
diff --git a/arch/x86/include/asm/irq_regs_64.h b/arch/x86/include/asm/irq_regs_64.h
deleted file mode 100644
index 3dd9c0b..0000000
--- a/arch/x86/include/asm/irq_regs_64.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <asm-generic/irq_regs.h>
diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
index 1db0524..0b254de 100644
--- a/arch/x86/kernel/irq_64.c
+++ b/arch/x86/kernel/irq_64.c
@@ -22,6 +22,9 @@
 DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
 
+DEFINE_PER_CPU(struct pt_regs *, irq_regs);
+EXPORT_PER_CPU_SYMBOL(irq_regs);
+
 /*
  * Probabilistic stack overflow check:
  *
-- 
1.6.0.2

