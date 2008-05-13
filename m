Return-Path: <linux-kernel-owner+w=401wt.eu-S1761959AbYEMUWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959AbYEMUWP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932146AbYEMUPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:15:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:38577 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134AbYEMUPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:15:50 -0400
Date: Tue, 13 May 2008 13:12:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 25/37] sparc: Fix mremap address range validation.
Message-ID: <20080513201229.GZ31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sparc-fix-mremap-address-range-validation.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

Just like mmap, we need to validate address ranges regardless
of MAP_FIXED.

sparc{,64}_mmap_check()'s flag argument is unused, remove.

Based upon a report and preliminary patch by
Jan Lieskovsky <jlieskov@redhat.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc/kernel/sys_sparc.c     |   48 +++-----------------------------------
 arch/sparc64/kernel/sys_sparc.c   |   36 +++-------------------------
 arch/sparc64/kernel/sys_sparc32.c |   33 +-------------------------
 include/asm-sparc/mman.h          |    5 +--
 include/asm-sparc64/mman.h        |    5 +--
 5 files changed, 15 insertions(+), 112 deletions(-)

--- a/arch/sparc64/kernel/sys_sparc32.c
+++ b/arch/sparc64/kernel/sys_sparc32.c
@@ -906,44 +906,15 @@ asmlinkage unsigned long sys32_mremap(un
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
--- a/arch/sparc64/kernel/sys_sparc.c
+++ b/arch/sparc64/kernel/sys_sparc.c
@@ -542,8 +542,7 @@ asmlinkage long sparc64_personality(unsi
 	return ret;
 }
 
-int sparc64_mmap_check(unsigned long addr, unsigned long len,
-		unsigned long flags)
+int sparc64_mmap_check(unsigned long addr, unsigned long len)
 {
 	if (test_thread_flag(TIF_32BIT)) {
 		if (len >= STACK_TOP32)
@@ -609,46 +608,19 @@ asmlinkage unsigned long sys64_mremap(un
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
--- a/arch/sparc/kernel/sys_sparc.c
+++ b/arch/sparc/kernel/sys_sparc.c
@@ -220,7 +220,7 @@ out:
 	return err;
 }
 
-int sparc_mmap_check(unsigned long addr, unsigned long len, unsigned long flags)
+int sparc_mmap_check(unsigned long addr, unsigned long len)
 {
 	if (ARCH_SUN4C_SUN4 &&
 	    (len > 0x20000000 ||
@@ -296,52 +296,14 @@ asmlinkage unsigned long sparc_mremap(un
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
--- a/include/asm-sparc64/mman.h
+++ b/include/asm-sparc64/mman.h
@@ -37,9 +37,8 @@
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
-#define arch_mmap_check	sparc64_mmap_check
-int sparc64_mmap_check(unsigned long addr, unsigned long len,
-		unsigned long flags);
+#define arch_mmap_check(addr,len,flags)	sparc64_mmap_check(addr,len)
+int sparc64_mmap_check(unsigned long addr, unsigned long len);
 #endif
 #endif
 
--- a/include/asm-sparc/mman.h
+++ b/include/asm-sparc/mman.h
@@ -37,9 +37,8 @@
 
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
-#define arch_mmap_check	sparc_mmap_check
-int sparc_mmap_check(unsigned long addr, unsigned long len,
-		unsigned long flags);
+#define arch_mmap_check(addr,len,flags)	sparc_mmap_check(addr,len)
+int sparc_mmap_check(unsigned long addr, unsigned long len);
 #endif
 #endif
 

-- 
