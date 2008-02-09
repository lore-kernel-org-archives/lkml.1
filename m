Return-Path: <linux-kernel-owner+w=401wt.eu-S1757955AbYBINgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbYBINgL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:36:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757238AbYBINfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:35:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:60449 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757417AbYBINfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:35:18 -0500
From: jason.wessel@windriver.com
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/8] kgdb, modules: Always allow module sect info for KGDB
Date: Sat,  9 Feb 2008 07:35:09 -0600
Message-Id: <1202564114-18587-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1202564114-18587-3-git-send-email-jason.wessel@windriver.com>
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 09 Feb 2008 13:34:54.0915 (UTC) FILETIME=[8E36F130:01C86B20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

With more information in the kernel, gdb can be modified in such a way
as to automatically read the kernel module section information and
allow for easy kernel module debugging.

In gdb the solib-search-path must contain the location of any module
to be debugged.  When a module is loaded GDB acts like a shared
library has been loaded and will collect the information about the
memory location so the kernel module can be debugged or inspected.

Even when not using kgdb+gdb, it is quite useful for a
debugger+ICE/jtag to have the module section information.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/module.h |    9 ++++++---
 kernel/module.c        |   34 ++++++++++++++++++++++------------
 2 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index ac28e87..87b0301 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -342,13 +342,16 @@ struct module
 	unsigned long num_symtab;
 	char *strtab;
 
-	/* Section attributes */
-	struct module_sect_attrs *sect_attrs;
-
 	/* Notes attributes */
 	struct module_notes_attrs *notes_attrs;
 #endif
 
+#if defined(CONFIG_KALLSYMS) || defined(CONFIG_KGDB)
+	/* Section attributes */
+	struct module_sect_attrs *sect_attrs;
+#endif
+
+
 	/* Per-cpu data. */
 	void *percpu;
 
diff --git a/kernel/module.c b/kernel/module.c
index 4202da9..4a94d1a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -602,6 +602,9 @@ static void module_unload_free(struct module *mod)
 			}
 		}
 	}
+	blocking_notifier_call_chain(&module_notify_list,
+				MODULE_STATE_GOING,
+				mod);
 }
 
 #ifdef CONFIG_MODULE_FORCE_UNLOAD
@@ -992,6 +995,7 @@ static unsigned long resolve_symbol(Elf_Shdr *sechdrs,
  * /sys/module/foo/sections stuff
  * J. Corbet <corbet@lwn.net>
  */
+#if defined(CONFIG_KALLSYMS) || defined(CONFIG_KGDB)
 #ifdef CONFIG_KALLSYMS
 static ssize_t module_sect_show(struct module_attribute *mattr,
 				struct module *mod, char *buf)
@@ -1000,6 +1004,7 @@ static ssize_t module_sect_show(struct module_attribute *mattr,
 		container_of(mattr, struct module_sect_attr, mattr);
 	return sprintf(buf, "0x%lx\n", sattr->address);
 }
+#endif /* CONFIG_KALLSYMS */
 
 static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
 {
@@ -1046,7 +1051,9 @@ static void add_sect_attrs(struct module *mod, unsigned int nsect,
 		if (sattr->name == NULL)
 			goto out;
 		sect_attrs->nsections++;
+#ifdef CONFIG_KALLSYMS
 		sattr->mattr.show = module_sect_show;
+#endif
 		sattr->mattr.store = NULL;
 		sattr->mattr.attr.name = sattr->name;
 		sattr->mattr.attr.mode = S_IRUGO;
@@ -1074,7 +1081,20 @@ static void remove_sect_attrs(struct module *mod)
 		mod->sect_attrs = NULL;
 	}
 }
+#else /* ! (CONFIG_KALLSYMS || CONFIG_KGDB) */
 
+static inline void add_sect_attrs(struct module *mod, unsigned int nsect,
+		char *sectstrings, Elf_Shdr *sechdrs)
+{
+}
+
+static inline void remove_sect_attrs(struct module *mod)
+{
+}
+
+#endif /* CONFIG_KALLSYMS || CONFIG_KGDB */
+
+#ifdef CONFIG_KALLSYMS
 /*
  * /sys/module/foo/notes/.section.name gives contents of SHT_NOTE sections.
  */
@@ -1168,18 +1188,7 @@ static void remove_notes_attrs(struct module *mod)
 	if (mod->notes_attrs)
 		free_notes_attrs(mod->notes_attrs, mod->notes_attrs->notes);
 }
-
 #else
-
-static inline void add_sect_attrs(struct module *mod, unsigned int nsect,
-		char *sectstrings, Elf_Shdr *sechdrs)
-{
-}
-
-static inline void remove_sect_attrs(struct module *mod)
-{
-}
-
 static inline void add_notes_attrs(struct module *mod, unsigned int nsect,
 				   char *sectstrings, Elf_Shdr *sechdrs)
 {
@@ -1188,7 +1197,8 @@ static inline void add_notes_attrs(struct module *mod, unsigned int nsect,
 static inline void remove_notes_attrs(struct module *mod)
 {
 }
-#endif /* CONFIG_KALLSYMS */
+#endif
+
 
 #ifdef CONFIG_SYSFS
 int module_add_modinfo_attrs(struct module *mod)
-- 
1.5.4

