Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab0BXUF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:05:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61077 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab0BXUFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:05:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com
Subject: [PATCH 07/10] module: __rcu annotations
Date: Wed, 24 Feb 2010 21:04:03 +0100
Message-Id: <1267041846-10469-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267041846-10469-1-git-send-email-arnd@arndb.de>
References: <1267041846-10469-1-git-send-email-arnd@arndb.de>
In-Reply-To: <20100223180127.GF6700@linux.vnet.ibm.com>
References: <20100223180127.GF6700@linux.vnet.ibm.com>
X-Provags-ID: V01U2FsdGVkX1/6O+NeZEuu0CK4tqYSPgjsY6yrU9PzRLO+3lB
 vWh+OFUEMwwmRmR8LhVtAv+JFixvSLwMKb3hJ4doY+dX8/3kZ5
 3s56I0Aqd7S1Uu80cfNNQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are partial, because the modules list is used
inconsistently with RCU. We actually pass a list_head
of an RCU protected list into another function.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/module.h |    4 ++--
 kernel/module.c        |   20 +++++++++++++-------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 6cb1a3c..94ce22e 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -6,7 +6,7 @@
  * Rewritten by Richard Henderson <rth@tamu.edu> Dec 1996
  * Rewritten again by Rusty Russell, 2002
  */
-#include <linux/list.h>
+#include <linux/rculist.h>
 #include <linux/stat.h>
 #include <linux/compiler.h>
 #include <linux/cache.h>
@@ -238,7 +238,7 @@ struct module
 	enum module_state state;
 
 	/* Member of list of modules */
-	struct list_head list;
+	struct rcu_list_head list;
 
 	/* Unique handle for this module */
 	char name[MODULE_NAME_LEN];
diff --git a/kernel/module.c b/kernel/module.c
index f82386b..d8b7603 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -78,7 +78,7 @@ EXPORT_TRACEPOINT_SYMBOL(module_get);
  * (delete uses stop_machine/add uses RCU list operations). */
 DEFINE_MUTEX(module_mutex);
 EXPORT_SYMBOL_GPL(module_mutex);
-static LIST_HEAD(modules);
+static LIST_HEAD_RCU(modules);
 
 /* Block module loading/unloading? */
 int modules_disabled = 0;
@@ -360,10 +360,12 @@ struct module *find_module(const char *name)
 {
 	struct module *mod;
 
-	list_for_each_entry(mod, &modules, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(mod, &modules, list) {
 		if (strcmp(mod->name, name) == 0)
 			return mod;
 	}
+	rcu_read_unlock();
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(find_module);
@@ -544,7 +546,8 @@ static void module_unload_free(struct module *mod)
 {
 	struct module *i;
 
-	list_for_each_entry(i, &modules, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(i, &modules, list) {
 		struct module_use *use;
 
 		list_for_each_entry(use, &i->modules_which_use_me, list) {
@@ -559,6 +562,7 @@ static void module_unload_free(struct module *mod)
 			}
 		}
 	}
+	rcu_read_unlock();
 }
 
 #ifdef CONFIG_MODULE_FORCE_UNLOAD
@@ -1368,7 +1372,7 @@ static void mod_kobject_remove(struct module *mod)
 static int __unlink_module(void *_mod)
 {
 	struct module *mod = _mod;
-	list_del(&mod->list);
+	list_del_rcu(&mod->list);
 	return 0;
 }
 
@@ -2718,7 +2722,8 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 	unsigned int i;
 	int ret;
 
-	list_for_each_entry(mod, &modules, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(mod, &modules, list) {
 		for (i = 0; i < mod->num_symtab; i++) {
 			ret = fn(data, mod->strtab + mod->symtab[i].st_name,
 				 mod, mod->symtab[i].st_value);
@@ -2726,6 +2731,7 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 				return ret;
 		}
 	}
+	rcu_read_unlock();
 	return 0;
 }
 #endif /* CONFIG_KALLSYMS */
@@ -2768,12 +2774,12 @@ static char *module_flags(struct module *mod, char *buf)
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
 	mutex_lock(&module_mutex);
-	return seq_list_start(&modules, *pos);
+	return seq_list_start((struct list_head *)&modules, *pos);
 }
 
 static void *m_next(struct seq_file *m, void *p, loff_t *pos)
 {
-	return seq_list_next(p, &modules, pos);
+	return seq_list_next(p, (struct list_head *)&modules, pos);
 }
 
 static void m_stop(struct seq_file *m, void *p)
-- 
1.6.3.3

