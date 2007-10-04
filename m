Return-Path: <linux-kernel-owner+w=401wt.eu-S1762387AbXJDX7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762387AbXJDX7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759919AbXJDX7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:59:22 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65021 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759553AbXJDX7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:59:20 -0400
In-Reply-To: <4702758A.20205@redhat.com>
References: <20070814183119.GC17694@angus.ind.WPI.EDU> <p73r6m5n90l.fsf@bingen.suse.de> <78642229-39DD-4956-9385-5A3F960BFEEF@mit.edu> <20070814212858.GB23308@one.firstfloor.org> <07759638-DE7C-4341-A642-D611A897614F@MIT.EDU> <20070814214622.GE23308@one.firstfloor.org> <6655DD8B-D9C6-495D-9E22-2FDF6B375C9D@MIT.EDU> <20070814221927.GH23308@one.firstfloor.org> <9D5ACA40-5F33-4F49-8255-D51F554889E7@MIT.EDU> <4702758A.20205@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <42824DD7-AD58-4C2C-A15C-C88EBFAC2C56@MIT.EDU>
Cc: Andi Kleen <andi@firstfloor.org>, Chuck Anderson <cra@WPI.EDU>,
       linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Content-Transfer-Encoding: 7bit
From: William Cattey <wdc@MIT.EDU>
Subject: Re: vm86.c audit_syscall_exit() call trashes registers
Date: Thu, 4 Oct 2007 19:58:37 -0400
To: Chuck Ebbert <cebbert@redhat.com>
X-Mailer: Apple Mail (2.752.3)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks very much for thinking about this and providing a revised  
candidate patch.

Sadly, the effect of the patch is the same as the most recent  
candidate patch from Jeremy Fitzhardinge:  The EDID transfer still  
comes up all zeros.

This is very perplexing to me.  If I take the code that appears in  
2.6.18's vm86.c, and simply put #if 0 around the call to  
audit_syscall_exit I get good data.

If this is indeed a correct minimal correction to the  
audit_syscall_exit code, then perhaps there's some other condition  
being exercised.  I guess my next step is to take the whole pt_regs  
patch (commit 49d26b6eaa8e970c8cf6e299e6ccba2474191bf5) from  
kernel.org and see if that has a beneficial effect.

-Bill

----

William Cattey
Linux Platform Coordinator
MIT Information Services & Technology

N42-040M, 617-253-0140, wdc@mit.edu
http://web.mit.edu/wdc/www/


On Oct 2, 2007, at 12:44 PM, Chuck Ebbert wrote:

> On 09/25/2007 07:38 PM, William Cattey wrote:
>>
>> I'd feel a lot more confident we were on the right track if I  
>> could just
>> correctly patch Fitzhardinge's cleanup into the test setup I have  
>> now.
>>
>
> I think you need to zero both registers if you're using 2.6.16, and  
> force
> %eax as the source so it doesn't choose %ebp?
>
> --- a/arch/i386/kernel/vm86.c
> +++ b/arch/i386/kernel/vm86.c
> @@ -306,19 +334,19 @@ static void do_sys_vm86(struct  
> kernel_vm86_struct *info, struct task_struct *tsk
>  	tsk->thread.screen_bitmap = info->screen_bitmap;
>  	if (info->flags & VM86_SCREEN_BITMAP)
>  		mark_screen_rdonly(tsk->mm);
> -	__asm__ __volatile__("xorl %eax,%eax; movl %eax,%fs; movl %eax,%gs 
> \n\t");
> -	__asm__ __volatile__("movl %%eax, %0\n" :"=r"(eax));
>
>  	/*call audit_syscall_exit since we do not exit via the normal  
> paths */
>  	if (unlikely(current->audit_context))
> -		audit_syscall_exit(AUDITSC_RESULT(eax), eax);
> +		audit_syscall_exit(AUDITSC_RESULT(0), 0);
>
>  	__asm__ __volatile__(
>  		"movl %0,%%esp\n\t"
>  		"movl %1,%%ebp\n\t"
> +		"mov  %2, %%fs\n\t"
> +		"mov  %2, %%gs\n\t"
>  		"jmp resume_userspace"
>  		: /* no outputs */
> -		:"r" (&info->regs), "r" (task_thread_info(tsk)));
> +		:"r" (&info->regs), "r" (task_thread_info(tsk)), "a" (0));
>  	/* we never return here */
>  }
>

