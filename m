Return-Path: <linux-kernel-owner+w=401wt.eu-S1751501AbZHaKNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbZHaKNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbZHaKNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:13:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40568 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZHaKNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:13:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 Aug 2009 19:11:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       benh@kernel.crashing.org, ralf@linux-mips.org, xiyou.wangcong@gmail.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       jirislaby@gmail.com
Subject: [PATCH 8/8][mmotm] kcore regiter module area in generic way
Message-Id: <20090831191110.3fb4aa68.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090831190024.fadc3b50.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090831190024.fadc3b50.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some archs define MODULED_VADDR/MODULES_END which is not in
VMALLOC area. This is handled only in x86-64. This patch
make it more generic. 
And we can use vread/vwrite to access the area. Fix it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 arch/x86/mm/init_64.c |    4 +---
 fs/proc/kcore.c       |   19 ++++++++++++++++++-
 include/linux/mm.h    |    8 ++++++++
 mm/vmalloc.c          |    2 +-
 4 files changed, 28 insertions(+), 5 deletions(-)

Index: mmotm-2.6.31-Aug27/fs/proc/kcore.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/fs/proc/kcore.c
+++ mmotm-2.6.31-Aug27/fs/proc/kcore.c
@@ -490,7 +490,7 @@ read_kcore(struct file *file, char __use
 		if (m == NULL) {
 			if (clear_user(buffer, tsz))
 				return -EFAULT;
-		} else if (is_vmalloc_addr((void *)start)) {
+		} else if (is_vmalloc_or_module_addr((void *)start)) {
 			char * elf_buf;
 
 			elf_buf = kzalloc(tsz, GFP_KERNEL);
@@ -586,6 +586,22 @@ static void __init proc_kcore_text_init(
 }
 #endif
 
+#if defined(CONFIG_MODULES) && defined(MODULES_VADDR)
+/*
+ * MODULES_VADDR has no intersection with VMALLOC_ADDR.
+ */
+struct kcore_list kcore_modules;
+static void __init add_modules_range(void)
+{
+	kclist_add(&kcore_modules, (void *)MODULES_VADDR,
+			MODULES_END - MODULES_VADDR, KCORE_VMALLOC);
+}
+#else
+static void __init add_modules_range(void)
+{
+}
+#endif
+
 static int __init proc_kcore_init(void)
 {
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL,
@@ -595,6 +611,7 @@ static int __init proc_kcore_init(void)
 	/* Store vmalloc area */
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
 		VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
+	add_modules_range();
 	/* Store direct-map area from physical memory map */
 	kcore_update_ram();
 	hotplug_memory_notifier(kcore_callback, 0);
Index: mmotm-2.6.31-Aug27/include/linux/mm.h
===================================================================
--- mmotm-2.6.31-Aug27.orig/include/linux/mm.h
+++ mmotm-2.6.31-Aug27/include/linux/mm.h
@@ -285,6 +285,14 @@ static inline int is_vmalloc_addr(const 
 	return 0;
 #endif
 }
+#ifdef CONFIG_MMU
+extern int is_vmalloc_or_module_addr(const void *x);
+#else
+static int is_vmalloc_or_module_addr(const void *x)
+{
+	return 0;
+}
+#endif
 
 static inline struct page *compound_head(struct page *page)
 {
Index: mmotm-2.6.31-Aug27/mm/vmalloc.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/mm/vmalloc.c
+++ mmotm-2.6.31-Aug27/mm/vmalloc.c
@@ -184,7 +184,7 @@ static int vmap_page_range(unsigned long
 	return ret;
 }
 
-static inline int is_vmalloc_or_module_addr(const void *x)
+int is_vmalloc_or_module_addr(const void *x)
 {
 	/*
 	 * ARM, x86-64 and sparc64 put modules in a special place,
Index: mmotm-2.6.31-Aug27/arch/x86/mm/init_64.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/x86/mm/init_64.c
+++ mmotm-2.6.31-Aug27/arch/x86/mm/init_64.c
@@ -647,7 +647,7 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-static struct kcore_list kcore_modules, kcore_vsyscall;
+static struct kcore_list kcore_vsyscall;
 
 void __init mem_init(void)
 {
@@ -676,8 +676,6 @@ void __init mem_init(void)
 	initsize =  (unsigned long) &__init_end - (unsigned long) &__init_begin;
 
 	/* Register memory areas for /proc/kcore */
-	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN,
-			KCORE_OTHER);
 	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START,
 			 VSYSCALL_END - VSYSCALL_START, KCORE_OTHER);
 

