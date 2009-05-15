Return-Path: <linux-kernel-owner+w=401wt.eu-S1757800AbZEOAUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800AbZEOAUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 20:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbZEOAUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 20:20:32 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:41696 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529AbZEOAUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 20:20:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B2C6ghkdZuEZuXnZr7ljYXWga+mOxOtSAnUcmUcjQWIZ1cd4oszdC0n9+w6jY7szAi
         jAFvRa5J/Z4AUMhNWVs9cHrRMzo09Ab/RkZP62dUP72TLwlWVNaiV60RFW4wzfjDr63U
         L7eGPaozXwjifGoxmc01EkazAtz9QVvFLvx8g=
Date: Fri, 15 May 2009 02:20:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] tracing: adding flags to events
Message-ID: <20090515002027.GB8051@nowhere>
References: <alpine.DEB.2.00.0905141535360.30591@gandalf.stny.rr.com> <20090514203351.GA5969@nowhere> <alpine.DEB.2.00.0905141916000.30591@gandalf.stny.rr.com> <20090514235846.GA8051@nowhere> <alpine.DEB.2.00.0905142000540.30591@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0905142000540.30591@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 08:01:20PM -0400, Steven Rostedt wrote:
> 
> 
> 
> On Fri, 15 May 2009, Frederic Weisbecker wrote:
> 
> > On Thu, May 14, 2009 at 07:18:23PM -0400, Steven Rostedt wrote:
> > > > > +
> > > > >  #undef TRACE_EVENT
> > > > >  #define TRACE_EVENT(call, proto, args, tstruct, assign, print)		\
> > > > >  enum print_line_t							\
> > > > > @@ -127,6 +132,7 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
> > > > >  	struct trace_seq *s = &iter->seq;				\
> > > > >  	struct ftrace_raw_##call *field;				\
> > > > >  	struct trace_entry *entry;					\
> > > > > +	struct trace_seq *p;						\
> > > > >  	int ret;							\
> > > > >  									\
> > > > >  	entry = iter->ent;						\
> > > > > @@ -138,7 +144,9 @@ ftrace_raw_output_##call(struct trace_iterator *iter, int flags)	\
> > > > >  									\
> > > > >  	field = (typeof(field))entry;					\
> > > > >  									\
> > > > > +	p = &get_cpu_var(ftrace_event_seq);				\
> > > > >  	ret = trace_seq_printf(s, #call ": " print);			\
> > > > > +	put_cpu();							\
> > > > 
> > > > 
> > > > 
> > > > I don't understand the role of this per-cpu trace_seq variable.
> > > > It doesn't seem to be used.
> > > 
> > > See it now? ;-)
> > 
> > 
> > Still not :-)
> > 
> > I don't understand, it doesn't seem to be used. May be I'm too
> > much sleepy to understand...
> 
> That's because you cut out an important detail ;-)
> 
> > > +#define __print_flags(flag, x...) ftrace_print_flags_seq(p, flag, x)
> 


Aah, ok.
Then it returns the seq buffer and matches the %s of the real
trace_seq_printf.

Wow tricky! And by disabling preemption and using per_cpu, we ensure it won't be
concurrently modified because we are in the read callback/always in user context.

Thanks, now I can go to sleep without this pain of doubt :)

