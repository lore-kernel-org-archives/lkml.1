Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbYJJNvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbYJJNvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 09:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYJJNvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 09:51:16 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:28104 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807AbYJJNvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 09:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=APJNhPBfQhlAMzK1cyhhPQmNj/FxTsBNT6Ii3p8iuTqTekWqKrTeVJTXu4FQuI5Alk
         Qzm0zZ2/i4SsEPZeo67WbzbJWsGTed1pO96fJbDnjeWAYydxYPj/K93DNANMSeC1yrcR
         0X0ql2RvrHanYz065Khk3JtEeqm5688Y9SOXE=
Message-ID: <c62985530810100651x2a61764bj1f98b98d50e9abe4@mail.gmail.com>
Date: Fri, 10 Oct 2008 15:51:13 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 3/6] tracing/ftrace: Fix a race condition in sched_switch tracer
Cc: "Ingo Molnar" <mingo@elte.hu>, Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0810100935570.26408@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081010113510.A07A9D1BD59@perso1.free.fr>
	 <alpine.DEB.1.10.0810100935570.26408@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/10 Steven Rostedt <rostedt@goodmis.org>:
>
> On Fri, 10 Oct 2008, Frederic Weisbecker wrote:
>>
>> This patch fixes a race condition in the sched_switch tracer.
>> If several tasks (IE: concurrent initcalls) are playing with
>> tracing_start_cmdline_record() and tracing_stop_cmdline_record(),
>> the following situation could happen:
>>
>>
>> _ Task A and B are using the same tracepoint probe. Task A holds it. Task B is
>> sleeping and doesn't hold it.
>> _ Task A frees the sched tracer, then sched_ref is decremented to 0.
>> _ Task A is preempted and hadn't yet unregistered its tracepoint probe,
>> then B runs.
>> _ B increments sched_ref, sees it's 1 and then guess it has to register its probe. But it has not been freed by task A.
>> _ A lot of bad things can happen after that...
>
> OK, I see the issue.
>
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> CC: Steven Rostedt <rostedt@goodmis.org>
>> ---
>>  kernel/trace/trace_sched_switch.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
>> index b8f56be..59de514 100644
>> --- a/kernel/trace/trace_sched_switch.c
>> +++ b/kernel/trace/trace_sched_switch.c
>> @@ -17,6 +17,7 @@
>>  static struct trace_array    *ctx_trace;
>>  static int __read_mostly     tracer_enabled;
>>  static atomic_t                      sched_ref;
>> +static DEFINE_MUTEX(tracepoint_mutex);
>>
>>  static void
>>  probe_sched_switch(struct rq *__rq, struct task_struct *prev,
>> @@ -125,18 +126,22 @@ static void tracing_start_sched_switch(void)
>>  {
>>       long ref;
>>
>> +     mutex_lock(&tracepoint_mutex);
>>       ref = atomic_inc_return(&sched_ref);
>>       if (ref == 1)
>>               tracing_sched_register();
>
> Could you make another patch to convert sched_ref to an int. With a mutex
> lock, there's no reason for this to be atomic.
>
> We can simply do:
>
>        if (!(sched_ref++))
>                tracing_sched_register();
>
>> +     mutex_unlock(&tracepoint_mutex);
>>  }
>>
>>  static void tracing_stop_sched_switch(void)
>>  {
>>       long ref;
>>
>> +     mutex_lock(&tracepoint_mutex);
>>       ref = atomic_dec_and_test(&sched_ref);
>>       if (ref)
>>               tracing_sched_unregister();
>
> and
>
>        if (!(--sched_ref))
>                tracing_sched_unregister();
>
>> +     mutex_unlock(&tracepoint_mutex);
>
> Also, lets change the name. sched_register_mutex?
>
>>  }
>>
>>  void tracing_start_cmdline_record(void)

I didn't want to change it into an int because probe_sched_switch().
But actually that shouldn't be a problem.
Ok I will apply your comments in the next days (I can't until this week-end)....
