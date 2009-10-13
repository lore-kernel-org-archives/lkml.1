Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbZJMHoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbZJMHoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbZJMHoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:44:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:44640 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbZJMHon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:44:43 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Jie Zhang <jie.zhang@analog.com>, Robin Getz <rgetz@analog.com>
Subject: [PATCH] NOMMU: fix malloc performance by adding uninitialized flag
Date: Tue, 13 Oct 2009 03:44:05 -0400
Message-Id: <1255419845-30504-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <12871.1175267477@redhat.com>
References: <12871.1175267477@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Zhang <jie.zhang@analog.com>

The no-mmu code currently clears all anonymous mmap-ed memory.  While this
is what we want in the default case, all memory allocation from userspace
under no-mmu has to go through this interface, including malloc() which is
allowed to return uninitialized memory.  This can easily be a significant
performance slow down.  So for constrained embedded systems were security
is irrelevant, allow people to avoid unnecessarily clearing memory.

Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Signed-off-by: Robin Getz <rgetz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Documentation/nommu-mmap.txt      |   21 +++++++++++++++++++++
 fs/binfmt_elf_fdpic.c             |    2 +-
 include/asm-generic/mman-common.h |    5 +++++
 init/Kconfig                      |   16 ++++++++++++++++
 mm/nommu.c                        |    7 ++++---
 5 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/Documentation/nommu-mmap.txt b/Documentation/nommu-mmap.txt
index b565e82..30d09e8 100644
--- a/Documentation/nommu-mmap.txt
+++ b/Documentation/nommu-mmap.txt
@@ -16,6 +16,27 @@ the CLONE_VM flag.
 The behaviour is similar between the MMU and no-MMU cases, but not identical;
 and it's also much more restricted in the latter case:
 
+ (*) Anonymous mappings - general case
+
+	Anonymous mappings are  not  backed  by any file, and according to the
+	Linux man pages (ver 2.22 or later) contents are initialized to zero.
+
+	In the MMU case, regions are backed by arbitrary virtual pages, and the
+	contents are only mapped with physical pages and initialized to zero
+	when a read or write happens in that specific page. This spreads out
+	the time it takes to initialize the contents depending on the
+	read/write usage of the map.
+
+	In the no-MMU case, anonymous mappings are backed by physical pages,
+	and the entire map is initialized to zero at allocation time. This
+	can cause significant delays in userspace during malloc() as the C
+	library does an anonymous mapping, and the kernel is doing a memset
+	for the entire map. Since malloc's memory is not required to be
+	cleared, an (optional) flag MAP_UNINITIALIZE can be passed to the
+	kernel's do_mmap, which will not initialize the contents to zero.
+
+	uClibc supports this to provide a pretty significant speedup for malloc().
+
  (*) Anonymous mapping, MAP_PRIVATE
 
 	In the MMU case: VM regions backed by arbitrary pages; copy-on-write
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 38502c6..85db4a4 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -380,7 +380,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm,
 	down_write(&current->mm->mmap_sem);
 	current->mm->start_brk = do_mmap(NULL, 0, stack_size,
 					 PROT_READ | PROT_WRITE | PROT_EXEC,
-					 MAP_PRIVATE | MAP_ANONYMOUS | MAP_GROWSDOWN,
+					 MAP_PRIVATE | MAP_ANONYMOUS | MAP_UNINITIALIZE | MAP_GROWSDOWN,
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
index 09c5c64..ae15849 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1069,6 +1069,22 @@ config SLOB
 
 endchoice
 
+config MMAP_ALLOW_UNINITIALIZE
+	bool "Allow mmaped anonymous memory to be un-initialized"
+	depends on EMBEDDED && ! MMU
+	default n
+	help
+	   Normally (and according to the Linux spec) mmap'ed MAP_ANONYMOUS
+	   memory has it's contents initialized to zero. This kernel option
+	   gives you the option of not doing that by adding a MAP_UNINITIALIZE
+	   mmap flag (which uClibc's malloc() takes takes advantage of)
+	   which provides a huge performance boost.
+
+	   Because of the obvious security issues, this option should only be
+	   enabled on embedded devices which you control what is run in
+	   userspace. Since that isn't a problem on no-MMU systems, it is
+	   normally safe to say Y here.
+
 config PROFILING
 	bool "Profiling support (EXPERIMENTAL)"
 	help
diff --git a/mm/nommu.c b/mm/nommu.c
index 5189b5a..b62bd9d 100644
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
@@ -1343,6 +1340,10 @@ unsigned long do_mmap_pgoff(struct file *file,
 		goto error_just_free;
 	add_nommu_region(region);
 
+	/* clear anonymous mappings that don't ask for un-initialized data */
+	if (!(vma->vm_file) && !(flags & MAP_UNINITIALIZE))
+		memset((void *)region->vm_start, 0, region->vm_end - region->vm_start);
+
 	/* okay... we have a mapping; now we have to register it */
 	result = vma->vm_start;
 
-- 
1.6.5

