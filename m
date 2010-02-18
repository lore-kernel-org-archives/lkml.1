Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab0BRWHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 17:07:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758782Ab0BRWHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 17:07:36 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v10 6/9] kprobes/x86: Cleanup save/restore registers
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>, Andi Kleen <andi@firstfloor.org>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Thu, 18 Feb 2010 17:13:36 -0500
Message-ID: <20100218221336.19637.83293.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100218221247.19637.80088.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100218221247.19637.80088.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce SAVE/RESOTRE_REGS_STRING for cleanup kretprobe-trampoline asm
code. These macros will be used for emulating interruption.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Anders Kaseorg <andersk@ksplice.com>
Cc: Tim Abbott <tabbott@ksplice.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
---

 arch/x86/kernel/kprobes.c |  128 ++++++++++++++++++++++++---------------------
 1 files changed, 67 insertions(+), 61 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index c69bb65..4ae95be 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -554,6 +554,69 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
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
@@ -567,65 +630,16 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
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
@@ -633,15 +647,7 @@ static void __used __kprobes kretprobe_trampoline_holder(void)
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
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
