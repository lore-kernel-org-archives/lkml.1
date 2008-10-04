Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbYJDVcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbYJDVcS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 17:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYJDVcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 17:32:09 -0400
Received: from m-relay2.rz.uni-saarland.de ([134.96.7.8]:2742 "EHLO
	eris.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbYJDVcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 17:32:08 -0400
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] dumpstack: x86: add "end" parameter to valid_stack_ptr and print_context_stack
Date: Sat,  4 Oct 2008 23:12:42 +0200
Message-Id: <1223154766-19350-4-git-send-email-heukelum@fastmail.fm>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1223154766-19350-3-git-send-email-heukelum@fastmail.fm>
References: <1223154766-19350-1-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-2-git-send-email-heukelum@fastmail.fm>
 <1223154766-19350-3-git-send-email-heukelum@fastmail.fm>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (eris.rz.uni-saarland.de [134.96.7.8]); Sat, 04 Oct 2008 23:31:50 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.8.1.34; VDF: 7.0.6.243; host: AntiVir2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - Add "end" parameter to valid_stack_ptr and print_context_stack
 - use sizeof(long) as the size of a word on the stack

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
---
 arch/x86/kernel/dumpstack_32.c |   19 +++++++++++++------
 arch/x86/kernel/dumpstack_64.c |    2 +-
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index 62f71c8..09cd37c 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -28,10 +28,16 @@ void printk_address(unsigned long address, int reliable)
 }
 
 static inline int valid_stack_ptr(struct thread_info *tinfo,
-			void *p, unsigned int size)
+			void *p, unsigned int size, void *end)
 {
 	void *t = tinfo;
-	return	p > t && p <= t + THREAD_SIZE - size;
+	if (end) {
+		if (p < end && p >= (end-THREAD_SIZE))
+			return 1;
+		else
+			return 0;
+	}
+	return p > t && p < t + THREAD_SIZE - size;
 }
 
 /* The form of the top of the frame on the stack */
@@ -43,16 +49,17 @@ struct stack_frame {
 static inline unsigned long
 print_context_stack(struct thread_info *tinfo,
 		unsigned long *stack, unsigned long bp,
-		const struct stacktrace_ops *ops, void *data)
+		const struct stacktrace_ops *ops, void *data,
+		unsigned long *end)
 {
 	struct stack_frame *frame = (struct stack_frame *)bp;
 
-	while (valid_stack_ptr(tinfo, stack, sizeof(*stack))) {
+	while (valid_stack_ptr(tinfo, stack, sizeof(*stack), end)) {
 		unsigned long addr;
 
 		addr = *stack;
 		if (__kernel_text_address(addr)) {
-			if ((unsigned long) stack == bp + 4) {
+			if ((unsigned long) stack == bp + sizeof(long)) {
 				ops->address(data, addr, 1);
 				frame = frame->next_frame;
 				bp = (unsigned long) frame;
@@ -96,7 +103,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 
 		context = (struct thread_info *)
 			((unsigned long)stack & (~(THREAD_SIZE - 1)));
-		bp = print_context_stack(context, stack, bp, ops, data);
+		bp = print_context_stack(context, stack, bp, ops, data, NULL);
 		/*
 		 * Should be after the line below, but somewhere
 		 * in early boot context comes out corrupted and we
diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index f215f1c..9e40357 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -141,7 +141,7 @@ print_context_stack(struct thread_info *tinfo,
 
 		addr = *stack;
 		if (__kernel_text_address(addr)) {
-			if ((unsigned long) stack == bp + 8) {
+			if ((unsigned long) stack == bp + sizeof(long)) {
 				ops->address(data, addr, 1);
 				frame = frame->next_frame;
 				bp = (unsigned long) frame;
-- 
1.5.4.3

