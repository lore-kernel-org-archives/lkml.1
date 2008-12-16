Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758562AbYLPWjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562AbYLPWjI (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 17:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbYLPWiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 17:38:54 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:38664 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbYLPWix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 17:38:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZuDYNFoZqpxsYXmwEno5j/OAF7TFIVktsW0fqBT7z+ldCLwaKJJiEkl4DsGcb8I/Px
         egNZEGmhcW4nqF7xIVY9FNjXrKYRtLPe4twyzjWxuy/4z0sQeSk9aqdBniDIKYTC1rym
         FmkrB9UbATxwaEloYGrVt5uODELJezivUXhnU=
Message-ID: <c62985530812161438m2490e67dk42d79cd7fc1f1365@mail.gmail.com>
Date: Tue, 16 Dec 2008 23:38:51 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/ftrace: use preempt_enable_no_resched_notrace in ring_buffer_time_stamp()
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081216215033.GV14787@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <494818EA.7080807@gmail.com> <20081216212028.GP14787@elte.hu>
	 <c62985530812161339p6296f032rdc3c74650331f3d8@mail.gmail.com>
	 <20081216215033.GV14787@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/16 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> 2008/12/16 Ingo Molnar <mingo@elte.hu>:
>> >
>> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> >
>> >> Impact: prevent a trace recursion
>> >>
>> >> After some tests with function graph tracer under x86-32, I saw some recursions
>> >> caused by ring_buffer_time_stamp() that calls preempt_enable_no_notrace() which
>> >> calls preempt_schedule() which is traced itself.
>> >>
>> >> This patch re-enables preemption without rescheduling.
>> >>
>> >> Cc: Steven Rostedt <rostedt@goodmis.org>
>> >> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> >> ---
>> >>  kernel/trace/ring_buffer.c |    2 +-
>> >>  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > applied to tip/tracing/ftrace, thanks Frederic!
>> >
>> > Does this explain+fix the weird crashes/reboots you were seeing?
>> >
>> >        Ingo
>> >
>>
>> No, actually the functions tracers are protected against recursion,
>> but rescheduling attempts
>> during all trace insertions (and moreover a call to
>> prepare_ftrace_return with cancelled insertion)
>> is a useless payload.
>>
>> The hard reboots I've seen are related to x86-64 while
>> disabling/reenabling a CPU through /sys/device/system/cpu No tracer was
>> enabled at these times (the problem still remains with latest updates on
>> -tip for half an hour).
>>
>> One other thing: I've seen these pointless calls to preempt_schedule
>> while testing the function graph tracer on VirtualBox. Since it provides
>> virtual serial lines, it was more easy to debug than usual (I haven't
>> any serial line on my box). The function graph tracer hangs on
>> VirtualBox with a x86-32 -tip. It seems that the tracing is too slow and
>> so hrtimer_interrupt() does an eternal loop, assuming that a new time
>> update has to be done (because too much time elapsed during th tracing)
>> after each iteration. I'm not sure what to do...disabling tracing for
>> hrtimers or....
>
> reduce HZ?
>
>        Ingo
>

I just switched from 250 to 100 HZ. And it remains the same. But I
commented out the early_printk which could consume some
time too.
Perhaps there is one other thing that makes it hanging. I will
investigate more...
Did someone make some tests with function graph tracer on 32 bits
these last days?
