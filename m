Return-Path: <linux-kernel-owner+w=401wt.eu-S1751753AbZHaKHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbZHaKHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbZHaKHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:07:21 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40316 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZHaKHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:07:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 31 Aug 2009 19:05:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       benh@kernel.crashing.org, ralf@linux-mips.org, xiyou.wangcong@gmail.com,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       jirislaby@gmail.com
Subject: [PATCH 4/8][mmotm] kcore register text area in generic way
Message-Id: <20090831190528.8d81bdfb.kamezawa.hiroyu@jp.fujitsu.com>
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

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Some 64bit arch has special segment for mapping kernel text.  It should be
entried to /proc/kcore in addtion to direct-linear-map, vmalloc area. 
This patch unifies KCORE_TEXT entry scattered under x86 and ia64.

I'm not familiar with other archs (mips has its own even after this patch)
but range of [_stext ..._end) is a valid area of text and it's not in
direct-map area, defining CONFIG_ARCH_PROC_KCORE_TEXT is only a necessary
thing to do.

Note: I left mips as it is now.

Changelog:
 - fixed bisection breakage in ia64

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig     |    4 ++++
 arch/ia64/mm/init.c   |    3 +--
 arch/x86/Kconfig      |    4 ++++
 arch/x86/mm/init_64.c |    4 +---
 fs/proc/kcore.c       |   19 ++++++++++++++++++-
 5 files changed, 28 insertions(+), 6 deletions(-)

Index: mmotm-2.6.31-Aug27/arch/ia64/Kconfig
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/ia64/Kconfig
+++ mmotm-2.6.31-Aug27/arch/ia64/Kconfig
@@ -496,6 +496,10 @@ config HAVE_ARCH_NODEDATA_EXTENSION
 	def_bool y
 	depends on NUMA
 
+config ARCH_PROC_KCORE_TEXT
+	def_bool y
+	depends on PROC_KCORE
+
 config IA32_SUPPORT
 	bool "Support for Linux/x86 binaries"
 	help
Index: mmotm-2.6.31-Aug27/arch/x86/Kconfig
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/x86/Kconfig
+++ mmotm-2.6.31-Aug27/arch/x86/Kconfig
@@ -1252,6 +1252,10 @@ config ARCH_MEMORY_PROBE
 	def_bool X86_64
 	depends on MEMORY_HOTPLUG
 
+config ARCH_PROC_KCORE_TEXT
+	def_bool y
+	depends on X86_64 && PROC_KCORE
+
 config ILLEGAL_POINTER_VALUE
        hex
        default 0 if X86_32
Index: mmotm-2.6.31-Aug27/arch/x86/mm/init_64.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/x86/mm/init_64.c
+++ mmotm-2.6.31-Aug27/arch/x86/mm/init_64.c
@@ -647,8 +647,7 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-static struct kcore_list kcore_mem, kcore_kernel,
-			 kcore_modules, kcore_vsyscall;
+static struct kcore_list kcore_mem, kcore_modules, kcore_vsyscall;
 
 void __init mem_init(void)
 {
@@ -678,7 +677,6 @@ void __init mem_init(void)
 
 	/* Register memory areas for /proc/kcore */
 	kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT, KCORE_RAM);
-	kclist_add(&kcore_kernel, &_stext, _end - _stext, KCORE_TEXT);
 	kclist_add(&kcore_modules, (void *)MODULES_VADDR, MODULES_LEN,
 			KCORE_OTHER);
 	kclist_add(&kcore_vsyscall, (void *)VSYSCALL_START,
Index: mmotm-2.6.31-Aug27/fs/proc/kcore.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/fs/proc/kcore.c
+++ mmotm-2.6.31-Aug27/fs/proc/kcore.c
@@ -21,6 +21,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/list.h>
+#include <asm/sections.h>
 
 #define CORE_STR "CORE"
 
@@ -374,10 +375,26 @@ read_kcore(struct file *file, char __use
 
 static struct kcore_list kcore_vmalloc;
 
+#ifdef CONFIG_ARCH_PROC_KCORE_TEXT
+static struct kcore_list kcore_text;
+/*
+ * If defined, special segment is used for mapping kernel text instead of
+ * direct-map area. We need to create special TEXT section.
+ */
+static void __init proc_kcore_text_init(void)
+{
+	kclist_add(&kcore_text, _stext, _end - _stext, KCORE_TEXT);
+}
+#else
+static void __init proc_kcore_text_init(void)
+{
+}
+#endif
+
 static int __init proc_kcore_init(void)
 {
 	proc_root_kcore = proc_create("kcore", S_IRUSR, NULL, &proc_kcore_operations);
-
+	proc_kcore_text_init();
 	kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
 		VMALLOC_END - VMALLOC_START, KCORE_VMALLOC);
 	return 0;
Index: mmotm-2.6.31-Aug27/arch/ia64/mm/init.c
===================================================================
--- mmotm-2.6.31-Aug27.orig/arch/ia64/mm/init.c
+++ mmotm-2.6.31-Aug27/arch/ia64/mm/init.c
@@ -617,7 +617,7 @@ mem_init (void)
 	long reserved_pages, codesize, datasize, initsize;
 	pg_data_t *pgdat;
 	int i;
-	static struct kcore_list kcore_mem, kcore_kernel;
+	static struct kcore_list kcore_mem;
 
 	BUG_ON(PTRS_PER_PGD * sizeof(pgd_t) != PAGE_SIZE);
 	BUG_ON(PTRS_PER_PMD * sizeof(pmd_t) != PAGE_SIZE);
@@ -640,7 +640,6 @@ mem_init (void)
 	high_memory = __va(max_low_pfn * PAGE_SIZE);
 
 	kclist_add(&kcore_mem, __va(0), max_low_pfn * PAGE_SIZE, KCORE_RAM);
-	kclist_add(&kcore_kernel, _stext, _end - _stext, KCORE_TEXT);
 
 	for_each_online_pgdat(pgdat)
 		if (pgdat->bdata->node_bootmem_map)

