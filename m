Return-Path: <linux-kernel-owner+w=401wt.eu-S1764974AbXJZQk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764974AbXJZQk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763927AbXJZQgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:36:44 -0400
Received: from waste.org ([66.93.16.53]:56591 "EHLO cinder.waste.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763369AbXJZQgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:36:38 -0400
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
X-PatchBomber: http://selenic.com/scripts/mailpatches
Cc: Dave Hansen <haveblue@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Rientjes <rientjes@google.com>,
       Fengguang Wu <wfg@mail.ustc.edu.cn>
In-Reply-To: <1.430487409@selenic.com>
Message-Id: <12.430487409@selenic.com>
Subject: [PATCH 11/12] maps4: add /proc/kpageflags interface
Date: Fri, 26 Oct 2007 11:36:37 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Mackall <mpm@selenic.com>

This makes a subset of physical page flags available to userspace. Together
with /proc/pid/kpagemap, this allows tracking of a wide variety of VM behaviors.

Exported flags are decoupled from the kernel's internal flags. This
allows us to reorder flag bits, and synthesize any bits that get
redefined in terms of other bits.

Signed-off-by: Matt Mackall <mpm@selenic.com>
---

Index: l/fs/proc/proc_misc.c
===================================================================
--- l.orig/fs/proc/proc_misc.c	2007-10-22 17:53:48.000000000 -0500
+++ l/fs/proc/proc_misc.c	2007-10-22 18:55:25.000000000 -0500
@@ -708,6 +708,84 @@ static struct file_operations proc_kpage
 	.read = kpagecount_read,
 };
 
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
+	if (!access_ok(VERIFY_WRITE, buf, count))
+		return -EFAULT;
+
+	pfn = src / KPMSIZE;
+	count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);
+	if (src & KPMMASK || count & KPMMASK)
+		return -EIO;
+
+	while (count > 0) {
+		ppage = pfn_to_page(pfn++);
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
+static struct file_operations proc_kpageflags_operations = {
+	.llseek = mem_lseek,
+	.read = kpageflags_read,
+};
+
 struct proc_dir_entry *proc_root_kcore;
 
 void create_seq_entry(char *name, mode_t mode, const struct file_operations *f)
@@ -788,6 +866,7 @@ void __init proc_misc_init(void)
 	}
 #endif
 	create_seq_entry("kpagecount", S_IRUSR, &proc_kpagecount_operations);
+	create_seq_entry("kpageflags", S_IRUSR, &proc_kpageflags_operations);
 #ifdef CONFIG_PROC_VMCORE
 	proc_vmcore = create_proc_entry("vmcore", S_IRUSR, NULL);
 	if (proc_vmcore)
