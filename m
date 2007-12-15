Return-Path: <linux-kernel-owner+w=401wt.eu-S1763971AbXLOIqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763971AbXLOIqP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 03:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbXLOIp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 03:45:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:30879 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbXLOIpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 03:45:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YWWV198RjqYsiFHdY1WTkLU6tJs50/bN3uQrUgTDLL566/eegWJc88+kTkYMNH1MHeu6vn4h2zTTQG56XU2HJs8Cmaqw8N70Yt19+g+vcp/fpllT+oWvAKc+8VV8QwAwreC+DTPAIcJZGGq0NE5HvkR6yiAi+c2y1G7FBYgHqIE=
Subject: FInal kprobes rollup patches
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 15 Dec 2007 00:45:50 -0800
Message-Id: <1197708350.898.87.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f87fb3155500f85ffbafc01d6f5b8dc2a3f6184c Mon Sep 17 00:00:00 2001
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Fri, 14 Dec 2007 22:02:51 -0800
Subject: [PATCH] [RFC] x86: kprobes unification

Further unification work.  There is a possible behavior
change on X86_32 here.

is_IF_modifier(p->opcode)

to

is_IF_modifier(p->ainsn.insn)

Which should be equivalent, but is not purely cosmetic as
the rest of the unification so far.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes_32.c |   43 +++++++++++++++++++++--------
 arch/x86/kernel/kprobes_64.c |   60 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 81 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 878b0c4..21ac86f 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -220,15 +220,21 @@ retry:
 /*
  * returns non-zero if opcode modifies the interrupt flag.
  */
-static int __kprobes is_IF_modifier(kprobe_opcode_t opcode)
+static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
 {
-	switch (opcode) {
+	switch (*insn) {
 	case 0xfa:		/* cli */
 	case 0xfb:		/* sti */
 	case 0xcf:		/* iret/iretd */
 	case 0x9d:		/* popf/popfd */
 		return 1;
 	}
+
+#ifdef CONFIG_X86_64
+	/* REX prefix */
+	if (*insn  >= 0x40 && *insn <= 0x4f && *++insn == 0xcf)
+		return 1;
+#endif
 	return 0;
 }
 
@@ -370,7 +376,7 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 	__get_cpu_var(current_kprobe) = p;
 	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
 		= (regs->flags & (TF_MASK | IF_MASK));
-	if (is_IF_modifier(p->opcode))
+	if (is_IF_modifier(p->ainsn.insn))
 		kcb->kprobe_saved_flags &= ~IF_MASK;
 }
 
@@ -410,10 +416,9 @@ static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
-	unsigned long *sara = (unsigned long *)&regs->sp;
+	unsigned long *sara = &regs->sp;
 
 	ri->ret_addr = (kprobe_opcode_t *) *sara;
-
 	/* Replace the return addr with trampoline addr */
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
@@ -528,8 +533,9 @@ no_kprobe:
  * here. When a retprobed function returns, this probe is hit and
  * trampoline_probe_handler() runs, calling the kretprobe's handler.
  */
- void __kprobes kretprobe_trampoline_holder(void)
- {
+void __kprobes kretprobe_trampoline_holder(void)
+{
+#ifdef CONFIG_X86_32
 	asm volatile ( ".global kretprobe_trampoline\n"
 			"kretprobe_trampoline: \n"
 			"	pushf\n"
@@ -563,6 +569,11 @@ no_kprobe:
 			"	addl $20, %esp\n"
 			"	popf\n"
 			"	ret\n");
+#else
+	asm volatile (  ".global kretprobe_trampoline\n"
+			"kretprobe_trampoline: \n"
+			"nop\n");
+#endif
 }
 
 /*
@@ -658,12 +669,20 @@ void *__kprobes trampoline_handler(struct pt_regs *regs)
 static void __kprobes resume_execution(struct kprobe *p,
 		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
 {
-	unsigned long *tos = (unsigned long *)&regs->sp;
+	unsigned long *tos = &regs->sp;
+	unsigned long next_rip = 0;
 	unsigned long copy_ip = (unsigned long)p->ainsn.insn;
 	unsigned long orig_ip = (unsigned long)p->addr;
+	kprobe_opcode_t *insn = p->ainsn.insn;
+
+#ifdef CONFIG_X86_64
+	/*skip the REX prefix*/
+	if (*insn >= 0x40 && *insn <= 0x4f)
+		insn++;
+#endif
 
 	regs->flags &= ~TF_MASK;
-	switch (p->ainsn.insn[0]) {
+	switch (*insn) {
 	case 0x9c:		/* pushfl */
 		*tos &= ~(TF_MASK | IF_MASK);
 		*tos |= kcb->kprobe_old_flags;
@@ -684,7 +703,7 @@ static void __kprobes resume_execution(struct kprobe *p,
 		*tos = orig_ip + (*tos - copy_ip);
 		goto no_change;
 	case 0xff:
-		if ((p->ainsn.insn[1] & 0x30) == 0x10) {
+		if ((insn[1] & 0x30) == 0x10) {
 			/*
 			 * call absolute, indirect
 			 * Fix return addr; ip is correct.
@@ -692,8 +711,8 @@ static void __kprobes resume_execution(struct kprobe *p,
 			 */
 			*tos = orig_ip + (*tos - copy_ip);
 			goto no_change;
-		} else if (((p->ainsn.insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
-			   ((p->ainsn.insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
+		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
+			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
 			/* ip is correct. And this is boostable */
 			p->ainsn.boostable = 1;
 			goto no_change;
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index b437f7a..9bf6ebe 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -236,8 +236,11 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
 		return 1;
 	}
 
+#ifdef CONFIG_X86_64
+	/* REX prefix */
 	if (*insn  >= 0x40 && *insn <= 0x4f && *++insn == 0xcf)
 		return 1;
+#endif
 	return 0;
 }
 
@@ -419,7 +422,7 @@ static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
-	unsigned long *sara = (unsigned long *)regs->sp;
+	unsigned long *sara = &regs->sp;
 
 	ri->ret_addr = (kprobe_opcode_t *) *sara;
 	/* Replace the return addr with trampoline addr */
@@ -535,12 +538,48 @@ no_kprobe:
  * here. When a retprobed function returns, this probe is hit and
  * trampoline_probe_handler() runs, calling the kretprobe's handler.
  */
- void kretprobe_trampoline_holder(void)
- {
- 	asm volatile (  ".global kretprobe_trampoline\n"
- 			"kretprobe_trampoline: \n"
- 			"nop\n");
- }
+void kretprobe_trampoline_holder(void)
+{
+#ifdef CONFIG_X86_32
+	asm volatile ( ".global kretprobe_trampoline\n"
+			"kretprobe_trampoline: \n"
+			"	pushf\n"
+			/* skip cs, ip, orig_ax */
+			"	subl $12, %esp\n"
+			"	pushl %fs\n"
+			"	pushl %ds\n"
+			"	pushl %es\n"
+			"	pushl %eax\n"
+			"	pushl %ebp\n"
+			"	pushl %edi\n"
+			"	pushl %esi\n"
+			"	pushl %edx\n"
+			"	pushl %ecx\n"
+			"	pushl %ebx\n"
+			"	movl %esp, %eax\n"
+			"	call trampoline_handler\n"
+			/* move flags to cs */
+			"	movl 52(%esp), %edx\n"
+			"	movl %edx, 48(%esp)\n"
+			/* save true return address on flags */
+			"	movl %eax, 52(%esp)\n"
+			"	popl %ebx\n"
+			"	popl %ecx\n"
+			"	popl %edx\n"
+			"	popl %esi\n"
+			"	popl %edi\n"
+			"	popl %ebp\n"
+			"	popl %eax\n"
+			/* skip ip, orig_ax, es, ds, fs */
+			"	addl $20, %esp\n"
+			"	popf\n"
+			"	ret\n");
+#else
+	asm volatile (  ".global kretprobe_trampoline\n"
+			"kretprobe_trampoline: \n"
+			"nop\n");
+#endif
+}
 
 /*
  * Called when we hit the probe point at kretprobe_trampoline
@@ -634,16 +673,19 @@ int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
 static void __kprobes resume_execution(struct kprobe *p,
 		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
 {
-	unsigned long *tos = (unsigned long *)regs->sp;
+	unsigned long *tos = &regs->sp;
 	unsigned long next_rip = 0;
 	unsigned long copy_ip = (unsigned long)p->ainsn.insn;
 	unsigned long orig_ip = (unsigned long)p->addr;
 	kprobe_opcode_t *insn = p->ainsn.insn;
 
+#ifdef CONFIG_X86_64
 	/*skip the REX prefix*/
 	if (*insn >= 0x40 && *insn <= 0x4f)
 		insn++;
+#endif
 
+	regs->flags &= ~TF_MASK;
 	switch (*insn) {
 	case 0x9c:		/* pushfl */
 		*tos &= ~(TF_MASK | IF_MASK);
@@ -653,7 +695,6 @@ static void __kprobes resume_execution(struct kprobe *p,
 	case 0xcb:
 	case 0xc2:
 	case 0xca:
-		regs->flags &= ~TF_MASK;
 		/* ip is already adjusted, no more changes required*/
 		return;
 	case 0xe8:		/* call relative - Fix return addr */
@@ -678,7 +719,6 @@ static void __kprobes resume_execution(struct kprobe *p,
 		break;
 	}
 
-	regs->flags &= ~TF_MASK;
 	if (next_rip) {
 		regs->ip = next_rip;
 	} else {
-- 
1.5.4.rc0.1083.gf568


>From 4a048bf0c67558b8170dcde7c8395f6c35592f0b Mon Sep 17 00:00:00 2001
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Fri, 14 Dec 2007 22:52:44 -0800
Subject: [PATCH] x86: Move some exception fixup logic in kprobes_{32|64}.c

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes_32.c |   21 ++++++++++++++++++---
 arch/x86/kernel/kprobes_64.c |   21 ++++++++++++++++-----
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 21ac86f..a2b5ca7 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -533,7 +533,7 @@ no_kprobe:
  * here. When a retprobed function returns, this probe is hit and
  * trampoline_probe_handler() runs, calling the kretprobe's handler.
  */
-void __kprobes kretprobe_trampoline_holder(void)
+void kretprobe_trampoline_holder(void)
 {
 #ifdef CONFIG_X86_32
 	asm volatile ( ".global kretprobe_trampoline\n"
@@ -787,6 +787,9 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+#ifdef CONFIG_X86_64
+	const struct exception_table_entry *fixup;
+#endif
 
 	switch(kcb->kprobe_status) {
 	case KPROBE_HIT_SS:
@@ -829,11 +832,18 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		 * In case the user-specified fault handler returned
 		 * zero, try to fix up.
 		 */
+#ifdef CONFIG_X86_32
 		if (fixup_exception(regs))
 			return 1;
-
+#else
+		fixup = search_exception_tables(regs->ip);
+		if (fixup) {
+			regs->ip = fixup->fixup;
+			return 1;
+		}
+#endif
 		/*
-		 * fixup_exception() could not handle it,
+		 * Exception couldn't be fixed up,
 		 * Let do_page_fault() fix it.
 		 */
 		break;
@@ -852,8 +862,13 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 	struct die_args *args = (struct die_args *)data;
 	int ret = NOTIFY_DONE;
 
+#ifdef CONFIG_X86_32
 	if (args->regs && user_mode_vm(args->regs))
 		return ret;
+#else
+	if (args->regs && user_mode(args->regs))
+		return ret;
+#endif
 
 	switch (val) {
 	case DIE_INT3:
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 9bf6ebe..705cb99 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -769,7 +769,9 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 {
 	struct kprobe *cur = kprobe_running();
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+#ifdef CONFIG_X86_64
 	const struct exception_table_entry *fixup;
+#endif
 
 	switch(kcb->kprobe_status) {
 	case KPROBE_HIT_SS:
@@ -812,14 +814,18 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 		 * In case the user-specified fault handler returned
 		 * zero, try to fix up.
 		 */
+#ifdef CONFIG_X86_32
+		if (fixup_exception(regs))
+			return 1;
+#else
 		fixup = search_exception_tables(regs->ip);
 		if (fixup) {
 			regs->ip = fixup->fixup;
 			return 1;
 		}
-
+#endif
 		/*
-		 * fixup() could not handle it,
+		 * Exception couldn't be fixed up,
 		 * Let do_page_fault() fix it.
 		 */
 		break;
@@ -838,8 +844,13 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 	struct die_args *args = (struct die_args *)data;
 	int ret = NOTIFY_DONE;
 
+#ifdef CONFIG_X86_32
+	if (args->regs && user_mode_vm(args->regs))
+		return ret;
+#else
 	if (args->regs && user_mode(args->regs))
 		return ret;
+#endif
 
 	switch (val) {
 	case DIE_INT3:
@@ -871,7 +882,7 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
 	kcb->jprobe_saved_regs = *regs;
-	kcb->jprobe_saved_sp = (long *) regs->sp;
+	kcb->jprobe_saved_sp = &regs->sp;
 	addr = (unsigned long)(kcb->jprobe_saved_sp);
 	/*
 	 * As Linus pointed out, gcc assumes that the callee
@@ -916,12 +927,12 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
 
 	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
-		if ((long *)regs->sp != kcb->jprobe_saved_sp) {
+		if (&regs->sp != kcb->jprobe_saved_sp) {
 			struct pt_regs *saved_regs =
 			    container_of(kcb->jprobe_saved_sp,
 					    struct pt_regs, sp);
 			printk("current sp %p does not match saved sp %p\n",
-			       (long *)regs->sp, kcb->jprobe_saved_sp);
+			       &regs->sp, kcb->jprobe_saved_sp);
 			printk("Saved registers for jprobe %p\n", jp);
 			show_registers(saved_regs);
 			printk("Current registers\n");
-- 
1.5.4.rc0.1083.gf568


>From 83fde2864abcc34ef8bc575a22b5f8e76477b64b Mon Sep 17 00:00:00 2001
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Fri, 14 Dec 2007 22:56:50 -0800
Subject: [PATCH] x86: Duplicate some instruction IP logic

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes_32.c |    8 ++++++++
 arch/x86/kernel/kprobes_64.c |   22 +++++++++++++++++++++-
 2 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index a2b5ca7..23fb9ae 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -721,6 +721,7 @@ static void __kprobes resume_execution(struct kprobe *p,
 		break;
 	}
 
+#ifdef CONFIG_X86_32
 	if (p->ainsn.boostable == 0) {
 		if ((regs->ip > copy_ip) &&
 		    (regs->ip - copy_ip) + 5 < (MAX_INSN_SIZE + 1)) {
@@ -739,6 +740,13 @@ static void __kprobes resume_execution(struct kprobe *p,
 	regs->ip = orig_ip + (regs->ip - copy_ip);
 
 no_change:
+#else
+	if (next_rip) {
+		regs->ip = next_rip;
+	} else {
+		regs->ip = orig_ip + (regs->ip - copy_ip);
+	}
+#endif
 	restore_btf();
 }
 
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 705cb99..f9cede4 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -719,12 +719,32 @@ static void __kprobes resume_execution(struct kprobe *p,
 		break;
 	}
 
+#ifdef CONFIG_X86_32
+	if (p->ainsn.boostable == 0) {
+		if ((regs->ip > copy_ip) &&
+		    (regs->ip - copy_ip) + 5 < (MAX_INSN_SIZE + 1)) {
+			/*
+			 * These instructions can be executed directly if it
+			 * jumps back to correct address.
+			 */
+			set_jmp_op((void *)regs->ip,
+				   (void *)orig_ip + (regs->ip - copy_ip));
+			p->ainsn.boostable = 1;
+		} else {
+			p->ainsn.boostable = -1;
+		}
+	}
+
+	regs->ip = orig_ip + (regs->ip - copy_ip);
+
+no_change:
+#else
 	if (next_rip) {
 		regs->ip = next_rip;
 	} else {
 		regs->ip = orig_ip + (regs->ip - copy_ip);
 	}
-
+#endif
 	restore_btf();
 }
 
-- 
1.5.4.rc0.1083.gf568


>From 323525be495dc545158fe43e072523d994253c39 Mon Sep 17 00:00:00 2001
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Sat, 15 Dec 2007 00:28:58 -0800
Subject: [PATCH] x86: Uglify kprobes_{32|64}.c before final unification

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes_32.c |   92 ++++++++++++++++++++++++++------
 arch/x86/kernel/kprobes_64.c |  118 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 172 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index 23fb9ae..cb836ce 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -16,15 +16,6 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2002, 2004
- *
- * 2002-Oct	Created by Vamsi Krishna S <vamsi_krishna@in.ibm.com> Kernel
- *		Probes initial implementation ( includes contributions from
- *		Rusty Russell).
- * 2004-July	Suparna Bhattacharya <suparna@in.ibm.com> added jumper probes
- *		interface to access function arguments.
- * 2005-May	Hien Nguyen <hien@us.ibm.com>, Jim Keniston
- *		<jkenisto@us.ibm.com> and Prasanna S Panchamukhi
- *		<prasanna@in.ibm.com> added function-return probes.
  */
 
 #include <linux/kprobes.h>
@@ -350,7 +341,11 @@ void __kprobes arch_disarm_kprobe(struct kprobe *p)
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
 	mutex_lock(&kprobe_mutex);
+#ifdef CONFIG_X86_32
 	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
+#else
+	free_insn_slot(p->ainsn.insn, 0);
+#endif
 	mutex_unlock(&kprobe_mutex);
 }
 
@@ -471,7 +466,11 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 			 * another cpu right after we hit, no further
 			 * handling of this interrupt is appropriate
 			 */
+#ifdef CONFIG_X86_32
 				regs->ip -= sizeof(kprobe_opcode_t);
+#else
+				regs->ip = (unsigned long)addr;
+#endif
 				ret = 1;
 				goto no_kprobe;
 			}
@@ -495,7 +494,11 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 			 * Back up over the (now missing) int3 and run
 			 * the original instruction.
 			 */
+#ifdef CONFIG_X86_32
 			regs->ip -= sizeof(kprobe_opcode_t);
+#else
+			regs->ip = (unsigned long)addr;
+#endif
 			ret = 1;
 		}
 		/* Not one of ours: let kernel handle it */
@@ -510,7 +513,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 		return 1;
 
 ss_probe:
-#if !defined(CONFIG_PREEMPT) || defined(CONFIG_PM)
+#if defined(CONFIG_X86_32) && (!defined(CONFIG_PREEMPT) || defined(CONFIG_PM))
 	if (p->ainsn.boostable == 1 && !p->post_handler){
 		/* Boost up -- we can execute copied instructions directly */
 		reset_current_kprobe();
@@ -579,7 +582,11 @@ void kretprobe_trampoline_holder(void)
 /*
  * Called when we hit the probe point at kretprobe_trampoline
  */
+#ifdef CONFIG_X86_32
 void *__kprobes trampoline_handler(struct pt_regs *regs)
+#else
+int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
+#endif
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
@@ -590,11 +597,12 @@ void *__kprobes trampoline_handler(struct pt_regs *regs)
 	INIT_HLIST_HEAD(&empty_rp);
 	spin_lock_irqsave(&kretprobe_lock, flags);
 	head = kretprobe_inst_table_head(current);
+#ifdef CONFIG_X86_32
 	/* fixup registers */
 	regs->cs = __KERNEL_CS | get_kernel_rpl();
 	regs->ip = trampoline_address;
 	regs->orig_ax = 0xffffffff;
-
+#endif
 	/*
 	 * It is possible to have multiple instances associated with a given
 	 * task either because an multiple functions in the call path
@@ -612,14 +620,17 @@ void *__kprobes trampoline_handler(struct pt_regs *regs)
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;
-
-		if (ri->rp && ri->rp->handler){
+#ifdef CONFIG_X86_32
+		if (ri->rp && ri->rp->handler) {
 			__get_cpu_var(current_kprobe) = &ri->rp->kp;
 			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
 			ri->rp->handler(ri, regs);
 			__get_cpu_var(current_kprobe) = NULL;
 		}
-
+#else
+		if (ri->rp && ri->rp->handler)
+			ri->rp->handler(ri, regs);
+#endif
 		orig_ret_address = (unsigned long)ri->ret_addr;
 		recycle_rp_inst(ri, &empty_rp);
 
@@ -633,13 +644,29 @@ void *__kprobes trampoline_handler(struct pt_regs *regs)
 	}
 
 	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+#ifdef CONFIG_X86_64
+	regs->ip = orig_ret_address;
+	reset_current_kprobe();
+#endif
 	spin_unlock_irqrestore(&kretprobe_lock, flags);
-
+#ifdef CONFIG_X86_64
+	preempt_enable_no_resched();
+#endif
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
+
+#ifdef CONFIG_X86_32
 	return (void*)orig_ret_address;
+#else
+	/*
+	 * By returning a non-zero value, we are telling
+	 * kprobe_handler() that we don't want the post_handler
+	 * to run (and have re-enabled preemption)
+	 */
+	return 1;
+#endif
 }
 
 /*
@@ -687,22 +714,29 @@ static void __kprobes resume_execution(struct kprobe *p,
 		*tos &= ~(TF_MASK | IF_MASK);
 		*tos |= kcb->kprobe_old_flags;
 		break;
-	case 0xc2:		/* iret/ret/lret */
+	case 0xc2:		/* ret/lret */
 	case 0xc3:
 	case 0xca:
 	case 0xcb:
-	case 0xcf:
-	case 0xea:		/* jmp absolute -- ip is correct */
+#ifdef CONFIG_X86_32
+	case 0xcf:		/* iret */
 		/* ip is already adjusted, no more changes required */
 		p->ainsn.boostable = 1;
 		goto no_change;
+#else
+		/* ip is already adjusted, no more changes required*/
+		return;
+#endif
 	case 0xe8:		/* call relative - Fix return addr */
 		*tos = orig_ip + (*tos - copy_ip);
 		break;
+#ifdef CONFIG_X86_32
 	case 0x9a:		/* call absolute -- same as call absolute, indirect */
 		*tos = orig_ip + (*tos - copy_ip);
 		goto no_change;
+#endif
 	case 0xff:
+#ifdef CONFIG_X86_32
 		if ((insn[1] & 0x30) == 0x10) {
 			/*
 			 * call absolute, indirect
@@ -717,6 +751,28 @@ static void __kprobes resume_execution(struct kprobe *p,
 			p->ainsn.boostable = 1;
 			goto no_change;
 		}
+#else
+		if ((insn[1] & 0x30) == 0x10) {
+			/* call absolute, indirect */
+			/* Fix return addr; ip is correct. */
+			next_rip = regs->ip;
+			*tos = orig_ip + (*tos - copy_ip);
+		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
+			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
+			/* ip is correct. */
+			next_rip = regs->ip;
+		}
+#endif
+		break;
+	case 0xea:		/* jmp absolute -- ip is correct */
+#ifdef CONFIG_X86_32
+		/* ip is already adjusted, no more changes required */
+		p->ainsn.boostable = 1;
+		goto no_change;
+#else
+		next_rip = regs->ip;
+		break;
+#endif
 	default:
 		break;
 	}
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index f9cede4..6761a80 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -16,18 +16,6 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * Copyright (C) IBM Corporation, 2002, 2004
- *
- * 2002-Oct	Created by Vamsi Krishna S <vamsi_krishna@in.ibm.com> Kernel
- *		Probes initial implementation ( includes contributions from
- *		Rusty Russell).
- * 2004-July	Suparna Bhattacharya <suparna@in.ibm.com> added jumper probes
- *		interface to access function arguments.
- * 2004-Oct	Jim Keniston <kenistoj@us.ibm.com> and Prasanna S Panchamukhi
- *		<prasanna@in.ibm.com> adapted for x86_64
- * 2005-Mar	Roland McGrath <roland@redhat.com>
- *		Fixed to handle %rip-relative addressing mode correctly.
- * 2005-May     Rusty Lynch <rusty.lynch@intel.com>
- *              Added function return probes functionality
  */
 
 #include <linux/kprobes.h>
@@ -356,7 +344,11 @@ void __kprobes arch_disarm_kprobe(struct kprobe *p)
 void __kprobes arch_remove_kprobe(struct kprobe *p)
 {
 	mutex_lock(&kprobe_mutex);
+#ifdef CONFIG_X86_32
+	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
+#else
 	free_insn_slot(p->ainsn.insn, 0);
+#endif
 	mutex_unlock(&kprobe_mutex);
 }
 
@@ -429,6 +421,10 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 	*sara = (unsigned long) &kretprobe_trampoline;
 }
 
+/*
+ * Interrupts are disabled on entry as trap3 is an interrupt gate and they
+ * remain disabled thorough out this function.
+ */
 static int __kprobes kprobe_handler(struct pt_regs *regs)
 {
 	struct kprobe *p;
@@ -485,7 +481,11 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 			 * another cpu right after we hit, no further
 			 * handling of this interrupt is appropriate
 			 */
+#ifdef CONFIG_X86_32
+				regs->ip -= sizeof(kprobe_opcode_t);
+#else
 				regs->ip = (unsigned long)addr;
+#endif
 				ret = 1;
 				goto no_kprobe;
 			}
@@ -509,7 +509,11 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 			 * Back up over the (now missing) int3 and run
 			 * the original instruction.
 			 */
+#ifdef CONFIG_X86_32
+			regs->ip -= sizeof(kprobe_opcode_t);
+#else
 			regs->ip = (unsigned long)addr;
+#endif
 			ret = 1;
 		}
 		/* Not one of ours: let kernel handle it */
@@ -524,6 +528,15 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 		return 1;
 
 ss_probe:
+#if defined(CONFIG_X86_32) && (!defined(CONFIG_PREEMPT) || defined(CONFIG_PM))
+	if (p->ainsn.boostable == 1 && !p->post_handler){
+		/* Boost up -- we can execute copied instructions directly */
+		reset_current_kprobe();
+		regs->ip = (unsigned long)p->ainsn.insn;
+		preempt_enable_no_resched();
+		return 1;
+	}
+#endif
 	prepare_singlestep(p, regs);
 	kcb->kprobe_status = KPROBE_HIT_SS;
 	return 1;
@@ -584,7 +597,11 @@ void kretprobe_trampoline_holder(void)
 /*
  * Called when we hit the probe point at kretprobe_trampoline
  */
+#ifdef CONFIG_X86_32
+void *__kprobes trampoline_handler(struct pt_regs *regs)
+#else
 int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
+#endif
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
@@ -595,7 +612,12 @@ int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
 	INIT_HLIST_HEAD(&empty_rp);
 	spin_lock_irqsave(&kretprobe_lock, flags);
 	head = kretprobe_inst_table_head(current);
-
+#ifdef CONFIG_X86_32
+	/* fixup registers */
+	regs->cs = __KERNEL_CS | get_kernel_rpl();
+	regs->ip = trampoline_address;
+	regs->orig_ax = 0xffffffff;
+#endif
 	/*
 	 * It is possible to have multiple instances associated with a given
 	 * task either because an multiple functions in the call path
@@ -613,10 +635,17 @@ int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
 		if (ri->task != current)
 			/* another task is sharing our hash bucket */
 			continue;
-
+#ifdef CONFIG_X86_32
+		if (ri->rp && ri->rp->handler) {
+			__get_cpu_var(current_kprobe) = &ri->rp->kp;
+			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
+			ri->rp->handler(ri, regs);
+			__get_cpu_var(current_kprobe) = NULL;
+		}
+#else
 		if (ri->rp && ri->rp->handler)
 			ri->rp->handler(ri, regs);
-
+#endif
 		orig_ret_address = (unsigned long)ri->ret_addr;
 		recycle_rp_inst(ri, &empty_rp);
 
@@ -630,22 +659,29 @@ int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
 	}
 
 	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+#ifdef CONFIG_X86_64
 	regs->ip = orig_ret_address;
-
 	reset_current_kprobe();
+#endif
 	spin_unlock_irqrestore(&kretprobe_lock, flags);
+#ifdef CONFIG_X86_64
 	preempt_enable_no_resched();
-
+#endif
 	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
 		hlist_del(&ri->hlist);
 		kfree(ri);
 	}
+
+#ifdef CONFIG_X86_32
+	return (void*)orig_ret_address;
+#else
 	/*
 	 * By returning a non-zero value, we are telling
 	 * kprobe_handler() that we don't want the post_handler
 	 * to run (and have re-enabled preemption)
 	 */
 	return 1;
+#endif
 }
 
 /*
@@ -669,6 +705,8 @@ int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
  * 2) If the single-stepped instruction was a call, the return address
  * that is atop the stack is the address following the copied instruction.
  * We need to make it the address following the original instruction.
+ *
+ * This function also checks instruction size for preparing direct execution.
  */
 static void __kprobes resume_execution(struct kprobe *p,
 		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
@@ -691,16 +729,44 @@ static void __kprobes resume_execution(struct kprobe *p,
 		*tos &= ~(TF_MASK | IF_MASK);
 		*tos |= kcb->kprobe_old_flags;
 		break;
-	case 0xc3:		/* ret/lret */
-	case 0xcb:
-	case 0xc2:
+	case 0xc2:		/* ret/lret */
+	case 0xc3:
 	case 0xca:
+	case 0xcb:
+#ifdef CONFIG_X86_32
+	case 0xcf:		/* iret */
+		/* ip is already adjusted, no more changes required */
+		p->ainsn.boostable = 1;
+		goto no_change;
+#else
 		/* ip is already adjusted, no more changes required*/
 		return;
+#endif
 	case 0xe8:		/* call relative - Fix return addr */
 		*tos = orig_ip + (*tos - copy_ip);
 		break;
+#ifdef CONFIG_X86_32
+	case 0x9a:		/* call absolute -- same as call absolute, indirect */
+		*tos = orig_ip + (*tos - copy_ip);
+		goto no_change;
+#endif
 	case 0xff:
+#ifdef CONFIG_X86_32
+		if ((insn[1] & 0x30) == 0x10) {
+			/*
+			 * call absolute, indirect
+			 * Fix return addr; ip is correct.
+			 * But this is not boostable
+			 */
+			*tos = orig_ip + (*tos - copy_ip);
+			goto no_change;
+		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
+			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
+			/* ip is correct. And this is boostable */
+			p->ainsn.boostable = 1;
+			goto no_change;
+		}
+#else
 		if ((insn[1] & 0x30) == 0x10) {
 			/* call absolute, indirect */
 			/* Fix return addr; ip is correct. */
@@ -711,10 +777,17 @@ static void __kprobes resume_execution(struct kprobe *p,
 			/* ip is correct. */
 			next_rip = regs->ip;
 		}
+#endif
 		break;
 	case 0xea:		/* jmp absolute -- ip is correct */
+#ifdef CONFIG_X86_32
+		/* ip is already adjusted, no more changes required */
+		p->ainsn.boostable = 1;
+		goto no_change;
+#else
 		next_rip = regs->ip;
 		break;
+#endif
 	default:
 		break;
 	}
@@ -748,6 +821,10 @@ no_change:
 	restore_btf();
 }
 
+/*
+ * Interrupts are disabled on entry as trap1 is an interrupt gate and they
+ * remain disabled thoroughout this function.
+ */
 static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 {
 	struct kprobe *cur = kprobe_running();
@@ -904,6 +981,7 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	kcb->jprobe_saved_regs = *regs;
 	kcb->jprobe_saved_sp = &regs->sp;
 	addr = (unsigned long)(kcb->jprobe_saved_sp);
+
 	/*
 	 * As Linus pointed out, gcc assumes that the callee
 	 * owns the argument space and could overwrite it, e.g.
-- 
1.5.4.rc0.1083.gf568


>From e7fd0efa2e7860012d0a625c1fda3174ae200dc5 Mon Sep 17 00:00:00 2001
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Sat, 15 Dec 2007 00:36:37 -0800
Subject: [PATCH] x86: Final kprobes_{32|64}.c unification

Sure, it's ugly, but it can only get better from here.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes_32.c |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/kprobes_64.c |   18 ++++++++++++++++++
 2 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index cb836ce..f195348 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -20,10 +20,15 @@
 
 #include <linux/kprobes.h>
 #include <linux/ptrace.h>
+#include <linux/string.h>
+#include <linux/slab.h>
 #include <linux/preempt.h>
+#include <linux/module.h>
 #include <linux/kdebug.h>
+
 #include <asm/cacheflush.h>
 #include <asm/desc.h>
+#include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/alternative.h>
 
@@ -447,6 +452,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 				regs->flags &= ~TF_MASK;
 				regs->flags |= kcb->kprobe_saved_flags;
 				goto no_kprobe;
+#ifdef CONFIG_X86_32
 			}
 			/* We have reentered the kprobe_handler(), since
 			 * another probe was hit while within the handler.
@@ -460,6 +466,33 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 			prepare_singlestep(p, regs);
 			kcb->kprobe_status = KPROBE_REENTER;
 			return 1;
+#else
+			} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
+				/* TODO: Provide re-entrancy from
+				 * post_kprobes_handler() and avoid exception
+				 * stack corruption while single-stepping on
+				 * the instruction of the new probe.
+				 */
+				arch_disarm_kprobe(p);
+				regs->ip = (unsigned long)p->addr;
+				reset_current_kprobe();
+				ret = 1;
+			} else {
+				/* We have reentered the kprobe_handler(), since
+				 * another probe was hit while within the
+				 * handler. We here save the original kprobe
+				 * variables and just single step on instruction
+				 * of the new probe without calling any user
+				 * handlers.
+				 */
+				save_previous_kprobe(kcb);
+				set_current_kprobe(p, regs, kcb);
+				kprobes_inc_nmissed_count(p);
+				prepare_singlestep(p, regs);
+				kcb->kprobe_status = KPROBE_REENTER;
+				return 1;
+			}
+#endif
 		} else {
 			if (*addr != BREAKPOINT_INSTRUCTION) {
 			/* The breakpoint instruction was removed by
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
index 6761a80..f195348 100644
--- a/arch/x86/kernel/kprobes_64.c
+++ b/arch/x86/kernel/kprobes_64.c
@@ -26,6 +26,8 @@
 #include <linux/module.h>
 #include <linux/kdebug.h>
 
+#include <asm/cacheflush.h>
+#include <asm/desc.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/alternative.h>
@@ -450,6 +452,21 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 				regs->flags &= ~TF_MASK;
 				regs->flags |= kcb->kprobe_saved_flags;
 				goto no_kprobe;
+#ifdef CONFIG_X86_32
+			}
+			/* We have reentered the kprobe_handler(), since
+			 * another probe was hit while within the handler.
+			 * We here save the original kprobes variables and
+			 * just single step on the instruction of the new probe
+			 * without calling any user handlers.
+			 */
+			save_previous_kprobe(kcb);
+			set_current_kprobe(p, regs, kcb);
+			kprobes_inc_nmissed_count(p);
+			prepare_singlestep(p, regs);
+			kcb->kprobe_status = KPROBE_REENTER;
+			return 1;
+#else
 			} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
 				/* TODO: Provide re-entrancy from
 				 * post_kprobes_handler() and avoid exception
@@ -475,6 +492,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 				kcb->kprobe_status = KPROBE_REENTER;
 				return 1;
 			}
+#endif
 		} else {
 			if (*addr != BREAKPOINT_INSTRUCTION) {
 			/* The breakpoint instruction was removed by
-- 
1.5.4.rc0.1083.gf568


>From 7fe6bd404ae0c51ec0bd334ca28a1f17f247a099 Mon Sep 17 00:00:00 2001
From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Sat, 15 Dec 2007 00:39:44 -0800
Subject: [PATCH] x86: Eliminate kprobes_{32|64}.c

Now that the files are the same, unify the makefiles and
eliminate the duplicates.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/Makefile_32  |    2 +-
 arch/x86/kernel/Makefile_64  |    2 +-
 arch/x86/kernel/kprobes.c    | 1090 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/kprobes_32.c | 1090 ------------------------------------------
 arch/x86/kernel/kprobes_64.c | 1090 ------------------------------------------
 5 files changed, 1092 insertions(+), 2182 deletions(-)

diff --git a/arch/x86/kernel/Makefile_32 b/arch/x86/kernel/Makefile_32
index db8cada..62a8120 100644
--- a/arch/x86/kernel/Makefile_32
+++ b/arch/x86/kernel/Makefile_32
@@ -35,7 +35,7 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec_32.o relocate_kernel_32.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_32.o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 obj-$(CONFIG_X86_SUMMIT_NUMA)	+= summit_32.o
-obj-$(CONFIG_KPROBES)		+= kprobes_32.o
+obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_MODULES)		+= module_32.o
 obj-$(CONFIG_ACPI_SRAT) 	+= srat_32.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_32.o efi_stub_32.o
diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
index a961f5c..79e335c 100644
--- a/arch/x86/kernel/Makefile_64
+++ b/arch/x86/kernel/Makefile_64
@@ -34,7 +34,7 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
 obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb_64.o
-obj-$(CONFIG_KPROBES)		+= kprobes_64.o
+obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer_64.o
 obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
 obj-$(CONFIG_K8_NB)		+= k8.o
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
new file mode 100644
index 0000000..f195348
--- /dev/null
+++ b/arch/x86/kernel/kprobes.c
@@ -0,0 +1,1090 @@
+/*
+ *  Kernel Probes (KProbes)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2002, 2004
+ */
+
+#include <linux/kprobes.h>
+#include <linux/ptrace.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/preempt.h>
+#include <linux/module.h>
+#include <linux/kdebug.h>
+
+#include <asm/cacheflush.h>
+#include <asm/desc.h>
+#include <asm/pgtable.h>
+#include <asm/uaccess.h>
+#include <asm/alternative.h>
+
+void jprobe_return_end(void);
+static void __kprobes arch_copy_kprobe(struct kprobe *p);
+
+DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
+DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
+
+struct kretprobe_blackpoint kretprobe_blacklist[] = {
+	{"__switch_to", }, /* This function switches only current task, but
+			      doesn't switch kernel stack.*/
+	{NULL, NULL}	/* Terminator */
+};
+const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
+
+#define W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)  \
+	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
+	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
+	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
+	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
+	 << (r % sizeof(unsigned long)))
+
+#define R1(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
+#define R3(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
+#define R4(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf),
+#define RF(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)
+
+#ifdef CONFIG_X86_32
+#define R2(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf),
+#else
+#define R2(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
+	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
+#endif
+
+/*
+ * Undefined/reserved opcodes, conditional jump, Opcode Extension
+ * Groups, and some special opcodes can not be boost.
+ */
+static const unsigned long
+twobyte_is_boostable[256 / sizeof(unsigned long)] = {
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+	/*      -----------------------------------------------        */
+	R1(0x00, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0) /* 00 */
+	R2(0x10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 10 */
+	R3(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 20 */
+	R4(0x30, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 30 */
+	R1(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 40 */
+	R2(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 50 */
+	R3(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1) /* 60 */
+	R4(0x70, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) /* 70 */
+	R1(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 80 */
+	R2(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 90 */
+	R3(0xa0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* a0 */
+	R4(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) /* b0 */
+	R1(0xc0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* c0 */
+	R2(0xd0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* d0 */
+	R3(0xe0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* e0 */
+	RF(0xf0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0) /* f0 */
+	/*      -----------------------------------------------        */
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+};
+
+static const unsigned long
+onebyte_has_modrm[256 / sizeof(unsigned long)] = {
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+	/*      -----------------------------------------------        */
+	R1(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 00 */
+	R2(0x10, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 10 */
+	R3(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 20 */
+	R4(0x30, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 30 */
+	R1(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 40 */
+	R2(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 50 */
+	R3(0x60, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0) /* 60 */
+	R4(0x70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 70 */
+	R1(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 80 */
+	R2(0x90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 90 */
+	R3(0xa0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* a0 */
+	R4(0xb0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* b0 */
+	R1(0xc0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) /* c0 */
+	R2(0xd0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* d0 */
+	R3(0xe0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* e0 */
+	RF(0xf0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) /* f0 */
+	/*      -----------------------------------------------        */
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+};
+
+static const unsigned long
+twobyte_has_modrm[256 / sizeof(unsigned long)] = {
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+	/*      -----------------------------------------------        */
+	R1(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1) /* 0f */
+	R2(0x10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0) /* 1f */
+	R3(0x20, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* 2f */
+	R4(0x30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 3f */
+	R1(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 4f */
+	R2(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 5f */
+	R3(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 6f */
+	R4(0x70, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1) /* 7f */
+	R1(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 8f */
+	R2(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 9f */
+	R3(0xa0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) /* af */
+	R4(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1) /* bf */
+	R1(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) /* cf */
+	R2(0xd0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* df */
+	R3(0xe0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* ef */
+	RF(0xf0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0) /* ff */
+	/*      -----------------------------------------------        */
+	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
+};
+
+#undef W
+#undef R1
+#undef R2
+#undef R3
+#undef R4
+#undef RF
+
+/* insert a jmp code */
+static inline void set_jmp_op(void *from, void *to)
+{
+	struct __arch_jmp_op {
+		char op;
+		long raddr;
+	} __attribute__((packed)) *jop;
+	jop = (struct __arch_jmp_op *)from;
+	jop->raddr = (long)(to) - ((long)(from) + 5);
+	jop->op = RELATIVEJUMP_INSTRUCTION;
+}
+
+/*
+ * returns non-zero if opcodes can be boosted.
+ */
+static inline int can_boost(kprobe_opcode_t *opcodes)
+{
+	kprobe_opcode_t opcode;
+	kprobe_opcode_t *orig_opcodes = opcodes;
+retry:
+	if (opcodes - orig_opcodes > MAX_INSN_SIZE)
+		return 0;
+	opcode = *(opcodes++);
+
+	/* 2nd-byte opcode */
+	if (opcode == 0x0f) {
+		if (opcodes - orig_opcodes > MAX_INSN_SIZE)
+			return 0;
+		return test_bit(*opcodes, twobyte_is_boostable);
+	}
+
+	switch (opcode & 0xf0) {
+	case 0x60:
+		if (0x63 < opcode && opcode < 0x67)
+			goto retry; /* prefixes */
+		/* can't boost Address-size override and bound */
+		return (opcode != 0x62 && opcode != 0x67);
+	case 0x70:
+		return 0; /* can't boost conditional jump */
+	case 0xc0:
+		/* can't boost software-interruptions */
+		return (0xc1 < opcode && opcode < 0xcc) || opcode == 0xcf;
+	case 0xd0:
+		/* can boost AA* and XLAT */
+		return (opcode == 0xd4 || opcode == 0xd5 || opcode == 0xd7);
+	case 0xe0:
+		/* can boost in/out and absolute jmps */
+		return ((opcode & 0x04) || opcode == 0xea);
+	case 0xf0:
+		if ((opcode & 0x0c) == 0 && opcode != 0xf1)
+			goto retry; /* lock/rep(ne) prefix */
+		/* clear and set flags can be boost */
+		return (opcode == 0xf5 || (0xf7 < opcode && opcode < 0xfe));
+	default:
+		if (opcode == 0x26 || opcode == 0x36 || opcode == 0x3e)
+			goto retry; /* prefixes */
+		/* can't boost CS override and call */
+		return (opcode != 0x2e && opcode != 0x9a);
+	}
+}
+
+/*
+ * returns non-zero if opcode modifies the interrupt flag.
+ */
+static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
+{
+	switch (*insn) {
+	case 0xfa:		/* cli */
+	case 0xfb:		/* sti */
+	case 0xcf:		/* iret/iretd */
+	case 0x9d:		/* popf/popfd */
+		return 1;
+	}
+
+#ifdef CONFIG_X86_64
+	/* REX prefix */
+	if (*insn  >= 0x40 && *insn <= 0x4f && *++insn == 0xcf)
+		return 1;
+#endif
+	return 0;
+}
+
+int __kprobes arch_prepare_kprobe(struct kprobe *p)
+{
+	/* insn: must be on special executable page on x86_32|64. */
+	p->ainsn.insn = get_insn_slot();
+	if (!p->ainsn.insn)
+		return -ENOMEM;
+
+	arch_copy_kprobe(p);
+	return 0;
+}
+
+/*
+ * Determine if the instruction uses the %rip-relative addressing mode.
+ * If it does, return the address of the 32-bit displacement word.
+ * If not, return null.
+ */
+static s32 __kprobes *is_riprel(u8 *insn)
+{
+	int need_modrm;
+
+	/* Skip legacy instruction prefixes.  */
+	while (1) {
+		switch (*insn) {
+		case 0x66:
+		case 0x67:
+		case 0x2e:
+		case 0x3e:
+		case 0x26:
+		case 0x64:
+		case 0x65:
+		case 0x36:
+		case 0xf0:
+		case 0xf3:
+		case 0xf2:
+			++insn;
+			continue;
+		}
+		break;
+	}
+
+	/* Skip REX instruction prefix.  */
+	if ((*insn & 0xf0) == 0x40)
+		++insn;
+
+	if (*insn == 0x0f) {	/* Two-byte opcode.  */
+		++insn;
+		need_modrm = test_bit(*insn, twobyte_has_modrm);
+	} else {		/* One-byte opcode.  */
+		need_modrm = test_bit(*insn, onebyte_has_modrm);
+	}
+
+	if (need_modrm) {
+		u8 modrm = *++insn;
+		if ((modrm & 0xc7) == 0x05) { /* %rip+disp32 addressing mode */
+			/* Displacement follows ModRM byte.  */
+			return (s32 *) ++insn;
+		}
+	}
+
+	/* No %rip-relative addressing mode here.  */
+	return NULL;
+}
+
+static void __kprobes arch_copy_kprobe(struct kprobe *p)
+{
+#ifdef CONFIG_X86_32
+	memcpy(p->ainsn.insn, p->addr, (MAX_INSN_SIZE + 1) * sizeof(kprobe_opcode_t));
+	p->opcode = *p->addr;
+	if (can_boost(p->addr)) {
+		p->ainsn.boostable = 0;
+	} else {
+		p->ainsn.boostable = -1;
+	}
+#else
+	s32 *ripdisp;
+	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE);
+	ripdisp = is_riprel(p->ainsn.insn);
+	if (ripdisp) {
+		/*
+		 * The copied instruction uses the %rip-relative
+		 * addressing mode.  Adjust the displacement for the
+		 * difference between the original location of this
+		 * instruction and the location of the copy that will
+		 * actually be run.  The tricky bit here is making sure
+		 * that the sign extension happens correctly in this
+		 * calculation, since we need a signed 32-bit result to
+		 * be sign-extended to 64 bits when it's added to the
+		 * %rip value and yield the same 64-bit result that the
+		 * sign-extension of the original signed 32-bit
+		 * displacement would have given.
+		 */
+		s64 disp = (u8 *) p->addr + *ripdisp - (u8 *) p->ainsn.insn;
+		BUG_ON((s64) (s32) disp != disp); /* Sanity check.  */
+		*ripdisp = disp;
+	}
+	p->opcode = *p->addr;
+#endif
+}
+
+void __kprobes arch_arm_kprobe(struct kprobe *p)
+{
+	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
+}
+
+void __kprobes arch_disarm_kprobe(struct kprobe *p)
+{
+	text_poke(p->addr, &p->opcode, 1);
+}
+
+void __kprobes arch_remove_kprobe(struct kprobe *p)
+{
+	mutex_lock(&kprobe_mutex);
+#ifdef CONFIG_X86_32
+	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
+#else
+	free_insn_slot(p->ainsn.insn, 0);
+#endif
+	mutex_unlock(&kprobe_mutex);
+}
+
+static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	kcb->prev_kprobe.kp = kprobe_running();
+	kcb->prev_kprobe.status = kcb->kprobe_status;
+	kcb->prev_kprobe.old_flags = kcb->kprobe_old_flags;
+	kcb->prev_kprobe.saved_flags = kcb->kprobe_saved_flags;
+}
+
+static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
+	kcb->kprobe_status = kcb->prev_kprobe.status;
+	kcb->kprobe_old_flags = kcb->prev_kprobe.old_flags;
+	kcb->kprobe_saved_flags = kcb->prev_kprobe.saved_flags;
+}
+
+static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
+				struct kprobe_ctlblk *kcb)
+{
+	__get_cpu_var(current_kprobe) = p;
+	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
+		= (regs->flags & (TF_MASK | IF_MASK));
+	if (is_IF_modifier(p->ainsn.insn))
+		kcb->kprobe_saved_flags &= ~IF_MASK;
+}
+
+static __always_inline void clear_btf(void)
+{
+	if (test_thread_flag(TIF_DEBUGCTLMSR))
+#ifdef CONFIG_X86_32
+		wrmsr(MSR_IA32_DEBUGCTLMSR, 0, 0);
+#else
+		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
+#endif
+}
+
+static __always_inline void restore_btf(void)
+{
+	if (test_thread_flag(TIF_DEBUGCTLMSR))
+#ifdef CONFIG_X86_32
+		wrmsr(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr, 0);
+#else
+		wrmsrl(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr);
+#endif
+}
+
+static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
+{
+	clear_btf();
+	regs->flags |= TF_MASK;
+	regs->flags &= ~IF_MASK;
+	/*single step inline if the instruction is an int3*/
+	if (p->opcode == BREAKPOINT_INSTRUCTION)
+		regs->ip = (unsigned long)p->addr;
+	else
+		regs->ip = (unsigned long)p->ainsn.insn;
+}
+
+/* Called with kretprobe_lock held */
+void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
+				      struct pt_regs *regs)
+{
+	unsigned long *sara = &regs->sp;
+
+	ri->ret_addr = (kprobe_opcode_t *) *sara;
+	/* Replace the return addr with trampoline addr */
+	*sara = (unsigned long) &kretprobe_trampoline;
+}
+
+/*
+ * Interrupts are disabled on entry as trap3 is an interrupt gate and they
+ * remain disabled thorough out this function.
+ */
+static int __kprobes kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *p;
+	int ret = 0;
+	kprobe_opcode_t *addr;
+	struct kprobe_ctlblk *kcb;
+
+	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
+
+	/*
+	 * We don't want to be preempted for the entire
+	 * duration of kprobe processing
+	 */
+	preempt_disable();
+	kcb = get_kprobe_ctlblk();
+
+	/* Check we're not actually recursing */
+	if (kprobe_running()) {
+		p = get_kprobe(addr);
+		if (p) {
+			if (kcb->kprobe_status == KPROBE_HIT_SS &&
+				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
+				regs->flags &= ~TF_MASK;
+				regs->flags |= kcb->kprobe_saved_flags;
+				goto no_kprobe;
+#ifdef CONFIG_X86_32
+			}
+			/* We have reentered the kprobe_handler(), since
+			 * another probe was hit while within the handler.
+			 * We here save the original kprobes variables and
+			 * just single step on the instruction of the new probe
+			 * without calling any user handlers.
+			 */
+			save_previous_kprobe(kcb);
+			set_current_kprobe(p, regs, kcb);
+			kprobes_inc_nmissed_count(p);
+			prepare_singlestep(p, regs);
+			kcb->kprobe_status = KPROBE_REENTER;
+			return 1;
+#else
+			} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
+				/* TODO: Provide re-entrancy from
+				 * post_kprobes_handler() and avoid exception
+				 * stack corruption while single-stepping on
+				 * the instruction of the new probe.
+				 */
+				arch_disarm_kprobe(p);
+				regs->ip = (unsigned long)p->addr;
+				reset_current_kprobe();
+				ret = 1;
+			} else {
+				/* We have reentered the kprobe_handler(), since
+				 * another probe was hit while within the
+				 * handler. We here save the original kprobe
+				 * variables and just single step on instruction
+				 * of the new probe without calling any user
+				 * handlers.
+				 */
+				save_previous_kprobe(kcb);
+				set_current_kprobe(p, regs, kcb);
+				kprobes_inc_nmissed_count(p);
+				prepare_singlestep(p, regs);
+				kcb->kprobe_status = KPROBE_REENTER;
+				return 1;
+			}
+#endif
+		} else {
+			if (*addr != BREAKPOINT_INSTRUCTION) {
+			/* The breakpoint instruction was removed by
+			 * another cpu right after we hit, no further
+			 * handling of this interrupt is appropriate
+			 */
+#ifdef CONFIG_X86_32
+				regs->ip -= sizeof(kprobe_opcode_t);
+#else
+				regs->ip = (unsigned long)addr;
+#endif
+				ret = 1;
+				goto no_kprobe;
+			}
+			p = __get_cpu_var(current_kprobe);
+			if (p->break_handler && p->break_handler(p, regs)) {
+				goto ss_probe;
+			}
+		}
+		goto no_kprobe;
+	}
+
+	p = get_kprobe(addr);
+	if (!p) {
+		if (*addr != BREAKPOINT_INSTRUCTION) {
+			/*
+			 * The breakpoint instruction was removed right
+			 * after we hit it.  Another cpu has removed
+			 * either a probepoint or a debugger breakpoint
+			 * at this address.  In either case, no further
+			 * handling of this interrupt is appropriate.
+			 * Back up over the (now missing) int3 and run
+			 * the original instruction.
+			 */
+#ifdef CONFIG_X86_32
+			regs->ip -= sizeof(kprobe_opcode_t);
+#else
+			regs->ip = (unsigned long)addr;
+#endif
+			ret = 1;
+		}
+		/* Not one of ours: let kernel handle it */
+		goto no_kprobe;
+	}
+
+	set_current_kprobe(p, regs, kcb);
+	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
+
+	if (p->pre_handler && p->pre_handler(p, regs))
+		/* handler has already set things up, so skip ss setup */
+		return 1;
+
+ss_probe:
+#if defined(CONFIG_X86_32) && (!defined(CONFIG_PREEMPT) || defined(CONFIG_PM))
+	if (p->ainsn.boostable == 1 && !p->post_handler){
+		/* Boost up -- we can execute copied instructions directly */
+		reset_current_kprobe();
+		regs->ip = (unsigned long)p->ainsn.insn;
+		preempt_enable_no_resched();
+		return 1;
+	}
+#endif
+	prepare_singlestep(p, regs);
+	kcb->kprobe_status = KPROBE_HIT_SS;
+	return 1;
+
+no_kprobe:
+	preempt_enable_no_resched();
+	return ret;
+}
+
+/*
+ * For function-return probes, init_kprobes() establishes a probepoint
+ * here. When a retprobed function returns, this probe is hit and
+ * trampoline_probe_handler() runs, calling the kretprobe's handler.
+ */
+void kretprobe_trampoline_holder(void)
+{
+#ifdef CONFIG_X86_32
+	asm volatile ( ".global kretprobe_trampoline\n"
+			"kretprobe_trampoline: \n"
+			"	pushf\n"
+			/* skip cs, ip, orig_ax */
+			"	subl $12, %esp\n"
+			"	pushl %fs\n"
+			"	pushl %ds\n"
+			"	pushl %es\n"
+			"	pushl %eax\n"
+			"	pushl %ebp\n"
+			"	pushl %edi\n"
+			"	pushl %esi\n"
+			"	pushl %edx\n"
+			"	pushl %ecx\n"
+			"	pushl %ebx\n"
+			"	movl %esp, %eax\n"
+			"	call trampoline_handler\n"
+			/* move flags to cs */
+			"	movl 52(%esp), %edx\n"
+			"	movl %edx, 48(%esp)\n"
+			/* save true return address on flags */
+			"	movl %eax, 52(%esp)\n"
+			"	popl %ebx\n"
+			"	popl %ecx\n"
+			"	popl %edx\n"
+			"	popl %esi\n"
+			"	popl %edi\n"
+			"	popl %ebp\n"
+			"	popl %eax\n"
+			/* skip ip, orig_ax, es, ds, fs */
+			"	addl $20, %esp\n"
+			"	popf\n"
+			"	ret\n");
+#else
+	asm volatile (  ".global kretprobe_trampoline\n"
+			"kretprobe_trampoline: \n"
+			"nop\n");
+#endif
+}
+
+/*
+ * Called when we hit the probe point at kretprobe_trampoline
+ */
+#ifdef CONFIG_X86_32
+void *__kprobes trampoline_handler(struct pt_regs *regs)
+#else
+int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
+#endif
+{
+	struct kretprobe_instance *ri = NULL;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *node, *tmp;
+	unsigned long flags, orig_ret_address = 0;
+	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
+
+	INIT_HLIST_HEAD(&empty_rp);
+	spin_lock_irqsave(&kretprobe_lock, flags);
+	head = kretprobe_inst_table_head(current);
+#ifdef CONFIG_X86_32
+	/* fixup registers */
+	regs->cs = __KERNEL_CS | get_kernel_rpl();
+	regs->ip = trampoline_address;
+	regs->orig_ax = 0xffffffff;
+#endif
+	/*
+	 * It is possible to have multiple instances associated with a given
+	 * task either because an multiple functions in the call path
+	 * have a return probe installed on them, and/or more then one return
+	 * return probe was registered for a target function.
+	 *
+	 * We can handle this because:
+	 *     - instances are always inserted at the head of the list
+	 *     - when multiple return probes are registered for the same
+	 *       function, the first instance's ret_addr will point to the
+	 *       real return address, and all the rest will point to
+	 *       kretprobe_trampoline
+	 */
+	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+#ifdef CONFIG_X86_32
+		if (ri->rp && ri->rp->handler) {
+			__get_cpu_var(current_kprobe) = &ri->rp->kp;
+			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
+			ri->rp->handler(ri, regs);
+			__get_cpu_var(current_kprobe) = NULL;
+		}
+#else
+		if (ri->rp && ri->rp->handler)
+			ri->rp->handler(ri, regs);
+#endif
+		orig_ret_address = (unsigned long)ri->ret_addr;
+		recycle_rp_inst(ri, &empty_rp);
+
+		if (orig_ret_address != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+#ifdef CONFIG_X86_64
+	regs->ip = orig_ret_address;
+	reset_current_kprobe();
+#endif
+	spin_unlock_irqrestore(&kretprobe_lock, flags);
+#ifdef CONFIG_X86_64
+	preempt_enable_no_resched();
+#endif
+	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
+
+#ifdef CONFIG_X86_32
+	return (void*)orig_ret_address;
+#else
+	/*
+	 * By returning a non-zero value, we are telling
+	 * kprobe_handler() that we don't want the post_handler
+	 * to run (and have re-enabled preemption)
+	 */
+	return 1;
+#endif
+}
+
+/*
+ * Called after single-stepping.  p->addr is the address of the
+ * instruction whose first byte has been replaced by the "int 3"
+ * instruction.  To avoid the SMP problems that can occur when we
+ * temporarily put back the original opcode to single-step, we
+ * single-stepped a copy of the instruction.  The address of this
+ * copy is p->ainsn.insn.
+ *
+ * This function prepares to return from the post-single-step
+ * interrupt.  We have to fix up the stack as follows:
+ *
+ * 0) Except in the case of absolute or indirect jump or call instructions,
+ * the new ip is relative to the copied instruction.  We need to make
+ * it relative to the original instruction.
+ *
+ * 1) If the single-stepped instruction was pushfl, then the TF and IF
+ * flags are set in the just-pushed flags, and may need to be cleared.
+ *
+ * 2) If the single-stepped instruction was a call, the return address
+ * that is atop the stack is the address following the copied instruction.
+ * We need to make it the address following the original instruction.
+ *
+ * This function also checks instruction size for preparing direct execution.
+ */
+static void __kprobes resume_execution(struct kprobe *p,
+		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
+{
+	unsigned long *tos = &regs->sp;
+	unsigned long next_rip = 0;
+	unsigned long copy_ip = (unsigned long)p->ainsn.insn;
+	unsigned long orig_ip = (unsigned long)p->addr;
+	kprobe_opcode_t *insn = p->ainsn.insn;
+
+#ifdef CONFIG_X86_64
+	/*skip the REX prefix*/
+	if (*insn >= 0x40 && *insn <= 0x4f)
+		insn++;
+#endif
+
+	regs->flags &= ~TF_MASK;
+	switch (*insn) {
+	case 0x9c:		/* pushfl */
+		*tos &= ~(TF_MASK | IF_MASK);
+		*tos |= kcb->kprobe_old_flags;
+		break;
+	case 0xc2:		/* ret/lret */
+	case 0xc3:
+	case 0xca:
+	case 0xcb:
+#ifdef CONFIG_X86_32
+	case 0xcf:		/* iret */
+		/* ip is already adjusted, no more changes required */
+		p->ainsn.boostable = 1;
+		goto no_change;
+#else
+		/* ip is already adjusted, no more changes required*/
+		return;
+#endif
+	case 0xe8:		/* call relative - Fix return addr */
+		*tos = orig_ip + (*tos - copy_ip);
+		break;
+#ifdef CONFIG_X86_32
+	case 0x9a:		/* call absolute -- same as call absolute, indirect */
+		*tos = orig_ip + (*tos - copy_ip);
+		goto no_change;
+#endif
+	case 0xff:
+#ifdef CONFIG_X86_32
+		if ((insn[1] & 0x30) == 0x10) {
+			/*
+			 * call absolute, indirect
+			 * Fix return addr; ip is correct.
+			 * But this is not boostable
+			 */
+			*tos = orig_ip + (*tos - copy_ip);
+			goto no_change;
+		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
+			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
+			/* ip is correct. And this is boostable */
+			p->ainsn.boostable = 1;
+			goto no_change;
+		}
+#else
+		if ((insn[1] & 0x30) == 0x10) {
+			/* call absolute, indirect */
+			/* Fix return addr; ip is correct. */
+			next_rip = regs->ip;
+			*tos = orig_ip + (*tos - copy_ip);
+		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
+			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
+			/* ip is correct. */
+			next_rip = regs->ip;
+		}
+#endif
+		break;
+	case 0xea:		/* jmp absolute -- ip is correct */
+#ifdef CONFIG_X86_32
+		/* ip is already adjusted, no more changes required */
+		p->ainsn.boostable = 1;
+		goto no_change;
+#else
+		next_rip = regs->ip;
+		break;
+#endif
+	default:
+		break;
+	}
+
+#ifdef CONFIG_X86_32
+	if (p->ainsn.boostable == 0) {
+		if ((regs->ip > copy_ip) &&
+		    (regs->ip - copy_ip) + 5 < (MAX_INSN_SIZE + 1)) {
+			/*
+			 * These instructions can be executed directly if it
+			 * jumps back to correct address.
+			 */
+			set_jmp_op((void *)regs->ip,
+				   (void *)orig_ip + (regs->ip - copy_ip));
+			p->ainsn.boostable = 1;
+		} else {
+			p->ainsn.boostable = -1;
+		}
+	}
+
+	regs->ip = orig_ip + (regs->ip - copy_ip);
+
+no_change:
+#else
+	if (next_rip) {
+		regs->ip = next_rip;
+	} else {
+		regs->ip = orig_ip + (regs->ip - copy_ip);
+	}
+#endif
+	restore_btf();
+}
+
+/*
+ * Interrupts are disabled on entry as trap1 is an interrupt gate and they
+ * remain disabled thoroughout this function.
+ */
+static int __kprobes post_kprobe_handler(struct pt_regs *regs)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	if (!cur)
+		return 0;
+
+	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
+		kcb->kprobe_status = KPROBE_HIT_SSDONE;
+		cur->post_handler(cur, regs, 0);
+	}
+
+	resume_execution(cur, regs, kcb);
+	regs->flags |= kcb->kprobe_saved_flags;
+	trace_hardirqs_fixup_flags(regs->flags);
+
+	/* Restore the original saved kprobes variables and continue. */
+	if (kcb->kprobe_status == KPROBE_REENTER) {
+		restore_previous_kprobe(kcb);
+		goto out;
+	}
+	reset_current_kprobe();
+out:
+	preempt_enable_no_resched();
+
+	/*
+	 * if somebody else is singlestepping across a probe point, flags
+	 * will have TF set, in which case, continue the remaining processing
+	 * of do_debug, as if this is not a probe hit.
+	 */
+	if (regs->flags & TF_MASK)
+		return 0;
+
+	return 1;
+}
+
+int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
+{
+	struct kprobe *cur = kprobe_running();
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+#ifdef CONFIG_X86_64
+	const struct exception_table_entry *fixup;
+#endif
+
+	switch(kcb->kprobe_status) {
+	case KPROBE_HIT_SS:
+	case KPROBE_REENTER:
+		/*
+		 * We are here because the instruction being single
+		 * stepped caused a page fault. We reset the current
+		 * kprobe and the ip points back to the probe address
+		 * and allow the page fault handler to continue as a
+		 * normal page fault.
+		 */
+		regs->ip = (unsigned long)cur->addr;
+		regs->flags |= kcb->kprobe_old_flags;
+		if (kcb->kprobe_status == KPROBE_REENTER)
+			restore_previous_kprobe(kcb);
+		else
+			reset_current_kprobe();
+		preempt_enable_no_resched();
+		break;
+	case KPROBE_HIT_ACTIVE:
+	case KPROBE_HIT_SSDONE:
+		/*
+		 * We increment the nmissed count for accounting,
+		 * we can also use npre/npostfault count for accouting
+		 * these specific fault cases.
+		 */
+		kprobes_inc_nmissed_count(cur);
+
+		/*
+		 * We come here because instructions in the pre/post
+		 * handler caused the page_fault, this could happen
+		 * if handler tries to access user space by
+		 * copy_from_user(), get_user() etc. Let the
+		 * user-specified handler try to fix it first.
+		 */
+		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
+			return 1;
+
+		/*
+		 * In case the user-specified fault handler returned
+		 * zero, try to fix up.
+		 */
+#ifdef CONFIG_X86_32
+		if (fixup_exception(regs))
+			return 1;
+#else
+		fixup = search_exception_tables(regs->ip);
+		if (fixup) {
+			regs->ip = fixup->fixup;
+			return 1;
+		}
+#endif
+		/*
+		 * Exception couldn't be fixed up,
+		 * Let do_page_fault() fix it.
+		 */
+		break;
+	default:
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Wrapper routine for handling exceptions.
+ */
+int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
+				       unsigned long val, void *data)
+{
+	struct die_args *args = (struct die_args *)data;
+	int ret = NOTIFY_DONE;
+
+#ifdef CONFIG_X86_32
+	if (args->regs && user_mode_vm(args->regs))
+		return ret;
+#else
+	if (args->regs && user_mode(args->regs))
+		return ret;
+#endif
+
+	switch (val) {
+	case DIE_INT3:
+		if (kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	case DIE_DEBUG:
+		if (post_kprobe_handler(args->regs))
+			ret = NOTIFY_STOP;
+		break;
+	case DIE_GPF:
+		/* kprobe_running() needs smp_processor_id() */
+		preempt_disable();
+		if (kprobe_running() &&
+		    kprobe_fault_handler(args->regs, args->trapnr))
+			ret = NOTIFY_STOP;
+		preempt_enable();
+		break;
+	default:
+		break;
+	}
+	return ret;
+}
+
+int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+	unsigned long addr;
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+
+	kcb->jprobe_saved_regs = *regs;
+	kcb->jprobe_saved_sp = &regs->sp;
+	addr = (unsigned long)(kcb->jprobe_saved_sp);
+
+	/*
+	 * As Linus pointed out, gcc assumes that the callee
+	 * owns the argument space and could overwrite it, e.g.
+	 * tailcall optimization. So, to be absolutely safe
+	 * we also save and restore enough stack bytes to cover
+	 * the argument area.
+	 */
+	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *)addr,
+			MIN_STACK_SIZE(addr));
+	regs->flags &= ~IF_MASK;
+	trace_hardirqs_off();
+	regs->ip = (unsigned long)(jp->entry);
+	return 1;
+}
+
+void __kprobes jprobe_return(void)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+#ifdef CONFIG_X86_32
+	asm volatile ("       xchgl   %%ebx,%%esp     \n"
+		      "       int3			\n"
+		      "       .globl jprobe_return_end	\n"
+		      "       jprobe_return_end:	\n"
+		      "       nop			\n"::"b"
+		      (kcb->jprobe_saved_sp):"memory");
+#else
+	asm volatile ("       xchg   %%rbx,%%rsp     \n"
+		      "       int3			\n"
+		      "       .globl jprobe_return_end	\n"
+		      "       jprobe_return_end:	\n"
+		      "       nop			\n"::"b"
+		      (kcb->jprobe_saved_sp):"memory");
+#endif
+}
+
+int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
+{
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	u8 *addr = (u8 *) (regs->ip - 1);
+	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_sp);
+	struct jprobe *jp = container_of(p, struct jprobe, kp);
+
+	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
+		if (&regs->sp != kcb->jprobe_saved_sp) {
+			struct pt_regs *saved_regs =
+			    container_of(kcb->jprobe_saved_sp,
+					    struct pt_regs, sp);
+			printk("current sp %p does not match saved sp %p\n",
+			       &regs->sp, kcb->jprobe_saved_sp);
+			printk("Saved registers for jprobe %p\n", jp);
+			show_registers(saved_regs);
+			printk("Current registers\n");
+			show_registers(regs);
+			BUG();
+		}
+		*regs = kcb->jprobe_saved_regs;
+		memcpy((kprobe_opcode_t *) stack_addr, kcb->jprobes_stack,
+		       MIN_STACK_SIZE(stack_addr));
+		preempt_enable_no_resched();
+		return 1;
+	}
+	return 0;
+}
+
+#ifdef CONFIG_X86_64
+static struct kprobe trampoline_p = {
+	.addr = (kprobe_opcode_t *) &kretprobe_trampoline,
+	.pre_handler = trampoline_probe_handler
+};
+#endif
+
+int __kprobes arch_trampoline_kprobe(struct kprobe *p)
+{
+#ifdef CONFIG_X86_64
+	if (p->addr == (kprobe_opcode_t *)&kretprobe_trampoline)
+		return 1;
+#endif
+	return 0;
+}
+
+int __init arch_init_kprobes(void)
+{
+#ifdef CONFIG_X86_32
+	return 0;
+#else
+	return register_kprobe(&trampoline_p);
+#endif
+}
diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
deleted file mode 100644
index f195348..0000000
--- a/arch/x86/kernel/kprobes_32.c
+++ /dev/null
@@ -1,1090 +0,0 @@
-/*
- *  Kernel Probes (KProbes)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright (C) IBM Corporation, 2002, 2004
- */
-
-#include <linux/kprobes.h>
-#include <linux/ptrace.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/preempt.h>
-#include <linux/module.h>
-#include <linux/kdebug.h>
-
-#include <asm/cacheflush.h>
-#include <asm/desc.h>
-#include <asm/pgtable.h>
-#include <asm/uaccess.h>
-#include <asm/alternative.h>
-
-void jprobe_return_end(void);
-static void __kprobes arch_copy_kprobe(struct kprobe *p);
-
-DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
-DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
-
-struct kretprobe_blackpoint kretprobe_blacklist[] = {
-	{"__switch_to", }, /* This function switches only current task, but
-			      doesn't switch kernel stack.*/
-	{NULL, NULL}	/* Terminator */
-};
-const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
-
-#define W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)  \
-	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
-	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
-	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
-	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
-	 << (r % sizeof(unsigned long)))
-
-#define R1(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
-	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
-#define R3(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
-	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
-#define R4(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
-	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf),
-#define RF(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
-	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)
-
-#ifdef CONFIG_X86_32
-#define R2(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
-	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf),
-#else
-#define R2(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
-	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
-#endif
-
-/*
- * Undefined/reserved opcodes, conditional jump, Opcode Extension
- * Groups, and some special opcodes can not be boost.
- */
-static const unsigned long
-twobyte_is_boostable[256 / sizeof(unsigned long)] = {
-	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
-	/*      -----------------------------------------------        */
-	R1(0x00, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0) /* 00 */
-	R2(0x10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 10 */
-	R3(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 20 */
-	R4(0x30, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 30 */
-	R1(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 40 */
-	R2(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 50 */
-	R3(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1) /* 60 */
-	R4(0x70, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) /* 70 */
-	R1(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 80 */
-	R2(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 90 */
-	R3(0xa0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* a0 */
-	R4(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) /* b0 */
-	R1(0xc0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* c0 */
-	R2(0xd0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* d0 */
-	R3(0xe0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* e0 */
-	RF(0xf0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0) /* f0 */
-	/*      -----------------------------------------------        */
-	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
-};
-
-static const unsigned long
-onebyte_has_modrm[256 / sizeof(unsigned long)] = {
-	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
-	/*      -----------------------------------------------        */
-	R1(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 00 */
-	R2(0x10, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 10 */
-	R3(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 20 */
-	R4(0x30, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 30 */
-	R1(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 40 */
-	R2(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 50 */
-	R3(0x60, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0) /* 60 */
-	R4(0x70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 70 */
-	R1(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 80 */
-	R2(0x90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 90 */
-	R3(0xa0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* a0 */
-	R4(0xb0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* b0 */
-	R1(0xc0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) /* c0 */
-	R2(0xd0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* d0 */
-	R3(0xe0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* e0 */
-	RF(0xf0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) /* f0 */
-	/*      -----------------------------------------------        */
-	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
-};
-
-static const unsigned long
-twobyte_has_modrm[256 / sizeof(unsigned long)] = {
-	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
-	/*      -----------------------------------------------        */
-	R1(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1) /* 0f */
-	R2(0x10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0) /* 1f */
-	R3(0x20, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* 2f */
-	R4(0x30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 3f */
-	R1(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 4f */
-	R2(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 5f */
-	R3(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 6f */
-	R4(0x70, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1) /* 7f */
-	R1(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 8f */
-	R2(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 9f */
-	R3(0xa0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) /* af */
-	R4(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1) /* bf */
-	R1(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) /* cf */
-	R2(0xd0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* df */
-	R3(0xe0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* ef */
-	RF(0xf0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0) /* ff */
-	/*      -----------------------------------------------        */
-	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
-};
-
-#undef W
-#undef R1
-#undef R2
-#undef R3
-#undef R4
-#undef RF
-
-/* insert a jmp code */
-static inline void set_jmp_op(void *from, void *to)
-{
-	struct __arch_jmp_op {
-		char op;
-		long raddr;
-	} __attribute__((packed)) *jop;
-	jop = (struct __arch_jmp_op *)from;
-	jop->raddr = (long)(to) - ((long)(from) + 5);
-	jop->op = RELATIVEJUMP_INSTRUCTION;
-}
-
-/*
- * returns non-zero if opcodes can be boosted.
- */
-static inline int can_boost(kprobe_opcode_t *opcodes)
-{
-	kprobe_opcode_t opcode;
-	kprobe_opcode_t *orig_opcodes = opcodes;
-retry:
-	if (opcodes - orig_opcodes > MAX_INSN_SIZE)
-		return 0;
-	opcode = *(opcodes++);
-
-	/* 2nd-byte opcode */
-	if (opcode == 0x0f) {
-		if (opcodes - orig_opcodes > MAX_INSN_SIZE)
-			return 0;
-		return test_bit(*opcodes, twobyte_is_boostable);
-	}
-
-	switch (opcode & 0xf0) {
-	case 0x60:
-		if (0x63 < opcode && opcode < 0x67)
-			goto retry; /* prefixes */
-		/* can't boost Address-size override and bound */
-		return (opcode != 0x62 && opcode != 0x67);
-	case 0x70:
-		return 0; /* can't boost conditional jump */
-	case 0xc0:
-		/* can't boost software-interruptions */
-		return (0xc1 < opcode && opcode < 0xcc) || opcode == 0xcf;
-	case 0xd0:
-		/* can boost AA* and XLAT */
-		return (opcode == 0xd4 || opcode == 0xd5 || opcode == 0xd7);
-	case 0xe0:
-		/* can boost in/out and absolute jmps */
-		return ((opcode & 0x04) || opcode == 0xea);
-	case 0xf0:
-		if ((opcode & 0x0c) == 0 && opcode != 0xf1)
-			goto retry; /* lock/rep(ne) prefix */
-		/* clear and set flags can be boost */
-		return (opcode == 0xf5 || (0xf7 < opcode && opcode < 0xfe));
-	default:
-		if (opcode == 0x26 || opcode == 0x36 || opcode == 0x3e)
-			goto retry; /* prefixes */
-		/* can't boost CS override and call */
-		return (opcode != 0x2e && opcode != 0x9a);
-	}
-}
-
-/*
- * returns non-zero if opcode modifies the interrupt flag.
- */
-static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
-{
-	switch (*insn) {
-	case 0xfa:		/* cli */
-	case 0xfb:		/* sti */
-	case 0xcf:		/* iret/iretd */
-	case 0x9d:		/* popf/popfd */
-		return 1;
-	}
-
-#ifdef CONFIG_X86_64
-	/* REX prefix */
-	if (*insn  >= 0x40 && *insn <= 0x4f && *++insn == 0xcf)
-		return 1;
-#endif
-	return 0;
-}
-
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
-{
-	/* insn: must be on special executable page on x86_32|64. */
-	p->ainsn.insn = get_insn_slot();
-	if (!p->ainsn.insn)
-		return -ENOMEM;
-
-	arch_copy_kprobe(p);
-	return 0;
-}
-
-/*
- * Determine if the instruction uses the %rip-relative addressing mode.
- * If it does, return the address of the 32-bit displacement word.
- * If not, return null.
- */
-static s32 __kprobes *is_riprel(u8 *insn)
-{
-	int need_modrm;
-
-	/* Skip legacy instruction prefixes.  */
-	while (1) {
-		switch (*insn) {
-		case 0x66:
-		case 0x67:
-		case 0x2e:
-		case 0x3e:
-		case 0x26:
-		case 0x64:
-		case 0x65:
-		case 0x36:
-		case 0xf0:
-		case 0xf3:
-		case 0xf2:
-			++insn;
-			continue;
-		}
-		break;
-	}
-
-	/* Skip REX instruction prefix.  */
-	if ((*insn & 0xf0) == 0x40)
-		++insn;
-
-	if (*insn == 0x0f) {	/* Two-byte opcode.  */
-		++insn;
-		need_modrm = test_bit(*insn, twobyte_has_modrm);
-	} else {		/* One-byte opcode.  */
-		need_modrm = test_bit(*insn, onebyte_has_modrm);
-	}
-
-	if (need_modrm) {
-		u8 modrm = *++insn;
-		if ((modrm & 0xc7) == 0x05) { /* %rip+disp32 addressing mode */
-			/* Displacement follows ModRM byte.  */
-			return (s32 *) ++insn;
-		}
-	}
-
-	/* No %rip-relative addressing mode here.  */
-	return NULL;
-}
-
-static void __kprobes arch_copy_kprobe(struct kprobe *p)
-{
-#ifdef CONFIG_X86_32
-	memcpy(p->ainsn.insn, p->addr, (MAX_INSN_SIZE + 1) * sizeof(kprobe_opcode_t));
-	p->opcode = *p->addr;
-	if (can_boost(p->addr)) {
-		p->ainsn.boostable = 0;
-	} else {
-		p->ainsn.boostable = -1;
-	}
-#else
-	s32 *ripdisp;
-	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE);
-	ripdisp = is_riprel(p->ainsn.insn);
-	if (ripdisp) {
-		/*
-		 * The copied instruction uses the %rip-relative
-		 * addressing mode.  Adjust the displacement for the
-		 * difference between the original location of this
-		 * instruction and the location of the copy that will
-		 * actually be run.  The tricky bit here is making sure
-		 * that the sign extension happens correctly in this
-		 * calculation, since we need a signed 32-bit result to
-		 * be sign-extended to 64 bits when it's added to the
-		 * %rip value and yield the same 64-bit result that the
-		 * sign-extension of the original signed 32-bit
-		 * displacement would have given.
-		 */
-		s64 disp = (u8 *) p->addr + *ripdisp - (u8 *) p->ainsn.insn;
-		BUG_ON((s64) (s32) disp != disp); /* Sanity check.  */
-		*ripdisp = disp;
-	}
-	p->opcode = *p->addr;
-#endif
-}
-
-void __kprobes arch_arm_kprobe(struct kprobe *p)
-{
-	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
-}
-
-void __kprobes arch_disarm_kprobe(struct kprobe *p)
-{
-	text_poke(p->addr, &p->opcode, 1);
-}
-
-void __kprobes arch_remove_kprobe(struct kprobe *p)
-{
-	mutex_lock(&kprobe_mutex);
-#ifdef CONFIG_X86_32
-	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
-#else
-	free_insn_slot(p->ainsn.insn, 0);
-#endif
-	mutex_unlock(&kprobe_mutex);
-}
-
-static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	kcb->prev_kprobe.kp = kprobe_running();
-	kcb->prev_kprobe.status = kcb->kprobe_status;
-	kcb->prev_kprobe.old_flags = kcb->kprobe_old_flags;
-	kcb->prev_kprobe.saved_flags = kcb->kprobe_saved_flags;
-}
-
-static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
-	kcb->kprobe_status = kcb->prev_kprobe.status;
-	kcb->kprobe_old_flags = kcb->prev_kprobe.old_flags;
-	kcb->kprobe_saved_flags = kcb->prev_kprobe.saved_flags;
-}
-
-static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
-				struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = p;
-	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
-		= (regs->flags & (TF_MASK | IF_MASK));
-	if (is_IF_modifier(p->ainsn.insn))
-		kcb->kprobe_saved_flags &= ~IF_MASK;
-}
-
-static __always_inline void clear_btf(void)
-{
-	if (test_thread_flag(TIF_DEBUGCTLMSR))
-#ifdef CONFIG_X86_32
-		wrmsr(MSR_IA32_DEBUGCTLMSR, 0, 0);
-#else
-		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
-#endif
-}
-
-static __always_inline void restore_btf(void)
-{
-	if (test_thread_flag(TIF_DEBUGCTLMSR))
-#ifdef CONFIG_X86_32
-		wrmsr(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr, 0);
-#else
-		wrmsrl(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr);
-#endif
-}
-
-static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
-{
-	clear_btf();
-	regs->flags |= TF_MASK;
-	regs->flags &= ~IF_MASK;
-	/*single step inline if the instruction is an int3*/
-	if (p->opcode == BREAKPOINT_INSTRUCTION)
-		regs->ip = (unsigned long)p->addr;
-	else
-		regs->ip = (unsigned long)p->ainsn.insn;
-}
-
-/* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
-				      struct pt_regs *regs)
-{
-	unsigned long *sara = &regs->sp;
-
-	ri->ret_addr = (kprobe_opcode_t *) *sara;
-	/* Replace the return addr with trampoline addr */
-	*sara = (unsigned long) &kretprobe_trampoline;
-}
-
-/*
- * Interrupts are disabled on entry as trap3 is an interrupt gate and they
- * remain disabled thorough out this function.
- */
-static int __kprobes kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *p;
-	int ret = 0;
-	kprobe_opcode_t *addr;
-	struct kprobe_ctlblk *kcb;
-
-	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
-
-	/*
-	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing
-	 */
-	preempt_disable();
-	kcb = get_kprobe_ctlblk();
-
-	/* Check we're not actually recursing */
-	if (kprobe_running()) {
-		p = get_kprobe(addr);
-		if (p) {
-			if (kcb->kprobe_status == KPROBE_HIT_SS &&
-				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
-				regs->flags &= ~TF_MASK;
-				regs->flags |= kcb->kprobe_saved_flags;
-				goto no_kprobe;
-#ifdef CONFIG_X86_32
-			}
-			/* We have reentered the kprobe_handler(), since
-			 * another probe was hit while within the handler.
-			 * We here save the original kprobes variables and
-			 * just single step on the instruction of the new probe
-			 * without calling any user handlers.
-			 */
-			save_previous_kprobe(kcb);
-			set_current_kprobe(p, regs, kcb);
-			kprobes_inc_nmissed_count(p);
-			prepare_singlestep(p, regs);
-			kcb->kprobe_status = KPROBE_REENTER;
-			return 1;
-#else
-			} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
-				/* TODO: Provide re-entrancy from
-				 * post_kprobes_handler() and avoid exception
-				 * stack corruption while single-stepping on
-				 * the instruction of the new probe.
-				 */
-				arch_disarm_kprobe(p);
-				regs->ip = (unsigned long)p->addr;
-				reset_current_kprobe();
-				ret = 1;
-			} else {
-				/* We have reentered the kprobe_handler(), since
-				 * another probe was hit while within the
-				 * handler. We here save the original kprobe
-				 * variables and just single step on instruction
-				 * of the new probe without calling any user
-				 * handlers.
-				 */
-				save_previous_kprobe(kcb);
-				set_current_kprobe(p, regs, kcb);
-				kprobes_inc_nmissed_count(p);
-				prepare_singlestep(p, regs);
-				kcb->kprobe_status = KPROBE_REENTER;
-				return 1;
-			}
-#endif
-		} else {
-			if (*addr != BREAKPOINT_INSTRUCTION) {
-			/* The breakpoint instruction was removed by
-			 * another cpu right after we hit, no further
-			 * handling of this interrupt is appropriate
-			 */
-#ifdef CONFIG_X86_32
-				regs->ip -= sizeof(kprobe_opcode_t);
-#else
-				regs->ip = (unsigned long)addr;
-#endif
-				ret = 1;
-				goto no_kprobe;
-			}
-			p = __get_cpu_var(current_kprobe);
-			if (p->break_handler && p->break_handler(p, regs)) {
-				goto ss_probe;
-			}
-		}
-		goto no_kprobe;
-	}
-
-	p = get_kprobe(addr);
-	if (!p) {
-		if (*addr != BREAKPOINT_INSTRUCTION) {
-			/*
-			 * The breakpoint instruction was removed right
-			 * after we hit it.  Another cpu has removed
-			 * either a probepoint or a debugger breakpoint
-			 * at this address.  In either case, no further
-			 * handling of this interrupt is appropriate.
-			 * Back up over the (now missing) int3 and run
-			 * the original instruction.
-			 */
-#ifdef CONFIG_X86_32
-			regs->ip -= sizeof(kprobe_opcode_t);
-#else
-			regs->ip = (unsigned long)addr;
-#endif
-			ret = 1;
-		}
-		/* Not one of ours: let kernel handle it */
-		goto no_kprobe;
-	}
-
-	set_current_kprobe(p, regs, kcb);
-	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-
-	if (p->pre_handler && p->pre_handler(p, regs))
-		/* handler has already set things up, so skip ss setup */
-		return 1;
-
-ss_probe:
-#if defined(CONFIG_X86_32) && (!defined(CONFIG_PREEMPT) || defined(CONFIG_PM))
-	if (p->ainsn.boostable == 1 && !p->post_handler){
-		/* Boost up -- we can execute copied instructions directly */
-		reset_current_kprobe();
-		regs->ip = (unsigned long)p->ainsn.insn;
-		preempt_enable_no_resched();
-		return 1;
-	}
-#endif
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_HIT_SS;
-	return 1;
-
-no_kprobe:
-	preempt_enable_no_resched();
-	return ret;
-}
-
-/*
- * For function-return probes, init_kprobes() establishes a probepoint
- * here. When a retprobed function returns, this probe is hit and
- * trampoline_probe_handler() runs, calling the kretprobe's handler.
- */
-void kretprobe_trampoline_holder(void)
-{
-#ifdef CONFIG_X86_32
-	asm volatile ( ".global kretprobe_trampoline\n"
-			"kretprobe_trampoline: \n"
-			"	pushf\n"
-			/* skip cs, ip, orig_ax */
-			"	subl $12, %esp\n"
-			"	pushl %fs\n"
-			"	pushl %ds\n"
-			"	pushl %es\n"
-			"	pushl %eax\n"
-			"	pushl %ebp\n"
-			"	pushl %edi\n"
-			"	pushl %esi\n"
-			"	pushl %edx\n"
-			"	pushl %ecx\n"
-			"	pushl %ebx\n"
-			"	movl %esp, %eax\n"
-			"	call trampoline_handler\n"
-			/* move flags to cs */
-			"	movl 52(%esp), %edx\n"
-			"	movl %edx, 48(%esp)\n"
-			/* save true return address on flags */
-			"	movl %eax, 52(%esp)\n"
-			"	popl %ebx\n"
-			"	popl %ecx\n"
-			"	popl %edx\n"
-			"	popl %esi\n"
-			"	popl %edi\n"
-			"	popl %ebp\n"
-			"	popl %eax\n"
-			/* skip ip, orig_ax, es, ds, fs */
-			"	addl $20, %esp\n"
-			"	popf\n"
-			"	ret\n");
-#else
-	asm volatile (  ".global kretprobe_trampoline\n"
-			"kretprobe_trampoline: \n"
-			"nop\n");
-#endif
-}
-
-/*
- * Called when we hit the probe point at kretprobe_trampoline
- */
-#ifdef CONFIG_X86_32
-void *__kprobes trampoline_handler(struct pt_regs *regs)
-#else
-int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
-#endif
-{
-	struct kretprobe_instance *ri = NULL;
-	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
-	unsigned long flags, orig_ret_address = 0;
-	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
-
-	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
-#ifdef CONFIG_X86_32
-	/* fixup registers */
-	regs->cs = __KERNEL_CS | get_kernel_rpl();
-	regs->ip = trampoline_address;
-	regs->orig_ax = 0xffffffff;
-#endif
-	/*
-	 * It is possible to have multiple instances associated with a given
-	 * task either because an multiple functions in the call path
-	 * have a return probe installed on them, and/or more then one return
-	 * return probe was registered for a target function.
-	 *
-	 * We can handle this because:
-	 *     - instances are always inserted at the head of the list
-	 *     - when multiple return probes are registered for the same
-	 *       function, the first instance's ret_addr will point to the
-	 *       real return address, and all the rest will point to
-	 *       kretprobe_trampoline
-	 */
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
-		if (ri->task != current)
-			/* another task is sharing our hash bucket */
-			continue;
-#ifdef CONFIG_X86_32
-		if (ri->rp && ri->rp->handler) {
-			__get_cpu_var(current_kprobe) = &ri->rp->kp;
-			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
-			ri->rp->handler(ri, regs);
-			__get_cpu_var(current_kprobe) = NULL;
-		}
-#else
-		if (ri->rp && ri->rp->handler)
-			ri->rp->handler(ri, regs);
-#endif
-		orig_ret_address = (unsigned long)ri->ret_addr;
-		recycle_rp_inst(ri, &empty_rp);
-
-		if (orig_ret_address != trampoline_address)
-			/*
-			 * This is the real return address. Any other
-			 * instances associated with this task are for
-			 * other calls deeper on the call stack
-			 */
-			break;
-	}
-
-	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-#ifdef CONFIG_X86_64
-	regs->ip = orig_ret_address;
-	reset_current_kprobe();
-#endif
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-#ifdef CONFIG_X86_64
-	preempt_enable_no_resched();
-#endif
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
-		hlist_del(&ri->hlist);
-		kfree(ri);
-	}
-
-#ifdef CONFIG_X86_32
-	return (void*)orig_ret_address;
-#else
-	/*
-	 * By returning a non-zero value, we are telling
-	 * kprobe_handler() that we don't want the post_handler
-	 * to run (and have re-enabled preemption)
-	 */
-	return 1;
-#endif
-}
-
-/*
- * Called after single-stepping.  p->addr is the address of the
- * instruction whose first byte has been replaced by the "int 3"
- * instruction.  To avoid the SMP problems that can occur when we
- * temporarily put back the original opcode to single-step, we
- * single-stepped a copy of the instruction.  The address of this
- * copy is p->ainsn.insn.
- *
- * This function prepares to return from the post-single-step
- * interrupt.  We have to fix up the stack as follows:
- *
- * 0) Except in the case of absolute or indirect jump or call instructions,
- * the new ip is relative to the copied instruction.  We need to make
- * it relative to the original instruction.
- *
- * 1) If the single-stepped instruction was pushfl, then the TF and IF
- * flags are set in the just-pushed flags, and may need to be cleared.
- *
- * 2) If the single-stepped instruction was a call, the return address
- * that is atop the stack is the address following the copied instruction.
- * We need to make it the address following the original instruction.
- *
- * This function also checks instruction size for preparing direct execution.
- */
-static void __kprobes resume_execution(struct kprobe *p,
-		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
-{
-	unsigned long *tos = &regs->sp;
-	unsigned long next_rip = 0;
-	unsigned long copy_ip = (unsigned long)p->ainsn.insn;
-	unsigned long orig_ip = (unsigned long)p->addr;
-	kprobe_opcode_t *insn = p->ainsn.insn;
-
-#ifdef CONFIG_X86_64
-	/*skip the REX prefix*/
-	if (*insn >= 0x40 && *insn <= 0x4f)
-		insn++;
-#endif
-
-	regs->flags &= ~TF_MASK;
-	switch (*insn) {
-	case 0x9c:		/* pushfl */
-		*tos &= ~(TF_MASK | IF_MASK);
-		*tos |= kcb->kprobe_old_flags;
-		break;
-	case 0xc2:		/* ret/lret */
-	case 0xc3:
-	case 0xca:
-	case 0xcb:
-#ifdef CONFIG_X86_32
-	case 0xcf:		/* iret */
-		/* ip is already adjusted, no more changes required */
-		p->ainsn.boostable = 1;
-		goto no_change;
-#else
-		/* ip is already adjusted, no more changes required*/
-		return;
-#endif
-	case 0xe8:		/* call relative - Fix return addr */
-		*tos = orig_ip + (*tos - copy_ip);
-		break;
-#ifdef CONFIG_X86_32
-	case 0x9a:		/* call absolute -- same as call absolute, indirect */
-		*tos = orig_ip + (*tos - copy_ip);
-		goto no_change;
-#endif
-	case 0xff:
-#ifdef CONFIG_X86_32
-		if ((insn[1] & 0x30) == 0x10) {
-			/*
-			 * call absolute, indirect
-			 * Fix return addr; ip is correct.
-			 * But this is not boostable
-			 */
-			*tos = orig_ip + (*tos - copy_ip);
-			goto no_change;
-		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
-			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
-			/* ip is correct. And this is boostable */
-			p->ainsn.boostable = 1;
-			goto no_change;
-		}
-#else
-		if ((insn[1] & 0x30) == 0x10) {
-			/* call absolute, indirect */
-			/* Fix return addr; ip is correct. */
-			next_rip = regs->ip;
-			*tos = orig_ip + (*tos - copy_ip);
-		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
-			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
-			/* ip is correct. */
-			next_rip = regs->ip;
-		}
-#endif
-		break;
-	case 0xea:		/* jmp absolute -- ip is correct */
-#ifdef CONFIG_X86_32
-		/* ip is already adjusted, no more changes required */
-		p->ainsn.boostable = 1;
-		goto no_change;
-#else
-		next_rip = regs->ip;
-		break;
-#endif
-	default:
-		break;
-	}
-
-#ifdef CONFIG_X86_32
-	if (p->ainsn.boostable == 0) {
-		if ((regs->ip > copy_ip) &&
-		    (regs->ip - copy_ip) + 5 < (MAX_INSN_SIZE + 1)) {
-			/*
-			 * These instructions can be executed directly if it
-			 * jumps back to correct address.
-			 */
-			set_jmp_op((void *)regs->ip,
-				   (void *)orig_ip + (regs->ip - copy_ip));
-			p->ainsn.boostable = 1;
-		} else {
-			p->ainsn.boostable = -1;
-		}
-	}
-
-	regs->ip = orig_ip + (regs->ip - copy_ip);
-
-no_change:
-#else
-	if (next_rip) {
-		regs->ip = next_rip;
-	} else {
-		regs->ip = orig_ip + (regs->ip - copy_ip);
-	}
-#endif
-	restore_btf();
-}
-
-/*
- * Interrupts are disabled on entry as trap1 is an interrupt gate and they
- * remain disabled thoroughout this function.
- */
-static int __kprobes post_kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	if (!cur)
-		return 0;
-
-	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
-		kcb->kprobe_status = KPROBE_HIT_SSDONE;
-		cur->post_handler(cur, regs, 0);
-	}
-
-	resume_execution(cur, regs, kcb);
-	regs->flags |= kcb->kprobe_saved_flags;
-	trace_hardirqs_fixup_flags(regs->flags);
-
-	/* Restore the original saved kprobes variables and continue. */
-	if (kcb->kprobe_status == KPROBE_REENTER) {
-		restore_previous_kprobe(kcb);
-		goto out;
-	}
-	reset_current_kprobe();
-out:
-	preempt_enable_no_resched();
-
-	/*
-	 * if somebody else is singlestepping across a probe point, flags
-	 * will have TF set, in which case, continue the remaining processing
-	 * of do_debug, as if this is not a probe hit.
-	 */
-	if (regs->flags & TF_MASK)
-		return 0;
-
-	return 1;
-}
-
-int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-#ifdef CONFIG_X86_64
-	const struct exception_table_entry *fixup;
-#endif
-
-	switch(kcb->kprobe_status) {
-	case KPROBE_HIT_SS:
-	case KPROBE_REENTER:
-		/*
-		 * We are here because the instruction being single
-		 * stepped caused a page fault. We reset the current
-		 * kprobe and the ip points back to the probe address
-		 * and allow the page fault handler to continue as a
-		 * normal page fault.
-		 */
-		regs->ip = (unsigned long)cur->addr;
-		regs->flags |= kcb->kprobe_old_flags;
-		if (kcb->kprobe_status == KPROBE_REENTER)
-			restore_previous_kprobe(kcb);
-		else
-			reset_current_kprobe();
-		preempt_enable_no_resched();
-		break;
-	case KPROBE_HIT_ACTIVE:
-	case KPROBE_HIT_SSDONE:
-		/*
-		 * We increment the nmissed count for accounting,
-		 * we can also use npre/npostfault count for accouting
-		 * these specific fault cases.
-		 */
-		kprobes_inc_nmissed_count(cur);
-
-		/*
-		 * We come here because instructions in the pre/post
-		 * handler caused the page_fault, this could happen
-		 * if handler tries to access user space by
-		 * copy_from_user(), get_user() etc. Let the
-		 * user-specified handler try to fix it first.
-		 */
-		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
-			return 1;
-
-		/*
-		 * In case the user-specified fault handler returned
-		 * zero, try to fix up.
-		 */
-#ifdef CONFIG_X86_32
-		if (fixup_exception(regs))
-			return 1;
-#else
-		fixup = search_exception_tables(regs->ip);
-		if (fixup) {
-			regs->ip = fixup->fixup;
-			return 1;
-		}
-#endif
-		/*
-		 * Exception couldn't be fixed up,
-		 * Let do_page_fault() fix it.
-		 */
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
-/*
- * Wrapper routine for handling exceptions.
- */
-int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
-				       unsigned long val, void *data)
-{
-	struct die_args *args = (struct die_args *)data;
-	int ret = NOTIFY_DONE;
-
-#ifdef CONFIG_X86_32
-	if (args->regs && user_mode_vm(args->regs))
-		return ret;
-#else
-	if (args->regs && user_mode(args->regs))
-		return ret;
-#endif
-
-	switch (val) {
-	case DIE_INT3:
-		if (kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_DEBUG:
-		if (post_kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_GPF:
-		/* kprobe_running() needs smp_processor_id() */
-		preempt_disable();
-		if (kprobe_running() &&
-		    kprobe_fault_handler(args->regs, args->trapnr))
-			ret = NOTIFY_STOP;
-		preempt_enable();
-		break;
-	default:
-		break;
-	}
-	return ret;
-}
-
-int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct jprobe *jp = container_of(p, struct jprobe, kp);
-	unsigned long addr;
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	kcb->jprobe_saved_regs = *regs;
-	kcb->jprobe_saved_sp = &regs->sp;
-	addr = (unsigned long)(kcb->jprobe_saved_sp);
-
-	/*
-	 * As Linus pointed out, gcc assumes that the callee
-	 * owns the argument space and could overwrite it, e.g.
-	 * tailcall optimization. So, to be absolutely safe
-	 * we also save and restore enough stack bytes to cover
-	 * the argument area.
-	 */
-	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *)addr,
-			MIN_STACK_SIZE(addr));
-	regs->flags &= ~IF_MASK;
-	trace_hardirqs_off();
-	regs->ip = (unsigned long)(jp->entry);
-	return 1;
-}
-
-void __kprobes jprobe_return(void)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-#ifdef CONFIG_X86_32
-	asm volatile ("       xchgl   %%ebx,%%esp     \n"
-		      "       int3			\n"
-		      "       .globl jprobe_return_end	\n"
-		      "       jprobe_return_end:	\n"
-		      "       nop			\n"::"b"
-		      (kcb->jprobe_saved_sp):"memory");
-#else
-	asm volatile ("       xchg   %%rbx,%%rsp     \n"
-		      "       int3			\n"
-		      "       .globl jprobe_return_end	\n"
-		      "       jprobe_return_end:	\n"
-		      "       nop			\n"::"b"
-		      (kcb->jprobe_saved_sp):"memory");
-#endif
-}
-
-int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	u8 *addr = (u8 *) (regs->ip - 1);
-	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_sp);
-	struct jprobe *jp = container_of(p, struct jprobe, kp);
-
-	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
-		if (&regs->sp != kcb->jprobe_saved_sp) {
-			struct pt_regs *saved_regs =
-			    container_of(kcb->jprobe_saved_sp,
-					    struct pt_regs, sp);
-			printk("current sp %p does not match saved sp %p\n",
-			       &regs->sp, kcb->jprobe_saved_sp);
-			printk("Saved registers for jprobe %p\n", jp);
-			show_registers(saved_regs);
-			printk("Current registers\n");
-			show_registers(regs);
-			BUG();
-		}
-		*regs = kcb->jprobe_saved_regs;
-		memcpy((kprobe_opcode_t *) stack_addr, kcb->jprobes_stack,
-		       MIN_STACK_SIZE(stack_addr));
-		preempt_enable_no_resched();
-		return 1;
-	}
-	return 0;
-}
-
-#ifdef CONFIG_X86_64
-static struct kprobe trampoline_p = {
-	.addr = (kprobe_opcode_t *) &kretprobe_trampoline,
-	.pre_handler = trampoline_probe_handler
-};
-#endif
-
-int __kprobes arch_trampoline_kprobe(struct kprobe *p)
-{
-#ifdef CONFIG_X86_64
-	if (p->addr == (kprobe_opcode_t *)&kretprobe_trampoline)
-		return 1;
-#endif
-	return 0;
-}
-
-int __init arch_init_kprobes(void)
-{
-#ifdef CONFIG_X86_32
-	return 0;
-#else
-	return register_kprobe(&trampoline_p);
-#endif
-}
diff --git a/arch/x86/kernel/kprobes_64.c b/arch/x86/kernel/kprobes_64.c
deleted file mode 100644
index f195348..0000000
--- a/arch/x86/kernel/kprobes_64.c
+++ /dev/null
@@ -1,1090 +0,0 @@
-/*
- *  Kernel Probes (KProbes)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright (C) IBM Corporation, 2002, 2004
- */
-
-#include <linux/kprobes.h>
-#include <linux/ptrace.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/preempt.h>
-#include <linux/module.h>
-#include <linux/kdebug.h>
-
-#include <asm/cacheflush.h>
-#include <asm/desc.h>
-#include <asm/pgtable.h>
-#include <asm/uaccess.h>
-#include <asm/alternative.h>
-
-void jprobe_return_end(void);
-static void __kprobes arch_copy_kprobe(struct kprobe *p);
-
-DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
-DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
-
-struct kretprobe_blackpoint kretprobe_blacklist[] = {
-	{"__switch_to", }, /* This function switches only current task, but
-			      doesn't switch kernel stack.*/
-	{NULL, NULL}	/* Terminator */
-};
-const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
-
-#define W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)  \
-	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
-	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
-	  (b8##UL << 0x8)|(b9##UL << 0x9)|(ba##UL << 0xa)|(bb##UL << 0xb) |   \
-	  (bc##UL << 0xc)|(bd##UL << 0xd)|(be##UL << 0xe)|(bf##UL << 0xf))    \
-	 << (r % sizeof(unsigned long)))
-
-#define R1(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
-	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
-#define R3(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
-	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
-#define R4(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
-	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf),
-#define RF(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
-	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)
-
-#ifdef CONFIG_X86_32
-#define R2(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
-	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf),
-#else
-#define R2(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) \
-	 W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf) |
-#endif
-
-/*
- * Undefined/reserved opcodes, conditional jump, Opcode Extension
- * Groups, and some special opcodes can not be boost.
- */
-static const unsigned long
-twobyte_is_boostable[256 / sizeof(unsigned long)] = {
-	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
-	/*      -----------------------------------------------        */
-	R1(0x00, 0, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0) /* 00 */
-	R2(0x10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 10 */
-	R3(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 20 */
-	R4(0x30, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 30 */
-	R1(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 40 */
-	R2(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 50 */
-	R3(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1) /* 60 */
-	R4(0x70, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) /* 70 */
-	R1(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 80 */
-	R2(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 90 */
-	R3(0xa0, 1, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* a0 */
-	R4(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) /* b0 */
-	R1(0xc0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* c0 */
-	R2(0xd0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* d0 */
-	R3(0xe0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1) /* e0 */
-	RF(0xf0, 0, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0) /* f0 */
-	/*      -----------------------------------------------        */
-	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
-};
-
-static const unsigned long
-onebyte_has_modrm[256 / sizeof(unsigned long)] = {
-	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
-	/*      -----------------------------------------------        */
-	R1(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 00 */
-	R2(0x10, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 10 */
-	R3(0x20, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 20 */
-	R4(0x30, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0) /* 30 */
-	R1(0x40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 40 */
-	R2(0x50, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 50 */
-	R3(0x60, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0) /* 60 */
-	R4(0x70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 70 */
-	R1(0x80, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 80 */
-	R2(0x90, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 90 */
-	R3(0xa0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* a0 */
-	R4(0xb0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* b0 */
-	R1(0xc0, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) /* c0 */
-	R2(0xd0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* d0 */
-	R3(0xe0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* e0 */
-	RF(0xf0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1) /* f0 */
-	/*      -----------------------------------------------        */
-	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
-};
-
-static const unsigned long
-twobyte_has_modrm[256 / sizeof(unsigned long)] = {
-	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
-	/*      -----------------------------------------------        */
-	R1(0x00, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1) /* 0f */
-	R2(0x10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0) /* 1f */
-	R3(0x20, 1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1) /* 2f */
-	R4(0x30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 3f */
-	R1(0x40, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 4f */
-	R2(0x50, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 5f */
-	R3(0x60, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 6f */
-	R4(0x70, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1) /* 7f */
-	R1(0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) /* 8f */
-	R2(0x90, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* 9f */
-	R3(0xa0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1) /* af */
-	R4(0xb0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1) /* bf */
-	R1(0xc0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0) /* cf */
-	R2(0xd0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* df */
-	R3(0xe0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1) /* ef */
-	RF(0xf0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0) /* ff */
-	/*      -----------------------------------------------        */
-	/*       0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f        */
-};
-
-#undef W
-#undef R1
-#undef R2
-#undef R3
-#undef R4
-#undef RF
-
-/* insert a jmp code */
-static inline void set_jmp_op(void *from, void *to)
-{
-	struct __arch_jmp_op {
-		char op;
-		long raddr;
-	} __attribute__((packed)) *jop;
-	jop = (struct __arch_jmp_op *)from;
-	jop->raddr = (long)(to) - ((long)(from) + 5);
-	jop->op = RELATIVEJUMP_INSTRUCTION;
-}
-
-/*
- * returns non-zero if opcodes can be boosted.
- */
-static inline int can_boost(kprobe_opcode_t *opcodes)
-{
-	kprobe_opcode_t opcode;
-	kprobe_opcode_t *orig_opcodes = opcodes;
-retry:
-	if (opcodes - orig_opcodes > MAX_INSN_SIZE)
-		return 0;
-	opcode = *(opcodes++);
-
-	/* 2nd-byte opcode */
-	if (opcode == 0x0f) {
-		if (opcodes - orig_opcodes > MAX_INSN_SIZE)
-			return 0;
-		return test_bit(*opcodes, twobyte_is_boostable);
-	}
-
-	switch (opcode & 0xf0) {
-	case 0x60:
-		if (0x63 < opcode && opcode < 0x67)
-			goto retry; /* prefixes */
-		/* can't boost Address-size override and bound */
-		return (opcode != 0x62 && opcode != 0x67);
-	case 0x70:
-		return 0; /* can't boost conditional jump */
-	case 0xc0:
-		/* can't boost software-interruptions */
-		return (0xc1 < opcode && opcode < 0xcc) || opcode == 0xcf;
-	case 0xd0:
-		/* can boost AA* and XLAT */
-		return (opcode == 0xd4 || opcode == 0xd5 || opcode == 0xd7);
-	case 0xe0:
-		/* can boost in/out and absolute jmps */
-		return ((opcode & 0x04) || opcode == 0xea);
-	case 0xf0:
-		if ((opcode & 0x0c) == 0 && opcode != 0xf1)
-			goto retry; /* lock/rep(ne) prefix */
-		/* clear and set flags can be boost */
-		return (opcode == 0xf5 || (0xf7 < opcode && opcode < 0xfe));
-	default:
-		if (opcode == 0x26 || opcode == 0x36 || opcode == 0x3e)
-			goto retry; /* prefixes */
-		/* can't boost CS override and call */
-		return (opcode != 0x2e && opcode != 0x9a);
-	}
-}
-
-/*
- * returns non-zero if opcode modifies the interrupt flag.
- */
-static int __kprobes is_IF_modifier(kprobe_opcode_t *insn)
-{
-	switch (*insn) {
-	case 0xfa:		/* cli */
-	case 0xfb:		/* sti */
-	case 0xcf:		/* iret/iretd */
-	case 0x9d:		/* popf/popfd */
-		return 1;
-	}
-
-#ifdef CONFIG_X86_64
-	/* REX prefix */
-	if (*insn  >= 0x40 && *insn <= 0x4f && *++insn == 0xcf)
-		return 1;
-#endif
-	return 0;
-}
-
-int __kprobes arch_prepare_kprobe(struct kprobe *p)
-{
-	/* insn: must be on special executable page on x86_32|64. */
-	p->ainsn.insn = get_insn_slot();
-	if (!p->ainsn.insn)
-		return -ENOMEM;
-
-	arch_copy_kprobe(p);
-	return 0;
-}
-
-/*
- * Determine if the instruction uses the %rip-relative addressing mode.
- * If it does, return the address of the 32-bit displacement word.
- * If not, return null.
- */
-static s32 __kprobes *is_riprel(u8 *insn)
-{
-	int need_modrm;
-
-	/* Skip legacy instruction prefixes.  */
-	while (1) {
-		switch (*insn) {
-		case 0x66:
-		case 0x67:
-		case 0x2e:
-		case 0x3e:
-		case 0x26:
-		case 0x64:
-		case 0x65:
-		case 0x36:
-		case 0xf0:
-		case 0xf3:
-		case 0xf2:
-			++insn;
-			continue;
-		}
-		break;
-	}
-
-	/* Skip REX instruction prefix.  */
-	if ((*insn & 0xf0) == 0x40)
-		++insn;
-
-	if (*insn == 0x0f) {	/* Two-byte opcode.  */
-		++insn;
-		need_modrm = test_bit(*insn, twobyte_has_modrm);
-	} else {		/* One-byte opcode.  */
-		need_modrm = test_bit(*insn, onebyte_has_modrm);
-	}
-
-	if (need_modrm) {
-		u8 modrm = *++insn;
-		if ((modrm & 0xc7) == 0x05) { /* %rip+disp32 addressing mode */
-			/* Displacement follows ModRM byte.  */
-			return (s32 *) ++insn;
-		}
-	}
-
-	/* No %rip-relative addressing mode here.  */
-	return NULL;
-}
-
-static void __kprobes arch_copy_kprobe(struct kprobe *p)
-{
-#ifdef CONFIG_X86_32
-	memcpy(p->ainsn.insn, p->addr, (MAX_INSN_SIZE + 1) * sizeof(kprobe_opcode_t));
-	p->opcode = *p->addr;
-	if (can_boost(p->addr)) {
-		p->ainsn.boostable = 0;
-	} else {
-		p->ainsn.boostable = -1;
-	}
-#else
-	s32 *ripdisp;
-	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE);
-	ripdisp = is_riprel(p->ainsn.insn);
-	if (ripdisp) {
-		/*
-		 * The copied instruction uses the %rip-relative
-		 * addressing mode.  Adjust the displacement for the
-		 * difference between the original location of this
-		 * instruction and the location of the copy that will
-		 * actually be run.  The tricky bit here is making sure
-		 * that the sign extension happens correctly in this
-		 * calculation, since we need a signed 32-bit result to
-		 * be sign-extended to 64 bits when it's added to the
-		 * %rip value and yield the same 64-bit result that the
-		 * sign-extension of the original signed 32-bit
-		 * displacement would have given.
-		 */
-		s64 disp = (u8 *) p->addr + *ripdisp - (u8 *) p->ainsn.insn;
-		BUG_ON((s64) (s32) disp != disp); /* Sanity check.  */
-		*ripdisp = disp;
-	}
-	p->opcode = *p->addr;
-#endif
-}
-
-void __kprobes arch_arm_kprobe(struct kprobe *p)
-{
-	text_poke(p->addr, ((unsigned char []){BREAKPOINT_INSTRUCTION}), 1);
-}
-
-void __kprobes arch_disarm_kprobe(struct kprobe *p)
-{
-	text_poke(p->addr, &p->opcode, 1);
-}
-
-void __kprobes arch_remove_kprobe(struct kprobe *p)
-{
-	mutex_lock(&kprobe_mutex);
-#ifdef CONFIG_X86_32
-	free_insn_slot(p->ainsn.insn, (p->ainsn.boostable == 1));
-#else
-	free_insn_slot(p->ainsn.insn, 0);
-#endif
-	mutex_unlock(&kprobe_mutex);
-}
-
-static void __kprobes save_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	kcb->prev_kprobe.kp = kprobe_running();
-	kcb->prev_kprobe.status = kcb->kprobe_status;
-	kcb->prev_kprobe.old_flags = kcb->kprobe_old_flags;
-	kcb->prev_kprobe.saved_flags = kcb->kprobe_saved_flags;
-}
-
-static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe.kp;
-	kcb->kprobe_status = kcb->prev_kprobe.status;
-	kcb->kprobe_old_flags = kcb->prev_kprobe.old_flags;
-	kcb->kprobe_saved_flags = kcb->prev_kprobe.saved_flags;
-}
-
-static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
-				struct kprobe_ctlblk *kcb)
-{
-	__get_cpu_var(current_kprobe) = p;
-	kcb->kprobe_saved_flags = kcb->kprobe_old_flags
-		= (regs->flags & (TF_MASK | IF_MASK));
-	if (is_IF_modifier(p->ainsn.insn))
-		kcb->kprobe_saved_flags &= ~IF_MASK;
-}
-
-static __always_inline void clear_btf(void)
-{
-	if (test_thread_flag(TIF_DEBUGCTLMSR))
-#ifdef CONFIG_X86_32
-		wrmsr(MSR_IA32_DEBUGCTLMSR, 0, 0);
-#else
-		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
-#endif
-}
-
-static __always_inline void restore_btf(void)
-{
-	if (test_thread_flag(TIF_DEBUGCTLMSR))
-#ifdef CONFIG_X86_32
-		wrmsr(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr, 0);
-#else
-		wrmsrl(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr);
-#endif
-}
-
-static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
-{
-	clear_btf();
-	regs->flags |= TF_MASK;
-	regs->flags &= ~IF_MASK;
-	/*single step inline if the instruction is an int3*/
-	if (p->opcode == BREAKPOINT_INSTRUCTION)
-		regs->ip = (unsigned long)p->addr;
-	else
-		regs->ip = (unsigned long)p->ainsn.insn;
-}
-
-/* Called with kretprobe_lock held */
-void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
-				      struct pt_regs *regs)
-{
-	unsigned long *sara = &regs->sp;
-
-	ri->ret_addr = (kprobe_opcode_t *) *sara;
-	/* Replace the return addr with trampoline addr */
-	*sara = (unsigned long) &kretprobe_trampoline;
-}
-
-/*
- * Interrupts are disabled on entry as trap3 is an interrupt gate and they
- * remain disabled thorough out this function.
- */
-static int __kprobes kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *p;
-	int ret = 0;
-	kprobe_opcode_t *addr;
-	struct kprobe_ctlblk *kcb;
-
-	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
-
-	/*
-	 * We don't want to be preempted for the entire
-	 * duration of kprobe processing
-	 */
-	preempt_disable();
-	kcb = get_kprobe_ctlblk();
-
-	/* Check we're not actually recursing */
-	if (kprobe_running()) {
-		p = get_kprobe(addr);
-		if (p) {
-			if (kcb->kprobe_status == KPROBE_HIT_SS &&
-				*p->ainsn.insn == BREAKPOINT_INSTRUCTION) {
-				regs->flags &= ~TF_MASK;
-				regs->flags |= kcb->kprobe_saved_flags;
-				goto no_kprobe;
-#ifdef CONFIG_X86_32
-			}
-			/* We have reentered the kprobe_handler(), since
-			 * another probe was hit while within the handler.
-			 * We here save the original kprobes variables and
-			 * just single step on the instruction of the new probe
-			 * without calling any user handlers.
-			 */
-			save_previous_kprobe(kcb);
-			set_current_kprobe(p, regs, kcb);
-			kprobes_inc_nmissed_count(p);
-			prepare_singlestep(p, regs);
-			kcb->kprobe_status = KPROBE_REENTER;
-			return 1;
-#else
-			} else if (kcb->kprobe_status == KPROBE_HIT_SSDONE) {
-				/* TODO: Provide re-entrancy from
-				 * post_kprobes_handler() and avoid exception
-				 * stack corruption while single-stepping on
-				 * the instruction of the new probe.
-				 */
-				arch_disarm_kprobe(p);
-				regs->ip = (unsigned long)p->addr;
-				reset_current_kprobe();
-				ret = 1;
-			} else {
-				/* We have reentered the kprobe_handler(), since
-				 * another probe was hit while within the
-				 * handler. We here save the original kprobe
-				 * variables and just single step on instruction
-				 * of the new probe without calling any user
-				 * handlers.
-				 */
-				save_previous_kprobe(kcb);
-				set_current_kprobe(p, regs, kcb);
-				kprobes_inc_nmissed_count(p);
-				prepare_singlestep(p, regs);
-				kcb->kprobe_status = KPROBE_REENTER;
-				return 1;
-			}
-#endif
-		} else {
-			if (*addr != BREAKPOINT_INSTRUCTION) {
-			/* The breakpoint instruction was removed by
-			 * another cpu right after we hit, no further
-			 * handling of this interrupt is appropriate
-			 */
-#ifdef CONFIG_X86_32
-				regs->ip -= sizeof(kprobe_opcode_t);
-#else
-				regs->ip = (unsigned long)addr;
-#endif
-				ret = 1;
-				goto no_kprobe;
-			}
-			p = __get_cpu_var(current_kprobe);
-			if (p->break_handler && p->break_handler(p, regs)) {
-				goto ss_probe;
-			}
-		}
-		goto no_kprobe;
-	}
-
-	p = get_kprobe(addr);
-	if (!p) {
-		if (*addr != BREAKPOINT_INSTRUCTION) {
-			/*
-			 * The breakpoint instruction was removed right
-			 * after we hit it.  Another cpu has removed
-			 * either a probepoint or a debugger breakpoint
-			 * at this address.  In either case, no further
-			 * handling of this interrupt is appropriate.
-			 * Back up over the (now missing) int3 and run
-			 * the original instruction.
-			 */
-#ifdef CONFIG_X86_32
-			regs->ip -= sizeof(kprobe_opcode_t);
-#else
-			regs->ip = (unsigned long)addr;
-#endif
-			ret = 1;
-		}
-		/* Not one of ours: let kernel handle it */
-		goto no_kprobe;
-	}
-
-	set_current_kprobe(p, regs, kcb);
-	kcb->kprobe_status = KPROBE_HIT_ACTIVE;
-
-	if (p->pre_handler && p->pre_handler(p, regs))
-		/* handler has already set things up, so skip ss setup */
-		return 1;
-
-ss_probe:
-#if defined(CONFIG_X86_32) && (!defined(CONFIG_PREEMPT) || defined(CONFIG_PM))
-	if (p->ainsn.boostable == 1 && !p->post_handler){
-		/* Boost up -- we can execute copied instructions directly */
-		reset_current_kprobe();
-		regs->ip = (unsigned long)p->ainsn.insn;
-		preempt_enable_no_resched();
-		return 1;
-	}
-#endif
-	prepare_singlestep(p, regs);
-	kcb->kprobe_status = KPROBE_HIT_SS;
-	return 1;
-
-no_kprobe:
-	preempt_enable_no_resched();
-	return ret;
-}
-
-/*
- * For function-return probes, init_kprobes() establishes a probepoint
- * here. When a retprobed function returns, this probe is hit and
- * trampoline_probe_handler() runs, calling the kretprobe's handler.
- */
-void kretprobe_trampoline_holder(void)
-{
-#ifdef CONFIG_X86_32
-	asm volatile ( ".global kretprobe_trampoline\n"
-			"kretprobe_trampoline: \n"
-			"	pushf\n"
-			/* skip cs, ip, orig_ax */
-			"	subl $12, %esp\n"
-			"	pushl %fs\n"
-			"	pushl %ds\n"
-			"	pushl %es\n"
-			"	pushl %eax\n"
-			"	pushl %ebp\n"
-			"	pushl %edi\n"
-			"	pushl %esi\n"
-			"	pushl %edx\n"
-			"	pushl %ecx\n"
-			"	pushl %ebx\n"
-			"	movl %esp, %eax\n"
-			"	call trampoline_handler\n"
-			/* move flags to cs */
-			"	movl 52(%esp), %edx\n"
-			"	movl %edx, 48(%esp)\n"
-			/* save true return address on flags */
-			"	movl %eax, 52(%esp)\n"
-			"	popl %ebx\n"
-			"	popl %ecx\n"
-			"	popl %edx\n"
-			"	popl %esi\n"
-			"	popl %edi\n"
-			"	popl %ebp\n"
-			"	popl %eax\n"
-			/* skip ip, orig_ax, es, ds, fs */
-			"	addl $20, %esp\n"
-			"	popf\n"
-			"	ret\n");
-#else
-	asm volatile (  ".global kretprobe_trampoline\n"
-			"kretprobe_trampoline: \n"
-			"nop\n");
-#endif
-}
-
-/*
- * Called when we hit the probe point at kretprobe_trampoline
- */
-#ifdef CONFIG_X86_32
-void *__kprobes trampoline_handler(struct pt_regs *regs)
-#else
-int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
-#endif
-{
-	struct kretprobe_instance *ri = NULL;
-	struct hlist_head *head, empty_rp;
-	struct hlist_node *node, *tmp;
-	unsigned long flags, orig_ret_address = 0;
-	unsigned long trampoline_address =(unsigned long)&kretprobe_trampoline;
-
-	INIT_HLIST_HEAD(&empty_rp);
-	spin_lock_irqsave(&kretprobe_lock, flags);
-	head = kretprobe_inst_table_head(current);
-#ifdef CONFIG_X86_32
-	/* fixup registers */
-	regs->cs = __KERNEL_CS | get_kernel_rpl();
-	regs->ip = trampoline_address;
-	regs->orig_ax = 0xffffffff;
-#endif
-	/*
-	 * It is possible to have multiple instances associated with a given
-	 * task either because an multiple functions in the call path
-	 * have a return probe installed on them, and/or more then one return
-	 * return probe was registered for a target function.
-	 *
-	 * We can handle this because:
-	 *     - instances are always inserted at the head of the list
-	 *     - when multiple return probes are registered for the same
-	 *       function, the first instance's ret_addr will point to the
-	 *       real return address, and all the rest will point to
-	 *       kretprobe_trampoline
-	 */
-	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
-		if (ri->task != current)
-			/* another task is sharing our hash bucket */
-			continue;
-#ifdef CONFIG_X86_32
-		if (ri->rp && ri->rp->handler) {
-			__get_cpu_var(current_kprobe) = &ri->rp->kp;
-			get_kprobe_ctlblk()->kprobe_status = KPROBE_HIT_ACTIVE;
-			ri->rp->handler(ri, regs);
-			__get_cpu_var(current_kprobe) = NULL;
-		}
-#else
-		if (ri->rp && ri->rp->handler)
-			ri->rp->handler(ri, regs);
-#endif
-		orig_ret_address = (unsigned long)ri->ret_addr;
-		recycle_rp_inst(ri, &empty_rp);
-
-		if (orig_ret_address != trampoline_address)
-			/*
-			 * This is the real return address. Any other
-			 * instances associated with this task are for
-			 * other calls deeper on the call stack
-			 */
-			break;
-	}
-
-	kretprobe_assert(ri, orig_ret_address, trampoline_address);
-#ifdef CONFIG_X86_64
-	regs->ip = orig_ret_address;
-	reset_current_kprobe();
-#endif
-	spin_unlock_irqrestore(&kretprobe_lock, flags);
-#ifdef CONFIG_X86_64
-	preempt_enable_no_resched();
-#endif
-	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
-		hlist_del(&ri->hlist);
-		kfree(ri);
-	}
-
-#ifdef CONFIG_X86_32
-	return (void*)orig_ret_address;
-#else
-	/*
-	 * By returning a non-zero value, we are telling
-	 * kprobe_handler() that we don't want the post_handler
-	 * to run (and have re-enabled preemption)
-	 */
-	return 1;
-#endif
-}
-
-/*
- * Called after single-stepping.  p->addr is the address of the
- * instruction whose first byte has been replaced by the "int 3"
- * instruction.  To avoid the SMP problems that can occur when we
- * temporarily put back the original opcode to single-step, we
- * single-stepped a copy of the instruction.  The address of this
- * copy is p->ainsn.insn.
- *
- * This function prepares to return from the post-single-step
- * interrupt.  We have to fix up the stack as follows:
- *
- * 0) Except in the case of absolute or indirect jump or call instructions,
- * the new ip is relative to the copied instruction.  We need to make
- * it relative to the original instruction.
- *
- * 1) If the single-stepped instruction was pushfl, then the TF and IF
- * flags are set in the just-pushed flags, and may need to be cleared.
- *
- * 2) If the single-stepped instruction was a call, the return address
- * that is atop the stack is the address following the copied instruction.
- * We need to make it the address following the original instruction.
- *
- * This function also checks instruction size for preparing direct execution.
- */
-static void __kprobes resume_execution(struct kprobe *p,
-		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
-{
-	unsigned long *tos = &regs->sp;
-	unsigned long next_rip = 0;
-	unsigned long copy_ip = (unsigned long)p->ainsn.insn;
-	unsigned long orig_ip = (unsigned long)p->addr;
-	kprobe_opcode_t *insn = p->ainsn.insn;
-
-#ifdef CONFIG_X86_64
-	/*skip the REX prefix*/
-	if (*insn >= 0x40 && *insn <= 0x4f)
-		insn++;
-#endif
-
-	regs->flags &= ~TF_MASK;
-	switch (*insn) {
-	case 0x9c:		/* pushfl */
-		*tos &= ~(TF_MASK | IF_MASK);
-		*tos |= kcb->kprobe_old_flags;
-		break;
-	case 0xc2:		/* ret/lret */
-	case 0xc3:
-	case 0xca:
-	case 0xcb:
-#ifdef CONFIG_X86_32
-	case 0xcf:		/* iret */
-		/* ip is already adjusted, no more changes required */
-		p->ainsn.boostable = 1;
-		goto no_change;
-#else
-		/* ip is already adjusted, no more changes required*/
-		return;
-#endif
-	case 0xe8:		/* call relative - Fix return addr */
-		*tos = orig_ip + (*tos - copy_ip);
-		break;
-#ifdef CONFIG_X86_32
-	case 0x9a:		/* call absolute -- same as call absolute, indirect */
-		*tos = orig_ip + (*tos - copy_ip);
-		goto no_change;
-#endif
-	case 0xff:
-#ifdef CONFIG_X86_32
-		if ((insn[1] & 0x30) == 0x10) {
-			/*
-			 * call absolute, indirect
-			 * Fix return addr; ip is correct.
-			 * But this is not boostable
-			 */
-			*tos = orig_ip + (*tos - copy_ip);
-			goto no_change;
-		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
-			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
-			/* ip is correct. And this is boostable */
-			p->ainsn.boostable = 1;
-			goto no_change;
-		}
-#else
-		if ((insn[1] & 0x30) == 0x10) {
-			/* call absolute, indirect */
-			/* Fix return addr; ip is correct. */
-			next_rip = regs->ip;
-			*tos = orig_ip + (*tos - copy_ip);
-		} else if (((insn[1] & 0x31) == 0x20) ||	/* jmp near, absolute indirect */
-			   ((insn[1] & 0x31) == 0x21)) {	/* jmp far, absolute indirect */
-			/* ip is correct. */
-			next_rip = regs->ip;
-		}
-#endif
-		break;
-	case 0xea:		/* jmp absolute -- ip is correct */
-#ifdef CONFIG_X86_32
-		/* ip is already adjusted, no more changes required */
-		p->ainsn.boostable = 1;
-		goto no_change;
-#else
-		next_rip = regs->ip;
-		break;
-#endif
-	default:
-		break;
-	}
-
-#ifdef CONFIG_X86_32
-	if (p->ainsn.boostable == 0) {
-		if ((regs->ip > copy_ip) &&
-		    (regs->ip - copy_ip) + 5 < (MAX_INSN_SIZE + 1)) {
-			/*
-			 * These instructions can be executed directly if it
-			 * jumps back to correct address.
-			 */
-			set_jmp_op((void *)regs->ip,
-				   (void *)orig_ip + (regs->ip - copy_ip));
-			p->ainsn.boostable = 1;
-		} else {
-			p->ainsn.boostable = -1;
-		}
-	}
-
-	regs->ip = orig_ip + (regs->ip - copy_ip);
-
-no_change:
-#else
-	if (next_rip) {
-		regs->ip = next_rip;
-	} else {
-		regs->ip = orig_ip + (regs->ip - copy_ip);
-	}
-#endif
-	restore_btf();
-}
-
-/*
- * Interrupts are disabled on entry as trap1 is an interrupt gate and they
- * remain disabled thoroughout this function.
- */
-static int __kprobes post_kprobe_handler(struct pt_regs *regs)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	if (!cur)
-		return 0;
-
-	if ((kcb->kprobe_status != KPROBE_REENTER) && cur->post_handler) {
-		kcb->kprobe_status = KPROBE_HIT_SSDONE;
-		cur->post_handler(cur, regs, 0);
-	}
-
-	resume_execution(cur, regs, kcb);
-	regs->flags |= kcb->kprobe_saved_flags;
-	trace_hardirqs_fixup_flags(regs->flags);
-
-	/* Restore the original saved kprobes variables and continue. */
-	if (kcb->kprobe_status == KPROBE_REENTER) {
-		restore_previous_kprobe(kcb);
-		goto out;
-	}
-	reset_current_kprobe();
-out:
-	preempt_enable_no_resched();
-
-	/*
-	 * if somebody else is singlestepping across a probe point, flags
-	 * will have TF set, in which case, continue the remaining processing
-	 * of do_debug, as if this is not a probe hit.
-	 */
-	if (regs->flags & TF_MASK)
-		return 0;
-
-	return 1;
-}
-
-int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
-{
-	struct kprobe *cur = kprobe_running();
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-#ifdef CONFIG_X86_64
-	const struct exception_table_entry *fixup;
-#endif
-
-	switch(kcb->kprobe_status) {
-	case KPROBE_HIT_SS:
-	case KPROBE_REENTER:
-		/*
-		 * We are here because the instruction being single
-		 * stepped caused a page fault. We reset the current
-		 * kprobe and the ip points back to the probe address
-		 * and allow the page fault handler to continue as a
-		 * normal page fault.
-		 */
-		regs->ip = (unsigned long)cur->addr;
-		regs->flags |= kcb->kprobe_old_flags;
-		if (kcb->kprobe_status == KPROBE_REENTER)
-			restore_previous_kprobe(kcb);
-		else
-			reset_current_kprobe();
-		preempt_enable_no_resched();
-		break;
-	case KPROBE_HIT_ACTIVE:
-	case KPROBE_HIT_SSDONE:
-		/*
-		 * We increment the nmissed count for accounting,
-		 * we can also use npre/npostfault count for accouting
-		 * these specific fault cases.
-		 */
-		kprobes_inc_nmissed_count(cur);
-
-		/*
-		 * We come here because instructions in the pre/post
-		 * handler caused the page_fault, this could happen
-		 * if handler tries to access user space by
-		 * copy_from_user(), get_user() etc. Let the
-		 * user-specified handler try to fix it first.
-		 */
-		if (cur->fault_handler && cur->fault_handler(cur, regs, trapnr))
-			return 1;
-
-		/*
-		 * In case the user-specified fault handler returned
-		 * zero, try to fix up.
-		 */
-#ifdef CONFIG_X86_32
-		if (fixup_exception(regs))
-			return 1;
-#else
-		fixup = search_exception_tables(regs->ip);
-		if (fixup) {
-			regs->ip = fixup->fixup;
-			return 1;
-		}
-#endif
-		/*
-		 * Exception couldn't be fixed up,
-		 * Let do_page_fault() fix it.
-		 */
-		break;
-	default:
-		break;
-	}
-	return 0;
-}
-
-/*
- * Wrapper routine for handling exceptions.
- */
-int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
-				       unsigned long val, void *data)
-{
-	struct die_args *args = (struct die_args *)data;
-	int ret = NOTIFY_DONE;
-
-#ifdef CONFIG_X86_32
-	if (args->regs && user_mode_vm(args->regs))
-		return ret;
-#else
-	if (args->regs && user_mode(args->regs))
-		return ret;
-#endif
-
-	switch (val) {
-	case DIE_INT3:
-		if (kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_DEBUG:
-		if (post_kprobe_handler(args->regs))
-			ret = NOTIFY_STOP;
-		break;
-	case DIE_GPF:
-		/* kprobe_running() needs smp_processor_id() */
-		preempt_disable();
-		if (kprobe_running() &&
-		    kprobe_fault_handler(args->regs, args->trapnr))
-			ret = NOTIFY_STOP;
-		preempt_enable();
-		break;
-	default:
-		break;
-	}
-	return ret;
-}
-
-int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct jprobe *jp = container_of(p, struct jprobe, kp);
-	unsigned long addr;
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-
-	kcb->jprobe_saved_regs = *regs;
-	kcb->jprobe_saved_sp = &regs->sp;
-	addr = (unsigned long)(kcb->jprobe_saved_sp);
-
-	/*
-	 * As Linus pointed out, gcc assumes that the callee
-	 * owns the argument space and could overwrite it, e.g.
-	 * tailcall optimization. So, to be absolutely safe
-	 * we also save and restore enough stack bytes to cover
-	 * the argument area.
-	 */
-	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *)addr,
-			MIN_STACK_SIZE(addr));
-	regs->flags &= ~IF_MASK;
-	trace_hardirqs_off();
-	regs->ip = (unsigned long)(jp->entry);
-	return 1;
-}
-
-void __kprobes jprobe_return(void)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-#ifdef CONFIG_X86_32
-	asm volatile ("       xchgl   %%ebx,%%esp     \n"
-		      "       int3			\n"
-		      "       .globl jprobe_return_end	\n"
-		      "       jprobe_return_end:	\n"
-		      "       nop			\n"::"b"
-		      (kcb->jprobe_saved_sp):"memory");
-#else
-	asm volatile ("       xchg   %%rbx,%%rsp     \n"
-		      "       int3			\n"
-		      "       .globl jprobe_return_end	\n"
-		      "       jprobe_return_end:	\n"
-		      "       nop			\n"::"b"
-		      (kcb->jprobe_saved_sp):"memory");
-#endif
-}
-
-int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
-{
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	u8 *addr = (u8 *) (regs->ip - 1);
-	unsigned long stack_addr = (unsigned long)(kcb->jprobe_saved_sp);
-	struct jprobe *jp = container_of(p, struct jprobe, kp);
-
-	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
-		if (&regs->sp != kcb->jprobe_saved_sp) {
-			struct pt_regs *saved_regs =
-			    container_of(kcb->jprobe_saved_sp,
-					    struct pt_regs, sp);
-			printk("current sp %p does not match saved sp %p\n",
-			       &regs->sp, kcb->jprobe_saved_sp);
-			printk("Saved registers for jprobe %p\n", jp);
-			show_registers(saved_regs);
-			printk("Current registers\n");
-			show_registers(regs);
-			BUG();
-		}
-		*regs = kcb->jprobe_saved_regs;
-		memcpy((kprobe_opcode_t *) stack_addr, kcb->jprobes_stack,
-		       MIN_STACK_SIZE(stack_addr));
-		preempt_enable_no_resched();
-		return 1;
-	}
-	return 0;
-}
-
-#ifdef CONFIG_X86_64
-static struct kprobe trampoline_p = {
-	.addr = (kprobe_opcode_t *) &kretprobe_trampoline,
-	.pre_handler = trampoline_probe_handler
-};
-#endif
-
-int __kprobes arch_trampoline_kprobe(struct kprobe *p)
-{
-#ifdef CONFIG_X86_64
-	if (p->addr == (kprobe_opcode_t *)&kretprobe_trampoline)
-		return 1;
-#endif
-	return 0;
-}
-
-int __init arch_init_kprobes(void)
-{
-#ifdef CONFIG_X86_32
-	return 0;
-#else
-	return register_kprobe(&trampoline_p);
-#endif
-}
-- 
1.5.4.rc0.1083.gf568



