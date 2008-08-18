Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbYHRKdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbYHRKdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbYHRKd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:33:27 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:41821 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYHRKd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:33:26 -0400
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       michael@free-electrons.com, thomas.petazzoni@free-electrons.com
Subject: [PATCH] [x86] Move cmpxchg fallbacks to a generic place
Date: Mon, 18 Aug 2008 12:33:21 +0200
Message-Id: <1219055602-8046-2-git-send-email-thomas.petazzoni@free-electrons.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
In-Reply-To: <20080815143843.GA519@elte.hu>
References: <20080815143843.GA519@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/cpu/intel.c defines a few fallback functions
(cmpxchg_*()) that are used when the CPU doesn't support cmpxchg
and/or cmpxchg64 natively. However, while defined in an Intel-specific
file, these functions are also used for CPUs from other vendors when
they don't support cmpxchg and/or cmpxchg64. This breaks the
compilation when support for Intel CPUs is disabled.

This patch moves these functions to a new
arch/x86/kernel/cpu/cmpxchg.c file, unconditionally compiled when
X86_32 is enabled.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
---
 arch/x86/kernel/cpu/Makefile  |    2 +-
 arch/x86/kernel/cpu/cmpxchg.c |   72 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/intel.c   |   64 ------------------------------------
 3 files changed, 73 insertions(+), 65 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/cmpxchg.c

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a35ee92..a0fc6c1 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -5,7 +5,7 @@
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o feature_names.o
 
-obj-$(CONFIG_X86_32)	+= common.o bugs.o
+obj-$(CONFIG_X86_32)	+= common.o bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= common_64.o bugs_64.o
 
 obj-$(CONFIG_CPU_SUP_AMD_32)		+= amd.o
diff --git a/arch/x86/kernel/cpu/cmpxchg.c b/arch/x86/kernel/cpu/cmpxchg.c
new file mode 100644
index 0000000..2056ccf
--- /dev/null
+++ b/arch/x86/kernel/cpu/cmpxchg.c
@@ -0,0 +1,72 @@
+/*
+ * cmpxchg*() fallbacks for CPU not supporting these instructions
+ */
+
+#include <linux/kernel.h>
+#include <linux/smp.h>
+#include <linux/module.h>
+
+#ifndef CONFIG_X86_CMPXCHG
+unsigned long cmpxchg_386_u8(volatile void *ptr, u8 old, u8 new)
+{
+	u8 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u8 *)ptr;
+	if (prev == old)
+		*(u8 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_386_u8);
+
+unsigned long cmpxchg_386_u16(volatile void *ptr, u16 old, u16 new)
+{
+	u16 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u16 *)ptr;
+	if (prev == old)
+		*(u16 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_386_u16);
+
+unsigned long cmpxchg_386_u32(volatile void *ptr, u32 old, u32 new)
+{
+	u32 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u32 *)ptr;
+	if (prev == old)
+		*(u32 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_386_u32);
+#endif
+
+#ifndef CONFIG_X86_CMPXCHG64
+unsigned long long cmpxchg_486_u64(volatile void *ptr, u64 old, u64 new)
+{
+	u64 prev;
+	unsigned long flags;
+
+	/* Poor man's cmpxchg8b for 386 and 486. Unsuitable for SMP */
+	local_irq_save(flags);
+	prev = *(u64 *)ptr;
+	if (prev == old)
+		*(u64 *)ptr = new;
+	local_irq_restore(flags);
+	return prev;
+}
+EXPORT_SYMBOL(cmpxchg_486_u64);
+#endif
+
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5c8959b..77618c7 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -307,69 +307,5 @@ static struct cpu_dev intel_cpu_dev __cpuinitdata = {
 
 cpu_vendor_dev_register(X86_VENDOR_INTEL, &intel_cpu_dev);
 
-#ifndef CONFIG_X86_CMPXCHG
-unsigned long cmpxchg_386_u8(volatile void *ptr, u8 old, u8 new)
-{
-	u8 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u8 *)ptr;
-	if (prev == old)
-		*(u8 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u8);
-
-unsigned long cmpxchg_386_u16(volatile void *ptr, u16 old, u16 new)
-{
-	u16 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u16 *)ptr;
-	if (prev == old)
-		*(u16 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u16);
-
-unsigned long cmpxchg_386_u32(volatile void *ptr, u32 old, u32 new)
-{
-	u32 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg for 386. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u32 *)ptr;
-	if (prev == old)
-		*(u32 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_386_u32);
-#endif
-
-#ifndef CONFIG_X86_CMPXCHG64
-unsigned long long cmpxchg_486_u64(volatile void *ptr, u64 old, u64 new)
-{
-	u64 prev;
-	unsigned long flags;
-
-	/* Poor man's cmpxchg8b for 386 and 486. Unsuitable for SMP */
-	local_irq_save(flags);
-	prev = *(u64 *)ptr;
-	if (prev == old)
-		*(u64 *)ptr = new;
-	local_irq_restore(flags);
-	return prev;
-}
-EXPORT_SYMBOL(cmpxchg_486_u64);
-#endif
-
 /* arch_initcall(intel_cpu_init); */
 
-- 
1.5.4.3

