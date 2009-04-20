Return-Path: <linux-kernel-owner+w=401wt.eu-S1757143AbZDTVG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143AbZDTVG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:06:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756760AbZDTVGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:06:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43022 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbZDTVGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:06:16 -0400
Date: Mon, 20 Apr 2009 17:06:15 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, mingo@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC] Stupid tracepoint ideas
In-Reply-To: <20090420205438.GA11567@Krystal>
Message-ID: <alpine.DEB.2.00.0904201702430.10097@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0904201456470.26147@gandalf.stny.rr.com> <20090420205438.GA11567@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 20 Apr 2009, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > Mathieu,
> > 
> > You may have tried this in your creation of tracepoints, but I figured I 
> > would ask before wasting too much time on it.
> > 
> > I'm looking at ways to make tracepoints even lighter weight when disabled. 
> > And I thought of doing section code. I'm playing with the following idea 
> > (see below patch) but I'm afraid gcc is allowed to think that the code it 
> > produces will not move to different sections.
> > 
> > Any thoughts on how we could do something similar to this.
> > 
> > Note, this patch is purely proof-of-concept. I'm fully aware that it is an 
> > x86 solution only.
> > 
> > -- Steve
> > 
> > [ no Signed-off-by: because this patch is crap ]
> > 
> > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > index 4353f3f..6953f78 100644
> > --- a/include/linux/tracepoint.h
> > +++ b/include/linux/tracepoint.h
> > @@ -65,9 +65,18 @@ struct tracepoint {
> >  	extern struct tracepoint __tracepoint_##name;			\
> >  	static inline void trace_##name(proto)				\
> >  	{								\
> > -		if (unlikely(__tracepoint_##name.state))		\
> > +		if (unlikely(__tracepoint_##name.state)) {		\
> > +			asm volatile ("jmp 43f\n"			\
> > +				      "42:\n"				\
> > +				      ".section .unlikely,\"ax\"\n"	\
> > +				      "43:\n"				\
> > +				      ::: "memory");			\
> >  			__DO_TRACE(&__tracepoint_##name,		\
> > -				TP_PROTO(proto), TP_ARGS(args));	\
> > +				   TP_PROTO(proto), TP_ARGS(args));	\
> > +			asm volatile ("jmp 42b\n"			\
> > +			     ".previous\n"				\
> > +			     ::: "memory");				\
> > +		}							\
> 
> You are right, I thought of this.
> 
> gcc forbids jumping outside of inline assembly statements. Optimisations
> done by gcc are not aware of this sort of execution flow modification,
> and gcc has every rights to interleave unrelated code between the two
> inline assembly statements.

Yeah, I was afraid of that :-/

Would be nice to apply sections to code:

	__attribute__((section ".unlikely")) {
		/* code for .unlikely section */
	}

And have gcc do the jmps to and from the section.

This should not be too hard to implement.

> 
> And is it me or this sounds like an infinite loop ?
> 
> 42:
> ....
> jmp 42b
> 

Nope:

	jmp 43f
	42:
	.section ...
	43:
	jmp 42b
	.previous

is the same as:

	jmp 43f
	42:
	[...]


in the other section:

	43:
	jmp 42b

same as a return.

-- Steve

