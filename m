Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650Ab0AOODh (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 09:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756290Ab0AOODg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 09:03:36 -0500
Received: from mail.windriver.com ([147.11.1.11]:60758 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab0AOODf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 09:03:35 -0500
Message-ID: <4B50759C.30409@windriver.com>
Date: Fri, 15 Jan 2010 08:03:08 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        mingo@elte.hu
Subject: Re: [PATCH 39/40] debug_core: Turn off tracing while in the debugger
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com> <1263481176-1897-40-git-send-email-jason.wessel@windriver.com> <1263514210.28171.3963.camel@gandalf.stny.rr.com>
In-Reply-To: <1263514210.28171.3963.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2010 14:03:09.0718 (UTC) FILETIME=[7808DB60:01CA95EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Thu, 2010-01-14 at 08:59 -0600, Jason Wessel wrote:
>   
>> The kernel debugger should turn off kernel tracing any time the
>> debugger is active and restore it on resume.
>>
>> CC: Steven Rostedt <rostedt@goodmis.org>
>> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>> ---
>>  kernel/debug/debug_core.c |    8 ++++++++
>>  1 files changed, 8 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
>> index 6ca3f7c..464aa65 100644
>> --- a/kernel/debug/debug_core.c
>> +++ b/kernel/debug/debug_core.c
>> @@ -474,6 +474,7 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs)
>>  	int sstep_tries = 100;
>>  	int error;
>>  	int i, cpu;
>> +	int trace_on = 0;
>>  acquirelock:
>>  	/*
>>  	 * Interrupts will be restored by the 'trap return' code, except when
>> @@ -518,6 +519,8 @@ return_normal:
>>  			 */
>>  			if (arch_kgdb_ops.correct_hw_break)
>>  				arch_kgdb_ops.correct_hw_break();
>> +			if (trace_on)
>> +				tracing_on();
>>  			atomic_set(&cpu_in_kgdb[cpu], 0);
>>  			touch_softlockup_watchdog_sync();
>>  			clocksource_touch_watchdog();
>> @@ -592,6 +595,9 @@ return_normal:
>>  	kgdb_single_step = 0;
>>  	kgdb_contthread = current;
>>  	exception_level = 0;
>> +	trace_on = tracing_is_on();
>> +	if (trace_on)
>> +		tracing_off();
>>     
>
> Hmm, what happens if tracing gets turned on by something else? Will it
> break this code? If so, we may need to do something different here.
>   

What else do you imagine would turn on tracing, or what might break?

At the point in time that this is called all the slave CPUs are rounded
up, and a single CPU remains executing as the "master" cpu inside the
debug core.  There are two exit points from this context depending on
the state of how you are resuming system, where we turn tracing back on,
if it was on prior to entry to the kernel debug context.

I debated about using an atomic_inc and also allowing the slave_cpu
entry to turn it off, because that actually happens first, and you can
actually see that in the function tracer log up to the point that the
master turns off tracing.

The approach employed by this patch seemed the most simplistic, and
definitely stopped the trace log, while the debugger was active.  This
particular problem with having tracing active while in the kernel debug
context was not even discovered until kdb ftdump was implemented.  We
don't really want to do much of anything except keep minimal HW alive
while in the kernel debugger context.  I am open to suggestions if you
think we need something more here.  I can also hard code a test if you
believe there is a condition that requires some investigation.

Thanks,
Jason.
