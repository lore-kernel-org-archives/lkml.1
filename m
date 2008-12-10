Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbYLJSci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbYLJSci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:32:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbYLJS2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:28:15 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:33267 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756363AbYLJS2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:28:14 -0500
Subject: [PATCH 14/15] kmemleak: Simple testing module for kmemleak
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 10 Dec 2008 18:28:11 +0000
Message-ID: <20081210182811.30323.45787.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2008 18:28:12.0136 (UTC) FILETIME=[0EF78680:01C95AF5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a loadable module that deliberately leaks memory. It
is used for testing various memory leaking scenarios.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 lib/Kconfig.debug |   11 +++++
 mm/Makefile       |    1 
 mm/memleak-test.c |  110 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 122 insertions(+), 0 deletions(-)
 create mode 100644 mm/memleak-test.c

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 72cde77..205c1da 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -313,6 +313,17 @@ config DEBUG_MEMLEAK
 	  In order to access the memleak file, debugfs needs to be
 	  mounted (usually at /sys/kernel/debug).
 
+config DEBUG_MEMLEAK_TEST
+	tristate "Test the kernel memory leak detector"
+	default n
+	depends on DEBUG_MEMLEAK
+	help
+	  Say Y or M here to build a test for the kernel memory leak
+	  detector. This option enables a module that explicitly leaks
+	  memory.
+
+	  If unsure, say N.
+
 config DEBUG_KEEP_INIT
 	bool "Do not free the __init code/data"
 	default n
diff --git a/mm/Makefile b/mm/Makefile
index 3e43536..deb5935 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -35,3 +35,4 @@ obj-$(CONFIG_SMP) += allocpercpu.o
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
 obj-$(CONFIG_DEBUG_MEMLEAK) += memleak.o
+obj-$(CONFIG_DEBUG_MEMLEAK_TEST) += memleak-test.o
diff --git a/mm/memleak-test.c b/mm/memleak-test.c
new file mode 100644
index 0000000..0f3e651
--- /dev/null
+++ b/mm/memleak-test.c
@@ -0,0 +1,110 @@
+/*
+ * mm/memleak-test.c
+ *
+ * Copyright (C) 2008 ARM Limited
+ * Written by Catalin Marinas <catalin.marinas@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/list.h>
+#include <linux/percpu.h>
+
+#include <linux/memleak.h>
+
+struct test_node {
+	long header[25];
+	struct list_head list;
+	long footer[25];
+};
+
+static LIST_HEAD(test_list);
+static DEFINE_PER_CPU(void *, test_pointer);
+
+/*
+ * Some very simple testing. This function needs to be extended for
+ * proper testing.
+ */
+static int __init memleak_test_init(void)
+{
+	struct test_node *elem;
+	int i;
+
+	printk(KERN_INFO "Kmemleak testing\n");
+
+	/* make some orphan objects */
+	pr_info("kmemleak: kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
+	pr_info("kmemleak: kmalloc(32) = %p\n", kmalloc(32, GFP_KERNEL));
+	pr_info("kmemleak: kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
+	pr_info("kmemleak: kmalloc(1024) = %p\n", kmalloc(1024, GFP_KERNEL));
+	pr_info("kmemleak: kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
+	pr_info("kmemleak: kmalloc(2048) = %p\n", kmalloc(2048, GFP_KERNEL));
+	pr_info("kmemleak: kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
+	pr_info("kmemleak: kmalloc(4096) = %p\n", kmalloc(4096, GFP_KERNEL));
+#ifndef CONFIG_MODULES
+	pr_info("kmemleak: kmem_cache_alloc(files_cachep) = %p\n",
+		kmem_cache_alloc(files_cachep, GFP_KERNEL));
+	pr_info("kmemleak: kmem_cache_alloc(files_cachep) = %p\n",
+		kmem_cache_alloc(files_cachep, GFP_KERNEL));
+#endif
+	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
+	pr_info("kmemleak: vmalloc(64) = %p\n", vmalloc(64));
+
+	/*
+	 * Add elements to a list. They should only appear as orphan
+	 * after the module is removed.
+	 */
+	for (i = 0; i < 10; i++) {
+		elem = kmalloc(sizeof(*elem), GFP_KERNEL);
+		pr_info("kmemleak: kmalloc(sizeof(*elem)) = %p\n", elem);
+		if (!elem)
+			return -ENOMEM;
+		memset(elem, 0, sizeof(*elem));
+		INIT_LIST_HEAD(&elem->list);
+
+		list_add_tail(&elem->list, &test_list);
+	}
+
+	for_each_possible_cpu(i) {
+		per_cpu(test_pointer, i) = kmalloc(129, GFP_KERNEL);
+		pr_info("kmemleak: kmalloc(129) = %p\n",
+			per_cpu(test_pointer, i));
+	}
+
+	return 0;
+}
+module_init(memleak_test_init);
+
+static void __exit memleak_test_exit(void)
+{
+	struct test_node *elem, *tmp;
+
+	/*
+	 * Remove the list elements without actually freeing the
+	 * memory.
+	 */
+	list_for_each_entry_safe(elem, tmp, &test_list, list)
+		list_del(&elem->list);
+}
+module_exit(memleak_test_exit);
+
+MODULE_LICENSE("GPL");

