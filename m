Return-Path: <linux-kernel-owner+w=401wt.eu-S934700AbXHNTJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934700AbXHNTJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933251AbXHNTIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:08:45 -0400
Received: from MAIL1.WPI.EDU ([130.215.36.91]:44488 "EHLO mail1.wpi.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933430AbXHNTIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:08:43 -0400
X-Greylist: delayed 2238 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Aug 2007 15:08:43 EDT
Date: Tue, 14 Aug 2007 14:31:19 -0400
From: Chuck Anderson <cra@WPI.EDU>
To: linux-kernel@vger.kernel.org
Cc: wdc@mit.edu
Subject: vm86.c audit_syscall_exit() call trashes registers
Message-ID: <20070814183119.GC17694@angus.ind.WPI.EDU>
Reply-To: cra@WPI.EDU, wdc@mit.edu, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please Cc: any replies, as we are not subscribed to linux-kernel.  
Thanks.

Somewhere around 2.6.16.12 a call to audit_syscall_exit was added to 
vm86.c:

 static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk)
 {
        struct tss_struct *tss;
+       long eax;
 /*
  * make sure the vm86() system call doesn't try to do anything silly
  */
@@ -305,13 +307,19 @@ static void do_sys_vm86(struct kernel_vm
        tsk->thread.screen_bitmap = info->screen_bitmap;
        if (info->flags & VM86_SCREEN_BITMAP)
                mark_screen_rdonly(tsk->mm);
+       __asm__ __volatile__("xorl %eax,%eax; movl %eax,%fs; movl %eax,%gs\n\t");
+       __asm__ __volatile__("movl %%eax, %0\n" :"=r"(eax));
+
+       /*call audit_syscall_exit since we do not exit via the normal paths */
+       if (unlikely(current->audit_context))
+               audit_syscall_exit(current, AUDITSC_RESULT(eax), eax);
+
        __asm__ __volatile__(
-               "xorl %%eax,%%eax; movl %%eax,%%fs; movl %%eax,%%gs\n\t"
                "movl %0,%%esp\n\t"
                "movl %1,%%ebp\n\t"
                "jmp resume_userspace"
                : /* no outputs */
-               :"r" (&info->regs), "r" (task_thread_info(tsk)) : "ax");
+               :"r" (&info->regs), "r" (task_thread_info(tsk)));
        /* we never return here */
 }
 
This appears to have caused intermittent data corruption of the 
results of the vm86() call that the X server uses to get EDID data 
from the monitor via the VESA BIOS.  After removing the 
audit_syscall_exit() call, the problems mentioned in these bugzillas 
disappear:

Fetch of EDID 128 byte buffer by X server through vm86 INT 10 call is flaky.
http://bugzilla.kernel.org/show_bug.cgi?id=8633

RHEL 5 fails to get EDID data from monitor and sets low resolution
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=236416

If I'm reading correctly, it appears that the code above trashes the 
%fs and %gs registers, or otherwise doesn't leave them at zero before 
returning from the system call as the old code did.  Is this a correct 
analysis?  How should this be fixed?

Thanks.

-Chuck
