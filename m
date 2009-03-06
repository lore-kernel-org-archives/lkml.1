Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbZCFSlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbZCFSlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 13:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbZCFSlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 13:41:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:43928 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbZCFSlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 13:41:13 -0500
Date: Fri, 6 Mar 2009 13:41:05 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       ltt-dev@lists.casi.polymtl.ca, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Martin Bligh <mbligh@google.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       mrubin@google.com, md@google.com
Subject: Re: [RFC patch 02/41] LTTng - core data structures
In-Reply-To: <20090305225511.794620538@polymtl.ca>
Message-ID: <alpine.DEB.2.00.0903061340030.23248@gandalf.stny.rr.com>
References: <20090305224728.947235917@polymtl.ca> <20090305225511.794620538@polymtl.ca>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Mar 2009, Mathieu Desnoyers wrote:

> Home of the traces data structures. Needs to be built into the kernel.
> 
> LTT heartbeat is a module specialized into firing periodical interrupts to
> record events in traces (so cycle counter rollover can be detected) and to
> update the 64 bits "synthetic TSC" (extended from the CPU 32 bits TSC on MIPS).
> Also needs to be built into the kernel.

Why is patch 1 and 2 separate. They look like they should be a single 
patch. Patch 1 is pretty useless by itself. This patch depends on patch 1.

-- Steve



> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> ---
>  MAINTAINERS              |    7 +++
>  include/linux/ltt-core.h |   10 ++++
>  ltt/ltt-core.c           |  101 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 118 insertions(+)
> 
> Index: linux-2.6-lttng/MAINTAINERS
> ===================================================================
> --- linux-2.6-lttng.orig/MAINTAINERS	2009-03-04 13:24:38.000000000 -0500
> +++ linux-2.6-lttng/MAINTAINERS	2009-03-04 13:24:59.000000000 -0500
> @@ -2766,6 +2766,13 @@ P:	Eric Piel
>  M:	eric.piel@tremplin-utc.net
>  S:	Maintained
>  
> +LINUX TRACE TOOLKIT NEXT GENERATION
> +P:	Mathieu Desnoyers
> +M:	mathieu.desnoyers@polymtl.ca
> +L:	ltt-dev@lttng.org
> +W:	http://ltt.polymtl.ca
> +S:	Maintained
> +
>  LM83 HARDWARE MONITOR DRIVER
>  P:	Jean Delvare
>  M:	khali@linux-fr.org
> Index: linux-2.6-lttng/ltt/ltt-core.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/ltt/ltt-core.c	2009-03-04 13:36:17.000000000 -0500
> @@ -0,0 +1,101 @@
> +/*
> + * LTT core in-kernel infrastructure.
> + *
> + * Copyright 2006 - Mathieu Desnoyers mathieu.desnoyers@polymtl.ca
> + *
> + * Distributed under the GPL license
> + */
> +
> +#include <linux/ltt-core.h>
> +#include <linux/percpu.h>
> +#include <linux/module.h>
> +#include <linux/debugfs.h>
> +#include <linux/kref.h>
> +
> +/* Traces structures */
> +struct ltt_traces ltt_traces = {
> +	.setup_head = LIST_HEAD_INIT(ltt_traces.setup_head),
> +	.head = LIST_HEAD_INIT(ltt_traces.head),
> +};
> +EXPORT_SYMBOL(ltt_traces);
> +
> +/* Traces list writer locking */
> +static DEFINE_MUTEX(ltt_traces_mutex);
> +
> +/* root dentry mutex */
> +static DEFINE_MUTEX(ltt_root_mutex);
> +/* dentry of ltt's root dir */
> +static struct dentry *ltt_root_dentry;
> +static struct kref ltt_root_kref = {
> +	.refcount = ATOMIC_INIT(0),
> +};
> +
> +static void ltt_root_release(struct kref *ref)
> +{
> +	debugfs_remove(ltt_root_dentry);
> +	ltt_root_dentry = NULL;
> +}
> +
> +void put_ltt_root(void)
> +{
> +	mutex_lock(&ltt_root_mutex);
> +	if (ltt_root_dentry)
> +		kref_put(&ltt_root_kref, ltt_root_release);
> +	mutex_unlock(&ltt_root_mutex);
> +}
> +EXPORT_SYMBOL_GPL(put_ltt_root);
> +
> +struct dentry *get_ltt_root(void)
> +{
> +	mutex_lock(&ltt_root_mutex);
> +	if (!ltt_root_dentry) {
> +		ltt_root_dentry = debugfs_create_dir(LTT_ROOT, NULL);
> +		if (!ltt_root_dentry) {
> +			printk(KERN_ERR "LTT : create ltt root dir failed\n");
> +			goto out;
> +		}
> +		kref_init(&ltt_root_kref);
> +		goto out;
> +	}
> +	kref_get(&ltt_root_kref);
> +out:
> +	mutex_unlock(&ltt_root_mutex);
> +	return ltt_root_dentry;
> +}
> +EXPORT_SYMBOL_GPL(get_ltt_root);
> +
> +void ltt_lock_traces(void)
> +{
> +	mutex_lock(&ltt_traces_mutex);
> +}
> +EXPORT_SYMBOL_GPL(ltt_lock_traces);
> +
> +void ltt_unlock_traces(void)
> +{
> +	mutex_unlock(&ltt_traces_mutex);
> +}
> +EXPORT_SYMBOL_GPL(ltt_unlock_traces);
> +
> +DEFINE_PER_CPU(unsigned int, ltt_nesting);
> +EXPORT_PER_CPU_SYMBOL(ltt_nesting);
> +
> +int ltt_run_filter_default(void *trace, uint16_t eID)
> +{
> +	return 1;
> +}
> +
> +/* This function pointer is protected by a trace activation check */
> +ltt_run_filter_functor ltt_run_filter = ltt_run_filter_default;
> +EXPORT_SYMBOL_GPL(ltt_run_filter);
> +
> +void ltt_filter_register(ltt_run_filter_functor func)
> +{
> +	ltt_run_filter = func;
> +}
> +EXPORT_SYMBOL_GPL(ltt_filter_register);
> +
> +void ltt_filter_unregister(void)
> +{
> +	ltt_run_filter = ltt_run_filter_default;
> +}
> +EXPORT_SYMBOL_GPL(ltt_filter_unregister);
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
