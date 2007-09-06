Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbXIFXBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbXIFXBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 19:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932483AbXIFXB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 19:01:29 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19245 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932477AbXIFXB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 19:01:28 -0400
Date: Thu, 6 Sep 2007 16:00:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] Linux Kernel Markers - Architecture Independent
 Code
Message-Id: <20070906160001.cfe48d78.randy.dunlap@oracle.com>
In-Reply-To: <20070906200825.893834634@polymtl.ca>
References: <20070906200733.194442762@polymtl.ca>
	<20070906200825.893834634@polymtl.ca>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Sep 2007 16:07:34 -0400 Mathieu Desnoyers wrote:

> Changelog:
> - markers_mutex now nests inside module_mutex rather than the opposite.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Reviewed-by: Christoph Hellwig <hch@infradead.org>
> Reviewed-by: Rusty Russell <rusty@rustcorp.com.au>
> Reviewed-by: "Frank Ch. Eigler" <fche@redhat.com>

Documentation/SubmittingPatches recognizes Signed-off-by: and
Acked-by:.  Nothing about Reviewed-by.  Quote:

  Acked-by: is not as formal as Signed-off-by:.  It is a record that the acker
  has at least reviewed the patch and has indicated acceptance.

Reviewed-by: carries no such connotation or indication IMO.
Please use Acked-by if that's what these reviewers have done.


> ---
> 
>  include/asm-generic/vmlinux.lds.h |   11 
>  include/linux/marker.h            |  169 +++++++++
>  include/linux/module.h            |    5 
>  kernel/marker.c                   |  699 ++++++++++++++++++++++++++++++++++++++
>  kernel/module.c                   |   11 
>  5 files changed, 894 insertions(+), 1 deletion(-)


> Index: linux-2.6-lttng/include/linux/marker.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/include/linux/marker.h	2007-09-06 15:07:28.000000000 -0400
> @@ -0,0 +1,169 @@

> +/*
> + * Connect a probe to a markers.

                           marker.

> + * pdata must be a valid allocated memory address, or NULL.
> + */
> +extern int marker_probe_register(const char *name, const char *format,
> +				marker_probe_func *probe, void *pdata);

> Index: linux-2.6-lttng/kernel/marker.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/kernel/marker.c	2007-09-06 15:07:28.000000000 -0400
> @@ -0,0 +1,699 @@
> +/*
> + * Marker deferred synchronization.
> + * Upon marker probe_unregister, we delay call to synchronize_sched() to
> + * accelerate mass unregistration (only when there is no more reference to a
> + * give module do we call synchronize_sched()). However, we need to make sure

      given

> + * every critical region have ended before we re-arm a marker that has been

                            has

> + * unregistered and then registered back with a different probe data.
> + */
> +static int deferred_sync;
> +
> +/*
> + * Marker hash table, containing the active markers.
> + * Protected by module_mutex.
> + */
> +#define MARKER_HASH_BITS 6
> +#define MARKER_TABLE_SIZE (1 << MARKER_HASH_BITS)
> +
> +struct marker_entry {
> +	struct hlist_node hlist;
> +	char *format;
> +	marker_probe_func *probe;
> +	void *pdata;
> +	int refcount;	/* Number of times armed. 0 if disarmed. */
> +	char name[0];	/* Contains name'\0'format'\0' */
> +};
> +
> +static struct hlist_head marker_table[MARKER_TABLE_SIZE];
> +
> +/**
> + * __mark_empty_function - Empty probe callback
> + * @mdata: pointer of type const struct __mark_marker
> + * @fmt: format string
> + * @...: variable argument list
> + *
> + * Empty callback provided as a probe to the markers. By providing this to a
> + * disabled marker, we makes sure the  execution flow is always valid even

                          make

> + * though the function pointer change and the marker enabling are two distinct
> + * operations that modifies the execution flow of preemptible code.
> + */
> +void __mark_empty_function(const struct __mark_marker *mdata,
> +	void *private_data,
> +	const char *fmt, ...)
> +{ }
> +EXPORT_SYMBOL_GPL(__mark_empty_function);


> +/*
> + * Sets the probe callback corresponding to one marker.
> + */
> +static int set_marker(struct marker_entry **entry,
> +			struct __mark_marker *elem)
> +{
> +	int ret;
> +	BUG_ON(strcmp((*entry)->name, elem->name) != 0);

You can't return -ENOENT here?

> +
> +	if ((*entry)->format) {
> +		if (strcmp((*entry)->format, elem->format) != 0) {
> +			printk(KERN_NOTICE
> +				"Format mismatch for probe %s "
> +				"(%s), marker (%s)\n",
> +				(*entry)->name,
> +				(*entry)->format,
> +				elem->format);
> +			return -EPERM;
> +		}
> +	} else {
> +		ret = marker_set_format(entry, elem->format);
> +		if (ret)
> +			return ret;
> +	}
> +	elem->call = (*entry)->probe;
> +	elem->pdata = (*entry)->pdata;
> +	_immediate_set(&elem->state, 1);
> +	return 0;
> +}
> +
> +/*
> + * Disable a marker and its probe callback.
> + * Note: only after a synchronize_sched() issued after setting elem->call to the
> + * empty function insures that the original callback is not used anymore. This
> + * insured by preemption disabling around the call site.
> + */
> +static void disable_marker(struct __mark_marker *elem)
> +{
> +	_immediate_set(&elem->state, 0);
> +	elem->call = __mark_empty_function;
> +	/*
> +	 * Leave the pdata and id there, because removal is racy and should be
> +	 * done only after a synchronize_sched(). There are never used until

                                                  These

> +	 * the next initialization anyway.
> +	 */
> +}
> +

> +#ifdef CONFIG_MODULES
> +/*
> + * Update module probes.
> + * Must be called with markers_mutex held.
> + */
> +static inline void marker_update_probes_modules(struct module *probe_module,
> +	int *refcount)
> +{
> +	struct module *mod;
> +
> +	list_for_each_entry(mod, &modules, list) {
> +		if (!mod->taints) {
> +			marker_update_probe_range(mod->markers,
> +				mod->markers+mod->num_markers,
> +				probe_module, refcount);
> +		}
> +	}
> +}

hm, so if the module is tainted, markers won't be applied to it?
That's OK IMO.  However, I tend to think that something that
modifies code on the fly (like kprobes or text edit) should set some
flag somewhere so that when the system crashes, we can know that
code was modified.  This could be done via taints flags or some other
mechanism.  Has this already been discussed?


> +#else
> +static inline void marker_update_probes_modules(struct module *probe_module,
> +	int *refcount)
> +{ }
> +#endif
> +
> +/*
> + * Update probes, removing the faulty probes.
> + * Issues a synchronize_sched() when no reference to the module passed
> + * as parameter is found in the probes so the probe module can be
> + * safely unloaded from now on.
> + */
> +static inline void _marker_update_probes(struct module *probe_module)
> +{
> +	int refcount = 0;
> +
> +	/* Core kernel markers */
> +	marker_update_probe_range(__start___markers,
> +			__stop___markers, probe_module, &refcount);
> +	/* Markers in modules. */
> +	marker_update_probes_modules(probe_module, &refcount);
> +	if (probe_module && refcount == 0) {
> +		synchronize_sched();
> +		deferred_sync = 0;
> +	}
> +}

> +/**
> + * marker_probe_unregister -  Disconnect a probe from a marker

wrong function name above.

> + * @pdata: probe private data
> + *
> + * Unregister a marker by providing the registered pdata.
> + * Returns the pdata given to marker_probe_register, or an ERR_PTR().
> + */
> +void *marker_probe_unregister_pdata(void *pdata)
> +{
  ...
> +}
> +EXPORT_SYMBOL_GPL(marker_probe_unregister_pdata);

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
