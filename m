Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbZHaXhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbZHaXhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 19:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZHaXhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 19:37:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:57050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbZHaXhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 19:37:33 -0400
Date: Mon, 31 Aug 2009 23:37:14 GMT
From: tip-bot for Borislav Petkov <petkovbb@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       petkovbb@googlemail.com, tglx@linutronix.de, petkovbb@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       petkovbb@googlemail.com, tglx@linutronix.de, petkovbb@gmail.com
In-Reply-To: <1251705011-18636-1-git-send-email-petkovbb@gmail.com>
References: <1251705011-18636-1-git-send-email-petkovbb@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, msr: Add rd/wrmsr interfaces with preset registers
Message-ID: <tip-132ec92f3f70fe365c1f4b8d46e66cf8a2a16880@git.kernel.org>
Git-Commit-ID: 132ec92f3f70fe365c1f4b8d46e66cf8a2a16880
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 23:37:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  132ec92f3f70fe365c1f4b8d46e66cf8a2a16880
Gitweb:     http://git.kernel.org/tip/132ec92f3f70fe365c1f4b8d46e66cf8a2a16880
Author:     Borislav Petkov <petkovbb@googlemail.com>
AuthorDate: Mon, 31 Aug 2009 09:50:09 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 31 Aug 2009 15:14:26 -0700

x86, msr: Add rd/wrmsr interfaces with preset registers

native_{rdmsr,wrmsr}_safe_regs are two new interfaces which allow
presetting of a subset of eight x86 GPRs before executing the rd/wrmsr
instructions. This is needed at least on AMD K8 for accessing an erratum
workaround MSR.

Originally based on an idea by H. Peter Anvin.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
LKML-Reference: <1251705011-18636-1-git-send-email-petkovbb@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/include/asm/msr.h      |   13 +++++
 arch/x86/include/asm/paravirt.h |   16 ++++++
 arch/x86/kernel/paravirt.c      |    2 +
 arch/x86/lib/Makefile           |    1 +
 arch/x86/lib/msr-reg.S          |   98 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 130 insertions(+), 0 deletions(-)

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
