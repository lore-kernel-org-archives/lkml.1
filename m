Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbZDFVmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbZDFVmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759313AbZDFVmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:42:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45795 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115AbZDFVmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:42:19 -0400
Message-ID: <49DA774C.701@redhat.com>
Date: Mon, 06 Apr 2009 17:42:36 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Vegard Nossum <vegard.nossum@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Satoshi Oshima <satoshi.oshima.fk@hitachi.com>
Subject: [RFC][PROTO][PATCH -tip 5/7] kprobes: x86: cleanup save/restore registers
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce SAVE/RESOTRE_REGS_STRING for cleanup kretprobe-trampoline asm
code. These macros will be used for emulating interruption.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
---

 arch/x86/kernel/kprobes.c |  128 ++++++++++++++++++++++++---------------------
 1 files changed, 67 insertions(+), 61 deletions(-)


diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 3d5e85f..fcce435 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -634,6 +634,69 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 	return 0;
 }

+#ifdef CONFIG_X86_64
+#define SAVE_REGS_STRING		\
+	/* Skip cs, ip, orig_ax. */	\
+	"	subq $24, %rsp\n"	\
+	"	pushq %rdi\n"		\
+	"	pushq %rsi\n"		\
+	"	pushq %rdx\n"		\
+	"	pushq %rcx\n"		\
+	"	pushq %rax\n"		\
+	"	pushq %r8\n"		\
+	"	pushq %r9\n"		\
+	"	pushq %r10\n"		\
+	"	pushq %r11\n"		\
+	"	pushq %rbx\n"		\
+	"	pushq %rbp\n"		\
+	"	pushq %r12\n"		\
+	"	pushq %r13\n"		\
+	"	pushq %r14\n"		\
+	"	pushq %r15\n"
+#define RESTORE_REGS_STRING		\
+	"	popq %r15\n"		\
+	"	popq %r14\n"		\
+	"	popq %r13\n"		\
+	"	popq %r12\n"		\
+	"	popq %rbp\n"		\
+	"	popq %rbx\n"		\
+	"	popq %r11\n"		\
+	"	popq %r10\n"		\
+	"	popq %r9\n"		\
+	"	popq %r8\n"		\
+	"	popq %rax\n"		\
+	"	popq %rcx\n"		\
+	"	popq %rdx\n"		\
+	"	popq %rsi\n"		\
+	"	popq %rdi\n"		\
+	/* Skip orig_ax, ip, cs */	\
+	"	addq $24, %rsp\n"
+#else
+#define SAVE_REGS_STRING		\
+	/* Skip cs, ip, orig_ax and gs. */	\
+	"	subl $16, %esp\n"	\
+	"	pushl %fs\n"		\
+	"	pushl %ds\n"		\
+	"	pushl %es\n"		\
+	"	pushl %eax\n"		\
+	"	pushl %ebp\n"		\
+	"	pushl %edi\n"		\
+	"	pushl %esi\n"		\
+	"	pushl %edx\n"		\
+	"	pushl %ecx\n"		\
+	"	pushl %ebx\n"
+#define RESTORE_REGS_STRING		\
+	"	popl %ebx\n"		\
+	"	popl %ecx\n"		\
+	"	popl %edx\n"		\
+	"	popl %esi\n"		\
+	"	popl %edi\n"		\
+	"	popl %ebp\n"		\
+	"	popl %eax\n"		\
+	/* Skip ds, es, fs, gs, orig_ax, and ip. Note: don't pop cs here*/\
+	"	addl $24, %esp\n"
+#endif
+
 /*
  * When a retprobed function returns, this code saves registers and
  * calls trampoline_handler() runs, which calls the kretprobe's handler.
@@ -647,65 +710,16 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 			/* We don't bother saving the ss register */
 			"	pushq %rsp\n"
 			"	pushfq\n"
-			/*
-			 * Skip cs, ip, orig_ax.
-			 * trampoline_handler() will plug in these values
-			 */
-			"	subq $24, %rsp\n"
-			"	pushq %rdi\n"
-			"	pushq %rsi\n"
-			"	pushq %rdx\n"
-			"	pushq %rcx\n"
-			"	pushq %rax\n"
-			"	pushq %r8\n"
-			"	pushq %r9\n"
-			"	pushq %r10\n"
-			"	pushq %r11\n"
-			"	pushq %rbx\n"
-			"	pushq %rbp\n"
-			"	pushq %r12\n"
-			"	pushq %r13\n"
-			"	pushq %r14\n"
-			"	pushq %r15\n"
+			SAVE_REGS_STRING
 			"	movq %rsp, %rdi\n"
 			"	call trampoline_handler\n"
 			/* Replace saved sp with true return address. */
 			"	movq %rax, 152(%rsp)\n"
-			"	popq %r15\n"
-			"	popq %r14\n"
-			"	popq %r13\n"
-			"	popq %r12\n"
-			"	popq %rbp\n"
-			"	popq %rbx\n"
-			"	popq %r11\n"
-			"	popq %r10\n"
-			"	popq %r9\n"
-			"	popq %r8\n"
-			"	popq %rax\n"
-			"	popq %rcx\n"
-			"	popq %rdx\n"
-			"	popq %rsi\n"
-			"	popq %rdi\n"
-			/* Skip orig_ax, ip, cs */
-			"	addq $24, %rsp\n"
+			RESTORE_REGS_STRING
 			"	popfq\n"
 #else
 			"	pushf\n"
-			/*
-			 * Skip cs, ip, orig_ax and gs.
-			 * trampoline_handler() will plug in these values
-			 */
-			"	subl $16, %esp\n"
-			"	pushl %fs\n"
-			"	pushl %es\n"
-			"	pushl %ds\n"
-			"	pushl %eax\n"
-			"	pushl %ebp\n"
-			"	pushl %edi\n"
-			"	pushl %esi\n"
-			"	pushl %edx\n"
-			"	pushl %ecx\n"
-			"	pushl %ebx\n"
+			SAVE_REGS_STRING
 			"	movl %esp, %eax\n"
 			"	call trampoline_handler\n"
 			/* Move flags to cs */
@@ -713,15 +727,7 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
 			"	movl %edx, 52(%esp)\n"
 			/* Replace saved flags with true return address. */
 			"	movl %eax, 56(%esp)\n"
-			"	popl %ebx\n"
-			"	popl %ecx\n"
-			"	popl %edx\n"
-			"	popl %esi\n"
-			"	popl %edi\n"
-			"	popl %ebp\n"
-			"	popl %eax\n"
-			/* Skip ds, es, fs, gs, orig_ax and ip */
-			"	addl $24, %esp\n"
+			RESTORE_REGS_STRING
 			"	popf\n"
 #endif
 			"	ret\n");
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

