Return-Path: <linux-kernel-owner+w=401wt.eu-S965781AbXCPRfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965781AbXCPRfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 13:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965792AbXCPRfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 13:35:32 -0400
Received: from [198.99.130.12] ([198.99.130.12]:58988 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S965781AbXCPRfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 13:35:30 -0400
Date: Fri, 16 Mar 2007 12:10:15 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH] UML - arch_prctl should set thread fs
Message-ID: <20070316161015.GA7948@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ This missed getting into -stable the first time I sent it ]

In my previous x86_64 thread fix, I forgot to initialize
thread.arch.fs in arch_prctl.  A process calling arch_prctl to set %fs
would lose it on the next context switch.

It also turns out that you can switch to a process which is in the
process of exiting and which has lost its mm.  In this case, it's
worse than useless to try to call arch_prctl on the host process. 

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/sys-x86_64/syscalls.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.17/arch/um/sys-x86_64/syscalls.c
===================================================================
--- linux-2.6.17.orig/arch/um/sys-x86_64/syscalls.c	2007-03-07 12:18:38.000000000 -0500
+++ linux-2.6.17/arch/um/sys-x86_64/syscalls.c	2007-03-16 12:04:40.000000000 -0400
@@ -103,6 +103,9 @@ long arch_prctl_skas(struct task_struct 
 
         switch(code){
 	case ARCH_SET_FS:
+		current->thread.arch.fs = (unsigned long) ptr;
+		save_registers(pid, &current->thread.regs.regs);
+		break;
 	case ARCH_SET_GS:
                 save_registers(pid, &current->thread.regs.regs);
 		break;
@@ -140,9 +143,8 @@ long sys_clone(unsigned long clone_flags
 
 void arch_switch_to_skas(struct task_struct *from, struct task_struct *to)
 {
-        if(to->thread.arch.fs == 0)
+        if((to->thread.arch.fs == 0) || (to->mm == NULL))
                 return;
 
         arch_prctl_skas(to, ARCH_SET_FS, (void __user *) to->thread.arch.fs);
 }
-
