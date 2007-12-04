Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbXLDTIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbXLDTIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 14:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbXLDTIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 14:08:14 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbXLDTIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 14:08:13 -0500
Date: Tue, 4 Dec 2007 11:06:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       hch@infradead.org, mmlnx@us.ibm.com, dipankar@in.ibm.com,
       dsmith@redhat.com, "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [patch 1/2] Linux Kernel Markers - Support Multiple Probes
Message-Id: <20071204110648.dd918789.akpm@linux-foundation.org>
In-Reply-To: <20071204182402.940135178@polymtl.ca>
References: <20071204181845.895090222@polymtl.ca>
	<20071204182402.940135178@polymtl.ca>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Dec 2007 13:18:46 -0500
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> RCU style multiple probes support for the Linux Kernel Markers.
> Common case (one probe) is still fast and does not require dynamic allocation
> or a supplementary pointer dereference on the fast path.
> 
> - Move preempt disable from the marker site to the callback.
> 
> Since we now have an internal callback, move the preempt disable/enable to the
> callback instead of the marker site.
> 
> Since the callback change is done asynchronously (passing from a handler that
> supports arguments to a handler that does not setup the arguments is no
> arguments are passed), we can safely update it even if it is outside the preempt
> disable section.
> 
> - Move probe arm to probe connection. Now, a connected probe is automatically
>   armed.
> 
> Remove MARK_MAX_FORMAT_LEN, unused.
> 
> This patch modifies the Linux Kernel Markers API : it removes the probe
> "arm/disarm" and changes the probe function prototype : it now expects a
> va_list * instead of a "...".
> 
> If we want to have more than one probe connected to a marker at a given
> time (LTTng, or blktrace, ssytemtap) then we need this patch. Without it,
> connecting a second probe handler to a marker will fail.
> 
> It allow us, for instance, to do interesting combinations :
> 
> Do standard tracing with LTTng and, eventually, to compute statistics
> with SystemTAP, or to have a special trigger on an event that would call
> a systemtap script which would stop flight recorder tracing.
> 
> ...
>
> +/*
> + * Note about RCU :

Paul cc'ed in case he has time to review this work...

> + * It is used to make sure every handler has finished using its private data
> + * between two consecutive operation (add or remove) on a given marker.  It is
> + * also used to delay the free of multiple probes array until a quiescent state
> + * is reached.
> + */
>  struct marker_entry {
>  	struct hlist_node hlist;
>  	char *format;
> -	marker_probe_func *probe;
> -	void *private;
> +	void (*call)(const struct marker *mdata,	/* Probe wrapper */
> +		void *call_private, const char *fmt, ...);
> +	struct marker_probe_closure single;
> +	struct marker_probe_closure *multi;
>  	int refcount;	/* Number of times armed. 0 if disarmed. */
> +	struct rcu_head rcu;
> +	void *oldptr;
> +	char rcu_pending:1;
> +	char ptype:1;

rcu_pending and ptype share the same word and modifications of one can
trash modifications of the other on a different cpu.  External locking is
needed to prevent this.  Is it present?  If so, it should be documented
right here in a comment.  If not, use plain-old-ints.


>  	char name[0];	/* Contains name'\0'format'\0' */
>  };
>  
> @@ -63,7 +69,8 @@ static struct hlist_head marker_table[MA
>  
>  /**
>   * __mark_empty_function - Empty probe callback
> - * @mdata: pointer of type const struct marker
> + * @probe_private: probe private data
> + * @call_private: call site private data
>   * @fmt: format string
>   * @...: variable argument list
>   *
> @@ -72,13 +79,262 @@ static struct hlist_head marker_table[MA
>   * though the function pointer change and the marker enabling are two distinct
>   * operations that modifies the execution flow of preemptible code.
>   */
> -void __mark_empty_function(const struct marker *mdata, void *private,
> -	const char *fmt, ...)
> +void __mark_empty_function(void *probe_private, void *call_private,
> +	const char *fmt, va_list *args)
>  {
>  }
>  EXPORT_SYMBOL_GPL(__mark_empty_function);
>  
>  /*
> + * marker_probe_cb Callback that prepares the variable argument list for probes.
> + * @mdata: pointer of type struct marker
> + * @call_private: caller site private data
> + * @fmt: format string
> + * @...:  Variable argument list.
> + *
> + * Since we do not use "typical" pointer based RCU in the 1 argument case, we
> + * need to put a full smp_rmb() in this branch. This is why we do not use
> + * rcu_dereference() for the pointer read.

hm.

> + */
> +void marker_probe_cb(const struct marker *mdata, void *call_private,
> +	const char *fmt, ...)
> +{
> +	va_list args;
> +	char ptype;
> +
> +	preempt_disable();

What are the preempt_disable()s doing in here?

Unless I missed something obvious, a comment is needed here (at least).

> +	ptype = ACCESS_ONCE(mdata->ptype);
> +	if (likely(!ptype)) {
> +		marker_probe_func *func;
> +		/* Must read the ptype before ptr. They are not data dependant,
> +		 * so we put an explicit smp_rmb() here. */
> +		smp_rmb();
> +		func = ACCESS_ONCE(mdata->single.func);
> +		/* Must read the ptr before private data. They are not data
> +		 * dependant, so we put an explicit smp_rmb() here. */
> +		smp_rmb();
> +		va_start(args, fmt);
> +		func(mdata->single.probe_private, call_private, fmt, &args);
> +		va_end(args);
> +	} else {
> +		struct marker_probe_closure *multi;
> +		int i;
> +		/*
> +		 * multi points to an array, therefore accessing the array
> +		 * depends on reading multi. However, even in this case,
> +		 * we must insure that the pointer is read _before_ the array
> +		 * data. Same as rcu_dereference, but we need a full smp_rmb()
> +		 * in the fast path, so put the explicit barrier here.
> +		 */
> +		smp_read_barrier_depends();
> +		multi = ACCESS_ONCE(mdata->multi);
> +		for (i = 0; multi[i].func; i++) {
> +			va_start(args, fmt);
> +			multi[i].func(multi[i].probe_private, call_private, fmt,
> +				&args);
> +			va_end(args);
> +		}
> +	}
> +	preempt_enable();
> +}
> +EXPORT_SYMBOL_GPL(marker_probe_cb);
>
> ...
>
> +static inline void debug_print_probes(struct marker_entry *entry)
> +{
> +	int i;
> +
> +	if (!marker_debug)
> +		return;
> +
> +	if (!entry->ptype) {
> +		printk(KERN_DEBUG "Single probe : %p %p\n",
> +			entry->single.func,
> +			entry->single.probe_private);
> +	} else {
> +		for (i = 0; entry->multi[i].func; i++)
> +			printk(KERN_DEBUG "Multi probe %d : %p %p\n", i,
> +				entry->multi[i].func,
> +				entry->multi[i].probe_private);
> +	}
> +}

argh, this has about six callsites.  It is vastly too large to inline.

> +static struct marker_probe_closure *
> +marker_entry_add_probe(struct marker_entry *entry,
> +		marker_probe_func *probe, void *probe_private)
> +{
> +	int nr_probes = 0;
> +	struct marker_probe_closure *old, *new;
> +
> +	WARN_ON(!probe);
> +
> +	debug_print_probes(entry);
> +	old = entry->multi;
> +	if (!entry->ptype) {
> +		if (entry->single.func == probe &&
> +				entry->single.probe_private == probe_private)
> +			return ERR_PTR(-EBUSY);
> +		if (entry->single.func == __mark_empty_function) {
> +			/* 0 -> 1 probes */
> +			entry->single.func = probe;
> +			entry->single.probe_private = probe_private;
> +			entry->refcount = 1;
> +			entry->ptype = 0;
> +			debug_print_probes(entry);
> +			return NULL;
> +		} else {
> +			/* 1 -> 2 probes */
> +			nr_probes = 1;
> +			old = NULL;
> +		}
> +	} else {
> +		/* (N -> N+1), (N != 0, 1) probes */
> +		for (nr_probes = 0; old[nr_probes].func; nr_probes++)
> +			if (old[nr_probes].func == probe
> +					&& old[nr_probes].probe_private
> +						== probe_private)
> +				return ERR_PTR(-EBUSY);
> +	}
> +	/* + 2 : one for new probe, one for NULL func */
> +	new = kzalloc((nr_probes + 2) * sizeof(struct marker_probe_closure),
> +			GFP_KERNEL);
> +	if (new == NULL)
> +		return ERR_PTR(-ENOMEM);
> +	if (!old)
> +		new[0] = entry->single;
> +	else
> +		memcpy(new, old,
> +			nr_probes * sizeof(struct marker_probe_closure));

could use krealloc here, although it isn't a very good fit.

> +	new[nr_probes].func = probe;
> +	new[nr_probes].probe_private = probe_private;
> +	entry->refcount = nr_probes + 1;
> +	entry->multi = new;
> +	entry->ptype = 1;
> +	debug_print_probes(entry);
> +	return old;
> +}
> +

