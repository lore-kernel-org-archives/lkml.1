Return-Path: <linux-kernel-owner+w=401wt.eu-S1161606AbXD2XvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161606AbXD2XvE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 19:51:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161611AbXD2Xqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 19:46:48 -0400
Received: from ns1.suse.de ([195.135.220.2]:41970 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161608AbXD2Xqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 19:46:35 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430146.588463000@suse.de>
In-Reply-To: <20070430146.588463000@suse.de>
To: Glauber de Oliveira Costa <gcosta@redhat.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [24/26] x86_64: Fix x86_64 compilation with DEBUG_SIG on
Message-Id: <20070429234634.50CBC150F2@wotan.suse.de>
Date: Mon, 30 Apr 2007 01:46:34 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Glauber de Oliveira Costa <gcosta@redhat.com>

Setting the DEBUG_SIG flag breaks compilation due to a wrong
struct access. Aditionally, it raises two warnings. This is one
patch to fix them all.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
Signed-off-by: Andi Kleen <ak@suse.de>

-- 
Glauber de Oliveira Costa
Red Hat Inc.
"Free as in Freedom"


commit ff9d841995b6055b74017306f30485c2b4a9ea70
Author: Glauber de Oliveira Costa <gcosta@redhat.com>
Date:   Fri Mar 23 07:13:38 2007 -0300

    [PATCH] Fix x86_64 compilation with DEBUG_SIG on
    
    Setting the DEBUG_SIG flag breaks compilation due to a wrong
    struct access. Aditionally, it raises two warnings. This is one
    patch to fix them all.
    
    Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

---
 arch/x86_64/kernel/signal.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/arch/x86_64/kernel/signal.c
===================================================================
--- linux.orig/arch/x86_64/kernel/signal.c
+++ linux/arch/x86_64/kernel/signal.c
@@ -141,7 +141,7 @@ asmlinkage long sys_rt_sigreturn(struct 
 		goto badframe;
 
 #ifdef DEBUG_SIG
-	printk("%d sigreturn rip:%lx rsp:%lx frame:%p rax:%lx\n",current->pid,regs.rip,regs.rsp,frame,eax);
+	printk("%d sigreturn rip:%lx rsp:%lx frame:%p rax:%lx\n",current->pid,regs->rip,regs->rsp,frame,eax);
 #endif
 
 	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->rsp) == -EFAULT)
@@ -301,7 +301,7 @@ static int setup_rt_frame(int sig, struc
 	if (test_thread_flag(TIF_SINGLESTEP))
 		ptrace_notify(SIGTRAP);
 #ifdef DEBUG_SIG
-	printk("SIG deliver (%s:%d): sp=%p pc=%p ra=%p\n",
+	printk("SIG deliver (%s:%d): sp=%p pc=%lx ra=%p\n",
 		current->comm, current->pid, frame, regs->rip, frame->pretcode);
 #endif
 
@@ -463,7 +463,7 @@ void
 do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 {
 #ifdef DEBUG_SIG
-	printk("do_notify_resume flags:%x rip:%lx rsp:%lx caller:%lx pending:%lx\n",
+	printk("do_notify_resume flags:%x rip:%lx rsp:%lx caller:%p pending:%x\n",
 	       thread_info_flags, regs->rip, regs->rsp, __builtin_return_address(0),signal_pending(current)); 
 #endif
 	       
