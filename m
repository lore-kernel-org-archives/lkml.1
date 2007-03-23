Return-Path: <linux-kernel-owner+w=401wt.eu-S1751711AbXCWOOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbXCWOOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945897AbXCWOOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:14:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44634 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbXCWOOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:14:41 -0400
Date: Fri, 23 Mar 2007 09:37:31 -0300
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de
Subject: [PATCH] Fix x86_64 compilation with DEBUG_SIG on
Message-ID: <20070323123731.GA13310@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Setting the DEBUG_SIG flag breaks compilation due to a wrong
struct access. Aditionally, it raises two warnings. This is one
patch to fix them all.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

-- 
Glauber de Oliveira Costa
Red Hat Inc.
"Free as in Freedom"

--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="signal.patch"

commit ff9d841995b6055b74017306f30485c2b4a9ea70
Author: Glauber de Oliveira Costa <gcosta@redhat.com>
Date:   Fri Mar 23 07:13:38 2007 -0300

    [PATCH] Fix x86_64 compilation with DEBUG_SIG on
    
    Setting the DEBUG_SIG flag breaks compilation due to a wrong
    struct access. Aditionally, it raises two warnings. This is one
    patch to fix them all.
    
    Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>

diff --git a/arch/x86_64/kernel/signal.c b/arch/x86_64/kernel/signal.c
index 49ec324..c819625 100644
--- a/arch/x86_64/kernel/signal.c
+++ b/arch/x86_64/kernel/signal.c
@@ -141,7 +141,7 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 		goto badframe;
 
 #ifdef DEBUG_SIG
-	printk("%d sigreturn rip:%lx rsp:%lx frame:%p rax:%lx\n",current->pid,regs.rip,regs.rsp,frame,eax);
+	printk("%d sigreturn rip:%lx rsp:%lx frame:%p rax:%lx\n",current->pid,regs->rip,regs->rsp,frame,eax);
 #endif
 
 	if (do_sigaltstack(&frame->uc.uc_stack, NULL, regs->rsp) == -EFAULT)
@@ -301,7 +301,7 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
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
 	       

--ZPt4rx8FFjLCG7dd--
