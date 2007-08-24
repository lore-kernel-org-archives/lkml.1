Return-Path: <linux-kernel-owner+w=401wt.eu-S1760025AbXHXQ1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbXHXQ1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755097AbXHXQ1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:27:00 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:56366 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754948AbXHXQ06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:26:58 -0400
Date: Fri, 24 Aug 2007 12:26:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070824162656.GC21226@Krystal>
References: <20070820202704.927923667@polymtl.ca> <20070820202758.850703563@polymtl.ca> <1187656987.19435.163.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1187656987.19435.163.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:59:02 up 25 days, 16:17,  6 users,  load average: 0.54, 0.56, 0.59
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Mon, 2007-08-20 at 16:27 -0400, Mathieu Desnoyers wrote:
> > The marker activation functions sits in kernel/marker.c. A hash table is used
> > to keep track of the registered probes and armed markers, so the markers within
> > a newly loaded module that should be active can be activated at module load
> > time.
> 
> Hi Mathieu!
> 
> 	Just reading through this patch, a couple of comments:
> 

Hi Rusty,

> > +/* To be used for string format validity checking with gcc */
> > +static inline void __mark_check_format(const char *fmt, ...)
> > +		__attribute__ ((format (printf, 1, 2)));
> > +static inline void __mark_check_format(const char *fmt, ...) { }
> 
> If you place the __attribute__() before the function name, you can do
> this in the definition.
> 

Ok, will fix.

> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/module.c	2007-08-10 19:44:18.000000000 -0400
> > +++ linux-2.6-lttng/kernel/module.c	2007-08-10 23:54:38.000000000 -0400
> > @@ -1980,6 +1986,10 @@ static struct module *load_module(void _
> >  			sechdrs[immediateindex].sh_size / sizeof(*mod->immediate);
> >  	}
> >  #endif
> > +	if (markersindex)
> > +		sechdrs[markersindex].sh_flags |= SHF_ALLOC;
> > +	if (markersstringsindex)
> > +		sechdrs[markersstringsindex].sh_flags |= SHF_ALLOC;
> >  
> 
> Perhaps I'm missing something, but I don't see why these sections
> wouldn't be SHF_ALLOC already.
> 

Declaring variables with __attribute__((section("__markers_strings")))
will likely put them in an allocated section, you are right. Will fix.

The same applies to immediate values with .section __immediate, \"a\",
@progbits, which is explicitely allocated.

> >  	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
> >  	if (unusedcrcindex)
> > @@ -2021,6 +2031,13 @@ static struct module *load_module(void _
> >  		if (err < 0)
> >  			goto cleanup;
> >  	}
> > +#ifdef CONFIG_MARKERS
> > +	if (markersindex) {
> > +		mod->markers = (void *)sechdrs[markersindex].sh_addr;
> > +		mod->num_markers =
> > +			sechdrs[markersindex].sh_size / sizeof(*mod->markers);
> > +	}
> > +#endif
> 
> Because of the wonders of ELF, section 0 has sh_addr and sh_size 0.  So
> the if (markersindex) is unnecessary here.
> 

Ok. Will apply to immediate values too.

> > +/*
> > + * Get marker if the marker is present in the marker hash table.
> > + * Must be called with markers_mutex held.
> > + * Returns NULL if not present.
> > + */
> > +static struct marker_entry *_get_marker(const char *name)
> 
> You seem to really enjoy underscores, yet I'm having trouble
> understanding why this would have an underscore in it.
> 

Just they are internal functiona meant to be called with markers_mutex
held. But I guess having a static prefix and not being exported is
enough. Will remove. I'll just keep
_marker_update_probes/marker_update_probes to differentiate between
locked/non-locked version.

> > +{
> > +	struct hlist_head *head;
> > +	struct hlist_node *node;
> > +	struct marker_entry *e;
> > +	size_t len = strlen(name) + 1;
> > +	u32 hash = jhash(name, len-1, 0);
> > +
> > +	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
> > +	hlist_for_each_entry(e, node, head, hlist) {
> > +		if (!strcmp(name, e->name))
> > +			return e;
> > +	}
> > +	return NULL;
> > +}
> 
> OK, don't understand the strlen, len, len-1 dance here?
> 

Let's say we have abc\0 for marker name as name input.

len = 3 + 1 = 4 (including \0)
hash is done only on the 3 first chars, excluding the \0 (therefore the
                                                          len-1 there)

Actually, it's like this only for a matter of consistency between
add_marker and remove_marker, which are quite similar, but add_marker
needs name_len to include the \0 value. It would be odd to change the
logic between the two functions to one including the \0 and the other
excluding it.

> > +/*
> > + * Updates the probe callback corresponding to a range of markers.
> > + * Must be called with markers_mutex held.
> > + */
> > +static void _marker_update_probe_range(
> 
> And yet:
> 
> > +void module_marker_update(struct module *mod)
> > +{
> > +	if (!mod->taints)
> > +		_marker_update_probe_range(mod->markers,
> > +			mod->markers+mod->num_markers, NULL, NULL);
> > +}
> 
> This doesn't hold the markers_mutex.
> 

Since this function is only meant to be called upon module load, before
the module is added to the module list, this marker range cannot be seen
by other calls to marker_update_probe_range. But you are right. It also
protects the hash table, so I should take the mutex there.  Fixing.

Thanks for the review,

Mathieu

> Cheers,
> Rusty.
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
