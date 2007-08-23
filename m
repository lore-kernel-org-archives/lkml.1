Return-Path: <linux-kernel-owner+w=401wt.eu-S1761637AbXHWJ2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761637AbXHWJ2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbXHWJ2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:28:37 -0400
Received: from twin.jikos.cz ([213.151.79.26]:35170 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756623AbXHWJ2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:28:36 -0400
Date: Thu, 23 Aug 2007 11:28:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Zan Lynx <zlynx@acm.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1 - memory layout change?  - lost support for
 MAP_32BIT? - mono crashes
In-Reply-To: <1187834905.190825.16.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708231126380.2460@twin.jikos.cz>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
 <1187834905.190825.16.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007, Zan Lynx wrote:

> After installing this new wonder kernel on my AMD-64 laptop, I 
> discovered that Beagle wouldn't start.  While enjoying how fast my 
> system felt ( :) ) I also discovered that Evolution wouldn't start 
> because it was built with mono integration.
[...]
> Mono claims to mmap with the MAP_32BIT option.
> In -rc3-mm1 strace shows mono's mmap like this:
> mmap(NULL, 65536, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANONYMOUS|MAP_32BIT, -1, 0) = 0x7fa21f5cb000

Hi Zan,

thanks for an excellent bugreport. Rather than throwing the whole 
pie-randomization and flexmmap support away, could you please test the 
patch below and let me know whether it fixes all your issues? Thanks.


From: Jiri Kosina <jkosina@suse.cz>

Handle MAP_32BIT flags properly in x86_64 flexmmap

We need to handle MAP_32BIT flags of mmap() properly for 64bit 
applications with filexible mmap layout.

This patch introduces x86_64-specific version of 
arch_get_unmapped_area_topdown() which differs from the generic one in 
handling of the MAP_32BIT flag -- when this flag is passed to mmap(), we 
stick back to the legacy layout for this particular mmap, which gives 
proper 32bit range.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/arch/x86_64/kernel/sys_x86_64.c b/arch/x86_64/kernel/sys_x86_64.c
index 4770b7a..0e44d08 100644
--- a/arch/x86_64/kernel/sys_x86_64.c
+++ b/arch/x86_64/kernel/sys_x86_64.c
@@ -16,6 +16,7 @@
 #include <linux/file.h>
 #include <linux/utsname.h>
 #include <linux/personality.h>
+#include <linux/random.h>
 
 #include <asm/uaccess.h>
 #include <asm/ia32.h>
@@ -69,6 +70,7 @@ static void find_start_end(unsigned long flags, unsigned long *begin,
 			   unsigned long *end)
 {
 	if (!test_thread_flag(TIF_IA32) && (flags & MAP_32BIT)) {
+		unsigned long new_begin;
 		/* This is usually used needed to map code in small
 		   model, so it needs to be in the first 31bit. Limit
 		   it to that.  This means we need to move the
@@ -78,6 +80,11 @@ static void find_start_end(unsigned long flags, unsigned long *begin,
 		   of playground for now. -AK */ 
 		*begin = 0x40000000; 
 		*end = 0x80000000;		
+		if (current->flags & PF_RANDOMIZE) {
+			new_begin = randomize_range(*begin, *begin + 0x02000000, 0);
+			if (new_begin)
+				*begin = new_begin;
+		}
 	} else {
 		*begin = TASK_UNMAPPED_BASE;
 		*end = TASK_SIZE; 
@@ -147,6 +154,97 @@ full_search:
 	}
 }
 
+
+unsigned long
+arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
+			  const unsigned long len, const unsigned long pgoff,
+			  const unsigned long flags)
+{
+	struct vm_area_struct *vma;
+	struct mm_struct *mm = current->mm;
+	unsigned long addr = addr0;
+
+	/* requested length too big for entire address space */
+	if (len > TASK_SIZE)
+		return -ENOMEM;
+
+	if (flags & MAP_FIXED)
+		return addr;
+
+	/* for MAP_32BIT mappings we force the legact mmap base */
+	if (!test_thread_flag(TIF_IA32) && (flags & MAP_32BIT))
+		goto bottomup;
+
+	/* requesting a specific address */
+	if (addr) {
+		addr = PAGE_ALIGN(addr);
+		vma = find_vma(mm, addr);
+		if (TASK_SIZE - len >= addr &&
+				(!vma || addr + len <= vma->vm_start))
+			return addr;
+	}
+
+	/* check if free_area_cache is useful for us */
+	if (len <= mm->cached_hole_size) {
+ 	        mm->cached_hole_size = 0;
+ 		mm->free_area_cache = mm->mmap_base;
+ 	}
+
+	/* either no address requested or can't fit in requested address hole */
+	addr = mm->free_area_cache;
+
+	/* make sure it can fit in the remaining address space */
+	if (addr > len) {
+		vma = find_vma(mm, addr-len);
+		if (!vma || addr <= vma->vm_start)
+			/* remember the address as a hint for next time */
+			return (mm->free_area_cache = addr-len);
+	}
+
+	if (mm->mmap_base < len)
+		goto bottomup;
+
+	addr = mm->mmap_base-len;
+
+	do {
+		/*
+		 * Lookup failure means no vma is above this address,
+		 * else if new region fits below vma->vm_start,
+		 * return with success:
+		 */
+		vma = find_vma(mm, addr);
+		if (!vma || addr+len <= vma->vm_start)
+			/* remember the address as a hint for next time */
+			return (mm->free_area_cache = addr);
+
+ 		/* remember the largest hole we saw so far */
+ 		if (addr + mm->cached_hole_size < vma->vm_start)
+ 		        mm->cached_hole_size = vma->vm_start - addr;
+
+		/* try just below the current vma->vm_start */
+		addr = vma->vm_start-len;
+	} while (len < vma->vm_start);
+
+bottomup:
+	/*
+	 * A failed mmap() very likely causes application failure,
+	 * so fall back to the bottom-up function here. This scenario
+	 * can happen with large stack limits and large mmap()
+	 * allocations.
+	 */
+	mm->cached_hole_size = ~0UL;
+  	mm->free_area_cache = TASK_UNMAPPED_BASE;
+	addr = arch_get_unmapped_area(filp, addr0, len, pgoff, flags);
+	/*
+	 * Restore the topdown base:
+	 */
+	mm->free_area_cache = mm->mmap_base;
+	mm->cached_hole_size = ~0UL;
+
+	return addr;
+}
+
+
 asmlinkage long sys_uname(struct new_utsname __user * name)
 {
 	int err;
diff --git a/include/asm-x86_64/pgtable.h b/include/asm-x86_64/pgtable.h
index c9d8764..8863d04 100644
--- a/include/asm-x86_64/pgtable.h
+++ b/include/asm-x86_64/pgtable.h
@@ -409,6 +409,7 @@ pte_t *lookup_address(unsigned long addr);
 		remap_pfn_range(vma, vaddr, pfn, size, prot)
 
 #define HAVE_ARCH_UNMAPPED_AREA
+#define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
 
 #define pgtable_cache_init()   do { } while (0)
 
