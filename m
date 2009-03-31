Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbZCaNDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbZCaNDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbZCaNDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:03:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:44254 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbZCaNDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:03:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="502274090"
Date: Tue, 31 Mar 2009 15:03:19 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 4/21] mm: refund memory for a locked buffer
Message-ID: <20090331150319.A12691@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to refund the memory of a locked buffer.

The function will be used by a worker thread to free a buffer
allocated by a different task and to refund the memory correctly.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/include/linux/mm.h
===================================================================
--- git-tip.orig/include/linux/mm.h	2009-03-28 13:04:30.000000000 +0100
+++ git-tip/include/linux/mm.h	2009-03-28 13:07:53.000000000 +0100
@@ -13,6 +13,7 @@
 #include <linux/prio_tree.h>
 #include <linux/debug_locks.h>
 #include <linux/mm_types.h>
+#include <linux/sched.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -1318,6 +1319,6 @@
 
 extern void *alloc_locked_buffer(size_t size);
 extern void free_locked_buffer(void *buffer, size_t size);
-extern void release_locked_buffer(void *buffer, size_t size);
+extern void refund_locked_buffer_memory(struct mm_struct *mm, size_t size);
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
Index: git-tip/mm/mlock.c
===================================================================
--- git-tip.orig/mm/mlock.c	2009-03-28 13:04:30.000000000 +0100
+++ git-tip/mm/mlock.c	2009-03-28 13:08:53.000000000 +0100
@@ -660,21 +660,20 @@
 	return buffer;
 }
 
-void release_locked_buffer(void *buffer, size_t size)
+void refund_locked_buffer_memory(struct mm_struct *mm, size_t size)
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
 {
-	release_locked_buffer(buffer, size);
-
+	refund_locked_buffer_memory(current->mm, size);
 	kfree(buffer);
 }
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

