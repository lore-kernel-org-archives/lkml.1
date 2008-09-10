Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYIJOVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYIJOVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYIJOVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:21:33 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:49623 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYIJOVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:21:32 -0400
Message-ID: <48C7D6FB.3050207@linux.vnet.ibm.com>
Date: Wed, 10 Sep 2008 16:17:31 +0200
From: Pierre Morel <pmorel@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, oleg@tv-sign.ru, roland@redhat.com,
       heicars2@linux.vnet.ibm.com, sameske@linux.vnet.ibm.com,
       schwidefsky@de.ibm.com, mingo@elte.hu, gregkh@suse.de,
       user-mode-linux-devel@lists.sourceforge.net, dave@linux.vnet.ibm.com,
       clg@fr.ibm.com, dlezcano@fr.ibm.com,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/1] system call notification with self_ptrace
References: <48C51439.7000706@linux.vnet.ibm.com> <20080908170427.c8bf38f5.akpm@linux-foundation.org>
In-Reply-To: <20080908170427.c8bf38f5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Andrew Morton wrote:
> On Mon, 08 Sep 2008 14:02:01 +0200
> Pierre Morel <pmorel@linux.vnet.ibm.com> wrote:
>
>   
>> Subject: [PATCH] system call notification with self_ptrace
>>
>> From: Pierre Morel <pmorel@fr.ibm.com>
>>
>>
>> PTRACE SELF
>>
>> This patch adds a new functionality to ptrace: system call notification to
>> the current process.
>> When a process requests self ptrace, with the new request PTRACE_SELF_ON:
>>
>>  1.  the next system call performed by the process will not be executed
>>  2.  self ptrace will be disabled for the process
>>  3.  a SIGSYS signal will be sent to the process.
>>
>> With an appropriate SIGSYS signal handler, the process can access its own
>> data structures to
>>
>>  1.  get the system call number from the siginfo structure
>>  2.  get the system call arguments from the stack
>>  3.  instrument the system call with other system calls
>>  4.  emulate the system call with other system calls
>>  5.  change the arguments of the system call
>>  6.  perform the system call for good
>>  7.  change the return value of the system call
>>  8.  request self ptrace again before returning.
>>
>> The new request PTRACE_SELF_OFF disables self ptrace.
>>
>>     
>
> It sounds like it might be useful.
>   
Thanks, yes I am sure it might.
> Are there any userspace tools available with which people can utilise
> this new functionality?  Or plans to release them?
>   
Yes, we plan to release a tool to trace an application soon.
>   
>> arch/s390/kernel/ptrace.c     |   16 ++++++++++++++++
>> arch/s390/kernel/signal.c     |    5 +++++
>> arch/x86/kernel/ptrace.c      |   29 +++++++++++++++++++++++++++++
>> arch/x86/kernel/signal_32.c   |    5 +++++
>> arch/x86/kernel/signal_64.c   |    5 +++++
>>     
>
> Maintainers of the other 30-odd architectures would appreciate a test
> application which they can use to develop and test their ports, please.
>   
Yes, of course I have one for x86 and one for s390.
I am cleaning them to make them available.
> Michael Kerrisk will no doubt be looking for manpage assistance. 
> Please cc him on this material.
>   
OK, I will prepare this.
> It would be good to get suitable testcases integrated into LTP (if LTP
> has ptrace tests).
>   
Yes, I will prepare this too.
> The patch title uses the term "self_ptrace", but the patch itself uses
> the term "ptrace_self".  Let's get it consistent everywhere.
>   
Right.  It should be self_ptrace.
> The patch adds a
>
> +	u64	instrumentation;
>
> to the task_struct but no explanation is provided as to why this was
> added, why it is a 64-bit field, what its locking rules are, etc. 
> Please fix this.
>   

I used to steal one bit in the ptrace bit-field of the task_struct but 
Oleg pointed out that the ptrace bit-field is used in a lot of places 
without any bit mask, so I chose another way to remember that I (the 
thread) am instrumenting myself.

Alternatively, I could also use the ptrace bit-field and modify every 
reference to use a mask for any test, set or reset of the bit-field.

I provision a 64 bit wide bit-field for future extensions of the 
instrumentation.  I could of course use a smaller bit-field as only 1 
bit is really useful for now. I used 64 bit to be memory aligned with 
most of the architectures.

There is no lock for the instrumentation bit-field because it is used 
for self tracing only, and only current ever accesses the flag.


-- 
=============
Pierre Morel
RTOS and Embedded Linux

