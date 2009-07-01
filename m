Return-Path: <linux-kernel-owner+w=401wt.eu-S1762039AbZGABKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762039AbZGABKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761531AbZGAAfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:30 -0400
Received: from kroah.org ([198.145.64.141]:60585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760446AbZGAAfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:38 2009
Message-Id: <20090701002438.502935424@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Lubomir Rintel <lkundrak@v3.sk>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Noonan <steven@uplinklabs.net>
Subject: [patch 080/108] x86: Fix non-lazy GS handling in sys_vm86()
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=x86-fix-non-lazy-gs-handling-in-sys_vm86.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lubomir Rintel <lkundrak@v3.sk>

commit 3aa6b186f86c5d06d6d92d14311ffed51f091f40 upstream.

This fixes a stack corruption panic or null dereference oops
due to a bad GS in resume_userspace() when returning from
sys_vm86() and calling lockdep_sys_exit().

Only a problem when CONFIG_LOCKDEP and CONFIG_CC_STACKPROTECTOR
enabled.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <1244384628.2323.4.camel@bimbo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Steven Noonan <steven@uplinklabs.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/vm86_32.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -287,10 +287,9 @@ static void do_sys_vm86(struct kernel_vm
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
@@ -343,7 +342,9 @@ static void do_sys_vm86(struct kernel_vm
 	__asm__ __volatile__(
 		"movl %0,%%esp\n\t"
 		"movl %1,%%ebp\n\t"
+#ifdef CONFIG_X86_32_LAZY_GS
 		"mov  %2, %%gs\n\t"
+#endif
 		"jmp resume_userspace"
 		: /* no outputs */
 		:"r" (&info->regs), "r" (task_thread_info(tsk)), "r" (0));


