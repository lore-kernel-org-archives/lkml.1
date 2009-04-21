Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbZDUPq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbZDUPq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 11:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZDUPqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 11:46:16 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:36437 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbZDUPqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 11:46:16 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYFAKKG7UlMQW1W/2dsb2JhbACBT9QKg3oG
Date: Tue, 21 Apr 2009 11:46:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       mingo@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Etienne Bergeron <etienne.bergeron@octasic.com>
Subject: Re: [RFC] Stupid tracepoint ideas
Message-ID: <20090421154610.GD3792@Krystal>
References: <alpine.DEB.2.00.0904201456470.26147@gandalf.stny.rr.com> <20090420205438.GA11567@Krystal> <alpine.DEB.2.00.0904201702430.10097@gandalf.stny.rr.com> <20090420211249.GA12445@Krystal> <20090421072147.GD22937@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090421072147.GD22937@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:35:45 up 52 days, 12:01,  2 users,  load average: 0.75, 0.61,
	0.59
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > 
> > > On Mon, 20 Apr 2009, Mathieu Desnoyers wrote:
> > > 
> > > > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > > > 
> > > > > Mathieu,
> > > > > 
> > > > > You may have tried this in your creation of tracepoints, but I figured I 
> > > > > would ask before wasting too much time on it.
> > > > > 
> > > > > I'm looking at ways to make tracepoints even lighter weight when disabled. 
> > > > > And I thought of doing section code. I'm playing with the following idea 
> > > > > (see below patch) but I'm afraid gcc is allowed to think that the code it 
> > > > > produces will not move to different sections.
> > > > > 
> > > > > Any thoughts on how we could do something similar to this.
> > > > > 
> > > > > Note, this patch is purely proof-of-concept. I'm fully aware that it is an 
> > > > > x86 solution only.
> > > > > 
> > > > > -- Steve
> > > > > 
> > > > > [ no Signed-off-by: because this patch is crap ]
> > > > > 
> > > > > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > > > > index 4353f3f..6953f78 100644
> > > > > --- a/include/linux/tracepoint.h
> > > > > +++ b/include/linux/tracepoint.h
> > > > > @@ -65,9 +65,18 @@ struct tracepoint {
> > > > >  	extern struct tracepoint __tracepoint_##name;			\
> > > > >  	static inline void trace_##name(proto)				\
> > > > >  	{								\
> > > > > -		if (unlikely(__tracepoint_##name.state))		\
> > > > > +		if (unlikely(__tracepoint_##name.state)) {		\
> > > > > +			asm volatile ("jmp 43f\n"			\
> > > > > +				      "42:\n"				\
> > > > > +				      ".section .unlikely,\"ax\"\n"	\
> > > > > +				      "43:\n"				\
> > > > > +				      ::: "memory");			\
> > > > >  			__DO_TRACE(&__tracepoint_##name,		\
> > > > > -				TP_PROTO(proto), TP_ARGS(args));	\
> > > > > +				   TP_PROTO(proto), TP_ARGS(args));	\
> > > > > +			asm volatile ("jmp 42b\n"			\
> > > > > +			     ".previous\n"				\
> > > > > +			     ::: "memory");				\
> > > > > +		}							\
> > > > 
> > > > You are right, I thought of this.
> > > > 
> > > > gcc forbids jumping outside of inline assembly statements. Optimisations
> > > > done by gcc are not aware of this sort of execution flow modification,
> > > > and gcc has every rights to interleave unrelated code between the two
> > > > inline assembly statements.
> > > 
> > > Yeah, I was afraid of that :-/
> > > 
> > > Would be nice to apply sections to code:
> > > 
> > > 	__attribute__((section ".unlikely")) {
> > > 		/* code for .unlikely section */
> > > 	}
> > > 
> > > And have gcc do the jmps to and from the section.
> > > 
> > > This should not be too hard to implement.
> > > 
> > 
> > Yes, but for some reason no kernel developer I know seems to be 
> > very keen of digging into gcc's internals. :-)
> 
> There are some kernel developers who are also GCC developers - but i 
> have to say the choice for a good developer is rather obvious: in 
> the Linux kernel project the maximum latency until an obviously good 
> patch hits upstream is around 3 months. In the GCC space the 
> _minimum_ latency until an obviously good feature hits the compiler 
> tends to be more like 2-3 years in the typical case.
> 
> I think the solution is obvious: the kernel needs its own compiler.
> 

Yeah, I've started noticing that players in a few specialized areas,
especially on embedded systems where SIMD is vastly required, are doing
their compiler from scratch rather than re-using gcc, given they don't
*need* to drag all the frontends and backends gcc supports. This, in
their case, makes development of new analysis much easier.

Maybe this is an area we should investigate as a community : adding a
compiler into the kernel tree, which could be itself compiled with the
gcc/intel compiler (for bootstrap) present on the system (with very few
optimizations if needed), which could then compile the kernel tree.

This way, we could take control of this key piece of infrastructure
which has many interactions with the kernel source. I wonder if, in the
end, we could end up saving time having the control on the compiler
rather than to try to do sketchy inline assembly hacks to work around
gcc's limitations.

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
