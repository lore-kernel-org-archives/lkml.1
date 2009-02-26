Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbZBZFi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbZBZFi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbZBZFif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:38:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:62674 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbZBZFie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:38:34 -0500
Message-Id: <20090226053831.813803082@goodmis.org>
References: <20090226053240.607719846@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 26 Feb 2009 00:32:41 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH v2 1/5] uaccess: move probe_kernel_* functions to lib/uaccess.c
Content-Disposition: inline; filename=0001-uaccess-move-probe_kernel_-functions-to-lib-uacces.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch moves the file mm/maccess.c to lib/uaccess.c. This
is a more generic location to find lib utils. Since probe_kernel_*
are declared in linux/uaccess.h, having them in a file named uaccess.c
seems to be a better place.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/Makefile  |    3 ++-
 lib/uaccess.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/Makefile   |    2 +-
 mm/maccess.c  |   55 -------------------------------------------------------
 4 files changed, 58 insertions(+), 57 deletions(-)
 create mode 100644 lib/uaccess.c
 delete mode 100644 mm/maccess.c

diff --git a/lib/Makefile b/lib/Makefile
index 32b0e64..46ce28c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -11,7 +11,8 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o \
 	 idr.o int_sqrt.o extable.o prio_tree.o \
 	 sha1.o irq_regs.o reciprocal_div.o argv_split.o \
-	 proportions.o prio_heap.o ratelimit.o show_mem.o is_single_threaded.o
+	 proportions.o prio_heap.o ratelimit.o show_mem.o is_single_threaded.o \
+	 uaccess.o
 
 lib-$(CONFIG_MMU) += ioremap.o
 lib-$(CONFIG_SMP) += cpumask.o
diff --git a/lib/uaccess.c b/lib/uaccess.c
new file mode 100644
index 0000000..ac40796
--- /dev/null
+++ b/lib/uaccess.c
@@ -0,0 +1,55 @@
+/*
+ * Access kernel memory without faulting.
+ */
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+
+/**
+ * probe_kernel_read(): safely attempt to read from a location
+ * @dst: pointer to the buffer that shall take the data
+ * @src: address to read from
+ * @size: size of the data chunk
+ *
+ * Safely read from address @src to the buffer at @dst.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+long probe_kernel_read(void *dst, void *src, size_t size)
+{
+	long ret;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(KERNEL_DS);
+	pagefault_disable();
+	ret = __copy_from_user_inatomic(dst,
+			(__force const void __user *)src, size);
+	pagefault_enable();
+	set_fs(old_fs);
+
+	return ret ? -EFAULT : 0;
+}
+EXPORT_SYMBOL_GPL(probe_kernel_read);
+
+/**
+ * probe_kernel_write(): safely attempt to write to a location
+ * @dst: address to write to
+ * @src: pointer to the data that shall be written
+ * @size: size of the data chunk
+ *
+ * Safely write to address @dst from the buffer at @src.  If a kernel fault
+ * happens, handle that and return -EFAULT.
+ */
+long probe_kernel_write(void *dst, void *src, size_t size)
+{
+	long ret;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(KERNEL_DS);
+	pagefault_disable();
+	ret = __copy_to_user_inatomic((__force void __user *)dst, src, size);
+	pagefault_enable();
+	set_fs(old_fs);
+
+	return ret ? -EFAULT : 0;
+}
+EXPORT_SYMBOL_GPL(probe_kernel_write);
diff --git a/mm/Makefile b/mm/Makefile
index 72255be..90323d1 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -8,7 +8,7 @@ mmu-$(CONFIG_MMU)	:= fremap.o highmem.o madvise.o memory.o mincore.o \
 			   vmalloc.o
 
 obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
-			   maccess.o page_alloc.o page-writeback.o pdflush.o \
+			   page_alloc.o page-writeback.o pdflush.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
 			   page_isolation.o mm_init.o $(mmu-y)
diff --git a/mm/maccess.c b/mm/maccess.c
deleted file mode 100644
index ac40796..0000000
--- a/mm/maccess.c
+++ /dev/null
@@ -1,55 +0,0 @@
-/*
- * Access kernel memory without faulting.
- */
-#include <linux/uaccess.h>
-#include <linux/module.h>
-#include <linux/mm.h>
-
-/**
- * probe_kernel_read(): safely attempt to read from a location
- * @dst: pointer to the buffer that shall take the data
- * @src: address to read from
- * @size: size of the data chunk
- *
- * Safely read from address @src to the buffer at @dst.  If a kernel fault
- * happens, handle that and return -EFAULT.
- */
-long probe_kernel_read(void *dst, void *src, size_t size)
-{
-	long ret;
-	mm_segment_t old_fs = get_fs();
-
-	set_fs(KERNEL_DS);
-	pagefault_disable();
-	ret = __copy_from_user_inatomic(dst,
-			(__force const void __user *)src, size);
-	pagefault_enable();
-	set_fs(old_fs);
-
-	return ret ? -EFAULT : 0;
-}
-EXPORT_SYMBOL_GPL(probe_kernel_read);
-
-/**
- * probe_kernel_write(): safely attempt to write to a location
- * @dst: address to write to
- * @src: pointer to the data that shall be written
- * @size: size of the data chunk
- *
- * Safely write to address @dst from the buffer at @src.  If a kernel fault
- * happens, handle that and return -EFAULT.
- */
-long probe_kernel_write(void *dst, void *src, size_t size)
-{
-	long ret;
-	mm_segment_t old_fs = get_fs();
-
-	set_fs(KERNEL_DS);
-	pagefault_disable();
-	ret = __copy_to_user_inatomic((__force void __user *)dst, src, size);
-	pagefault_enable();
-	set_fs(old_fs);
-
-	return ret ? -EFAULT : 0;
-}
-EXPORT_SYMBOL_GPL(probe_kernel_write);
-- 
1.5.6.5

-- 
