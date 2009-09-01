Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZIAXvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZIAXvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 19:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbZIAXvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 19:51:39 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:61965 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397AbZIAXvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 19:51:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VH2AC0SlEZRQTRmAKAc11E3YQ1XRKa5sdzvpa6CVzVFgZzT81YZ6GIR4Uv8Ia+2rVT
         PV7l4Wdff4lsSA+PggYk6HJ8PK8YATRiG2x608QatYewCIR6M6o/oxVuVel947B3x7bl
         /udpbEJttyjepPEpecJSRdofAEzdu5GZV/Dos=
Date: Wed, 2 Sep 2009 01:51:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>,
       Paul Mackerras <paulus@samba.org>, David Gibson <dwg@au1.ibm.com>
Subject: Re: [Patch 0/1] HW-BKPT: Allow per-cpu kernel-space Hardware
	Breakpoint requests
Message-ID: <20090901235128.GE6108@nowhere>
References: <20090819161119.GA3633@in.ibm.com> <20090819173259.GF4972@nowhere> <20090820172719.GA16499@in.ibm.com> <20090821142811.GF11098@elte.hu> <20090826033637.GB6245@nowhere> <20090826091642.GB7743@elte.hu> <20090826114954.GA6009@nowhere> <20090826180245.GA4438@in.ibm.com> <20090829134107.GD24123@elte.hu> <20090901063845.GB25221@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901063845.GB25221@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 12:08:45PM +0530, K.Prasad wrote:
> On Sat, Aug 29, 2009 at 03:41:07PM +0200, Ingo Molnar wrote:
> > 
> > * K.Prasad <prasad@linux.vnet.ibm.com> wrote:
> > 
> > > I am not sure if pmus can handle, (or want to handle) all the 
> > > intricacies involved with the hw-breakpoint layer [...]
> > 
> > Which are those intricacies? It's all rather straightforward 
> > register scheduling and reservation stuff - which perfcounters 
> > already solves in a very rich way.
> > 
> > 	Ingo
> 
> While it is quite true that debug register scheduling and reservation
> (using exclusive/pinned properties) are possible through the perf's
> implementation, breakpoint exception handling and a provision to invoke
> user-defined callback require an extension to the existing perf
> implementation (which allows only counting and sampling upon an event,
> as I presently understand).



Well, not that much actually. The upper (core) layer of the hw bp
should reside and still handle specific breakpoint problems.

Also that doesn't imply a complete zapping of the low level, we
indeed still need to handle things like exception callbacks.

Actually the only part that may roughly shrink is the registers
scheduling. We just won't need to handle anymore tricky things like
per thread virtual debug registers and things like that.


 
> Breakpoint exception handling involving tasks such as filtering stray
> exceptions (arising out of breakpoint length limitations), user-defined
> callback invocation and signal generation are, as I see not in common
> with perf-counter's functionality. And on architectures like PPC64 whose
> exception behaviour is 'trigger-before-execute' making it difficult to
> bring a 'continuous-trigger' behaviour, sufficient interlocking is necessary
> with single-step exception (required for a
> bkpt_exception-->disable_bp-->single_step-->enable_bp-->invoke_callback+signal
> process).



No really, it's not up to perf to handle such peculiar things. It's still
the role of the bp API (low and high level).


 
> And post integration, in-kernel users like ptrace, kgdb* and xmon*
> which hitherto have interacted directly with the debug registers
> (through set_debugreg()/set_dabr()) should route their requests through the
> perf-layer. It is difficult to imagine ptrace's idempotent requests
> (through ptrace_<get><set>_debugreg()) having to pass through perf-layer
> (and becoming dependant on CONFIG_PERF_COUNTERS), not to mention the
> tricks required to synchronise signal generation timing with exception
> behaviour (especially on PPC64).
> * - Not converted to use hw-breakpoint layer yet



Actually, I see the perf layer here as a middle man between

- the very hardware stuff (dr[0-467]) handling, reading, writing, updating
- the core API (register_kernel_breakpoint(), register_user_breakpoint() etc..)

And this middle man can handle so much things on its own that the two above
gets utterly shrinked.

Also the ptrace thing is tricky in itself, and that can't be helped easily.
Because of the direct writing to debug registers done by POKE_USR,
whatever the current breakpoint API with or without perf integration, we still
need subterfuges to carry it.



> With debugging and performance monitoring being two primary uses of
> hw-breakpoints (apart from the many niche uses that one can think of),
> it would be prudent to retain the breakpoints as a separate layer
> allowing exploitation by applications with either needs than to tightly
> integrate with perf-counters.



A lonesome counter would be very limited in itself, we would only
the perf support for breakpoint. Again, the API is still required.

The goal is to have:

1) A factorization of the registers scheduling, of breakpoint
   target allocation (task/cpu, etc..., it's all handled by perf)
2) Optimization of registers scheduling
3) New features (period to trigger events, target inheritance, context exclusion
   etc...)
4) A schrink of the code



> With plenty of users exploiting the breakpoint layer's debugging
> capabilities - like SystemTap http://lwn.net/Articles/343581/
> (extensible for user-space), ftrace, ptrace and potentially gdbstub
> (http://tinyurl.com/gdbstub-prototype), it is but a sad state to keep
> the hw-breakpoint layer waiting in-queue for want of performance
> monitoring (through perf-counter exploitation/integration).


I first felt the idea of a perf based design suspicious. Because it appeared
to be a real overkill.
But actually after more thoughts about it, it could really simplify, factorize,
and enhance this API.

I'm currently trying to do something. A quick draft just to see where
we can go with it, how could look like such a beast...

