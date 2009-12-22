Return-Path: <linux-kernel-owner+w=401wt.eu-S1751491AbZLVCqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbZLVCqf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 21:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZLVCqe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 21:46:34 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43023 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbZLVCqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 21:46:34 -0500
Date: Mon, 21 Dec 2009 18:46:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH] [1/11] Add rcustring ADT for RCU protected strings
Message-ID: <20091222024635.GA9279@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091221220.243954235@firstfloor.org> <20091221012022.9C5C4B160D@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221012022.9C5C4B160D@basil.firstfloor.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 02:20:22AM +0100, Andi Kleen wrote:
> 
> Add a little ADT for RCU protected strings. RCU is a convenient
> way to manage modifications to read-often-write-seldom strings.
> Add some helper functions to make this more straight forward.
> 
> Used by follow-on patches to implement RCU protected sysctl strings.
> 
>  * General rules:
>  * Reader has to use rcu_read_lock() and not sleep while accessing the string,
>  * or alternatively get a copy with access_rcu_string()
>  * Writer needs an own lock against each other.
>  * Each modification should allocate a new string first and free the old
>  * one with free_rcu_string()
>  * In writers use rcu_assign_pointer to publicize the updated string to
>  * global readers.
>  * The size passed to access_rcu_string() must be the same as passed
>  * to alloc_rcu_string() and be known in advance. Don't use strlen()!
>  *
>  * For sysctls also see proc_rcu_string() as a convenient wrapper

Looks very interesting, possibly extremely useful!

I do have a couple of questions below, one a debugging suggestion, and
the other either a bug or extreme confusion on my part.

							Thanx, Paul

> Cc: paulmck@linux.vnet.ibm.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  include/linux/rcustring.h |   20 ++++++++
>  lib/Makefile              |    3 -
>  lib/rcustring.c           |  112 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 134 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.33-rc1-ak/include/linux/rcustring.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.33-rc1-ak/include/linux/rcustring.h
> @@ -0,0 +1,20 @@
> +#ifndef _RCUSTRING_H
> +#define _RCUSTRING_H 1
> +
> +#include <linux/gfp.h>
> +#include <linux/rcupdate.h>
> +
> +/*
> + * Simple wrapper to manage strings by RCU.
> + */
> +
> +extern char *alloc_rcu_string(int size, gfp_t gfp);
> +extern void free_rcu_string(const char *string);
> +
> +/*
> + * size must be the same as alloc_rcu_string, don't
> + * use strlen on str!
> + */
> +extern char *access_rcu_string(const char *str, int size, gfp_t gfp);
> +
> +#endif
> Index: linux-2.6.33-rc1-ak/lib/rcustring.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.33-rc1-ak/lib/rcustring.c
> @@ -0,0 +1,112 @@
> +/*
> + * Manage strings by Read-Copy-Update. This is useful for global strings
> + * that change only very rarely, but are read often.
> + *
> + * Author: Andi Kleen
> + *
> + * General rules:
> + * Reader has to use rcu_read_lock() and not sleep while accessing the string,
> + * or alternatively get a copy with access_rcu_string()
> + * Writer needs an own lock against each other.
> + * Each modification should allocate a new string first and free the old
> + * one with free_rcu_string()
> + * In writers use rcu_assign_pointer to publicize the updated string to
> + * global readers.
> + * The size passed to access_rcu_string() must be the same as passed
> + * to alloc_rcu_string() and be known in advance. Don't use strlen()!
> + *
> + * For sysctls also see proc_rcu_string() as a convenient wrapper
> + *
> + * Typical example:
> + * #define MAX_GLOBAL_SIZE ...
> + * char *global = "default";
> + *
> + * Rare writer:
> + * char *old, *new;
> + * DECLARE_MUTEX(writer_lock);
> + * mutex_lock(&writer_lock);
> + * new = alloc_rcu_string(MAX_GLOBAL_SIZE, GFP_KERNEL);
> + * if (!new) {
> + *      mutex_unlock(&writer_lock);
> + *      return -ENOMEM;
> + * }
> + * strlcpy(new, new_value, MAX_GLOBAL_SIZE);
> + * old = global;
> + * rcu_assign_pointer(global, new);
> + * mutex_unlock(&writer_lock);
> + * free_rcu_string(old);
> + *
> + * Sleepy reader:
> + * char *str = access_rcu_string(global, MAX_GLOBAL_SIZE, GFP_KERNEL);
> + * if (!str)
> + *     return -ENOMEM;
> + * ... use str while sleeping ...
> + * kfree(string);
> + *
> + * Non sleepy reader:
> + * rcu_read_lock();
> + * ... read str ...
> + * rcu_read_unlock();
> + *
> + * Note this code could be relatively easily generalized for other kinds
> + * of non-atomic data, but this initial version only handles strings.
> + * Only need to change the strlcpy() below to memcpy()
> + */
> +#include <linux/kernel.h>
> +#include <linux/rcustring.h>
> +#include <linux/slab.h>
> +#include <linux/rcupdate.h>
> +#include <linux/module.h>
> +#include <linux/string.h>
> +
> +struct rcu_string {
> +	struct rcu_head rcu;
> +	char str[0];

My guess is that you will sooner or later need a size field, perhaps
under some debug config parameter.

> +};
> +
> +char *alloc_rcu_string(int size, gfp_t gfp)
> +{
> +	struct rcu_string *rs = kmalloc(sizeof(struct rcu_string) + size, gfp);
> +	if (!rs)
> +		return NULL;
> +	return rs->str;
> +}
> +EXPORT_SYMBOL(alloc_rcu_string);
> +
> +static void do_free_rcu_string(struct rcu_head *h)
> +{
> +	kfree(container_of(h, struct rcu_string, rcu));
> +}
> +
> +static inline struct rcu_string *str_to_rcustr(const char *str)
> +{
> +	/*
> +	 * Opencoded container_of because the strict type checking
> +	 * in normal container_of cannot deal with char str[0] vs char *str.
> +	 */
> +	return (struct rcu_string *)(str - offsetof(struct rcu_string, str));
> +}
> +
> +void free_rcu_string(const char *str)
> +{
> +	struct rcu_string *rs = str_to_rcustr(str);
> +	call_rcu(&rs->rcu, do_free_rcu_string);
> +}
> +EXPORT_SYMBOL(free_rcu_string);
> +
> +/*
> + * Get a local private copy of a RCU protected string.
> + * Mostly useful to get a string that is stable while sleeping.
> + * Caller must free returned string.
> + */
> +char *access_rcu_string(const char *str, int size, gfp_t gfp)
> +{
> +	char *copy = kmalloc(size, gfp);
> +	if (!str)
> +		return NULL;

Assuming that "str" points to the "str" field of a struct rcu_string,
what prevents a grace period from elapsing at this point, freeing the
"str" out from under us?

> +	rcu_read_lock();
> +	strlcpy(copy, str, size);
> +	rcu_read_unlock();
> +	return copy;
> +}
> +EXPORT_SYMBOL(access_rcu_string);
> Index: linux-2.6.33-rc1-ak/lib/Makefile
> ===================================================================
> --- linux-2.6.33-rc1-ak.orig/lib/Makefile
> +++ linux-2.6.33-rc1-ak/lib/Makefile
> @@ -12,7 +12,8 @@ lib-y := ctype.o string.o vsprintf.o cmd
>  	 idr.o int_sqrt.o extable.o prio_tree.o \
>  	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
>  	 proportions.o prio_heap.o ratelimit.o show_mem.o \
> -	 is_single_threaded.o plist.o decompress.o flex_array.o
> +	 is_single_threaded.o plist.o decompress.o flex_array.o \
> +	 rcustring.o
> 
>  lib-$(CONFIG_MMU) += ioremap.o
>  lib-$(CONFIG_SMP) += cpumask.o
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
