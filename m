Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbZDNP5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbZDNP5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756595AbZDNPxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:53:50 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42196 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569AbZDNPxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:53:48 -0400
Date: Tue, 14 Apr 2009 08:53:27 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org, dipankar@in.ibm.com, mingo@elte.hu
Subject: Re: [PATCH] rculist.h: introduce list_entry_rcu and
	list_first_entry_rcu
Message-ID: <20090414155327.GG6753@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090414153356.GC3999@psychotron.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414153356.GC3999@psychotron.englab.brq.redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 05:33:57PM +0200, Jiri Pirko wrote:
> I've run into the situation where I need to use list_first_entry with
> rcu-guarded list. This patch introduces this. Also changed
> list_for_each_entry_rcu to use new list_entry_rcu instead of list_entry.
> 
> Jirka

Looks good -- and very nice list_entry_rcu() primitive!

There are a couple more places where this primitive could be applied.
I would welcome a patch for these as well.

include/linux/sched.h next_task 1986 #define next_task(p) list_entry(rcu_dereference((p)->tasks.next), struct task_struct, tasks)
include/linux/sched.h next_thread 2025 return list_entry(rcu_dereference(p->thread_group.next),
ipc/sem.c exit_sem 1293 un = list_entry(rcu_dereference(ulp->list_proc.next),

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> ---
>  include/linux/rculist.h |   30 ++++++++++++++++++++++++++++--
>  1 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index e649bd3..5710f43 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -198,6 +198,32 @@ static inline void list_splice_init_rcu(struct list_head *list,
>  	at->prev = last;
>  }
> 
> +/**
> + * list_entry_rcu - get the struct for this entry
> + * @ptr:        the &struct list_head pointer.
> + * @type:       the type of the struct this is embedded in.
> + * @member:     the name of the list_struct within the struct.
> + *
> + * This primitive may safely run concurrently with the _rcu list-mutation
> + * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
> + */
> +#define list_entry_rcu(ptr, type, member) \
> +	container_of(rcu_dereference(ptr), type, member)
> +
> +/**
> + * list_first_entry_rcu - get the first element from a list
> + * @ptr:        the list head to take the element from.
> + * @type:       the type of the struct this is embedded in.
> + * @member:     the name of the list_struct within the struct.
> + *
> + * Note, that list is expected to be not empty.
> + *
> + * This primitive may safely run concurrently with the _rcu list-mutation
> + * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
> + */
> +#define list_first_entry_rcu(ptr, type, member) \
> +	list_entry_rcu((ptr)->next, type, member)
> +
>  #define __list_for_each_rcu(pos, head) \
>  	for (pos = rcu_dereference((head)->next); \
>  		pos != (head); \
> @@ -214,9 +240,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
>   * as long as the traversal is guarded by rcu_read_lock().
>   */
>  #define list_for_each_entry_rcu(pos, head, member) \
> -	for (pos = list_entry(rcu_dereference((head)->next), typeof(*pos), member); \
> +	for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
>  		prefetch(pos->member.next), &pos->member != (head); \
> -		pos = list_entry(rcu_dereference(pos->member.next), typeof(*pos), member))
> +		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
> 
> 
>  /**
> -- 
> 1.6.0.6
> 
