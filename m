Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbYA0Nbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbYA0Nbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 08:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYA0Nbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 08:31:34 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:31119 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbYA0Nbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 08:31:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=JEmbNM094UP16E1gQH7lFbCKEmoYQWKHnp3XN4/XlQmjgGCyTdSzPuytl7CamtMKjBWhg1vGV911hD5LL3JeKl52m89JKpHNBJBw+WXuYNG0eRlPfiqNfiNk6/aNNwysmZCemS4xd9x4bSM6hdhlue0cZGPZ6dMJrLJuBXQWYwM=
Message-ID: <479C8795.1080709@gmail.com>
Date: Sun, 27 Jan 2008 19:01:01 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       ananth@in.ibm.com, Masami Hiramatsu <mhiramat@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/3] x86: Macrofy resuable code
References: <479C4A42.1020602@gmail.com> <20080127092344.GB18116@uranus.ravnborg.org>
In-Reply-To: <20080127092344.GB18116@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:

> Small static functions are preferred over macros.
> Any particular reason to use a macro here?
> 
> 	Sam

These macros have very limited(two) instantiations. But here's an alternative patch inlined.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index a99e764..b7c2d20 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -159,6 +159,16 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
 };
 const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
 
+static inline unsigned long kprobe_bkpt_addr(struct pt_regs *regs)
+{
+	return (instruction_pointer(regs) - sizeof(kprobe_opcode_t));
+}
+
+static inline int is_jprobe_bkpt(u8 *ptr)
+{
+	return (ptr > (u8 *)jprobe_return) && (ptr < (u8 *)jprobe_return_end);
+}
+
 /* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
 static void __kprobes set_jmp_op(void *from, void *to)
 {
@@ -519,7 +529,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
 	struct kprobe *p;
 	struct kprobe_ctlblk *kcb;
 
-	addr = (kprobe_opcode_t *)(regs->ip - sizeof(kprobe_opcode_t));
+	addr = (kprobe_opcode_t *)kprobe_bkpt_addr(regs);
 	if (*addr != BREAKPOINT_INSTRUCTION) {
 		/*
 		 * The breakpoint instruction was removed right
@@ -1032,8 +1042,7 @@ int __kprobes longjmp_break_handler(struct kprobe *p, struct pt_regs *regs)
 	u8 *addr = (u8 *) (regs->ip - 1);
 	struct jprobe *jp = container_of(p, struct jprobe, kp);
 
-	if ((addr > (u8 *) jprobe_return) &&
-	    (addr < (u8 *) jprobe_return_end)) {
+	if (is_jprobe_bkpt(addr)) {
 		if (stack_addr(regs) != kcb->jprobe_saved_sp) {
 			struct pt_regs *saved_regs = &kcb->jprobe_saved_regs;
 			printk(KERN_ERR
