Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbZFGOX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbZFGOX4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 10:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZFGOXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 10:23:49 -0400
Received: from norkia.v3.sk ([92.240.234.41]:45728 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZFGOXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 10:23:49 -0400
Subject: Re: [PATCH] Fix non-lazy GS handling in sys_vm86()
From: Lubomir Rintel <lkundrak@v3.sk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       x86@kernel.org
In-Reply-To: <20090607075613.GA3962@elte.hu>
References: <1244312605.28613.4.camel@bimbo> <20090607075613.GA3962@elte.hu>
Content-Type: text/plain
Date: Sun, 07 Jun 2009 16:23:48 +0200
Message-Id: <1244384628.2323.4.camel@bimbo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-07 at 09:56 +0200, Ingo Molnar wrote:
> * Lubomir Rintel <lkundrak@v3.sk> wrote:

> > -		"mov  %2, %%gs\n\t"
> > +#ifdef CONFIG_X86_32_LAZY_GS
> > +		"mov  $0, %%gs\n\t"
> > +#endif
> 
> That bit looks rather untested - i dont think there's an immediate 
> constant instruction variant for segment register moves ...

Right. Sorry, I only tested (dosbox & svgalib) with stackprotector
enabled. This time I ensured it compiles and runs dosbox & mode3 (from
svgalib) both with and without stackprotector:

>From 8bdb7e27766be7bf2902cf6d6938f3e5868d0aac Mon Sep 17 00:00:00 2001
From: Lubomir Rintel <lkundrak@v3.sk>
Date: Sat, 6 Jun 2009 20:09:17 +0200
Subject: [PATCH] Fix non-lazy GS handling in sys_vm86()

This fixes a stack corruption panic or null dereference oops due to
a bad GS in resume_userspace() when returning from sys_vm86() and calling
lockdep_sys_exit().

Only a problem when CONFIG_LOCKDEP and CONFIG_CC_STACKPROTECTOR enabled.
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
-- 
1.6.2.2

-- 
"Excuse all the blood" -- Dead

