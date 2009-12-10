Return-Path: <linux-kernel-owner+w=401wt.eu-S1761887AbZLJWEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761887AbZLJWEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761831AbZLJWEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:04:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:65049 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761822AbZLJWEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:04:53 -0500
X-Authority-Analysis: v=1.0 c=1 a=0ZecOPpkQPkA:10 a=7U3hwN5JcxgA:10 a=itrxvkQ26ZJaz4eVJagA:9 a=ZNb4StTgH9x_apTRRjgA:7 a=jsCJkTVCBpVu7DKOnDNP2duEb4wA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Tim Bird <tim.bird@am.sony.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Bird, Tim" <Timothy.Bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4B216478.3080601@am.sony.com>
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu>
	 <4B216478.3080601@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Dec 2009 17:04:58 -0500
Message-ID: <1260482698.2146.234.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 13:13 -0800, Tim Bird wrote:

> > Please do it in a cleaner an more generic fashion: add a "function 
> > event" that perf can see and process, so all the output embellishment 
> > can be done outside of the kernel, in tools/perf/.
> 
> Sigh.  OK - where's the perf code?
> 
> It took me a while to wrap my head around ftrace, so if I've
> got to switch to a completely different event-ing infrastructure,
> it will probably be some time before I'm back again.
> 
> I have some patches to add function graph tracing for
> ARM, and to make it possible to use arbitrary ftrace plugins
> at boot time.  (There are issues with the current code for
> anything other than the bootgraph plugin).

The function graph for arm would be fine. Go ahead, there's no expected
change in this code for the near future, and if it does change it will
be at a higher level (generic code, not arch).

> 
> Are either of these still interesting?

We already have a way to enable arbitrary ftrace plugins at boot time:

Try ftrace=function on the command line.

> 
> I was about to start work on dynamic ftrace support for ARM.
> What is the status of this?

Please do. Again, if we change this code, I would expect it to happen at
a higher level. Trying to do a registry at the arch level will explode
in complexity.

> 
> > We want to wind down the current maze of ftrace plugins, not extend 
> > them. We already obsoleted the following ftrace plugins: scheduler, 
> > sysprof, blktrace, kmem, scheduler, etc. There's more work ongoing and 
> > broad agreement between folks developing it that this is the way 
> > forward.
> 
> It looks like all the tracers mentioned above are still in 2.6.32,
> which was just released. In what sense are they "already obsoleted"?

Well, the TRACE_EVENT infrastructure has made them obsolete. In ftrace
terms, you can just do:

 # echo 1 > debugfs/tracing/events/sched/enable
 # cat /debugfs/tracing/trace

and see basically the same information that sched_switch showed.

> 
> In what time frame will the ftrace plugin feature be obsoleted?

Well, currently we don't have any substitute for function/function_graph
and the latency tracers. We just don't want to be adding more.


> I'm using this code on 2.6.29 for a variety of Sony products.
> If the ftrace plugin stuff isn't going away for another year
> or two that gives me several years of utility with the current
> code (which I recognize I'd have to maintain myself out-of-tree).

I don't plan on removing the plugin infrastructure anytime soon.

> 
> Once things have settled down and you guys have figured out
> for sure what's going on, I could come back and try to integrate
> these features into perf.  As it stands now, I'm a little wary
> of putting much effort into that.
> 
> Where are these things discussed?  Only on LKML?  It would be
> handy if there were a separate list that could get CC-ed for
> ftrace stuff, so I could monitor it more easily for big movements
> like this.  I apologize if there is and I've just missed it.

It's not really discussed much. Usually someone pushes out a patch set
that changes the direction of tracing, and we go from there. So yes, it
is LKML.

> 
> > The function tracer / function graph tracer is a holdout due to its 
> > complexity - but that by no means weakens the argument and the necessity 
> > to migrate it.
> > 
> > ftrace plugins were a nice idea originally and a clear improvement over 
> > existing alternatives, but now that we've got a technicaly superior, 
> > unified event framework that can do what the old plugins did and much 
> > more, we want to improve that and not look back ...
> 
> I'm a little worried about this.  ftrace is already an order
> of magnitude more overhead than the previous tracer I was using.

Which tracer was that? I know you used the -finstrument-functions for
tracing before, and that has quite a bit overhead as well. The ring
buffer has gone through a lot to speed it up.

-- Steve


