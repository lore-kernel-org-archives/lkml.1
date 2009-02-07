Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbZBGMs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbZBGMs0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 07:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbZBGMqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 07:46:45 -0500
Received: from ozlabs.org ([203.10.76.45]:45016 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247AbZBGMqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 07:46:43 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 07 Feb 2009 23:15:22 +1030
Subject: [PATCH 3/9] module: remove module_text_address()
Cc: linux-mtd@lists.infradead.org
Message-Id: <20090207124642.62B22DDDDF@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Replace and remove risky (non-EXPORTed) API

module_text_address() returns a pointer to the module, which given locking
improvements in module.c, is useless except to test for NULL:

1) If the module can't go away, use __module_text_address.
2) Otherwise, just use is_module_text_address().

Cc: linux-mtd@lists.infradead.org
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/mtd/nand/nand_base.c |    4 ++--
 include/linux/module.h       |    7 -------
 kernel/extable.c             |    6 +++---
 kernel/module.c              |   17 ++++-------------
 4 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2720,14 +2720,14 @@ int nand_scan_tail(struct mtd_info *mtd)
 	return chip->scan_bbt(mtd);
 }
 
-/* module_text_address() isn't exported, and it's mostly a pointless
+/* is_module_text_address() isn't exported, and it's mostly a pointless
    test if this is a module _anyway_ -- they'd have to try _really_ hard
    to call us from in-kernel code if the core NAND support is modular. */
 #ifdef MODULE
 #define caller_is_module() (1)
 #else
 #define caller_is_module() \
-	module_text_address((unsigned long)__builtin_return_address(0))
+	is_module_text_address((unsigned long)__builtin_return_address(0))
 #endif
 
 /**
diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -358,8 +358,6 @@ static inline int module_is_live(struct 
 	return mod->state != MODULE_STATE_GOING;
 }
 
-/* Is this address in a module? (second is with no locks, for oops) */
-struct module *module_text_address(unsigned long addr);
 struct module *__module_text_address(unsigned long addr);
 struct module *__module_address(unsigned long addr);
 bool is_module_address(unsigned long addr);
@@ -488,11 +486,6 @@ extern int module_get_iter_tracepoints(s
 /* Given an address, look for it in the exception tables. */
 static inline const struct exception_table_entry *
 search_module_extables(unsigned long addr)
-{
-	return NULL;
-}
-
-static inline struct module *module_text_address(unsigned long addr)
 {
 	return NULL;
 }
diff --git a/kernel/extable.c b/kernel/extable.c
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -58,14 +58,14 @@ __notrace_funcgraph int __kernel_text_ad
 {
 	if (core_kernel_text(addr))
 		return 1;
-	return __module_text_address(addr) != NULL;
+	return is_module_text_address(addr);
 }
 
 int kernel_text_address(unsigned long addr)
 {
 	if (core_kernel_text(addr))
 		return 1;
-	return module_text_address(addr) != NULL;
+	return is_module_text_address(addr);
 }
 
 /*
@@ -81,5 +81,5 @@ int func_ptr_is_kernel_text(void *ptr)
 	addr = (unsigned long) dereference_function_descriptor(ptr);
 	if (core_kernel_text(addr))
 		return 1;
-	return module_text_address(addr) != NULL;
+	return is_module_text_address(addr);
 }
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -874,8 +874,10 @@ void symbol_put_addr(void *addr)
 	if (core_kernel_text((unsigned long)addr))
 		return;
 
-	if (!(modaddr = module_text_address((unsigned long)addr)))
-		BUG();
+	/* module_text_address is safe here: we're supposed to have reference
+	 * to module from symbol_get, so it can't go away. */
+	modaddr = __module_text_address((unsigned long)addr);
+	BUG_ON(!modaddr);
 	module_put(modaddr);
 }
 EXPORT_SYMBOL_GPL(symbol_put_addr);
@@ -2788,17 +2790,6 @@ struct module *__module_text_address(uns
 	return mod;
 }
 
-struct module *module_text_address(unsigned long addr)
-{
-	struct module *mod;
-
-	preempt_disable();
-	mod = __module_text_address(addr);
-	preempt_enable();
-
-	return mod;
-}
-
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
 {

