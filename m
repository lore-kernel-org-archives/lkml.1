Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbYAHL2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbYAHL2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759508AbYAHL2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:28:25 -0500
Received: from ozlabs.org ([203.10.76.45]:45357 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759499AbYAHL2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:28:24 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] call sysrq_timer_list_show from a workqueue
Date: Tue, 8 Jan 2008 22:28:04 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080108063113.GA21287@fattire.cabal.ca> <20080108091742.GD27671@elte.hu>
In-Reply-To: <20080108091742.GD27671@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801082228.05218.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 January 2008 20:17:42 Ingo Molnar wrote:
> (Rusty Cc:-ed)
>
> * Kyle McMartin <kyle@mcmartin.ca> wrote:
> > handle_sysrq can be called from interrupt context.
> > sysrq_timer_list_show eventually starts poking at module symbols which
> > take the module mutex.
> >
> > so instead, let's just kick off a workqueue.
> >
> > [ doesn't happen on my laptop with the keyboard, but does when
> >   triggered from /proc/sysrq-trigger ]
>
> hmmm. This really shouldnt be happening - how come we hit the module
> mutex on simple things like symbol lookups?

We did start demutexing paths to try to get more info out for oopsen, but
lookup_module_symbol_name was not among them.

Hmm, the module symbol lookup interfaces are out of control, but this
should do it:

De-mutex more symbol lookup paths in the module code

Kyle McMartin reports sysrq_timer_list_show() can hit the module
mutex; these paths don't need to though, since we long ago changed all
the module list manipulation to occur via stop_machine().

Disabling preemption is enough.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r f52abc2cbb4e kernel/module.c
--- a/kernel/module.c	Tue Jan 08 17:39:23 2008 +1100
+++ b/kernel/module.c	Tue Jan 08 22:27:01 2008 +1100
@@ -2238,29 +2238,34 @@ static const char *get_ksymbol(struct mo
 /* For kallsyms to ask for address resolution.  NULL means not found.
    We don't lock, as this is used for oops resolution and races are a
    lesser concern. */
+/* FIXME: Risky: returns a pointer into a module w/o lock */
 const char *module_address_lookup(unsigned long addr,
 				  unsigned long *size,
 				  unsigned long *offset,
 				  char **modname)
 {
 	struct module *mod;
+	const char *ret = NULL;
 
+	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
 		if (within(addr, mod->module_init, mod->init_size)
 		    || within(addr, mod->module_core, mod->core_size)) {
 			if (modname)
 				*modname = mod->name;
-			return get_ksymbol(mod, addr, size, offset);
+			ret = get_ksymbol(mod, addr, size, offset);
+			break;
 		}
 	}
-	return NULL;
+	preempt_enable();
+	return ret;
 }
 
 int lookup_module_symbol_name(unsigned long addr, char *symname)
 {
 	struct module *mod;
 
-	mutex_lock(&module_mutex);
+	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
 		if (within(addr, mod->module_init, mod->init_size) ||
 		    within(addr, mod->module_core, mod->core_size)) {
@@ -2270,12 +2275,12 @@ int lookup_module_symbol_name(unsigned l
 			if (!sym)
 				goto out;
 			strlcpy(symname, sym, KSYM_NAME_LEN);
-			mutex_unlock(&module_mutex);
+			preempt_enable();
 			return 0;
 		}
 	}
 out:
-	mutex_unlock(&module_mutex);
+	preempt_enable();
 	return -ERANGE;
 }
 
@@ -2284,7 +2289,7 @@ int lookup_module_symbol_attrs(unsigned 
 {
 	struct module *mod;
 
-	mutex_lock(&module_mutex);
+	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
 		if (within(addr, mod->module_init, mod->init_size) ||
 		    within(addr, mod->module_core, mod->core_size)) {
@@ -2297,12 +2302,12 @@ int lookup_module_symbol_attrs(unsigned 
 				strlcpy(modname, mod->name, MODULE_NAME_LEN);
 			if (name)
 				strlcpy(name, sym, KSYM_NAME_LEN);
-			mutex_unlock(&module_mutex);
+			preempt_enable();
 			return 0;
 		}
 	}
 out:
-	mutex_unlock(&module_mutex);
+	preempt_enable();
 	return -ERANGE;
 }
 
@@ -2311,7 +2316,7 @@ int module_get_kallsym(unsigned int symn
 {
 	struct module *mod;
 
-	mutex_lock(&module_mutex);
+	preempt_disable();
 	list_for_each_entry(mod, &modules, list) {
 		if (symnum < mod->num_symtab) {
 			*value = mod->symtab[symnum].st_value;
@@ -2320,12 +2325,12 @@ int module_get_kallsym(unsigned int symn
 				KSYM_NAME_LEN);
 			strlcpy(module_name, mod->name, MODULE_NAME_LEN);
 			*exported = is_exported(name, mod);
-			mutex_unlock(&module_mutex);
+			preempt_enable();
 			return 0;
 		}
 		symnum -= mod->num_symtab;
 	}
-	mutex_unlock(&module_mutex);
+	preempt_enable();
 	return -ERANGE;
 }
 
@@ -2348,6 +2353,7 @@ unsigned long module_kallsyms_lookup_nam
 	unsigned long ret = 0;
 
 	/* Don't lock: we're in enough trouble already. */
+	preempt_disable();
 	if ((colon = strchr(name, ':')) != NULL) {
 		*colon = '\0';
 		if ((mod = find_module(name)) != NULL)
@@ -2358,6 +2364,7 @@ unsigned long module_kallsyms_lookup_nam
 			if ((ret = mod_find_symname(mod, name)) != 0)
 				break;
 	}
+	preempt_enable();
 	return ret;
 }
 #endif /* CONFIG_KALLSYMS */
