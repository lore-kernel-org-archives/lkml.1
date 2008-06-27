Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbYF0MlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbYF0MlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 08:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbYF0Mk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 08:40:57 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:17955 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbYF0Mk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 08:40:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=KR2QB8j1EpH7IrT8+3EZgR3BBkhvL2BQyr6BHfRbKsaBVaCDGGsoD+4H7MHzHwXJ0x
         XD91FcVOxGx4YrF+iVe0Aw6SgQWFqVXZJpEnMmRAdGb04LB5x8xSY2tJy1B5Q/wieuc8
         AWX/SiI4VniTzz3d2wloZAiYzHh9jG18sR/28=
Message-ID: <4864DFD2.60508@gmail.com>
Date: Fri, 27 Jun 2008 05:40:50 -0700
From: "nkalmala@gmail.com" <nkalmala@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, rusty@rustcorp.com.au
Subject: [patch] experimental: try-resolve-unexported-symbol-references-in-modules
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For purely experimental purposes, let the kernel resolve unexported-symbol references
in external modules when loading them. Iff used carefully, this helps save time on 
development cycles. building testing experimenting certain kinds of changes becomes 
really fast.

Signed-off-by: <nkalmala@gmail.com>
---

 include/linux/kallsyms.h |   11 +++++++++++
 include/linux/module.h   |   11 ++++++++---
 init/Kconfig             |   18 ++++++++++++++++++
 kernel/kallsyms.c        |   21 ++++++++++++++++++---
 kernel/module.c          |   31 ++++++++++++++++++++++++++++---
 5 files changed, 83 insertions(+), 9 deletions(-)


diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 00c1801..f39569d 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -13,8 +13,12 @@
 			 2*(BITS_PER_LONG*3/10) + (MODULE_NAME_LEN - 1) + 1)
 
 #ifdef CONFIG_KALLSYMS
+struct module;
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
+/* Like above, but this also tells which module (owner) defines the symbol,
+ * NULL if kernel or no symbol */
+unsigned long kallsyms_lookup_name_owner(const char *name, struct module **owner);
 
 extern int kallsyms_lookup_size_offset(unsigned long addr,
 				  unsigned long *symbolsize,
@@ -42,6 +46,13 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
 	return 0;
 }
 
+static inline unsigned long kallsyms_lookup_name_owner(const char *name,
+		struct module **owner)
+{
+	if (owner) *owner = NULL;
+	return 0;
+}
+
 static inline int kallsyms_lookup_size_offset(unsigned long addr,
 					      unsigned long *symbolsize,
 					      unsigned long *offset)
diff --git a/include/linux/module.h b/include/linux/module.h
index 3e03b1a..e99da01 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -365,8 +365,11 @@ int is_module_address(unsigned long addr);
 int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
 			char *name, char *module_name, int *exported);
 
-/* Look for this name: can be of form module:name. */
-unsigned long module_kallsyms_lookup_name(const char *name);
+/* Look for this name: can be of form module:name.
+ * If name is a module symbol, *owner will be set to struct module, NULL
+ * otherwise */
+unsigned long module_kallsyms_lookup_name(const char *name,
+		struct module **owner);
 
 extern void __module_put_and_exit(struct module *mod, long code)
 	__attribute__((noreturn));
@@ -528,8 +531,10 @@ static inline int module_get_kallsym(unsigned int symnum, unsigned long *value,
 	return -ERANGE;
 }
 
-static inline unsigned long module_kallsyms_lookup_name(const char *name)
+static inline unsigned long module_kallsyms_lookup_name(const char *name,
+		struct module **owner)
 {
+	if (owner) *owner = NULL;
 	return 0;
 }
 
diff --git a/init/Kconfig b/init/Kconfig
index 6199d11..c0c2810 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -892,6 +892,24 @@ config MODULE_SRCVERSION_ALL
 	  the version).  With this option, such a "srcversion" field
 	  will be created for all modules.  If unsure, say N.
 
+config RESOLVE_UNEXPORTED_SYMBOL
+	bool "Try to resolve unexported symbols (experimental use only)"
+	depends on MODULES && KALLSYMS
+	default n
+	help
+	  Say Y here to let the kernel resolve unexported-symbol references
+	  in external modules when loading them. This taints the kernel with
+	  TAINT_PROPRIETARY_MODULE and TAINT_FORCED_MODULE, when the first
+	  unexported symbol gets resolved; this also bypasses version checks,
+	  if enabled, on such symbols. Use carefully.
+	  Building the kernel with KALLSYMS_ALL expands the range of symbols
+	  that can be referenced.
+	  This is purely for experimental purposes. Enable this config if you
+	  prefer experimenting in the kernel using loadable modules. Once the
+	  kernel gets tainted by resolving an unexported symbol, any subsequent
+	  kernel issue becomes the individual's responsibility to worry; do not
+	  report back those issues.
+
 config KMOD
 	bool "Automatic kernel module loading"
 	depends on MODULES
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 6fc0040..f0e8928 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -146,7 +146,8 @@ static unsigned int get_symbol_offset(unsigned long pos)
 }
 
 /* Lookup the address for this symbol. Returns 0 if not found. */
-unsigned long kallsyms_lookup_name(const char *name)
+static unsigned long __kallsyms_lookup_name_owner(const char *name,
+		struct module **owner)
 {
 	char namebuf[KSYM_NAME_LEN];
 	unsigned long i;
@@ -155,10 +156,24 @@ unsigned long kallsyms_lookup_name(const char *name)
 	for (i = 0, off = 0; i < kallsyms_num_syms; i++) {
 		off = kallsyms_expand_symbol(off, namebuf);
 
-		if (strcmp(namebuf, name) == 0)
+		if (strcmp(namebuf, name) == 0) {
+			if (owner)
+				*owner = NULL;
 			return kallsyms_addresses[i];
+		}
 	}
-	return module_kallsyms_lookup_name(name);
+	return module_kallsyms_lookup_name(name, owner);
+}
+
+unsigned long kallsyms_lookup_name(const char *name)
+{
+	return __kallsyms_lookup_name_owner(name, NULL);
+}
+
+unsigned long kallsyms_lookup_name_owner(const char *name,
+		struct module **owner)
+{
+	return __kallsyms_lookup_name_owner(name, owner);
 }
 
 static unsigned long get_symbol_pos(unsigned long addr,
diff --git a/kernel/module.c b/kernel/module.c
index 5f80478..c8863f1 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1001,13 +1001,30 @@ static unsigned long resolve_symbol(Elf_Shdr *sechdrs,
 	struct module *owner;
 	unsigned long ret;
 	const unsigned long *crc;
+	int check_ver = 1;
 
 	ret = find_symbol(name, &owner, &crc,
 			  !(mod->taints & TAINT_PROPRIETARY_MODULE), true);
+
+#ifdef CONFIG_RESOLVE_UNEXPORTED_SYMBOL
+	if (IS_ERR_VALUE(ret)) {
+		unsigned long addr = kallsyms_lookup_name_owner(name, &owner);
+		check_ver = 0;
+		if (addr) {
+			ret = addr;
+			printk(KERN_WARNING "%s: Symbol %s not exported.. "
+				"resolved to %s:%lx - kernel tainted\n", mod->name,
+				name, owner ? owner->name : "", ret);
+			add_taint(TAINT_FORCED_MODULE);
+			add_taint(TAINT_PROPRIETARY_MODULE);
+		}
+	}
+#endif
+
 	if (!IS_ERR_VALUE(ret)) {
 		/* use_module can fail due to OOM,
 		   or module initialization or unloading */
-		if (!check_version(sechdrs, versindex, name, mod, crc) ||
+		if ((check_ver && !check_version(sechdrs, versindex, name, mod, crc)) ||
 		    !use_module(mod, owner))
 			ret = -EINVAL;
 	}
@@ -2435,8 +2452,12 @@ static unsigned long mod_find_symname(struct module *mod, const char *name)
 	return 0;
 }
 
-/* Look for this name: can be of form module:name. */
-unsigned long module_kallsyms_lookup_name(const char *name)
+/* Look for this name: can be of form module:name.
+ * if symbol found in a module, *owner will be set to its struct module,
+ * else NULL
+ */
+unsigned long module_kallsyms_lookup_name(const char *name,
+		struct module **owner)
 {
 	struct module *mod;
 	char *colon;
@@ -2455,6 +2476,10 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 				break;
 	}
 	preempt_enable();
+
+	if (owner)
+		*owner = ret ? mod : NULL;
+
 	return ret;
 }
 #endif /* CONFIG_KALLSYMS */
