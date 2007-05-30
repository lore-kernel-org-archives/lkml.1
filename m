Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbXE3Udt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbXE3Udt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754555AbXE3Ud3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:33:29 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:47071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbXE3Ud1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:33:27 -0400
Date: Wed, 30 May 2007 13:32:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 2/9] Conditional Calls - Hash Table
Message-Id: <20070530133250.e0dd1f72.akpm@linux-foundation.org>
In-Reply-To: <20070530140227.398040643@polymtl.ca>
References: <20070530140025.917261793@polymtl.ca>
	<20070530140227.398040643@polymtl.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007 10:00:27 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Reimplementation of the cond calls which uses a hash table to hold the active
> cond_calls. It permits to first arm a cond_call and then load supplementary
> modules that contain this cond_call.

This patch so completely mangles [patch 1/9] that I'd suggest they be
merged together?

> Without this, the order of loading a module containing a cond_call and arming a
> cond_call matters and there is no symbol dependency to check this.
> 
> At module load time, each cond_call checks if it is enabled in the hash table
> and is set accordingly.
> 

<again wonders what a cond_call is, and how it works>

> Index: linux-2.6-lttng/kernel/module.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/module.c	2007-05-17 01:42:50.000000000 -0400
> +++ linux-2.6-lttng/kernel/module.c	2007-05-17 01:46:42.000000000 -0400
> @@ -33,6 +33,8 @@
>  #include <linux/moduleparam.h>
>  #include <linux/errno.h>
>  #include <linux/condcall.h>
> +#include <linux/jhash.h>
> +#include <linux/list.h>
>  #include <linux/err.h>
>  #include <linux/vermagic.h>
>  #include <linux/notifier.h>
> @@ -71,6 +73,20 @@
>  
>  static BLOCKING_NOTIFIER_HEAD(module_notify_list);
>  
> +#ifdef CONFIG_COND_CALL
> +/* Conditional call hash table, containing the active cond_calls.
> + * Protected by module_mutex. */
> +#define COND_CALL_HASH_BITS 6
> +#define COND_CALL_TABLE_SIZE (1 << COND_CALL_HASH_BITS)
> +
> +struct cond_call_entry {
> +	struct hlist_node hlist;
> +	char name[0];
> +};
> +
> +static struct hlist_head cond_call_table[COND_CALL_TABLE_SIZE];
> +#endif //CONFIG_COND_CALL

No //'s, please.

> +/* Remove the cond_call from the hash table. Must be called with mutex_lock
> + * held. */
> +static void hash_remove_cond_call(const char *name)
> +{
> +	struct hlist_head *head;
> +	struct hlist_node *node;
> +	struct cond_call_entry *e;
> +	int found = 0;
> +	size_t len = strlen(name);
> +	u32 hash = jhash(name, len, 0);
> +
> +	head = &cond_call_table[hash & ((1 << COND_CALL_HASH_BITS)-1)];
> +	hlist_for_each_entry(e, node, head, hlist)
> +		if (!strcmp(name, e->name)) {
> +			found = 1;
> +			break;
> +		}

Layout looks funny.  I'd suggest that the extra { and } be added.

> +	if (found) {
> +		hlist_del(&e->hlist);
> +		kfree(e);
> +	}
> +}

>  /* Set the enable bit of the cond_call, choosing the generic or architecture
>   * specific functions depending on the cond_call's flags.
> @@ -317,59 +395,53 @@
>  		return cond_call_generic_set_enable(address, enable);
>  }
>  
> -/* Query the state of a cond_calls range. */
> -static int _cond_call_query_range(const char *name,
> -	const struct __cond_call_struct *begin,
> -	const struct __cond_call_struct *end)
> +static int cond_call_get_enable(void *address, int flags)
> +{
> +	if (flags & CF_OPTIMIZED)
> +		return COND_CALL_OPTIMIZED_ENABLE(address);
> +	else
> +		return COND_CALL_GENERIC_ENABLE(address);
> +}

I don't get this bit.  Does CF_OPTIMIZED indicate that we're running on an
arch which has the hadn-optimised implentation?  If so, is it not the case
that _all_ cond_call sites will have CF_OPTIMIZED set?  And if so, why
would we need to perform this test at runtime?

(The preferred way of answering questions like this is via a suitable
comment in the next version of the patchset, btw.  So that others don't end
up wondering the same things).

> +static void module_cond_call_setup(struct module *mod)
> +{
> +}

I suppose that should have been inlined, although I expect the compiler
will do that anyway.


