Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZCFKMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZCFKMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbZCFKMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:12:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49084 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbZCFKMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:12:23 -0500
Date: Fri, 6 Mar 2009 11:11:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, ltt-dev@lists.casi.polymtl.ca,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Subject: Re: [RFC patch 00/41] LTTng 0.105 core for Linux 2.6.27-rc9
Message-ID: <20090306101142.GA26659@elte.hu>
References: <20090305224728.947235917@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305224728.947235917@polymtl.ca>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi,
> 
> I spent the last 4-5 months working with the Fujitsu team at 
> implementing the tracer elements identified as goals at Kernel 
> Summit 2008 and at the following Plumber Conference. My idea 
> was to incremententally adapt the LTTng tracer, currently used 
> in the industry and well tested, to those requirements.
> 
> I spent the last days rearranging/folding/inspecting the LTTng 
> patchset to prepare it for an LKML post. The version 0.105 in 
> the LTTng git tree corresponds to the patchset I am posting 
> here. The said patchset will only include the core features of 
> LTTng, excluding the timestamping infrastructure (trace clock) 
> and excluding the instrumentation.

I'd like to merge the good bits into the tracing tree. Looking 
at the patches you submitted there's a lot of avoidable overlap 
with existing tracing features either present upstream already 
or queued up for v2.6.30 - and we need to work more on 
eliminating that overlap.

I dont think there's much fundamental disagreement just 
different implementations - so we should evaluate each of those 
details one by one, iteratively.

The first step would be to split the patches up into three 
logical buckets:

 - Unique features not present in the tracing infracture, in the 
   event tracer or other tracing plugins - those should be 
   structured as feature additions.

 - Features that you consider superior to existing tracing
   features of the kernel. For those, please iterate the
   existing code with your enhancements - instead of a parallel 
   implementation.

 - Items which offer nothing new and are not superior to 
   existing features, those should be dropped probably. This too 
   is a case by case thing.

Would you be interested in working with us on that? I know that 
both Steve and me would be very much interested in that. If you 
have time/interest to work on that then we can go through each 
patch one by one and categorize them and map out the way to go.

Let me give you a few examples of existing areas of overlap:

> The corresponding git tree contains also the trace clock 
> patches and the lttng instrumentation. The trace clock is 
> required to use the tracer, but it can be used without the 
> instrumentation : there is already a kprobes and userspace 
> event support included in this patchset.

The latest tracing tree includes kernel/tracing/trace_clock.c 
which offers three trace clock variants, with different 
performance/precision tradeoffs:

 trace_clock_local()   [ for pure CPU-local tracers with no idle 
                         events. This is the fastest but least 
                         coherent tracing clock. ]

 trace_clock()         [ intermediate, scalable clock with
                         usable but imprecise global coherency. ]

 trace_clock_global()  [ globally serialized, coherent clock. 
                         It is the slowest but most accurate variant. ]

Tracing plugins can pick their choice. (This is relatively new 
code but you get the idea.)

> This tracer exports binary data through buffers using 
> splice(). The resulting binary files can be parsed from 
> userspace because the format string metadata is exported in 
> the files. The event set can be enhanced by adding tracepoints 
> to the kernel code and by creating probe modules, which 
> connects callbacks to the tracepoints and contain the format 
> string metainformation. Those callbacks are responsible for 
> writing the data in the trace buffers. This separation between 
> the trace buffer format string and the tracepoints is done on 
> purpose so the core kernel instrumentation (tracepoints) is 
> not exported to userspace, which will make maintainance much 
> easier.

A tracepoint format specification mechanism plus working (and 
fast!) zero-copy splice() support of the ring-buffer exists in 
the latest tracing tree already - as you are probably aware of 
because you commented on those patches a few days ago.

There are 3 good ways to go from here regarding the trace 
buffering and splice code:

  1- we end up switching to the lttng version in essence
  2- we end up keeping the tracing tree version
  3- we end up somewhere inbetween

Which point in the above spectrum we will settle down on depends 
on the technical details.

Note, whichever path we choose a gradual, iterative workflow is 
still needed, so that we improve the existing upstream code with
lttng enhancements gradually.

This approach works for all your other patches as well. A 
direct, constructive comparison and active work on unifying them 
is required.

Thanks,

	Ingo
