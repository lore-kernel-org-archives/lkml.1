Return-Path: <linux-kernel-owner+w=401wt.eu-S1756697AbXJAWbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697AbXJAWbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbXJAWb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:31:27 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:36951 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbXJAWb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:31:26 -0400
In-Reply-To: <46FDEC1F.7080809@goop.org>
References: <20070814183119.GC17694@angus.ind.WPI.EDU> <p73r6m5n90l.fsf@bingen.suse.de> <78642229-39DD-4956-9385-5A3F960BFEEF@mit.edu> <20070814212858.GB23308@one.firstfloor.org> <07759638-DE7C-4341-A642-D611A897614F@MIT.EDU> <20070814214622.GE23308@one.firstfloor.org> <6655DD8B-D9C6-495D-9E22-2FDF6B375C9D@MIT.EDU> <20070814221927.GH23308@one.firstfloor.org> <9D5ACA40-5F33-4F49-8255-D51F554889E7@MIT.EDU> <46FDA325.8000602@goop.org> <7CB783C7-8EC7-4AA3-B825-B23595373229@MIT.EDU> <46FDEB6D.6000403@goop.org> <46FDEC1F.7080809@goop.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: multipart/mixed; boundary=Apple-Mail-6-369777975
Message-Id: <7CF81651-4B94-42AA-9FEF-790F4D08EE4F@MIT.EDU>
Cc: Andi Kleen <andi@firstfloor.org>, Chuck Anderson <cra@WPI.EDU>,
       linux-kernel@vger.kernel.org
From: William Cattey <wdc@MIT.EDU>
Subject: Re: vm86.c audit_syscall_exit() call trashes registers
Date: Mon, 1 Oct 2007 18:30:59 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Mailer: Apple Mail (2.752.3)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-6-369777975
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

Thanks very much for responding.

 From your two replies, I crafted the attached patch.
Alas, the EDID transfer comes up all zeros.
I see two possible causes of this behavior:

1. I misunderstood how you intended the file to be modified.
2. The fix for my bug is NOT in correcting the audit call, but  
instead from some other fix, perhaps from the other aspect that you  
worked on.

I know that when I surrounded the audit_syscall_exit with #if 0 I got  
correct EDID fetches, so the most likely cause is #1, that I didn't  
correctly incorporate your understanding of correct operation of the  
call to audit_syscall_exit.

Here's my patch.  Where did I screw up?


--Apple-Mail-6-369777975
Content-Transfer-Encoding: 7bit
Content-Type: application/octet-stream;
	x-unix-mode=0666;
	name=linux-2.6-correct-vm86-audit-foonly.patch
Content-Disposition: attachment;
	filename=linux-2.6-correct-vm86-audit-foonly.patch

--- linux-2.6.18.i686/arch/i386/kernel/vm86.c.foonly	2007-10-01 16:40:35.000000000 -0400
+++ linux-2.6.18.i686/arch/i386/kernel/vm86.c	2007-10-01 16:27:50.000000000 -0400
@@ -318,12 +318,11 @@
 	tsk->thread.screen_bitmap = info->screen_bitmap;
 	if (info->flags & VM86_SCREEN_BITMAP)
 		mark_screen_rdonly(tsk->mm);
-	__asm__ __volatile__("xorl %eax,%eax; movl %eax,%fs; movl %eax,%gs\n\t");
-	__asm__ __volatile__("movl %%eax, %0\n" :"=r"(eax));
+	__asm__ __volatile__("mov %0, %%fs; mov %0, %%gs" : : "r" (0));
 
 	/*call audit_syscall_exit since we do not exit via the normal paths */
 	if (unlikely(current->audit_context))
-		audit_syscall_exit(AUDITSC_RESULT(eax), eax);
+		audit_syscall_exit(AUDITSC_RESULT(0), 0);
 
 	__asm__ __volatile__(
 		"movl %0,%%esp\n\t"

--Apple-Mail-6-369777975
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed


-Bill

----

William Cattey
Linux Platform Coordinator
MIT Information Services & Technology

N42-040M, 617-253-0140, wdc@mit.edu
http://web.mit.edu/wdc/www/


On Sep 29, 2007, at 2:09 AM, Jeremy Fitzhardinge wrote:

> Jeremy Fitzhardinge wrote:
>> @@ -306,19 +334,18 @@ static void do_sys_vm86(struct kernel_vm
>>         tsk->thread.screen_bitmap = info->screen_bitmap;
>>         if (info->flags & VM86_SCREEN_BITMAP)
>>                 mark_screen_rdonly(tsk->mm);
>>         __asm__ __volatile__("xorl %eax,%eax; movl %eax,%fs; movl % 
>> eax,%gs\n\t");
>>
>
> Oh, this line is also clearly bogus, since it clobbers %eax without
> telling the compiler.  The minimal change would be something like:
>
> 	asm volatile("mov %0, %%fs; mov %0, %%gs" : : "r" (0));
>
>
>     J


--Apple-Mail-6-369777975--
