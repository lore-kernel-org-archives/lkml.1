Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbYAJHhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbYAJHhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 02:37:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYAJHhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 02:37:00 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:57018 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbYAJHg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 02:36:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uaLuGDlruGLUyPrPK+OmMYQk29fwrYtXoLDhYz3cW6mUvchIB/kf3QiR6UdPdeQH9cVUCvTOMy+ZPctQRPE9Wl7oInQlBQClKV76lBumhicRvQ9uhpuo7HWBgUOIewv/ptP6sLKt2Pe9LHsfOQaVWo0YUltC0SVLoNYLNLK3NsQ=
Subject: [PATCH] x86: Move get_segment_eip() to step.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 09 Jan 2008 23:36:54 -0800
Message-Id: <1199950614.19760.16.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_segment_eip has similarities to convert_rip_to_linear(),
and is used in a similar context.  Move get_segment_eip to
step.c to allow easier consolidation.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Ingo, you may want to fold this into my previous patch:

x86: begin fault_{32|64}.c unification

it was a mistake to add the 32-bit version to X86_64 when it
could be moved to step.c, I'll follow along with a bit of
factoring of get_segment_eip and convert_rip_to_linear.  This
should allow elimination of many (all?) of the nasty #ifdefs in
fault_32|64.c in is_prefetch().

 arch/x86/kernel/step.c   |   81 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/fault_32.c   |   77 -------------------------------------------
 arch/x86/mm/fault_64.c   |   77 -------------------------------------------
 include/asm-x86/ptrace.h |    2 +
 4 files changed, 83 insertions(+), 154 deletions(-)

diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index d73c537..bf7819e 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -6,6 +6,87 @@
 #include <linux/ptrace.h>
 
 #ifdef CONFIG_X86_32
+#include <linux/uaccess.h>
+
+#include <asm/desc.h>
+
+/*
+ * Return EIP plus the CS segment base.  The segment limit is also
+ * adjusted, clamped to the kernel/user address space (whichever is
+ * appropriate), and returned in *eip_limit.
+ *
+ * The segment is checked, because it might have been changed by another
+ * task between the original faulting instruction and here.
+ *
+ * If CS is no longer a valid code segment, or if EIP is beyond the
+ * limit, or if it is a kernel address when CS is not a kernel segment,
+ * then the returned value will be greater than *eip_limit.
+ *
+ * This is slow, but is very rarely executed.
+ */
+unsigned long get_segment_eip(struct pt_regs *regs,
+					    unsigned long *eip_limit)
+{
+	unsigned long ip = regs->ip;
+	unsigned seg = regs->cs & 0xffff;
+	u32 seg_ar, seg_limit, base, *desc;
+
+	/* Unlikely, but must come before segment checks. */
+	if (unlikely(regs->flags & VM_MASK)) {
+		base = seg << 4;
+		*eip_limit = base + 0xffff;
+		return base + (ip & 0xffff);
+	}
+
+	/* The standard kernel/user address space limit. */
+	*eip_limit = user_mode(regs) ? USER_DS.seg : KERNEL_DS.seg;
+
+	/* By far the most common cases. */
+	if (likely(SEGMENT_IS_FLAT_CODE(seg)))
+		return ip;
+
+	/* Check the segment exists, is within the current LDT/GDT size,
+	   that kernel/user (ring 0..3) has the appropriate privilege,
+	   that it's a code segment, and get the limit. */
+	__asm__("larl %3,%0; lsll %3,%1"
+		 : "=&r" (seg_ar), "=r" (seg_limit) : "0" (0), "rm" (seg));
+	if ((~seg_ar & 0x9800) || ip > seg_limit) {
+		*eip_limit = 0;
+		return 1;	 /* So that returned ip > *eip_limit. */
+	}
+
+	/* Get the GDT/LDT descriptor base.
+	   When you look for races in this code remember that
+	   LDT and other horrors are only used in user space. */
+	if (seg & (1<<2)) {
+		/* Must lock the LDT while reading it. */
+		mutex_lock(&current->mm->context.lock);
+		desc = current->mm->context.ldt;
+		desc = (void *)desc + (seg & ~7);
+	} else {
+		/* Must disable preemption while reading the GDT. */
+		desc = (u32 *)get_cpu_gdt_table(get_cpu());
+		desc = (void *)desc + (seg & ~7);
+	}
+
+	/* Decode the code segment base from the descriptor */
+	base = get_desc_base((struct desc_struct *)desc);
+
+	if (seg & (1<<2))
+		mutex_unlock(&current->mm->context.lock);
+	else
+		put_cpu();
+
+	/* Adjust EIP and segment limit, and clamp at the kernel limit.
+	   It's legitimate for segments to wrap at 0xffffffff. */
+	seg_limit += base;
+	if (seg_limit < *eip_limit && seg_limit >= base)
+		*eip_limit = seg_limit;
+	return ip + base;
+}
+#endif
+
+#ifdef CONFIG_X86_32
 static
 #endif
 unsigned long convert_rip_to_linear(struct task_struct *child, struct pt_regs *regs)
diff --git a/arch/x86/mm/fault_32.c b/arch/x86/mm/fault_32.c
index 50a9930..2caf5bc 100644
--- a/arch/x86/mm/fault_32.c
+++ b/arch/x86/mm/fault_32.c
@@ -61,83 +61,6 @@ static inline int notify_page_fault(struct pt_regs *regs)
 #endif
 }
 
-#ifdef CONFIG_X86_32
-/*
- * Return EIP plus the CS segment base.  The segment limit is also
- * adjusted, clamped to the kernel/user address space (whichever is
- * appropriate), and returned in *eip_limit.
- *
- * The segment is checked, because it might have been changed by another
- * task between the original faulting instruction and here.
- *
- * If CS is no longer a valid code segment, or if EIP is beyond the
- * limit, or if it is a kernel address when CS is not a kernel segment,
- * then the returned value will be greater than *eip_limit.
- *
- * This is slow, but is very rarely executed.
- */
-static inline unsigned long get_segment_eip(struct pt_regs *regs,
-					    unsigned long *eip_limit)
-{
-	unsigned long ip = regs->ip;
-	unsigned seg = regs->cs & 0xffff;
-	u32 seg_ar, seg_limit, base, *desc;
-
-	/* Unlikely, but must come before segment checks. */
-	if (unlikely(regs->flags & VM_MASK)) {
-		base = seg << 4;
-		*eip_limit = base + 0xffff;
-		return base + (ip & 0xffff);
-	}
-
-	/* The standard kernel/user address space limit. */
-	*eip_limit = user_mode(regs) ? USER_DS.seg : KERNEL_DS.seg;
-
-	/* By far the most common cases. */
-	if (likely(SEGMENT_IS_FLAT_CODE(seg)))
-		return ip;
-
-	/* Check the segment exists, is within the current LDT/GDT size,
-	   that kernel/user (ring 0..3) has the appropriate privilege,
-	   that it's a code segment, and get the limit. */
-	__asm__ ("larl %3,%0; lsll %3,%1"
-		 : "=&r" (seg_ar), "=r" (seg_limit) : "0" (0), "rm" (seg));
-	if ((~seg_ar & 0x9800) || ip > seg_limit) {
-		*eip_limit = 0;
-		return 1;	 /* So that returned ip > *eip_limit. */
-	}
-
-	/* Get the GDT/LDT descriptor base.
-	   When you look for races in this code remember that
-	   LDT and other horrors are only used in user space. */
-	if (seg & (1<<2)) {
-		/* Must lock the LDT while reading it. */
-		mutex_lock(&current->mm->context.lock);
-		desc = current->mm->context.ldt;
-		desc = (void *)desc + (seg & ~7);
-	} else {
-		/* Must disable preemption while reading the GDT. */
-		desc = (u32 *)get_cpu_gdt_table(get_cpu());
-		desc = (void *)desc + (seg & ~7);
-	}
-
-	/* Decode the code segment base from the descriptor */
-	base = get_desc_base((struct desc_struct *)desc);
-
-	if (seg & (1<<2))
-		mutex_unlock(&current->mm->context.lock);
-	else
-		put_cpu();
-
-	/* Adjust EIP and segment limit, and clamp at the kernel limit.
-	   It's legitimate for segments to wrap at 0xffffffff. */
-	seg_limit += base;
-	if (seg_limit < *eip_limit && seg_limit >= base)
-		*eip_limit = seg_limit;
-	return ip + base;
-}
-#endif
-
 /*
  * X86_32
  * Sometimes AMD Athlon/Opteron CPUs report invalid exceptions on prefetch.
diff --git a/arch/x86/mm/fault_64.c b/arch/x86/mm/fault_64.c
index f681ff8..d866d19 100644
--- a/arch/x86/mm/fault_64.c
+++ b/arch/x86/mm/fault_64.c
@@ -64,83 +64,6 @@ static inline int notify_page_fault(struct pt_regs *regs)
 #endif
 }
 
-#ifdef CONFIG_X86_32
-/*
- * Return EIP plus the CS segment base.  The segment limit is also
- * adjusted, clamped to the kernel/user address space (whichever is
- * appropriate), and returned in *eip_limit.
- *
- * The segment is checked, because it might have been changed by another
- * task between the original faulting instruction and here.
- *
- * If CS is no longer a valid code segment, or if EIP is beyond the
- * limit, or if it is a kernel address when CS is not a kernel segment,
- * then the returned value will be greater than *eip_limit.
- *
- * This is slow, but is very rarely executed.
- */
-static inline unsigned long get_segment_eip(struct pt_regs *regs,
-					    unsigned long *eip_limit)
-{
-	unsigned long ip = regs->ip;
-	unsigned seg = regs->cs & 0xffff;
-	u32 seg_ar, seg_limit, base, *desc;
-
-	/* Unlikely, but must come before segment checks. */
-	if (unlikely(regs->flags & VM_MASK)) {
-		base = seg << 4;
-		*eip_limit = base + 0xffff;
-		return base + (ip & 0xffff);
-	}
-
-	/* The standard kernel/user address space limit. */
-	*eip_limit = user_mode(regs) ? USER_DS.seg : KERNEL_DS.seg;
-
-	/* By far the most common cases. */
-	if (likely(SEGMENT_IS_FLAT_CODE(seg)))
-		return ip;
-
-	/* Check the segment exists, is within the current LDT/GDT size,
-	   that kernel/user (ring 0..3) has the appropriate privilege,
-	   that it's a code segment, and get the limit. */
-	__asm__("larl %3,%0; lsll %3,%1"
-		 : "=&r" (seg_ar), "=r" (seg_limit) : "0" (0), "rm" (seg));
-	if ((~seg_ar & 0x9800) || ip > seg_limit) {
-		*eip_limit = 0;
-		return 1;	 /* So that returned ip > *eip_limit. */
-	}
-
-	/* Get the GDT/LDT descriptor base.
-	   When you look for races in this code remember that
-	   LDT and other horrors are only used in user space. */
-	if (seg & (1<<2)) {
-		/* Must lock the LDT while reading it. */
-		mutex_lock(&current->mm->context.lock);
-		desc = current->mm->context.ldt;
-		desc = (void *)desc + (seg & ~7);
-	} else {
-		/* Must disable preemption while reading the GDT. */
-		desc = (u32 *)get_cpu_gdt_table(get_cpu());
-		desc = (void *)desc + (seg & ~7);
-	}
-
-	/* Decode the code segment base from the descriptor */
-	base = get_desc_base((struct desc_struct *)desc);
-
-	if (seg & (1<<2))
-		mutex_unlock(&current->mm->context.lock);
-	else
-		put_cpu();
-
-	/* Adjust EIP and segment limit, and clamp at the kernel limit.
-	   It's legitimate for segments to wrap at 0xffffffff. */
-	seg_limit += base;
-	if (seg_limit < *eip_limit && seg_limit >= base)
-		*eip_limit = seg_limit;
-	return ip + base;
-}
-#endif
-
 /*
  * X86_32
  * Sometimes AMD Athlon/Opteron CPUs report invalid exceptions on prefetch.
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 61946fe..cc44566 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -184,6 +184,8 @@ convert_rip_to_linear(struct task_struct *child, struct pt_regs *regs);
 
 #ifdef __KERNEL__
 
+unsigned long get_segment_eip(struct pt_regs *regs, unsigned long *eip_limit);
+
 /*
  * These are defined as per linux/ptrace.h, which see.
  */
-- 
1.5.4.rc2.1164.g6451

