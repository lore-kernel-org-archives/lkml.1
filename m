Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807AbZFFSXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbZFFSXe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 14:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbZFFSX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 14:23:26 -0400
Received: from norkia.v3.sk ([92.240.234.41]:44882 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbZFFSXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 14:23:25 -0400
Subject: [PATCH] Fix non-lazy GS handling in sys_vm86()
From: Lubomir Rintel <lkundrak@v3.sk>
To: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       x86@kernel.org
Content-Type: text/plain
Date: Sat, 06 Jun 2009 20:23:25 +0200
Message-Id: <1244312605.28613.4.camel@bimbo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a stack corruption panic or null dereference oops due to
a bad GS in resume_userspace() when returning from sys_vm86() and calling
lockdep_sys_exit().

Only a problem when CONFIG_LOCKDEP and CONFIG_CC_STACKPROTECTOR enabled.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 arch/x86/kernel/vm86_32.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index d7ac84e..177d976 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -287,10 +287,9 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
 	info->regs.pt.ds = 0;
 	info->regs.pt.es = 0;
 	info->regs.pt.fs = 0;
-
-/* we are clearing gs later just before "jmp resume_userspace",
- * because it is not saved/restored.
- */
+#ifndef CONFIG_X86_32_LAZY_GS
+	info->regs.pt.gs = 0;
+#endif
 
 /*
  * The flags register is also special: we cannot trust that the user
@@ -343,10 +342,12 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
 	__asm__ __volatile__(
 		"movl %0,%%esp\n\t"
 		"movl %1,%%ebp\n\t"
-		"mov  %2, %%gs\n\t"
+#ifdef CONFIG_X86_32_LAZY_GS
+		"mov  $0, %%gs\n\t"
+#endif
 		"jmp resume_userspace"
 		: /* no outputs */
-		:"r" (&info->regs), "r" (task_thread_info(tsk)), "r" (0));
+		:"r" (&info->regs), "r" (task_thread_info(tsk)));
 	/* we never return here */
 }
 

-- 
"Excuse all the blood" -- Dead

