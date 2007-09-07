Return-Path: <linux-kernel-owner+w=401wt.eu-S1758378AbXIGPfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378AbXIGPfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 11:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbXIGPe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 11:34:57 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41704 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757469AbXIGPez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 11:34:55 -0400
Date: Fri, 7 Sep 2007 08:34:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Pavel Emelianov <xemul@openvz.org>, Zach Brown <zach.brown@oracle.com>,
       Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] list.h: add list_for_each_entry_continue_rcu
Message-ID: <20070907153453.GD8864@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1189175688.28781.167.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189175688.28781.167.camel@johannes.berg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2007 at 04:34:48PM +0200, Johannes Berg wrote:
> To implement the multicast list callback in mac80211 we need to
> do partial list iteration. Since I want to convert the interface
> list to an RCU list, I need a new list walking primitive:
> list_for_each_entry_continue_rcu().
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: linux-kernel@vger.kernel.org
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Pavel Emelianov <xemul@openvz.org>
> Cc: Zach Brown <zach.brown@oracle.com>
> Cc: Dave Jones <davej@redhat.com>
> Cc: Oleg Nesterov <oleg@tv-sign.ru>
> 
> ---
> How do we want to handle this? Is it ok to push this via net-2.6.24 so
> we can merge it along with the fix that needs it?
> 
>  include/linux/list.h |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> --- wireless-dev.orig/include/linux/list.h	2007-09-07 00:16:07.374444290 +0200
> +++ wireless-dev/include/linux/list.h	2007-08-29 21:08:14.802054000 +0200
> @@ -665,6 +665,26 @@ static inline void list_splice_init_rcu(
>  		prefetch(rcu_dereference((pos))->next), (pos) != (head); \
>          	(pos) = (pos)->next)
> 
> +
> +/**
> + * list_for_each_entry_continue_rcu - continue iteration over rcu list
> + * @pos:	the type * to use as a loop cursor.
> + * @head:	the head for your list.
> + * @member:	the name of the list_struct within the struct.
> + *
> + * Continue to iterate over rcu list of given type, continuing after
> + * the current position.

Please add something like the following to this comment:

	Note that the caller is responsible for making sure that
	the element remains in place between the earlier iterator
	and this one.  One way to do this is to ensure that
	both iterators are covered by the same rcu_read_lock(),
	while others involve reference counts, flags, or mutexes.

						Thanx, Paul

> + *
> + * This list-traversal primitive may safely run concurrently with
> + * the _rcu list-mutation primitives such as list_add_rcu()
> + * as long as the traversal is guarded by rcu_read_lock().
> + */
> +#define list_for_each_entry_continue_rcu(pos, head, member) \
> +	for ((pos) = list_entry((pos)->member.next, typeof(*pos), member); \
> +		prefetch(rcu_dereference((pos))->member.next), \
> +			 &pos->member != (head); \
> +        	(pos) = list_entry(pos->member.next, typeof(*pos), member))
> +
>  /*
>   * Double linked lists with a single pointer list head.
>   * Mostly useful for hash tables where the two pointer list head is
> 
> 
