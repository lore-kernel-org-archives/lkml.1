Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbXKTB1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbXKTB1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbXKTBOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:21 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49875 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755991AbXKTBNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:40 -0500
Message-Id: <20071120011339.407332676@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:04 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 32/45] Module handling: Use CPU_xx ops to dynamically allocate counters
Content-Disposition: inline; filename=remove_local_t_in_kernel_module
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use the CPU_xx operations to deal with the per cpu data.

Avoid a loop to NR_CPUS here. Use the possible map instead.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/module.h |   13 +++++--------
 kernel/module.c        |   17 +++++++----------
 2 files changed, 12 insertions(+), 18 deletions(-)

Index: linux-2.6/include/linux/module.h
===================================================================
--- linux-2.6.orig/include/linux/module.h	2007-11-19 14:44:06.233923291 -0800
+++ linux-2.6/include/linux/module.h	2007-11-19 15:10:50.982356094 -0800
@@ -219,8 +219,8 @@ void *__symbol_get_gpl(const char *symbo
 
 struct module_ref
 {
-	local_t count;
-} ____cacheline_aligned;
+	int count;
+};
 
 enum module_state
 {
@@ -324,7 +324,7 @@ struct module
 
 #ifdef CONFIG_MODULE_UNLOAD
 	/* Reference counts */
-	struct module_ref ref[NR_CPUS];
+	struct module_ref *ref;
 
 	/* What modules depend on me? */
 	struct list_head modules_which_use_me;
@@ -401,8 +401,7 @@ static inline void __module_get(struct m
 {
 	if (module) {
 		BUG_ON(module_refcount(module) == 0);
-		local_inc(&module->ref[get_cpu()].count);
-		put_cpu();
+		_CPU_INC(module->ref->count);
 	}
 }
 
@@ -411,12 +410,10 @@ static inline int try_module_get(struct 
 	int ret = 1;
 
 	if (module) {
-		unsigned int cpu = get_cpu();
 		if (likely(module_is_live(module)))
-			local_inc(&module->ref[cpu].count);
+			_CPU_INC(module->ref->count);
 		else
 			ret = 0;
-		put_cpu();
 	}
 	return ret;
 }
Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c	2007-11-19 14:44:06.241923622 -0800
+++ linux-2.6/kernel/module.c	2007-11-19 15:20:28.491897584 -0800
@@ -501,13 +501,11 @@ MODINFO_ATTR(srcversion);
 /* Init the unload section of the module. */
 static void module_unload_init(struct module *mod)
 {
-	unsigned int i;
-
 	INIT_LIST_HEAD(&mod->modules_which_use_me);
-	for (i = 0; i < NR_CPUS; i++)
-		local_set(&mod->ref[i].count, 0);
+	mod->ref = CPU_ALLOC(struct module_ref, GFP_KERNEL | __GFP_ZERO);
+
 	/* Hold reference count during initialization. */
-	local_set(&mod->ref[raw_smp_processor_id()].count, 1);
+	__CPU_WRITE(mod->ref->count, 1);
 	/* Backwards compatibility macros put refcount during init. */
 	mod->waiter = current;
 }
@@ -575,6 +573,7 @@ static void module_unload_free(struct mo
 				kfree(use);
 				sysfs_remove_link(i->holders_dir, mod->name);
 				/* There can be at most one match. */
+				CPU_FREE(i->ref);
 				break;
 			}
 		}
@@ -630,8 +629,8 @@ unsigned int module_refcount(struct modu
 {
 	unsigned int i, total = 0;
 
-	for (i = 0; i < NR_CPUS; i++)
-		total += local_read(&mod->ref[i].count);
+	for_each_online_cpu(i)
+		total += CPU_PTR(mod->ref, i)->count;
 	return total;
 }
 EXPORT_SYMBOL(module_refcount);
@@ -790,12 +789,10 @@ static struct module_attribute refcnt = 
 void module_put(struct module *module)
 {
 	if (module) {
-		unsigned int cpu = get_cpu();
-		local_dec(&module->ref[cpu].count);
+		_CPU_DEC(module->ref->count);
 		/* Maybe they're waiting for us to drop reference? */
 		if (unlikely(!module_is_live(module)))
 			wake_up_process(module->waiter);
-		put_cpu();
 	}
 }
 EXPORT_SYMBOL(module_put);

-- 
