Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYAYWML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYAYWML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbYAYWL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:11:58 -0500
Received: from mail.windriver.com ([147.11.1.11]:36219 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbYAYWL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:11:56 -0500
Message-ID: <479A5EA9.8060202@windriver.com>
Date: Fri, 25 Jan 2008 16:11:53 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] KGDB: This allows for KGDB to better deal with
 autoloaded modules.
References: <4713B289.20204@windriver.com> <200801180833.08185.rusty@rustcorp.com.au>
In-Reply-To: <200801180833.08185.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jan 2008 22:11:41.0745 (UTC) FILETIME=[43877A10:01C85F9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Tuesday 16 October 2007 04:33:45 Jason Wessel wrote:
>> With more information in the kernel, gdb can be modified in such a way
>> as to automatically read the kernel module section information and
>> allow for easy kernel module debugging.  This patch can be found at:
> 
> Hi Jason,
> 
>     Some comments on your patch:
> 
>> @@ -226,8 +226,17 @@ enum module_state
>>         MODULE_STATE_LIVE,
>>         MODULE_STATE_COMING,
>>         MODULE_STATE_GOING,
>> +       MODULE_STATE_GONE,
>>  };
> 
> A new state is added, but it's not actually ever set in a module (it's used 
> for notifiers).  That's fine, but a comment is nice, and you don't need to 
> add the printing code :)
> 
>> +#ifdef CONFIG_KGDB
>> +#define MAX_SECTNAME 31
>> +struct mod_section {
>> +       void *address;
>> +       char name[MAX_SECTNAME + 1];
>> +};
>> +#endif
>> +
> 
> We already have this information in "sect_attrs".  It would be better to 
> combine with that somehow, as far as I can tell.
> 
>>         }
>>         free_module(mod);
>>  
>> +       down(&notify_mutex);
>> +       blocking_notifier_call_chain(&module_notify_list, MODULE_STATE_GONE,
>> +                       NULL); 
>> +       up(&notify_mutex);
>> +
> 
> Err, that's horribly inconsistent (handing NULL).  It would be far more useful 
> before the free_module(), (or at least before the actual free), and handing 
> the module arg.
> 
>> @@ -842,6 +854,9 @@ static ssize_t show_initstate(struct mod
>>         case MODULE_STATE_GOING:
>>                 state = "going";
>>                 break;
>> +       case MODULE_STATE_GONE:
>> +               state = "gone";
>> +               break;
>>         }
>>         return sprintf(buffer, "%s\n", state);
>>  }
> 
> This is the printing code that can't happen...
> 
> 
>> +#ifdef CONFIG_KGDB
>> +int add_modsects(struct module *mod, Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
>> +               const char *secstrings)
>> +{
> ...
>> +       return 0;
>> +}
>> +#endif
> 
> This should be static, and should have a noop version under #else...
> 
>> +
>>  #ifdef CONFIG_KALLSYMS
>>  static int is_exported(const char *name, const struct module *mod)
>>  {
>> @@ -1880,6 +1924,12 @@ static struct module *load_module(void _
>>  
>>         add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
>>  
>> +#ifdef CONFIG_KGDB
>> +       err = add_modsects(mod, hdr, sechdrs, secstrings);
>> +        if (err < 0)
>> +                goto nomodsectinfo;
>> +#endif
>> +
> 
> ...so this that code doesn't need an ifdef.
> 
> Thanks!
> Rusty.

Rusty thanks for all your comments.

I restructured the gdb kernel module awareness based on the consolidation of the KGDB section headers into the KALLSYMS  requirement for section headers.  The new patch to a non patched module.c and module.h is as follows.  Below that patch, you will find the delta to the original patch included in the x86.git tree which will clean up the kgdb module code as desired.

Please feel free to further comment.

Thanks,
Jason.

-----------Patch against Clean kernel-------------

From: Jason Wessel <jason.wessel@windriver.com>
CC: rusty@rustcorp.com.au
Subject: [PATCH] This allows for KGDB to better deal with autoloaded modules.

With more information in the kernel, gdb can be modified in such a way
as to automatically read the kernel module section information and
allow for easy kernel module debugging.

In gdb the solib-search-path must contain the location of any module
to be debugged.  When a module is loaded GDB acts like a shared
library has been loaded and will collect the information about the
memory location so the kernel module can be debugged or inspected.

Even when not using kgdb+gdb, it is quite useful for a
debugger+ICE/jtag to have the module section information, which
can be obtained by configure KGDB into the kernel or using
CONFIG_KALLSYMS.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 include/linux/module.h |    9 ++++++---
 kernel/module.c        |   34 ++++++++++++++++++++++------------
 2 files changed, 28 insertions(+), 15 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -580,6 +580,9 @@ static void module_unload_free(struct mo
 			}
 		}
 	}
+	blocking_notifier_call_chain(&module_notify_list,
+				MODULE_STATE_GOING,
+				mod);
 }
 
 #ifdef CONFIG_MODULE_FORCE_UNLOAD
@@ -967,6 +970,7 @@ static unsigned long resolve_symbol(Elf_
  * /sys/module/foo/sections stuff
  * J. Corbet <corbet@lwn.net>
  */
+#if defined(CONFIG_KALLSYMS) || defined(CONFIG_KGDB)
 #ifdef CONFIG_KALLSYMS
 static ssize_t module_sect_show(struct module_attribute *mattr,
 				struct module *mod, char *buf)
@@ -975,6 +979,7 @@ static ssize_t module_sect_show(struct m
 		container_of(mattr, struct module_sect_attr, mattr);
 	return sprintf(buf, "0x%lx\n", sattr->address);
 }
+#endif /* CONFIG_KALLSYMS */
 
 static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
 {
@@ -1021,7 +1026,9 @@ static void add_sect_attrs(struct module
 		if (sattr->name == NULL)
 			goto out;
 		sect_attrs->nsections++;
+#ifdef CONFIG_KALLSYMS
 		sattr->mattr.show = module_sect_show;
+#endif
 		sattr->mattr.store = NULL;
 		sattr->mattr.attr.name = sattr->name;
 		sattr->mattr.attr.mode = S_IRUGO;
@@ -1049,7 +1056,20 @@ static void remove_sect_attrs(struct mod
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
@@ -1143,18 +1163,7 @@ static void remove_notes_attrs(struct mo
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
@@ -1163,7 +1172,8 @@ static inline void add_notes_attrs(struc
 static inline void remove_notes_attrs(struct module *mod)
 {
 }
-#endif /* CONFIG_KALLSYMS */
+#endif
+
 
 #ifdef CONFIG_SYSFS
 int module_add_modinfo_attrs(struct module *mod)
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
 




-----------Delta patch against x86.git tree-------------
kgdb-module_cleanups.patch

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH][KGDB] debugger module interface cleanups

This patch removes all the duplicated module section information that
KGDB added.  This means that the debugger "kernel awareness" has to
look at a different structure, but the kernel remains clean.

The only event required for a module that is being unloaded is to
notify the debugger when the module has been removed from the module
list.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 include/linux/module.h |   25 +++----------
 kernel/module.c        |   92 +++++++++++--------------------------------------
 2 files changed, 28 insertions(+), 89 deletions(-)

--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -227,17 +227,8 @@ enum module_state
 	MODULE_STATE_LIVE,
 	MODULE_STATE_COMING,
 	MODULE_STATE_GOING,
-	MODULE_STATE_GONE,
 };
 
-#ifdef CONFIG_KGDB
-#define MAX_SECTNAME 31
-struct mod_section {
-	void *address;
-	char name[MAX_SECTNAME + 1];
-};
-#endif
-
 /* Similar stuff for section attributes. */
 struct module_sect_attr
 {
@@ -265,13 +256,6 @@ struct module
 	/* Unique handle for this module */
 	char name[MODULE_NAME_LEN];
 
-#ifdef CONFIG_KGDB
-	/* keep kgdb info at the begining so that gdb doesn't have a chance to
-	 * miss out any fields */
-	unsigned long num_sections;
-	struct mod_section *mod_sections;
-#endif
-
 	/* Sysfs stuff. */
 	struct module_kobject mkobj;
 	struct module_param_attrs *param_attrs;
@@ -358,13 +342,16 @@ struct module
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
 
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -66,7 +66,6 @@ extern int module_sysfs_initialized;
  * (add/delete uses stop_machine). */
 static DEFINE_MUTEX(module_mutex);
 static LIST_HEAD(modules);
-static DEFINE_MUTEX(notify_mutex);
 
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);
 
@@ -581,6 +580,9 @@ static void module_unload_free(struct mo
 			}
 		}
 	}
+	blocking_notifier_call_chain(&module_notify_list,
+				MODULE_STATE_GOING,
+				mod);
 }
 
 #ifdef CONFIG_MODULE_FORCE_UNLOAD
@@ -712,12 +714,6 @@ sys_delete_module(const char __user *nam
 	if (ret != 0)
 		goto out;
 
-	mutex_lock(&notify_mutex);
-	blocking_notifier_call_chain(&module_notify_list, MODULE_STATE_GOING,
-								 mod);
-	mutex_unlock(&notify_mutex);
-
-
 	/* Never wait if forced. */
 	if (!forced && module_refcount(mod) != 0)
 		wait_for_zero_refcount(mod);
@@ -730,11 +726,6 @@ sys_delete_module(const char __user *nam
 	}
 	free_module(mod);
 
-	mutex_lock(&notify_mutex);
-	blocking_notifier_call_chain(&module_notify_list, MODULE_STATE_GONE,
-			NULL);
-	mutex_unlock(&notify_mutex);
-
  out:
 	mutex_unlock(&module_mutex);
 	return ret;
@@ -849,9 +840,6 @@ static ssize_t show_initstate(struct mod
 	case MODULE_STATE_GOING:
 		state = "going";
 		break;
-	case MODULE_STATE_GONE:
-		state = "gone";
-		break;
 	}
 	return sprintf(buffer, "%s\n", state);
 }
@@ -982,6 +970,7 @@ static unsigned long resolve_symbol(Elf_
  * /sys/module/foo/sections stuff
  * J. Corbet <corbet@lwn.net>
  */
+#if defined(CONFIG_KALLSYMS) || defined(CONFIG_KGDB)
 #ifdef CONFIG_KALLSYMS
 static ssize_t module_sect_show(struct module_attribute *mattr,
 				struct module *mod, char *buf)
@@ -990,6 +979,7 @@ static ssize_t module_sect_show(struct m
 		container_of(mattr, struct module_sect_attr, mattr);
 	return sprintf(buf, "0x%lx\n", sattr->address);
 }
+#endif /* CONFIG_KALLSYMS */
 
 static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
 {
@@ -1036,7 +1026,9 @@ static void add_sect_attrs(struct module
 		if (sattr->name == NULL)
 			goto out;
 		sect_attrs->nsections++;
+#ifdef CONFIG_KALLSYMS
 		sattr->mattr.show = module_sect_show;
+#endif
 		sattr->mattr.store = NULL;
 		sattr->mattr.attr.name = sattr->name;
 		sattr->mattr.attr.mode = S_IRUGO;
@@ -1064,7 +1056,20 @@ static void remove_sect_attrs(struct mod
 		mod->sect_attrs = NULL;
 	}
 }
+#else /* ! (CONFIG_KALLSYMS || CONFIG_KGDB) */
+
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
 
+#ifdef CONFIG_KALLSYMS
 /*
  * /sys/module/foo/notes/.section.name gives contents of SHT_NOTE sections.
  */
@@ -1158,18 +1163,7 @@ static void remove_notes_attrs(struct mo
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
@@ -1178,7 +1172,8 @@ static inline void add_notes_attrs(struc
 static inline void remove_notes_attrs(struct module *mod)
 {
 }
-#endif /* CONFIG_KALLSYMS */
+#endif
+
 
 #ifdef CONFIG_SYSFS
 int module_add_modinfo_attrs(struct module *mod)
@@ -1321,11 +1316,6 @@ static void free_module(struct module *m
 	/* Arch-specific cleanup. */
 	module_arch_cleanup(mod);
 
-#ifdef CONFIG_KGDB
-	/* kgdb info */
-	vfree(mod->mod_sections);
-#endif
-
 	/* Module unload stuff */
 	module_unload_free(mod);
 
@@ -1585,30 +1575,6 @@ static void setup_modinfo(struct module 
 	}
 }
 
-#ifdef CONFIG_KGDB
-int add_modsects(struct module *mod, Elf_Ehdr *hdr, Elf_Shdr *sechdrs,
-		const char *secstrings)
-{
-	 int i;
-
-	 mod->num_sections = hdr->e_shnum - 1;
-	 mod->mod_sections = vmalloc((hdr->e_shnum - 1) *
-		sizeof(struct mod_section));
-
-	 if (mod->mod_sections == NULL)
-		 return -ENOMEM;
-
-	 for (i = 1; i < hdr->e_shnum; i++) {
-		 mod->mod_sections[i - 1].address = (void *)sechdrs[i].sh_addr;
-		 strncpy(mod->mod_sections[i - 1].name, secstrings +
-				 sechdrs[i].sh_name, MAX_SECTNAME);
-		 mod->mod_sections[i - 1].name[MAX_SECTNAME] = '\0';
-	}
-
-	return 0;
-}
-#endif
-
 #ifdef CONFIG_KALLSYMS
 static int is_exported(const char *name, const struct module *mod)
 {
@@ -2035,11 +2001,6 @@ static struct module *load_module(void _
 
 	add_kallsyms(mod, sechdrs, symindex, strindex, secstrings);
 
-#ifdef CONFIG_KGDB
-	err = add_modsects(mod, hdr, sechdrs, secstrings);
-	 if (err < 0)
-		 goto nomodsectinfo;
-#endif
 #ifdef CONFIG_MARKERS
 	if (!mod->taints)
 		marker_update_probe_range(mod->markers,
@@ -2106,10 +2067,6 @@ static struct module *load_module(void _
  arch_cleanup:
 	module_arch_cleanup(mod);
  cleanup:
-#ifdef CONFIG_KGDB
- nomodsectinfo:
-	vfree(mod->mod_sections);
-#endif
 	module_unload_free(mod);
 	module_free(mod, mod->module_init);
  free_core:
@@ -2181,11 +2138,6 @@ sys_init_module(void __user *umod,
 		/* Init routine failed: abort.  Try to protect us from
                    buggy refcounters. */
 		mod->state = MODULE_STATE_GOING;
-		mutex_lock(&notify_mutex);
-		blocking_notifier_call_chain(&module_notify_list,
-				MODULE_STATE_GOING,
-				mod);
-		mutex_unlock(&notify_mutex);
 		synchronize_sched();
 		module_put(mod);
 		mutex_lock(&module_mutex);
