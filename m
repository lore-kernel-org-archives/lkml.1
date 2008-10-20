Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbYJTERv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbYJTERv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 00:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbYJTERm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 00:17:42 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42595 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbYJTERk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 00:17:40 -0400
Date: Sun, 19 Oct 2008 21:17:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: serue@us.ibm.com, sds@tycho.nsa.gov, jmorris@namei.org,
       chrisw@sous-sol.org, dhowells@redhat.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp
Subject: Re: [TOMOYO #10 (linux-next) 7/8] File operation restriction part.
Message-ID: <20081020041736.GA6929@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081016151003.GA6772@linux.vnet.ibm.com> <48F84DAB.4060002@nttdata.co.jp> <20081017145630.GC6706@linux.vnet.ibm.com> <200810182304.JDC12476.JFSHLVMOQFtOOF@I-love.SAKURA.ne.jp> <20081018151809.GA7227@linux.vnet.ibm.com> <200810192210.FAG26590.MLtOVOFJHQFOSF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810192210.FAG26590.MLtOVOFJHQFOSF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2008 at 10:10:23PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Paul E. McKenney wrote:
> > > Maybe I'm misunderstanding what "mb()" can do.
> > 
> > The problem is that while wmb() and mb() do in fact order writes, they 
> > cannot order the other task's reads.
> > 
> I expected that "mb()" can order the other task's reads.

So did I, a long time ago.  It took an Alpha architect more than
an hour face-to-face to convince me otherwise.  ;-)

> Now, I understood that there is no room for optimizing the reader process
> by omitting smp_read_barrier_depends() on read side.
> 
> OK, let's return to http://lkml.org/lkml/2008/10/14/406 .
> Below is the updated version of list1 operations.
> As I now use rcu_assign_pointer() and rcu_dereference() which depend on
> include/linux/rcupdate.h , I separated the code from include/linux/list.h .
> Did I update correctly?
> 
> ---
> Subject: Singly linked list implementation.

Looks good to me!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  include/linux/list1.h |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 81 insertions(+)
> 
> --- /dev/null
> +++ linux-next/include/linux/list1.h
> @@ -0,0 +1,81 @@
> +#ifndef _LINUX_LIST1_H
> +#define _LINUX_LIST1_H
> +
> +#include <linux/list.h>
> +#include <linux/rcupdate.h>
> +
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
> + */
> +
> +/* To reduce memory usage, this list doesn't use "->prev" pointer. */
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
> +
> +/* Reuse list_entry because it doesn't use "->prev" pointer. */
> +#define list1_entry list_entry
> +
> +/* Reuse list_for_each_rcu because it doesn't use "->prev" pointer. */
> +#define list1_for_each list_for_each_rcu
> +/* Reuse list_for_each_entry_rcu because it doesn't use "->prev" pointer. */
> +#define list1_for_each_entry list_for_each_entry_rcu
> +
> +/**
> + * list1_for_each_cookie - iterate over a list with cookie.
> + * @pos:        the &struct list1_head to use as a loop cursor.
> + * @cookie:     the &struct list1_head to use as a cookie.
> + * @head:       the head for your list.
> + *
> + * Same with list_for_each_rcu() except that this primitive uses @cookie
> + * so that we can continue iteration.
> + * @cookie must be NULL when iteration starts, and @cookie will become
> + * NULL when iteration finishes.
> + *
> + * Since list elements are never removed, we don't need to get a lock
> + * or a reference count.
> + */
> +#define list1_for_each_cookie(pos, cookie, head)                      \
> +	for (({ if (!cookie)                                          \
> +				     cookie = head; }),               \
> +	     pos = rcu_dereference((cookie)->next);                   \
> +	     prefetch(pos->next), pos != (head) || ((cookie) = NULL); \
> +	     (cookie) = pos, pos = rcu_dereference(pos->next))
> +
> +/**
> + * list1_add_tail - add a new entry to list1 list.
> + * @new: new entry to be added.
> + * @head: list head to add it before.
> + *
> + * Same with list_add_tail_rcu() without "->prev" pointer.
> + *
> + * Caller must hold a lock for protecting @head.
> + */
> +static inline void list1_add_tail(struct list1_head *new,
> +				  struct list1_head *head)
> +{
> +	struct list1_head *prev = head;
> +
> +	new->next = head;
> +	while (prev->next != head)
> +		prev = prev->next;
> +	rcu_assign_pointer(prev->next, new);
> +}
> +
> +#endif
> ---
> 
> By the way, quoting from ordering.2007.09.19a.pdf :
> 
> | One could place an smp_rmb() primitive between the pointer fetch and
> | dereference. However, this imposes unneeded overhead on systems (such as
> | i386, IA64, PPC, and SPARC) that respect data dependencies on the read side.
> | A smp_read_barrier_depends() primitive has been added to the Linux 2.6 kernel
> | to eliminate overhead on these systems.
> 
> In 2.4 kernels, to support Alpha architecture, people use smp_rmb() which
> imposes unneeded overhead on non Alpha architecture.
> In 2.6 kernels, to support Alpha architecture, people use
> smp_read_barrier_depends() which does not impose unneeded overhead on
> non Alpha architecture.
> That's nice.
> 
> | Alpha is the only CPU where smp_read_barrier_depends() is an smp_mb() rather
> | than a no-op.
> 
> I found
> 
>   #define smp_read_barrier_depends()      read_barrier_depends()
> 
> in arch/h8300/include/asm/system.h but couldn't find the definition of
> read_barrier_depends() within that file.
> I hope read_barrier_depends() is defined as a no-op by some other header files.
> 
> Regards.
