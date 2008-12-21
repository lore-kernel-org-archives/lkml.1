Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbYLUMVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbYLUMVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 07:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYLUMVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 07:21:16 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:26122 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYLUMVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 07:21:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sAJ3YdBBBxmyXgYBMGmKkagQKD3iz081/OwHAnhntHkDQvmwrOkbqFehlzYFEEaEsx
         4OPwE12rXH81+o4eqgkMtJI6pSz8xnvbSYSfVYZQ+w6pct/EN7K38Op9XrFSSNCOYKzG
         /lzsLiZQwpNJuBwCU8I6yZh1eZOXftduWkM7M=
Message-ID: <c62985530812210421w8e2af3ai2cae7440b2297a2@mail.gmail.com>
Date: Sun, 21 Dec 2008 13:21:12 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer interrupt infinite loop
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081221101226.GA6021@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4949A2CC.6040209@gmail.com> <20081218103459.GD10513@elte.hu>
	 <alpine.LFD.2.00.0812181136410.3492@localhost.localdomain>
	 <20081218112216.GE14332@elte.hu>
	 <c62985530812181307k4fc35770x3698101b3981879a@mail.gmail.com>
	 <20081218211637.GF24271@elte.hu>
	 <c62985530812181336m6ab39c8ah410dff763bd02d24@mail.gmail.com>
	 <20081218214458.GA30834@elte.hu> <20081221100047.GA31074@elte.hu>
	 <20081221101226.GA6021@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/21 Ingo Molnar <mingo@elte.hu>:
>
> btw., a graph-tracer buglet i noticed:
>
>  3)               |  perf_counter_task_tick() {
>  3)               |    perf_counter_task_sched_out() {
>  3)               |      /* c:ffff88049b184000, u:0: 0000000020ca1ab0 + 0000000000000000 = 0000000020ca1ab0
>  */
>  3)               |      /* sched-out counter ffff88049b184000, state: 0
>  */
>  3)   5.024 us    |    }
>  3)               |    perf_counter_task_sched_in() {
>  3)               |      /* c:ffff88049b184000, u:0: 0000000020ca1ab0 + 0000000000000000 = 0000000020ca1ab0
>  */
>  3)               |      /* sched-in counter ffff88049b184000, state: 1
>  */
>  3)   2.605 us    |    }
>  3)   9.714 us    |  }
>  3)               |  perf_counter_task_tick() {
>
> the bug is that the '*/' comment closing text is printed in the next line
> - that's not a linewrap, it happened like this in the trace.
>
> The reason is that the ftrace_printk did:
>
>        ftrace_printk("c:%p, u:%d: %016Lx + %016Lx = %016Lx\n",
>
> the closing \n is pretty natural - especially for kernel hackers who might
> just turn printk()s into ftrace_printk(), to embedd printouts in function
> traces. So it would be nice if ftrace skipped over \n's when printing them
> out as embedded C comments.
>
>        Ingo
>


Yes I was afraid of the \n from the user for these comments. You're
right, I will skip the newlines
from the user.


2008/12/21 Ingo Molnar <mingo@elte.hu>:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> btw., a graph-tracer buglet i noticed:
>
> another thing. I turned off all the options that come ahead of the 'meat'
> of the trace data:
>
> # cat /debug/tracing/trace_options
> print-parent nosym-offset nosym-addr noverbose noraw nohex nobin noblock
> nostacktrace nosched-tree ftrace_printk noftrace_preempt nobranch annotate
> nouserstacktrace nosym-userobj printk-msg-only nofuncgraph-overrun
> nofuncgraph-cpu nofuncgraph-overhead nofuncgraph-proc
>
> but i still got the 'duration' field printed:
>
> # tracer: function_graph
> #
> # DURATION            FUNCTION CALLS
> #     |               |   |   |   |
>
> 0.865 us    |    }
>            |    alloc_page_vma() {
> 0.295 us    |      get_vma_policy();
> 0.268 us    |      policy_zonelist();
>            |      __alloc_pages_internal() {
> 0.257 us    |        __might_sleep();
>            |        get_page_from_freelist() {
>
>
> i'd have expected to only see the flow of execution as it happens.
>
>        Ingo
>


Strange. I will test that.
