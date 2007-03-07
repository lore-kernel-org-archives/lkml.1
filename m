Return-Path: <linux-kernel-owner+w=401wt.eu-S1422630AbXCGTLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422630AbXCGTLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422996AbXCGTLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:11:10 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:57406 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422630AbXCGTLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:11:07 -0500
Date: Wed, 7 Mar 2007 14:01:00 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>, stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Blaisorblade <blaisorblade@yahoo.it>
Subject: [PATCH] UML - arch_prctl should set thread fs
Message-ID: <20070307190100.GA3847@ccure.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Andrew, this is definite 2.6.21 material ]

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

Index: linux-2.6.18-mm/arch/um/sys-x86_64/syscalls.c
===================================================================
--- linux-2.6.18-mm.orig/arch/um/sys-x86_64/syscalls.c	2007-03-07 12:05:02.000000000 -0500
+++ linux-2.6.18-mm/arch/um/sys-x86_64/syscalls.c	2007-03-07 14:01:16.000000000 -0500
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
