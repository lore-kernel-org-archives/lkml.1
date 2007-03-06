Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbXCFBDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbXCFBDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 20:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932860AbXCFBDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 20:03:25 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:41202 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932857AbXCFBDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 20:03:24 -0500
Message-ID: <45ECBDDC.8080708@vmware.com>
Date: Mon, 05 Mar 2007 17:03:24 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Andi Kleen <ak@suse.de>, virtualization <virtualization@lists.osdl.org>
Subject: Re: [patch] paravirt: VDSO page is essential
References: <20070305120631.GA14105@elte.hu>	 <1173101297.26165.39.camel@localhost.localdomain> <1173142644.4644.6.camel@localhost.localdomain>
In-Reply-To: <1173142644.4644.6.camel@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------020304040801080602050400"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020304040801080602050400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Rusty Russell wrote:
> On Tue, 2007-03-06 at 00:28 +1100, Rusty Russell wrote:
>   
>> On Mon, 2007-03-05 at 13:06 +0100, Ingo Molnar wrote:
>>     
>>> Subject: [patch] paravirt: VDSO page is essential
>>> From: Ingo Molnar <mingo@elte.hu>
>>>
>>> commit 3bbf54725467d604698721384d858b5983b87e8f disables the VDSO for 
>>> CONFIG_PARAVIRT kernels. This #ifdeffery was a bad change: the VDSO is 
>>> an essential component of Linux, and this change forces all of them to 
>>> use int $0x80 - including sane ones like KVM. (If a hypervisor does not 
>>> handle the VDSO properly then it can work things around via the vdso=0 
>>> boot option. Or CONFIG_PARAVIRT should not have been merged. But in any 
>>> case, it is a basic taste issue: we DO NOT #ifdef around core features 
>>> like this!)
>>>       
>> I agree with the criticism, dislike the snarly comments, and disagree
>> with this patch.
>>     
>
> And my patch was pretty crack-induced too.  Sorry.
>
> I shouldn't have been thinking about using CONFIG options at all: we
> should simply disable the vdso if CONFIG_COMPAT_VDSO=y when we
> *actually* reserve top memory.
>
> This still need some work (doing that now), but do people like the idea?
>
> The current "vdso_disabled" flag merely disabled the ELF note, so it
> needs to be made a little stronger, to not set up the vdso at all.
>   

I had just sent this out for internal review...



--------------020304040801080602050400
Content-Type: text/plain;
 name="compat-vdso-broken"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="compat-vdso-broken"

COMPAT_VDSO is incompatible with PARAVIRT for most implementations, as they
must relocate the fixmap to make room for a hypervisor.  So allow COMPAT_VDSO
kernels to relocate the fixmap as well, just disable the VDSO if they do so.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r fad0910252d2 arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c	Mon Mar 05 15:24:04 2007 -0800
+++ b/arch/i386/kernel/sysenter.c	Mon Mar 05 15:27:31 2007 -0800
@@ -74,7 +74,12 @@ static struct page *syscall_pages[1];
 
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
@@ -106,6 +111,11 @@ int arch_setup_additional_pages(struct l
 	struct mm_struct *mm = current->mm;
 	unsigned long addr;
 	int ret;
+
+	if (!vdso_enabled) {
+		current->mm->context.vdso = (void *)~0UL;
+		return 0;
+	}
 
 	down_write(&mm->mmap_sem);
 	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
diff -r fad0910252d2 arch/i386/mm/pgtable.c
--- a/arch/i386/mm/pgtable.c	Mon Mar 05 15:24:04 2007 -0800
+++ b/arch/i386/mm/pgtable.c	Mon Mar 05 16:06:31 2007 -0800
@@ -144,10 +144,8 @@ void set_pmd_pfn(unsigned long vaddr, un
 }
 
 static int fixmaps;
-#ifndef CONFIG_COMPAT_VDSO
 unsigned long __FIXADDR_TOP = 0xfffff000;
 EXPORT_SYMBOL(__FIXADDR_TOP);
-#endif
 
 void __set_fixmap (enum fixed_addresses idx, unsigned long phys, pgprot_t flags)
 {
@@ -174,11 +172,13 @@ void reserve_top_address(unsigned long r
 	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
 	       (int)-reserve);
 #ifdef CONFIG_COMPAT_VDSO
-	BUG_ON(reserve != 0);
-#else
+	if (reserve != 0) {
+		printk(KERN_WARNING "Compat VDSO is incompatible with fixmap relocation - disabling VDSO\n");
+		vdso_enabled = 0;
+	}
+#endif
 	__FIXADDR_TOP = -reserve - PAGE_SIZE;
 	__VMALLOC_RESERVE += reserve;
-#endif
 }
 
 pte_t *pte_alloc_one_kernel(struct mm_struct *mm, unsigned long address)
diff -r fad0910252d2 include/asm-i386/elf.h
--- a/include/asm-i386/elf.h	Mon Mar 05 15:24:04 2007 -0800
+++ b/include/asm-i386/elf.h	Mon Mar 05 15:44:43 2007 -0800
@@ -137,7 +137,7 @@ extern int dump_task_extended_fpu (struc
 
 #ifdef CONFIG_COMPAT_VDSO
 # define VDSO_COMPAT_BASE	VDSO_HIGH_BASE
-# define VDSO_PRELINK		VDSO_HIGH_BASE
+# define VDSO_PRELINK		0xffffe000UL
 #else
 # define VDSO_COMPAT_BASE	VDSO_BASE
 # define VDSO_PRELINK		0
diff -r fad0910252d2 include/asm-i386/fixmap.h
--- a/include/asm-i386/fixmap.h	Mon Mar 05 15:24:04 2007 -0800
+++ b/include/asm-i386/fixmap.h	Mon Mar 05 15:59:30 2007 -0800
@@ -14,19 +14,6 @@
 #define _ASM_FIXMAP_H
 
 
-/* used by vmalloc.c, vsyscall.lds.S.
- *
- * Leave one empty page between vmalloc'ed areas and
- * the start of the fixmap.
- */
-#ifndef CONFIG_COMPAT_VDSO
-extern unsigned long __FIXADDR_TOP;
-#else
-#define __FIXADDR_TOP  0xfffff000
-#define FIXADDR_USER_START	__fix_to_virt(FIX_VDSO)
-#define FIXADDR_USER_END	__fix_to_virt(FIX_VDSO - 1)
-#endif
-
 #ifndef __ASSEMBLY__
 #include <linux/kernel.h>
 #include <asm/acpi.h>
@@ -35,6 +22,15 @@ extern unsigned long __FIXADDR_TOP;
 #ifdef CONFIG_HIGHMEM
 #include <linux/threads.h>
 #include <asm/kmap_types.h>
+#endif
+
+/* used by vmalloc.c, vsyscall.lds.S, elf.h, pgtable.c */
+extern unsigned long __FIXADDR_TOP;
+
+/* used for dumping VDSO to core files */
+#ifdef CONFIG_COMPAT_VDSO
+#define FIXADDR_USER_START     __fix_to_virt(FIX_VDSO)
+#define FIXADDR_USER_END       __fix_to_virt(FIX_VDSO - 1)
 #endif
 
 /*

--------------020304040801080602050400--
