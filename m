Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbZBYHET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbZBYHET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbZBYHEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:04:09 -0500
Received: from ozlabs.org ([203.10.76.45]:46486 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbZBYHEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:04:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
Date: Wed, 25 Feb 2009 17:33:56 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Andreas Robinson <andr345@gmail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       heiko.carstens@de.ibm.com
References: <1234722028-8110-1-git-send-email-andr345@gmail.com> <200902202202.13994.rusty@rustcorp.com.au> <ac3eb2510902230842n278503a7w33d5ac2e622ec711@mail.gmail.com>
In-Reply-To: <ac3eb2510902230842n278503a7w33d5ac2e622ec711@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200902251733.57069.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009 03:12:28 Kay Sievers wrote:
> Rusty,
> are you taking care, that this patch gets merged somewhere, and shows
> up in -next?

Yep, already done.

> I still get a ~10% improvement without the mutex, and traces show some
> parallelism from different modprobe processes. Any idea how to safely
> minimize the time we need to hold it?

OK, let's do that then.

<hack hack>

Here's a backported version which you should be able to simply apply; it'll
be good to check that we still win...

Thanks!
Rusty.

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -75,7 +75,8 @@ static DECLARE_WAIT_QUEUE_HEAD(module_wq
 
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);
 
-/* Bounds of module allocation, for speeding __module_text_address */
+/* Bounds of module allocation, for speeding __module_address.
+ * Protected by module_mutex. */
 static unsigned long module_addr_min = -1UL, module_addr_max = 0;
 
 int register_module_notifier(struct notifier_block * nb)
@@ -328,7 +329,7 @@ static bool find_symbol_in_section(const
 }
 
 /* Find a symbol, return value, (optional) crc and (optional) module
- * which owns it */
+ * which owns it.  Needs preempt disabled or module_mutex. */
 static unsigned long find_symbol(const char *name,
 				 struct module **owner,
 				 const unsigned long **crc,
@@ -408,8 +409,9 @@ static void *percpu_modalloc(unsigned lo
 {
 	unsigned long extra;
 	unsigned int i;
-	void *ptr;
+	void *ptr = NULL;
 
+	mutex_lock(&module_mutex);
 	if (align > PAGE_SIZE) {
 		printk(KERN_WARNING "%s: per-cpu alignment %li > %li\n",
 		       name, align, PAGE_SIZE);
@@ -434,24 +436,32 @@ static void *percpu_modalloc(unsigned lo
 		ptr += extra;
 
 		/* Split block if warranted */
-		if (pcpu_size[i] - size > sizeof(unsigned long))
-			if (!split_block(i, size))
-				return NULL;
+		if (pcpu_size[i] - size > sizeof(unsigned long)) {
+			if (!split_block(i, size)) {
+				ptr = NULL;
+				break;
+			}
+		}
 
 		/* Mark allocated */
 		pcpu_size[i] = -pcpu_size[i];
-		return ptr;
+		break;
 	}
+	mutex_unlock(&module_mutex);
 
-	printk(KERN_WARNING "Could not allocate %lu bytes percpu data\n",
-	       size);
-	return NULL;
+	if (!ptr)
+		printk(KERN_WARNING
+		       "Could not allocate %lu bytes percpu data\n", size);
+	return ptr;
 }
 
 static void percpu_modfree(void *freeme)
 {
 	unsigned int i;
-	void *ptr = __per_cpu_start + block_size(pcpu_size[0]);
+	void *ptr;
+
+	mutex_lock(&module_mutex);
+	ptr = __per_cpu_start + block_size(pcpu_size[0]);
 
 	/* First entry is core kernel percpu data. */
 	for (i = 1; i < pcpu_num_used; ptr += block_size(pcpu_size[i]), i++) {
@@ -478,6 +488,7 @@ static void percpu_modfree(void *freeme)
 		memmove(&pcpu_size[i+1], &pcpu_size[i+2],
 			(pcpu_num_used - (i+1)) * sizeof(pcpu_size[0]));
 	}
+	mutex_unlock(&module_mutex);
 }
 
 static unsigned int find_pcpusec(Elf_Ehdr *hdr,
@@ -606,7 +617,7 @@ static int already_uses(struct module *a
 	return 0;
 }
 
-/* Module a uses b */
+/* Module a uses b: caller needs module_mutex() */
 static int use_module(struct module *a, struct module *b)
 {
 	struct module_use *use;
@@ -646,6 +657,7 @@ static void module_unload_free(struct mo
 {
 	struct module *i;
 
+	mutex_lock(&module_mutex);
 	list_for_each_entry(i, &modules, list) {
 		struct module_use *use;
 
@@ -661,6 +673,7 @@ static void module_unload_free(struct mo
 			}
 		}
 	}
+	mutex_unlock(&module_mutex);
 }
 
 #ifdef CONFIG_MODULE_FORCE_UNLOAD
@@ -823,9 +836,13 @@ SYSCALL_DEFINE2(delete_module, const cha
 	/* Store the name of the last unloaded module for diagnostic purposes */
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
 	unregister_dynamic_debug_module(mod->name);
+
+	/* free_module doesn't want module_mutex held by caller. */
+	mutex_unlock(&module_mutex);
 	free_module(mod);
+	goto out_stop;
 
- out:
+out:
 	mutex_unlock(&module_mutex);
 out_stop:
 	stop_machine_destroy();
@@ -1062,8 +1079,7 @@ static inline int same_magic(const char 
 }
 #endif /* CONFIG_MODVERSIONS */
 
-/* Resolve a symbol for this module.  I.e. if we find one, record usage.
-   Must be holding module_mutex. */
+/* Resolve a symbol for this module.  I.e. if we find one, record usage. */
 static unsigned long resolve_symbol(Elf_Shdr *sechdrs,
 				    unsigned int versindex,
 				    const char *name,
@@ -1073,6 +1089,7 @@ static unsigned long resolve_symbol(Elf_
 	unsigned long ret;
 	const unsigned long *crc;
 
+	mutex_lock(&module_mutex);
 	ret = find_symbol(name, &owner, &crc,
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
 	if (!IS_ERR_VALUE(ret)) {
@@ -1082,6 +1099,7 @@ static unsigned long resolve_symbol(Elf_
 		    !use_module(mod, owner))
 			ret = -EINVAL;
 	}
+	mutex_unlock(&module_mutex);
 	return ret;
 }
 
@@ -1442,11 +1460,14 @@ static int __unlink_module(void *_mod)
 	return 0;
 }
 
-/* Free a module, remove from lists, etc (must hold module_mutex). */
+/* Free a module, remove from lists, etc. */
 static void free_module(struct module *mod)
 {
 	/* Delete from various lists */
+	mutex_lock(&module_mutex);	
 	stop_machine(__unlink_module, mod, NULL);
+	mutex_unlock(&module_mutex);
+
 	remove_notes_attrs(mod);
 	remove_sect_attrs(mod);
 	mod_kobject_remove(mod);
@@ -1520,14 +1541,19 @@ static int verify_export_symbols(struct 
 
 	for (i = 0; i < ARRAY_SIZE(arr); i++) {
 		for (s = arr[i].sym; s < arr[i].sym + arr[i].num; s++) {
+
+			/* Stopping preemption makes find_symbol safe. */
+			preempt_disable();
 			if (!IS_ERR_VALUE(find_symbol(s->name, &owner,
 						      NULL, true, false))) {
+				preempt_enable();
 				printk(KERN_ERR
 				       "%s: exports duplicate symbol %s"
 				       " (owned by %s)\n",
 				       mod->name, s->name, module_name(owner));
 				return -ENOEXEC;
 			}
+			preempt_enable();
 		}
 	}
 	return 0;
@@ -1850,11 +1876,13 @@ static void *module_alloc_update_bounds(
 	void *ret = module_alloc(size);
 
 	if (ret) {
+		mutex_lock(&module_mutex);
 		/* Update module bounds. */
 		if ((unsigned long)ret < module_addr_min)
 			module_addr_min = (unsigned long)ret;
 		if ((unsigned long)ret + size > module_addr_max)
 			module_addr_max = (unsigned long)ret + size;
+		mutex_unlock(&module_mutex);
 	}
 	return ret;
 }
@@ -2256,7 +2284,9 @@ static noinline struct module *load_modu
 	 * function to insert in a way safe to concurrent readers.
 	 * The mutex protects against concurrent writers.
 	 */
+	mutex_lock(&module_mutex);
 	list_add_rcu(&mod->list, &modules);
+	mutex_unlock(&module_mutex);
 
 	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
 	if (err < 0)
@@ -2275,8 +2305,10 @@ static noinline struct module *load_modu
 	return mod;
 
  unlink:
+	mutex_lock(&module_mutex);
 	/* Unlink carefully: kallsyms could be walking list. */
 	list_del_rcu(&mod->list);
+	mutex_unlock(&module_mutex);
 	synchronize_sched();
 	module_arch_cleanup(mod);
  cleanup:
@@ -2317,19 +2349,10 @@ SYSCALL_DEFINE3(init_module, void __user
 	if (!capable(CAP_SYS_MODULE))
 		return -EPERM;
 
-	/* Only one module load at a time, please */
-	if (mutex_lock_interruptible(&module_mutex) != 0)
-		return -EINTR;
-
 	/* Do all the hard work */
 	mod = load_module(umod, len, uargs);
-	if (IS_ERR(mod)) {
-		mutex_unlock(&module_mutex);
+	if (IS_ERR(mod))
 		return PTR_ERR(mod);
-	}
-
-	/* Drop lock so they can recurse */
-	mutex_unlock(&module_mutex);
 
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
@@ -2345,9 +2368,7 @@ SYSCALL_DEFINE3(init_module, void __user
 		module_put(mod);
 		blocking_notifier_call_chain(&module_notify_list,
 					     MODULE_STATE_GOING, mod);
-		mutex_lock(&module_mutex);
 		free_module(mod);
-		mutex_unlock(&module_mutex);
 		wake_up(&module_wq);
 		return ret;
 	}
@@ -2366,14 +2387,15 @@ SYSCALL_DEFINE3(init_module, void __user
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_LIVE, mod);
 
-	mutex_lock(&module_mutex);
+	/* Be a little careful here: an oops may look at this mem right now. */
+	mod->init_size = 0;
+	mod->init_text_size = 0;
+	wmb();
+	module_free(mod, mod->module_init);
+	mod->module_init = NULL;
+
 	/* Drop initial reference. */
 	module_put(mod);
-	module_free(mod, mod->module_init);
-	mod->module_init = NULL;
-	mod->init_size = 0;
-	mod->init_text_size = 0;
-	mutex_unlock(&module_mutex);
 
 	return 0;
 }
