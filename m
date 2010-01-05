Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479Ab0AEFc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab0AEFc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 00:32:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612Ab0AEFcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 00:32:55 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55302 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab0AEFcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 00:32:55 -0500
Date: Mon, 4 Jan 2010 21:32:52 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/9] Add rcustring ADT for RCU protected strings v2
Message-ID: <20100105053252.GB6836@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100105315.789846878@firstfloor.org> <20100105021526.17EF2B17C2@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100105021526.17EF2B17C2@basil.firstfloor.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 03:15:26AM +0100, Andi Kleen wrote:
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
> 
> v2: Use rcu_dereference correctly

Very good, the extra level of indirection on the first argument to
access_rcu_string() fixes the problem I complained about last time.

One additional question below.

> Cc: paulmck@linux.vnet.ibm.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  include/linux/rcustring.h |   20 ++++++++
>  lib/Makefile              |    3 -
>  lib/rcustring.c           |  115 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 137 insertions(+), 1 deletion(-)

[ . . . ]

> +/*
> + * Get a local private copy of a RCU protected string.
> + * Mostly useful to get a string that is stable while sleeping.
> + * Caller must free returned string.
> + */
> +char *access_rcu_string(char **str, int size, gfp_t gfp)
> +{
> +	char *copy = kmalloc(size, gfp);
> +	if (!str)
> +		return NULL;
> +	rcu_read_lock();
> +	strlcpy(copy, rcu_dereference(*str), size);

What if "str" is non-NULL, but "*str" is NULL?  Or is that disallowed
somehow?

If it is not disallowed, then something like the following?

	if (!str)
		return NULL;
	rcu_read_lock();
	tmp = rcu_dereference(*str);
	if (!tmp) {
		rcu_read_unlock();
		return NULL;
	}
	strlcpy(copy, tmp, size);
	rcu_read_unlock();
	return copy;

> +	rcu_read_unlock();
> +	return copy;
> +}
> +EXPORT_SYMBOL(access_rcu_string);
> Index: linux-2.6.33-rc2-ak/lib/Makefile
> ===================================================================
> --- linux-2.6.33-rc2-ak.orig/lib/Makefile
> +++ linux-2.6.33-rc2-ak/lib/Makefile
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
