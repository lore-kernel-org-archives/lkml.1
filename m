Return-Path: <linux-kernel-owner+w=401wt.eu-S1755822AbZBGMrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbZBGMrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 07:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbZBGMqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 07:46:44 -0500
Received: from ozlabs.org ([203.10.76.45]:45014 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbZBGMqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 07:46:43 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 07 Feb 2009 23:15:22 +1030
Subject: [PATCH 2/9] module: __module_address
Cc: Anders Kaseorg <andersk@mit.edu>
Cc: Jeff Arnold <jbarnold@mit.edu>
Cc: Tim Abbott <tabbott@mit.edu>
Message-Id: <20090207124640.8BC5EDDDE3@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: New API, cleanup

ksplice wants to know the bounds of a module, not just the module text.

It makes sense to have __module_address.  We then implement
is_module_address and __module_text_address in terms of this (and
change is_module_text_address() to bool while we're at it).

Also, add proper kerneldoc for them all.

Cc: Anders Kaseorg <andersk@mit.edu>
Cc: Jeff Arnold <jbarnold@mit.edu>
Cc: Tim Abbott <tabbott@mit.edu>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h |   20 +++++++++---
 kernel/module.c        |   76 +++++++++++++++++++++++++++++++++++++------------
 2 files changed, 73 insertions(+), 23 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -361,7 +361,9 @@ static inline int module_is_live(struct 
 /* Is this address in a module? (second is with no locks, for oops) */
 struct module *module_text_address(unsigned long addr);
 struct module *__module_text_address(unsigned long addr);
-int is_module_address(unsigned long addr);
+struct module *__module_address(unsigned long addr);
+bool is_module_address(unsigned long addr);
+bool is_module_text_address(unsigned long addr);
 
 static inline int within_module_core(unsigned long addr, struct module *mod)
 {
@@ -490,21 +492,29 @@ search_module_extables(unsigned long add
 	return NULL;
 }
 
-/* Is this address in a module? */
 static inline struct module *module_text_address(unsigned long addr)
 {
 	return NULL;
 }
 
-/* Is this address in a module? (don't take a lock, we're oopsing) */
+static inline struct module *__module_address(unsigned long addr)
+{
+	return NULL;
+}
+
 static inline struct module *__module_text_address(unsigned long addr)
 {
 	return NULL;
 }
 
-static inline int is_module_address(unsigned long addr)
+static inline bool is_module_address(unsigned long addr)
 {
-	return 0;
+	return false;
+}
+
+static inline bool is_module_text_address(unsigned long addr)
+{
+	return false;
 }
 
 /* Get/put a kernel symbol (calls should be symmetric) */
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -75,7 +75,7 @@ static DECLARE_WAIT_QUEUE_HEAD(module_wq
 
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);
 
-/* Bounds of module allocation, for speeding __module_text_address */
+/* Bounds of module allocation, for speeding __module_address */
 static unsigned long module_addr_min = -1UL, module_addr_max = 0;
 
 int register_module_notifier(struct notifier_block * nb)
@@ -2712,29 +2712,31 @@ const struct exception_table_entry *sear
 }
 
 /*
- * Is this a valid module address?
+ * is_module_address - is this address inside a module?
+ * @addr: the address to check.
+ *
+ * See is_module_text_address() if you simply want to see if the address
+ * is code (not data).
  */
-int is_module_address(unsigned long addr)
+bool is_module_address(unsigned long addr)
 {
-	struct module *mod;
+	bool ret;
 
 	preempt_disable();
-
-	list_for_each_entry_rcu(mod, &modules, list) {
-		if (within_module_core(addr, mod)) {
-			preempt_enable();
-			return 1;
-		}
-	}
-
+	ret = __module_address(addr) != NULL;
 	preempt_enable();
 
-	return 0;
+	return ret;
 }
 
-
-/* Is this a valid kernel address? */
-__notrace_funcgraph struct module *__module_text_address(unsigned long addr)
+/*
+ * __module_address - get the module which contains an address.
+ * @addr: the address.
+ *
+ * Must be called with preempt disabled or module mutex held so that
+ * module doesn't get freed during this.
+ */
+__notrace_funcgraph struct module *__module_address(unsigned long addr)
 {
 	struct module *mod;
 
@@ -2742,10 +2744,48 @@ __notrace_funcgraph struct module *__mod
 		return NULL;
 
 	list_for_each_entry_rcu(mod, &modules, list)
-		if (within(addr, mod->module_init, mod->init_text_size)
-		    || within(addr, mod->module_core, mod->core_text_size))
+		if (within_module_core(addr, mod)
+		    || within_module_init(addr, mod))
 			return mod;
 	return NULL;
+}
+
+/*
+ * is_module_text_address - is this address inside module code?
+ * @addr: the address to check.
+ *
+ * See is_module_address() if you simply want to see if the address is
+ * anywhere in a module.  See kernel_text_address() for testing if an
+ * address corresponds to kernel or module code.
+ */
+bool is_module_text_address(unsigned long addr)
+{
+	bool ret;
+
+	preempt_disable();
+	ret = __module_text_address(addr) != NULL;
+	preempt_enable();
+
+	return ret;
+}
+
+/*
+ * __module_text_address - get the module whose code contains an address.
+ * @addr: the address.
+ *
+ * Must be called with preempt disabled or module mutex held so that
+ * module doesn't get freed during this.
+ */
+struct module *__module_text_address(unsigned long addr)
+{
+	struct module *mod = __module_address(addr);
+	if (mod) {
+		/* Make sure it's within the text section. */
+		if (!within(addr, mod->module_init, mod->init_text_size)
+		    && !within(addr, mod->module_core, mod->core_text_size))
+			mod = NULL;
+	}
+	return mod;
 }
 
 struct module *module_text_address(unsigned long addr)

