Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZELOUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZELOUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbZELOUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:20:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34874 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbZELOUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:20:24 -0400
Message-ID: <4A0985BE.7000403@redhat.com>
Date: Tue, 12 May 2009 10:20:46 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, systemtap@sources.redhat.com,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jan Blunck <jblunck@suse.de>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -rc] [BUGFIX] x86: fix kernel_trap_sp()
References: <20090511210300.17332.67549.stgit@localhost.localdomain> <alpine.LFD.2.01.0905111512240.3586@localhost.localdomain> <20090512112300.GL7601@sgi.com>
In-Reply-To: <20090512112300.GL7601@sgi.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:
> On Mon, May 11, 2009 at 03:24:07PM -0700, Linus Torvalds wrote:
>>
>> On Mon, 11 May 2009, Masami Hiramatsu wrote:
>>> Use &regs->sp instead of regs for getting the top of stack in kernel mode.
>>> (on x86-64, regs->sp always points the top of stack)
>> Ack. 
>>
>> That said, we have only _one_ use of this "kernel_trap_sp()" in the whole 
>> kernel, and that use is actually fairly odd too, in that it does it 
>> _before_ checking that it's in kernel mode.
>>
>> Admittedly it will then only _use_ the value after it has checked that 
>> things are in kernel mode, but it all boils down to "ok, that's pretty 
>> odd".
>>
>> So how about fixing that, and also fixing the naming of the function. Call 
>> it "kernel_stack_pointer()" to match its more widely used sibling function
>> "user_stack_pointer()".
>>
>> IOW, something like this?
>>
>> 		Linus
>>
>> ---
>>  arch/x86/include/asm/ptrace.h |    7 ++++---
>>  arch/x86/oprofile/backtrace.c |    2 +-
>>  2 files changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
>> index e304b66..624f133 100644
>> --- a/arch/x86/include/asm/ptrace.h
>> +++ b/arch/x86/include/asm/ptrace.h
>> @@ -187,14 +187,15 @@ static inline int v8086_mode(struct pt_regs *regs)
>>  
>>  /*
>>   * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
>> - * when it traps.  So regs will be the current sp.
>> + * when it traps.  The previous stack will be directly underneath the saved
>> + * registers, and 'sp/ss' won't even have been saved. Thus the '&regs->sp'.
>>   *
>>   * This is valid only for kernel mode traps.
>>   */
>> -static inline unsigned long kernel_trap_sp(struct pt_regs *regs)
>> +static inline unsigned long kernel_stack_pointer(struct pt_regs *regs)
> 
> Why not have it return an unsigned long *?
>>  {
>>  #ifdef CONFIG_X86_32
>> -	return (unsigned long)regs;
>> +	return (unsigned long)(&regs->sp);
>>  #else
>>  	return regs->sp;

Perhaps, you might forget that this line needs a cast :-).

Anyway, IMHO, it does not come from coding, but meaning.
kernel/user_stack_pointer() just return
"the value of stack pointer register", not a "stack pointer".

Thank you,

>>  #endif
>> diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
>> index 04df67f..044897b 100644
>> --- a/arch/x86/oprofile/backtrace.c
>> +++ b/arch/x86/oprofile/backtrace.c
>> @@ -76,9 +76,9 @@ void
>>  x86_backtrace(struct pt_regs * const regs, unsigned int depth)
>>  {
>>  	struct frame_head *head = (struct frame_head *)frame_pointer(regs);
>> -	unsigned long stack = kernel_trap_sp(regs);
>>  
>>  	if (!user_mode_vm(regs)) {
>> +		unsigned long stack = kernel_stack_pointer(regs);
> 
> Make this an unsigned long *?
> 
>>  		if (depth)
>>  			dump_trace(NULL, regs, (unsigned long *)stack, 0,
> 
> Then get rid of the cast?
> 
> Robin

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

