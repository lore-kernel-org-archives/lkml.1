Return-Path: <linux-kernel-owner+w=401wt.eu-S1761246AbYGRXNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761246AbYGRXNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbYGRXNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:13:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:24397 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157AbYGRXNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:13:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,212,1215414000"; 
   d="scan'208";a="316588967"
Message-Id: <20080718231049.876919000@intel.com>
References: <20080718230812.826863000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jul 2008 16:08:14 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [RFC patch 2/2] x86: Add a debugfs interface to dump PAT memtype
Content-Disposition: inline; filename=pat_debugfs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a debugfs interface to list out all the PAT memtype reservations.
Appears at debugfs x86/pat_memtype_list and output format is
type @ <start addr>-<end addr>

We do not hold the lock while printing the entire list. So, the list may not be
a consistent copy in case where regions are getting added or deleted
at the same time.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/mm/pat.c |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2008-07-18 15:10:37.000000000 -0700
+++ linux-2.6/arch/x86/mm/pat.c	2008-07-18 15:48:31.000000000 -0700
@@ -12,6 +12,8 @@
 #include <linux/gfp.h>
 #include <linux/fs.h>
 #include <linux/bootmem.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 
 #include <asm/msr.h>
 #include <asm/tlbflush.h>
@@ -489,3 +491,89 @@ void unmap_devmem(unsigned long pfn, uns
 
 	free_memtype(addr, addr + size);
 }
+
+#if defined(CONFIG_DEBUG_FS)
+
+/* get Nth element of the linked list */
+static struct memtype *memtype_get_idx(loff_t pos)
+{
+	struct memtype *list_node, *print_entry;
+	int i = 1;
+
+	print_entry  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
+	if (!print_entry)
+		return NULL;
+
+	spin_lock(&memtype_lock);
+	list_for_each_entry(list_node, &memtype_list, nd) {
+		if (pos == i) {
+			*print_entry = *list_node;
+			spin_unlock(&memtype_lock);
+			return print_entry;
+		}
+		++i;
+	}
+	spin_unlock(&memtype_lock);
+	kfree(print_entry);
+	return NULL;
+}
+
+static void *memtype_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	if (*pos == 0) {
+		++*pos;
+		seq_printf(seq, "PAT memtype list:\n");
+	}
+
+	return memtype_get_idx(*pos);
+}
+
+static void *memtype_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	++*pos;
+	return memtype_get_idx(*pos);
+}
+
+static void memtype_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static int memtype_seq_show(struct seq_file *seq, void *v)
+{
+	struct memtype *print_entry = (struct memtype *)v;
+
+	seq_printf(seq, "%s @ 0x%Lx-0x%Lx\n", cattr_name(print_entry->type),
+			print_entry->start, print_entry->end);
+	kfree(print_entry);
+	return 0;
+}
+
+static struct seq_operations memtype_seq_ops = {
+	.start = memtype_seq_start,
+	.next  = memtype_seq_next,
+	.stop  = memtype_seq_stop,
+	.show  = memtype_seq_show,
+};
+
+static int memtype_seq_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &memtype_seq_ops);
+}
+
+static const struct file_operations memtype_fops = {
+	.open    = memtype_seq_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release,
+};
+
+static int __init pat_memtype_list_init(void)
+{
+	debugfs_create_file("pat_memtype_list", S_IRUSR, arch_debugfs_dir,
+				NULL, &memtype_fops);
+	return 0;
+}
+
+late_initcall(pat_memtype_list_init);
+
+#endif /* CONFIG_DEBUG_FS */

-- 

