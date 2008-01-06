Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbYAFOvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbYAFOvX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758902AbYAFOlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:41:46 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:56112 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758889AbYAFOln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:41:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=IT/D0nCzVUqkFUiP3P7BlfTsZAwsBMZQy7ccogVPSrB7BZj8FtjB37+eT2/oGZv9GjViilsjvQyDyKkwkBowz/CZwsCouq0yyxVbqCxjj+oHYzgtv3FeVPDwUlFhC6E5L/3yb++sOHu/i9LSxv8+yLHfEhfqymL3DZpXqY9PiNo=
Message-ID: <4780E89B.1050108@gmail.com>
Date: Sun, 06 Jan 2008 15:41:31 +0100
From: =?ISO-8859-1?Q?Miguel_Bot=F3n?= <mboton@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: =?ISO-8859-1?Q?Miguel_Bot=F3n?= <mboton.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] x86: paravirt_patch_{32|64}.c unification
References: <200801060105.44758.mboton@gmail.com> <20080106093250.GB26291@elte.hu>
In-Reply-To: <20080106093250.GB26291@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i couldnt apply your mail due to:
> 
>  User-Agent: KMail/1.9.7
> 
> and due to quoted printables:
> 
>  =20
>   #else
>  =20
>  =2D# ifdef CONFIG_SMP
> 
> 	Ingo

D'oh. Sorry, this time I'll use Mozilla Thunderbird
to send the patch.

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

---
	Miguel Botón
