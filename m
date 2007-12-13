Return-Path: <linux-kernel-owner+w=401wt.eu-S934903AbXLNAEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934903AbXLNAEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933624AbXLNAEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:04:16 -0500
Received: from mga03.intel.com ([143.182.124.21]:58012 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762260AbXLNAEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:04:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,163,1196668800"; 
   d="scan'208";a="340710596"
Message-Id: <20071213235711.900223000@intel.com>
References: <20071213235543.568682000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 13 Dec 2007 15:55:47 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [RFC PATCH 04/12] PAT 64b: reserve_mattr and free_mattr for PAT
Content-Disposition: inline; filename=pat-conflict.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Straight forward port of pat-conflict.patch to x86 tree.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: linux-2.6.24-rc4/arch/x86/mm/ioremap_64.c
===================================================================
--- linux-2.6.24-rc4.orig/arch/x86/mm/ioremap_64.c	2007-12-11 14:24:56.000000000 -0800
+++ linux-2.6.24-rc4/arch/x86/mm/ioremap_64.c	2007-12-12 15:03:26.000000000 -0800
@@ -19,6 +19,7 @@
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 #include <asm/proto.h>
+#include <asm/pat.h>
 
 unsigned long __phys_addr(unsigned long x)
 {
@@ -125,12 +126,23 @@
 		remove_vm_area((void *)(PAGE_MASK & (unsigned long) addr));
 		return NULL;
 	}
+
+	/* For plain ioremap() get the existing attributes. Otherwise
+	   check against the existing ones */
+	if (reserve_mattr(phys_addr, phys_addr + size, flags,
+			  flags ? NULL : &flags) < 0)
+		goto out;
+
 	if (flags && ioremap_change_attr(phys_addr, size, flags) < 0) {
-		area->flags &= 0xffffff;
-		vunmap(addr);
-		return NULL;
+		free_mattr(phys_addr, phys_addr + size, flags);
+		goto out;
 	}
 	return (__force void __iomem *) (offset + (char *)addr);
+
+out:
+	area->flags &= 0xffffff;
+	vunmap(addr);
+	return NULL;
 }
 EXPORT_SYMBOL(__ioremap);
 
@@ -198,8 +210,10 @@
 	}
 
 	/* Reset the direct mapping. Can block */
-	if (p->flags >> 20)
+	if (p->flags >> 20) {
+		free_mattr(p->phys_addr, p->phys_addr + p->size, p->flags>>20);
 		ioremap_change_attr(p->phys_addr, p->size, 0);
+	}
 
 	/* Finally remove it */
 	o = remove_vm_area((void *)addr);
Index: linux-2.6.24-rc4/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.24-rc4.orig/arch/x86/mm/pat.c	2007-12-11 15:08:12.000000000 -0800
+++ linux-2.6.24-rc4/arch/x86/mm/pat.c	2007-12-12 15:06:52.000000000 -0800
@@ -6,6 +6,8 @@
 #include <asm/msr.h>
 #include <asm/tlbflush.h>
 #include <asm/processor.h>
+#include <asm/pgtable.h>
+#include <asm/pat.h>
 
 static u64 boot_pat_state;
 
@@ -55,3 +57,96 @@
 	}
 }
 
+/* The global memattr list keeps track of caching attributes for specific
+   physical memory areas. Conflicting caching attributes in different
+   mappings can cause CPU cache corruption. To avoid this we keep track.
+
+   The list is sorted and can contain multiple entries for each address
+   (this allows reference counting for overlapping areas). All the aliases
+   have the same cache attributes of course.  Zero attributes are represente
+   as holes.
+
+   Currently the data structure is a list because the number of mappings
+   are right now expected to be relatively small. If this should be a problem
+   it could be changed to a rbtree or similar.
+
+   mattr_lock protects the whole list. */
+
+struct memattr {
+	struct list_head nd;
+	u64 start;
+	u64 end;
+	unsigned long attr;
+};
+
+static LIST_HEAD(mattr_list);
+static DEFINE_SPINLOCK(mattr_lock); 	/* protects memattr list */
+
+int reserve_mattr(u64 start, u64 end, unsigned long attr, unsigned long *fattr)
+{
+	struct memattr *ma = NULL, *ml;
+	int err = 0;
+	if (attr) {
+		ma  = kmalloc(sizeof(struct memattr), GFP_KERNEL);
+		if (!ma)
+			return -ENOMEM;
+		ma->start = start;
+		ma->end = end;
+		ma->attr = attr;
+	}
+	if (fattr)
+		*fattr = attr;
+	spin_lock(&mattr_lock);
+	list_for_each_entry(ml, &mattr_list, nd) {
+		if (ml->start <= start && ml->end >= end) {
+			if (fattr) {
+				attr = ml->attr;
+				*fattr = attr;
+			}
+			if (attr != ml->attr) {
+				printk(
+	KERN_ERR "%s:%d conflicting cache attribute %Lx-%Lx %lx<->%lx\n",
+					current->comm, current->pid,
+					start, end, attr, ml->attr);
+				err = -EBUSY;
+				break;
+			}
+		} else if (ml->start >= end) {
+			if (ma) {
+				list_add(&ma->nd, ml->nd.prev);
+				ma = NULL;
+			}
+			break;
+		}
+	}
+	if (ma)
+		list_add_tail(&ma->nd, &mattr_list);
+	spin_unlock(&mattr_lock);
+	return 0;
+}
+
+int free_mattr(u64 start, u64 end, unsigned long attr)
+{
+	struct memattr *ml;
+	int err = attr ? -EBUSY : 0;
+	spin_lock(&mattr_lock);
+	list_for_each_entry(ml, &mattr_list, nd) {
+		if (ml->start == start && ml->end == end) {
+			if (ml->attr != attr)
+				printk(KERN_ERR
+	"%s:%d conflicting cache attributes on free %Lx-%Lx %lx<->%lx\n",
+			current->comm, current->pid, start, end, attr,ml->attr);
+			list_del(&ml->nd);
+			kfree(ml);
+			err = 0;
+			break;
+		}
+	}
+	spin_unlock(&mattr_lock);
+	if (err)
+		printk(KERN_ERR "%s:%d freeing invalid mattr %Lx-%Lx %lx\n",
+			current->comm, current->pid,
+			start, end, attr);
+	return err;
+}
+
Index: linux-2.6.24-rc4/include/asm-x86/pat.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.24-rc4/include/asm-x86/pat.h	2007-12-11 15:39:28.000000000 -0800
@@ -0,0 +1,12 @@
+#ifndef _ASM_PAT_H
+#define _ASM_PAT_H 1
+
+#include <linux/types.h>
+
+/* Handle the page attribute table (PAT) of the CPU */
+
+int reserve_mattr(u64 start, u64 end, unsigned long attr, unsigned long *fattr);
+int free_mattr(u64 start, u64 end, unsigned long attr);
+
+#endif
+

-- 
