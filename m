Return-Path: <linux-kernel-owner+w=401wt.eu-S964824AbXCOANH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824AbXCOANH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 20:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964855AbXCOANH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 20:13:07 -0400
Received: from wlserva2.wldelft.nl ([145.9.150.101]:37857 "EHLO wldelft.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964824AbXCOANF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 20:13:05 -0400
X-Greylist: delayed 1955 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Mar 2007 20:13:05 EDT
Message-ID: <45F88780.1080507@wldelft.nl>
Date: Thu, 15 Mar 2007 00:38:40 +0100
From: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: rdunlap@xenotime.net, roland@redhat.com, mingo@elte.hu, akpm@osdl.org,
       stable@kernel.org, greg@kroah.com
Subject: [PATCH] Fix COMPAT_VDSO regression bug
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


    Revert "[PATCH] Fix CONFIG_COMPAT_VDSO"
    This reverts commit a1f3bb9ae4497a2ed3eac773fd7798ac33a0371f.

    Several systems couldnt boot using CONFIG_HIGHMEM64G=y as
    reported in bug #8040. Reverting the above patch solved the problem.


    Cc: Randy Dunlap <rdunlap@xenotime.net>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Roland McGrath <roland@redhat.com>
    Bisected-by: Leroy Raymond van Logchem <leroy.vanlogchem@gmail.com>


arch/i386/kernel/entry.S    |    4 ----
arch/i386/kernel/sysenter.c |    2 --
include/asm-i386/elf.h      |    7 ++++---
include/asm-i386/fixmap.h   |    2 --
include/asm-i386/page.h     |    2 --
5 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/i386/kernel/entry.S b/arch/i386/kernel/entry.S
index 5e47683..06461b8 100644
--- a/arch/i386/kernel/entry.S
+++ b/arch/i386/kernel/entry.S
@@ -302,16 +302,12 @@ sysenter_past_esp:
        pushl $(__USER_CS)
        CFI_ADJUST_CFA_OFFSET 4
        /*CFI_REL_OFFSET cs, 0*/
-#ifndef CONFIG_COMPAT_VDSO
        /*
         * Push current_thread_info()->sysenter_return to the stack.
         * A tiny bit of offset fixup is necessary - 4*4 means the 4 words
         * pushed above; +8 corresponds to copy_thread's esp0 setting.
         */
        pushl (TI_sysenter_return-THREAD_SIZE+8+4*4)(%esp)
-#else
-       pushl $SYSENTER_RETURN
-#endif
        CFI_ADJUST_CFA_OFFSET 4
        CFI_REL_OFFSET eip, 0

diff --git a/arch/i386/kernel/sysenter.c b/arch/i386/kernel/sysenter.c
index 666f70d..a1090e1 100644
--- a/arch/i386/kernel/sysenter.c
+++ b/arch/i386/kernel/sysenter.c
@@ -95,7 +95,6 @@ int __init sysenter_setup(void)
        return 0;
}

-#ifndef CONFIG_COMPAT_VDSO
static struct page *syscall_nopage(struct vm_area_struct *vma,
                                unsigned long adr, int *type)
{
@@ -190,4 +189,3 @@ int in_gate_area_no_task(unsigned long addr)
{
        return 0;
}
-#endif
diff --git a/include/asm-i386/elf.h b/include/asm-i386/elf.h
index 369035d..157bb7a 100644
--- a/include/asm-i386/elf.h
+++ b/include/asm-i386/elf.h
@@ -143,9 +143,12 @@ extern int dump_task_extended_fpu (struct
task_struct *, struct user_fxsr_struct
# define VDSO_PRELINK          0
#endif

-#define VDSO_SYM(x) \
+#define VDSO_COMPAT_SYM(x) \
                (VDSO_COMPAT_BASE + (unsigned long)(x) - VDSO_PRELINK)

+#define VDSO_SYM(x) \
+               (VDSO_BASE + (unsigned long)(x) - VDSO_PRELINK)
+
#define VDSO_HIGH_EHDR         ((const struct elfhdr *) VDSO_HIGH_BASE)
#define VDSO_EHDR              ((const struct elfhdr *) VDSO_COMPAT_BASE)

@@ -153,12 +156,10 @@ extern void __kernel_vsyscall;

#define VDSO_ENTRY             VDSO_SYM(&__kernel_vsyscall)

-#ifndef CONFIG_COMPAT_VDSO
#define ARCH_HAS_SETUP_ADDITIONAL_PAGES
struct linux_binprm;
extern int arch_setup_additional_pages(struct linux_binprm *bprm,
                                        int executable_stack);
-#endif

extern unsigned int vdso_enabled;

diff --git a/include/asm-i386/fixmap.h b/include/asm-i386/fixmap.h
index 3e9f610..02428cb 100644
--- a/include/asm-i386/fixmap.h
+++ b/include/asm-i386/fixmap.h
@@ -23,8 +23,6 @@
extern unsigned long __FIXADDR_TOP;
#else
#define __FIXADDR_TOP  0xfffff000
-#define FIXADDR_USER_START     __fix_to_virt(FIX_VDSO)
-#define FIXADDR_USER_END       __fix_to_virt(FIX_VDSO - 1)
#endif

#ifndef __ASSEMBLY__
diff --git a/include/asm-i386/page.h b/include/asm-i386/page.h
index 7b19f45..fd3f64a 100644
--- a/include/asm-i386/page.h
+++ b/include/asm-i386/page.h
@@ -143,9 +143,7 @@ extern int page_is_ram(unsigned long pagenr);
#include <asm-generic/memory_model.h>
#include <asm-generic/page.h>

-#ifndef CONFIG_COMPAT_VDSO
#define __HAVE_ARCH_GATE_AREA 1
-#endif
#endif /* __KERNEL__ */

#endif /* _I386_PAGE_H */

