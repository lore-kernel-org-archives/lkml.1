Return-Path: <linux-kernel-owner+w=401wt.eu-S1754048AbXJBQpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbXJBQpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 12:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbXJBQpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 12:45:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbXJBQpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 12:45:04 -0400
Message-ID: <4702758A.20205@redhat.com>
Date: Tue, 02 Oct 2007 12:44:58 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: William Cattey <wdc@MIT.EDU>
CC: Andi Kleen <andi@firstfloor.org>, Chuck Anderson <cra@WPI.EDU>,
       linux-kernel@vger.kernel.org
Subject: Re: vm86.c audit_syscall_exit() call trashes registers
References: <20070814183119.GC17694@angus.ind.WPI.EDU> <p73r6m5n90l.fsf@bingen.suse.de> <78642229-39DD-4956-9385-5A3F960BFEEF@mit.edu> <20070814212858.GB23308@one.firstfloor.org> <07759638-DE7C-4341-A642-D611A897614F@MIT.EDU> <20070814214622.GE23308@one.firstfloor.org> <6655DD8B-D9C6-495D-9E22-2FDF6B375C9D@MIT.EDU> <20070814221927.GH23308@one.firstfloor.org> <9D5ACA40-5F33-4F49-8255-D51F554889E7@MIT.EDU>
In-Reply-To: <9D5ACA40-5F33-4F49-8255-D51F554889E7@MIT.EDU>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2007 07:38 PM, William Cattey wrote:
> 
> I'd feel a lot more confident we were on the right track if I could just
> correctly patch Fitzhardinge's cleanup into the test setup I have now.
> 

I think you need to zero both registers if you're using 2.6.16, and force
%eax as the source so it doesn't choose %ebp?

--- a/arch/i386/kernel/vm86.c
+++ b/arch/i386/kernel/vm86.c
@@ -306,19 +334,19 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
 	tsk->thread.screen_bitmap = info->screen_bitmap;
 	if (info->flags & VM86_SCREEN_BITMAP)
 		mark_screen_rdonly(tsk->mm);
-	__asm__ __volatile__("xorl %eax,%eax; movl %eax,%fs; movl %eax,%gs\n\t");
-	__asm__ __volatile__("movl %%eax, %0\n" :"=r"(eax));
 
 	/*call audit_syscall_exit since we do not exit via the normal paths */
 	if (unlikely(current->audit_context))
-		audit_syscall_exit(AUDITSC_RESULT(eax), eax);
+		audit_syscall_exit(AUDITSC_RESULT(0), 0);
 
 	__asm__ __volatile__(
 		"movl %0,%%esp\n\t"
 		"movl %1,%%ebp\n\t"
+		"mov  %2, %%fs\n\t"
+		"mov  %2, %%gs\n\t"
 		"jmp resume_userspace"
 		: /* no outputs */
-		:"r" (&info->regs), "r" (task_thread_info(tsk)));
+		:"r" (&info->regs), "r" (task_thread_info(tsk)), "a" (0));
 	/* we never return here */
 }
 
