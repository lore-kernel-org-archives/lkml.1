Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbYAFAHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbYAFAHj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 19:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbYAFAHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 19:07:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:23511 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbYAFAHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 19:07:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=Z2Y6Iz5Qanv5nJR9fGPffk19ClF5hg3flN98yn/fFwLs8sRvm12Z5rv5zYbBw5vu211YkdeV4wazgERdxTFgmkl58V54lq03UxpUXtmbxTkpLPBDxLfZcVdx+Rs/77J7VjPZe9gu0sqLSmeif/dUDp6L4+a+teaUIiPYamyq4es=
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: paravirt_patch_{32|64}.c unification
Date: Sun, 6 Jan 2008 01:05:44 +0100
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801060105.44758.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

paravirt_patch_{32|64}.c unification.

This patch unifies the code from the paravirt_patcht_32.c and
paravirt_patch_64.c files.

I couldn't test this modification but it shouldn't have any bugs
(it's a very simple modification).

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 5ed68b4..92d9ac6 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -66,7 +66,7 @@ obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_MGEODE_LX)		+= geode_32.o mfgpt_32.o
 
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
-obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch_$(BITS).o
+obj-$(CONFIG_PARAVIRT)		+= paravirt.o paravirt_patch.o
 obj-y				+= pcspeaker.o
 
 obj-$(CONFIG_SCx200)		+= scx200_32.o
diff --git a/arch/x86/kernel/paravirt_patch.c b/arch/x86/kernel/paravirt_patch.c
new file mode 100644
index 0000000..7e756ea
--- /dev/null
+++ b/arch/x86/kernel/paravirt_patch.c
@@ -0,0 +1,69 @@
+#include <asm/paravirt.h>
+
+DEF_NATIVE(pv_irq_ops, irq_enable, "sti");
+DEF_NATIVE(pv_irq_ops, irq_disable, "cli");
+DEF_NATIVE(pv_cpu_ops, clts, "clts");
+
+#ifdef CONFIG_X86_32
+DEF_NATIVE(pv_irq_ops, restore_fl, "push %eax; popf");
+DEF_NATIVE(pv_irq_ops, save_fl, "pushf; pop %eax");
+DEF_NATIVE(pv_cpu_ops, iret, "iret");
+DEF_NATIVE(pv_cpu_ops, irq_enable_syscall_ret, "sti; sysexit");
+DEF_NATIVE(pv_mmu_ops, read_cr2, "mov %cr2, %eax");
+DEF_NATIVE(pv_mmu_ops, read_cr3, "mov %cr3, %eax");
+DEF_NATIVE(pv_mmu_ops, write_cr3, "mov %eax, %cr3");
+DEF_NATIVE(pv_cpu_ops, read_tsc, "rdtsc");
+#else
+DEF_NATIVE(pv_irq_ops, restore_fl, "pushq %rdi; popfq");
+DEF_NATIVE(pv_irq_ops, save_fl, "pushfq; popq %rax");
+DEF_NATIVE(pv_cpu_ops, iret, "iretq");
+DEF_NATIVE(pv_cpu_ops, irq_enable_syscall_ret, "movq %gs:" __stringify(pda_oldrsp) ", %rsp; swapgs; sysretq;");
+DEF_NATIVE(pv_mmu_ops, read_cr2, "movq %cr2, %rax");
+DEF_NATIVE(pv_mmu_ops, read_cr3, "movq %cr3, %rax");
+DEF_NATIVE(pv_mmu_ops, write_cr3, "movq %rdi, %cr3");
+DEF_NATIVE(pv_mmu_ops, flush_tlb_single, "invlpg (%rdi)");
+DEF_NATIVE(pv_cpu_ops, wbinvd, "wbinvd");
+DEF_NATIVE(pv_cpu_ops, swapgs, "swapgs");
+#endif
+
+unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
+		      unsigned long addr, unsigned len)
+{
+	const unsigned char *start, *end;
+	unsigned ret;
+
+#define PATCH_SITE(ops, x)					\
+		case PARAVIRT_PATCH(ops.x):			\
+			start = start_##ops##_##x;		\
+			end = end_##ops##_##x;			\
+			goto patch_site
+	switch (type) {
+		PATCH_SITE(pv_irq_ops, irq_enable);
+		PATCH_SITE(pv_irq_ops, irq_disable);
+		PATCH_SITE(pv_irq_ops, restore_fl);
+		PATCH_SITE(pv_irq_ops, save_fl);
+		PATCH_SITE(pv_cpu_ops, iret);
+		PATCH_SITE(pv_cpu_ops, irq_enable_syscall_ret);
+		PATCH_SITE(pv_mmu_ops, read_cr2);
+		PATCH_SITE(pv_mmu_ops, read_cr3);
+		PATCH_SITE(pv_mmu_ops, write_cr3);
+		PATCH_SITE(pv_cpu_ops, clts);
+#ifdef CONFIG_X86_32
+		PATCH_SITE(pv_cpu_ops, read_tsc);
+#else
+		PATCH_SITE(pv_mmu_ops, flush_tlb_single);
+		PATCH_SITE(pv_cpu_ops, wbinvd);
+		PATCH_SITE(pv_cpu_ops, swapgs);
+#endif
+
+patch_site:
+		ret = paravirt_patch_insns(ibuf, len, start, end);
+		break;
+
+default:
+		ret = paravirt_patch_default(type, clobbers, ibuf, addr, len);
+		break;
+	}
+#undef PATCH_SITE
+	return ret;
+}
diff --git a/arch/x86/kernel/paravirt_patch_32.c b/arch/x86/kernel/paravirt_patch_32.c
deleted file mode 100644
index 82fc5fc..0000000
--- a/arch/x86/kernel/paravirt_patch_32.c
+++ /dev/null
@@ -1,49 +0,0 @@
-#include <asm/paravirt.h>
-
-DEF_NATIVE(pv_irq_ops, irq_disable, "cli");
-DEF_NATIVE(pv_irq_ops, irq_enable, "sti");
-DEF_NATIVE(pv_irq_ops, restore_fl, "push %eax; popf");
-DEF_NATIVE(pv_irq_ops, save_fl, "pushf; pop %eax");
-DEF_NATIVE(pv_cpu_ops, iret, "iret");
-DEF_NATIVE(pv_cpu_ops, irq_enable_syscall_ret, "sti; sysexit");
-DEF_NATIVE(pv_mmu_ops, read_cr2, "mov %cr2, %eax");
-DEF_NATIVE(pv_mmu_ops, write_cr3, "mov %eax, %cr3");
-DEF_NATIVE(pv_mmu_ops, read_cr3, "mov %cr3, %eax");
-DEF_NATIVE(pv_cpu_ops, clts, "clts");
-DEF_NATIVE(pv_cpu_ops, read_tsc, "rdtsc");
-
-unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
-		      unsigned long addr, unsigned len)
-{
-	const unsigned char *start, *end;
-	unsigned ret;
-
-#define PATCH_SITE(ops, x)					\
-		case PARAVIRT_PATCH(ops.x):			\
-			start = start_##ops##_##x;		\
-			end = end_##ops##_##x;			\
-			goto patch_site
-	switch(type) {
-		PATCH_SITE(pv_irq_ops, irq_disable);
-		PATCH_SITE(pv_irq_ops, irq_enable);
-		PATCH_SITE(pv_irq_ops, restore_fl);
-		PATCH_SITE(pv_irq_ops, save_fl);
-		PATCH_SITE(pv_cpu_ops, iret);
-		PATCH_SITE(pv_cpu_ops, irq_enable_syscall_ret);
-		PATCH_SITE(pv_mmu_ops, read_cr2);
-		PATCH_SITE(pv_mmu_ops, read_cr3);
-		PATCH_SITE(pv_mmu_ops, write_cr3);
-		PATCH_SITE(pv_cpu_ops, clts);
-		PATCH_SITE(pv_cpu_ops, read_tsc);
-
-	patch_site:
-		ret = paravirt_patch_insns(ibuf, len, start, end);
-		break;
-
-	default:
-		ret = paravirt_patch_default(type, clobbers, ibuf, addr, len);
-		break;
-	}
-#undef PATCH_SITE
-	return ret;
-}
diff --git a/arch/x86/kernel/paravirt_patch_64.c b/arch/x86/kernel/paravirt_patch_64.c
deleted file mode 100644
index cbfc4f3..0000000
--- a/arch/x86/kernel/paravirt_patch_64.c
+++ /dev/null
@@ -1,56 +0,0 @@
-#include <asm/paravirt.h>
-#include <asm/asm-offsets.h>
-
-DEF_NATIVE(pv_irq_ops, irq_disable, "cli");
-DEF_NATIVE(pv_irq_ops, irq_enable, "sti");
-DEF_NATIVE(pv_irq_ops, restore_fl, "pushq %rdi; popfq");
-DEF_NATIVE(pv_irq_ops, save_fl, "pushfq; popq %rax");
-DEF_NATIVE(pv_cpu_ops, iret, "iretq");
-DEF_NATIVE(pv_mmu_ops, read_cr2, "movq %cr2, %rax");
-DEF_NATIVE(pv_mmu_ops, read_cr3, "movq %cr3, %rax");
-DEF_NATIVE(pv_mmu_ops, write_cr3, "movq %rdi, %cr3");
-DEF_NATIVE(pv_mmu_ops, flush_tlb_single, "invlpg (%rdi)");
-DEF_NATIVE(pv_cpu_ops, clts, "clts");
-DEF_NATIVE(pv_cpu_ops, wbinvd, "wbinvd");
-
-/* the three commands give us more control to how to return from a syscall */
-DEF_NATIVE(pv_cpu_ops, irq_enable_syscall_ret, "movq %gs:" __stringify(pda_oldrsp) ", %rsp; swapgs; sysretq;");
-DEF_NATIVE(pv_cpu_ops, swapgs, "swapgs");
-
-unsigned native_patch(u8 type, u16 clobbers, void *ibuf,
-		      unsigned long addr, unsigned len)
-{
-	const unsigned char *start, *end;
-	unsigned ret;
-
-#define PATCH_SITE(ops, x)					\
-		case PARAVIRT_PATCH(ops.x):			\
-			start = start_##ops##_##x;		\
-			end = end_##ops##_##x;			\
-			goto patch_site
-	switch(type) {
-		PATCH_SITE(pv_irq_ops, restore_fl);
-		PATCH_SITE(pv_irq_ops, save_fl);
-		PATCH_SITE(pv_irq_ops, irq_enable);
-		PATCH_SITE(pv_irq_ops, irq_disable);
-		PATCH_SITE(pv_cpu_ops, iret);
-		PATCH_SITE(pv_cpu_ops, irq_enable_syscall_ret);
-		PATCH_SITE(pv_cpu_ops, swapgs);
-		PATCH_SITE(pv_mmu_ops, read_cr2);
-		PATCH_SITE(pv_mmu_ops, read_cr3);
-		PATCH_SITE(pv_mmu_ops, write_cr3);
-		PATCH_SITE(pv_cpu_ops, clts);
-		PATCH_SITE(pv_mmu_ops, flush_tlb_single);
-		PATCH_SITE(pv_cpu_ops, wbinvd);
-
-	patch_site:
-		ret = paravirt_patch_insns(ibuf, len, start, end);
-		break;
-
-	default:
-		ret = paravirt_patch_default(type, clobbers, ibuf, addr, len);
-		break;
-	}
-#undef PATCH_SITE
-	return ret;
-}

-- 
	Miguel Botón
