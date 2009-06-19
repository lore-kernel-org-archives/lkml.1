Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbZFSD3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbZFSD3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 23:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZFSD32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 23:29:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41231 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbZFSD32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 23:29:28 -0400
Date: Thu, 18 Jun 2009 23:29:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, bligh@google.com,
       roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 3/7] add syscall tracepoints
In-Reply-To: <20090619015954.GA7903@nowhere>
Message-ID: <alpine.DEB.2.00.0906182327010.6890@gandalf.stny.rr.com>
References: <cover.1244837725.git.jbaron@redhat.com> <0ee4090012cf46f25d8cd8b022746a43b99d5767.1244837725.git.jbaron@redhat.com> <20090619015954.GA7903@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 19 Jun 2009, Frederic Weisbecker wrote:

> On Fri, Jun 12, 2009 at 05:24:49PM -0400, Jason Baron wrote:
> > 
> > Introduce a new 'DECLARE_TRACE_REG()' macro, so that tracepoints can associate
> > an external register/unregister function.
> > 
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> > 
> > ---
> >  include/linux/tracepoint.h |   27 +++++++++++++++++++++++----
> >  1 files changed, 23 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> > index 14df7e6..9a3660b 100644
> > --- a/include/linux/tracepoint.h
> > +++ b/include/linux/tracepoint.h
> > @@ -61,7 +61,7 @@ struct tracepoint {
> >   * not add unwanted padding between the beginning of the section and the
> >   * structure. Force alignment to the same alignment as the section start.
> >   */
> > -#define DECLARE_TRACE(name, proto, args)				\
> > +#define DECLARE_TRACE_REG(name, proto, args, reg, unreg)		\
> 
> 
> 
> May be it deserves a comment? DECLARE_TRACE_REG() as a name is not enough
> obvious on its own :)

I agree. I was talking with Christoph Hellwig about doing something 
similar with TRACE_EVENT, since he needs to do special things when enabled 
and disabled (like enable other trace points).

But anyway, I totally NAK the name. What about something like 
DECLARE_TRACE_WITH_CALLBACK()

Yes, it is a bit more verbose, but it at least tells what it does. The 
first thing that came to my mind when I saw DECLARE_TRACE_REG, was that 
this trace point will pass in "regs" to do things like backtraces.

-- Steve

> 
> 
> 
> >  	extern struct tracepoint __tracepoint_##name;			\
> >  	static inline void trace_##name(proto)				\
> >  	{								\
> > @@ -71,13 +71,29 @@ struct tracepoint {
> >  	}								\
> >  	static inline int register_trace_##name(void (*probe)(proto))	\
> >  	{								\
> > -		return tracepoint_probe_register(#name, (void *)probe);	\
> > +		int ret;						\
> > +		void (*func)(void) = (void (*)(void))reg;		\
> > +									\
> > +		ret = tracepoint_probe_register(#name, (void *)probe);	\
> > +		if (func && !ret)					\
> > +			func();						\
> > +		return ret;						\
> >  	}								\
> >  	static inline int unregister_trace_##name(void (*probe)(proto))	\
> >  	{								\
> > -		return tracepoint_probe_unregister(#name, (void *)probe);\
> > +		int ret;						\
> > +		void (*func)(void) = (void (*)(void))unreg;		\
> > +									\
> > +		ret = tracepoint_probe_unregister(#name, (void *)probe);\
> > +		if (func && !ret)					\
> > +			func();						\
> > +		return ret;						\
> >  	}
> >  
> > +
> > +#define DECLARE_TRACE(name, proto, args)		\
> > +	DECLARE_TRACE_REG(name, TP_PROTO(proto), TP_ARGS(args), 0, 0);
> > +
> >  #define DEFINE_TRACE(name)						\
> >  	static const char __tpstrtab_##name[]				\
> >  	__attribute__((section("__tracepoints_strings"))) = #name;	\
> > @@ -94,7 +110,7 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
> >  	struct tracepoint *end);
> >  
> >  #else /* !CONFIG_TRACEPOINTS */
> > -#define DECLARE_TRACE(name, proto, args)				\
> > +#define DECLARE_TRACE_REG(name, proto, args, reg, unreg)		\
> >  	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
> >  	{ }								\
> >  	static inline void trace_##name(proto)				\
> > @@ -108,6 +124,9 @@ extern void tracepoint_update_probe_range(struct tracepoint *begin,
> >  		return -ENOSYS;						\
> >  	}
> >  
> > +#define DECLARE_TRACE(name, proto, args)                \
> > +	DECLARE_TRACE_REG(name, TP_PROTO(proto), TP_ARGS(args), 0, 0);
> > +
> >  #define DEFINE_TRACE(name)
> >  #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
> >  #define EXPORT_TRACEPOINT_SYMBOL(name)
> > -- 
> > 1.6.0.6
> > 
> 
> 
