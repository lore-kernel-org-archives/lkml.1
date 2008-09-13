Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbYIMFTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbYIMFTj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 01:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbYIMFR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 01:17:58 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40806 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753886AbYIMFR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 01:17:57 -0400
From: Jeffrey Brian Arnold <jbarnold@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [RFC v2 PATCH 9/9] Ksplice: Add support for building Ksplice as a module
Date: Sat, 13 Sep 2008 01:14:45 -0400
Message-Id: <d6b318d87ce57f8fbedeec562f4e70874ddfc101.1221282535.git.jbarnold@mit.edu>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <9db918711d1108cc89f991e2494f58d60cbd2555.1221282535.git.jbarnold@mit.edu>
References: <1221282885-1150-1-git-send-email-jbarnold@mit.edu>
 <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221282535.git.jbarnold@mit.edu>
 <8cfda1c8f6c46e2f0fa9e9279aa2b2a213fba7a4.1221282535.git.jbarnold@mit.edu>
 <bdf8d7b52e2cb9ff3bbed52cedd28294086c9f56.1221282535.git.jbarnold@mit.edu>
 <401afda17296e380049b129c92a9ae27e8e47fc3.1221282535.git.jbarnold@mit.edu>
 <a827aed330aec871b73c468cf61c27048b26574d.1221282535.git.jbarnold@mit.edu>
 <6ba306125ffc8fbcf9ceb2960645827523247689.1221282535.git.jbarnold@mit.edu>
 <95a158bee29bdcfa7d2bb537fdfe1e6af21599c7.1221282535.git.jbarnold@mit.edu>
 <9db918711d1108cc89f991e2494f58d60cbd2555.1221282535.git.jbarnold@mit.edu>
In-Reply-To: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221282535.git.jbarnold@mit.edu>
References: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221282535.git.jbarnold@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Abbott <tabbott@mit.edu>

Export the symbols needed to build Ksplice as a module.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 arch/Kconfig          |    2 +-
 arch/x86/mm/init_32.c |    5 +++--
 arch/x86/mm/init_64.c |    3 ++-
 kernel/kallsyms.c     |    1 +
 kernel/module.c       |    9 +++++++++
 kernel/sched.c        |    1 +
 6 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 9d5a843..cfbbcf3 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -28,7 +28,7 @@ config KPROBES
 	  If in doubt, say "N".
 
 config KSPLICE
-	bool "Ksplice rebootless kernel updates"
+	tristate "Ksplice rebootless kernel updates"
 	depends on KALLSYMS_ALL && MODULE_UNLOAD && SYSFS && \
 		   FUNCTION_DATA_SECTIONS
 	depends on HAVE_KSPLICE
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 5998d5c..549b021 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1036,7 +1036,8 @@ void mark_rodata_ro(void)
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
-#if !defined(CONFIG_DYNAMIC_FTRACE) && !defined(CONFIG_KSPLICE)
+#if !defined(CONFIG_DYNAMIC_FTRACE) && \
+    !defined(CONFIG_KSPLICE) && !defined(CONFIG_KSPLICE_MODULE)
 	/* Dynamic tracing and Ksplice modify the kernel text section */
 	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 	printk(KERN_INFO "Write protecting the kernel text: %luk\n",
@@ -1050,7 +1051,7 @@ void mark_rodata_ro(void)
 	printk(KERN_INFO "Testing CPA: write protecting again\n");
 	set_pages_ro(virt_to_page(start), size>>PAGE_SHIFT);
 #endif
-#endif /* !CONFIG_DYNAMIC_FTRACE && !CONFIG_KSPLICE */
+#endif /* !CONFIG_DYNAMIC_FTRACE && !CONFIG_KSPLICE && !CONFIG_KSPLICE_MODULE */
 
 	start += size;
 	size = (unsigned long)__end_rodata - start;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 31db657..dec6325 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -857,7 +857,8 @@ void mark_rodata_ro(void)
 	unsigned long rodata_start =
 		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
 
-#if defined(CONFIG_DYNAMIC_FTRACE) || defined(CONFIG_KSPLICE)
+#if defined(CONFIG_DYNAMIC_FTRACE) || \
+    defined(CONFIG_KSPLICE) || defined(CONFIG_KSPLICE_MODULE)
 	/* Dynamic tracing and Ksplice modify the kernel text section */
 	start = rodata_start;
 #endif
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 47d3e94..ef47021 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -178,6 +178,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 	}
 	return module_kallsyms_on_each_symbol(fn, data);
 }
+EXPORT_SYMBOL_GPL(kallsyms_on_each_symbol);
 
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
diff --git a/kernel/module.c b/kernel/module.c
index 2acb646..d2fa540 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -63,6 +63,7 @@
 /* List of modules, protected by module_mutex or preempt_disable
  * (add/delete uses stop_machine). */
 DEFINE_MUTEX(module_mutex);
+EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
 
 /* Waiting for a module to finish initializing? */
@@ -324,6 +325,7 @@ const struct kernel_symbol *find_symbol(const char *name,
 	DEBUGP("Failed to find symbol %s\n", name);
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(find_symbol);
 
 /* Search for module by name: must hold module_mutex. */
 struct module *find_module(const char *name)
@@ -336,6 +338,7 @@ struct module *find_module(const char *name)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(find_module);
 
 #ifdef CONFIG_SMP
 /* Number of blocks used and allocated. */
@@ -612,6 +615,7 @@ int use_module(struct module *a, struct module *b)
 	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
 	return 1;
 }
+EXPORT_SYMBOL_GPL(use_module);
 
 /* Clear the unload stuff of the module. */
 static void module_unload_free(struct module *mod)
@@ -878,6 +882,7 @@ int use_module(struct module *a, struct module *b)
 {
 	return strong_try_module_get(b) == 0;
 }
+EXPORT_SYMBOL_GPL(use_module);
 
 static inline void module_unload_init(struct module *mod)
 {
@@ -2689,6 +2694,7 @@ struct module *__module_text_address(unsigned long addr)
 			return mod;
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(__module_text_address);
 
 struct module *module_text_address(unsigned long addr)
 {
@@ -2700,6 +2706,7 @@ struct module *module_text_address(unsigned long addr)
 
 	return mod;
 }
+EXPORT_SYMBOL_GPL(module_text_address);
 
 struct module *__module_data_address(unsigned long addr)
 {
@@ -2717,6 +2724,7 @@ struct module *__module_data_address(unsigned long addr)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(__module_data_address);
 
 struct module *module_data_address(unsigned long addr)
 {
@@ -2728,6 +2736,7 @@ struct module *module_data_address(unsigned long addr)
 
 	return mod;
 }
+EXPORT_SYMBOL_GPL(module_data_address);
 
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
diff --git a/kernel/sched.c b/kernel/sched.c
index cc1f81b..bd385b6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1736,6 +1736,7 @@ inline int task_curr(const struct task_struct *p)
 {
 	return cpu_curr(task_cpu(p)) == p;
 }
+EXPORT_SYMBOL_GPL(task_curr);
 
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
-- 
1.5.4.3

