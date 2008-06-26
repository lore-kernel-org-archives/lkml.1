Return-Path: <linux-kernel-owner+w=401wt.eu-S1761254AbYFZVEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761254AbYFZVEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 17:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbYFZVEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 17:04:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbYFZVEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 17:04:32 -0400
Message-ID: <486403F0.4020801@redhat.com>
Date: Thu, 26 Jun 2008 17:02:40 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC PATCH] Kernel Tracepoints
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48612879.5090809@redhat.com> <20080625235214.GA14249@Krystal>
In-Reply-To: <20080625235214.GA14249@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mathieu,

Thank you for making this so soon!

Mathieu Desnoyers wrote:
> ** note : this patch is submitted for early review. It applies after my
> current unreleased 2.6.26-rc8 LTTng patchset. Comments are welcome.

Would you mean there is no tree on which we can test this patch?

>
> Implementation of kernel tracepoints. Inspired from the Linux Kernel Markers.

What would you think redesigning markers on tracepoints? because most of the
logic (scaning sections, multiple probe and activation) seems very similar
to markers.

For example, (not complete, I just thought :-))

 struct tracepoint {
 	const char *name;		/* Tracepoint name */
 	DEFINE_IMV(char, state);	/* Immediate value state. */
 	struct tracepoint_probe_closure *multi;	/* Closures */
	void * callsite_data;		/* private date from call site */
 } __attribute__((aligned(8)));

 #define __tracepoint_block(generic, name, data, func, args)
 	static const char __tpstrtab_##name[]			\
 	__attribute__((section("__tracepoints_strings")))	\
 	= #name;						\
 	static struct tracepoint __tracepoint_##name		\
 	__attribute__((section("__tracepoints"), aligned(8))) =	\
 	{ __tpstrtab_##name, 0, NULL, data};			\
 	if (!generic) {						\
 		if (unlikely(imv_cond(__tracepoint_##name.state))) { \
 			imv_cond_end();				\
 			func(&__tracepoint_##name, args); \
 		} else						\
 			imv_cond_end();				\
 	} else {						\
 		if (unlikely(_imv_read(__tracepoint_##name.state))) \
 			func(&__tracepoint_##name, args); \
 	}

 struct marker {
        const char *name;       /* Marker name */
        const char *format;     /* Marker format string, describing the
                                 * variable argument list.
                                 */
 } __attribute__((aligned(8)));

 #define trace_mark(name, fmt, args...)			\
 do {							\
 	static const char __mstrtab_##name[]		\
 	__attribute__((section("__markers_strings")))	\
 	= #name "\0" fmt;				\
 	static struct marker __marker_##name		\
 	__attribute__((section("__markers"), aligned(8))) =	\
 	{ __mstrtab_##name, &__mstrtab_##name[sizeof(#name)]};	\ 	
 	__tracepoint_block(1, name, __marker_##name, marker_probe_cb, args)	\
 } while (0)

>
> Allows complete typing verification. No format string required.
>
> TODO : Documentation/tracepoint.txt
[...]
> +/*
> + * Note : the empty asm volatile with read constraint is used here instead of a
> + * "used" attribute to fix a gcc 4.1.x bug.as
> + * Make sure the alignment of the structure in the __markers section will
> + * not add unwanted padding between the beginning of the section and the
> + * structure. Force alignment to the same alignment as the section start.

this comment should be updated...

> + *
> + * The "generic" argument controls which marker enabling mechanism must be used.
> + * If generic is true, a variable read is used.
> + * If generic is false, immediate values are used.
> + */
> +#define DEFINE_TRACE(name, proto, args)					\
> +	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
> +	{								\
> +		int i;							\
> +		struct tracepoint_probe_closure *multi;			\
> +		preempt_disable();					\
> +		multi = tp->multi;					\
> +		smp_read_barrier_depends();				\
> +		if (multi) {						\
> +			for (i = 0; multi[i].func; i++) {		\
> +				((void(*)(void *private_data, proto))	\
> +				(multi[i].func))(multi[i].probe_private, args);\
> +			}						\
> +		}							\
> +		preempt_enable();					\
> +	}								\
> +	static inline void __trace_##name(int generic, proto)		\
> +	{								\
> +		static const char __tpstrtab_##name[]			\
> +		__attribute__((section("__tracepoints_strings")))	\
> +		= #name;						\
> +		static struct tracepoint __tracepoint_##name		\
> +		__attribute__((section("__tracepoints"), aligned(8))) =	\
> +		{ __tpstrtab_##name, 0, NULL };				\
> +		if (!generic) {						\
> +			if (unlikely(imv_cond(__tracepoint_##name.state))) { \
> +				imv_cond_end();				\
> +				_do_trace_##name(&__tracepoint_##name, args); \
> +			} else						\
> +				imv_cond_end();				\
> +		} else {						\
> +			if (unlikely(_imv_read(__tracepoint_##name.state))) \
> +				_do_trace_##name(&__tracepoint_##name, args); \
> +		}							\
> +	}								\
> +	static inline void trace_##name(proto)				\
> +	{								\
> +		__trace_##name(0, args);				\
> +	}								\
> +	static inline void _trace_##name(proto)				\
> +	{								\
> +		__trace_##name(1, args);				\
> +	}								\
> +	static inline int register_trace_##name(			\
> +		void (*probe)(void *private_data, proto),		\
> +		void *private_data)					\
> +	{								\
> +		return tracepoint_probe_register(#name, (void *)probe,	\
> +			private_data);					\
> +	}								\
> +	static inline void unregister_trace_##name(			\
> +		void (*probe)(void *private_data, proto),		\
> +		void *private_data)					\
> +	{								\
> +		tracepoint_probe_unregister(#name, (void *)probe,	\
> +			private_data);					\
> +	}

Out of curiousity, what the private_data is for?

> +
> +extern void tracepoint_update_probe_range(struct tracepoint *begin,
> +	struct tracepoint *end);
> +
> +#else /* !CONFIG_TRACEPOINTS */
> +#define DEFINE_TRACE(name, proto, args)			\
> +	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
> +	{ }								\
> +	static inline void __trace_##name(int generic, proto)		\
> +	{ }								\
> +	static inline void trace_##name(proto)				\
> +	{ }								\
> +	static inline void _trace_##name(proto)				\
> +	{ }

By the way, I think you'd better add below two inlines.

	static inline int register_trace_##name(			\
		void (*probe)(void *private_data, proto),		\
		void *private_data)					\
	{ return -ENOSYS; }
	static inline void unregister_trace_##name(			\
		void (*probe)(void *private_data, proto),		\
		void *private_data)					\
	{ }


> +
> +static inline void tracepoint_update_probe_range(struct tracepoint *begin,
> +	struct tracepoint *end)
> +{ }
> +#endif /* CONFIG_TRACEPOINTS */
> +
> +/*
> + * Connect a probe to a tracepoint.
> + * Internal API, should not be used directly.
> + */
> +extern int tracepoint_probe_register(const char *name,
> +	void *probe, void *probe_private);
> +
> +/*
> + * Disconnect a probe from a tracepoint.
> + * Internal API, should not be used directly.
> + */
> +extern int tracepoint_probe_unregister(const char *name,
> +	void *probe, void *probe_private);
> +
> +struct tracepoint_iter {
> +	struct module *module;
> +	struct tracepoint *tracepoint;
> +};
> +
> +extern void tracepoint_iter_start(struct tracepoint_iter *iter);
> +extern void tracepoint_iter_next(struct tracepoint_iter *iter);
> +extern void tracepoint_iter_stop(struct tracepoint_iter *iter);
> +extern void tracepoint_iter_reset(struct tracepoint_iter *iter);
> +extern int tracepoint_get_iter_range(struct tracepoint **tracepoint,
> +	struct tracepoint *begin, struct tracepoint *end);
> +
> +#endif
[...]


Best regards,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

