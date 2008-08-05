Return-Path: <linux-kernel-owner+w=401wt.eu-S1752684AbYHEFr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbYHEFr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 01:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbYHEFru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 01:47:50 -0400
Received: from ozlabs.org ([203.10.76.45]:55721 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbYHEFrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 01:47:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/2] Export get_user_pages_fast
Date: Tue, 5 Aug 2008 15:47:34 +1000
User-Agent: KMail/1.9.9
Cc: benh@kernel.crashing.org, Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@qumranet.com>, Adrian Bunk <bunk@kernel.org>,
       lguest <lguest@ozlabs.org>, linux-kernel@vger.kernel.org
References: <200807301438.55941.rusty@rustcorp.com.au> <1217494343.11188.437.camel@pasglop> <200807311856.39837.nickpiggin@yahoo.com.au>
In-Reply-To: <200807311856.39837.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808051547.34743.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 July 2008 18:56:39 Nick Piggin wrote:
> I see. Here we are, then.

I can't see this in linux-next?  I put it in mm/util.c instead of
mm/memory.c: your version will barf on CONFIG_MMU=n AFAICT.

Since I'm the one who wants the export, I guess I'll fwd:

mm: Make generic weak get_user_pages_fast and EXPORT_GPL it

Out of line get_user_pages_fast fallback implementation, make it a weak
symbol, get rid of CONFIG_HAVE_GET_USER_PAGES_FAST.

Export the symbol to modules so lguest can use it.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/powerpc/Kconfig |    3 ---
 arch/x86/Kconfig     |    1 -
 arch/x86/mm/Makefile |    3 +--
 include/linux/mm.h   |   20 --------------------
 mm/Kconfig           |    3 ---
 mm/util.c            |   15 +++++++++++++++
 6 files changed, 16 insertions(+), 29 deletions(-)

diff -r 607fc39e88f5 arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig	Tue Aug 05 15:14:02 2008 +1000
+++ b/arch/powerpc/Kconfig	Tue Aug 05 15:46:04 2008 +1000
@@ -41,9 +41,6 @@ config GENERIC_HARDIRQS
 config GENERIC_HARDIRQS
 	bool
 	default y
-
-config HAVE_GET_USER_PAGES_FAST
-	def_bool PPC64
 
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool PPC64
diff -r 607fc39e88f5 arch/x86/Kconfig
--- a/arch/x86/Kconfig	Tue Aug 05 15:14:02 2008 +1000
+++ b/arch/x86/Kconfig	Tue Aug 05 15:46:04 2008 +1000
@@ -22,7 +22,6 @@ config X86
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select HAVE_IOREMAP_PROT
-	select HAVE_GET_USER_PAGES_FAST
 	select HAVE_KPROBES
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_KRETPROBES
diff -r 607fc39e88f5 arch/x86/mm/Makefile
--- a/arch/x86/mm/Makefile	Tue Aug 05 15:14:02 2008 +1000
+++ b/arch/x86/mm/Makefile	Tue Aug 05 15:46:04 2008 +1000
@@ -1,7 +1,6 @@ obj-y	:=  init_$(BITS).o fault.o ioremap
 obj-y	:=  init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
-	    pat.o pgtable.o
+	    pat.o pgtable.o gup.o
 
-obj-$(CONFIG_HAVE_GET_USER_PAGES_FAST) += gup.o
 obj-$(CONFIG_X86_32)		+= pgtable_32.o
 
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
diff -r 607fc39e88f5 include/linux/mm.h
--- a/include/linux/mm.h	Tue Aug 05 15:14:02 2008 +1000
+++ b/include/linux/mm.h	Tue Aug 05 15:46:04 2008 +1000
@@ -834,7 +834,6 @@ extern int mprotect_fixup(struct vm_area
 			  struct vm_area_struct **pprev, unsigned long start,
 			  unsigned long end, unsigned long newflags);
 
-#ifdef CONFIG_HAVE_GET_USER_PAGES_FAST
 /*
  * get_user_pages_fast provides equivalent functionality to get_user_pages,
  * operating on current and current->mm (force=0 and doesn't return any vmas).
@@ -847,25 +846,6 @@ extern int mprotect_fixup(struct vm_area
  */
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
-
-#else
-/*
- * Should probably be moved to asm-generic, and architectures can include it if
- * they don't implement their own get_user_pages_fast.
- */
-#define get_user_pages_fast(start, nr_pages, write, pages)	\
-({								\
-	struct mm_struct *mm = current->mm;			\
-	int ret;						\
-								\
-	down_read(&mm->mmap_sem);				\
-	ret = get_user_pages(current, mm, start, nr_pages,	\
-					write, 0, pages, NULL);	\
-	up_read(&mm->mmap_sem);					\
-								\
-	ret;							\
-})
-#endif
 
 /*
  * A callback you can register to apply pressure to ageable caches.
diff -r 607fc39e88f5 mm/Kconfig
--- a/mm/Kconfig	Tue Aug 05 15:14:02 2008 +1000
+++ b/mm/Kconfig	Tue Aug 05 15:46:04 2008 +1000
@@ -76,9 +76,6 @@ config FLAT_NODE_MEM_MAP
 config FLAT_NODE_MEM_MAP
 	def_bool y
 	depends on !SPARSEMEM
-
-config HAVE_GET_USER_PAGES_FAST
-	bool
 
 #
 # Both the NUMA code and DISCONTIGMEM use arrays of pg_data_t's
diff -r 607fc39e88f5 mm/util.c
--- a/mm/util.c	Tue Aug 05 15:14:02 2008 +1000
+++ b/mm/util.c	Tue Aug 05 15:46:04 2008 +1000
@@ -171,3 +171,18 @@ void arch_pick_mmap_layout(struct mm_str
 	mm->unmap_area = arch_unmap_area;
 }
 #endif
+
+int __attribute__((weak)) get_user_pages_fast(unsigned long start,
+				int nr_pages, int write, struct page **pages)
+{
+	struct mm_struct *mm = current->mm;
+	int ret;
+
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages(current, mm, start, nr_pages,
+					write, 0, pages, NULL);
+	up_read(&mm->mmap_sem);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(get_user_pages_fast);
