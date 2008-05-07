Return-Path: <linux-kernel-owner+w=401wt.eu-S932551AbYEGUEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551AbYEGUEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676AbYEGUEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:04:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57294 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756965AbYEGUEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:04:12 -0400
Date: Wed, 7 May 2008 13:02:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: clameter@sgi.com, steiner@sgi.com, holt@sgi.com, npiggin@suse.de,
       a.p.zijlstra@chello.nl, kvm-devel@lists.sourceforge.net,
       kanojsarcar@yahoo.com, rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 01 of 11] mmu-notifier-core
Message-Id: <20080507130214.5884d94a.akpm@linux-foundation.org>
In-Reply-To: <e20917dcc8284b6a07cf.1210170951@duo.random>
References: <patchbomb.1210170950@duo.random>
	<e20917dcc8284b6a07cf.1210170951@duo.random>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 16:35:51 +0200
Andrea Arcangeli <andrea@qumranet.com> wrote:

> # HG changeset patch
> # User Andrea Arcangeli <andrea@qumranet.com>
> # Date 1210096013 -7200
> # Node ID e20917dcc8284b6a07cfcced13dda4cbca850a9c
> # Parent  5026689a3bc323a26d33ad882c34c4c9c9a3ecd8
> mmu-notifier-core
> 
> ...
>
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -747,7 +747,7 @@ static inline void hlist_del(struct hlis
>   * or hlist_del_rcu(), running on this same list.
>   * However, it is perfectly legal to run concurrently with
>   * the _rcu list-traversal primitives, such as
> - * hlist_for_each_entry().
> + * hlist_for_each_entry_rcu().
>   */
>  static inline void hlist_del_rcu(struct hlist_node *n)
>  {
> @@ -760,6 +760,34 @@ static inline void hlist_del_init(struct
>  	if (!hlist_unhashed(n)) {
>  		__hlist_del(n);
>  		INIT_HLIST_NODE(n);
> +	}
> +}
> +
> +/**
> + * hlist_del_init_rcu - deletes entry from hash list with re-initialization
> + * @n: the element to delete from the hash list.
> + *
> + * Note: list_unhashed() on entry does return true after this. It is

Should that be "does" or "does not".  "does", I suppose.

It should refer to hlist_unhashed()

The term "on entry" is a bit ambiguous - we normally use that as shorthand
to mean "on entry to the function".  

So I'll change this to

> + * Note: hlist_unhashed() on the node returns true after this. It is

OK?

<oh, that was copied-and-pasted from similarly errant comments in that file>

> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -10,6 +10,7 @@
>  #include <linux/rbtree.h>
>  #include <linux/rwsem.h>
>  #include <linux/completion.h>
> +#include <linux/cpumask.h>

OK, unrelated bugfix ;)

> --- a/include/linux/srcu.h
> +++ b/include/linux/srcu.h
> @@ -27,6 +27,8 @@
>  #ifndef _LINUX_SRCU_H
>  #define _LINUX_SRCU_H
>  
> +#include <linux/mutex.h>

And another.  Fair enough.

