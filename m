Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbYF0Nf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbYF0Nf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYF0NfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:35:19 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:54843 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752838AbYF0NfR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:35:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApAFAK+IZEhMQWVt/2dsb2JhbACBW7Bl
Date: Fri, 27 Jun 2008 09:30:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC PATCH] Kernel Tracepoints
Message-ID: <20080627133009.GC13751@Krystal>
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48612879.5090809@redhat.com> <20080625235214.GA14249@Krystal> <486403F0.4020801@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <486403F0.4020801@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:17:51 up 22 days, 17:58,  3 users,  load average: 3.16, 3.78,
	4.72
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
 >
> > Implementation of kernel tracepoints. Inspired from the Linux Kernel Markers.
> 
> What would you think redesigning markers on tracepoints? because most of the
> logic (scaning sections, multiple probe and activation) seems very similar
> to markers.
> 

We could, although markers, because they use var args, allow to put the
iteration on the multi probe array out-of-line. Tracepoints cannot
afford this and the iteration must be done at the initial call-site.

>From what I see in your proposal, it's mostly to extract the if() call()
code from the inner __trace_mark() macro and to put it in a separate
macro, am I correct ? This would make the macro more readable.

> For example, (not complete, I just thought :-))
> 
>  struct tracepoint {
>  	const char *name;		/* Tracepoint name */
>  	DEFINE_IMV(char, state);	/* Immediate value state. */
>  	struct tracepoint_probe_closure *multi;	/* Closures */
> 	void * callsite_data;		/* private date from call site */
>  } __attribute__((aligned(8)));
> 
>  #define __tracepoint_block(generic, name, data, func, args)
>  	static const char __tpstrtab_##name[]			\
>  	__attribute__((section("__tracepoints_strings")))	\
>  	= #name;						\
>  	static struct tracepoint __tracepoint_##name		\
>  	__attribute__((section("__tracepoints"), aligned(8))) =	\
>  	{ __tpstrtab_##name, 0, NULL, data};			\
>  	if (!generic) {						\
>  		if (unlikely(imv_cond(__tracepoint_##name.state))) { \
>  			imv_cond_end();				\
>  			func(&__tracepoint_##name, args); \
>  		} else						\
>  			imv_cond_end();				\
>  	} else {						\
>  		if (unlikely(_imv_read(__tracepoint_##name.state))) \
>  			func(&__tracepoint_##name, args); \
>  	}
> 
>  struct marker {
>         const char *name;       /* Marker name */
>         const char *format;     /* Marker format string, describing the
>                                  * variable argument list.
>                                  */
>  } __attribute__((aligned(8)));
> 
>  #define trace_mark(name, fmt, args...)			\
>  do {							\
>  	static const char __mstrtab_##name[]		\
>  	__attribute__((section("__markers_strings")))	\
>  	= #name "\0" fmt;				\
>  	static struct marker __marker_##name		\
>  	__attribute__((section("__markers"), aligned(8))) =	\
>  	{ __mstrtab_##name, &__mstrtab_##name[sizeof(#name)]};	\ 	
>  	__tracepoint_block(1, name, __marker_##name, marker_probe_cb, args)	\
>  } while (0)
> 
> >
[...]
> > +	static inline int register_trace_##name(			\
> > +		void (*probe)(void *private_data, proto),		\
> > +		void *private_data)					\
> > +	{								\
> > +		return tracepoint_probe_register(#name, (void *)probe,	\
> > +			private_data);					\
> > +	}								\
> > +	static inline void unregister_trace_##name(			\
> > +		void (*probe)(void *private_data, proto),		\
> > +		void *private_data)					\
> > +	{								\
> > +		tracepoint_probe_unregister(#name, (void *)probe,	\
> > +			private_data);					\
> > +	}
> 
> Out of curiousity, what the private_data is for?
> 

When a probe is registered, it gives more flexibility to be able to pass
a pointer to private data associated with that probe. For instance, if a
tracer needs to register the same probe to many different tracepoints,
but having a different context associated with each, it will pass the
same function pointer with different private_data to the registration
function.

> > +
> > +extern void tracepoint_update_probe_range(struct tracepoint *begin,
> > +	struct tracepoint *end);
> > +
> > +#else /* !CONFIG_TRACEPOINTS */
> > +#define DEFINE_TRACE(name, proto, args)			\
> > +	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
> > +	{ }								\
> > +	static inline void __trace_##name(int generic, proto)		\
> > +	{ }								\
> > +	static inline void trace_##name(proto)				\
> > +	{ }								\
> > +	static inline void _trace_##name(proto)				\
> > +	{ }
> 
> By the way, I think you'd better add below two inlines.
> 
> 	static inline int register_trace_##name(			\
> 		void (*probe)(void *private_data, proto),		\
> 		void *private_data)					\
> 	{ return -ENOSYS; }
> 	static inline void unregister_trace_##name(			\
> 		void (*probe)(void *private_data, proto),		\
> 		void *private_data)					\
> 	{ }
> 

My original thought was that if tracepoints are disabled, the probe
objects should not even be built. But I can foresee that they will not
always be in separate objects, so it makes sense. Will add.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
