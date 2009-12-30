Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbZL3URn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbZL3URn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:17:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbZL3URm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:17:42 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:57208 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbZL3URl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:17:41 -0500
X-Trace: 317591880/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiEBAEZEO0tPRRyw/2dsb2JhbAAI1wiEMQQ
X-IronPort-AV: E=Sophos;i="4.47,476,1257120000"; 
   d="scan'208";a="317591880"
Date: Wed, 30 Dec 2009 20:17:34 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, David Howells <dhowells@redhat.com>,
       Eric B Munson <ebmunson@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH] mm: move sys_mmap_pgoff from util.c
Message-ID: <alpine.LSU.2.00.0912302009040.30390@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move sys_mmap_pgoff() from mm/util.c to mm/mmap.c and mm/nommu.c,
where we'd expect to find such code: especially now that it contains
the MAP_HUGETLB handling.  Revert mm/util.c to how it was in 2.6.32.

This patch just ignores MAP_HUGETLB in the nommu case, as in 2.6.32,
whereas 2.6.33-rc2 reported -ENOSYS.  Perhaps validate_mmap_request()
should reject it with -EINVAL?  Add that later if necessary.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/mmap.c  |   40 ++++++++++++++++++++++++++++++++++++++++
 mm/nommu.c |   25 +++++++++++++++++++++++++
 mm/util.c  |   44 --------------------------------------------
 3 files changed, 65 insertions(+), 44 deletions(-)

--- 2.6.33-rc2/mm/mmap.c	2009-12-18 11:42:54.000000000 +0000
+++ linux/mm/mmap.c	2009-12-26 18:28:30.000000000 +0000
@@ -1043,6 +1043,46 @@ unsigned long do_mmap_pgoff(struct file
 }
 EXPORT_SYMBOL(do_mmap_pgoff);
 
+SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
+		unsigned long, prot, unsigned long, flags,
+		unsigned long, fd, unsigned long, pgoff)
+{
+	struct file *file = NULL;
+	unsigned long retval = -EBADF;
+
+	if (!(flags & MAP_ANONYMOUS)) {
+		if (unlikely(flags & MAP_HUGETLB))
+			return -EINVAL;
+		file = fget(fd);
+		if (!file)
+			goto out;
+	} else if (flags & MAP_HUGETLB) {
+		struct user_struct *user = NULL;
+		/*
+		 * VM_NORESERVE is used because the reservations will be
+		 * taken when vm_ops->mmap() is called
+		 * A dummy user value is used because we are not locking
+		 * memory so no accounting is necessary
+		 */
+		len = ALIGN(len, huge_page_size(&default_hstate));
+		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len, VM_NORESERVE,
+						&user, HUGETLB_ANONHUGE_INODE);
+		if (IS_ERR(file))
+			return PTR_ERR(file);
+	}
+
+	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+
+	down_write(&current->mm->mmap_sem);
+	retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+	up_write(&current->mm->mmap_sem);
+
+	if (file)
+		fput(file);
+out:
+	return retval;
+}
+
 /*
  * Some shared mappigns will want the pages marked read-only
  * to track write events. If so, we'll downgrade vm_page_prot
--- 2.6.33-rc2/mm/nommu.c	2009-12-18 11:42:54.000000000 +0000
+++ linux/mm/nommu.c	2009-12-26 18:28:30.000000000 +0000
@@ -1398,6 +1398,31 @@ error_getting_region:
 }
 EXPORT_SYMBOL(do_mmap_pgoff);
 
+SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
+		unsigned long, prot, unsigned long, flags,
+		unsigned long, fd, unsigned long, pgoff)
+{
+	struct file *file = NULL;
+	unsigned long retval = -EBADF;
+
+	if (!(flags & MAP_ANONYMOUS)) {
+		file = fget(fd);
+		if (!file)
+			goto out;
+	}
+
+	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
+
+	down_write(&current->mm->mmap_sem);
+	retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+	up_write(&current->mm->mmap_sem);
+
+	if (file)
+		fput(file);
+out:
+	return retval;
+}
+
 /*
  * split a vma into two pieces at address 'addr', a new vma is allocated either
  * for the first part or the tail.
--- 2.6.33-rc2/mm/util.c	2009-12-18 11:42:55.000000000 +0000
+++ linux/mm/util.c	2009-12-26 18:28:30.000000000 +0000
@@ -4,10 +4,6 @@
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/sched.h>
-#include <linux/hugetlb.h>
-#include <linux/syscalls.h>
-#include <linux/mman.h>
-#include <linux/file.h>
 #include <asm/uaccess.h>
 
 #define CREATE_TRACE_POINTS
@@ -272,46 +268,6 @@ int __attribute__((weak)) get_user_pages
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
 
-SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
-		unsigned long, prot, unsigned long, flags,
-		unsigned long, fd, unsigned long, pgoff)
-{
-	struct file * file = NULL;
-	unsigned long retval = -EBADF;
-
-	if (!(flags & MAP_ANONYMOUS)) {
-		if (unlikely(flags & MAP_HUGETLB))
-			return -EINVAL;
-		file = fget(fd);
-		if (!file)
-			goto out;
-	} else if (flags & MAP_HUGETLB) {
-		struct user_struct *user = NULL;
-		/*
-		 * VM_NORESERVE is used because the reservations will be
-		 * taken when vm_ops->mmap() is called
-		 * A dummy user value is used because we are not locking
-		 * memory so no accounting is necessary
-		 */
-		len = ALIGN(len, huge_page_size(&default_hstate));
-		file = hugetlb_file_setup(HUGETLB_ANON_FILE, len, VM_NORESERVE,
-						&user, HUGETLB_ANONHUGE_INODE);
-		if (IS_ERR(file))
-			return PTR_ERR(file);
-	}
-
-	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
-
-	down_write(&current->mm->mmap_sem);
-	retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
-	up_write(&current->mm->mmap_sem);
-
-	if (file)
-		fput(file);
-out:
-	return retval;
-}
-
 /* Tracepoints definitions. */
 EXPORT_TRACEPOINT_SYMBOL(kmalloc);
 EXPORT_TRACEPOINT_SYMBOL(kmem_cache_alloc);
