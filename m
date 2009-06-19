Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbZFSDlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbZFSDlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 23:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbZFSDkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 23:40:55 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:45928 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbZFSDky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 23:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hp8drfU2Vc0KeMtA4tXT3h5/dFNyX6FP7UqKu6G2YxWCTBGEIr5gBjDEO/oK7domvt
         UAPRlxNS5ZUpsaXEZ2PkPSUD5fDYxzW7QaTnVVfx5iqgZu6yCRJDgA7H56zZRHgg1Loa
         HkGVCx+HHvUIOCTzEOjwKAJncGGMjgV9YmVPU=
Date: Fri, 19 Jun 2009 05:40:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, bligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 3/7] add syscall tracepoints
Message-ID: <20090619034052.GJ7903@nowhere>
References: <cover.1244837725.git.jbaron@redhat.com> <0ee4090012cf46f25d8cd8b022746a43b99d5767.1244837725.git.jbaron@redhat.com> <20090619015954.GA7903@nowhere> <alpine.DEB.2.00.0906182327010.6890@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906182327010.6890@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 11:29:29PM -0400, Steven Rostedt wrote:
> 
> On Fri, 19 Jun 2009, Frederic Weisbecker wrote:
> 
> > On Fri, Jun 12, 2009 at 05:24:49PM -0400, Jason Baron wrote:
> > > 
> > > Introduce a new 'DECLARE_TRACE_REG()' macro, so that tracepoints can associate
> > > an external register/unregister function.
> > > 
> > > 
> > > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > > 
> > > ---
> > >  include/linux/tracepoint.h |   27 +++++++++++++++++++++++----
> > >  1 files changed, 23 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > > index 14df7e6..9a3660b 100644
> > > --- a/include/linux/tracepoint.h
> > > +++ b/include/linux/tracepoint.h
> > > @@ -61,7 +61,7 @@ struct tracepoint {
> > >   * not add unwanted padding between the beginning of the section and the
> > >   * structure. Force alignment to the same alignment as the section start.
> > >   */
> > > -#define DECLARE_TRACE(name, proto, args)				\
> > > +#define DECLARE_TRACE_REG(name, proto, args, reg, unreg)		\
> > 
> > 
> > 
> > May be it deserves a comment? DECLARE_TRACE_REG() as a name is not enough
> > obvious on its own :)
> 
> I agree. I was talking with Christoph Hellwig about doing something 
> similar with TRACE_EVENT, since he needs to do special things when enabled 
> and disabled (like enable other trace points).
> 
> But anyway, I totally NAK the name. What about something like 
> DECLARE_TRACE_WITH_CALLBACK()
> 
> Yes, it is a bit more verbose, but it at least tells what it does.


Yeah, sounds good.



> The first thing that came to my mind when I saw DECLARE_TRACE_REG, was that 
> this trace point will pass in "regs" to do things like backtraces.


Ah, the first thing that came to me was a tracepoint that did something
weird with a mysterious registry...and then my imagination got stucked
there.


Frederic.

 
> -- Steve
> 
> > 
> > 
> > 
> > >  	extern struct tracepoint __tracepoint_##name;			\
> > >  	static inline void trace_##name(proto)				\
> > >  	{								\
> > > @@ -71,13 +71,29 @@ struct tracepoint {
> > >  	}								\
> > >  	static inline int register_trace_##name(void (*probe)(proto))	\
> > >  	{								\
> > > -		return tracepoint_probe_register(#name, (void *)probe);	\
> > > +		int ret;						\
> > > +		void (*func)(void) = (void (*)(void))reg;		\
> > > +									\
> > > +		ret = tracepoint_probe_register(#name, (void *)probe);	\
> > > +		if (func && !ret)					\
> > > +			func();						\
> > > +		return ret;						\
> > >  	}								\
> > >  	static inline int unregister_trace_##name(void (*probe)(proto))	\
> > >  	{								\
> > > -		return tracepoint_probe_unregister(#name, (void *)probe);\
> > > +		int ret;						\
> > > +		void (*func)(void) = (void (*)(void))unreg;		\
> > > +									\
> > > +		ret = tracepoint_probe_unregister(#name, (void *)probe);\
> > > +		if (func && !ret)					\
> > > +			func();						\
> > > +		return ret;						\
> > >  	}
> > >  
> > > +
> > > +#define DECLARE_TRACE(name, proto, args)		\
> > > +	DECLARE_TRACE_REG(name, TP_PROTO(proto), TP_ARGS(args), 0, 0);
> > > +
> > >  #define DEFINE_TRACE(name)						\
> > >  	static const char __tpstrtab_##name[]				\
> > >  	__attribute__((section("__tracepoints_strings"))) = #name;	\
> > > @@ -94,7 +110,7 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
> > >  	struct tracepoint *end);
> > >  
> > >  #else /* !CONFIG_TRACEPOINTS */
> > > -#define DECLARE_TRACE(name, proto, args)				\
> > > +#define DECLARE_TRACE_REG(name, proto, args, reg, unreg)		\
> > >  	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
> > >  	{ }								\
> > >  	static inline void trace_##name(proto)				\
> > > @@ -108,6 +124,9 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
> > >  		return -ENOSYS;						\
> > >  	}
> > >  
> > > +#define DECLARE_TRACE(name, proto, args)                \
> > > +	DECLARE_TRACE_REG(name, TP_PROTO(proto), TP_ARGS(args), 0, 0);
> > > +
> > >  #define DEFINE_TRACE(name)
> > >  #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
> > >  #define EXPORT_TRACEPOINT_SYMBOL(name)
> > > -- 
> > > 1.6.0.6
> > > 
> > 
> > 

