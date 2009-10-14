Return-Path: <linux-kernel-owner+w=401wt.eu-S934883AbZJNQQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934883AbZJNQQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934863AbZJNQQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:16:53 -0400
Received: from claw.goop.org ([74.207.240.146]:48430 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934077AbZJNQQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:16:53 -0400
Message-ID: <4AD5F921.8080007@goop.org>
Date: Wed, 14 Oct 2009 09:15:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Avi Kivity <avi@redhat.com>,
       Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] sched: add notifier for process migration
References: <4ACFA4C5.4020607@goop.org> <1255125738.7439.17.camel@laptop> <4ACFBC98.4070701@goop.org> <1255158863.7866.25.camel@twins> <4AD04E50.7060001@redhat.com> <1255166662.7866.28.camel@twins> <4AD055B3.8070705@goop.org> <1255169528.7521.3.camel@laptop> <4AD4F02C.9060203@goop.org> <20091014070508.GI784@elte.hu>
In-Reply-To: <20091014070508.GI784@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/09 00:05, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> @@ -1981,6 +1989,12 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
>>  #endif
>>  		perf_swcounter_event(PERF_COUNT_SW_CPU_MIGRATIONS,
>>  				     1, 1, NULL, 0);
>> +
>> +		tmn.task = p;
>> +		tmn.from_cpu = old_cpu;
>> +		tmn.to_cpu = new_cpu;
>> +
>> +		atomic_notifier_call_chain(&task_migration_notifier, 0, &tmn);
>>     
> We already have one event notifier there - look at the 
> perf_swcounter_event() callback. Why add a second one for essentially 
> the same thing?
>
> We should only put a single callback there - a tracepoint defined via 
> TRACE_EVENT() - and any secondary users can register a callback to the 
> tracepoint itself.
>
> There's many similar places in the kernel - with notifier chains and 
> also with a need to get tracepoints there. The fastest (and most 
> consistent) solution is to add just a single event callback facility.
>   

My specific use case for this notifier is to provide a "you've been
migrated" counter to usermode via a fixmap page, as part of the work to
extend kernel/pvclock.c to implement vread for vsyscall use.  I probably
should have referred to that explicitly in the comment for the patch to
give a concrete motivation and rationale.

This means that on applicable systems - ie, running virtualized under
Xen or KVM - this will be something that will be installed early in boot
and called for the entire uptime of the system.  Since we don't want a
strong permanent coupling between that particular piece of
arch-independent scheduler code and an arch-specific piece of
functionality, it seemed like a notifier is a good fit.

(Note that this callback is generally useful on all systems for the
vgetcpu vsyscall; it would allow us to use the "tcache" parameter to
provide results which are both fast and 100% accurate, by deferring the
use of expensive lsl/rdtscp instructions until it *knows* the cpu has
changed.)

I tend to view the intent of tracepoints as more a diagnostic tool which
are inserted and removed dynamically as a way of instrumenting a running
system, and the tracepoints themselves don't have side-effects required
for correct running of the system.

More handwavingly, I see the semantics of a tracepoint is basically a
flag-fall showing that a particular piece of kernel code has been
called, whereas notifications are that a particular event has occurred
(which may not be associated with any specific piece of code being
executed).  This notion of "task X has been migrated from cpu A to B"
seems like a fairly high-level concept; the fact that it can be
implemented by hooking a single piece of code is side-effect of the
modularity of the scheduler rather than anything relating to the event
itself.

Functionally, tracepoints and notifiers do have broad similarities. 
Should they be unified?  I don't know, but they do seem to serve
distinct roles.

    J
