Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbZC0BvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbZC0BvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763164AbZC0BvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:51:04 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:45653 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759862AbZC0Bu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:50:58 -0400
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 12/13] score - New architecure port to SunplusCT S+CORE
  processor
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF33220B3D.C7812D3B-ON48257586.0009C8A6-48257586.000A0DBB@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Fri, 27 Mar 2009 09:48:04 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/03/27 ?? 09:48:06,
	Serialize complete at 2009/03/27 ?? 09:48:06
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/score lastest patch place at 
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/lib/libgcc.h 
linux-2.6-git.new/arch/score/lib/libgcc.h
--- linux-2.6-git.ori/arch/score/lib/libgcc.h   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/lib/libgcc.h   2009-03-13 
17:22:23.000000000 +0800
@@ -0,0 +1,46 @@
+/*
+ * arch/score/lib/libgcc.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+
+#ifndef __ASM_LIBGCC_H
+#define __ASM_LIBGCC_H
+
+#include <asm/byteorder.h>
+
+typedef int word_type __attribute__ ((mode (__word__)));
+
+#ifdef __BIG_ENDIAN
+struct DWstruct {
+       int high, low;
+};
+#elif defined(__LITTLE_ENDIAN)
+struct DWstruct {
+       int low, high;
+};
+#else
+#error I feel sick.
+#endif
+
+typedef union
+{
+       struct DWstruct s;
+       long long ll;
+} DWunion;
+
+#endif /* __ASM_LIBGCC_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/lib/lshrdi3.c 
linux-2.6-git.new/arch/score/lib/lshrdi3.c
--- linux-2.6-git.ori/arch/score/lib/lshrdi3.c  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/lib/lshrdi3.c  2009-03-23 
14:15:42.000000000 +0800
@@ -0,0 +1,47 @@
+/*
+ * arch/score/lib/lshrdi3.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+
+#include <linux/module.h>
+#include "libgcc.h"
+
+long long __lshrdi3(long long u, word_type b)
+{
+       DWunion uu, w;
+       word_type bm;
+
+       if (b == 0)
+               return u;
+
+       uu.ll = u;
+       bm = 32 - b;
+
+       if (bm <= 0) {
+               w.s.high = 0;
+               w.s.low = (unsigned int) uu.s.high >> -bm;
+       } else {
+               const unsigned int carries = (unsigned int) uu.s.high << 
bm;
+
+               w.s.high = (unsigned int) uu.s.high >> b;
+               w.s.low = ((unsigned int) uu.s.low >> b) | carries;
+       }
+
+       return w.ll;
+}
+EXPORT_SYMBOL(__lshrdi3);
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/lib/Makefile 
linux-2.6-git.new/arch/score/lib/Makefile
--- linux-2.6-git.ori/arch/score/lib/Makefile   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/lib/Makefile   2009-03-24 
08:58:50.000000000 +0800
@@ -0,0 +1,8 @@
+#
+# Makefile for SCORE-specific library files..
+#
+
+lib-y  += string.o checksum.o checksum_copy.o
+
+# libgcc-style stuff needed in the kernel
+obj-y  += ashldi3.o ashrdi3.o cmpdi2.o lshrdi3.o ucmpdi2.o
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/lib/string.S 
linux-2.6-git.new/arch/score/lib/string.S
--- linux-2.6-git.ori/arch/score/lib/string.S   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/lib/string.S   2009-03-23 
18:02:48.000000000 +0800
@@ -0,0 +1,203 @@
+/*
+ * arch/score/lib/string.S
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <asm/errno.h>
+
+       .text
+       .globl  __strncpy_from_user
+       .align 2
+__strncpy_from_user:
+       cmpi.c  r6, 0
+       mv      r9, r6
+       ble     .L2
+0:     lbu     r7, [r5]
+       ldi     r8, 0
+1:     sb      r7, [r4]
+2:     lb      r6, [r5]
+       cmp.c   r6, r8
+       beq     .L2
+ 
+.L5:
+       addi    r8, 1
+       cmp.c   r8, r9
+       beq     .L7
+3:     lbu     r6, [r5, 1]+
+4:     sb      r6, [r4, 1]+
+5:     lb      r7, [r5]
+       cmpi.c  r7, 0
+       bne     .L5
+.L7:
+       mv      r4, r8
+       br      r3
+.L2:
+       ldi     r8, 0
+       mv      r4, r8
+       br      r3
+       .section .fixup, "ax"
+99:
+       ldi     r4, -EFAULT
+       br      r3
+       .previous
+       .section __ex_table, "a"
+       .align  2
+       .word   0b ,99b
+       .word   1b ,99b
+       .word   2b ,99b
+       .word   3b ,99b
+       .word   4b ,99b
+       .word   5b ,99b
+       .previous
+ 
+       .globl __strnlen_user
+       .align 2 
+__strnlen_user: 
+       cmpi.c  r5, 0
+       ble     .L11
+0:     lb      r6, [r4]
+       ldi     r7, 0
+       cmp.c   r6, r7
+       beq     .L11
+.L15: 
+       addi    r7, 1
+       cmp.c   r7, r5
+       beq     .L23
+1:     lb      r6, [r4,1]+
+       cmpi.c  r6, 0
+       bne     .L15
+.L23:
+       addri   r4, r7, 1
+       br      r3
+ 
+.L11:
+       ldi     r4, 1
+       br      r3
+       .section .fixup, "ax"
+99:
+       ldi     r4, 0
+       br      r3
+ 
+       .section __ex_table,"a"
+       .align 2
+       .word   0b, 99b
+       .word   1b, 99b
+       .previous
+ 
+       .globl  __strlen_user
+       .align 2
+__strlen_user:
+0:     lb      r6, [r4]
+       mv      r7, r4
+       extsb   r6, r6
+       cmpi.c  r6, 0
+       mv      r4, r6
+       beq     .L27
+.L28:
+1:     lb      r6, [r7, 1]+
+       addi    r6, 1
+       cmpi.c  r6, 0
+       bne     .L28 
+.L27:
+       br      r3
+       .section .fixup, "ax"
+       ldi     r4, 0x0
+       br      r3
+99:
+       ldi     r4, 0
+       br      r3
+       .previous
+       .section __ex_table, "a"
+       .align  2
+       .word   0b ,99b
+       .word   1b ,99b
+       .previous
+
+       .globl  __copy_tofrom_user
+       .align 2
+__copy_tofrom_user:
+       cmpi.c  r6, 0
+       mv      r10,r6
+       beq     .L32
+       ldi     r9, 0
+.L34:
+       add     r6, r5, r9
+0:     lbu     r8, [r6]
+       add     r7, r4, r9
+1:     sb      r8, [r7]
+       addi    r9, 1
+       cmp.c   r9, r10
+       bne     .L34
+.L32: 
+       ldi     r4, 0
+       br      r3
+       .section .fixup, "ax"
+99:
+       sub     r4, r10, r9
+       br      r3
+       .previous
+       .section __ex_table, "a"
+       .align  2
+       .word   0b, 99b
+       .word   1b, 99b
+       .previous
+
+       .globl __clear_user
+       .align 2
+__clear_user:
+       cmpi.c  r5, 0
+       beq     .L38
+       ldi     r6, 0
+       mv      r7, r6
+.L40:
+       addi    r6, 1
+0:     sb      r7, [r4]+, 1
+       cmp.c   r6, r5
+       bne     .L40
+.L38:
+       ldi     r4, 0
+       br      r3
+
+       .section .fixup, "ax"
+       br      r3
+       .previous
+       .section __ex_table, "a"
+       .align  2
+99:
+       .word   0b, 99b 
+       .previous 
+
+       .align  2
+       .globl  __put_user_unknown
+__put_user_unknown:
+       .set volatile
+       ldi     r4, -EFAULT
+       br      r3
+
+       .align  2
+       .globl  __get_user_unknown
+       .set volatile
+__get_user_unknown:
+       ldi     r5, 0
+       ldi     r4, -EFAULT
+       br      r3
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/lib/ucmpdi2.c 
linux-2.6-git.new/arch/score/lib/ucmpdi2.c
--- linux-2.6-git.ori/arch/score/lib/ucmpdi2.c  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/lib/ucmpdi2.c  2009-03-23 
14:15:20.000000000 +0800
@@ -0,0 +1,38 @@
+/*
+ * arch/score/lib/ucmpdi2.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include "libgcc.h"
+
+word_type __ucmpdi2(unsigned long long a, unsigned long long b)
+{
+       const DWunion au = {.ll = a};
+       const DWunion bu = {.ll = b};
+
+       if ((unsigned int) au.s.high < (unsigned int) bu.s.high)
+               return 0;
+       else if ((unsigned int) au.s.high > (unsigned int) bu.s.high)
+               return 2;
+       if ((unsigned int) au.s.low < (unsigned int) bu.s.low)
+               return 0;
+       else if ((unsigned int) au.s.low > (unsigned int) bu.s.low)
+               return 2;
+       return 1;
+}
+EXPORT_SYMBOL(__ucmpdi2);
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/Makefile 
linux-2.6-git.new/arch/score/Makefile
--- linux-2.6-git.ori/arch/score/Makefile       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/Makefile       2009-03-26 
13:59:53.000000000 +0800
@@ -0,0 +1,54 @@
+#
+# arch/score/Makefile
+#
+# This file is subject to the terms and conditions of the GNU General 
Public
+# License.  See the file "COPYING" in the main directory of this archive
+# for more details.
+#
+
+KBUILD_DEFCONFIG:= spct6600_defconfig
+CROSS_COMPILE  := score-elf-
+
+cflags-y       := -ffunction-sections -ffreestanding
+
+#
+# CPU-dependent compiler/assembler options for optimization.
+#
+cflags-y       += -O2 -G0 -pipe -mel -mnhwloop -D__linux__ -D__SCOREEL__
+
+#
+# Board-dependent options and extra files
+#
+
+KBUILD_AFLAGS  += $(cflags-y)
+KBUILD_CFLAGS  += $(cflags-y)
+MODFLAGS       += -mlong-calls
+LDFLAGS                += --oformat elf32-littlescore
+LDFLAGS_vmlinux        += -G0 -static -nostdlib
+
+CLEAN_FILES    += arch/score/kernel/vmlinux.lds
+
+#
+# Choosing incompatible machines durings configuration will result in
+# error messages during linking.  Select a default linkscript if
+# none has been choosen above.
+#
+
+head-y         := arch/score/kernel/head.o arch/score/kernel/init_task.o
+
+libs-y         += arch/score/lib/
+core-y         += arch/score/kernel/ arch/score/mm/
+
+boot           := arch/score/boot
+
+vmlinux.bin: vmlinux
+       $(Q)$(MAKE) $(build)=$(boot) $(boot)/$@
+
+archclean:
+       @$(MAKE) $(clean)=$(boot)
+
+define archhelp
+       echo '  vmlinux.bin          - Raw binary boot image'
+       echo
+       echo '  These will be default as apropriate for a configured 
platform.'
+endef
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/cache.c 
linux-2.6-git.new/arch/score/mm/cache.c
--- linux-2.6-git.ori/arch/score/mm/cache.c     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/cache.c     2009-03-23 
18:03:22.000000000 +0800
@@ -0,0 +1,332 @@
+/*
+ * arch/score/mm/cache.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/linkage.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <asm/cache.h>
+#include <asm/cacheflush.h>
+#include <asm/mmu_context.h>
+
+#define CACHE_SAVE 0
+
+/* Cache operations. */
+void (*flush_cache_all)(void);
+void (*__flush_cache_all)(void);
+void (*flush_cache_mm)(struct mm_struct *mm);
+void (*flush_cache_range)(struct vm_area_struct *vma,
+                               unsigned long start, unsigned long end);
+void (*flush_cache_page)(struct vm_area_struct *vma,
+                               unsigned long page, unsigned long pfn);
+void (*flush_icache_range)(unsigned long start, unsigned long end);
+void (*__flush_cache_vmap)(void);
+void (*__flush_cache_vunmap)(void);
+void (*flush_cache_sigtramp)(unsigned long addr);
+void (*flush_data_cache_page)(unsigned long addr);
+EXPORT_SYMBOL(flush_data_cache_page);
+void (*flush_icache_all)(void);
+
+/*Score 7 cache operations*/
+void s7_flush_cache_all(void);
+void s7_flush_dcache_all(void);
+void s7_flush_icache_all(void);
+static inline void s7___flush_cache_all(void);
+static void s7_flush_cache_mm(struct mm_struct *mm);
+static void s7_flush_cache_range(struct vm_area_struct *vma,
+                                unsigned long start, unsigned long end);
+static void s7_flush_cache_page(struct vm_area_struct *vma,
+                                unsigned long page, unsigned long pfn);
+static void s7_flush_icache_range(unsigned long start, unsigned long 
end);
+static void s7_flush_cache_sigtramp(unsigned long addr);
+static void s7_flush_data_cache_page(unsigned long addr);
+static void s7_flush_dcache_range(unsigned long start, unsigned long 
end);
+
+/*
+ * We could optimize the case where the cache argument is not BCACHE but
+ * that seems very atypical use ...
+ */
+asmlinkage int sys_cacheflush(unsigned long addr,
+       unsigned long bytes, unsigned int cache)
+{
+       if (bytes == 0)
+               return 0;
+       if (!access_ok(VERIFY_WRITE, (void __user *) addr, bytes))
+               return -EFAULT;
+
+       flush_icache_range(addr, addr + bytes);
+
+       return 0;
+}
+
+void __update_cache(struct vm_area_struct *vma, unsigned long address,
+       pte_t pte)
+{
+       struct page *page;
+       unsigned long pfn, addr;
+       int exec = (vma->vm_flags & VM_EXEC);
+
+       pfn = pte_pfn(pte);
+       if (unlikely(!pfn_valid(pfn)))
+               return;
+       page = pfn_to_page(pfn);
+       if (page_mapping(page) && Page_dcache_dirty(page)) {
+               addr = (unsigned long) page_address(page);
+               if (exec)
+                       s7_flush_data_cache_page(addr);
+               ClearPageDcacheDirty(page);
+       }
+}
+
+static inline void setup_protection_map(void)
+{
+       protection_map[0] = PAGE_NONE;
+       protection_map[1] = PAGE_READONLY;
+       protection_map[2] = PAGE_COPY;
+       protection_map[3] = PAGE_COPY;
+       protection_map[4] = PAGE_READONLY;
+       protection_map[5] = PAGE_READONLY;
+       protection_map[6] = PAGE_COPY;
+       protection_map[7] = PAGE_COPY;
+       protection_map[8] = PAGE_NONE;
+       protection_map[9] = PAGE_READONLY;
+       protection_map[10] = PAGE_SHARED;
+       protection_map[11] = PAGE_SHARED;
+       protection_map[12] = PAGE_READONLY;
+       protection_map[13] = PAGE_READONLY;
+       protection_map[14] = PAGE_SHARED;
+       protection_map[15] = PAGE_SHARED;
+}
+
+void __devinit cpu_cache_init(void)
+{
+       flush_cache_all = s7_flush_cache_all;
+       __flush_cache_all = s7___flush_cache_all;
+       flush_cache_mm = s7_flush_cache_mm;
+       flush_cache_range = s7_flush_cache_range;
+       flush_cache_page = s7_flush_cache_page;
+       flush_icache_range = s7_flush_icache_range;
+       flush_cache_sigtramp = s7_flush_cache_sigtramp;
+       flush_data_cache_page = s7_flush_data_cache_page;
+
+       setup_protection_map();
+}
+
+void s7_flush_icache_all(void)
+{
+       __asm__ __volatile__(
+       "la r8, s7_flush_icache_all\n"
+       "cache 0x10, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       ::: "r8");
+}
+
+void s7_flush_dcache_all(void)
+{
+       __asm__ __volatile__(
+       "la r8, s7_flush_dcache_all\n"
+       "cache 0x1f, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1a, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       ::: "r8");
+}
+
+void s7_flush_cache_all(void)
+{
+       __asm__ __volatile__(
+       "la r8, s7_flush_cache_all\n"
+       "cache 0x10, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1f, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1a, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       ::: "r8");
+}
+
+void s7___flush_cache_all(void)
+{
+       __asm__ __volatile__(
+       "la r8, s7_flush_cache_all\n"
+       "cache 0x10, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1f, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       "cache 0x1a, [r8, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\nnop\n"
+       ::: "r8");
+}
+
+static void s7_flush_cache_mm(struct mm_struct *mm)
+{
+       if(!cpu_context(0, mm))
+               return;
+       s7_flush_cache_all();
+}
+
+/*if we flush a range precisely , the processing may be very long.
+We must check each page in the range whether present. If the page is 
present,
+we can flush the range in the page. Be careful, the range may be cross 
two
+page, a page is present and another is not present.
+*/
+/*
+The interface is provided in hopes that the port can find
+a suitably efficient method for removing multiple page
+sized regions from the cache.
+*/
+static void s7_flush_cache_range(struct vm_area_struct *vma, unsigned 
long start,
+                                unsigned long end)
+{
+       struct mm_struct *mm = vma->vm_mm;
+       int exec = vma->vm_flags & VM_EXEC;
+       pgd_t *pgdp;
+       pud_t *pudp;
+       pmd_t *pmdp;
+       pte_t *ptep;
+
+       if(!cpu_context(0, mm))
+               return;
+
+       pgdp = pgd_offset(mm, start);
+       pudp = pud_offset(pgdp, start);
+       pmdp = pmd_offset(pudp, start);
+       ptep = pte_offset(pmdp, start);
+
+       while (start <= end) {
+               unsigned long tmpend;
+               pgdp = pgd_offset(mm, start);
+               pudp = pud_offset(pgdp, start);
+               pmdp = pmd_offset(pudp, start);
+               ptep = pte_offset(pmdp, start);
+
+               if (!(pte_val(*ptep) & _PAGE_PRESENT)) {
+                       start = (start + PAGE_SIZE) & ~(PAGE_SIZE - 1);
+                       continue;
+               }
+               tmpend = (start | (PAGE_SIZE-1)) > end ?
+                                end : (start | (PAGE_SIZE-1));
+
+               s7_flush_dcache_range(start, tmpend);
+               if (exec)
+                       s7_flush_icache_range(start, tmpend);
+               start=(start + PAGE_SIZE) & ~(PAGE_SIZE - 1);
+       }
+}
+
+static void s7_flush_cache_page(struct vm_area_struct *vma, unsigned long 
addr,
+                               unsigned long pfn)
+{
+       int exec = vma->vm_flags & VM_EXEC;
+       unsigned long kaddr = 0xa0000000 | (pfn << PAGE_SHIFT);
+
+       s7_flush_dcache_range(kaddr, kaddr + PAGE_SIZE);
+
+       if (exec)
+               s7_flush_icache_range(kaddr, kaddr + PAGE_SIZE);
+}
+
+static void s7_flush_cache_sigtramp(unsigned long addr)
+{
+       __asm__ __volatile__(
+       "cache 0x02, [%0, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+       "cache 0x02, [%0, 0x4]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+
+       "cache 0x0d, [%0, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+       "cache 0x0d, [%0, 0x4]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+
+       "cache 0x1a, [%0, 0]\n"
+       "nop\nnop\nnop\nnop\nnop\n"
+       :: "r" (addr));
+}
+
+/*
+Just flush entire Dcache!!
+You must ensure the page doesn't include instructions, because
+the function will not flush the Icache.
+The addr must be cache aligned.
+*/
+static void s7_flush_data_cache_page(unsigned long addr)
+{
+       unsigned int i;
+       for (i = 0; i < PAGE_SIZE / DCACHE_LSIZE ; i += DCACHE_LSIZE) {
+               __asm__ __volatile__(
+               "cache 0x0e, [%0, 0]\n"
+               "cache 0x1a, [%0, 0]\n"
+               "nop\n"
+               :
+               : "r" (addr));
+               addr += DCACHE_LSIZE;
+       }
+}
+
+/*
+1. WB and invalid a cache line of Dcache
+2. Drain Write Buffer
+the range must be smaller than PAGE_SIZE
+*/
+static void s7_flush_dcache_range(unsigned long start, unsigned long end)
+{
+       int size, i;
+ 
+       start = start & ~(ICACHE_LSIZE - 1);
+       end = end & ~(ICACHE_LSIZE - 1);
+       size = end - start;
+       /* flush dcache to ram, and invalidate dcache lines. */
+       for (i = 0; i < size; i += DCACHE_LSIZE) {
+               __asm__ __volatile__(
+               "cache 0x0e, [%0, 0]\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+               "cache 0x1a, [%0, 0]\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+               :
+               : "r" (start));
+               start += DCACHE_LSIZE;
+       }
+}
+
+static void s7_flush_icache_range(unsigned long start, unsigned long end)
+{
+       int size, i;
+       start = start & ~(ICACHE_LSIZE - 1);
+       end = end & ~(ICACHE_LSIZE - 1);
+
+       size = end - start;
+       /* invalidate icache lines. */
+       for (i = 0; i < size; i += ICACHE_LSIZE) {
+               __asm__ __volatile__(
+               "cache 0x02, [%0, 0]\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+               :
+               : "r" (start));
+               start += ICACHE_LSIZE;
+       }
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/dma-default.c 
linux-2.6-git.new/arch/score/mm/dma-default.c
--- linux-2.6-git.ori/arch/score/mm/dma-default.c       1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/dma-default.c       2009-03-23 
14:27:26.000000000 +0800
@@ -0,0 +1,147 @@
+/*
+ * arch/score/mm/dma-default.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/types.h>
+#include <linux/dma-mapping.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/string.h>
+#include <asm/cache.h>
+#include <asm/io.h>
+
+void *dma_alloc_noncoherent(struct device *dev, size_t size,
+       dma_addr_t *dma_handle, gfp_t gfp)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_alloc_noncoherent);
+
+void *dma_alloc_coherent(struct device *dev, size_t size,
+       dma_addr_t *dma_handle, gfp_t gfp)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_alloc_coherent);
+
+void dma_free_noncoherent(struct device *dev, size_t size, void *vaddr,
+       dma_addr_t dma_handle)
+{}
+EXPORT_SYMBOL(dma_free_noncoherent);
+
+void dma_free_coherent(struct device *dev, size_t size, void *vaddr,
+       dma_addr_t dma_handle)
+{}
+EXPORT_SYMBOL(dma_free_coherent);
+
+dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
+       enum dma_data_direction direction)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_map_single);
+
+void dma_unmap_single(struct device *dev, dma_addr_t dma_addr, size_t 
size,
+       enum dma_data_direction direction)
+{
+}
+EXPORT_SYMBOL(dma_unmap_single);
+
+int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
+       enum dma_data_direction direction)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_map_sg);
+
+dma_addr_t dma_map_page(struct device *dev, struct page *page,
+       unsigned long offset, size_t size, enum dma_data_direction 
direction)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_map_page);
+
+void dma_unmap_page(struct device *dev, dma_addr_t dma_address, size_t 
size,
+       enum dma_data_direction direction)
+{}
+EXPORT_SYMBOL(dma_unmap_page);
+
+void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int 
nhwentries,
+       enum dma_data_direction direction)
+{}
+EXPORT_SYMBOL(dma_unmap_sg);
+
+void dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle,
+       size_t size, enum dma_data_direction direction)
+{}
+EXPORT_SYMBOL(dma_sync_single_for_cpu);
+
+void dma_sync_single_for_device(struct device *dev, dma_addr_t 
dma_handle,
+       size_t size, enum dma_data_direction direction)
+{}
+EXPORT_SYMBOL(dma_sync_single_for_device);
+
+void dma_sync_single_range_for_cpu(struct device *dev, dma_addr_t 
dma_handle,
+       unsigned long offset, size_t size, enum dma_data_direction 
direction)
+{}
+EXPORT_SYMBOL(dma_sync_single_range_for_cpu);
+
+void dma_sync_single_range_for_device(struct device *dev, dma_addr_t 
dma_handle,
+       unsigned long offset, size_t size, enum dma_data_direction 
direction)
+{}
+EXPORT_SYMBOL(dma_sync_single_range_for_device);
+
+void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int 
nelems,
+       enum dma_data_direction direction)
+{}
+EXPORT_SYMBOL(dma_sync_sg_for_cpu);
+
+void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, 
int nelems,
+       enum dma_data_direction direction)
+{}
+EXPORT_SYMBOL(dma_sync_sg_for_device);
+
+int dma_mapping_error(struct device *dev, dma_addr_t dma_addr)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_mapping_error);
+
+int dma_supported(struct device *dev, u64 mask)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_supported);
+
+int dma_is_consistent(struct device *dev, dma_addr_t dma_addr)
+{
+       return 0;
+}
+EXPORT_SYMBOL(dma_is_consistent);
+
+void dma_cache_sync(struct device *dev, void *vaddr, size_t size,
+       enum dma_data_direction direction)
+{}
+EXPORT_SYMBOL(dma_cache_sync);
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/extable.c 
linux-2.6-git.new/arch/score/mm/extable.c
--- linux-2.6-git.ori/arch/score/mm/extable.c   1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/extable.c   2009-03-23 
14:27:37.000000000 +0800
@@ -0,0 +1,41 @@
+/*
+ * arch/score/mm/extable.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <asm/uaccess.h>
+#include <asm/ptrace.h>
+
+int fixup_exception(struct pt_regs *regs)
+{
+       const struct exception_table_entry *fixup;
+
+       fixup = search_exception_tables(regs->cp0_epc);
+       if (fixup) {
+               regs->cp0_epc = fixup->nextinsn;
+               return 1;
+       }
+       return 0;
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/fault.c 
linux-2.6-git.new/arch/score/mm/fault.c
--- linux-2.6-git.ori/arch/score/mm/fault.c     1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/fault.c     2009-03-23 
18:03:47.000000000 +0800
@@ -0,0 +1,240 @@
+/*
+ * arch/score/mm/fault.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/signal.h>
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/ptrace.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/vt_kern.h>             /* For unblank_screen() */
+#include <linux/module.h>
+#include <asm/system.h>
+#include <asm/uaccess.h>
+#include <asm/ptrace.h>
+
+extern unsigned long pgd_current;
+/*
+ * This routine handles page faults.  It determines the address,
+ * and the problem, and then passes it off to one of the appropriate
+ * routines.
+ */
+asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long write,
+                               unsigned long address)
+{
+       struct vm_area_struct *vma = NULL;
+       struct task_struct *tsk = current;
+       struct mm_struct *mm = tsk->mm;
+       const int field = sizeof(unsigned long) * 2;
+       siginfo_t info;
+       int fault;
+
+       info.si_code = SEGV_MAPERR;
+
+       /*
+       * We fault-in kernel-space virtual memory on-demand. The
+       * 'reference' page table is init_mm.pgd.
+       *
+       * NOTE! We MUST NOT take any locks for this case. We may
+       * be in an interrupt or a critical region, and should
+       * only copy the information from the master page table,
+       * nothing more.
+       */
+       if (unlikely(address >= VMALLOC_START && address <= VMALLOC_END))
+               goto vmalloc_fault;
+#ifdef MODULE_START
+       if (unlikely(address >= MODULE_START && address < MODULE_END))
+               goto vmalloc_fault;
+#endif
+
+       /*
+       * If we're in an interrupt or have no user
+       * context, we must not take the fault..
+       */
+       if (in_atomic() || !mm)
+               goto bad_area_nosemaphore;
+
+       down_read(&mm->mmap_sem);
+       vma = find_vma(mm, address);
+       if (!vma)
+               goto bad_area;
+       if (vma->vm_start <= address)
+               goto good_area;
+       if (!(vma->vm_flags & VM_GROWSDOWN))
+               goto bad_area;
+       if (expand_stack(vma, address))
+               goto bad_area;
+       /*
+       * Ok, we have a good vm_area for this memory access, so
+       * we can handle it..
+        */
+good_area:
+       info.si_code = SEGV_ACCERR;
+
+       if (write) {
+               if (!(vma->vm_flags & VM_WRITE))
+                       goto bad_area;
+       } else {
+               if (!(vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC)))
+                       goto bad_area;
+       }
+
+survive:
+       /*
+       * If for any reason at all we couldn't handle the fault,
+       * make sure we exit gracefully rather than endlessly redo
+       * the fault.
+       */
+       fault = handle_mm_fault(mm, vma, address, write);
+       if (unlikely(fault & VM_FAULT_ERROR)) {
+               if (fault & VM_FAULT_OOM)
+                       goto out_of_memory;
+               else if (fault & VM_FAULT_SIGBUS)
+                       goto do_sigbus;
+               BUG();
+       }
+       if (fault & VM_FAULT_MAJOR)
+               tsk->maj_flt++;
+       else
+               tsk->min_flt++;
+
+       up_read(&mm->mmap_sem);
+       return;
+
+       /*
+       * Something tried to access memory that isn't in our memory map..
+       * Fix it, but check if it's kernel or user first..
+        */
+bad_area:
+       up_read(&mm->mmap_sem);
+
+bad_area_nosemaphore:
+       /* User mode accesses just cause a SIGSEGV */
+       if (user_mode(regs)) {
+               tsk->thread.cp0_badvaddr = address;
+               tsk->thread.error_code = write;
+               info.si_signo = SIGSEGV;
+               info.si_errno = 0;
+               /* info.si_code has been set above */
+               info.si_addr = (void __user *) address;
+               force_sig_info(SIGSEGV, &info, tsk);
+               return;
+       }
+
+no_context:
+       /* Are we prepared to handle this kernel fault? */
+       if (fixup_exception(regs)) {
+               current->thread.cp0_baduaddr = address;
+               return;
+       }
+
+       /*
+       * Oops. The kernel tried to access some bad page. We'll have to
+       * terminate things with extreme prejudice.
+       */
+       bust_spinlocks(1);
+
+       printk(KERN_ALERT "CPU %d Unable to handle kernel paging request 
at "
+                       "virtual address %0*lx, epc == %0*lx, ra == 
%0*lx\n",
+                       0, field, address, field, regs->cp0_epc,
+                       field, regs->regs[3]);
+       die("Oops", regs);
+
+       /*
+       * We ran out of memory, or some other thing happened to us that 
made
+       * us unable to handle the page fault gracefully.
+       */
+out_of_memory:
+       up_read(&mm->mmap_sem);
+       if (is_global_init(tsk)) {
+               yield();
+               down_read(&mm->mmap_sem);
+               goto survive;
+       }
+       printk("VM: killing process %s\n", tsk->comm);
+       if (user_mode(regs))
+               do_group_exit(SIGKILL);
+       goto no_context;
+
+do_sigbus:
+       up_read(&mm->mmap_sem);
+       /* Kernel mode? Handle exceptions or die */
+       if (!user_mode(regs))
+               goto no_context;
+       else
+       /*
+       * Send a sigbus, regardless of whether we were in kernel
+       * or user mode.
+       */
+       tsk->thread.cp0_badvaddr = address;
+       info.si_signo = SIGBUS;
+       info.si_errno = 0;
+       info.si_code = BUS_ADRERR;
+       info.si_addr = (void __user *) address;
+       force_sig_info(SIGBUS, &info, tsk);
+       return;
+vmalloc_fault:
+       {
+               /*
+               * Synchronize this task's top level page-table
+               * with the 'reference' page table.
+               *
+               * Do _not_ use "tsk" here. We might be inside
+               * an interrupt in the middle of a task switch..
+               */
+               int offset = __pgd_offset(address);
+               pgd_t *pgd, *pgd_k;
+               pud_t *pud, *pud_k;
+               pmd_t *pmd, *pmd_k;
+               pte_t *pte_k;
+
+               pgd = (pgd_t *) pgd_current + offset;
+               pgd_k = init_mm.pgd + offset;
+
+               if (!pgd_present(*pgd_k))
+                       goto no_context;
+               set_pgd(pgd, *pgd_k);
+
+               pud = pud_offset(pgd, address);
+               pud_k = pud_offset(pgd_k, address);
+               if (!pud_present(*pud_k))
+                       goto no_context;
+
+               pmd = pmd_offset(pud, address);
+               pmd_k = pmd_offset(pud_k, address);
+               if (!pmd_present(*pmd_k))
+                       goto no_context;
+               set_pmd(pmd, *pmd_k);
+
+               pte_k = pte_offset_kernel(pmd_k, address);
+               if (!pte_present(*pte_k))
+                       goto no_context;
+               return;
+       }
+}
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/mm/init.c 
linux-2.6-git.new/arch/score/mm/init.c
--- linux-2.6-git.ori/arch/score/mm/init.c      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/mm/init.c      2009-03-23 
14:30:53.000000000 +0800
@@ -0,0 +1,176 @@
+/*
+ * arch/score/mm/init.c
+ *
+ * Score Processor version.
+ *
+ * Copyright (C) 2009 Sunplus Core Technology Co., Ltd.
+ *  Lennox Wu <lennox.wu@sunplusct.com>
+ *  Chen Liqin <liqin.chen@sunplusct.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see the file COPYING, or write
+ * to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/init.h>
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/pagemap.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/bootmem.h>
+#include <linux/proc_fs.h>
+#include <linux/pfn.h>
+
+#include <asm/asm-offsets.h>
+#include <asm/sections.h>
+#include <asm/pgtable.h>
+#include <asm/tlb.h>
+
+DEFINE_PER_CPU(struct mmu_gather, mmu_gathers);
+
+/*
+ * We have up to 8 empty zeroed pages so we can map one of the right 
colour
+ * when needed.
+ */
+unsigned long empty_zero_page, zero_page_mask;
+EXPORT_SYMBOL_GPL(empty_zero_page);
+static struct kcore_list kcore_mem, kcore_vmalloc;
+
+unsigned long setup_zero_pages(void)
+{
+       unsigned int order = 0;
+       unsigned long size;
+       struct page *page;
+
+       empty_zero_page = __get_free_pages(GFP_KERNEL | __GFP_ZERO, 
order);
+       if (!empty_zero_page)
+               panic("Oh boy, that early out of memory?");
+
+       page = virt_to_page((void *) empty_zero_page);
+       split_page(page, order);
+       while (page < virt_to_page((void *) (empty_zero_page +
+                                            (PAGE_SIZE << order)))) {
+               SetPageReserved(page);
+               page++;
+       }
+
+       size = PAGE_SIZE << order;
+       zero_page_mask = (size - 1) & PAGE_MASK;
+
+       return 1UL << order;
+}
+
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+static int __init page_is_ram(unsigned long pagenr)
+{
+       if (pagenr >= min_low_pfn && pagenr < max_low_pfn)
+               return 1;
+       else
+               return 0;
+}
+
+void __init paging_init(void)
+{
+       unsigned long max_zone_pfns[MAX_NR_ZONES];
+       unsigned long lastpfn;
+
+       pagetable_init();
+       max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
+       lastpfn = max_low_pfn;
+       free_area_init_nodes(max_zone_pfns);
+}
+
+void __init mem_init(void)
+{
+       unsigned long codesize, reservedpages, datasize, initsize;
+       unsigned long tmp, ram;
+
+       max_mapnr = max_low_pfn;
+       high_memory = (void *) __va(max_low_pfn << PAGE_SHIFT);
+       totalram_pages += free_all_bootmem();
+       totalram_pages -= setup_zero_pages();   /* Setup zeroed pages. */
+       reservedpages = ram = 0;
+
+       for (tmp = 0; tmp < max_low_pfn; tmp++)
+               if (page_is_ram(tmp)) {
+                       ram++;
+                       if (PageReserved(pfn_to_page(tmp)))
+                               reservedpages++;
+               }
+
+       num_physpages = ram;
+       codesize = (unsigned long) &_etext - (unsigned long) &_text;
+       datasize = (unsigned long) &_edata - (unsigned long) &_etext;
+       initsize = (unsigned long) &__init_end - (unsigned long) 
&__init_begin;
+
+       kclist_add(&kcore_mem, __va(0), max_low_pfn << PAGE_SHIFT);
+       kclist_add(&kcore_vmalloc, (void *) VMALLOC_START,
+                       VMALLOC_END - VMALLOC_START);
+
+       printk(KERN_INFO "Memory: %luk/%luk available (%ldk kernel code, "
+                       "%ldk reserved, %ldk data, %ldk init, %ldk 
highmem)\n",
+                       (unsigned long) nr_free_pages() << 
(PAGE_SHIFT-10),
+                       ram << (PAGE_SHIFT-10), codesize >> 10,
+                       reservedpages << (PAGE_SHIFT-10), datasize >> 10,
+                       initsize >> 10,
+                       (unsigned long) (totalhigh_pages << 
(PAGE_SHIFT-10)));
+}
+#endif /* !CONFIG_NEED_MULTIPLE_NODES */
+
+void free_init_pages(const char *what, unsigned long begin, unsigned long 
end)
+{
+       unsigned long pfn;
+
+       for (pfn = PFN_UP(begin); pfn < PFN_DOWN(end); pfn++) {
+               struct page *page = pfn_to_page(pfn);
+               void *addr = phys_to_virt(PFN_PHYS(pfn));
+
+               ClearPageReserved(page);
+               init_page_count(page);
+               memset(addr, POISON_FREE_INITMEM, PAGE_SIZE);
+               __free_page(page);
+               totalram_pages++;
+       }
+       printk(KERN_INFO "Freeing %s: %ldk freed\n", what, (end - begin) 
>> 10);
+}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+void free_initrd_mem(unsigned long start, unsigned long end)
+{
+       free_init_pages("initrd memory",
+       virt_to_phys((void *) start),
+       virt_to_phys((void *) end));
+}
+#endif
+
+void __init_refok free_initmem(void)
+{
+       free_init_pages("unused kernel memory",
+       __pa_symbol(&__init_begin),
+       __pa_symbol(&__init_end));
+}
+
+unsigned long pgd_current;
+
+#define __page_aligned(order) 
__attribute__((__aligned__(PAGE_SIZE<<order)))
+
+/*
+ * gcc 3.3 and older have trouble determining that PTRS_PER_PGD and 
PGD_ORDER
+ * are constants.  So we use the variants from asm-offset.h until that 
gcc
+ * will officially be retired.
+ */
+pgd_t swapper_pg_dir[_PTRS_PER_PGD] __page_aligned(_PGD_ORDER);
+pte_t invalid_pte_table[PTRS_PER_PTE] __page_aligned(PTE_ORDER);

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
