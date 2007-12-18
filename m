Return-Path: <linux-kernel-owner+w=401wt.eu-S1754440AbXLRKgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbXLRKgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 05:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXLRKgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 05:36:41 -0500
Received: from ro-out-1112.google.com ([72.14.202.180]:54844 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbXLRKgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 05:36:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Fg+Xpbb9voZxgb7Vq44q+ge0ob3rwie9Gk927AAosVMS5sk3cLZiquJcTfk3PUXLDXEyLdftkxNHvBOWvWr9/LqtEeypXWYjqlK3rg30ZL8zwwqISAityt0ZK7YNhYqUP/bU3lk5cVpp+cgv1Cc4JgHVVjzliDAl3UFutvRQV1M=
Subject: [PATCH] x86: unify extable_{32|64}.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 02:36:33 -0800
Message-Id: <1197974193.7734.18.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce fixup_exception() on X86_64 and use it in kprobes to
eliminate an #ifdef.

Only X86_64 needs search_extable() due to a stepping bug.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes.c |   12 +--------
 arch/x86/mm/Makefile_32   |    2 +-
 arch/x86/mm/Makefile_64   |    2 +-
 arch/x86/mm/extable.c     |   62 +++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/extable_32.c  |   35 -------------------------
 arch/x86/mm/extable_64.c  |   34 ------------------------
 6 files changed, 65 insertions(+), 82 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 1a0d96d..045a45e 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -902,19 +902,9 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		 * In case the user-specified fault handler returned
 		 * zero, try to fix up.
 		 */
-#ifdef CONFIG_X86_64
-		{
-			const struct exception_table_entry *fixup;
-			fixup = search_exception_tables(regs->ip);
-			if (fixup) {
-				regs->ip = fixup->fixup;
-				return 1;
-			}
-		}
-#else
 		if (fixup_exception(regs))
 			return 1;
-#endif
+
 		/*
 		 * fixup routine could not handle it,
 		 * Let do_page_fault() fix it.
diff --git a/arch/x86/mm/Makefile_32 b/arch/x86/mm/Makefile_32
index a01aca7..6a5e981 100644
--- a/arch/x86/mm/Makefile_32
+++ b/arch/x86/mm/Makefile_32
@@ -2,7 +2,7 @@
 # Makefile for the linux i386-specific parts of the memory manager.
 #
 
-obj-y	:= init_32.o pgtable_32.o fault_32.o ioremap_32.o extable_32.o pageattr_32.o mmap.o
+obj-y	:= init_32.o pgtable_32.o fault_32.o ioremap_32.o extable.o pageattr_32.o mmap.o
 
 obj-$(CONFIG_NUMA) += discontig_32.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
diff --git a/arch/x86/mm/Makefile_64 b/arch/x86/mm/Makefile_64
index b5a7448..09c997f 100644
--- a/arch/x86/mm/Makefile_64
+++ b/arch/x86/mm/Makefile_64
@@ -2,7 +2,7 @@
 # Makefile for the linux x86_64-specific parts of the memory manager.
 #
 
-obj-y	 := init_64.o fault_64.o ioremap_64.o extable_64.o pageattr_64.o mmap.o
+obj-y	 := init_64.o fault_64.o ioremap_64.o extable.o pageattr_64.o mmap.o
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_NUMA) += numa_64.o
 obj-$(CONFIG_K8_NUMA) += k8topology_64.o
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
new file mode 100644
index 0000000..7e8db53
--- /dev/null
+++ b/arch/x86/mm/extable.c
@@ -0,0 +1,62 @@
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <asm/uaccess.h>
+
+
+int fixup_exception(struct pt_regs *regs)
+{
+	const struct exception_table_entry *fixup;
+
+#ifdef CONFIG_PNPBIOS
+	if (unlikely(SEGMENT_IS_PNP_CODE(regs->cs))) {
+		extern u32 pnp_bios_fault_eip, pnp_bios_fault_esp;
+		extern u32 pnp_bios_is_utter_crap;
+		pnp_bios_is_utter_crap = 1;
+		printk(KERN_CRIT "PNPBIOS fault.. attempting recovery.\n");
+		__asm__ volatile(
+			"movl %0, %%esp\n\t"
+			"jmp *%1\n\t"
+			: : "g" (pnp_bios_fault_esp), "g" (pnp_bios_fault_eip));
+		panic("do_trap: can't hit this");
+	}
+#endif
+
+	fixup = search_exception_tables(regs->ip);
+	if (fixup) {
+		regs->ip = fixup->fixup;
+		return 1;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_X86_64
+/*
+ * Need to defined our own search_extable on X86_64 to work around
+ * a B stepping K8 bug.
+ */
+const struct exception_table_entry *
+search_extable(const struct exception_table_entry *first,
+	       const struct exception_table_entry *last,
+	       unsigned long value)
+{
+	/* B stepping K8 bug */
+	if ((value >> 32) == 0)
+		value |= 0xffffffffUL << 32;
+
+	while (first <= last) {
+		const struct exception_table_entry *mid;
+		long diff;
+
+		mid = (last - first) / 2 + first;
+		diff = mid->insn - value;
+		if (diff == 0)
+			return mid;
+		else if (diff < 0)
+			first = mid+1;
+		else
+			last = mid-1;
+	}
+	return NULL;
+}
+#endif
diff --git a/arch/x86/mm/extable_32.c b/arch/x86/mm/extable_32.c
deleted file mode 100644
index 4168546..0000000
--- a/arch/x86/mm/extable_32.c
+++ /dev/null
@@ -1,35 +0,0 @@
-/*
- * linux/arch/i386/mm/extable.c
- */
-
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <asm/uaccess.h>
-
-int fixup_exception(struct pt_regs *regs)
-{
-	const struct exception_table_entry *fixup;
-
-#ifdef CONFIG_PNPBIOS
-	if (unlikely(SEGMENT_IS_PNP_CODE(regs->cs)))
-	{
-		extern u32 pnp_bios_fault_eip, pnp_bios_fault_esp;
-		extern u32 pnp_bios_is_utter_crap;
-		pnp_bios_is_utter_crap = 1;
-		printk(KERN_CRIT "PNPBIOS fault.. attempting recovery.\n");
-		__asm__ volatile(
-			"movl %0, %%esp\n\t"
-			"jmp *%1\n\t"
-			: : "g" (pnp_bios_fault_esp), "g" (pnp_bios_fault_eip));
-		panic("do_trap: can't hit this");
-	}
-#endif
-
-	fixup = search_exception_tables(regs->ip);
-	if (fixup) {
-		regs->ip = fixup->fixup;
-		return 1;
-	}
-
-	return 0;
-}
diff --git a/arch/x86/mm/extable_64.c b/arch/x86/mm/extable_64.c
deleted file mode 100644
index 79ac6e7..0000000
--- a/arch/x86/mm/extable_64.c
+++ /dev/null
@@ -1,34 +0,0 @@
-/*
- * linux/arch/x86_64/mm/extable.c
- */
-
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/init.h>
-#include <asm/uaccess.h>
-
-/* Simple binary search */
-const struct exception_table_entry *
-search_extable(const struct exception_table_entry *first,
-	       const struct exception_table_entry *last,
-	       unsigned long value)
-{
-	/* Work around a B stepping K8 bug */
-	if ((value >> 32) == 0)
-		value |= 0xffffffffUL << 32; 
-
-        while (first <= last) {
-		const struct exception_table_entry *mid;
-		long diff;
-
-		mid = (last - first) / 2 + first;
-		diff = mid->insn - value;
-                if (diff == 0)
-                        return mid;
-                else if (diff < 0)
-                        first = mid+1;
-                else
-                        last = mid-1;
-        }
-        return NULL;
-}
-- 
1.5.4.rc0.1143.g1a8a



