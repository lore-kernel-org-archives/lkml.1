Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYH2UpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYH2UpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 16:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbYH2Uo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 16:44:59 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:49991 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbYH2Uo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 16:44:58 -0400
Date: Fri, 29 Aug 2008 13:44:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] Remove stop_machine during module load
Message-ID: <20080829204457.GF6725@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080829191734.GA28329@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080829191734.GA28329@basil.nowhere.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 09:17:34PM +0200, Andi Kleen wrote:
> Remove stop_machine during module load
> 
> module loading currently does a stop_machine on each module load to insert
> the module into the global module lists.  Especially on larger systems this 
> can be quite expensive.
> 
> It does that to handle concurrent lock lessmodule list readers
> like kallsyms.
> 
> I don't think stop_machine() is actually needed to insert something
> into a list though. There are no concurrent writers because the
> module mutex is taken. And the RCU list functions know how to insert
> a node into a list with the right memory ordering so that concurrent
> readers don't go off into the wood.
> 
> So remove the stop_machine for the module list insert and just
> do a list_add_rcu() instead. 
> 
> Module removal will still do a stop_machine of course, it needs
> that for other reasons.
> 
> [cc Paul McKenney for review. It's not RCU, but quite similar.]

Seems plausible, and faster module loading on big machines would be very
nice.  But aren't adjustments also needed on the removal side?

Ah, no they do not, because __unlink_module() is only called from the
context of stop_machine

OK, what about the read side?  Not so good for __unlink_module() to yank
the module out from under a reader.  Therefore, all readers must either
disable interrupts to block stop_machine() or must hold some sort of
mutex that prevents modules from being unloaded.

First, where the heck -is- the read side...

o	each_symbol() needs its list_for_each_entry() to become
	list_for_each_entry_rcu() and needs local_irq_disable()
	across the loop.  (I think -- looks to me like irqs are enabled,
	anyway...)

o	module_address_lookup() -- ditto.  Also lookup_module_symbol_name().
	And lookup_module_symbol_attrs().  And module_get_kallsym().
	As well as module_kallsyms_lookup_name().  And it looks like
	search_module_extables() also.  Ditto is_module_address().
	Plus __module_text_address().  Perhaps module_update_markers().

o	print_modules() -- needs the same treatment, but not sure
	how wise it is to invoke a potentially very large number of
	printk()s with interrupts disabled.

	An alternative would be to have free_module() do a
	synchronize_rcu() after the stop_machine().  Heck, if you are
	incurring a stop_machine(), what is an additional
	synchronize_rcu() among friends?  ;-)

	Yet another approach would be to use call_rcu() to defer the
	various kfree() &c calls later in free_module.

	Both the synchronize_rcu() and the call_rcu() approaches of
	course require that the list traversals all be done under either
	rcu_read_lock() or local_irq_disable().  This works with
	preemptable RCU -- rcu_read_lock() blocks either the
	synchronize_rcu() or the call_rcu(), which ever is chosen, while
	the local_irq_disable() blocks the stop_machine().

	But gack, there do appear to be lots of module_free()
	definitions out there!  More definitions than uses, it appears.
	So maybe not so bad.

	So maybe acquire module_mutex() or whatever to exclude module
	load and unload?  Unless of course print_modules() is sometimes
	invoked with module_mutex() already held!

	Too much fun!!!  ;-)

o	find_module() -- ditto.  Unless the comment about callers
	holding module_mutex really is honored, and unless module_mutex
	really prevents modules from being loaded and unloaded.

o	My guess is that already_uses() is an innocent bystander and
	thus need not change, but I cannot claim to be an expert on the
	modules code.  Ditto for print_unload_info ().

o	The caller of module_unload_free() presumably holds whatever
	mutex prevents other modules from being loaded and unloaded,
	so should not need to change.

Anyway, the general idea looks good, and getting rid of stop_machine()
for module load would be very cool on big machines, but the removal and
read sides need some help as noted above.

							Thanx, Paul

> Cc: rusty@rustcorp.com.au
> Cc: paulmck@us.ibm.com
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> Index: linux-2.6.27-rc4-misc/kernel/module.c
> ===================================================================
> --- linux-2.6.27-rc4-misc.orig/kernel/module.c
> +++ linux-2.6.27-rc4-misc/kernel/module.c
> @@ -42,6 +42,7 @@
>  #include <linux/string.h>
>  #include <linux/mutex.h>
>  #include <linux/unwind.h>
> +#include <linux/rculist.h>
>  #include <asm/uaccess.h>
>  #include <asm/cacheflush.h>
>  #include <linux/license.h>
> @@ -61,7 +62,7 @@
>  #define INIT_OFFSET_MASK (1UL << (BITS_PER_LONG-1))
> 
>  /* List of modules, protected by module_mutex or preempt_disable
> - * (add/delete uses stop_machine). */
> + * (delete uses stop_machine/add uses RCU list operations). */
>  static DEFINE_MUTEX(module_mutex);
>  static LIST_HEAD(modules);
> 
> @@ -1391,17 +1392,6 @@ static void mod_kobject_remove(struct mo
>  }
> 
>  /*
> - * link the module with the whole machine is stopped with interrupts off
> - * - this defends against kallsyms not taking locks
> - */
> -static int __link_module(void *_mod)
> -{
> -	struct module *mod = _mod;
> -	list_add(&mod->list, &modules);
> -	return 0;
> -}
> -
> -/*
>   * unlink the module with the whole machine is stopped with interrupts off
>   * - this defends against kallsyms not taking locks
>   */
> @@ -2196,8 +2186,12 @@ static struct module *load_module(void _
> 
>  	/* Now sew it into the lists so we can get lockdep and oops
>           * info during argument parsing.  Noone should access us, since
> -         * strong_try_module_get() will fail. */
> -	stop_machine(__link_module, mod, NULL);
> +         * strong_try_module_get() will fail.
> +	 * lockdep/oops can run asynchronous, so use the RCU list insertion
> +	 * function to insert in a way safe to concurrent readers.
> +	 * The mutex protects against concurrent writers.
> +	 */
> +	list_add_rcu(&mod->list, &modules);
> 
>  	/* Size of section 0 is 0, so this works well if no params */
>  	err = parse_args(mod->name, mod->args,
