Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbYKWQky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbYKWQky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 11:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbYKWQkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 11:40:39 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:33137 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753653AbYKWQkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 11:40:36 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAOMWKUlMROB9/2dsb2JhbACBbcwQgnw
Date: Sun, 23 Nov 2008 11:40:12 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/16] Markers auto enable tracepoints (new API :
	trace_mark_tp())
Message-ID: <20081123164012.GA16962@Krystal>
References: <20081114224733.364965865@polymtl.ca> <20081114224948.134716055@polymtl.ca> <20081116075928.GB530@elte.hu> <20081118044403.GA32759@Krystal> <20081118163037.GD8088@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081118163037.GD8088@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:44:02 up 6 days, 16:24,  1 user,  load average: 0.53, 0.52,
	0.38
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Markers identify the name (and therefore numeric ID) to attach to an 
> > "event" and the data types to export into trace buffers for this 
> > specific event type. These data types are fully expressed in a 
> > marker format-string table recorded in a "metadata" channel. The 
> > size of the various basic types and the endianness is recorded in 
> > the buffer header. Therefore, the binary trace buffers are 
> > self-described.
> > 
> > Data is exported through binary trace buffers out of kernel-space, 
> > either by writing directly to disk, sending data over the network, 
> > crash dump extraction, etc.
> 
> Streaming gigabytes of data is really mostly only done when we know 
> _nothing_ useful about a failure mode and are _forced_ into logging 
> gobs and gobs of data at great expense.
> 
> And thus in reality this is a rather uninteresting usecase.
> 
> We do recognize and support it as it's a valid "last line of defense" 
> for system and application failure analysis, but we should also put it 
> all into proper perspective: it's the rare and abnormal exception, not 
> the design target.
> 

Hrm, the fact that you assume that large data-throughput recording is
seldom used shows you have not been in contact with the same user-base I
have been interacting with. A few examples of successful LTTng users :

- Google are deploying LTTng on their servers. They want to use it to
  monitor their production servers (with flight recorder mode tracing)
  and to help them solve hard to reproduce problems. They have had
  success with such tracing approach to fix "rare disk delay" issues and
  VM-related issues presented in this article :

  * "Linux Kernel Debugging on Google-sized clusters at Ottawa Linux
    Symposium 2007"
    http://ltt.polymtl.ca/papers/bligh-Reprint.pdf

- IBM Research have had problems with Commercial Scale-out applications,
  which are being an increasing trend to split large server workloads.
  They used LTTng successfully to solve a distributed filesystem-related
  issue. It's presented in the same paper above.

- Autodesk, in the development of their next-generation of Linux
  audio/video edition applications, used LTTng extensively to solve
  soft real-time issues they had. Also presented in the same paper.

- Wind River included LTTng in their Linux distribution so their
  clients, already familiar to Wind River own tracing solution in
  VxWorks, car have the same kind of feature they have relied on for a
  long time.

- Montavista have integrated LTTng in their distribution for the same
  reasons. It's used by Sony amongst others.

- SuSE are currently integrating LTTng in their next SLES distribution,
  because their clients asking for solutions which supports a kernel
  closer to real-time need such tools to debug their problems.

- A project between Ericsson, the Canadian Defense, NSERC and various
  universities is just starting. It aims at monitoring and debugging
  multi-core systems and provide automated and help user system behavior
  analysis.

- Siemens have been using LTTng internally for quite some time now.

The wide user-base I have been interacting with, which range from expert
developers to lead OS researchers, all agree on the strong need for a
tool streaming gigabytes of data, as LTTng does, to help analysing the
problem offline. I think that Linux kernel developers might be a bit
biased in this aspect, because they happen to know what they are looking
for. But users, even experts, often have very few clue where the problem
might be in large applications they are developing. And as the number of
cores grows and applications are getting larger and more complex, this
problem is not likely to lessen.

> Note that we support this mode of tracing today already: we can 
> already stream binary data via the ftrace channel - the ring buffer 
> gives the infrastructure for that. Just do:
> 
>   # echo bin > /debug/tracing/trace_options
> 
> ... and you'll get the trace data streamed to user-space in an 
> efficient, raw, binary data format!
> 
> This works here and today - and if you'd like it to become more 
> efficient within the ftrace framework, we are all for it. (It's 
> obviously not the default mode of output, because humans prefer ASCII 
> and scriptable output formats by a _wide_ margin.)
> 
> Almost by definition anything opaque and binary-only that goes from 
> the kernel to user-space has fundamental limitations: it just doesnt 
> actively interact with the kernel for us to be able to form a useful 
> and flexible filter of information around it.
> 

This is the exact reason why I have an elaborated scheme to export
binary data to userspace in LTTng. LTTng buffer format is binary-only,
but is *not* opaque. It is self-described and portable, and a simple
user-space tool can format it to text without much effort.

> The _real_ solution to tracing in 99% of the cases is to intelligently 
> limit information - it's not like the user will read and parse 
> gigabytes of data ...
> 

Yes, limiting the information flow is sometimes required. e.g. we don't
want to export lockdep-rate information all the time. However, having
enough information within the trace to understand the surroundings of a
problematic behavior can greatly help identifying the root cause of the
problem. Ideally, having tools which automatically finds the interesting
spots in those gigabytes of data (which we have in lttv), and helps
representing the information in graphical form (which helps users find
execution patterns much more easily.. it's impressive to see how good
the human brain can be at pattern-recognition), and lets the user dig in
the detailed information located near the problematic execution scenario
is of inestimable value.

It has, in many of the cases explained above, led to fix the problematic
situation after a few hours with a tracer rather than a few weeks of
painful trial-and-error debugging (involving many developers).

> Look at the myriads of rather useful ftrace plugins we have already 
> and that sprung out of nothing. Compare it to the _10 years_ of 
> inaction that more static tracing concepts created. Those plugins work 
> and spread because it all lives and breathes within the kernel, and 
> almost none of that could be achieved via the 'stream binary data to 
> user-space' model you are concentrating on.

It's great that you have such momentum for ftrace, and yes, there is a
need for in-kernel analysis, because some workloads might be better
suited for in-kernel analysis (potentially because they generate a
too-high tracing throughput for the available system resources).

However, the comparison you are doing here is simply unfair. Ftrace has
this momentum simply because it happens to be shipped with the Linux
kernel. LTTng has been an out-of-tree patch for about 4 years now and
has generated a great deal of interest in users which can afford to
deploy their own kernel. Therefore, the real reason why ftrace has such
popularity is just because, as you say, it "all lives and breathes
within the kernel". It has nothing to do with in-kernel vs
post-processing analysis or with ascii vs binary data streaming.

Also, doing the analysis part within the kernel has a downside : it adds
complexity to the kernel itself. It adds analysis which are sometimes
complex and require additionnal data structures within the kernel. The
advantage of streaming the data out of the kernel is that it makes the
kernel-side of tracing trivially simple : we get the data out to a
memory buffer. Period. This helps being less intrusive, minimizes the
risks of distupting the normal system behavior, etc.

> 
> So in the conceptual space i can see little use for markers in the 
> kernel that are not tracepoints (i.e. not actively used by a real 
> tracer). We had markers in the scheduler initially, then we moved to 
> tracepoints - and tracepoints are much nicer.
> 

I am open to changes to the markers API, and we may need to do some, but
in LTTng scheme, they fulfill a very important requirement : they turn
what would otherwise be "opaque binary data" as you call it into fully
described, parseable binary data.

We can then think of LTTng binary data as a very efficient data
reprensentation wich can be automatically, and generically, transformed
into text with a simple binary-to-ascii parser (think of it as a
printk-like parser).

> [ And you wrote both markers and tracepoints, so it's not like i risk
>   degenerating this discussion into a flamewar by advocating one of 
>   your solutions over the other one ;-) ]
> 

That's ok.. I'm just trying to show which design space markers currently
fulfill.

> ... and in that sense i'd love to see lttng become a "super ftrace 
> plugin", and be merged upstream ASAP.
> 

Hrm, a big part of LTTng is its optimized buffering mechanism, which has
been more tested and is more flexible than the one currently found in
ftrace (it has supported lockless NMI-safe tracing for over 2 years). It
also separates the various tracing layers in separated modules, which
helps not mixing the buffer management layer with the timestamping layer
and with the memory backend layer.. I am opened to try to merge ftrace
and lttng together, but I think it will be more than a simple "make
lttng a ftrace plugin".

> We could even split it up into multiple bits as its merged: for 
> example syscall tracing would be a nice touch that a couple of other 
> plugins would adapt as well. But every tracepoint should have some 
> active role and active connection to a tracer.
> 
> And we'd keep all those tracepoints open for external kprobes use as 
> well - for the dynamic tracers, as a low-cost courtesy. (no long-term 
> API guarantees though.)
> 

Ah, I see.. when you speak of LTTng as a "super ftrace plugin", you
refer to the LTTng tracepoints only (the instrumentation). In that
sense, yes, we could add the LTTng tracepoints into the Linux kernel and
make ftrace a user of those without any problem. And as you say, no
guaranteed API (this is in-kernel only).

> Hm?

Well, given that I currently have :

- trace_clock() infrastructure for timestamping (which I could submit
  for -tip, I think it's ready)

- LTTng instrumentation, which could be used by many tracers.

- LTTng buffer management, trace control, etc, which we might want to
  get through in a review phase and try to do a mix and match of the
  best features between LTTng and ftrace.

I think we could end up with a tracer which would be faster, more solid
and would support both what ftrace is currently doing and what LTTng is
doing. But if we want to do that, we have to both recognise that the
use-cases filled by ftrace and by LTTng are complementary and are all
needed by the community overall.

Mathieu

> 
> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
