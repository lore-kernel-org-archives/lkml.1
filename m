Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYHNPuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYHNPuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 11:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYHNPuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 11:50:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58183 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbYHNPuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 11:50:06 -0400
X-Greylist: delayed 1719 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Aug 2008 11:49:56 EDT
Date: Thu, 14 Aug 2008 11:19:33 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200808141519.m7EFJX9Z009294@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] MAP_GROWSUP & MAP_GROWSDOWN removal
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan's mail the other day in which he foolishly tried to advocate the
use of MAP_GROWSDOWN reminded me that I wanted to see these flags removed
for some time.  The mail just made it clear that it's quite important if
even kernel people don't realize how dangerous the flags are.

I looked around and found, beside LinuxThreads, just one user of the flag.
This code is broken, will likely not work, and will just compile fine when
I remove the flags from the glibc headers.

What is proposed here is to remove the flags real soon (2.6.29, as indicated
below).  If this patch is accepted I will immediately remove the flags
from the glibc headers.


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index eb1a47b..02dae74 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -322,3 +322,29 @@ Why:  Accounting can now be enabled/disabled without kernel recompilation.
       controlled by a kernel/module/sysfs/sysctl parameter.
 Who:  Krzysztof Piotr Oledzki <ole@ans.pl>
 
+---------------------------
+What: MAP_GROWSDOWN, MAP_GROWSUP
+When: 2.6.29
+Why:  The two flags cannot be used securely because using them means that
+      collisions with other allocations cannot be avoided.  Assume a stack
+      of size S is allocated using mmap with the MAP_GROWSDOWN flag set.
+      The address is determined by the kernel to be A.  To make the
+      MAP_GROWSDOWN flag useful no guard page(s) can be allocated just
+      below the stack (i.e., just below address A).  This means the
+      address space just below A is unallocated.
+
+      Now assume a second, unrelated mmap call allocates a block in the
+      range [B, B+T), B+T < A.  Nothing will prevent the growing-down
+      stack from sooner or later reaching that block.  At this point
+      the stack will overwrite the memory in that second block and vice
+      versa.
+
+      The only way to prevent this is to change _every_ allocation via
+      mmap to include guard pages at either end.  This is completely
+      inpractical, expensive, and not a full protection any way.
+
+      These flags really aren't crucial to any code.  Their removal
+      shouldn't affect applications by more than a compilation problem.
+      And even these are unlikely from what I have seen.
+
+Who:  Ulrich Drepper <drepper@redhat.com>
diff --git a/mm/mmap.c b/mm/mmap.c
index 339cf5c..1a71b47 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -930,6 +930,21 @@ unsigned long do_mmap_pgoff(struct file * file, unsigned long addr,
 		if (!(file && (file->f_path.mnt->mnt_flags & MNT_NOEXEC)))
 			prot |= PROT_EXEC;
 
+	/* Hopefully support for these flags can be removed by 2.6.29.  */
+	if (unlikely (prot & (PROT_GROWSDOWN | PROT_GROWSUP))) {
+		static int __read_mostly count = 100;
+
+		if (count > 0 && printk_ratelimit()) {
+			char comm[TASK_COMM_LEN];
+
+			count--;
+			printk(KERN_INFO "mmap(): process `%s' used deprecated "
+					 "prot flags 0x%lx\n",
+				get_task_comm(comm, current),
+				prot & (PROT_GROWSDOWN | PROT_GROWSUP));
+		}
+	}
+
 	if (!len)
 		return -EINVAL;
 
