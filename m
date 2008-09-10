Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbYIJPRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbYIJPRX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 11:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYIJPRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 11:17:15 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:43901 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbYIJPRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 11:17:14 -0400
Message-ID: <48C7E3A9.3060602@linux.vnet.ibm.com>
Date: Wed, 10 Sep 2008 17:11:37 +0200
From: Pierre Morel <pmorel@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, gregkh@suse.de,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 1/1] system call notification with self_ptrace
References: <48C51439.7000706@linux.vnet.ibm.com> <20080909124302.GA139@tv-sign.ru>
In-Reply-To: <20080909124302.GA139@tv-sign.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Oleg Nesterov wrote:
> On 09/08, Pierre Morel wrote:
>   
>> --- linux-2.6.26.orig/arch/s390/kernel/signal.c
>> +++ linux-2.6.26/arch/s390/kernel/signal.c
>> @@ -409,6 +409,11 @@ handle_signal(unsigned long sig, struct 
>> 		spin_unlock_irq(&current->sighand->siglock);
>> 	}
>>
>> +	if (current->instrumentation) {
>> +		clear_thread_flag(TIF_SYSCALL_TRACE);
>> +		current->instrumentation &= ~PTS_SELF;
>> +	}
>> +
>> 	return ret;
>> }
>>     
>
> I still think this patch shouldn't change handle_signal().
>
> Once again. The signal handler for SIGSYS can first do
> sys_ptrace(PTRACE_SELF_OFF) (which is filtered out), and then use any
> other syscall, so this change is not needed, afaics.
>   
Yes it can but what if the application forget to do it?
It is a security so that the application do not bounce for ever.
> The overhead of the additional PTRACE_SELF_OFF syscall is very small,
> especially compared to signal delivery. I don't think this functionality
> will be widely used, but this change adds the unconditional overhead
> to handle_signal().
>
> Btw, the check above looks wrong, shouldn't it be
>
> 	if (current->instrumentation & PTS_SELF)
>
> ?
>   
Yes you are right, in fact I do not need two flags, I will remove
the PTS_INSTRUMENTED flag.
> And. According to the prior discussion, this requires to hook every
> signal handler in user space, otherwise we can miss syscall. But every
> hook should start with PTRACE_SELF_ON, so I can't see any gain.
>
>   
>> +#define PTS_INSTRUMENTED	0x00000001
>> +#define PTS_SELF	0x00000002
>>     
>
> I don't really understand why do we need 2 flags, see also below,
>   
Yes, I remove PTS_INSTRUMENTED, a bad idea.
>   
>> --- linux-2.6.26.orig/kernel/ptrace.c
>> +++ linux-2.6.26/kernel/ptrace.c
>> @@ -543,6 +543,38 @@ asmlinkage long sys_ptrace(long request,
>> 	 * This lock_kernel fixes a subtle race with suid exec
>> 	 */
>> 	lock_kernel();
>> +	if (request == PTRACE_SELF_ON) {
>> +		task_lock(current);
>> +		if (current->ptrace) {
>> +			task_unlock(current);
>> +			ret = -EPERM;
>> +			goto out;
>> +		}
>> +		set_thread_flag(TIF_SYSCALL_TRACE);
>> +		current->instrumentation |= PTS_INSTRUMENTED|PTS_SELF;
>> +		task_unlock(current);
>> +		ret = 0;
>> +		goto out;
>>     
>
> The code looks strange. How about
>
> 	if (request == PTRACE_SELF_ON) {
> 		ret = -EPERM;
> 		task_lock(current);
> 		if (!current->ptrace) {
> 			set_thread_flag(TIF_SYSCALL_TRACE);
> 			current->instrumentation |= PTS_INSTRUMENTED|PTS_SELF;
> 			ret = 0;
> 		}
> 		task_unlock(current);
> 		goto out;
> 	}
>
> ?
>
> I don't understand how task_lock() can help. This code runs under
> lock_kernel(), and without this lock the code is racy anyway.
>   

I use task_lock to protect the current->ptrace bit-field which can be 
accessed by another thread, like the one you pointed out previously.
I agree it is not necessary with lock_kernel().
I will put the code before the lock_kernel() to be more efficient.
>   
>> +	}
>> +	if (request == PTRACE_SELF_OFF) {
>> +		task_lock(current);
>> +		if (current->ptrace) {
>> +			task_unlock(current);
>> +			ret = -EPERM;
>> +			goto out;
>> +		}
>> +		clear_thread_flag(TIF_SYSCALL_TRACE);
>> +		current->instrumentation &= ~PTS_SELF;
>>     
>
> So. PTRACE_SELF_OFF doesn't clear PTS_INSTRUMENTED? How can the task
> reset ->instrumentation ?
>   
You are right again, I will remove the PTS_INSTRUMENTED flag.
>   
>> +	if (current->instrumentation) {
>> +		ret = -EPERM;
>> +		goto out;
>> +	}
>>     
>
> So, PTRACE_SELF_XXX disables the "normal" ptrace. Not sure this is good.
>   
I think that having two tracing system one over the other may be
quite difficult to handle.

Pierre
> Oleg.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   


-- 
=============
Pierre Morel
RTOS and Embedded Linux

