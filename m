Return-Path: <linux-kernel-owner+w=401wt.eu-S1758939AbYE3EIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939AbYE3EIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYE3EA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:57 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40548 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753047AbYE3EAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:23 -0400
Message-Id: <20080530040020.463478427@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:48 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 28/41] Module handling: Use CPU_xx ops to dynamically allocate counters
Content-Disposition: inline; filename=cpu_alloc_remove_local_t_in_kernel_module
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpu ops to deal with the per cpu data instead of a local_t. Reduces memory
requirements, cache footprint and decreases cycle counts.

Avoid a loop to NR_CPUS here. Use the possible map instead.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/module.h |   13 +++++--------
 kernel/module.c        |   17 +++++++----------
 2 files changed, 12 insertions(+), 18 deletions(-)

Index: linux-2.6/include/linux/module.h
===================================================================
--- linux-2.6.orig/include/linux/module.h	2008-05-21 22:41:03.000000000 -0700
+++ linux-2.6/include/linux/module.h	2008-05-21 23:19:39.000000000 -0700
@@ -219,8 +219,8 @@
 
 struct module_ref
 {
-	local_t count;
-} ____cacheline_aligned;
+	int count;
+};
 
 enum module_state
 {
@@ -307,7 +307,7 @@
 
 #ifdef CONFIG_MODULE_UNLOAD
 	/* Reference counts */
-	struct module_ref ref[NR_CPUS];
+	struct module_ref *ref;
 
 	/* What modules depend on me? */
 	struct list_head modules_which_use_me;
@@ -385,8 +385,7 @@
 {
 	if (module) {
 		BUG_ON(module_refcount(module) == 0);
-		local_inc(&module->ref[get_cpu()].count);
-		put_cpu();
+		_CPU_INC(module->ref->count);
 	}
 }
 
@@ -395,12 +394,12 @@
 	int ret = 1;
 
 	if (module) {
-		unsigned int cpu = get_cpu();
+		preempt_disable();
 		if (likely(module_is_live(module)))
-			local_inc(&module->ref[cpu].count);
+			__CPU_INC(module->ref->count);
 		else
 			ret = 0;
-		put_cpu();
+		preempt_enable();
 	}
 	return ret;
 }
Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c	2008-05-21 22:41:03.000000000 -0700
+++ linux-2.6/kernel/module.c	2008-05-21 23:17:20.000000000 -0700
@@ -366,13 +366,11 @@
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
@@ -450,6 +448,7 @@
 				kfree(use);
 				sysfs_remove_link(i->holders_dir, mod->name);
 				/* There can be at most one match. */
+				CPU_FREE(i->ref);
 				break;
 			}
 		}
@@ -505,8 +504,8 @@
 {
 	unsigned int i, total = 0;
 
-	for (i = 0; i < NR_CPUS; i++)
-		total += local_read(&mod->ref[i].count);
+	for_each_online_cpu(i)
+		total += CPU_PTR(mod->ref, i)->count;
 	return total;
 }
 EXPORT_SYMBOL(module_refcount);
@@ -667,12 +666,12 @@
 void module_put(struct module *module)
 {
 	if (module) {
-		unsigned int cpu = get_cpu();
-		local_dec(&module->ref[cpu].count);
+		preempt_disable();
+		_CPU_DEC(module->ref->count);
 		/* Maybe they're waiting for us to drop reference? */
 		if (unlikely(!module_is_live(module)))
 			wake_up_process(module->waiter);
-		put_cpu();
+		preempt_enable();
 	}
 }
 EXPORT_SYMBOL(module_put);

-- 
