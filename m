Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbYH1N3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbYH1N3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 09:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbYH1N3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 09:29:23 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:59307 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYH1N3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 09:29:22 -0400
Message-ID: <48B6A71A.9010305@linux.vnet.ibm.com>
Date: Thu, 28 Aug 2008 15:24:42 +0200
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
References: <48B26083.8080506@linux.vnet.ibm.com> <20080825165403.GA604@tv-sign.ru> <48B40D5F.3020705@linux.vnet.ibm.com> <20080826162750.GA406@tv-sign.ru> <48B5658A.5000101@linux.vnet.ibm.com> <20080827162455.GA132@tv-sign.ru> <48B6942E.2050607@linux.vnet.ibm.com> <20080828123242.GA187@tv-sign.ru>
In-Reply-To: <20080828123242.GA187@tv-sign.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 08/28, Pierre Morel wrote:
>   
>> Oleg Nesterov wrote:
>>     
>>> On 08/27, Pierre Morel wrote:
>>>
>>>       
>>>> Oleg Nesterov wrote:
>>>>
>>>>
>>>>         
>>>>> On s390 the patch changes handle_signal(), this is not clear to me too.
>>>>>
>>>>>
>>>>>           
>>>> The patch clears the trace flags before delivering the signal so
>>>> that the signal handler can use system call without bouncing again.
>>>>
>>>>         
>>> Yes I see. But the signal handler for SIGSYS can fisrt do
>>> sys_ptrace(PTRACE_SELF_OFF) (which is filtered out), and then use any
>>> other syscall.
>>>
>>>       
>> It is right but brings the overhead of a syscall.
>>     
>
> Well, this overhead is very small compared to the signal delivery.
>   
May be, but very high compared to the operation to just
clear a flag in the task struct.
This operation must be done anyway.
>   
>>> With this patch PT_SELF is cleared on any signal. This doesn't look
>>> right. Let's suppose that another signal comes in parallel with SIGSYS.
>>> It is very possible that the handler for that another signal will be
>>> called first, this handler can do some syscall which will be "missed".
>>>
>>>       
>> If the tracing application catches all signals before delivering
>> them to the instrumented original handler there is no problem,
>> the catching code can reset PTRACE_SELF_ON before calling the
>> instrumented application's original handler.
>> The instrumented code will then bounce as expected.
>>     
>
> Sorry, can't understand the text above :(
>
> OK, let's suppose the application does
>
> 	ptrace(PTRACE_SELF_ON);
> 	...
> 	syscall();
>
> This "syscall()" above should trigger the handler for SIGSYS.
> But what if another signal (with handler) comes in between?
> In that case handle_signal() clears PT_SELF/TIF_SYSCALL_TRACE,
> this syscall() (or any other) doesn't send SIGSYS.
>   
ok, please read "set PTRACE_SELF_ON"
where I wrote "reset PTRACE_SELF_ON" above.

Now, suppose the application does the following:

sigsys_handler(sig)
{
....
ptrace(PTRACE_SELF_ON);
}

sigx_handler(sig)
{
....
ptrace(PTRACE_SELF_ON);
if (sig_has_a_handler)
call_the_handler()
ptrace(PTRACE_SELF_OFF);
...
ptrace(PTRACE_SELF_ON);
}

main(){
...
signal(SIGSYS, sigsys_handler);
for(i=0; i<MAXSIGS; i++)
signal(i, sigx_handler);
ptrace(PTRACE_SELF_ON);
jump_into_instrumented_code;
...
}

If the instrumented code ever does a call to
signal(2), the call will be received by sig_sys() handler,
where the call the application signal handler can be performed with
PTRACE_SELF_ON.
This implies appropriate instrumentation of signal(2) and sigaction(2).

Pierre

-- 
=============
Pierre Morel
RTOS and Embedded Linux

