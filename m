Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbYJOB3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbYJOB3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 21:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYJOB3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 21:29:25 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33941 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbYJOB3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 21:29:24 -0400
Date: Tue, 14 Oct 2008 18:29:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: serue@us.ibm.com, sds@tycho.nsa.gov, jmorris@namei.org,
       chrisw@sous-sol.org, dhowells@redhat.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       haradats@nttdata.co.jp, akpm@linux-foundation.org
Subject: Re: [TOMOYO #10 (linux-next) 7/8] File operation restriction part.
Message-ID: <20081015012916.GF6874@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081009042814.398846861@nttdata.co.jp> <20081009042922.939610141@nttdata.co.jp> <20081009164836.GA5480@us.ibm.com> <200810120909.GDF95392.SQOFFFHVtOMOJL@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810120909.GDF95392.SQOFFFHVtOMOJL@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 09:09:40AM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Serge E. Hallyn wrote:
> > In a previous patch you mark funtions with 'begin/end critical section'.
> > Please instead put a comment on top listing precisely which locks
> > the fn expects to be held.
> > 
> > As for protecting your own data, please
> > 	1. explain at the var declaration what lock protects it
> > 	2. define the lock next to the list
> 
> OK. I added comments and simplified dependencies.
> http://svn.sourceforge.jp/cgi-bin/viewcvs.cgi/trunk/2.2.x/tomoyo-lsm/patches/?root=tomoyo
> Anything else we can do before reposting as #11?
> 
> Summary of locking is listed below.
> 
> (1) tmy_real_domain() requires the caller to hold tasklist_lock spinlock.
> (2) list1_add_tail_mb() requires the caller to hold a lock for protecting the
>     list.
> (3) All other functions can manage necessary locking using local locks declared
>     inside each functions, for read operation requires no locks and write
>     operation is aggregated into single function.
> 
> > For instance, I assume the intent below is for pattern_list to be
> > protected by the static 'lock' mutex defined in
> > update_file_pattern_entry.  But get_file_pattern() also walks the
> > list without any locking.
> > 
> > It looks like you only ever append to the list, with a memory barrier,
> > so *maybe* it's safe, but your rationale should be spelled out here.
> 
> It *is* safe. Below is the introduce-write-once-read-many-linked-list.patch
> taken from above URL. Paul, please review the below patch.

The memory barrier on the element-addition side is OK, though could
use rcu_assign_pointer().  In any case, it should be changed to smp_
form, as it is not needed in UP builds.

A few comments below -- some rcu_dereference()s are needed.

The general idea looks sound, at least as long as the lists remain
short.  Otherwise, the list scan in list1_add_tail_mb() will take
too long.

						Thanx, Paul

> Regards.
> --------------------
> Subject: Singly linked list implementation.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  include/linux/list.h |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 95 insertions(+)
> 
> --- linux-next.orig/include/linux/list.h
> +++ linux-next/include/linux/list.h
> @@ -692,4 +692,99 @@ static inline void hlist_move_list(struc
>  		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
>  	     pos = n)
> 
> +/*
> + * Singly linked list implementation.
> + *
> + * This list supports only two operations.
> + * (1) Append an entry to the tail of the list.
> + * (2) Read all entries starting from the head of the list.
> + *
> + * This list is designed for holding "write once, read many" entries.
> + * This list requires no locks for read operation.
> + * This list doesn't support "remove an entry from the list" operation.
> + * This list penalize "mb()" for write operation but penalize nothing for read
> + * operation.
> + */
> +
> +/* To keep the reader read lock free, this list doesn't have "prev" field. */
> +struct list1_head {
> +	struct list1_head *next;
> +};
> +
> +#define LIST1_HEAD_INIT(name) { &(name) }
> +#define LIST1_HEAD(name) struct list1_head name = LIST1_HEAD_INIT(name)
> +
> +static inline void INIT_LIST1_HEAD(struct list1_head *list)
> +{
> +	list->next = list;
> +}

Hmmm...  This list is circular.

> +/**
> + * list1_entry - get the struct for this entry
> + * @ptr:        the &struct list1_head pointer.
> + * @type:       the type of the struct this is embedded in.
> + * @member:     the name of the list1_struct within the struct.
> + */
> +#define list1_entry(ptr, type, member) container_of(ptr, type, member)

This is identical to list_entry().  Why have both?

> +/**
> + * list1_for_each - iterate over a list
> + * @pos:        the &struct list1_head to use as a loop cursor.
> + * @head:       the head for your list.
> + */
> +#define list1_for_each(pos, head)					\
> +	for (pos = (head)->next; prefetch(pos->next), pos != (head);	\
> +	     pos = pos->next)

Unless there is a strong need for list1_for_each(), I would leave it
out.  Error prone.

If you do retain it, don't you need rcu_dereference() as follows?

+#define list1_for_each(pos, head)					\
+	for (pos = rcu_dereference((head)->next); prefetch(pos->next), pos != (head);	\
+	     pos = rcu_dereference(pos->next))

> +/**
> + * list1_for_each_entry - iterate over list of given type
> + * @pos:        the type * to use as a loop cursor.
> + * @head:       the head for your list.
> + * @member:     the name of the list1_struct within the struct.
> + */
> +#define list1_for_each_entry(pos, head, member)				\
> +	for (pos = list1_entry((head)->next, typeof(*pos), member);	\
> +	     prefetch(pos->member.next), &pos->member != (head);        \
> +	     pos = list1_entry(pos->member.next, typeof(*pos), member))

Need rcu_dereference() here as well.  Otherwise, compiler optimizations
and DEC Alpha can cause failures.

> +/**
> + * list1_for_each_cookie - iterate over a list with cookie.
> + * @pos:        the &struct list1_head to use as a loop cursor.
> + * @cookie:     the &struct list1_head to use as a cookie.

And cookie must initially be NULL.

> + * @head:       the head for your list.
> + *
> + * Same with list_for_each except that this primitive uses cookie
> + * so that we can continue iteration.
> + * Since list elements are never removed, we don't need to get a lock
> + * or a reference count.
> + */
> +#define list1_for_each_cookie(pos, cookie, head)			\
> +	for (({ if (!cookie)						\
> +				     cookie = head; }), pos = (cookie)->next; \
> +	     prefetch(pos->next), pos != (head) || ((cookie) = NULL);	\
> +	     (cookie) = pos, pos = pos->next)

Need rcu_dereference() here as well:

+#define list1_for_each_cookie(pos, cookie, head)			\
+	for (({ if (!cookie)						\
+				     cookie = head; }), pos = rcu_dereference((cookie)->next); \
+	     prefetch(pos->next), pos != (head) || ((cookie) = NULL);	\
+	     (cookie) = pos, pos = rcu_dereference(pos->next))

> +/**
> + * list_add_tail_mb - add a new entry with memory barrier.
> + * @new: new entry to be added.
> + * @head: list head to add it before.
> + *
> + * Same with list_add_tail_rcu() except that this primitive uses mb()
> + * so that we can traverse forwards using list1_for_each() and
> + * list1_for_each_cookie() without any locks.
> + *
> + * Caller must hold a lock for protecting @head.
> + */
> +static inline void list1_add_tail_mb(struct list1_head *new,
> +				     struct list1_head *head)
> +{
> +	struct list1_head *pos = head;
> +
> +	new->next = head;
> +	mb(); /* Avoid out-of-order execution. */

smp_wmb() should be sufficient.  You could also instead use
rcu_assign_pointer() on the assignment to pos->next below.

> +	while (pos->next != head)
> +		pos = pos->next;
> +	pos->next = new;
> +}

Hope the lists are never too long...  ;-)

Another approach would be to maintain an explicit tail pointer, as
is done in the RCU callback lists in kernel/rcuclassic.c.

Either way, I suggest simply list1_add_tail() -- the "mb" is
implementation.  The key point is that you can add to the list
even when there are concurrent readers.

>  #endif
