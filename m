Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZFGOnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZFGOnd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755702AbZFGOnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:43:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:52876 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633AbZFGOnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:43:17 -0400
Date: Sun, 7 Jun 2009 14:42:33 GMT
From: tip-bot for Lubomir Rintel <lkundrak@v3.sk>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, lkundrak@v3.sk
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, lkundrak@v3.sk, mingo@elte.hu
In-Reply-To: <1244384628.2323.4.camel@bimbo>
References: <1244384628.2323.4.camel@bimbo>
Subject: [tip:x86/urgent] x86: Fix non-lazy GS handling in sys_vm86()
Message-ID: <tip-3aa6b186f86c5d06d6d92d14311ffed51f091f40@git.kernel.org>
Git-Commit-ID: 3aa6b186f86c5d06d6d92d14311ffed51f091f40
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 14:42:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3aa6b186f86c5d06d6d92d14311ffed51f091f40
Gitweb:     http://git.kernel.org/tip/3aa6b186f86c5d06d6d92d14311ffed51f091f40
Author:     Lubomir Rintel <lkundrak@v3.sk>
AuthorDate: Sun, 7 Jun 2009 16:23:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Jun 2009 16:31:23 +0200

x86: Fix non-lazy GS handling in sys_vm86()

This fixes a stack corruption panic or null dereference oops
due to a bad GS in resume_userspace() when returning from
sys_vm86() and calling lockdep_sys_exit().

Only a problem when CONFIG_LOCKDEP and CONFIG_CC_STACKPROTECTOR
enabled.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <1244384628.2323.4.camel@bimbo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vm86_32.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index d7ac84e..6a17769 100644
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
@@ -343,7 +342,9 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
 	__asm__ __volatile__(
 		"movl %0,%%esp\n\t"
 		"movl %1,%%ebp\n\t"
+#ifdef CONFIG_X86_32_LAZY_GS
 		"mov  %2, %%gs\n\t"
+#endif
 		"jmp resume_userspace"
 		: /* no outputs */
 		:"r" (&info->regs), "r" (task_thread_info(tsk)), "r" (0));
