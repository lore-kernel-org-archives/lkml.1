Return-Path: <linux-kernel-owner+w=401wt.eu-S1945905AbXBUXDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945905AbXBUXDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbXBUXDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:03:37 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2637 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbXBUXDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:03:36 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 21 Feb 2007 15:03:33 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 08/13] syslets: x86, add move_user_context() method
In-Reply-To: <20070221211537.GH7579@elte.hu>
Message-ID: <Pine.LNX.4.64.0702211428400.16904@alien.or.mcafeemobile.com>
References: <20070221211537.GH7579@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007, Ingo Molnar wrote:

> From: Ingo Molnar <mingo@elte.hu>
> 
> add the move_user_context() method to move the user-space
> context of one kernel thread to another kernel thread.
> User-space might notice the changed TID, but execution,
> stack and register contents (general purpose and FPU) are
> still the same.

Also signal handling should/must be maintained, on top of TID.
You don't want the user to be presented with a different signal handling 
after an sys_async_exec call.




> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  arch/i386/kernel/process.c |   21 +++++++++++++++++++++
>  include/asm-i386/system.h  |    7 +++++++
>  2 files changed, 28 insertions(+)
> 
> Index: linux/arch/i386/kernel/process.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/process.c
> +++ linux/arch/i386/kernel/process.c
> @@ -820,6 +820,27 @@ unsigned long get_wchan(struct task_stru
>  }
>  
>  /*
> + * Move user-space context from one kernel thread to another.
> + * This includes registers and FPU state. Callers must make
> + * sure that neither task is running user context at the moment:
> + */
> +void
> +move_user_context(struct task_struct *new_task, struct task_struct *old_task)
> +{
> +	struct pt_regs *old_regs = task_pt_regs(old_task);
> +	struct pt_regs *new_regs = task_pt_regs(new_task);
> +	union i387_union *tmp;
> +
> +	*new_regs = *old_regs;
> +	/*
> +	 * Flip around the FPU state too:
> +	 */
> +	tmp = new_task->thread.i387;
> +	new_task->thread.i387 = old_task->thread.i387;
> +	old_task->thread.i387 = tmp;
> +}

This is not going to work in this case (already posted twice in other 
emails):

---
Given TS_USEDFPU set (NTSK == new_task, OTSK == old_task), before 
move_user_context():

CPU  => FPUc
NTSK => FPUn
OTSK => FPUo

After move_user_context():

CPU  => FPUc
NTSK => FPUo
OTSK => FPUn

After the incoming __unlazy_fpu() in __switch_to():

CPU  => FPUc
NTSK => FPUo
OTSK => FPUc

After the first fault in NTSK:

CPU  => FPUo
NTSK => FPUo
OTSK => FPUc

So NTSK loads a non up2date FPUo, instead of the FPUc that was the "dirty" 
context to migrate (since TS_USEDFPU was set). I think you need an early 
__unlazy_fpu() in that case, that would turn the above into:

Before move_user_context():

CPU  => FPUc
NTSK => FPUn
OTSK => FPUo

After an early __unlazy_fpu() before FPU member swap:

CPU  => FPUc
NTSK => FPUn
OTSK => FPUc

After move_user_context():

CPU  => FPUc
NTSK => FPUc
OTSK => FPUn

After the first fault in NTSK:

CPU  => FPUc
NTSK => FPUc
OTSK => FPUn

So, NTSK (the return-to-userspace task) will get the correct FPUc after a 
fault. But the OTSK (now becoming service thread) will load FPUn after a 
fault, that is not what expected. You may need a copy in that case.
I think correct FPU context handling is not going to be as easy as 
swapping FPU pointers.



- Davide


