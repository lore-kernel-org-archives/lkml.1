Return-Path: <linux-kernel-owner+w=401wt.eu-S1752350AbYKMIut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbYKMIut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 03:50:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbYKMIug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 03:50:36 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:47007 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbYKMIug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 03:50:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=GudOTdFhCMdvymm2rrLrBgZe8YFtxJ6abgEMT9646z39swLCXhREdggJKOjTDmkFr7
         iLxhYGD2w71U0dASXyc1w2cZUoHAgB5YUSBO4BFE+nfLSfn6o1p+oiXxpytxe72YY8Yd
         ge5e2An93adtoH5umpSpaENu2vjO6Fz/qABQ8=
Message-ID: <c62985530811130050q58be3f58rcef08a61b5a584a3@mail.gmail.com>
Date: Thu, 13 Nov 2008 09:50:34 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function return tracer lockless
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081112221552.GA6125@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491B4F0A.3080901@gmail.com> <20081112221552.GA6125@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/12 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Impact: remove spinlocks and irq disabling in function return tracer.
>>
>> I've tried to figure out all of the race condition that could happen when
>> the tracer pushes or pops a return address trace to/from the current
>> thread_info.
>>
>> Theory:
>>
>> _ One thread can only execute on one cpu at a time. So this code doesn't need
>>   to be SMP-safe. Just drop the spinlock.
>> _ The only race could happen between the current thread and an interrupt. If an
>>   interrupt is raised, it will increase the index of the return stack storage and
>>   then execute until the end of the tracing to finally free the index it used.
>>   We don't need to disable irqs.
>>
>> This is theorical. In practice, I've tested it with a two-core SMP
>> and had no problem at all. Perhaps -tip testing could confirm it.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>
> applied to tip/tracing/function-return-tracer, thanks Frederic!
>
>        Ingo
>


BTW I'm wondering about consistency in time capturing.
When I look into kernel/sched_clock.c I see this in introduction:

"The clock: sched_clock_cpu() is monotonic per cpu, and should be somewhat
consistent between cpus (never more than 2 jiffies difference)."

Two Jiffies, that could result in a lot of inconsistency in the way of
nanosec capturing. The current task
can be preempted between the call time and the return time and I'm
doing a cpu_clock(raw_smp_processor_id)
on these two times.
Should I keep the same processor_id for these two captures? But what
would happen if this cpu is shut
down between these two times?
One other solution would be to plan time capture in usec but I would
mostly lose the interest of function cost measuring....

What do you think?
Thanks.
