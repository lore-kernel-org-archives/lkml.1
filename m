Return-Path: <linux-kernel-owner+w=401wt.eu-S934444AbXJOSmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934444AbXJOSmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933940AbXJOSer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:34:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:47928 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933348AbXJOSeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:34:31 -0400
Message-ID: <4713B289.20204@windriver.com>
Date: Mon, 15 Oct 2007 13:33:45 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: rusty@rustcorp.com.au
Subject: [PATCH 16/21] KGDB: This allows for KGDB to better deal with autoloaded
 modules.
Content-Type: multipart/mixed;
 boundary="------------000009000908050906030406"
X-OriginalArrivalTime: 15 Oct 2007 18:34:28.0876 (UTC) FILETIME=[0532FCC0:01C80F5A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000009000908050906030406
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

--------------000009000908050906030406
Content-Type: text/x-patch;
 name="module.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="module.patch"

module.patch

From: Jason Wessel <jason.wessel@windriver.com>
CC: rusty@rustcorp.com.au
Subject: [PATCH] This allows for KGDB to better deal with autoloaded modules.

With more information in the kernel, gdb can be modified in such a way
as to automatically read the kernel module section information and
allow for easy kernel module debugging.  This patch can be found at:

ftp://ftp.<countrycode>.kernel.org/pub/linux/kernel/people/trini/patches/gdb/6.3/gdb-6.3-kgdb-module-notification.patch

In gdb the solib-search-path must contain the location of any module
to be debugged.  When a module is loaded GDB acts like a shared
library has been loaded and will collect the information about the
memory location so the kernel module can be debugged or inspected.

Even when not using kgdb+gdb, it is quite useful for a
debugger+ICE/jtag to have the module section information.

Signed-off-by: Milind Dumbare <milind@linsyssoft.com>
Signed-off-by: Tom Rini <trini@kernel.crashing.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 include/linux/module.h |   16 +++++++++++++
 kernel/module.c        |   60 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

Index: linux-2.6-kgdb/include/linux/module.h
===================================================================
--- linux-2.6-kgdb.orig/include/linux/module.h
+++ linux-2.6-kgdb/include/linux/module.h
@@ -226,8 +226,17 @@ enum module_state
 	MODULE_STATE_LIVE,
 	MODULE_STATE_COMING,
 	MODULE_STATE_GOING,
+	MODULE_STATE_GONE,
 };
 
+#ifdef CONFIG_KGDB
+#define MAX_SECTNAME 31
+struct mod_section {
+	void *address;
+	char name[MAX_SECTNAME + 1];
+};
+#endif
+
 /* Similar stuff for section attributes. */
 struct module_sect_attr
 {
@@ -255,6 +264,13 @@ struct module
 	/* Unique handle for this module */
 	char name[MODULE_NAME_LEN];
 
+#ifdef CONFIG_KGDB
+	/* keep kgdb info at the begining so that gdb doesn't have a chance to
+	 * miss out any fields */
+	unsigned long num_sections;
+	struct mod_section *mod_sections;
+#endif
+
 	/* Sysfs stuff. */
 	struct module_kobject mkobj;
 	struct module_param_attrs *param_attrs;
Index: linux-2.6-kgdb/kernel/module.c
===================================================================
--- linux-2.6-kgdb.orig/kernel/module.c
+++ linux-2.6-kgdb/kernel/module.c
@@ -65,6 +65,7 @@ extern int module_sysfs_initialized;
  * (add/delete uses stop_machine). */
 static DEFINE_MUTEX(module_mutex);
 static LIST_HEAD(modules);
+static DECLARE_MUTEX(notify_mutex);
 
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);
 
@@ -710,6 +711,12 @@ sys_delete_module(const char __user *nam
 	if (ret != 0)
 		goto out;
 
+	down(&notify_mutex);
+	blocking_notifier_call_chain(&module_notify_list, MODULE_STATE_GOING,
+								 mod);
+	up(&notify_mutex);
+
+
 	/* Never wait if forced. */
 	if (!forced && module_refcount(mod) != 0)
 		wait_for_zero_refcount(mod);
@@ -722,6 +729,11 @@ sys_delete_module(const char __user *nam
 	}
 	free_module(mod);
 
+	down(&notify_mutex);
+	blocking_notifier_call_chain(&module_notify_list, MODULE_STATE_GONE,
+			NULL);
+	up(&notify_mutex);
+
  out:
 	mutex_unlock(&module_mutex);
 	return ret;
@@ -842,6 +854,9 @@ static ssize_t show_initstate(struct mod
 	case MODULE_STATE_GOING:
 		state = "going";
 		break;
+	case MODULE_STATE_GONE:
+		state = "gone";
+		break;
 	}
 	return sprintf(buffer, "%s\n", state);
 }
@@ -1206,6 +1221,11 @@ static void free_module(struct module *m
 	/* Arch-specific cleanup. */
 	module_arch_cleanup(mod);
 
+#ifdef CONFIG_KGDB
+	/* kgdb info */
+	vfree(mod->mod_sections);
+#endif
+
 	/* Module unload stuff */
 	module_unload_free(mod);
 
@@ -1465,6 +1485,30 @@ static void setup_modinfo(struct module 
 	}
 }
 
+#ifdef CONFIG_KGDB
+int add_modsects(struct module *mod, Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
+		const char *secstrings)
+{
+	 int i;
+
+	 mod->num_sections = hdr->e_shnum - 1;
+	 mod->mod_sections = vmalloc((hdr->e_shnum - 1) *
+		sizeof(struct mod_section));
+
+	 if (mod->mod_sections == NULL)
+		 return -ENOMEM;
+
+	 for (i = 1; i < hdr->e_shnum; i++) {
+		 mod->mod_sections[i - 1].address = (void *)sechdrs[i].sh_addr;
+		 strncpy(mod->mod_sections[i - 1].name, secstrings +
+				 sechdrs[i].sh_name, MAX_SECTNAME);
+		 mod->mod_sections[i - 1].name[MAX_SECTNAME] = '\0';
+	}
+
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_KALLSYMS
 static int is_exported(const char *name, const struct module *mod)
 {
@@ -1880,6 +1924,12 @@ static struct module *load_module(void _
 
 	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
 
+#ifdef CONFIG_KGDB
+	err = add_modsects(mod, hdr, sechdrs, secstrings);
+	 if (err < 0)
+		 goto nomodsectinfo;
+#endif
+
 	err = module_finalize(hdr, sechdrs, mod);
 	if (err < 0)
 		goto cleanup;
@@ -1940,6 +1990,11 @@ static struct module *load_module(void _
  arch_cleanup:
 	module_arch_cleanup(mod);
  cleanup:
+
+#ifdef CONFIG_KGDB
+nomodsectinfo:
+	vfree(mod->mod_sections);
+#endif
 	module_unload_free(mod);
 	module_free(mod, mod->module_init);
  free_core:
@@ -2011,6 +2066,11 @@ sys_init_module(void __user *umod,
 		/* Init routine failed: abort.  Try to protect us from
                    buggy refcounters. */
 		mod->state = MODULE_STATE_GOING;
+		down(&notify_mutex);
+		blocking_notifier_call_chain(&module_notify_list,
+				MODULE_STATE_GOING,
+				mod);
+		up(&notify_mutex);
 		synchronize_sched();
 		if (mod->unsafe)
 			printk(KERN_ERR "%s: module is now stuck!\n",

--------------000009000908050906030406--
