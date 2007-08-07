Return-Path: <linux-kernel-owner+w=401wt.eu-S935791AbXHGWd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935791AbXHGWd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbXHGWdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:33:06 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36167 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697AbXHGWdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:33:04 -0400
Subject: [RFC][PATCH 1/5] pagemap: remove file header
To: mpm@selenic.com
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Tue, 07 Aug 2007 15:33:00 -0700
Message-Id: <20070807223300.9228E0E0@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The /proc/<pid>/pagemap file has a header containing:
 * first byte:   0 for big endian, 1 for little
 * second byte:  page shift (eg 12 for 4096 byte pages)
 * third byte:   entry size in bytes (currently either 4 or 8)
 * fourth byte:  header size

The endianness is only useful when examining a raw dump of
pagemap from a different machine when you don't know the
source of the file.  This is pretty rare, and the programs
or scripts doing the copying off-machine can certainly be
made to hold this information.

The page size is available in userspace at least with libc's
getpagesize().  This will also never vary across processes,
so putting it in a per-process file doesn't make any difference.
If we need a "kernel's page size" exported to userspace,
perhaps we can put it in /proc/meminfo.

The entry size is the really tricky one.  This can't just
be sizeof(unsigned long) from userspace because we can have
32-bit processes on 64-bit kernels.  But, userspace can
certainly derive this value if it lseek()s to the end of
the file, and divides the file position by the size of its
virtual address space.

In any case, I believe this information is redundant, and
can be removed.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/proc/task_mmu.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff -puN fs/proc/task_mmu.c~pagemap-no-header fs/proc/task_mmu.c
--- lxc/fs/proc/task_mmu.c~pagemap-no-header	2007-08-07 15:30:52.000000000 -0700
+++ lxc-dave/fs/proc/task_mmu.c	2007-08-07 15:30:52.000000000 -0700
@@ -653,12 +653,12 @@ static ssize_t pagemap_read(struct file 
 		goto out;
 
 	ret = -EIO;
-	svpfn = src / sizeof(unsigned long) - 1;
+	svpfn = src / sizeof(unsigned long);
 	addr = PAGE_SIZE * svpfn;
-	if ((svpfn + 1) * sizeof(unsigned long) != src)
+	if (svpfn * sizeof(unsigned long) != src)
 		goto out;
 	evpfn = min((src + count) / sizeof(unsigned long),
-		    ((~0UL) >> PAGE_SHIFT) + 1) - 1;
+		    ((~0UL) >> PAGE_SHIFT) + 1);
 	count = (evpfn - svpfn) * sizeof(unsigned long);
 	end = PAGE_SIZE * evpfn;
 	//printk("src %ld svpfn %d evpfn %d count %d\n", src, svpfn, evpfn, count);
@@ -690,14 +690,6 @@ static ssize_t pagemap_read(struct file 
 	pm.count = count;
 	pm.out = (unsigned long __user *)buf;
 
-	if (svpfn == -1) {
-		add_to_pagemap(pm.next, 0, &pm);
-		put_user((char)(ntohl(1) != 1), buf);
-		put_user((char)PAGE_SHIFT, buf + 1);
-		put_user((char)sizeof(unsigned long), buf + 2);
-		put_user((char)sizeof(unsigned long), buf + 3);
-	}
-
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, pm.next);
 	while (pm.count > 0 && vma) {
_
