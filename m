Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbZBGMt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbZBGMt0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 07:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZBGMqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 07:46:48 -0500
Received: from ozlabs.org ([203.10.76.45]:45018 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455AbZBGMqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 07:46:46 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 07 Feb 2009 23:15:22 +1030
Subject: [PATCH 6/9] Ksplice: Add functions for walking kallsyms symbols
Cc: Jeff Arnold <jbarnold@mit.edu>
Cc: Tim Abbott <tabbott@mit.edu>
Cc: Anders Kaseorg <andersk@mit.edu>
Message-Id: <20090207124645.467A2DDDDF@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Kaseorg <andersk@mit.edu>

Impact: New API

kallsyms_lookup_name only returns the first match that it finds.  Ksplice
needs information about all symbols with a given name in order to correctly
resolve local symbols.

kallsyms_on_each_symbol provides a generic mechanism for iterating over the
kallsyms table.

Cc: Jeff Arnold <jbarnold@mit.edu>
Cc: Tim Abbott <tabbott@mit.edu>
Signed-off-by: Anders Kaseorg <andersk@mit.edu>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/kallsyms.h |   13 +++++++++++++
 include/linux/module.h   |   12 ++++++++++++
 kernel/kallsyms.c        |   19 +++++++++++++++++++
 kernel/module.c          |   19 +++++++++++++++++++
 4 files changed, 63 insertions(+)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index f3fe343..37746b2 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -17,6 +17,11 @@
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
 
+/* Call a function on each kallsyms symbol in the core kernel */
+int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
+				      unsigned long),
+			    void *data);
+
 extern int kallsyms_lookup_size_offset(unsigned long addr,
 				  unsigned long *symbolsize,
 				  unsigned long *offset);
@@ -43,6 +48,14 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
 	return 0;
 }
 
+static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+						    struct module *,
+						    unsigned long),
+					  void *data)
+{
+	return 0;
+}
+
 static inline int kallsyms_lookup_size_offset(unsigned long addr,
 					      unsigned long *symbolsize,
 					      unsigned long *offset)
diff --git a/include/linux/module.h b/include/linux/module.h
index 2268147..29972a2 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -378,6 +378,10 @@ int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 /* Look for this name: can be of form module:name. */
 unsigned long module_kallsyms_lookup_name(const char *name);
 
+int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+					     struct module *, unsigned long),
+				   void *data);
+
 extern void __module_put_and_exit(struct module *mod, long code)
 	__attribute__((noreturn));
 #define module_put_and_exit(code) __module_put_and_exit(THIS_MODULE, code);
@@ -546,6 +550,14 @@ static inline unsigned long module_kallsyms_lookup_name(const char *name)
 	return 0;
 }
 
+static inline int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+							   struct module *,
+							   unsigned long),
+						 void *data)
+{
+	return 0;
+}
+
 static inline int register_module_notifier(struct notifier_block * nb)
 {
 	/* no events will happen anyway, so this can always succeed */
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 7b8b0f2..374faf9 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -161,6 +161,25 @@ unsigned long kallsyms_lookup_name(const char *name)
 	return module_kallsyms_lookup_name(name);
 }
 
+int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
+				      unsigned long),
+			    void *data)
+{
+	char namebuf[KSYM_NAME_LEN];
+	unsigned long i;
+	unsigned int off;
+	int ret;
+
+	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
+		off = kallsyms_expand_symbol(off, namebuf);
+		ret = fn(data, namebuf, NULL, kallsyms_addresses[i]);
+		if (ret != 0)
+			return ret;
+	}
+	return module_kallsyms_on_each_symbol(fn, data);
+}
+EXPORT_SYMBOL_GPL(kallsyms_on_each_symbol);
+
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
 				    unsigned long *offset)
diff --git a/kernel/module.c b/kernel/module.c
index c3cf234..8839d40 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2554,6 +2554,25 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 	preempt_enable();
 	return ret;
 }
+
+int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+					     struct module *, unsigned long),
+				   void *data)
+{
+	struct module *mod;
+	unsigned int i;
+	int ret;
+
+	list_for_each_entry(mod, &modules, list) {
+		for (i = 0; i < mod->num_symtab; i++) {
+			ret = fn(data, mod->strtab + mod->symtab[i].st_name,
+				 mod, mod->symtab[i].st_value);
+			if (ret != 0)
+				return ret;
+		}
+	}
+	return 0;
+}
 #endif /* CONFIG_KALLSYMS */
 
 static char *module_flags(struct module *mod, char *buf)

