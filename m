Return-Path: <linux-kernel-owner+w=401wt.eu-S1762255AbZATNRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255AbZATNRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:17:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758730AbZATNPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:15:55 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:22949 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758131AbZATNPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:15:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fjRZgZsjAud4nlHiYHLrFRZCkGyhb2s4ep2nUQFLpzBREOLX4S29YF27AUcjSx4sH3
         ccSrTmYlym1hyr2yXHaLlz32QKmuR2eFrRhhVOriCJ9QSgUFAyCUTCmqd3SEaJmIg2f+
         FhYmREyG4XEePXHbvOavXWSYChK2WMOrvPe6E=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Brian Gerst <brgerst@gmail.com>
Subject: [PATCH 6/6] x86: Merge irq_regs.h
Date: Tue, 20 Jan 2009 08:15:45 -0500
Message-Id: <1232457345-12366-6-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make 64-bit use the same optimizations as 32-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
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
1.6.1

