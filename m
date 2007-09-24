Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbXIXSsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbXIXSsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761813AbXIXSsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:48:22 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:35063 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761414AbXIXSsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:48:20 -0400
Date: Mon, 24 Sep 2007 14:43:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [patch 4/7] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070924184309.GB28347@Krystal>
References: <20070924164950.006047409@polymtl.ca> <20070924165427.717587684@polymtl.ca> <20070924174817.GB1608@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070924174817.GB1608@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:11:09 up 56 days, 18:30,  6 users,  load average: 0.51, 0.76, 1.00
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Hellwig (hch@infradead.org) wrote:
> On Mon, Sep 24, 2007 at 12:49:54PM -0400, Mathieu Desnoyers wrote:
> > +struct __mark_marker {
> > +	const char *name;	/* Marker name */
> > +	const char *format;	/* Marker format string, describing the
> > +				 * variable argument list.
> > +				 */
> > +	char state;		/* Marker state. */
> > +	marker_probe_func *call;/* Probe handler function pointer */
> > +	void *pdata;		/* Private probe data */
> 
> This is normally called private in the kernel, and keeping this
> consistant would be nice.
> 

Ok, fixing.

> > +} __attribute__((aligned(8)));
> 
> Why do we care about the alignment here?
> 

Because we want to be really-really-really sure GCC won't align this
structure on 32 bytes. Here is the problematic scenario:

Developer A adds a few fields to struct __mark_marker, making it 32
bytes in size.
include/asm-generic/vmlinux.lds.h specifies 

        . = ALIGN(8);                                                   \
        VMLINUX_SYMBOL(__start___markers) = .;                          \
        *(__markers)                                                    \
        VMLINUX_SYMBOL(__stop___markers) = .;

Therefore, the __start___markers "begin" iterator will always be 8 bytes
aligned, but if GCC decides to align the structures on 32 bytes, we can
end up with padding at the beginning of our iterator.

Therefore, to make sure there won't be any unforeseen side-effect of any
changes to this structure, I specify the structure alignment there.

> > +/* To be used for string format validity checking with gcc */
> > +static inline void __attribute__ ((format (printf, 1, 2)))
> > +	__mark_check_format(const char *fmt, ...) { }
> 
> Please put each of the curly braces on a line of it's own, so it's
> clear this is an empty inline from the 1000 feet few, as it first
> looks like a prototype.  Also aren't __attributes__ normally afer
> the function identifier, ala:
> 

Ok, fixing __mark_empty_function too for the braces.

> static inline void __mark_check_format(const char *fmt, ...)
> 		__attribute__ ((format (printf, 1, 2)))
> {
> }
> 
> or is this after notation only for prototypes but not actual implementations?
> (yeah, gnu C extensions sometimes have syntax that odd)
> 

Build error 

In file included from include/linux/module.h:19,
                 from include/linux/crypto.h:22,
                 from arch/i386/kernel/asm-offsets.c:8:
include/linux/marker.h:106: error: expected ',' or ';' before '{' token
distcc[3903] ERROR: compile arch/i386/kernel/asm-offsets.c on dijkstra failed

gcc doesn't like it if I put the attribute after the function in the
implementation. Should I leave it before or separate the prototype from
the implementation ?
> 
> > +#ifdef CONFIG_MARKERS
> > +void module_update_markers(struct module *probe_module, int *refcount)
> > +{
> > +	struct module *mod;
> > +
> > +	mutex_lock(&module_mutex);
> > +	list_for_each_entry(mod, &modules, list)
> > +		if (!mod->taints)
> > +			marker_update_probe_range(mod->markers,
> > +				mod->markers + mod->num_markers,
> > +				probe_module, refcount);
> > +	mutex_unlock(&module_mutex);
> > +}
> > +EXPORT_SYMBOL_GPL(module_update_markers);
> 
> Why is this exported?  The markers code is always built into the kernel,
> isn't it?
> 
> > +EXPORT_SYMBOL_GPL(module_get_iter_markers);
> 
> Same here.

Yep, good point. Fixing.

> > +void marker_update_probe_range(
> > +	struct __mark_marker *begin,
> > +	struct __mark_marker *end,
> > +	struct module *probe_module,
> > +	int *refcount)
> 
> void marker_update_probe_range(struct __mark_marker *begin,
> 		struct __mark_marker *end, struct module *probe_module,
> 		int *refcount)
> 

ok

> > +EXPORT_SYMBOL_GPL(marker_update_probe_range);
> 
> What is this one exported for?
> 

Only used by module.c, should not be exported.

> > +/*
> > + * Update probes, removing the faulty probes.
> > + * Issues a synchronize_sched() when no reference to the module passed
> > + * as parameter is found in the probes so the probe module can be
> > + * safely unloaded from now on.
> > + */
> > +static inline void marker_update_probes(struct module *probe_module)
> 
> no need to mark this inline, the compiler takes care of that for you
> if nessecary.
> 

I'll change all static inlines into static in kernel/marker.c
since, as you point out, gcc knows its job. I originally used all
"static inline" following a comment from Andrew.

> > +	int found = 0;
> > +
> > +	if (!*marker && begin != end) {
> > +		found = 1;
> > +		*marker = begin;
> > +	} else if (*marker >= begin && *marker < end) {
> > +		found = 1;
> > +		/*
> > +		 * *marker is known to be a valid marker from now on.
> > +		 */
> > +	}
> > +	return found;
> 
> 	if (!*marker && begin != end) {
> 		*marker = begin;
> 		return 1;
> 	}
> 
> 	if (*marker >= begin && *marker < end)
> 		return 1;
> 	return 0;
> 
> ?
> 

Clearly, this simple layout did not come out from the evolution of the
code. Will fix.

> 
> There seem to be a lot of exports and some functions that don't seem
> to be used by the obvious marker use-cases like your example, blktrace
> or sputrace.  Care to explain why we'd really want them or better cut
> them out for this first submission?

If you are referring to the exports you just told about in this email,
I'll remove them, they are not needed. As for the "marker_get_iter" and
friends, they are used to list the markers (I provide a /proc interface
to list the markers in the subsequent modules and also use it to dump
the marker list in a trace channel at trace start so I can later
understand the event data by using the format strings as type
identifiers).

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
