Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYJQMvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYJQMvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 08:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756092AbYJQMui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 08:50:38 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:44229 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277AbYJQMug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 08:50:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ksj0eRI0uRg3Uqes8RHzIlN3aCdEA3bl3vV6xiAIwt0SUDd2fynv3P3AoGdr9VDpG1
         q8ZjcpGF6Xleso2VePJQoar3wLHsv52DeYP1r7VL0JUhnKw4iu0at/xw5/sR86pb7DlR
         SEZotaDJfaZSMRjpCOLRq+WIkqd6DUMIIXIBs=
Date: Fri, 17 Oct 2008 16:53:37 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mpm@selenic.com
Subject: [PATCH 29/31] proc: move pagecount stuff to fs/proc/page.c
Message-ID: <20081017125337.GD22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 10ede3dc6c1a235d0d51e9f08c9d7c176120337e Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 6 Oct 2008 14:26:12 +0400
Subject: [PATCH 29/31] proc: move pagecount stuff to fs/proc/page.c

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/Makefile    |    1 +
 fs/proc/page.c      |  147 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/proc_misc.c |  135 ----------------------------------------------
 3 files changed, 148 insertions(+), 135 deletions(-)
 create mode 100644 fs/proc/page.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index b921f44..fef5244 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -24,3 +24,4 @@ proc-$(CONFIG_PROC_KCORE)	+= kcore.o
 proc-$(CONFIG_PROC_VMCORE)	+= vmcore.o
 proc-$(CONFIG_PROC_DEVICETREE)	+= proc_devtree.o
 proc-$(CONFIG_PRINTK)	+= kmsg.o
+proc-$(CONFIG_PROC_PAGE_MONITOR)	+= page.o
diff --git a/fs/proc/page.c b/fs/proc/page.c
new file mode 100644
index 0000000..767d95a
--- /dev/null
+++ b/fs/proc/page.c
@@ -0,0 +1,147 @@
+#include <linux/bootmem.h>
+#include <linux/compiler.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/mmzone.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <asm/uaccess.h>
+#include "internal.h"
+
+#define KPMSIZE sizeof(u64)
+#define KPMMASK (KPMSIZE - 1)
+/* /proc/kpagecount - an array exposing page counts
+ *
+ * Each entry is a u64 representing the corresponding
+ * physical page count.
+ */
+static ssize_t kpagecount_read(struct file *file, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	u64 __user *out = (u64 __user *)buf;
+	struct page *ppage;
+	unsigned long src = *ppos;
+	unsigned long pfn;
+	ssize_t ret = 0;
+	u64 pcount;
+
+	pfn = src / KPMSIZE;
+	count = min_t(size_t, count, (max_pfn * KPMSIZE) - src);
+	if (src & KPMMASK || count & KPMMASK)
+		return -EINVAL;
+
+	while (count > 0) {
+		ppage = NULL;
+		if (pfn_valid(pfn))
+			ppage = pfn_to_page(pfn);
+		pfn++;
+		if (!ppage)
+			pcount = 0;
+		else
+			pcount = page_mapcount(ppage);
+
+		if (put_user(pcount, out++)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		count -= KPMSIZE;
+	}
+
+	*ppos += (char __user *)out - buf;
+	if (!ret)
+		ret = (char __user *)out - buf;
+	return ret;
+}
+
+static const struct file_operations proc_kpagecount_operations = {
+	.llseek = mem_lseek,
+	.read = kpagecount_read,
+};
+
+/* /proc/kpageflags - an array exposing page flags
+ *
+ * Each entry is a u64 representing the corresponding
+ * physical page flags.
+ */
+
+/* These macros are used to decouple internal flags from exported ones */
+
+#define KPF_LOCKED     0
+#define KPF_ERROR      1
+#define KPF_REFERENCED 2
+#define KPF_UPTODATE   3
+#define KPF_DIRTY      4
+#define KPF_LRU        5
+#define KPF_ACTIVE     6
+#define KPF_SLAB       7
+#define KPF_WRITEBACK  8
+#define KPF_RECLAIM    9
+#define KPF_BUDDY     10
+
+#define kpf_copy_bit(flags, srcpos, dstpos) (((flags >> srcpos) & 1) << dstpos)
+
+static ssize_t kpageflags_read(struct file *file, char __user *buf,
+			     size_t count, loff_t *ppos)
+{
+	u64 __user *out = (u64 __user *)buf;
+	struct page *ppage;
+	unsigned long src = *ppos;
+	unsigned long pfn;
+	ssize_t ret = 0;
+	u64 kflags, uflags;
+
+	pfn = src / KPMSIZE;
+	count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);
+	if (src & KPMMASK || count & KPMMASK)
+		return -EINVAL;
+
+	while (count > 0) {
+		ppage = NULL;
+		if (pfn_valid(pfn))
+			ppage = pfn_to_page(pfn);
+		pfn++;
+		if (!ppage)
+			kflags = 0;
+		else
+			kflags = ppage->flags;
+
+		uflags = kpf_copy_bit(KPF_LOCKED, PG_locked, kflags) |
+			kpf_copy_bit(kflags, KPF_ERROR, PG_error) |
+			kpf_copy_bit(kflags, KPF_REFERENCED, PG_referenced) |
+			kpf_copy_bit(kflags, KPF_UPTODATE, PG_uptodate) |
+			kpf_copy_bit(kflags, KPF_DIRTY, PG_dirty) |
+			kpf_copy_bit(kflags, KPF_LRU, PG_lru) |
+			kpf_copy_bit(kflags, KPF_ACTIVE, PG_active) |
+			kpf_copy_bit(kflags, KPF_SLAB, PG_slab) |
+			kpf_copy_bit(kflags, KPF_WRITEBACK, PG_writeback) |
+			kpf_copy_bit(kflags, KPF_RECLAIM, PG_reclaim) |
+			kpf_copy_bit(kflags, KPF_BUDDY, PG_buddy);
+
+		if (put_user(uflags, out++)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		count -= KPMSIZE;
+	}
+
+	*ppos += (char __user *)out - buf;
+	if (!ret)
+		ret = (char __user *)out - buf;
+	return ret;
+}
+
+static const struct file_operations proc_kpageflags_operations = {
+	.llseek = mem_lseek,
+	.read = kpageflags_read,
+};
+
+static int __init proc_page_init(void)
+{
+	proc_create("kpagecount", S_IRUSR, NULL, &proc_kpagecount_operations);
+	proc_create("kpageflags", S_IRUSR, NULL, &proc_kpageflags_operations);
+	return 0;
+}
+module_init(proc_page_init);
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 69c8244..32a80b7 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -56,146 +56,11 @@
 #include <asm/div64.h>
 #include "internal.h"
 
-#ifdef CONFIG_PROC_PAGE_MONITOR
-#define KPMSIZE sizeof(u64)
-#define KPMMASK (KPMSIZE - 1)
-/* /proc/kpagecount - an array exposing page counts
- *
- * Each entry is a u64 representing the corresponding
- * physical page count.
- */
-static ssize_t kpagecount_read(struct file *file, char __user *buf,
-			     size_t count, loff_t *ppos)
-{
-	u64 __user *out = (u64 __user *)buf;
-	struct page *ppage;
-	unsigned long src = *ppos;
-	unsigned long pfn;
-	ssize_t ret = 0;
-	u64 pcount;
-
-	pfn = src / KPMSIZE;
-	count = min_t(size_t, count, (max_pfn * KPMSIZE) - src);
-	if (src & KPMMASK || count & KPMMASK)
-		return -EINVAL;
-
-	while (count > 0) {
-		ppage = NULL;
-		if (pfn_valid(pfn))
-			ppage = pfn_to_page(pfn);
-		pfn++;
-		if (!ppage)
-			pcount = 0;
-		else
-			pcount = page_mapcount(ppage);
-
-		if (put_user(pcount, out++)) {
-			ret = -EFAULT;
-			break;
-		}
-
-		count -= KPMSIZE;
-	}
-
-	*ppos += (char __user *)out - buf;
-	if (!ret)
-		ret = (char __user *)out - buf;
-	return ret;
-}
-
-static struct file_operations proc_kpagecount_operations = {
-	.llseek = mem_lseek,
-	.read = kpagecount_read,
-};
-
-/* /proc/kpageflags - an array exposing page flags
- *
- * Each entry is a u64 representing the corresponding
- * physical page flags.
- */
-
-/* These macros are used to decouple internal flags from exported ones */
-
-#define KPF_LOCKED     0
-#define KPF_ERROR      1
-#define KPF_REFERENCED 2
-#define KPF_UPTODATE   3
-#define KPF_DIRTY      4
-#define KPF_LRU        5
-#define KPF_ACTIVE     6
-#define KPF_SLAB       7
-#define KPF_WRITEBACK  8
-#define KPF_RECLAIM    9
-#define KPF_BUDDY     10
-
-#define kpf_copy_bit(flags, srcpos, dstpos) (((flags >> srcpos) & 1) << dstpos)
-
-static ssize_t kpageflags_read(struct file *file, char __user *buf,
-			     size_t count, loff_t *ppos)
-{
-	u64 __user *out = (u64 __user *)buf;
-	struct page *ppage;
-	unsigned long src = *ppos;
-	unsigned long pfn;
-	ssize_t ret = 0;
-	u64 kflags, uflags;
-
-	pfn = src / KPMSIZE;
-	count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);
-	if (src & KPMMASK || count & KPMMASK)
-		return -EINVAL;
-
-	while (count > 0) {
-		ppage = NULL;
-		if (pfn_valid(pfn))
-			ppage = pfn_to_page(pfn);
-		pfn++;
-		if (!ppage)
-			kflags = 0;
-		else
-			kflags = ppage->flags;
-
-		uflags = kpf_copy_bit(KPF_LOCKED, PG_locked, kflags) |
-			kpf_copy_bit(kflags, KPF_ERROR, PG_error) |
-			kpf_copy_bit(kflags, KPF_REFERENCED, PG_referenced) |
-			kpf_copy_bit(kflags, KPF_UPTODATE, PG_uptodate) |
-			kpf_copy_bit(kflags, KPF_DIRTY, PG_dirty) |
-			kpf_copy_bit(kflags, KPF_LRU, PG_lru) |
-			kpf_copy_bit(kflags, KPF_ACTIVE, PG_active) |
-			kpf_copy_bit(kflags, KPF_SLAB, PG_slab) |
-			kpf_copy_bit(kflags, KPF_WRITEBACK, PG_writeback) |
-			kpf_copy_bit(kflags, KPF_RECLAIM, PG_reclaim) |
-			kpf_copy_bit(kflags, KPF_BUDDY, PG_buddy);
-
-		if (put_user(uflags, out++)) {
-			ret = -EFAULT;
-			break;
-		}
-
-		count -= KPMSIZE;
-	}
-
-	*ppos += (char __user *)out - buf;
-	if (!ret)
-		ret = (char __user *)out - buf;
-	return ret;
-}
-
-static struct file_operations proc_kpageflags_operations = {
-	.llseek = mem_lseek,
-	.read = kpageflags_read,
-};
-#endif /* CONFIG_PROC_PAGE_MONITOR */
-
 void __init proc_misc_init(void)
 {
 	proc_symlink("mounts", NULL, "self/mounts");
 
 	/* And now for trickier ones */
-#ifdef CONFIG_PROC_PAGE_MONITOR
-	proc_create("kpagecount", S_IRUSR, NULL, &proc_kpagecount_operations);
-	proc_create("kpageflags", S_IRUSR, NULL, &proc_kpageflags_operations);
-#endif
 #ifdef CONFIG_PROC_VMCORE
 	proc_vmcore = proc_create("vmcore", S_IRUSR, NULL, &proc_vmcore_operations);
 #endif
-- 
1.5.6.5

