Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbXLRDKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbXLRDKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 22:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbXLRDK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 22:10:27 -0500
Received: from ro-out-1112.google.com ([72.14.202.182]:48850 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXLRDK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 22:10:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GvCo/+uOHNbUDN4ayg1Bo0CywcO0ArNqBQ7dnJAZLoTnUMyaexfYrHmJ9h7l+b+/rQXCW190fHExI8KqRZzMGK8euSWQMW4MKBHMXxa9oTHQ5ZHXC2uQnhHYey1rpsu5zR++U82aIowSaZwd0xjnKUKI07kQ2dO9p9fkhEndR4g=
Subject: [PATCH] x86: kprobes use stack_addr() macro
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>, srinivasa@in.ibm.com,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
In-Reply-To: <47671407.7050607@redhat.com>
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu>
	 <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu>
	 <20071217142235.GA21379@linux.vnet.ibm.com>
	 <1197919234.23402.5.camel@brick>  <4766E9FC.7050101@redhat.com>
	 <1197927385.23402.41.camel@brick>  <4766EFA8.9070907@redhat.com>
	 <1197928823.23402.108.camel@brick>  <476702C4.8070205@redhat.com>
	 <1197934053.23402.124.camel@brick> <47670CB7.5060303@redhat.com>
	 <47671407.7050607@redhat.com>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 19:10:23 -0800
Message-Id: <1197947423.7734.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Replacement for the last patch in the kprobes series I just sent.

 arch/x86/kernel/kprobes.c |   45 +++++++++++++++++++++------------------------
 1 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 6f52c5e..c9df6fb 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -44,6 +44,20 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
 };
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
 
+/*
+ * "&regs->sp" looks wrong, but it's correct for x86_32.  x86_32 CPUs
+ * don't save the ss and esp registers if the CPU is already in kernel
+ * mode when it traps.  So for kprobes, regs->sp and regs->ss are not
+ * the [nonexistent] saved stack pointer and ss register, but rather
+ * the top 8 bytes of the pre-int3 stack.  So &regs->sp happens to
+ * point to the top of the pre-int3 stack.
+ */
+#ifdef CONFIG_X86_32
+# define stack_addr(regs) ((unsigned long *)&regs->sp)
+#else
+# define stack_addr(regs) ((unsigned long *)regs->sp)
+#endif
+
 #define W(r, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)  \
 	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
 	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
@@ -409,11 +423,8 @@ static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
-#ifdef CONFIG_X86_32
-	unsigned long *sara = (unsigned long *)&regs->sp;
-#else
-	unsigned long *sara = (unsigned long *)regs->sp;
-#endif
+	unsigned long *sara = stack_addr(regs);
+
 	ri->ret_addr = (kprobe_opcode_t *) *sara;
 	/* Replace the return addr with trampoline addr */
 	*sara = (unsigned long) &kretprobe_trampoline;
@@ -751,11 +762,8 @@ void *__kprobes trampoline_handler(struct pt_regs *regs)
 static void __kprobes resume_execution(struct kprobe *p,
 		struct pt_regs *regs, struct kprobe_ctlblk *kcb)
 {
-#ifdef CONFIG_X86_32
-	unsigned long *tos = (unsigned long *)&regs->sp;
-#else
-	unsigned long *tos = (unsigned long *)regs->sp;
-#endif
+
+	unsigned long *tos = stack_addr(regs);
 	unsigned long copy_ip = (unsigned long)p->ainsn.insn;
 	unsigned long orig_ip = (unsigned long)p->addr;
 	kprobe_opcode_t *insn = p->ainsn.insn;
@@ -984,11 +992,7 @@ int __kprobes setjmp_pre_handler(struct kprobe *p, struct pt_regs *regs)
 	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
 
 	kcb->jprobe_saved_regs = *regs;
-#ifdef CONFIG_X86_32
-	kcb->jprobe_saved_sp = &regs->sp;
-#else
-	kcb->jprobe_saved_sp = (long *) regs->sp;
-#endif
+	kcb->jprobe_saved_sp = (long *)stack_addr(regs);
 	addr = (unsigned long)(kcb->jprobe_saved_sp);
 	/*
 	 * As Linus pointed out, gcc assumes that the callee
@@ -1033,17 +1037,10 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
 
 	if ((addr > (u8 *) jprobe_return) && (addr < (u8 *) jprobe_return_end)) {
-#ifdef CONFIG_X86_32
-		if (&regs->sp != kcb->jprobe_saved_sp) {
+		if (stack_addr(regs) != kcb->jprobe_saved_sp) {
 			struct pt_regs *saved_regs = &kcb->jprobe_saved_sp;
 			printk("current sp %p does not match saved sp %p\n",
-			       &regs->sp, kcb->jprobe_saved_sp);
-#else
-		if ((long *)regs->sp != kcb->jprobe_saved_sp) {
-			struct pt_regs *saved_regs = &kcb->jprobe_saved_sp;
-			printk("current sp %p does not match saved sp %p\n",
-			       (long *)regs->sp, kcb->jprobe_saved_sp);
-#endif
+			       stack_addr(regs), kcb->jprobe_saved_sp);
 			printk("Saved registers for jprobe %p\n", jp);
 			show_registers(saved_regs);
 			printk("Current registers\n");
-- 
1.5.4.rc0.1083.gf568



