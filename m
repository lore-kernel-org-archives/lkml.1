Return-Path: <linux-kernel-owner+w=401wt.eu-S934554AbXLQQMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934554AbXLQQMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758713AbXLQQMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:12:41 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757438AbXLQQMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:12:40 -0500
Message-ID: <47669E8D.3020305@redhat.com>
Date: Mon, 17 Dec 2007 11:06:37 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: ananth@in.ibm.com, Jim Keniston <jkenisto@us.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       Ingo Molnar <mingo@elte.hu>,
       Harvey Harrison <harvey.harrison@gmail.com>
CC: systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [-mm][PATCH 1/6] jprobe bugfix and cleanup
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug of jprobe and cleans up.
jprobe for x86-64 can cause kernel page fault when the jprobe_return()
is called from incorrect function. Anyway, that path finally invokes
BUG() macro, so this is not so serious.

- Use jprobe_saved_regs instead getting it from stack.
  (Especially on x86-64, it may get incorrect data, because
   pt_regs can not be get by using container_of(rsp))
- Change the type of stack pointer to unsigned long *.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

---
 arch/x86/kernel/kprobes_32.c |    4 +---
 arch/x86/kernel/kprobes_64.c |    4 +---
 include/asm-x86/kprobes_32.h |    2 +-
 include/asm-x86/kprobes_64.h |    2 +-
 4 files changed, 4 insertions(+), 8 deletions(-)

Index: 2.6.24-rc4-mm1/arch/x86/kernel/kprobes_32.c
===================================================================
--- 2.6.24-rc4-mm1.orig/arch/x86/kernel/kprobes_32.c
+++ 2.6.24-rc4-mm1/arch/x86/kernel/kprobes_32.c
@@ -742,9 +742,7 @@ int __kprobes longjmp_break_handler(stru

 	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
 		if (&regs->sp != kcb->jprobe_saved_esp) {
-			struct pt_regs *saved_regs =
-			    container_of(kcb->jprobe_saved_esp,
-					    struct pt_regs, sp);
+			struct pt_regs *saved_regs = &kcb->jprobe_saved_regs;
 			printk("current sp %p does not match saved sp %p\n",
 			       &regs->sp, kcb->jprobe_saved_esp);
 			printk("Saved registers for jprobe %p\n", jp);
Index: 2.6.24-rc4-mm1/arch/x86/kernel/kprobes_64.c
===================================================================
--- 2.6.24-rc4-mm1.orig/arch/x86/kernel/kprobes_64.c
+++ 2.6.24-rc4-mm1/arch/x86/kernel/kprobes_64.c
@@ -732,9 +732,7 @@ int __kprobes longjmp_break_handler(stru

 	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
 		if ((long *)regs->sp != kcb->jprobe_saved_rsp) {
-			struct pt_regs *saved_regs =
-			    container_of(kcb->jprobe_saved_rsp,
-					    struct pt_regs, sp);
+			struct pt_regs *saved_regs = &kcb->jprobe_saved_regs;
 			printk("current sp %p does not match saved sp %p\n",
 			       (long *)regs->sp, kcb->jprobe_saved_rsp);
 			printk("Saved registers for jprobe %p\n", jp);
Index: 2.6.24-rc4-mm1/include/asm-x86/kprobes_32.h
===================================================================
--- 2.6.24-rc4-mm1.orig/include/asm-x86/kprobes_32.h
+++ 2.6.24-rc4-mm1/include/asm-x86/kprobes_32.h
@@ -73,7 +73,7 @@ struct kprobe_ctlblk {
 	unsigned long kprobe_status;
 	unsigned long kprobe_old_eflags;
 	unsigned long kprobe_saved_eflags;
-	long *jprobe_saved_esp;
+	unsigned long *jprobe_saved_esp;
 	struct pt_regs jprobe_saved_regs;
 	kprobe_opcode_t jprobes_stack[MAX_STACK_SIZE];
 	struct prev_kprobe prev_kprobe;
Index: 2.6.24-rc4-mm1/include/asm-x86/kprobes_64.h
===================================================================
--- 2.6.24-rc4-mm1.orig/include/asm-x86/kprobes_64.h
+++ 2.6.24-rc4-mm1/include/asm-x86/kprobes_64.h
@@ -66,7 +66,7 @@ struct kprobe_ctlblk {
 	unsigned long kprobe_status;
 	unsigned long kprobe_old_rflags;
 	unsigned long kprobe_saved_rflags;
-	long *jprobe_saved_rsp;
+	unsigned long *jprobe_saved_rsp;
 	struct pt_regs jprobe_saved_regs;
 	kprobe_opcode_t jprobes_stack[MAX_STACK_SIZE];
 	struct prev_kprobe prev_kprobe;

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com


