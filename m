Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbYJXTa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbYJXTa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 15:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYJXTaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 15:30:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43907 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbYJXTaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 15:30:12 -0400
Date: Fri, 24 Oct 2008 15:29:49 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, systemtap@sources.redhat.com
Subject: Re: [PATCH 5/5] tracing/ftrace: Introduce the big kernel lock tracer
Message-ID: <20081024192949.GC8210@redhat.com>
References: <48F10B0B.406@gmail.com> <c62985530810210528t416c82b2lbe8471322e8359c@mail.gmail.com> <y0mmygv18le.fsf@ton.toronto.redhat.com> <c62985530810240643q467a9060kaf906eb7865f0a7@mail.gmail.com> <20081024143744.GA20768@redhat.com> <alpine.DEB.1.10.0810241046300.3882@gandalf.stny.rr.com> <20081024150239.GB20768@redhat.com> <c62985530810240826l2e025e94i51fdfd0fc70b0449@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c62985530810240826l2e025e94i51fdfd0fc70b0449@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Oct 24, 2008 at 05:26:53PM +0200, Frédéric Weisbecker wrote:
> [...]
> Actually what I thought is a style like this (Python like):
> 
> probe = Systemtap.probeFunc("lock_kernel")
> probe.captureUtime("utime"))
> probe.captureBacktrace("trace")
> probe.trace()
> 
> For an obvious set of batch work like that, that could be possible,
> perhaps even easy to implement an Api...
> When the object calls trace(), the userspace Systemtap analyse the list
> of work to do and then translate into commands in kernel space.

There comes a point not too far beyond this example where one may want
to capture functions of values; filter; perform loops/conditionals;
refer to variables/arrays.  Coding that logic this way would be so
clumsy as to take away any charm of working in python.


> And the script could wait for events and then do its own processing
> with the captured events (do some operations on delays, on output....).
> 
> for event in probe.getEvent(): #blocking
>     print event["utime"]
>     trace = event["trace"] #Systemtap.trace object with specific
> fields and a default string repr
>     print trace
> 
> It would be interpreted by Python itself [...]

This is too gets impractical.  If the only event handler code is
general python, it can't practically be executed within the kernel.
So we're then talking about a python script consuming trace data
streamed in.  We lose:
- capability to take immediate action upon event occurrence
- any claim to good performance (~microsecond event handling)
- the natural coupling between events and their handlers
- the ability to statically analyze the entire instrumentation,
  to optimize locking, data encoding


Now, one may imagine using this sort of thing as a *wrapper* around
plain systemtap: where the python libraries generate stylized
systemtap code that emits data in a form that the later "getEvent"
routine can decode again and act upon.

Several people have written shell, perl, even awk scripts scripts to
generate systemtap code for particular special purposes.  So one can
hide the script language as an implementation detail of a higher level
tool.  It's not a substitute though.


- FChE
