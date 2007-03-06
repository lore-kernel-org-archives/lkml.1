Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbXCFA62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbXCFA62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbXCFA62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:58:28 -0500
Received: from ozlabs.org ([203.10.76.45]:36670 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbXCFA61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:58:27 -0500
Subject: Re: [patch] paravirt: VDSO page is essential
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Roland McGrath <roland@redhat.com>, Andi Kleen <ak@suse.de>,
       virtualization <virtualization@lists.osdl.org>
In-Reply-To: <1173101297.26165.39.camel@localhost.localdomain>
References: <20070305120631.GA14105@elte.hu>
	 <1173101297.26165.39.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 06 Mar 2007 11:57:24 +1100
Message-Id: <1173142644.4644.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 00:28 +1100, Rusty Russell wrote:
> On Mon, 2007-03-05 at 13:06 +0100, Ingo Molnar wrote:
> > Subject: [patch] paravirt: VDSO page is essential
> > From: Ingo Molnar <mingo@elte.hu>
> > 
> > commit 3bbf54725467d604698721384d858b5983b87e8f disables the VDSO for 
> > CONFIG_PARAVIRT kernels. This #ifdeffery was a bad change: the VDSO is 
> > an essential component of Linux, and this change forces all of them to 
> > use int $0x80 - including sane ones like KVM. (If a hypervisor does not 
> > handle the VDSO properly then it can work things around via the vdso=0 
> > boot option. Or CONFIG_PARAVIRT should not have been merged. But in any 
> > case, it is a basic taste issue: we DO NOT #ifdef around core features 
> > like this!)
> 
> I agree with the criticism, dislike the snarly comments, and disagree
> with this patch.

And my patch was pretty crack-induced too.  Sorry.

I shouldn't have been thinking about using CONFIG options at all: we
should simply disable the vdso if CONFIG_COMPAT_VDSO=y when we
*actually* reserve top memory.

This still need some work (doing that now), but do people like the idea?

The current "vdso_disabled" flag merely disabled the ELF note, so it
needs to be made a little stronger, to not set up the vdso at all.

diff -r f75715e64a3b arch/i386/Kconfig
--- a/arch/i386/Kconfig	Tue Mar 06 00:04:50 2007 +1100
+++ b/arch/i386/Kconfig	Tue Mar 06 09:30:36 2007 +1100
@@ -893,9 +893,10 @@ config COMPAT_VDSO
 config COMPAT_VDSO
 	bool "Compat VDSO support"
 	default y
-	depends on !PARAVIRT
-	help
-	  Map the VDSO to the predictable old-style address too.
+	help
+	  Map the VDSO to the predictable old-style address too, or
+	  in the case of a VMI/Xen/lguest virtualized guest, don't create
+	  the VDSO at all.
 	---help---
 	  Say N here if you are running a sufficiently recent glibc
 	  version (2.3.3 or later), to remove the high-mapped
diff -r f75715e64a3b arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c	Tue Mar 06 00:04:50 2007 +1100
+++ b/arch/i386/kernel/sysenter.c	Tue Mar 06 09:25:47 2007 +1100
@@ -27,11 +27,7 @@
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
  */
-#ifdef CONFIG_PARAVIRT
-unsigned int __read_mostly vdso_enabled = 0;
-#else
 unsigned int __read_mostly vdso_enabled = 1;
-#endif
 
 EXPORT_SYMBOL_GPL(vdso_enabled);
 
@@ -51,7 +47,7 @@ void enable_sep_cpu(void)
 	int cpu = get_cpu();
 	struct tss_struct *tss = &per_cpu(init_tss, cpu);
 
-	if (!boot_cpu_has(X86_FEATURE_SEP)) {
+	if (!boot_cpu_has(X86_FEATURE_SEP) || !vdso_enabled) {
 		put_cpu();
 		return;
 	}
@@ -74,7 +70,12 @@ static struct page *syscall_pages[1];
 
 int __init sysenter_setup(void)
 {
-	void *syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
+	void *syscall_page;
+
+	if (!vdso_enabled)
+		return 0;
+
+	syscall_page = (void *)get_zeroed_page(GFP_ATOMIC);
 	syscall_pages[0] = virt_to_page(syscall_page);
 
 #ifdef CONFIG_COMPAT_VDSO
@@ -106,6 +107,9 @@ int arch_setup_additional_pages(struct l
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
 	int ret;
+
+	if (!vdso_enabled)
+		return 0;
 
 	down_write(&mm->mmap_sem);
 	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
diff -r f75715e64a3b arch/i386/mm/pgtable.c
--- a/arch/i386/mm/pgtable.c	Tue Mar 06 00:04:50 2007 +1100
+++ b/arch/i386/mm/pgtable.c	Tue Mar 06 09:32:51 2007 +1100
@@ -144,10 +144,8 @@ void set_pmd_pfn(unsigned long vaddr, un
 }
 
 static int fixmaps;
-#ifndef CONFIG_COMPAT_VDSO
 unsigned long __FIXADDR_TOP = 0xfffff000;
 EXPORT_SYMBOL(__FIXADDR_TOP);
-#endif
 
 void __set_fixmap (enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
 {
@@ -174,11 +172,12 @@ void reserve_top_address(unsigned long r
 	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
 	       (int)-reserve);
 #ifdef CONFIG_COMPAT_VDSO
-	BUG_ON(reserve != 0);
-#else
+	/* We can't have both reserved space and VDSO at 0xFFFFE000. */
+	if (reserve)
+		vdso_enabled = 0;
+#endif
 	__FIXADDR_TOP = -reserve - PAGE_SIZE;
 	__VMALLOC_RESERVE += reserve;
-#endif
 }
 
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
diff -r f75715e64a3b include/asm-i386/fixmap.h
--- a/include/asm-i386/fixmap.h	Tue Mar 06 00:04:50 2007 +1100
+++ b/include/asm-i386/fixmap.h	Tue Mar 06 09:29:15 2007 +1100
@@ -19,10 +19,8 @@
  * Leave one empty page between vmalloc'ed areas and
  * the start of the fixmap.
  */
-#ifndef CONFIG_COMPAT_VDSO
 extern unsigned long __FIXADDR_TOP;
-#else
-#define __FIXADDR_TOP  0xfffff000
+#ifdef CONFIG_COMPAT_VDSO
 #define FIXADDR_USER_START	__fix_to_virt(FIX_VDSO)
 #define FIXADDR_USER_END	__fix_to_virt(FIX_VDSO - 1)
 #endif


