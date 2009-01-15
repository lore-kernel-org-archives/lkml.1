Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbZAOGEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbZAOGEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 01:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbZAOGD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 01:03:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbZAOGD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 01:03:56 -0500
Date: Thu, 15 Jan 2009 01:03:50 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Takashi Iwai <tiwai@suse.de>, Kyle McMartin <kyle@infradead.org>,
       linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] module: kzalloc mod->ref
Message-ID: <20090115060350.GA7488@bombadil.infradead.org>
References: <20090114033533.GL25103@bombadil.infradead.org> <s5hmydufe3c.wl%tiwai@suse.de> <200901151521.47326.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901151521.47326.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 03:21:46PM +1030, Rusty Russell wrote:
> In fact, I've decided to go back and add Eric's patch.  Since alloc_percpu
> isn't going to be fixed this merge window, we'll do this now, then simply
> use alloc_percpu once that is merged.

Er, what do you mean by "fixed"? ;-) Perhaps I'm just being thick, but
this seems to be working for me. At least, the refcnts seem to be the
same as the version without and unloading is fine...

Possibly I'm just being dense though. :)

regards, Kyle

diff --git a/include/linux/module.h b/include/linux/module.h
index 4f7ea12..61f97a2 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -219,11 +219,6 @@ void *__symbol_get_gpl(const char *symbol);
 
 #endif
 
-struct module_ref
-{
-	local_t count;
-} ____cacheline_aligned;
-
 enum module_state
 {
 	MODULE_STATE_LIVE,
@@ -345,7 +340,7 @@ struct module
 	void (*exit)(void);
 
 	/* Reference counts */
-	struct module_ref ref[NR_CPUS];
+	local_t *ref;	/* percpu */
 #endif
 };
 #ifndef MODULE_ARCH_INIT
@@ -400,8 +395,9 @@ void symbol_put_addr(void *addr);
 static inline void __module_get(struct module *module)
 {
 	if (module) {
+		int cpu = get_cpu();
 		BUG_ON(module_refcount(module) == 0);
-		local_inc(&module->ref[get_cpu()].count);
+		local_inc(per_cpu_ptr(module->ref, cpu));
 		put_cpu();
 	}
 }
@@ -412,9 +408,9 @@ static inline int try_module_get(struct module *module)
 
 	if (module) {
 		unsigned int cpu = get_cpu();
-		if (likely(module_is_live(module)))
-			local_inc(&module->ref[cpu].count);
-		else
+		if (likely(module_is_live(module))) {
+			local_inc(per_cpu_ptr(module->ref, cpu));
+		} else
 			ret = 0;
 		put_cpu();
 	}
diff --git a/kernel/module.c b/kernel/module.c
index c9332c9..e504f49 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -571,17 +571,19 @@ static char last_unloaded_module[MODULE_NAME_LEN+1];
 
 #ifdef CONFIG_MODULE_UNLOAD
 /* Init the unload section of the module. */
-static void module_unload_init(struct module *mod)
+static int module_unload_init(struct module *mod)
 {
-	unsigned int i;
+	mod->ref = percpu_alloc(sizeof(*mod->ref), GFP_KERNEL);
+	if (!mod->ref)
+		return -ENOMEM;
 
 	INIT_LIST_HEAD(&mod->modules_which_use_me);
-	for (i = 0; i < NR_CPUS; i++)
-		local_set(&mod->ref[i].count, 0);
 	/* Hold reference count during initialization. */
-	local_set(&mod->ref[raw_smp_processor_id()].count, 1);
+	local_set(per_cpu_ptr(mod->ref, raw_smp_processor_id()), 1);
 	/* Backwards compatibility macros put refcount during init. */
 	mod->waiter = current;
+
+	return 0;
 }
 
 /* modules using other modules */
@@ -661,6 +663,8 @@ static void module_unload_free(struct module *mod)
 			}
 		}
 	}
+
+	percpu_free(mod->ref);
 }
 
 #ifdef CONFIG_MODULE_FORCE_UNLOAD
@@ -717,10 +721,12 @@ static int try_stop_module(struct module *mod, int flags, int *forced)
 
 unsigned int module_refcount(struct module *mod)
 {
-	unsigned int i, total = 0;
+	unsigned int cpu, total = 0;
+
+	for_each_possible_cpu(cpu) {
+		total += local_read(per_cpu_ptr(mod->ref, cpu));
+	}
 
-	for (i = 0; i < NR_CPUS; i++)
-		total += local_read(&mod->ref[i].count);
 	return total;
 }
 EXPORT_SYMBOL(module_refcount);
@@ -894,7 +900,8 @@ void module_put(struct module *module)
 {
 	if (module) {
 		unsigned int cpu = get_cpu();
-		local_dec(&module->ref[cpu].count);
+
+		local_dec(per_cpu_ptr(module->ref, cpu));
 		/* Maybe they're waiting for us to drop reference? */
 		if (unlikely(!module_is_live(module)))
 			wake_up_process(module->waiter);
@@ -919,8 +926,9 @@ static inline int use_module(struct module *a, struct module *b)
 	return strong_try_module_get(b) == 0;
 }
 
-static inline void module_unload_init(struct module *mod)
+static inline int module_unload_init(struct module *mod)
 {
+	return 0;
 }
 #endif /* CONFIG_MODULE_UNLOAD */
 
@@ -2071,7 +2079,9 @@ static noinline struct module *load_module(void __user *umod,
 	mod = (void *)sechdrs[modindex].sh_addr;
 
 	/* Now we've moved module, initialize linked lists, etc. */
-	module_unload_init(mod);
+	err = module_unload_init(mod);
+	if (err < 0)
+		goto free_unload;
 
 	/* add kobject, so we can reference it. */
 	err = mod_sysfs_init(mod);
