Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbZLJUXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbZLJUXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 15:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZLJUXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 15:23:20 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60073 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbZLJUXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 15:23:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kN3oGAWwoIEWWsCPmGWqFvONC/Tl+vUaQrZZTn6AAnNofNDALzxNbVnhPlKjSdm6s/
         FUD+CMNorHz797pWZcVSRUNm2hSLsZET+qoSqaYCYUew8l7svPIyt3BuQN9CphEvpIF5
         c/RXACXD2Vy8B0QEr0ze5ZzsQqJyLo9nRLnLg=
Date: Thu, 10 Dec 2009 21:23:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
Message-ID: <20091210202317.GA6135@nowhere>
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu> <20091210120332.GA5042@nowhere> <1260455367.2146.143.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260455367.2146.143.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 09:29:27AM -0500, Steven Rostedt wrote:
> On Thu, 2009-12-10 at 13:03 +0100, Frederic Weisbecker wrote:
> 
> > This makes me feel I'm going to try converting the function graph tracer
> > into an event during the next cycle. It does not mean I could make it
> > usable as a perf event right away in the same shot that said, as you can
> > guess this is not a trivial plug. The current perf fast path is not yet
> > adapted for that.
> 
> I curious how you plan on doing this. The current event system shows one
> event per trace point. A straight forward approach would make every
> entry and exit of a function a trace point and that would lead to a very
> large kernel to handle that.


Oh no, I'm not planning to use tracepoints for that.


> Perhaps we could abstract out all entries and exits. We need to be able
> to link to a single point (entry or exit) not all.  This also has the
> added issue of using the ftrace infrastructure of nop the mcount call.
> We also need a way to enable a set of functions.
> 
> We may be able to abstract this out, but I'm hesitant on making this the
> only interface.


Hmm, yeah. The idea was just to move the use the struct trace to struct
trace_event. This would be about straightforward. A bit like kprobes: by
not using the TRACE_EVENT macros (would be impossible anyway) but
specific callbacks.

It would be one event.

set_ftrace_filter and set_graph_function can still be used to further
control dynamic patching. That's what I intended for a first conversion.

Another idea would be to abstract it through one trace event subsystem
that has one event per function. But that sounds a bit too much in term
of memory footprint. Also it's perhaps sufficient to abstract the
dynamic patching, but not enough to abstract set_graph_function.

But later on, a full trace event integration would probably imply
dicossiating dynamic tracing from the two function tracers.
For example if the function graph tracer asks to nop a function,
this shouldn't be propagated to a parallel function tracer user.
That's even worse once we get a perf integration, we can have
multiple parallel users of the function tracer. And patching
should probably adapt to parallel uses, maintaining a kind of
refcounting, extending the current function hashlist we have
for function profiling could probably help for that.

