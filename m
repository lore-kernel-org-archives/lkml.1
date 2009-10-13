Return-Path: <linux-kernel-owner+w=401wt.eu-S933851AbZJMKLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851AbZJMKLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933787AbZJMKLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:11:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20537 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933314AbZJMKLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:11:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1255419845-30504-1-git-send-email-vapier@gentoo.org>
References: <1255419845-30504-1-git-send-email-vapier@gentoo.org> <12871.1175267477@redhat.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dhowells@redhat.com, uclinux-dev@uclinux.org,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Jie Zhang <jie.zhang@analog.com>, Robin Getz <rgetz@analog.com>
Subject: Re: [PATCH] NOMMU: fix malloc performance by adding uninitialized flag
Date: Tue, 13 Oct 2009 11:10:18 +0100
Message-ID: <32310.1255428618@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This seems reasonable.  MAP_UNINITIALIZE definitely needs adding to the
general list so that the MMU folks don't steal the bit.  I would also call it
MAP_UNINITIALIZED (well, actually, I'd call it MAP_UNINITIALISED:-), otherwise
it looks like you're asking mmap() to uninitialise the memory for you.
Similarly for CONFIG_MMAP_ALLOW_UNINITIALIZE - I'd add a terminal 'D'.

I've also re-written the documenation somewhat and expanded the patch
description to mention the changes to ELF-FDPIC.

David
---
From: Jie Zhang <jie.zhang@analog.com>
Subject: [PATCH] NOMMU: Fix malloc performance by adding uninitialized flag

The NOMMU code currently clears all anonymous mmapped memory.  While this is
what we want in the default case, all memory allocation from userspace under
NOMMU has to go through this interface, including malloc() which is allowed to
return uninitialized memory.  This can easily be a significant performance
penalty.  So for constrained embedded systems were security is irrelevant,
allow people to avoid clearing memory unnecessarily.

This also alters the ELF-FDPIC binfmt such that it obtains uninitialised
memory for the brk and stack region.

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Robin Getz <rgetz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 Documentation/nommu-mmap.txt      |   26 ++++++++++++++++++++++++++
 fs/binfmt_elf_fdpic.c             |    3 ++-
 include/asm-generic/mman-common.h |    5 +++++
 init/Kconfig                      |   22 ++++++++++++++++++++++
 mm/nommu.c                        |    8 +++++---
 5 files changed, 60 insertions(+), 4 deletions(-)


diff --git a/Documentation/nommu-mmap.txt b/Documentation/nommu-mmap.txt
index b565e82..b216ced 100644
--- a/Documentation/nommu-mmap.txt
+++ b/Documentation/nommu-mmap.txt
@@ -119,6 +119,32 @@ FURTHER NOTES ON NO-MMU MMAP
      granule but will only discard the excess if appropriately configured as
      this has an effect on fragmentation.
 
+ (*) The memory allocated by a request for an anonymous mapping will normally
+     be cleared by the kernel before being returned in accordance with the
+     Linux man pages (ver 2.22 or later)
+
+     In the MMU case this can be achieved with reasonable performance as
+     regions are backed by virtual pages, with the contents only being mapped
+     to cleared physical pages when a write happens on that specific page
+     (prior to which, the pages are effectively mapped to the global zero page
+     from which reads can take place).  This spreads out the time it takes to
+     initialize the contents of a page - depending on the write-usage of the
+     mapping.
+
+     In the no-MMU case, however, anonymous mappings are backed by physical
+     pages, and the entire map is cleared at allocation time.  This can cause
+     significant delays during a userspace malloc() as the C library does an
+     anonymous mapping and the kernel then does a memset for the entire map.
+
+     However, for memory that isn't required to be precleared - such as that
+     returned by malloc() - mmap() can take a MAP_UNINITIALIZE flag to indicate
+     to the kernel that it shouldn't bother clearing the memory before
+     returning it.  Note that CONFIG_MMAP_ALLOW_UNINITIALIZE must be enabled to
+     permit this, otherwise the flag will be ignored.
+
+     uClibc uses this to speed up malloc(), and the ELF-FDPIC binfmt uses this
+     to allocate the brk and stack region.
+
  (*) A list of all the private copy and anonymous mappings on the system is
      visible through /proc/maps in no-MMU mode.
 
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index e19b9bb..ab7e57b 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -380,7 +380,8 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	down_write(&current->mm->mmap_sem);
 	current->mm->start_brk = do_mmap(NULL, 0, stack_size,
 					 PROT_READ | PROT_WRITE | PROT_EXEC,
-					 MAP_PRIVATE | MAP_ANONYMOUS | MAP_GROWSDOWN,
+					 MAP_PRIVATE | MAP_ANONYMOUS |
+					 MAP_UNINITIALIZE | MAP_GROWSDOWN,
 					 0);
 
 	if (IS_ERR_VALUE(current->mm->start_brk)) {
diff --git a/include/asm-generic/mman-common.h b/include/asm-generic/mman-common.h
index 5ee13b2..dddf626 100644
--- a/include/asm-generic/mman-common.h
+++ b/include/asm-generic/mman-common.h
@@ -19,6 +19,11 @@
 #define MAP_TYPE	0x0f		/* Mask for type of mapping */
 #define MAP_FIXED	0x10		/* Interpret addr exactly */
 #define MAP_ANONYMOUS	0x20		/* don't use a file */
+#ifdef CONFIG_MMAP_ALLOW_UNINITIALIZE
+# define MAP_UNINITIALIZE 0x4000000	/* For anonymous mmap, memory could be uninitialized */
+#else
+# define MAP_UNINITIALIZE 0x0		/* Don't support this flag */
+#endif
 
 #define MS_ASYNC	1		/* sync memory asynchronously */
 #define MS_INVALIDATE	2		/* invalidate the caches */
diff --git a/init/Kconfig b/init/Kconfig
index 09c5c64..9c0ffd1 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1069,6 +1069,28 @@ config SLOB
 
 endchoice
 
+config MMAP_ALLOW_UNINITIALIZE
+	bool "Allow mmapped anonymous memory to be un-initialized"
+	depends on EMBEDDED && !MMU
+	default n
+	help
+	   Normally, and according to the Linux spec, anonymous memory obtained
+	   from mmap() has it's contents cleared before it is passed to
+	   userspace.  Enabling this config option allows you to request that
+	   mmap() skip that if it is given an MAP_UNINITIALIZE flag, thus
+	   providing a huge performance boost.  If this option is not enabled,
+	   then the flag will be ignored.
+
+	   This is taken advantage of by uClibc's malloc(), and also by
+	   ELF-FDPIC binfmt's brk and stack allocator.
+
+	   Because of the obvious security issues, this option should only be
+	   enabled on embedded devices where you control what is run in
+	   userspace.  Since that isn't generally a problem on no-MMU systems,
+	   it is normally safe to say Y here.
+
+	   See Documentation/nommu-mmap.txt for more information.
+
 config PROFILING
 	bool "Profiling support (EXPERIMENTAL)"
 	help
diff --git a/mm/nommu.c b/mm/nommu.c
index eefce2d..688f6d0 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1143,9 +1143,6 @@ static int do_mmap_private(struct vm_area_struct *vma,
 		if (ret < rlen)
 			memset(base + ret, 0, rlen - ret);
 
-	} else {
-		/* if it's an anonymous mapping, then just clear it */
-		memset(base, 0, rlen);
 	}
 
 	return 0;
@@ -1343,6 +1340,11 @@ unsigned long do_mmap_pgoff(struct file *file,
 		goto error_just_free;
 	add_nommu_region(region);
 
+	/* clear anonymous mappings that don't ask for uninitialized data */
+	if (!vma->vm_file && !(flags & MAP_UNINITIALIZE))
+		memset((void *)region->vm_start, 0,
+		       region->vm_end - region->vm_start);
+
 	/* okay... we have a mapping; now we have to register it */
 	result = vma->vm_start;
 
