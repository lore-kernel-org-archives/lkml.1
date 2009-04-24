Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbZDXHLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbZDXHLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbZDXHK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:10:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36424 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbZDXHK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:10:56 -0400
Date: Fri, 24 Apr 2009 09:09:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/6] tracing: increase size of number of possible events
Message-ID: <20090424070953.GC24912@elte.hu>
References: <20090424043005.338878133@goodmis.org> <20090424043111.983189535@goodmis.org> <49F15607.1090707@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F15607.1090707@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > With the new event tracing registration, we must increase the number
> > of events that can be registered. Currently the type field is only
> > one byte, which leaves us only 256 possible events.
> > 
> > Since we do not save the CPU number in the tracer anymore (it is determined
> > by the per cpu ring buffer that is used) we have an extra byte to use.
> > 
> > This patch increases the size of type from 1 byte (256 events) to
> > 2 bytes (65,536 events).
> > 
> 
> You forgot to change this:
> 
> @@ -198,7 +198,7 @@ ftrace_define_fields_##call(void)					\
>  	struct ftrace_event_call *event_call = &event_##call;		\
>  	int ret;							\
>  									\
> -	__common_field(int, type);					\
> +	__common_field(unsigned short, type);				\
> 
> And we can apply the check in 3/6 to __common_field(). :)
> 
> > It also adds a WARN_ON_ONCE if we exceed that limit.
> > 
> 
> WARN_ON_ONCE() may not be sufficient IMO:
> 
> We can reach 65536 this way (It took me 15 mins):
> 
> while (foo_bar.id < 65536) {
> 	insmod trace-events-sample.ko
> 	rmmod trace-events-sample.ko
> }
> 
> Now next id will be 0! Then do this:
> 
> console 1:
>  # cat /debug/tracing/trace_pipe
> 
> console 2:
> while (1) {
> 	insmod trace-events-sample.ko
> 	echo foo_bar > /debug/tracing/set_event
> 	rmmod trace-events-sample.ko
> }
> 
> I got this immediately:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000006f
> IP: [<c05210f3>] bstr_printf+0x2ce/0x302
> ...
> Call Trace:
>  [<c0476d12>] ? trace_seq_bprintf+0x28/0x41
>  [<c0477569>] ? trace_bprint_print+0x58/0x6c
>  [<c0472ffc>] ? print_trace_line+0x2c5/0x2df
>  [<c0428a41>] ? sub_preempt_count+0x85/0xa0
>  [<c04758cf>] ? tracing_read_pipe+0x118/0x191
>  [<c04757b7>] ? tracing_read_pipe+0x0/0x191
>  [<c04b09f9>] ? vfs_read+0x8f/0x136
>  [<c04b0da3>] ? sys_read+0x40/0x65
>  [<c0402a68>] ? sysenter_do_call+0x12/0x36
> 
> (We can even get other crashes..)
> 
> So I think we should fail the initialization of the event, instead of
> WARN_ON().

Hm, i think this might also call for a 32-bit event ID after all, 
right? Especially if we get some more dynamic form of injecting such 
tracepoints, 64K does not sound all that far in the future anymore. 
It is stretching things, but still it would be a silly limit to 
leave in place, hm?

	Ingo
