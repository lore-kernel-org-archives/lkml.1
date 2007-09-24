Return-Path: <linux-kernel-owner+w=401wt.eu-S1760609AbXIXRsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760609AbXIXRsb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbXIXRsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:48:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48197 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629AbXIXRsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:48:22 -0400
Date: Mon, 24 Sep 2007 18:48:17 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 4/7] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070924174817.GB1608@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>
References: <20070924164950.006047409@polymtl.ca> <20070924165427.717587684@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070924165427.717587684@polymtl.ca>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 12:49:54PM -0400, Mathieu Desnoyers wrote:
> +struct __mark_marker {
> +	const char *name;	/* Marker name */
> +	const char *format;	/* Marker format string, describing the
> +				 * variable argument list.
> +				 */
> +	char state;		/* Marker state. */
> +	marker_probe_func *call;/* Probe handler function pointer */
> +	void *pdata;		/* Private probe data */

This is normally called private in the kernel, and keeping this
consistant would be nice.

> +} __attribute__((aligned(8)));

Why do we care about the alignment here?

> +/* To be used for string format validity checking with gcc */
> +static inline void __attribute__ ((format (printf, 1, 2)))
> +	__mark_check_format(const char *fmt, ...) { }

Please put each of the curly braces on a line of it's own, so it's
clear this is an empty inline from the 1000 feet few, as it first
looks like a prototype.  Also aren't __attributes__ normally afer
the function identifier, ala:

static inline void __mark_check_format(const char *fmt, ...)
		__attribute__ ((format (printf, 1, 2)))
{
}

or is this after notation only for prototypes but not actual implementations?
(yeah, gnu C extensions sometimes have syntax that odd)


> +#ifdef CONFIG_MARKERS
> +void module_update_markers(struct module *probe_module, int *refcount)
> +{
> +	struct module *mod;
> +
> +	mutex_lock(&module_mutex);
> +	list_for_each_entry(mod, &modules, list)
> +		if (!mod->taints)
> +			marker_update_probe_range(mod->markers,
> +				mod->markers + mod->num_markers,
> +				probe_module, refcount);
> +	mutex_unlock(&module_mutex);
> +}
> +EXPORT_SYMBOL_GPL(module_update_markers);

Why is this exported?  The markers code is always built into the kernel,
isn't it?

> +EXPORT_SYMBOL_GPL(module_get_iter_markers);

Same here.

> +/*
> + * Add the marker to the marker hash table. Must be called with markers_mutex
> + * held.
> + */
> +static int add_marker(const char *name,
> +	const char *format, marker_probe_func *probe, void *pdata)

static int add_marker(const char *name, const char *format,
		marker_probe_func *probe, void *private)

> +void marker_update_probe_range(
> +	struct __mark_marker *begin,
> +	struct __mark_marker *end,
> +	struct module *probe_module,
> +	int *refcount)

void marker_update_probe_range(struct __mark_marker *begin,
		struct __mark_marker *end, struct module *probe_module,
		int *refcount)

> +EXPORT_SYMBOL_GPL(marker_update_probe_range);

What is this one exported for?

> +/*
> + * Update probes, removing the faulty probes.
> + * Issues a synchronize_sched() when no reference to the module passed
> + * as parameter is found in the probes so the probe module can be
> + * safely unloaded from now on.
> + */
> +static inline void marker_update_probes(struct module *probe_module)

no need to mark this inline, the compiler takes care of that for you
if nessecary.

> +int marker_get_iter_range(struct __mark_marker **marker,
> +	struct __mark_marker *begin,
> +	struct __mark_marker *end)

int marker_get_iter_range(struct __mark_marker **marker,
		struct __mark_marker *begin, struct __mark_marker *end)

> +	int found = 0;
> +
> +	if (!*marker && begin != end) {
> +		found = 1;
> +		*marker = begin;
> +	} else if (*marker >= begin && *marker < end) {
> +		found = 1;
> +		/*
> +		 * *marker is known to be a valid marker from now on.
> +		 */
> +	}
> +	return found;

	if (!*marker && begin != end) {
		*marker = begin;
		return 1;
	}

	if (*marker >= begin && *marker < end)
		return 1;
	return 0;

?


There seem to be a lot of exports and some functions that don't seem
to be used by the obvious marker use-cases like your example, blktrace
or sputrace.  Care to explain why we'd really want them or better cut
them out for this first submission?
