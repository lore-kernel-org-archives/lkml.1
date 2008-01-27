Return-Path: <linux-kernel-owner+w=401wt.eu-S1754308AbYA0JKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbYA0JKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbYA0JJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:09:54 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:35168 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782AbYA0JJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:09:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=R1lqdW8hu0a88zlj/LSouLzHhNCHSD0ZE4tEEbSySVTexqxTMl0KmUKUhdkxBFH8gzMBVrLUswqMuNGSz5ZJgm5ZWJT3d/0sr15XBHvbDZ21fLfXIdG81NzgcS1J1K3JJv0XT0v9fgY2yUSi+pvjcttWaghbeb4nYeQD6nmReTw=
Message-ID: <479C4A42.1020602@gmail.com>
Date: Sun, 27 Jan 2008 14:39:22 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: jkenisto@us.ibm.com, ananth@in.ibm.com,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/3] x86: Macrofy resuable code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Encapsulate reusable code .

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index a99e764..45f2949 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -74,6 +74,13 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
 #define stack_addr(regs) ((unsigned long *)&regs->sp)
 #endif
 
+#define kprobe_bkpt_addr(regs) \
+	((unsigned long)(regs->ip - sizeof(kprobe_opcode_t)))
+
+#define is_jprobe_bkpt(ptr) \
+	((ptr > (u8 *)jprobe_return) && (ptr < (u8 *)jprobe_return_end))
+
+
 #define W(row, b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, ba, bb, bc, bd, be, bf)\
 	(((b0##UL << 0x0)|(b1##UL << 0x1)|(b2##UL << 0x2)|(b3##UL << 0x3) |   \
 	  (b4##UL << 0x4)|(b5##UL << 0x5)|(b6##UL << 0x6)|(b7##UL << 0x7) |   \
@@ -519,7 +526,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 	struct kprobe *p;
 	struct kprobe_ctlblk *kcb;
 
-	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
+	addr = (kprobe_opcode_t *)kprobe_bkpt_addr(regs);
 	if (*addr != BREAKPOINT_INSTRUCTION) {
 		/*
 		 * The breakpoint instruction was removed right
@@ -1032,8 +1039,7 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	u8 *addr = (u8 *) (regs->ip - 1);
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
 
-	if ((addr > (u8 *) jprobe_return) &&
-	    (addr < (u8 *) jprobe_return_end)) {
+	if (is_jprobe_bkpt(addr)) {
 		if (stack_addr(regs) != kcb->jprobe_saved_sp) {
 			struct pt_regs *saved_regs = &kcb->jprobe_saved_regs;
 			printk(KERN_ERR
