Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbYH3OCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbYH3OCp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 10:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750817AbYH3OCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 10:02:36 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:45498 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYH3OCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 10:02:35 -0400
Date: Sat, 30 Aug 2008 07:02:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, rusty@rustcorp.com.au
Subject: Re: [PATCH] Remove stop_machine during module load v2
Message-ID: <20080830140233.GC7107@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080830080900.GA19870@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080830080900.GA19870@basil.nowhere.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 10:09:00AM +0200, Andi Kleen wrote:
> Remove stop_machine during module load v2
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
> v2: Revised readers based on Paul's comments. All readers that only
>     rely on disabled preemption need to be changed to list_for_each_rcu().
>     Done that. The others are ok because they have the modules mutex.
>     Also added a possible missing preempt disable for print_modules().
> 
> [cc Paul McKenney for review. It's not RCU, but quite similar.]

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Cc: rusty@rustcorp.com.au
> Cc: paulmck@us.ibm.com
> 
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
> @@ -216,7 +217,7 @@ static bool each_symbol(bool (*fn)(const
>  	if (each_symbol_in_section(arr, ARRAY_SIZE(arr), NULL, fn, data))
>  		return true;
> 
> -	list_for_each_entry(mod, &modules, list) {
> +	list_for_each_entry_rcu(mod, &modules, list) {
>  		struct symsearch arr[] = {
>  			{ mod->syms, mod->syms + mod->num_syms, mod->crcs,
>  			  NOT_GPL_ONLY, false },
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
> @@ -2401,7 +2395,7 @@ const char *module_address_lookup(unsign
>  	const char *ret = NULL;
> 
>  	preempt_disable();
> -	list_for_each_entry(mod, &modules, list) {
> +	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (within(addr, mod->module_init, mod->init_size)
>  		    || within(addr, mod->module_core, mod->core_size)) {
>  			if (modname)
> @@ -2424,7 +2418,7 @@ int lookup_module_symbol_name(unsigned l
>  	struct module *mod;
> 
>  	preempt_disable();
> -	list_for_each_entry(mod, &modules, list) {
> +	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (within(addr, mod->module_init, mod->init_size) ||
>  		    within(addr, mod->module_core, mod->core_size)) {
>  			const char *sym;
> @@ -2448,7 +2442,7 @@ int lookup_module_symbol_attrs(unsigned 
>  	struct module *mod;
> 
>  	preempt_disable();
> -	list_for_each_entry(mod, &modules, list) {
> +	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (within(addr, mod->module_init, mod->init_size) ||
>  		    within(addr, mod->module_core, mod->core_size)) {
>  			const char *sym;
> @@ -2475,7 +2469,7 @@ int module_get_kallsym(unsigned int symn
>  	struct module *mod;
> 
>  	preempt_disable();
> -	list_for_each_entry(mod, &modules, list) {
> +	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (symnum < mod->num_symtab) {
>  			*value = mod->symtab[symnum].st_value;
>  			*type = mod->symtab[symnum].st_info;
> @@ -2518,7 +2512,7 @@ unsigned long module_kallsyms_lookup_nam
>  			ret = mod_find_symname(mod, colon+1);
>  		*colon = ':';
>  	} else {
> -		list_for_each_entry(mod, &modules, list)
> +		list_for_each_entry_rcu(mod, &modules, list)
>  			if ((ret = mod_find_symname(mod, name)) != 0)
>  				break;
>  	}
> @@ -2619,7 +2613,7 @@ const struct exception_table_entry *sear
>  	struct module *mod;
> 
>  	preempt_disable();
> -	list_for_each_entry(mod, &modules, list) {
> +	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (mod->num_exentries == 0)
>  			continue;
> 
> @@ -2645,7 +2639,7 @@ int is_module_address(unsigned long addr
> 
>  	preempt_disable();
> 
> -	list_for_each_entry(mod, &modules, list) {
> +	list_for_each_entry_rcu(mod, &modules, list) {
>  		if (within(addr, mod->module_core, mod->core_size)) {
>  			preempt_enable();
>  			return 1;
> @@ -2666,7 +2660,7 @@ struct module *__module_text_address(uns
>  	if (addr < module_addr_min || addr > module_addr_max)
>  		return NULL;
> 
> -	list_for_each_entry(mod, &modules, list)
> +	list_for_each_entry_rcu(mod, &modules, list)
>  		if (within(addr, mod->module_init, mod->init_text_size)
>  		    || within(addr, mod->module_core, mod->core_text_size))
>  			return mod;
> @@ -2691,8 +2685,11 @@ void print_modules(void)
>  	char buf[8];
> 
>  	printk("Modules linked in:");
> -	list_for_each_entry(mod, &modules, list)
> +	/* Most callers should already have preempt disabled, but make sure */
> +	preempt_disable();
> +	list_for_each_entry_rcu(mod, &modules, list)
>  		printk(" %s%s", mod->name, module_flags(mod, buf));
> +	preempt_enable();
>  	if (last_unloaded_module[0])
>  		printk(" [last unloaded: %s]", last_unloaded_module);
>  	printk("\n");
