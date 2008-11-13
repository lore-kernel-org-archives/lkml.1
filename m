Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbYKMJ1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbYKMJ1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 04:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYKMJ1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 04:27:11 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:53455 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbYKMJ1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 04:27:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KcPgyn3g12/4/fEiMO3QlufBFZjMkbb2sKgIdj1dq3+7JhkWCOenomr4Pm9Mq6WGNo
         vO+G1nBdy160tRt6JEdz5AE3BNHryZ2cjy2QVpkPbQa3IDcs+dpcEdosr0bqSTquAm/x
         ignBSZn/4gAFHdcVF3z6RL6PYPdCEWSe7+xu4=
Message-ID: <c62985530811130127u307c359fj4c4a9a778676ba4e@mail.gmail.com>
Date: Thu, 13 Nov 2008 10:27:07 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] tracing/function-return-tracer: Make the function return tracer lockless
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20081113092340.GJ25479@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <491B4F0A.3080901@gmail.com> <20081112221552.GA6125@elte.hu>
	 <c62985530811130050q58be3f58rcef08a61b5a584a3@mail.gmail.com>
	 <20081113085551.GF25479@elte.hu>
	 <c62985530811130116v60d46c85j7f74230e1545eaaf@mail.gmail.com>
	 <20081113092340.GJ25479@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/13 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> 2008/11/13 Ingo Molnar <mingo@elte.hu>:
>> >
>> > * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>> >
>> >> BTW I'm wondering about consistency in time capturing. When I look
>> >> into kernel/sched_clock.c I see this in introduction:
>> >>
>> >> "The clock: sched_clock_cpu() is monotonic per cpu, and should be
>> >> somewhat consistent between cpus (never more than 2 jiffies
>> >> difference)."
>> >>
>> >> Two Jiffies, that could result in a lot of inconsistency in the way
>> >> of nanosec capturing. The current task can be preempted between the
>> >> call time and the return time and I'm doing a
>> >> cpu_clock(raw_smp_processor_id) on these two times. Should I keep
>> >> the same processor_id for these two captures? But what would happen
>> >> if this cpu is shut down between these two times? One other solution
>> >> would be to plan time capture in usec but I would mostly lose the
>> >> interest of function cost measuring....
>> >>
>> >> What do you think?
>> >
>> > in practice the jitter is much lower - a couple of microseconds - up
>> > to a few dozen at most.
>> >
>> > But it's a possibility, and i think the best solution is something
>> > that Steve suggested yesterday: a /debug/tracing/trace_options flag
>> > that turns on global ordering for tracing timestamps. Something like:
>> >
>> >  echo global_timestamps > /debug/tracing/trace_options
>> >
>> > tracers could also change the default of this flag. The function-cost
>> > tracer will probably want to default to globally synchronous
>> > timestamps, while the preempt and irqsoff tracers want to default to
>> > local timestamps only.
>> >
>> > Would something like this work for you?
>> >
>> >        Ingo
>> >
>>
>>
>> But I guess this flag would apply on the timestamp inserted by the
>> ring-buffer. Unfortunately I can't use it since I have to capture
>> the clock for two times and not only during insertion in the
>> ring-buffer.
>
> i think the clock should be a property of the tracer, not of the ring
> buffer. Hence if a tracer has the option set, it will get coherent
> timestamps - including ringbuffer insertion timestamps.
>
>        Ingo
>



If so that would be suitable. And for his purpose, the ring-buffer
would propose a function for time snapshot
adapted to the current flags and that rely on sched_clock?
