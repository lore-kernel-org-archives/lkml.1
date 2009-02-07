Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZBGMr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZBGMr3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 07:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbZBGMqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 07:46:43 -0500
Received: from ozlabs.org ([203.10.76.45]:45013 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbZBGMql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 07:46:41 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 07 Feb 2009 23:15:22 +1030
Subject: [PATCH 7/9] module: Export symbols needed for Ksplice
Cc: Anders Kaseorg <andersk@mit.edu>
Cc: Jeff Arnold <jbarnold@mit.edu>
Cc: Tim Abbott <tabbott@mit.edu>
Message-Id: <20090207124640.2E724DDDDF@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@mit.edu>

Impact: Expose some module.c symbols

Ksplice uses several functions from module.c in order to resolve
symbols and implement dependency handling.  Calling these functions
requires holding module_mutex, so it is exported.

(This is just the module part of a bigger add-exports patch from Tim).b

Cc: Anders Kaseorg <andersk@mit.edu>
Cc: Jeff Arnold <jbarnold@mit.edu>
Signed-off-by: Tim Abbott <tabbott@mit.edu>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/module.h |   28 ++++++++++++++++++++++++++++
 kernel/module.c        |   41 +++++++++++++++++------------------------
 2 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -350,6 +350,8 @@ struct module
 #define MODULE_ARCH_INIT {}
 #endif
 
+extern struct mutex module_mutex;
+
 /* FIXME: It'd be nice to isolate modules during init, too, so they
    aren't used before they (may) fail.  But presently too much code
    (IDE & SCSI) require entry into the module during init.*/
@@ -374,6 +376,31 @@ static inline int within_module_init(uns
 	return (unsigned long)mod->module_init <= addr &&
 	       addr < (unsigned long)mod->module_init + mod->init_size;
 }
+
+/* Search for module by name: must hold module_mutex. */
+struct module *find_module(const char *name);
+
+struct symsearch {
+	const struct kernel_symbol *start, *stop;
+	const unsigned long *crcs;
+	enum {
+		NOT_GPL_ONLY,
+		GPL_ONLY,
+		WILL_BE_GPL_ONLY,
+	} licence;
+	bool unused;
+};
+
+/* Search for an exported symbol by name. */
+const struct kernel_symbol *find_symbol(const char *name,
+					struct module **owner,
+					const unsigned long **crc,
+					bool gplok,
+					bool warn);
+
+/* Walk the exported symbol table */
+bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
+			    unsigned int symnum, void *data), void *data);
 
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
    symnum out of range. */
@@ -448,6 +475,7 @@ static inline void __module_get(struct m
 #define symbol_put_addr(p) do { } while(0)
 
 #endif /* CONFIG_MODULE_UNLOAD */
+int use_module(struct module *a, struct module *b);
 
 /* This is a #define so the string doesn't get put in every .o file */
 #define module_name(mod)			\
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -67,7 +67,8 @@
 
 /* List of modules, protected by module_mutex or preempt_disable
  * (delete uses stop_machine/add uses RCU list operations). */
-static DEFINE_MUTEX(module_mutex);
+DEFINE_MUTEX(module_mutex);
+EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
 
 /* Waiting for a module to finish initializing? */
@@ -185,17 +186,6 @@ extern const unsigned long __start___kcr
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif
 
-struct symsearch {
-	const struct kernel_symbol *start, *stop;
-	const unsigned long *crcs;
-	enum {
-		NOT_GPL_ONLY,
-		GPL_ONLY,
-		WILL_BE_GPL_ONLY,
-	} licence;
-	bool unused;
-};
-
 static bool each_symbol_in_section(const struct symsearch *arr,
 				   unsigned int arrsize,
 				   struct module *owner,
@@ -216,10 +206,8 @@ static bool each_symbol_in_section(const
 }
 
 /* Returns true as soon as fn returns true, otherwise false. */
-static bool each_symbol(bool (*fn)(const struct symsearch *arr,
-				   struct module *owner,
-				   unsigned int symnum, void *data),
-			void *data)
+bool each_symbol(bool (*fn)(const struct symsearch *arr, struct module *owner,
+			    unsigned int symnum, void *data), void *data)
 {
 	struct module *mod;
 	const struct symsearch arr[] = {
@@ -272,6 +260,7 @@ static bool each_symbol(bool (*fn)(const
 	}
 	return false;
 }
+EXPORT_SYMBOL_GPL(each_symbol);
 
 struct find_symbol_arg {
 	/* Input */
@@ -329,11 +318,11 @@ static bool find_symbol_in_section(const
 
 /* Find a symbol and return it, along with, (optional) crc and
  * (optional) module which owns it */
-static const struct kernel_symbol *find_symbol(const char *name,
-					       struct module **owner,
-					       const unsigned long **crc,
-					       bool gplok,
-					       bool warn)
+const struct kernel_symbol *find_symbol(const char *name,
+					struct module **owner,
+					const unsigned long **crc,
+					bool gplok,
+					bool warn)
 {
 	struct find_symbol_arg fsa;
 
@@ -352,9 +341,10 @@ static const struct kernel_symbol *find_
 	DEBUGP("Failed to find symbol %s\n", name);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(find_symbol);
 
 /* Search for module by name: must hold module_mutex. */
-static struct module *find_module(const char *name)
+struct module *find_module(const char *name)
 {
 	struct module *mod;
 
@@ -364,6 +354,7 @@ static struct module *find_module(const 
 	}
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(find_module);
 
 #ifdef CONFIG_SMP
 /* Number of blocks used and allocated. */
@@ -607,7 +598,7 @@ static int already_uses(struct module *a
 }
 
 /* Module a uses b */
-static int use_module(struct module *a, struct module *b)
+int use_module(struct module *a, struct module *b)
 {
 	struct module_use *use;
 	int no_warn, err;
@@ -640,6 +631,7 @@ static int use_module(struct module *a, 
 	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
 	return 1;
 }
+EXPORT_SYMBOL_GPL(use_module);
 
 /* Clear the unload stuff of the module. */
 static void module_unload_free(struct module *mod)
@@ -917,10 +909,11 @@ static inline void module_unload_free(st
 {
 }
 
-static inline int use_module(struct module *a, struct module *b)
+int use_module(struct module *a, struct module *b)
 {
 	return strong_try_module_get(b) == 0;
 }
+EXPORT_SYMBOL_GPL(use_module);
 
 static inline void module_unload_init(struct module *mod)
 {

