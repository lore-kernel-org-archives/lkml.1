Return-Path: <linux-kernel-owner+w=401wt.eu-S1760966AbZLJQWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966AbZLJQWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 11:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757917AbZLJQWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 11:22:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41231 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756951AbZLJQWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 11:22:10 -0500
X-Authority-Analysis: v=1.0 c=1 a=0ZecOPpkQPkA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=G-JWF3KG1jJVRPdXRuIA:9 a=8YD4H-dj4VhTqoHyGfcA:7 a=fBeJG8RnvJKYfXHg3ZVccJT7JeMA:4 a=jeBq3FmKZ4MA:10 a=X5TqBHD1d8tQeGF2:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091210153845.GA28230@elte.hu>
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu>
	 <20091210120332.GA5042@nowhere> <20091210141121.GB1436@elte.hu>
	 <1260456803.2146.167.camel@gandalf.stny.rr.com>
	 <20091210153845.GA28230@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Dec 2009 11:22:12 -0500
Message-ID: <1260462132.2146.198.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 16:38 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:

> The correctly designed way to express latency tracing is via a new 
> generic event primitive: connecting two events to a maximum value.
> 
> That can be done without forcibly tying it and limiting it to a specific 
> 'latency tracing' variant as the /debug/tracing/ bits of ftrace do it 
> right now.

Sure, when we have that, then we can remove the plugin (and then all
plugins when there are superior alternatives).

> 
> Just off the top of my head we want to be able to trace:
> 
>  - max irq service latencies for a given IRQ
>  - max block IO completion latencies for a app
>  - max TLB flush latencies in the system
>  - max sys_open() latencies in a task
>  - max fork()/exit() latencies in a workload
>  - max scheduling latencies on a given CPU
>  - max page fault latencies
>  - max wakeup latencies for a given task
>  - max memory allocation latencies
> 
>  - ... and dozens and dozens of other things where there's a "start"
>    and a "stop" event and where we want to measure the time between
>    them.

Note, we also need a way to "store" the max. The fly recorder method is
not good enough.


> 
> Your design of tying latency tracing to some hardcoded 'ftrace plugin' 
> abstraction is shortsighted and just does not scale to many of the items 
> above.

When we can do everything a better way, then I'm all for removing them.
I just don't want to remove them before a superior alternative exists.


> > For recording events, yes I totally agree. But for logic that needs to 
> > pass data from one event to another, it is still a bit lacking.
> 
> Expressing latency tracing in form of an 'ftrace plugin' is a pretty 
> inefficient way of doing it: it's very limiting and its utility is much 
> lower than what it could be.

As I said, "it is still a bit lacking". When we solve these issues, then
we can look at removing plugins. I'm just saying that the plugins still
serve their purpose.

> 
> > > I hope there wont be any significant culture clash between ftrace 
> > > and perf - we want a single, unified piece of instrumentation 
> > > infrastructure, we want to keep the best of both worlds, and want to 
> > > eliminate any weaknesses and duplications. As long as we keep all 
> > > that in mind it will be all fine.
> > 
> > I'm just not from the mind set that one product fits all needs. I 
> > never was and that was the reason that I joined the Linux community in 
> > the first place. I liked the old Unix philosophy of "Do one thing, and 
> > do it well, and let all others interact, and interact with all 
> > others". Ftrace itself never was one product. It just seemed that 
> > anything to do with tracing was called ftrace. It started as just the 
> > function tracer. Then it had plugins, then it got events, but these 
> > are separate entities all together.
> > 
> > I designed the ftrace plugins as a way to plug in new features that I 
> > could never dream of.
> > 
> > I wrote the ring buffer not for ftrace, but as a separate entity, that 
> > is also used by the hard ware latency detector.
> > 
> > I designed the ftrace function tracer to not just work with ftrace but 
> > to allow all others to hook to functions. This created the function 
> > graph tracer, the stack tracer, and even LTTng hooks into it (not to 
> > mention my own logdev).
> > 
> > I see that perf at the user level has ways to interact with it nicely, 
> > although I don't know how well it interacts with other utilites. But 
> > the perf kernel code seems to be a one way street. You can add 
> > features to perf, but it is hard to use the perf infrastructure for 
> > something other than perf (with the exception of the hardware perf 
> > events, that part has a nice interface).
> 
> I see ftrace plugins as a step of evolution. If you see it as some 
> ground to 'protect' then that's going to cause significant disagreement 
> between us. I prefer to reimplement functionality in a better way and 
> throw away the old version, and the whole premise of /debug is that we 
> can throw away old versions of code.

I have two points. One is that the current event infrastructure is still
lacking the features to replace the plugins, in which the plugins still
serve a purpose. I actually have some patches that have the events pass
data around. But they are just hacks, I need to restructure them.

The second point (and my real concern) is that I want to keep the design
open that other parts of the kernel can always access these features. I
like the fact that LTTng can tap into ftrace. I do not want ftrace to be
the gate keeper of its utilities. If other tools can benefit from the
ftrace infrastructure, I think that is great!

> 
> If you want to keep inferior concepts under the guise of 'choice' then 
> i'm very much against that. In the kernel we make up our minds about 
> what the best technical solution is for a given range of problems, and 
> then we go for it. Having a zillion mediocre xterms (and not a single 
> good one) is not a development model i find too convincing.

My point of this email is not to protect the concept of the plugin. But
to protect the concept of interaction. I don't see xterm as a good
example. I use gnome-terminal, and I have no issues with it. Lets look
at network browsers. Yes these still suck too (but then all userspace
apps suck ;-)  One thing that I've seen (and like) about Firefox is the
gecko interface. They don't make everyone use firefox or firefox
plugins. But they have an infrastructure that lets other applications
tap into its engine. This is what ftrace did with its function tracer.
It created an API to allow other tools to use it (as did LTTng).

I'm not saying we need to split the infrastructure between perf and
ftrace, I'm saying that what ever infrastructure there is, needs to stay
flexible that other utilities can hook into. LTTng is well known as
ftrace's biggest competitor. Funny thing is, I've spent several days
talking with Maitheu on how we can share infrastructure.

I don't want LTTng to go away. I like the tool. There's things that I
picked from it, and there's things in LTTng that Mathieu took from
ftrace. I'm all for merging LTTng when it works well with ftrace.

perf is also a great tool. But I don't want to be forced to do all
kernel tracing through a single utility. That was my original complaint
about LTTng.

I have my own utility that I use because perf currently can't handle the
event tracing that well. I like having the debugfs interface, because I
feel more comfortable with accessing the trace information directly than
going through a tool. I see that we are getting rid of the sysctl
syscall in favor of the /proc/sys interface. I wonder why that is?

-- Steve


