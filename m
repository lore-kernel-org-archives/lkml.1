Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbYH1MH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbYH1MH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 08:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYH1MHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 08:07:14 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:39580 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbYH1MHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 08:07:12 -0400
Message-ID: <48B6942E.2050607@linux.vnet.ibm.com>
Date: Thu, 28 Aug 2008 14:03:58 +0200
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
References: <48B26083.8080506@linux.vnet.ibm.com> <20080825165403.GA604@tv-sign.ru> <48B40D5F.3020705@linux.vnet.ibm.com> <20080826162750.GA406@tv-sign.ru> <48B5658A.5000101@linux.vnet.ibm.com> <20080827162455.GA132@tv-sign.ru>
In-Reply-To: <20080827162455.GA132@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 08/27, Pierre Morel wrote:
>   
>> Oleg Nesterov wrote:
>>
>>     
>>> On s390 the patch changes handle_signal(), this is not clear to me too.
>>>
>>>       
>> The patch clears the trace flags before delivering the signal so
>> that the signal handler can use system call without bouncing again.
>>     
>
> Yes I see. But the signal handler for SIGSYS can fisrt do
> sys_ptrace(PTRACE_SELF_OFF) (which is filtered out), and then use any
> other syscall.
>   
It is right but brings the overhead of a syscall.
> With this patch PT_SELF is cleared on any signal. This doesn't look
> right. Let's suppose that another signal comes in parallel with SIGSYS.
> It is very possible that the handler for that another signal will be
> called first, this handler can do some syscall which will be "missed".
>   

If the tracing application catches all signals before delivering
them to the instrumented original handler there is no problem,
the catching code can reset PTRACE_SELF_ON before calling the 
instrumented application's original handler.
The instrumented code will then bounce as expected.

I see this more like a security, the "bouncing" feature
is only enabled until next syscall or signal, never more.

This instrumentation method allows with this little patch to do
all the syscall and signal instrumentation in userland and inside the
address space of the instrumented application.

I expect we will  have a big improvement of instrumenting tools like
 - debugger, tracing tool,
 - virtualization applications like UML
 - High availability: checkpoint and restart, record and replay.
because of the reduction of IPC and task switch overhead.

Pierre

-- 
=============
Pierre Morel
RTOS and Embedded Linux

