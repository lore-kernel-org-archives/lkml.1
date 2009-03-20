Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbZCTJAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbZCTJAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 05:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZCTJAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 05:00:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46329 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbZCTJAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 05:00:44 -0400
Date: Fri, 20 Mar 2009 14:30:30 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>
Subject: Re: [RFC][PATCH -tip 0/9] tracing: kprobe-based event tracer
Message-ID: <20090320090030.GE6398@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <49C2B4A4.5060109@redhat.com> <20090320002435.GA6895@nowhere> <49C30EA5.5040707@redhat.com> <20090320084544.GA16021@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320084544.GA16021@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 09:45:44AM +0100, Ingo Molnar wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > Frederic Weisbecker wrote:
> > > On Thu, Mar 19, 2009 at 05:09:56PM -0400, Masami Hiramatsu wrote:
> > >> Hi,
> > >>
> > >> This is a series of patches which introduce a proof-of concept of
> > >> kprobe-based event tracer to ftrace. I think that we could port some
> > >> tracing features from systemtap on this vehicle.
> > >> This can be applied on the linux-2.6-tip tree.
> > >>
> > >> This patchset includes following changes:
> > >> - Add kprobe-tracer plugin
> > >> - Add kernel_trap_sp() on x86, ia64, power, s390, arm which are
> > >>   ported from systemtap runtime.
> > >> - Add module_*probe api for repawning/removing kprobes when target
> > >>   module is coming/going.
> > >>
> > >> It's still not unclear that the last module_*probe would better be
> > >> provided as APIs or just embed it in trace_kprobe.c.
> > >>
> > >> Future items:
> > >> - Use binary print.
> > >> - Add kernel_trap_sp() on other archs.
> > >> - Support symbol-based memory fetching (for global variables)
> > >> - Support primitive types(long, ulong, int, uint, etc) for args.
> > >> - Support indirect memory fetch from register etc.
> > >> - Check insertion point safety by using instruction decoder.
> > >>
> > >> kprobe-based event tracer
> > >> ---------------------------
> > >>
> > >> This tracer is similar to the events tracer which is based on Tracepoint
> > >> infrastructure. Instead of Tracepoint, this tracer is based on kprobes(kprobe
> > >> and kretprobe). It probes anywhere where kprobes can probe(this means, all
> > >> functions body except for __kprobes functions).
> > >>
> > >> Unlike the function tracer, this tracer can probe instructions inside of
> > >> kernel functions. It allows you to check which instruction has been executed.
> > >>
> > >> Unlike the Tracepoint based events tracer, this tracer can add new probe points
> > >> on the fly.
> > >>
> > >> Similar to the events tracer, this tracer doesn't need to be activated via
> > >> current_tracer, instead of that, just set probe points via
> > >> /debug/tracing/kprobe_probes.
> > >>
> > >> Synopsis of kprobe_probes:
> > >>   p SYMBOL[+offs|-offs]|MEMADDR [FETCHARGS]     : set a probe
> > > 
> > > 
> > > Ahh, I see this is not only about parameters but also about very low level
> > > debugging, such as registers dumps.
> > > 
> > > This is very powerful.
> > 
> > Please take care, don't shot your foot :)
> > This tracer doesn't have a safety lever(e.g. instruction boundary checker) yet.
> > So, currently, we need to use this with objdump -d.
> 
> Would be really nice to have this in the future. We could reuse 
> existing opcode decoders in the x86 code for that i think. KVM has 
> probably the most potent one.

The KVM decoder has too much of a tie-in to the KVM internals and we
were also told that it is a very performance sensitive part of code.
Jim and Masami can elaborate on specifics, I think.

After considering alternatives, there is currently ongoing work on a
instruction decoder that will work not just for the kernel (djprobes for
instance, kprobes can also adapt to it), but also for userspace when it
gets done.

There is some preliminary code that works. See thread at:
https://www.redhat.com/archives/utrace-devel/2009-February/msg00005.html

Ananth
