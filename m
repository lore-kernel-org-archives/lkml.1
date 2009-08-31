Return-Path: <linux-kernel-owner+w=401wt.eu-S1751622AbZHaHuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbZHaHuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 03:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZHaHuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 03:50:23 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46486 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZHaHuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 03:50:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LtL0XAQ8grASwvg9JjhNdna8v0tXfyRlPXQMEGVTnYey0o30G9H6pssr5f31cBuJaG
         xMFnqI26ymjzMK0ms0slT8g0se+PPisbKyd1GPfhFAD0+atiDnE2slP1Jaw+GxN5LM3Q
         Q5YjqRLpp1CQQutacEDxqnXZzyswwGlDE9RrA=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <hpa@zytor.com>
Cc: <mingo@redhat.com>, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: [PATCH 1/3] x86, msr: add rd/wrmsr interfaces with preset registers
Date: Mon, 31 Aug 2009 09:50:09 +0200
Message-Id: <1251705011-18636-1-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090831073429.GA26596@liondog.tnic>
References: <20090831073429.GA26596@liondog.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

native_{rdmsr,wrmsr}_safe_regs are two new interfaces which allow
presetting of a subset of eight x86 GPRs before executing the rd/wrmsr
instructions. This is needed at least on AMD K8 for accessing an erratum
workaround MSR.

Originally based on an idea by H. Peter Anvin.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 arch/x86/include/asm/msr.h      |   13 +++++
 arch/x86/include/asm/paravirt.h |   16 ++++++
 arch/x86/kernel/paravirt.c      |    2 +
 arch/x86/lib/Makefile           |    1 +
 arch/x86/lib/msr-reg.S          |   98 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 130 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/lib/msr-reg.S

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 48ad9d2..184d4a1 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -113,6 +113,9 @@ notrace static inline int native_write_msr_safe(unsigned int msr,
 
 extern unsigned long long native_read_tsc(void);
 
+extern int native_rdmsr_safe_regs(u32 *regs);
+extern int native_wrmsr_safe_regs(u32 *regs);
+
 static __always_inline unsigned long long __native_read_tsc(void)
 {
 	DECLARE_ARGS(val, low, high);
@@ -189,6 +192,16 @@ static inline int rdmsrl_amd_safe(unsigned msr, unsigned long long *p)
 	return err;
 }
 
+static inline int rdmsr_safe_regs(u32 *regs)
+{
+	return native_rdmsr_safe_regs(regs);
+}
+
+static inline int wrmsr_safe_regs(u32 *regs)
+{
+	return native_wrmsr_safe_regs(regs);
+}
+
 #define rdtscl(low)						\
 	((low) = (u32)__native_read_tsc())
 
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 4fb37c8..1705944 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -168,7 +168,9 @@ struct pv_cpu_ops {
 	   err = 0/-EFAULT.  wrmsr returns 0/-EFAULT. */
 	u64 (*read_msr_amd)(unsigned int msr, int *err);
 	u64 (*read_msr)(unsigned int msr, int *err);
+	int (*rdmsr_regs)(u32 *regs);
 	int (*write_msr)(unsigned int msr, unsigned low, unsigned high);
+	int (*wrmsr_regs)(u32 *regs);
 
 	u64 (*read_tsc)(void);
 	u64 (*read_pmc)(int counter);
@@ -820,6 +822,12 @@ static inline u64 paravirt_read_msr(unsigned msr, int *err)
 {
 	return PVOP_CALL2(u64, pv_cpu_ops.read_msr, msr, err);
 }
+
+static inline int paravirt_rdmsr_regs(u32 *regs)
+{
+	return PVOP_CALL1(int, pv_cpu_ops.rdmsr_regs, regs);
+}
+
 static inline u64 paravirt_read_msr_amd(unsigned msr, int *err)
 {
 	return PVOP_CALL2(u64, pv_cpu_ops.read_msr_amd, msr, err);
@@ -829,6 +837,11 @@ static inline int paravirt_write_msr(unsigned msr, unsigned low, unsigned high)
 	return PVOP_CALL3(int, pv_cpu_ops.write_msr, msr, low, high);
 }
 
+static inline int paravirt_wrmsr_regs(u32 *regs)
+{
+	return PVOP_CALL1(int, pv_cpu_ops.wrmsr_regs, regs);
+}
+
 /* These should all do BUG_ON(_err), but our headers are too tangled. */
 #define rdmsr(msr, val1, val2)			\
 do {						\
@@ -862,6 +875,9 @@ do {						\
 	_err;					\
 })
 
+#define rdmsr_safe_regs(regs)	paravirt_rdmsr_regs(regs)
+#define wrmsr_safe_regs(regs)	paravirt_wrmsr_regs(regs)
+
 static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 {
 	int err;
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 70ec9b9..67594af 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -362,8 +362,10 @@ struct pv_cpu_ops pv_cpu_ops = {
 #endif
 	.wbinvd = native_wbinvd,
 	.read_msr = native_read_msr_safe,
+	.rdmsr_regs = native_rdmsr_safe_regs,
 	.read_msr_amd = native_read_msr_amd_safe,
 	.write_msr = native_write_msr_safe,
+	.wrmsr_regs = native_wrmsr_safe_regs,
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 	.read_tscp = native_read_tscp,
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 07c3189..b59c064 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -8,6 +8,7 @@ lib-y := delay.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
+lib-y += msr-reg.o
 
 ifeq ($(CONFIG_X86_32),y)
         obj-y += atomic64_32.o
diff --git a/arch/x86/lib/msr-reg.S b/arch/x86/lib/msr-reg.S
new file mode 100644
index 0000000..51f1bb3
--- /dev/null
+++ b/arch/x86/lib/msr-reg.S
@@ -0,0 +1,98 @@
+#include <linux/linkage.h>
+#include <linux/errno.h>
+#include <asm/asm.h>
+#include <asm/msr.h>
+
+#ifdef CONFIG_X86_64
+/*
+ * int native_{rdmsr,wrmsr}_safe_regs(u32 gprs[8]);
+ *
+ * reg layout: u32 gprs[eax, ecx, edx, ebx, esp, ebp, esi, edi]
+ *
+ */
+.macro op_safe_regs op:req
+ENTRY(native_\op\()_safe_regs)
+	push    %rbx
+	push    %rbp
+	push    $0              /* Return value */
+	push    %rdi
+	movl    (%rdi), %eax
+	movl    4(%rdi), %ecx
+	movl    8(%rdi), %edx
+	movl    12(%rdi), %ebx
+	movl    20(%rdi), %ebp
+	movl    24(%rdi), %esi
+	movl    28(%rdi), %edi
+1:	\op
+2:	movl    %edi, %r10d
+	pop     %rdi
+	movl    %eax, (%rdi)
+	movl    %ecx, 4(%rdi)
+	movl    %edx, 8(%rdi)
+	movl    %ebx, 12(%rdi)
+	movl    %ebp, 20(%rdi)
+	movl    %esi, 24(%rdi)
+	movl    %r10d, 28(%rdi)
+	pop     %rax
+	pop     %rbp
+	pop     %rbx
+	ret
+3:
+	movq    $-EIO, 8(%rsp)
+	jmp     2b
+	.section __ex_table,"ax"
+	.balign 4
+	.quad   1b, 3b
+	.previous
+ENDPROC(native_\op\()_safe_regs)
+.endm
+
+#else /* X86_32 */
+
+.macro op_safe_regs op:req
+ENTRY(native_\op\()_safe_regs)
+	push    %ebx
+	push    %ebp
+	push    %esi
+	push    %edi
+	push    $0              /* Return value */
+	push    %eax
+	movl    4(%eax), %ecx
+	movl    8(%eax), %edx
+	movl    12(%eax), %ebx
+	movl    20(%eax), %ebp
+	movl    24(%eax), %esi
+	movl    28(%eax), %edi
+	movl    (%eax), %eax
+1:	\op
+2:	push    %eax
+	movl    4(%esp), %eax
+	pop     (%eax)
+	addl    $4, %esp
+	movl    %ecx, 4(%eax)
+	movl    %edx, 8(%eax)
+	movl    %ebx, 12(%eax)
+	movl    %ebp, 20(%eax)
+	movl    %esi, 24(%eax)
+	movl    %edi, 28(%eax)
+	pop     %eax
+	pop     %edi
+	pop     %esi
+	pop     %ebp
+	pop     %ebx
+	ret
+3:
+	movl    $-EIO, 4(%esp)
+	jmp     2b
+	.section __ex_table,"ax"
+	.balign 4
+	.long   1b, 3b
+	.previous
+ENDPROC(native_\op\()_safe_regs)
+.endm
+
+#endif
+
+op_safe_regs rdmsr
+op_safe_regs wrmsr
+
-- 
1.6.3.3

