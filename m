Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYELXtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYELXtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 19:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbYELXtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 19:49:02 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33247
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754855AbYELXtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 19:49:00 -0400
Date: Mon, 12 May 2008 16:48:54 -0700 (PDT)
Message-Id: <20080512.164854.193697193.davem@davemloft.net>
To: jlieskov@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sparc: Fix mremap VA span checking.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080512.042453.238263459.davem@davemloft.net>
References: <1210590913.10883.9.camel@dhcp-lab-164.englab.brq.redhat.com>
	<20080512.042453.238263459.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 12 May 2008 04:24:53 -0700 (PDT)

> My first impression is that it might make sense to put an
> arch_mmap_check() call at the appropriate spots instead of duplicating
> this check so many times.

Thanks again for your report, the following is the final patch
I'll be using:

>From 94d149c34cda933ff5096aca94bb23bf68602f4e Mon Sep 17 00:00:00 2001
From: David S. Miller <davem@davemloft.net>
Date: Mon, 12 May 2008 16:33:33 -0700
Subject: [PATCH] sparc: Fix mremap address range validation.

Just like mmap, we need to validate address ranges regardless
of MAP_FIXED.

sparc{,64}_mmap_check()'s flag argument is unused, remove.

Based upon a report and preliminary patch by
Jan Lieskovsky <jlieskov@redhat.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/sys_sparc.c     |   48 ++++---------------------------------
 arch/sparc64/kernel/sys_sparc.c   |   36 +++------------------------
 arch/sparc64/kernel/sys_sparc32.c |   33 +-----------------------
 include/asm-sparc/mman.h          |    5 +--
 include/asm-sparc64/mman.h        |    5 +--
 5 files changed, 15 insertions(+), 112 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc.c b/arch/sparc/kernel/sys_sparc.c
index e995491..3c6b49a 100644
--- a/arch/sparc/kernel/sys_sparc.c
+++ b/arch/sparc/kernel/sys_sparc.c
@@ -219,7 +219,7 @@ out:
 	return err;
 }
 
-int sparc_mmap_check(unsigned long addr, unsigned long len, unsigned long flags)
+int sparc_mmap_check(unsigned long addr, unsigned long len)
 {
 	if (ARCH_SUN4C_SUN4 &&
 	    (len > 0x20000000 ||
@@ -295,52 +295,14 @@ asmlinkage unsigned long sparc_mremap(unsigned long addr,
 	unsigned long old_len, unsigned long new_len,
 	unsigned long flags, unsigned long new_addr)
 {
-	struct vm_area_struct *vma;
 	unsigned long ret = -EINVAL;
-	if (ARCH_SUN4C_SUN4) {
-		if (old_len > 0x20000000 || new_len > 0x20000000)
-			goto out;
-		if (addr < 0xe0000000 && addr + old_len > 0x20000000)
-			goto out;
-	}
-	if (old_len > TASK_SIZE - PAGE_SIZE ||
-	    new_len > TASK_SIZE - PAGE_SIZE)
+
+	if (unlikely(sparc_mmap_check(addr, old_len)))
+		goto out;
+	if (unlikely(sparc_mmap_check(new_addr, new_len)))
 		goto out;
 	down_write(&current->mm->mmap_sem);
-	if (flags & MREMAP_FIXED) {
-		if (ARCH_SUN4C_SUN4 &&
-		    new_addr < 0xe0000000 &&
-		    new_addr + new_len > 0x20000000)
-			goto out_sem;
-		if (new_addr + new_len > TASK_SIZE - PAGE_SIZE)
-			goto out_sem;
-	} else if ((ARCH_SUN4C_SUN4 && addr < 0xe0000000 &&
-		    addr + new_len > 0x20000000) ||
-		   addr + new_len > TASK_SIZE - PAGE_SIZE) {
-		unsigned long map_flags = 0;
-		struct file *file = NULL;
-
-		ret = -ENOMEM;
-		if (!(flags & MREMAP_MAYMOVE))
-			goto out_sem;
-
-		vma = find_vma(current->mm, addr);
-		if (vma) {
-			if (vma->vm_flags & VM_SHARED)
-				map_flags |= MAP_SHARED;
-			file = vma->vm_file;
-		}
-
-		new_addr = get_unmapped_area(file, addr, new_len,
-				     vma ? vma->vm_pgoff : 0,
-				     map_flags);
-		ret = new_addr;
-		if (new_addr & ~PAGE_MASK)
-			goto out_sem;
-		flags |= MREMAP_FIXED;
-	}
 	ret = do_mremap(addr, old_len, new_len, flags, new_addr);
-out_sem:
 	up_write(&current->mm->mmap_sem);
 out:
 	return ret;       
diff --git a/arch/sparc64/kernel/sys_sparc.c b/arch/sparc64/kernel/sys_sparc.c
index 0dbc941..ac1bff5 100644
--- a/arch/sparc64/kernel/sys_sparc.c
+++ b/arch/sparc64/kernel/sys_sparc.c
@@ -542,8 +542,7 @@ asmlinkage long sparc64_personality(unsigned long personality)
 	return ret;
 }
 
-int sparc64_mmap_check(unsigned long addr, unsigned long len,
-		unsigned long flags)
+int sparc64_mmap_check(unsigned long addr, unsigned long len)
 {
 	if (test_thread_flag(TIF_32BIT)) {
 		if (len >= STACK_TOP32)
@@ -609,46 +608,19 @@ asmlinkage unsigned long sys64_mremap(unsigned long addr,
 	unsigned long old_len, unsigned long new_len,
 	unsigned long flags, unsigned long new_addr)
 {
-	struct vm_area_struct *vma;
 	unsigned long ret = -EINVAL;
 
 	if (test_thread_flag(TIF_32BIT))
 		goto out;
 	if (unlikely(new_len >= VA_EXCLUDE_START))
 		goto out;
-	if (unlikely(invalid_64bit_range(addr, old_len)))
+	if (unlikely(sparc64_mmap_check(addr, old_len)))
+		goto out;
+	if (unlikely(sparc64_mmap_check(new_addr, new_len)))
 		goto out;
 
 	down_write(&current->mm->mmap_sem);
-	if (flags & MREMAP_FIXED) {
-		if (invalid_64bit_range(new_addr, new_len))
-			goto out_sem;
-	} else if (invalid_64bit_range(addr, new_len)) {
-		unsigned long map_flags = 0;
-		struct file *file = NULL;
-
-		ret = -ENOMEM;
-		if (!(flags & MREMAP_MAYMOVE))
-			goto out_sem;
-
-		vma = find_vma(current->mm, addr);
-		if (vma) {
-			if (vma->vm_flags & VM_SHARED)
-				map_flags |= MAP_SHARED;
-			file = vma->vm_file;
-		}
-
-		/* MREMAP_FIXED checked above. */
-		new_addr = get_unmapped_area(file, addr, new_len,
-				    vma ? vma->vm_pgoff : 0,
-				    map_flags);
-		ret = new_addr;
-		if (new_addr & ~PAGE_MASK)
-			goto out_sem;
-		flags |= MREMAP_FIXED;
-	}
 	ret = do_mremap(addr, old_len, new_len, flags, new_addr);
-out_sem:
 	up_write(&current->mm->mmap_sem);
 out:
 	return ret;       
diff --git a/arch/sparc64/kernel/sys_sparc32.c b/arch/sparc64/kernel/sys_sparc32.c
index 1aa4288..ba5bd62 100644
--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -867,44 +867,15 @@ asmlinkage unsigned long sys32_mremap(unsigned long addr,
 	unsigned long old_len, unsigned long new_len,
 	unsigned long flags, u32 __new_addr)
 {
-	struct vm_area_struct *vma;
 	unsigned long ret = -EINVAL;
 	unsigned long new_addr = __new_addr;
 
-	if (old_len > STACK_TOP32 || new_len > STACK_TOP32)
+	if (unlikely(sparc64_mmap_check(addr, old_len)))
 		goto out;
-	if (addr > STACK_TOP32 - old_len)
+	if (unlikely(sparc64_mmap_check(new_addr, new_len)))
 		goto out;
 	down_write(&current->mm->mmap_sem);
-	if (flags & MREMAP_FIXED) {
-		if (new_addr > STACK_TOP32 - new_len)
-			goto out_sem;
-	} else if (addr > STACK_TOP32 - new_len) {
-		unsigned long map_flags = 0;
-		struct file *file = NULL;
-
-		ret = -ENOMEM;
-		if (!(flags & MREMAP_MAYMOVE))
-			goto out_sem;
-
-		vma = find_vma(current->mm, addr);
-		if (vma) {
-			if (vma->vm_flags & VM_SHARED)
-				map_flags |= MAP_SHARED;
-			file = vma->vm_file;
-		}
-
-		/* MREMAP_FIXED checked above. */
-		new_addr = get_unmapped_area(file, addr, new_len,
-				    vma ? vma->vm_pgoff : 0,
-				    map_flags);
-		ret = new_addr;
-		if (new_addr & ~PAGE_MASK)
-			goto out_sem;
-		flags |= MREMAP_FIXED;
-	}
 	ret = do_mremap(addr, old_len, new_len, flags, new_addr);
-out_sem:
 	up_write(&current->mm->mmap_sem);
 out:
 	return ret;       
diff --git a/include/asm-sparc/mman.h b/include/asm-sparc/mman.h
index e18be98..3d16b40 100644
--- a/include/asm-sparc/mman.h
+++ b/include/asm-sparc/mman.h
@@ -24,9 +24,8 @@
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
-#define arch_mmap_check	sparc_mmap_check
-int sparc_mmap_check(unsigned long addr, unsigned long len,
-		unsigned long flags);
+#define arch_mmap_check(addr,len,flags)	sparc_mmap_check(addr,len)
+int sparc_mmap_check(unsigned long addr, unsigned long len);
 #endif
 #endif
 
diff --git a/include/asm-sparc64/mman.h b/include/asm-sparc64/mman.h
index e584563..625be4d 100644
--- a/include/asm-sparc64/mman.h
+++ b/include/asm-sparc64/mman.h
@@ -24,9 +24,8 @@
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
-#define arch_mmap_check	sparc64_mmap_check
-int sparc64_mmap_check(unsigned long addr, unsigned long len,
-		unsigned long flags);
+#define arch_mmap_check(addr,len,flags)	sparc64_mmap_check(addr,len)
+int sparc64_mmap_check(unsigned long addr, unsigned long len);
 #endif
 #endif
 
-- 
1.5.5.1.57.g5909c

