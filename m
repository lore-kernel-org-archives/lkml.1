Return-Path: <linux-kernel-owner+w=401wt.eu-S932415Ab0AFRYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab0AFRYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325Ab0AFRYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:24:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932407Ab0AFRYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:24:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/4] NOMMU: Avoiding duplicate icache flushes of shared maps
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org,
       David Howells <dhowells@redhat.com>, Mike Frysinger <vapier@gentoo.org>
Date: Wed, 06 Jan 2010 17:23:23 +0000
Message-ID: <20100106172322.25862.9944.stgit@warthog.procyon.org.uk>
In-Reply-To: <20100106172317.25862.64950.stgit@warthog.procyon.org.uk>
References: <20100106172317.25862.64950.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

When working with FDPIC, there are many shared mappings of read-only code
regions between applications (the C library, applet packages like busybox,
etc.), but the current do_mmap_pgoff() function will issue an icache flush
whenever a VMA is added to an MM instead of only doing it when the map is
initially created.

The flush can instead be done when a region is first mmapped PROT_EXEC.  Note
that we may not rely on the first mapping of a region being executable - it's
possible for it to be PROT_READ only, so we have to remember whether we've
flushed the region or not, and then flush the entire region when a bit of it is
made executable.

However, this also affects the brk area.  That will no longer be executable.
We can mprotect() it to PROT_EXEC on MPU-mode kernels, but for NOMMU mode
kernels, when it increases the brk allocation, making sys_brk() flush the extra
from the icache should suffice.  The brk area probably isn't used by NOMMU
programs since the brk area can only use up the leavings from the stack
allocation, where the stack allocation is larger than requested.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---

 include/linux/mm_types.h |    2 ++
 mm/nommu.c               |   11 ++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)


diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 84a524a..84d020b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -123,6 +123,8 @@ struct vm_region {
 	struct file	*vm_file;	/* the backing file or NULL */
 
 	atomic_t	vm_usage;	/* region usage count */
+	bool		vm_icache_flushed : 1; /* true if the icache has been flushed for
+						* this region */
 };
 
 /*
diff --git a/mm/nommu.c b/mm/nommu.c
index 6f9248f..a8d1752 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -432,6 +432,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
 	/*
 	 * Ok, looks good - let it rip.
 	 */
+	flush_icache_range(mm->brk, brk);
 	return mm->brk = brk;
 }
 
@@ -1353,10 +1354,14 @@ unsigned long do_mmap_pgoff(struct file *file,
 share:
 	add_vma_to_mm(current->mm, vma);
 
-	up_write(&nommu_region_sem);
+	/* we flush the region from the icache only when the first executable
+	 * mapping of it is made  */
+	if (vma->vm_flags & VM_EXEC && !region->vm_icache_flushed) {
+		flush_icache_range(region->vm_start, region->vm_end);
+		region->vm_icache_flushed = true;
+	}
 
-	if (prot & PROT_EXEC)
-		flush_icache_range(result, result + len);
+	up_write(&nommu_region_sem);
 
 	kleave(" = %lx", result);
 	return result;

