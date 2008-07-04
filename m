Return-Path: <linux-kernel-owner+w=401wt.eu-S1758238AbYGDN5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238AbYGDN5T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 09:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYGDN5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 09:57:11 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:38636 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754141AbYGDN5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 09:57:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoEAJfEbUhMQWVt/2dsb2JhbACBXK8r
Date: Fri, 4 Jul 2008 09:57:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC patch 1/3] Kernel Tracepoints
Message-ID: <20080704135701.GA28494@Krystal>
References: <20080703160526.637679319@polymtl.ca> <20080703161102.721606976@polymtl.ca> <486D48E0.9010708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <486D48E0.9010708@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:33:53 up 29 days, 18:14,  4 users,  load average: 3.76, 2.30,
	1.45
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Hi Mathieu,
> 
> I couldn't apply this patch against 2.6.26-rc8, and have
> some trivial comments.
> 
> Mathieu Desnoyers wrote:
> > Implementation of kernel tracepoints. Inspired from the Linux Kernel Markers.
> > 
> > Allows complete typing verification. No format string required.
> > 
> > TODO : Documentation/tracepoint.txt
> > 
> > Changelog :
> > - Use #name ":" #proto as string to identify the tracepoint in the
> >   tracepoint table. This will make sure not type mismatch happens due to
> >   connexion of a probe with the wrong type to a tracepoint declared with
> >   the same name in a different header.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: 'Peter Zijlstra' <peterz@infradead.org>
> > CC: "Frank Ch. Eigler" <fche@redhat.com>
> > CC: 'Ingo Molnar' <mingo@elte.hu>
> > CC: 'Hideo AOKI' <haoki@redhat.com>
> > CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
> > CC: 'Steven Rostedt' <rostedt@goodmis.org>
> > CC: Alexander Viro <viro@zeniv.linux.org.uk>
> > ---
> >  include/asm-generic/vmlinux.lds.h |    6 
> >  include/linux/module.h            |   17 +
> >  include/linux/tracepoint.h        |  139 ++++++++++
> >  init/Kconfig                      |   16 +
> >  kernel/Makefile                   |    1 
> >  kernel/module.c                   |   66 ++++-
> >  kernel/tracepoint.c               |  498 ++++++++++++++++++++++++++++++++++++++
> >  7 files changed, 741 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6-lttng/init/Kconfig
> > ===================================================================
> > --- linux-2.6-lttng.orig/init/Kconfig	2008-07-03 11:47:15.000000000 -0400
> > +++ linux-2.6-lttng/init/Kconfig	2008-07-03 11:49:54.000000000 -0400
> > @@ -782,12 +782,28 @@ config PROFILING
> >  	  Say Y here to enable the extended profiling support mechanisms used
> >  	  by profilers such as OProfile.
> >  
> > +config TRACEPOINTS
> > +	bool "Activate tracepoints"
> > +	default y
> > +	help
> > +	  Place an empty function call at each tracepoint site. Can be
> > +	  dynamically changed for a probe function.
> > +
> >  config MARKERS
> >  	bool "Activate markers"
> >  	help
> >  	  Place an empty function call at each marker site. Can be
> >  	  dynamically changed for a probe function.
> >  
> > +config TRACEPROBES
> > +	tristate "Compile generic tracing probes"
> > +	depends on MARKERS
> > +	default y
> > +	help
> > +	  Compile generic tracing probes, which connect to the tracepoints when
> > +	  loaded and format the information collected by the tracepoints with
> > +	  the Markers.
> > +
> >  source "arch/Kconfig"
> 
> might this part better go to PATCH 3/3?
> 

Will fix.

> [...]
> > +
> > +
> > +#define TPPROTO(args...)	args
> > +#define TPARGS(args...)		args
> > +
> > +#ifdef CONFIG_TRACEPOINTS
> > +
> > +/*
> > + * Note : the empty asm volatile with read constraint is used here instead of a
> > + * "used" attribute to fix a gcc 4.1.x bug.
> 
> There seems no empty asm...
> 

True, should be removed from markers too.

> > + * Make sure the alignment of the structure in the __tracepoints section will
> > + * not add unwanted padding between the beginning of the section and the
> > + * structure. Force alignment to the same alignment as the section start.
> > + */
> > +#define DEFINE_TRACE(name, proto, args)					\
> > +	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
> > +	{								\
> > +		int i;							\
> > +		struct tracepoint_probe_closure *multi;			\
> > +		preempt_disable();					\
> > +		multi = tp->multi;					\
> > +		smp_read_barrier_depends();				\
> > +		if (multi) {						\
> > +			for (i = 0; multi[i].func; i++) {		\
> > +				((void(*)(void *private_data, proto))	\
> > +				(multi[i].func))(multi[i].probe_private, args);\
> > +			}						\
> > +		}							\
> > +		preempt_enable();					\
> > +	}								\
> > +	static inline void trace_##name(proto)				\
> > +	{								\
> > +		static const char __tpstrtab_##name[]			\
> > +		__attribute__((section("__tracepoints_strings")))	\
> > +		= #name ":" #proto;					\
> > +		static struct tracepoint __tracepoint_##name		\
> > +		__attribute__((section("__tracepoints"), aligned(8))) =	\
> > +		{ __tpstrtab_##name, 0, NULL };				\
> > +		if (unlikely(__tracepoint_##name.state))		\
> > +			_do_trace_##name(&__tracepoint_##name, args);	\
> > +	}								\
> > +	static inline int register_trace_##name(			\
> > +		void (*probe)(void *private_data, proto),		\
> > +		void *private_data)					\
> > +	{								\
> > +		return tracepoint_probe_register(#name ":" #proto,	\
> > +			(void *)probe, private_data);			\
> > +	}								\
> > +	static inline void unregister_trace_##name(			\
> > +		void (*probe)(void *private_data, proto),		\
> > +		void *private_data)					\
> > +	{								\
> > +		tracepoint_probe_unregister(#name ":" #proto,		\
> > +			(void *)probe, private_data);			\
> > +	}
> > +
> 
> As we are discussing on another thread, this macro can't handle
> non-argument tracepoint.
> 

Will fix.

> [...]
> > Index: linux-2.6-lttng/kernel/tracepoint.c
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-2.6-lttng/kernel/tracepoint.c	2008-07-03 11:54:30.000000000 -0400
> > @@ -0,0 +1,498 @@
> > +/*
> > + * Copyright (C) 2007 Mathieu Desnoyers
> 
> trivial: it should be 2008?  :-)
> 

I always have difficulty remembering the day of the week. Now years... :)

> [...]
> > Index: linux-2.6-lttng/kernel/module.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/module.c	2008-07-03 11:49:54.000000000 -0400
> > +++ linux-2.6-lttng/kernel/module.c	2008-07-03 11:54:01.000000000 -0400
> > @@ -46,6 +46,7 @@
> >  #include <asm/cacheflush.h>
> >  #include <linux/license.h>
> >  #include <asm/sections.h>
> > +#include <linux/tracepoint.h>
> >  
> >  #if 0
> >  #define DEBUGP printk
> > @@ -1770,6 +1771,8 @@ static struct module *load_module(void _
> >  	unsigned int unusedgplcrcindex;
> >  	unsigned int markersindex;
> >  	unsigned int markersstringsindex;
> > +	unsigned int tracepointsindex;
> > +	unsigned int tracepointsstringsindex;
> >  	struct module *mod;
> >  	long err = 0;
> >  	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
> > @@ -2049,6 +2052,9 @@ static struct module *load_module(void _
> >  	markersindex = find_sec(hdr, sechdrs, secstrings, "__markers");
> >   	markersstringsindex = find_sec(hdr, sechdrs, secstrings,
> >  					"__markers_strings");
> > +	tracepointsindex = find_sec(hdr, sechdrs, secstrings, "__tracepoints");
> > +	tracepointsstringsindex = find_sec(hdr, sechdrs, secstrings,
> > +					"__tracepoints_strings");
> >  
> >  	/* Now do relocations. */
> >  	for (i = 1; i < hdr->e_shnum; i++) {
> > @@ -2076,6 +2082,12 @@ static struct module *load_module(void _
> >  	mod->num_markers =
> >  		sechdrs[markersindex].sh_size / sizeof(*mod->markers);
> >  #endif
> > +#ifdef CONFIG_TRACEPOINTS
> > +	mod->tracepoints = (void *)sechdrs[tracepointsindex].sh_addr;
> > +	mod->num_tracepoints =
> > +		sechdrs[tracepointsindex].sh_size / sizeof(*mod->tracepoints);
> > +#endif
> > +
> >  
> >          /* Find duplicate symbols */
> >  	err = verify_export_symbols(mod);
> > @@ -2094,11 +2106,16 @@ static struct module *load_module(void _
> >  
> >  	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
> >  
> > +	if (!(mod->taints & TAINT_FORCED_MODULE)) {
> >  #ifdef CONFIG_MARKERS
> > -	if (!(mod->taints & TAINT_FORCED_MODULE))
> >  		marker_update_probe_range(mod->markers,
> >  			mod->markers + mod->num_markers);
> 
> Here, this hunk was rejected, because "Markers Support for
> Proprierary Modules" patch doesn't merged yet.
> 

Ok, I'll change the patch order.

> >  #endif
> > +#ifdef CONFIG_TRACEPOINTS
> > +		tracepoint_update_probe_range(mod->tracepoints,
> > +			mod->tracepoints + mod->num_tracepoints);
> > +#endif
> > +	}
> >  	err = module_finalize(hdr, sechdrs, mod);
> >  	if (err < 0)
> >  		goto cleanup;
> 
> Thank you,
> 

Thanks for the review,

Mathieu

> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America) Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
