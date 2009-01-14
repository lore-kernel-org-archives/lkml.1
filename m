Return-Path: <linux-kernel-owner+w=401wt.eu-S1756936AbZANDfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbZANDfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 22:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZANDff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 22:35:35 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbZANDfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 22:35:34 -0500
Date: Tue, 13 Jan 2009 22:35:33 -0500
From: Kyle McMartin <kyle@infradead.org>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] module: kzalloc mod->ref
Message-ID: <20090114033533.GL25103@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyle McMartin <kyle@redhat.com>

Dynamically allocate mod->ref instead of fixing it in the struct module.
Reduces on disk space wasted in the module .ko, and kills a loop
initializing the local_t it contains since we can just kzalloc it.

This matters when we're talking about large NR_CPUS.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
---
The patch removing cacheline_aligned from struct module_ref should be
applied as well to cut down on the amount of memory we allocate. This
patch makes a nice stopgap until we have per_cpu module references.

cheers, Kyle

diff --git a/include/linux/module.h b/include/linux/module.h
index 4f7ea12..5863998 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -345,7 +345,7 @@ struct module
 	void (*exit)(void);
 
 	/* Reference counts */
-	struct module_ref ref[NR_CPUS];
+	struct module_ref *ref;
 #endif
 };
 #ifndef MODULE_ARCH_INIT
diff --git a/kernel/module.c b/kernel/module.c
index c9332c9..bc0a9b0 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -571,17 +571,19 @@ static char last_unloaded_module[MODULE_NAME_LEN+1];
 
 #ifdef CONFIG_MODULE_UNLOAD
 /* Init the unload section of the module. */
-static void module_unload_init(struct module *mod)
+static int module_unload_init(struct module *mod)
 {
-	unsigned int i;
+	mod->ref = kzalloc(NR_CPUS * sizeof(*mod->ref), GFP_KERNEL);
+	if (!mod->ref)
+		return -ENOMEM;
 
 	INIT_LIST_HEAD(&mod->modules_which_use_me);
-	for (i = 0; i < NR_CPUS; i++)
-		local_set(&mod->ref[i].count, 0);
 	/* Hold reference count during initialization. */
 	local_set(&mod->ref[raw_smp_processor_id()].count, 1);
 	/* Backwards compatibility macros put refcount during init. */
 	mod->waiter = current;
+
+	return 0;
 }
 
 /* modules using other modules */
@@ -919,8 +921,9 @@ static inline int use_module(struct module *a, struct module *b)
 	return strong_try_module_get(b) == 0;
 }
 
-static inline void module_unload_init(struct module *mod)
+static inline int module_unload_init(struct module *mod)
 {
+	return 0;
 }
 #endif /* CONFIG_MODULE_UNLOAD */
 
@@ -2071,7 +2074,9 @@ static noinline struct module *load_module(void __user *umod,
 	mod = (void *)sechdrs[modindex].sh_addr;
 
 	/* Now we've moved module, initialize linked lists, etc. */
-	module_unload_init(mod);
+	err = module_unload_init(mod);
+	if (err < 0)
+		goto free_unload;
 
 	/* add kobject, so we can reference it. */
 	err = mod_sysfs_init(mod);
