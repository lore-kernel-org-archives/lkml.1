Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbZDUHWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbZDUHWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZDUHWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:22:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37176 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbZDUHWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:22:05 -0400
Date: Tue, 21 Apr 2009 09:21:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       mingo@goodmis.org, Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC] Stupid tracepoint ideas
Message-ID: <20090421072147.GD22937@elte.hu>
References: <alpine.DEB.2.00.0904201456470.26147@gandalf.stny.rr.com> <20090420205438.GA11567@Krystal> <alpine.DEB.2.00.0904201702430.10097@gandalf.stny.rr.com> <20090420211249.GA12445@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420211249.GA12445@Krystal>
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > On Mon, 20 Apr 2009, Mathieu Desnoyers wrote:
> > 
> > > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > > 
> > > > Mathieu,
> > > > 
> > > > You may have tried this in your creation of tracepoints, but I figured I 
> > > > would ask before wasting too much time on it.
> > > > 
> > > > I'm looking at ways to make tracepoints even lighter weight when disabled. 
> > > > And I thought of doing section code. I'm playing with the following idea 
> > > > (see below patch) but I'm afraid gcc is allowed to think that the code it 
> > > > produces will not move to different sections.
> > > > 
> > > > Any thoughts on how we could do something similar to this.
> > > > 
> > > > Note, this patch is purely proof-of-concept. I'm fully aware that it is an 
> > > > x86 solution only.
> > > > 
> > > > -- Steve
> > > > 
> > > > [ no Signed-off-by: because this patch is crap ]
> > > > 
> > > > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > > > index 4353f3f..6953f78 100644
> > > > --- a/include/linux/tracepoint.h
> > > > +++ b/include/linux/tracepoint.h
> > > > @@ -65,9 +65,18 @@ struct tracepoint {
> > > >  	extern struct tracepoint __tracepoint_##name;			\
> > > >  	static inline void trace_##name(proto)				\
> > > >  	{								\
> > > > -		if (unlikely(__tracepoint_##name.state))		\
> > > > +		if (unlikely(__tracepoint_##name.state)) {		\
> > > > +			asm volatile ("jmp 43f\n"			\
> > > > +				      "42:\n"				\
> > > > +				      ".section .unlikely,\"ax\"\n"	\
> > > > +				      "43:\n"				\
> > > > +				      ::: "memory");			\
> > > >  			__DO_TRACE(&__tracepoint_##name,		\
> > > > -				TP_PROTO(proto), TP_ARGS(args));	\
> > > > +				   TP_PROTO(proto), TP_ARGS(args));	\
> > > > +			asm volatile ("jmp 42b\n"			\
> > > > +			     ".previous\n"				\
> > > > +			     ::: "memory");				\
> > > > +		}							\
> > > 
> > > You are right, I thought of this.
> > > 
> > > gcc forbids jumping outside of inline assembly statements. Optimisations
> > > done by gcc are not aware of this sort of execution flow modification,
> > > and gcc has every rights to interleave unrelated code between the two
> > > inline assembly statements.
> > 
> > Yeah, I was afraid of that :-/
> > 
> > Would be nice to apply sections to code:
> > 
> > 	__attribute__((section ".unlikely")) {
> > 		/* code for .unlikely section */
> > 	}
> > 
> > And have gcc do the jmps to and from the section.
> > 
> > This should not be too hard to implement.
> > 
> 
> Yes, but for some reason no kernel developer I know seems to be 
> very keen of digging into gcc's internals. :-)

There are some kernel developers who are also GCC developers - but i 
have to say the choice for a good developer is rather obvious: in 
the Linux kernel project the maximum latency until an obviously good 
patch hits upstream is around 3 months. In the GCC space the 
_minimum_ latency until an obviously good feature hits the compiler 
tends to be more like 2-3 years in the typical case.

I think the solution is obvious: the kernel needs its own compiler.

	Ingo
