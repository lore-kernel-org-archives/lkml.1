Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZHFNfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZHFNfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbZHFNfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:35:09 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:46722 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755791AbZHFNfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:35:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar4EAHt3ekpMQWXi/2dsb2JhbACBUs8QhBgFgUxo
Date: Thu, 6 Aug 2009 09:35:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       acme <acme@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       roland <roland@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, fche <fche@redhat.com>,
       pierre-marc.fournier@polymtl.ca, michel.dagenais@polymtl.ca,
       linux-kernel@vger.kernel.org
Subject: Re: malloc() tracing in perf?
Message-ID: <20090806133501.GA28201@Krystal>
References: <4A7A8ADD.4080208@cs.helsinki.fi> <1249546610.32113.35.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1249546610.32113.35.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:14:33 up 159 days,  9:40,  3 users,  load average: 1.24, 1.03,
	1.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Thu, 2009-08-06 at 10:48 +0300, Pekka Enberg wrote:
> > Hi,
> > 
> > It's me again :-).
> > 
> > I have a little user-space application that is pretty memory hungry and 
> > I want to understand why. I started to google around for a memory 
> > profiler or a malloc() tracer but didn't seem to find anything really 
> > useful.
> > 
> > But then it hit me, why can't I have kmemtrace + perf but for 
> > user-space? Something like the "Malloc Trace" shown here:
> > 
> > http://developer.apple.com/documentation/developertools/conceptual/SharkUserGuide/OtherProfilingandTracingTechniques/OtherProfilingandTracingTechniques.html#//apple_ref/doc/uid/TP40005233-CH6-SW17
> > 
> > Does this sound like something that could/should be part of "perf"? How 
> > would all this work anyway? Can we intercept malloc() and free() 
> > somehow? Where would the data be pushed? Am I just going perf-crazy and 
> > trying to turn it into a swiss army knife because it's so easy to use?-)
> 
> OK, you just trod into a wasp's nest :-)
> 
> 
> That sounds like uprobes, the equivalent of kprobes but for userspace.
> 
> I seem to have heard people are working on such a thing, but I can't
> seem to find a single LKML post with 'uprobe' in the subject in the past
> two years or something (except for MTUprobe) -- so I guess its not
> really going anywhere any fast.
> 
> Now doing probes on userspace is hard because you need to know more
> about the userspace bits than a kernel really ought to be interested in.
> 
> Then again, the only way to extract bits from userspace is to stop it --
> now one could do that using [pu]trace and have some monitoring app prod
> at it like any other debugger would, and I think this is the approach
> suggested by some (hch iirc).
> 
> Others seem to think we ought to stuff all this into the kernel, I can
> only imagine the pain that will cause, since you need to teach the
> kernel about these instrumentation sites' context, so I can only imagine
> it'd be through a kernel module interface much like system-tap does
> (they would be doing the in-kernel bit).
> 
> Then there are the tracer folks who also want to collect userspace
> traces. Some have proposed a sys_trace() call, others want to play silly
> games with mmap() and then there is the uprobe idea. Others (tglx and
> me) proposed letting userspace log itself and post-merge all the various
> trace buffers to get a complete picture.
> 

Hi !

Since we are comparing solutions, here is the path we are taking in
LTTng. We choose to let userspace log itself and merge the
kernel/userspace trace streams at post-processing. Past winter,
Pierre-Marc has been working on a port of the LTTng kernel tracer to
userspace. We named it "ust" library (for userspace tracing). Although
it still requires some polishing, it should be a generally usable state
(currently only on x86 with synchronized TSCs).

The plan is to gradually instrument userspace libraries and applications
with tracepoints, just like we are currently doing in the kernel.

The main difference between our approach and Dtrace is that Dtrace
requires a trap when userspace instrumentation is hit (yeah, even for
static instrumentation, isn't it a shame ?), adding a huge performance
overhead (especially on x86). Using tracepoints and staying in userspace
to log data helps keeping the performance overhead low.

For more info on lib ust :

Combined Tracing of the Kernel and Applications with LTTng at Linux
Symposium 2009 (presentation)
http://lttng.org/sites/default/files/presentation.pdf

Access to the git tree:

http://git.dorsal.polymtl.ca/?p=ust.git
(please note that we are about 99.9% done in asking permissions or
rewriting code to distribute under LGPL. I think we only wait for 1-2
bits of code to be rewritten. Pierre-Marc could tell more about it.
Until then, it's temporarily distributed under GPLv2.)

Eventually, parts of this ust library could be integrated to the libc,
so its usage should become more transparent that it currently is.

Eventually, the only dependency ust would have on the kernel is to
require a userspace trace clock mapped in a vDSO, synchronized with the
kernel trace clock.

Feedback is welcome,

Thanks,

Mathieu

> 
> Anyway, like you say, it has uses (potentially very powerful ones),
> Sun/Apple do it with Dtrace, Linux wants it but I don't think we quite
> agreed on how to do it :-)
> 
> 
> And here I see LKML isn't on the CC list, perhaps we should?
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
