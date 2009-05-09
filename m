Return-Path: <linux-kernel-owner+w=401wt.eu-S1751630AbZEIIiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbZEIIiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 04:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbZEIIiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 04:38:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51354 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbZEIIiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 04:38:02 -0400
Date: Sat, 9 May 2009 10:37:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [RFC] convert ftrace syscall tracer to TRACE_EVENT()
Message-ID: <20090509083737.GE3656@elte.hu>
References: <20090508210347.GA3121@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508210347.GA3121@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jason Baron <jbaron@redhat.com> wrote:

> Hi,
> 
> I've been thinking about converting the current ftrace syscall 
> tracer to the TRACE_EVENT() macros. There are a few issues with 
> the current syscall tracer approach:
> 
> 1) It has to be enabled for all processes and all syscalls. By 
> moving to TRACE_EVENT(), it can be enabled/disabled per tracepoint 
> and can also make use of the generic tracing filters, such as 
> "trace all process for pid x"
> 
> 2) Other tracers can not tie into it, since its not tracepoint 
> based. TRACE_EVENT() fixes this.
> 
> 3) data formatting. The syscall tracer I don't believe understands 
> all the various types for output formatting. By moving to 
> TRACE_EVENT(), we can print out a more readible syscall trace.
> 
> 4) The ftrace syscall tracer needs a new arch specific code for 
> each architecture. By converting to TRACE_EVENT() we don't need 
> any architecutre specific code.
> 
> Other issues to consider:
> 
> * Maintainence. The current syscall tracer automatically picks up 
> new syscalls. The TRACE_EVENT() will be harder to initially set 
> up. But once its done, syscalls are obviously not added often. So 
> I don't think this will be too bad.
> 
> * Performance. The current syscall tracer adds a 
> 'test_thread_flag()' to syscall entry/exit. The TRACE_EVENT() 
> would add a per-syscall global to check. So they are going to have 
> different cache profiles...however, the tracepoint infrastructure 
> is hopefully moving to the 'immediate' value work, which will make 
> this more highly optimized.
> 
> I've also tested the patch shown below (which uses, 
> DECLARE_TRACE(), as a preliminary proof of concept), using 
> getpid() in a loop, and tbench, and saw very small performance 
> differences. Obviously we would have to do more extensive testing 
> before deciding.
> 
> Patch is pretty rough, but should give a rough sense of what the 
> DECLARE_TRACE() type patch might look like...

Yeah, i very much agree with the direction. (I've Cc:-ed Tom Zanussi 
who also has expressed interest in this.)

I'm not sure about the implementation as you've posted it though:

Firstly, it adds two new tracepoints to every system call. That is 
unnecessary - we already have the TIF flag based callbacks, and we 
can use the existing syscall attributes table to get to tracepoints 
- without slow down (or impacting) the fast path in any way.

Secondly, we should reuse the information we get in SYSCALL_DEFINE, 
to construct the TRACE_EVENT tracepoints directly - without having 
to list all syscalls again in a separate file.

	Ingo
