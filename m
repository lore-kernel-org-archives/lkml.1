Return-Path: <linux-kernel-owner+w=401wt.eu-S935262AbXG0CBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935262AbXG0CBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 22:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765374AbXG0CBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 22:01:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:49830 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760353AbXG0CBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 22:01:05 -0400
Subject: [PATCH/RFC] Add MM_DEAD flag to struct mm_struct
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm <linux-mm@kvack.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Jul 2007 12:00:58 +1000
Message-Id: <1185501659.5495.174.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures like sparc can do useful optimizations when knowing
that an entire MM is being destroyed. At the moment, they rely on
fullmm in the mmu_gather structure. However, that doesn't always work
out very well with some of the changes we are doing. Among other things,
the TLB flushing on sparc64 is done using per-CPU tracking data, making
the batch not per-CPU will break that link.

So instead, we add a new flag to struct mm_struct that indicates that
the mm is going away, for those archs to use. It also allows to use it
in situations (such as PTE ops) where the batch isn't accessible (or
there is no batch)

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Index: linux-work/include/linux/sched.h
===================================================================
--- linux-work.orig/include/linux/sched.h	2007-07-27 11:09:16.000000000 +1000
+++ linux-work/include/linux/sched.h	2007-07-27 11:09:22.000000000 +1000
@@ -353,6 +353,7 @@ extern int get_dumpable(struct mm_struct
 #define MMF_DUMPABLE      0  /* core dump is permitted */
 #define MMF_DUMP_SECURELY 1  /* core file is readable only by root */
 #define MMF_DUMPABLE_BITS 2
+#define MMF_DEAD          3  /* mm is being destroyed */
 
 /* coredump filter bits */
 #define MMF_DUMP_ANON_PRIVATE	2
Index: linux-work/mm/mmap.c
===================================================================
--- linux-work.orig/mm/mmap.c	2007-07-27 11:09:52.000000000 +1000
+++ linux-work/mm/mmap.c	2007-07-27 11:10:05.000000000 +1000
@@ -1991,6 +1991,9 @@ void exit_mmap(struct mm_struct *mm)
 	unsigned long nr_accounted = 0;
 	unsigned long end;
 
+	/* Mark the MM as dead */
+	__set_bit(MMF_DEAD, &mm->flags);
+
 	/* mm's last user has gone, and its about to be pulled down */
 	arch_exit_mmap(mm);
 


