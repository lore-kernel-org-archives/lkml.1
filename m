Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbZC0JfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbZC0JfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757162AbZC0Jdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:33:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:18096 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757514AbZC0Jdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:33:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,431,1233561600"; 
   d="scan'208";a="501272191"
Date: Fri, 27 Mar 2009 09:48:36 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 2/14] x86, mm: add release_locked_buffer_on_behalf
Message-ID: <20090327094836.A11033@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the release of a locked buffer on behalf of another task.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/include/linux/mm.h
===================================================================
--- git-tip.orig/include/linux/mm.h	2009-03-23 16:23:19.000000000 +0100
+++ git-tip/include/linux/mm.h	2009-03-23 16:33:03.000000000 +0100
@@ -13,6 +13,7 @@
 #include <linux/prio_tree.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
+#include <linux/sched.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -1318,6 +1319,11 @@ void vmemmap_populate_print_last(void);
 
 extern void *alloc_locked_buffer(size_t size);
 extern void free_locked_buffer(void *buffer, size_t size);
-extern void release_locked_buffer(void *buffer, size_t size);
+extern void release_locked_buffer_on_behalf(struct mm_struct *mm,
+					    void *buffer, size_t size);
+static inline void release_locked_buffer(void *buffer, size_t size)
+{
+	release_locked_buffer_on_behalf(current->mm, buffer, size);
+}
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
Index: git-tip/mm/mlock.c
===================================================================
--- git-tip.orig/mm/mlock.c	2009-03-23 16:23:19.000000000 +0100
+++ git-tip/mm/mlock.c	2009-03-23 16:24:24.000000000 +0100
@@ -660,16 +660,17 @@ void *alloc_locked_buffer(size_t size)
 	return buffer;
 }
 
-void release_locked_buffer(void *buffer, size_t size)
+void release_locked_buffer_on_behalf(struct mm_struct *mm,
+				     void *buffer, size_t size)
 {
 	unsigned long pgsz = PAGE_ALIGN(size) >> PAGE_SHIFT;
 
-	down_write(&current->mm->mmap_sem);
+	down_write(&mm->mmap_sem);
 
-	current->mm->total_vm  -= pgsz;
-	current->mm->locked_vm -= pgsz;
+	mm->total_vm  -= pgsz;
+	mm->locked_vm -= pgsz;
 
-	up_write(&current->mm->mmap_sem);
+	up_write(&mm->mmap_sem);
 }
 
 void free_locked_buffer(void *buffer, size_t size)
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

