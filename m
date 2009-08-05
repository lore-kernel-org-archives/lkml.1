Return-Path: <linux-kernel-owner+w=401wt.eu-S934044AbZHEJhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044AbZHEJhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934035AbZHEJg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:36:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49105 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934018AbZHEJgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:36:46 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200908051136.682859934@firstfloor.org>
In-Reply-To: <200908051136.682859934@firstfloor.org>
To: akpm@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com,
       hidehiro.kawai.ez@hitachi.com
Subject: [PATCH] [19/19] HWPOISON: Add simple debugfs interface to inject hwpoison on arbitary PFNs
Message-Id: <20090805093646.EE6F0B15D8@basil.firstfloor.org>
Date: Wed,  5 Aug 2009 11:36:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Useful for some testing scenarios, although specific testing is often
done better through MADV_POISON

This can be done with the x86 level MCE injector too, but this interface
allows it to do independently from low level x86 changes.

Open issues: 

Should be disabled for cgroups.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 mm/Kconfig           |    6 +++++-
 mm/Makefile          |    1 +
 mm/hwpoison-inject.c |   40 ++++++++++++++++++++++++++++++++++++++++
 mm/madvise.c         |    2 +-
 4 files changed, 47 insertions(+), 2 deletions(-)

Index: linux/mm/hwpoison-inject.c
===================================================================
--- /dev/null
+++ linux/mm/hwpoison-inject.c
@@ -0,0 +1,40 @@
+/* Inject a hwpoison memory failure on a arbitary pfn */
+#include <linux/module.h>
+#include <linux/debugfs.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+
+static struct dentry *hwpoison_dir, *corrupt_pfn;
+
+static int hwpoison_inject(void *data, u64 val)
+{
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	printk(KERN_INFO "Injecting memory failure at pfn %Lx\n", val);
+	return __memory_failure(val, 18, 0);
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(hwpoison_fops, NULL, hwpoison_inject, "%lli\n");
+
+static void pfn_inject_exit(void)
+{
+	if (hwpoison_dir)
+		debugfs_remove_recursive(hwpoison_dir);
+}
+
+static int pfn_inject_init(void)
+{
+	hwpoison_dir = debugfs_create_dir("hwpoison", NULL);
+	if (hwpoison_dir == NULL)
+		return -ENOMEM;
+	corrupt_pfn = debugfs_create_file("corrupt-pfn", 0600, hwpoison_dir,
+					  NULL, &hwpoison_fops);
+	if (corrupt_pfn == NULL) {
+		pfn_inject_exit();
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+module_init(pfn_inject_init);
+module_exit(pfn_inject_exit);
Index: linux/mm/Kconfig
===================================================================
--- linux.orig/mm/Kconfig
+++ linux/mm/Kconfig
@@ -236,12 +236,16 @@ config DEFAULT_MMAP_MIN_ADDR
 config MEMORY_FAILURE
 	depends on MMU
 	depends on X86_MCE
-	bool "Enable memory failure recovery"
+	bool "Enable recovery from hardware memory errors"
 	help
 	  Enables code to recover from some memory failures on systems
 	  with MCA recovery. This allows a system to continue running
 	  even when some of its memory has uncorrected errors.
 
+config HWPOISON_INJECT
+	tristate "Poison pages injector"
+	depends on MEMORY_FAILURE && DEBUG_KERNEL
+
 config NOMMU_INITIAL_TRIM_EXCESS
 	int "Turn on mmap() excess space trimming before booting"
 	depends on !MMU
Index: linux/mm/Makefile
===================================================================
--- linux.orig/mm/Makefile
+++ linux/mm/Makefile
@@ -41,5 +41,6 @@ endif
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
+obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
 obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
Index: linux/mm/madvise.c
===================================================================
--- linux.orig/mm/madvise.c
+++ linux/mm/madvise.c
@@ -213,7 +213,7 @@ static long madvise_remove(struct vm_are
  */
 static int madvise_hwpoison(unsigned long start, unsigned long end)
 {
-	int ret = -EIO;
+	int ret = 0;
 	/*
 	 * RED-PEN
 	 * This allows to tie up arbitary amounts of memory.
