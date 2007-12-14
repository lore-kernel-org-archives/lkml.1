Return-Path: <linux-kernel-owner+w=401wt.eu-S1765435AbXLNWKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765435AbXLNWKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 17:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757322AbXLNWKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 17:10:35 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:49458 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbXLNWKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 17:10:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bayjcvN42i3jBj/0uyEgXggBAeiv6pLeHRHYgasict8BoikarLel7nQ/VYh8voliUEDe8TCTvZyoz4r9hXZtT2yXSdJZdCXW89vpsv+4A4hIYfOYnB0lX7SFWuoKzjRvGtXeRVtI2XYIXRXfjoZX5M0cUqBZE6dsIiO+Ndz9lrk=
Subject: [PATCH] x86: Unify kpropes MAX_INSN_SIZE definition
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 14 Dec 2007 14:10:32 -0800
Message-Id: <1197670232.898.63.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes_32.c |    8 ++++----
 include/asm-x86/kprobes.h    |    5 +----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
index b47381e..615f24a 100644
--- a/arch/x86/kernel/kprobes_32.c
+++ b/arch/x86/kernel/kprobes_32.c
@@ -101,13 +101,13 @@ static __always_inline int can_boost(kprobe_opcode_t *opcodes)
 	kprobe_opcode_t opcode;
 	kprobe_opcode_t *orig_opcodes = opcodes;
 retry:
-	if (opcodes - orig_opcodes > MAX_INSN_SIZE - 1)
+	if (opcodes - orig_opcodes > MAX_INSN_SIZE)
 		return 0;
 	opcode = *(opcodes++);
 
 	/* 2nd-byte opcode */
 	if (opcode == 0x0f) {
-		if (opcodes - orig_opcodes > MAX_INSN_SIZE - 1)
+		if (opcodes - orig_opcodes > MAX_INSN_SIZE)
 			return 0;
 		return test_bit(*opcodes, twobyte_is_boostable);
 	}
@@ -164,7 +164,7 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
 	if (!p->ainsn.insn)
 		return -ENOMEM;
 
-	memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+	memcpy(p->ainsn.insn, p->addr, (MAX_INSN_SIZE + 1) * sizeof(kprobe_opcode_t));
 	p->opcode = *p->addr;
 	if (can_boost(p->addr)) {
 		p->ainsn.boostable = 0;
@@ -539,7 +539,7 @@ static void __kprobes resume_execution(struct kprobe *p,
 
 	if (p->ainsn.boostable == 0) {
 		if ((regs->ip > copy_eip) &&
-		    (regs->ip - copy_eip) + 5 < MAX_INSN_SIZE) {
+		    (regs->ip - copy_eip) + 5 < (MAX_INSN_SIZE + 1)) {
 			/*
 			 * These instructions can be executed directly if it
 			 * jumps back to correct address.
diff --git a/include/asm-x86/kprobes.h b/include/asm-x86/kprobes.h
index 87b9d1b..e348ed6 100644
--- a/include/asm-x86/kprobes.h
+++ b/include/asm-x86/kprobes.h
@@ -35,12 +35,9 @@ struct kprobe;
 struct pt_regs;
 
 typedef u8 kprobe_opcode_t;
-#ifdef CONFIG_X86_32
+
 # define RELATIVEJUMP_INSTRUCTION 0xe9
-# define MAX_INSN_SIZE 16
-#else
 # define MAX_INSN_SIZE 15
-#endif
 
 #define BREAKPOINT_INSTRUCTION	0xcc
 #define MAX_STACK_SIZE 64
-- 
1.5.4.rc0.1083.gf568



