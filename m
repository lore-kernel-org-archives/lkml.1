Return-Path: <linux-kernel-owner+w=401wt.eu-S1759347AbXIJRj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347AbXIJRj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 13:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754933AbXIJRjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 13:39:51 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47698 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871AbXIJRju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 13:39:50 -0400
Date: Mon, 10 Sep 2007 10:39:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] list.h: add list_for_each_entry_continue_rcu
Message-ID: <20070910173948.GD11801@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1189425947.4506.78.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189425947.4506.78.camel@johannes.berg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 02:05:47PM +0200, Johannes Berg wrote:
> To implement the multicast list callback in mac80211 we need to
> do partial list iteration. Since I want to convert the interface
> list to an RCU list, I need a new list walking primitive:
> list_for_each_entry_continue_rcu().
> 
> Additional help text was provided by Paul McKenney.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: linux-kernel@vger.kernel.org
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> ---
> John, I don't know if you want to merge this or not. There's no clear
> list.h maintainer and this patch is requisite for the bugfix I'm going
> to send in a minute so it'd probably be best if this goes into the tree
> together.
> If you don't want to take it, however, I have no idea how to handle the
> situation :)
> 
>  include/linux/list.h |   26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> --- wireless-dev.orig/include/linux/list.h	2007-09-07 22:00:41.234425862 +0200
> +++ wireless-dev/include/linux/list.h	2007-09-07 22:05:08.184425862 +0200
> @@ -665,6 +665,32 @@ static inline void list_splice_init_rcu(
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
> + *
> + * This list-traversal primitive may safely run concurrently with
> + * the _rcu list-mutation primitives such as list_add_rcu()
> + * as long as the traversal is guarded by rcu_read_lock().
> + *
> + * Note that the caller is responsible for making sure that
> + * the element remains in place between the earlier iterator
> + * and this one.  One way to do this is to ensure that
> + * both iterators are covered by the same rcu_read_lock(),
> + * while others involve reference counts, flags, or mutexes.
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
