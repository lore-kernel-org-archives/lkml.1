Return-Path: <linux-kernel-owner+w=401wt.eu-S1754916AbYGXPjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbYGXPjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 11:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYGXPjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 11:39:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37661 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbYGXPjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 11:39:04 -0400
Date: Thu, 24 Jul 2008 11:39:02 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [patch 02/17] Kernel Tracepoints
In-Reply-To: <20080715222746.361289615@polymtl.ca>
Message-ID: <Pine.LNX.4.58.0807241136420.14946@gandalf.stny.rr.com>
References: <20080715222604.331269462@polymtl.ca> <20080715222746.361289615@polymtl.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, 15 Jul 2008, Mathieu Desnoyers wrote:
> Index: linux-2.6-lttng/kernel/tracepoint.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/kernel/tracepoint.c	2008-07-15 17:35:00.000000000 -0400

[...]

> +/*
> + * Tracepoint hash table, containing the active tracepoints.
> + * Protected by tracepoints_mutex.
> + */
> +#define TRACEPOINT_HASH_BITS 6
> +#define TRACEPOINT_TABLE_SIZE (1 << TRACEPOINT_HASH_BITS)
> +

[...]

> +/*
> + * Get tracepoint if the tracepoint is present in the tracepoint hash table.
> + * Must be called with tracepoints_mutex held.
> + * Returns NULL if not present.
> + */
> +static struct tracepoint_entry *get_tracepoint(const char *name)
> +{
> +	struct hlist_head *head;
> +	struct hlist_node *node;
> +	struct tracepoint_entry *e;
> +	u32 hash = jhash(name, strlen(name), 0);
> +
> +	head = &tracepoint_table[hash & ((1 << TRACEPOINT_HASH_BITS)-1)];

Wouldn't it look nicer to have: (TRACEPOINT_TABLE_SIZE - 1) ?

  hash & (
> +	hlist_for_each_entry(e, node, head, hlist) {
> +		if (!strcmp(name, e->name))
> +			return e;
> +	}
> +	return NULL;
> +}
> +
> +/*
> + * Add the tracepoint to the tracepoint hash table. Must be called with
> + * tracepoints_mutex held.
> + */
> +static struct tracepoint_entry *add_tracepoint(const char *name)
> +{
> +	struct hlist_head *head;
> +	struct hlist_node *node;
> +	struct tracepoint_entry *e;
> +	size_t name_len = strlen(name) + 1;
> +	u32 hash = jhash(name, name_len-1, 0);
> +
> +	head = &tracepoint_table[hash & ((1 << TRACEPOINT_HASH_BITS)-1)];

here too.

> +	hlist_for_each_entry(e, node, head, hlist) {
> +		if (!strcmp(name, e->name)) {
> +			printk(KERN_NOTICE
> +				"tracepoint %s busy\n", name);
> +			return ERR_PTR(-EEXIST);	/* Already there */
> +		}
> +	}
> +	/*
> +	 * Using kmalloc here to allocate a variable length element. Could
> +	 * cause some memory fragmentation if overused.
> +	 */
> +	e = kmalloc(sizeof(struct tracepoint_entry) + name_len, GFP_KERNEL);
> +	if (!e)
> +		return ERR_PTR(-ENOMEM);
> +	memcpy(&e->name[0], name, name_len);
> +	e->funcs = NULL;
> +	e->refcount = 0;
> +	e->rcu_pending = 0;
> +	hlist_add_head(&e->hlist, head);
> +	return e;
> +}
> +
> +/*
> + * Remove the tracepoint from the tracepoint hash table. Must be called with
> + * mutex_lock held.
> + */
> +static int remove_tracepoint(const char *name)
> +{
> +	struct hlist_head *head;
> +	struct hlist_node *node;
> +	struct tracepoint_entry *e;
> +	int found = 0;
> +	size_t len = strlen(name) + 1;
> +	u32 hash = jhash(name, len-1, 0);
> +
> +	head = &tracepoint_table[hash & ((1 << TRACEPOINT_HASH_BITS)-1)];

here too.

> +	hlist_for_each_entry(e, node, head, hlist) {
> +		if (!strcmp(name, e->name)) {
> +			found = 1;
> +			break;
> +		}
> +	}
> +	if (!found)
> +		return -ENOENT;
> +	if (e->refcount)
> +		return -EBUSY;
> +	hlist_del(&e->hlist);
> +	/* Make sure the call_rcu has been executed */
> +	if (e->rcu_pending)
> +		rcu_barrier();
> +	kfree(e);
> +	return 0;
> +}

-- Steve
