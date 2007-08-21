Return-Path: <linux-kernel-owner+w=401wt.eu-S1762063AbXHUAns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762063AbXHUAns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 20:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXHUAnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 20:43:41 -0400
Received: from ozlabs.org ([203.10.76.45]:45536 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbXHUAnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 20:43:40 -0400
Subject: Re: [patch 1/4] Linux Kernel Markers - Architecture Independent
	Code
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070820202758.850703563@polymtl.ca>
References: <20070820202704.927923667@polymtl.ca>
	 <20070820202758.850703563@polymtl.ca>
Content-Type: text/plain
Date: Tue, 21 Aug 2007 10:43:07 +1000
Message-Id: <1187656987.19435.163.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-20 at 16:27 -0400, Mathieu Desnoyers wrote:
> The marker activation functions sits in kernel/marker.c. A hash table is used
> to keep track of the registered probes and armed markers, so the markers within
> a newly loaded module that should be active can be activated at module load
> time.

Hi Mathieu!

	Just reading through this patch, a couple of comments:

> +/* To be used for string format validity checking with gcc */
> +static inline void __mark_check_format(const char *fmt, ...)
> +		__attribute__ ((format (printf, 1, 2)));
> +static inline void __mark_check_format(const char *fmt, ...) { }

If you place the __attribute__() before the function name, you can do
this in the definition.

> ===================================================================
> --- linux-2.6-lttng.orig/kernel/module.c	2007-08-10 19:44:18.000000000 -0400
> +++ linux-2.6-lttng/kernel/module.c	2007-08-10 23:54:38.000000000 -0400
> @@ -1980,6 +1986,10 @@ static struct module *load_module(void _
>  			sechdrs[immediateindex].sh_size / sizeof(*mod->immediate);
>  	}
>  #endif
> +	if (markersindex)
> +		sechdrs[markersindex].sh_flags |= SHF_ALLOC;
> +	if (markersstringsindex)
> +		sechdrs[markersstringsindex].sh_flags |= SHF_ALLOC;
>  

Perhaps I'm missing something, but I don't see why these sections
wouldn't be SHF_ALLOC already.

>  	mod->unused_syms = (void *)sechdrs[unusedindex].sh_addr;
>  	if (unusedcrcindex)
> @@ -2021,6 +2031,13 @@ static struct module *load_module(void _
>  		if (err < 0)
>  			goto cleanup;
>  	}
> +#ifdef CONFIG_MARKERS
> +	if (markersindex) {
> +		mod->markers = (void *)sechdrs[markersindex].sh_addr;
> +		mod->num_markers =
> +			sechdrs[markersindex].sh_size / sizeof(*mod->markers);
> +	}
> +#endif

Because of the wonders of ELF, section 0 has sh_addr and sh_size 0.  So
the if (markersindex) is unnecessary here.

> +/*
> + * Get marker if the marker is present in the marker hash table.
> + * Must be called with markers_mutex held.
> + * Returns NULL if not present.
> + */
> +static struct marker_entry *_get_marker(const char *name)

You seem to really enjoy underscores, yet I'm having trouble
understanding why this would have an underscore in it.

> +{
> +	struct hlist_head *head;
> +	struct hlist_node *node;
> +	struct marker_entry *e;
> +	size_t len = strlen(name) + 1;
> +	u32 hash = jhash(name, len-1, 0);
> +
> +	head = &marker_table[hash & ((1 << MARKER_HASH_BITS)-1)];
> +	hlist_for_each_entry(e, node, head, hlist) {
> +		if (!strcmp(name, e->name))
> +			return e;
> +	}
> +	return NULL;
> +}

OK, don't understand the strlen, len, len-1 dance here?

> +/*
> + * Updates the probe callback corresponding to a range of markers.
> + * Must be called with markers_mutex held.
> + */
> +static void _marker_update_probe_range(

And yet:

> +void module_marker_update(struct module *mod)
> +{
> +	if (!mod->taints)
> +		_marker_update_probe_range(mod->markers,
> +			mod->markers+mod->num_markers, NULL, NULL);
> +}

This doesn't hold the markers_mutex.

Cheers,
Rusty.

