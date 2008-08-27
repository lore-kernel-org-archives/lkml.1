Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYH0Og5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYH0Og5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbYH0Ogf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 10:36:35 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:48363 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbYH0Oge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 10:36:34 -0400
Message-ID: <48B5658A.5000101@linux.vnet.ibm.com>
Date: Wed, 27 Aug 2008 16:32:42 +0200
From: Pierre Morel <pmorel@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC] [Patch 1/1] [Self Ptrace] System call notification with
 self_ptrace
References: <48B26083.8080506@linux.vnet.ibm.com> <20080825165403.GA604@tv-sign.ru> <48B40D5F.3020705@linux.vnet.ibm.com> <20080826162750.GA406@tv-sign.ru>
In-Reply-To: <20080826162750.GA406@tv-sign.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 08/26, Pierre Morel wrote:
>   
>> Oleg Nesterov wrote:
>>     
>>> We have some "->ptrace != 0" checks which can misunderstand this. Just
>>> for example, suppose that the task does sys_ptrace(PTRACE_SELF_ON) and
>>> then its parent dies. I guess in that case forget_original_parent()
>>> will hit BUG_ON(p->ptrace), no?
>>>
>>>
>>>       
>> Yes you are right, I will take care of those cases.
>> I have the choice between:
>>
>> - tracking all references to the ptrace flags and add a test for PT_SELF
>> or a mask.
>>
>> - add a dedicated task_struct entry to hold the PT_SELF flag
>>     
>
> Well, given that PT_SELF is exotic, neither choice looks very good, imho.
> But I am not expert and maintainer is cc'ed ;)
>
> I don't understand why this patch changes the x86's sys_sigaction().
>   
Me neither, it should be only in handle_signal(), sorry it is a bug.
I am reworking the patch to take your remarks and the remarks
of Dave into account.
> On s390 the patch changes handle_signal(), this is not clear to me too.
>   
The patch clears the trace flags before delivering the signal so
that the signal handler can use system call without bouncing again.
> do_syscall_trace() filters out __NR_ptrace, this afaics means that the
> handler for SIGSYS can happily call sys_ptrace(PTRACE_SELF_OFF) and
> clear PT_SELF/TIF_SYSCALL_TRACE.
>   
Yes.
The situation is the following: the ptrace_self implementation is not
compatible with the standard ptrace.
In fact it is a new tracing system using the infrastructure of
ptrace because it exist but it could leave completely separate from
ptrace.
> I must admit, personally I don't think the whole idea is good...
> And what if the user of PT_SELF is ptraced? The usage of TIF_SYSCALL_TRACE
> doesn't look "safe" in that case.
>   
Yes, I will had exclusive access to the tracing so that one can not
use both ptrace and self_ptrace for the same process.
>
> Isn't it possible to implement this behaviour in the user space? If the
> task needs the PT_SELF behaviour, it can fork another process which will
> do PTRACE_ATTACH and then send the notifications to the task. We can use
> signals or something else.
>   
In this case we would go back to standard ptrace behaviour.
The goal of the patch is to avoid the overhead of task switching
and IPC when instrumenting the process.
> Oleg.
>
>   
thanks,

Pierre

-- 
=============
Pierre Morel
RTOS and Embedded Linux

