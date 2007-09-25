Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbXIYXys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbXIYXys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 19:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbXIYXyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 19:54:40 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:58146 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbXIYXyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 19:54:38 -0400
X-Greylist: delayed 941 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Sep 2007 19:54:38 EDT
In-Reply-To: <20070814221927.GH23308@one.firstfloor.org>
References: <20070814183119.GC17694@angus.ind.WPI.EDU> <p73r6m5n90l.fsf@bingen.suse.de> <78642229-39DD-4956-9385-5A3F960BFEEF@mit.edu> <20070814212858.GB23308@one.firstfloor.org> <07759638-DE7C-4341-A642-D611A897614F@MIT.EDU> <20070814214622.GE23308@one.firstfloor.org> <6655DD8B-D9C6-495D-9E22-2FDF6B375C9D@MIT.EDU> <20070814221927.GH23308@one.firstfloor.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: multipart/mixed; boundary=Apple-Mail-5--144547901
Message-Id: <9D5ACA40-5F33-4F49-8255-D51F554889E7@MIT.EDU>
Cc: Chuck Anderson <cra@WPI.EDU>, linux-kernel@vger.kernel.org
From: William Cattey <wdc@MIT.EDU>
Subject: Re: vm86.c audit_syscall_exit() call trashes registers
Date: Tue, 25 Sep 2007 19:38:53 -0400
To: Andi Kleen <andi@firstfloor.org>
X-Mailer: Apple Mail (2.752.3)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-5--144547901
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Andi,

Sorry to have taken so long to take another step with this problem.   
Once my customers had a work-around, other priorities crowded out  
this project.  Today Chuck and I did a little more work.  We'd heard  
that a more recent kernel alleged to fix this stuff.  Doing some  
digging, we came across this:

(http://www.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.20)

commit 49d26b6eaa8e970c8cf6e299e6ccba2474191bf5
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:	Thu Dec 7 02:14:03 2006 +0100

     [PATCH] i386: Update sys_vm86 to cope with changed pt_regs and % 
gs usage

     sys_vm86 uses a struct kernel_vm86_regs, which is identical to  
pt_regs, but
     adds an extra space for all the segment registers.	Previously  
this structure
     was completely independent, so changes in pt_regs had to be  
reflected in
     kernel_vm86_regs.  This changes just embeds pt_regs in  
kernel_vm86_regs, and
     makes the appropriate changes to vm86.c to deal with the new  
naming.

     Also, since %gs is dealt with differently in the kernel, this  
change adjusts
     vm86.c to reflect this.

     While making these changes, I also cleaned up some frankly  
bizarre code which
     was added when auditing was added to sys_vm86.

     Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
     Signed-off-by: Andi Kleen <ak@suse.de>
     Cc: Chuck Ebbert <76306.1226@compuserve.com>
     Cc: Zachary Amsden <zach@vmware.com>
     Cc: Jan Beulich <jbeulich@novell.com>
     Cc: Andi Kleen <ak@suse.de>
     Cc: Al Viro <viro@zeniv.linux.org.uk>
     Cc: Jason Baron <jbaron@redhat.com>
     Cc: Chris Wright <chrisw@sous-sol.org>
     Signed-off-by: Andrew Morton <akpm@osdl.org>

Chuck and I took a stab at extracting what we thought was the  
relevant change to the audit_syscall_exit code, but we must have  
gotten it wrong.  The EDID transfer always comes up zeros with our  
extract of  Fitzhardinge's patch.


--Apple-Mail-5--144547901
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name=patch-2.6.20-vm86-audit-syscall-exit.patch
Content-Disposition: attachment;
	filename=patch-2.6.20-vm86-audit-syscall-exit.patch

diff --git a/arch/i386/kernel/vm86.c b/arch/i386/kernel/vm86.c
--- a/arch/i386/kernel/vm86.c
+++ b/arch/i386/kernel/vm86.c
@@ -306,19 +334,18 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
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
 		"jmp resume_userspace"
 		: /* no outputs */
-		:"r" (&info->regs), "r" (task_thread_info(tsk)));
+		:"r" (&info->regs), "r" (task_thread_info(tsk)), "r" (0));
 	/* we never return here */
 }
 

--Apple-Mail-5--144547901
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed


At this point Chuck and I are trying to decide what will get us the  
best testing with the least effort.  (We keep planning to test with a  
stock kernel, but last time that was on our TODO list, the project  
languished for a month.)

Do you have a specific stock kernel revision to recommend we try on  
our test system currently running Red Hat's 2.6.18?  Are we right to  
presume it would be 2.6.18-0 to demonstrate failure and 2.6.20.0 to  
attempt to demonstrate success?

Are you the Andi Kleen who signed off on Fitzhardinge's patch, and if  
so do you have some insight for Chuck and I about what pieces are  
required to test and see if the bug really got fixed with his cleanup?

I'd feel a lot more confident we were on the right track if I could  
just correctly patch Fitzhardinge's cleanup into the test setup I  
have now.

-Bill

----

William Cattey
Linux Platform Coordinator
MIT Information Services & Technology

N42-040M, 617-253-0140, wdc@mit.edu
http://web.mit.edu/wdc/www/


On Aug 14, 2007, at 6:19 PM, Andi Kleen wrote:

> On Tue, Aug 14, 2007 at 06:14:40PM -0400, William Cattey wrote:
>> In fact, I had begun the process of assuring myself that I could
>> indeed take a main line kernel, and install it in place of a Red Hat
>> Kernel.
>
> Should normally work. Sometimes there are incompatibilities
> with udev -- it is safest to just compile in the drivers you
> need to avoid that -- but likely it would work even without
> that on a modern distro.
>
>> Shall I check back with you after we've re-run the test after putting
>> the stock kernel on the machine?  It will be a couple weeks because
>> they're moving my office on Thursday, I'm away on vacation the
>> following week, and I'm still unsure of the procedure to follow to
>> build a totally stock totally mainline kernel and put it into place
>> instead of what Red Hat has made.
>
> Better report to the list again in case others want to chime in.
> But you can put me into cc because I would need to merge
> any resulting patch anyways.
>
> -Andi


--Apple-Mail-5--144547901--
