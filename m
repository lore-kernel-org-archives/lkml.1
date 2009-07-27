Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZG0GsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZG0GsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 02:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbZG0GsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 02:48:19 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57355 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbZG0GsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 02:48:17 -0400
Message-ID: <4A6D4D9F.9080402@monstr.eu>
Date: Mon, 27 Jul 2009 08:47:59 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.31-rc5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes.

Thanks,
Michal


The following changes since commit 4be3bd7849165e7efa6b0b35a23d6a3598d97465:
  Linus Torvalds (1):
        Linux 2.6.31-rc4

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git fixes-for-linus

Arnd Bergmann (1):
      microblaze: remove sys_ipc

Huang Weiyi (1):
      microblaze: remove duplicated #include

John Williams (2):
      microblaze: Final support for statically linked DTB
      microblaze: Get module loading working

Michal Simek (12):
      microblaze: Define tlb_flush macro
      microblaze: Add messages about FDT blob
      microblaze: Not to clear r7 after copying DTB to kernel
      microblaze: Clear print messages for DTB passing via r7
      microblaze: Fix put_user macro for 64bits arguments
      microblaze: Add _PAGE_FILE macros to pgtable.h
      microblaze: Fix do_page_fault for no context
      microblaze: Detect new Microblaze 7.20 versions
      microblaze: Export memcpy, memmove for ASM optimized code
      microblaze: Support unaligned address for put/get_user macros
      microblaze: Add support for R_MICROBLAZE_64_NONE
      microblaze: Typo fix for cpu param inconsistency

Sam Ravnborg (1):
      microblaze: Makefile cleanup

 arch/microblaze/Makefile                      |   35 ++++----
 arch/microblaze/include/asm/io.h              |    1 -
 arch/microblaze/include/asm/pgtable.h         |    6 +-
 arch/microblaze/include/asm/prom.h            |   23 +++---
 arch/microblaze/include/asm/tlb.h             |    2 +-
 arch/microblaze/include/asm/uaccess.h         |    2 +-
 arch/microblaze/kernel/Makefile               |    2 +-
 arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c |    2 +-
 arch/microblaze/kernel/cpu/cpuinfo-static.c   |    2 +-
 arch/microblaze/kernel/cpu/cpuinfo.c          |    2 +
 arch/microblaze/kernel/head.S                 |   17 +++-
 arch/microblaze/kernel/hw_exception_handler.S |  109
+++++++++++--------------
 arch/microblaze/kernel/microblaze_ksyms.c     |    7 ++
 arch/microblaze/kernel/module.c               |   19 +++-
 arch/microblaze/kernel/setup.c                |    8 ++-
 arch/microblaze/kernel/sys_microblaze.c       |   99 ----------------------
 arch/microblaze/kernel/syscall_table.S        |    2 +-
 arch/microblaze/mm/fault.c                    |   15 +---
 18 files changed, 133 insertions(+), 220 deletions(-)




diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index d0bcf80..8439598 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -6,14 +6,16 @@ endif

 # What CPU vesion are we building for, and crack it open
 # as major.minor.rev
-CPU_VER=$(subst ",,$(CONFIG_XILINX_MICROBLAZE0_HW_VER) )
-CPU_MAJOR=$(shell echo $(CPU_VER) | cut -d '.' -f 1)
-CPU_MINOR=$(shell echo $(CPU_VER) | cut -d '.' -f 2)
-CPU_REV=$(shell echo $(CPU_VER) | cut -d '.' -f 3)
+CPU_VER   := $(shell echo $(CONFIG_XILINX_MICROBLAZE0_HW_VER))
+CPU_MAJOR := $(shell echo $(CPU_VER) | cut -d '.' -f 1)
+CPU_MINOR := $(shell echo $(CPU_VER) | cut -d '.' -f 2)
+CPU_REV   := $(shell echo $(CPU_VER) | cut -d '.' -f 3)

 export CPU_VER CPU_MAJOR CPU_MINOR CPU_REV

 # Use cpu-related CONFIG_ vars to set compile options.
+# The various CONFIG_XILINX cpu features options are integers 0/1/2...
+# rather than bools y/n

 # Work out HW multipler support.  This is icky.
 # 1. Spartan2 has no HW multiplers.
@@ -34,30 +36,29 @@ CPUFLAGS-$(CONFIG_XILINX_MICROBLAZE0_USE_PCMP_INSTR)
+= -mxl-pattern-compare

 CPUFLAGS-1 += $(call cc-option,-mcpu=v$(CPU_VER))

-# The various CONFIG_XILINX cpu features options are integers 0/1/2...
-# rather than bools y/n
-
 # r31 holds current when in kernel mode
-CFLAGS_KERNEL += -ffixed-r31 $(CPUFLAGS-1) $(CPUFLAGS-2)
+KBUILD_KERNEL += -ffixed-r31 $(CPUFLAGS-1) $(CPUFLAGS-2)

 LDFLAGS        :=
 LDFLAGS_vmlinux    :=
-LDFLAGS_BLOB := --format binary --oformat elf32-microblaze

-LIBGCC := $(shell $(CC) $(CFLAGS_KERNEL) -print-libgcc-file-name)
+LIBGCC := $(shell $(CC) $(KBUILD_KERNEL) -print-libgcc-file-name)

-head-y        := arch/microblaze/kernel/head.o
-libs-y        += arch/microblaze/lib/ $(LIBGCC)
-core-y        += arch/microblaze/kernel/ arch/microblaze/mm/ \
-           arch/microblaze/platform/
+head-y := arch/microblaze/kernel/head.o
+libs-y += arch/microblaze/lib/
+libs-y += $(LIBGCC)
+core-y += arch/microblaze/kernel/
+core-y += arch/microblaze/mm/
+core-y += arch/microblaze/platform/

-boot := arch/$(ARCH)/boot
+boot := arch/microblaze/boot

 # defines filename extension depending memory management type
 ifeq ($(CONFIG_MMU),)
-MMUEXT        := -nommu
+MMU := -nommu
 endif
-export    MMUEXT
+
+export MMU

 all: linux.bin

diff --git a/arch/microblaze/include/asm/io.h
b/arch/microblaze/include/asm/io.h
index 5c17342..7c3ec13 100644
--- a/arch/microblaze/include/asm/io.h
+++ b/arch/microblaze/include/asm/io.h
@@ -14,7 +14,6 @@
 #include <asm/byteorder.h>
 #include <asm/page.h>
 #include <linux/types.h>
-#include <asm/byteorder.h>
 #include <linux/mm.h>          /* Get struct page {...} */


diff --git a/arch/microblaze/include/asm/pgtable.h
b/arch/microblaze/include/asm/pgtable.h
index 4c57a58..cc3a4df 100644
--- a/arch/microblaze/include/asm/pgtable.h
+++ b/arch/microblaze/include/asm/pgtable.h
@@ -185,6 +185,7 @@ static inline pte_t pte_mkspecial(pte_t pte)    {
return pte; }

 /* Definitions for MicroBlaze. */
 #define    _PAGE_GUARDED    0x001    /* G: page is guarded from prefetch */
+#define _PAGE_FILE    0x001    /* when !present: nonlinear file mapping */
 #define _PAGE_PRESENT    0x002    /* software: PTE contains a
translation */
 #define    _PAGE_NO_CACHE    0x004    /* I: caching is inhibited */
 #define    _PAGE_WRITETHRU    0x008    /* W: caching is write-through */
@@ -320,8 +321,7 @@ static inline int pte_write(pte_t pte) { return
pte_val(pte) & _PAGE_RW; }
 static inline int pte_exec(pte_t pte)  { return pte_val(pte) &
_PAGE_EXEC; }
 static inline int pte_dirty(pte_t pte) { return pte_val(pte) &
_PAGE_DIRTY; }
 static inline int pte_young(pte_t pte) { return pte_val(pte) &
_PAGE_ACCESSED; }
-/* FIXME */
-static inline int pte_file(pte_t pte)        { return 0; }
+static inline int pte_file(pte_t pte)  { return pte_val(pte) &
_PAGE_FILE; }

 static inline void pte_uncache(pte_t pte) { pte_val(pte) |=
_PAGE_NO_CACHE; }
 static inline void pte_cache(pte_t pte)   { pte_val(pte) &=
~_PAGE_NO_CACHE; }
@@ -488,7 +488,7 @@ static inline pmd_t *pmd_offset(pgd_t *dir, unsigned
long address)
 /* Encode and decode a nonlinear file mapping entry */
 #define PTE_FILE_MAX_BITS    29
 #define pte_to_pgoff(pte)    (pte_val(pte) >> 3)
-#define pgoff_to_pte(off)    ((pte_t) { ((off) << 3) })
+#define pgoff_to_pte(off)    ((pte_t) { ((off) << 3) | _PAGE_FILE })

 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];

diff --git a/arch/microblaze/include/asm/prom.h
b/arch/microblaze/include/asm/prom.h
index 20f7b3a..37e6f30 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -16,6 +16,18 @@
 #define _ASM_MICROBLAZE_PROM_H
 #ifdef __KERNEL__

+/* Definitions used by the flattened device tree */
+#define OF_DT_HEADER        0xd00dfeed /* marker */
+#define OF_DT_BEGIN_NODE    0x1 /* Start of node, full name */
+#define OF_DT_END_NODE        0x2 /* End node */
+#define OF_DT_PROP        0x3 /* Property: name off, size, content */
+#define OF_DT_NOP        0x4 /* nop */
+#define OF_DT_END        0x9
+
+#define OF_DT_VERSION        0x10
+
+#ifndef __ASSEMBLY__
+
 #include <linux/types.h>
 #include <linux/proc_fs.h>
 #include <linux/platform_device.h>
@@ -29,16 +41,6 @@
 #define of_prop_cmp(s1, s2)        strcmp((s1), (s2))
 #define of_node_cmp(s1, s2)        strcasecmp((s1), (s2))

-/* Definitions used by the flattened device tree */
-#define OF_DT_HEADER        0xd00dfeed /* marker */
-#define OF_DT_BEGIN_NODE    0x1 /* Start of node, full name */
-#define OF_DT_END_NODE        0x2 /* End node */
-#define OF_DT_PROP        0x3 /* Property: name off, size, content */
-#define OF_DT_NOP        0x4 /* nop */
-#define OF_DT_END        0x9
-
-#define OF_DT_VERSION        0x10
-
 /*
  * This is what gets passed to the kernel by prom_init or kexec
  *
@@ -309,5 +311,6 @@ extern void __iomem *of_iomap(struct device_node
*device, int index);
  */
 #include <linux/of.h>

+#endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _ASM_MICROBLAZE_PROM_H */
diff --git a/arch/microblaze/include/asm/tlb.h
b/arch/microblaze/include/asm/tlb.h
index c472d28..e8abd4a 100644
--- a/arch/microblaze/include/asm/tlb.h
+++ b/arch/microblaze/include/asm/tlb.h
@@ -11,7 +11,7 @@
 #ifndef _ASM_MICROBLAZE_TLB_H
 #define _ASM_MICROBLAZE_TLB_H

-#define tlb_flush(tlb)    do {} while (0)
+#define tlb_flush(tlb)    flush_tlb_mm((tlb)->mm)

 #include <asm-generic/tlb.h>

diff --git a/arch/microblaze/include/asm/uaccess.h
b/arch/microblaze/include/asm/uaccess.h
index 65adad6..5431b46 100644
--- a/arch/microblaze/include/asm/uaccess.h
+++ b/arch/microblaze/include/asm/uaccess.h
@@ -189,7 +189,7 @@ extern long strnlen_user(const char *src, long count);

 #define __put_user(x, ptr)                        \
 ({                                    \
-    __typeof__(*(ptr)) __gu_val = x;                \
+    __typeof__(*(ptr)) volatile __gu_val = (x);            \
     long __gu_err = 0;                        \
     switch (sizeof(__gu_val)) {                    \
     case 1:                                \
diff --git a/arch/microblaze/kernel/Makefile
b/arch/microblaze/kernel/Makefile
index f4a5e19..d487729 100644
--- a/arch/microblaze/kernel/Makefile
+++ b/arch/microblaze/kernel/Makefile
@@ -17,4 +17,4 @@ obj-$(CONFIG_HEART_BEAT)    += heartbeat.o
 obj-$(CONFIG_MODULES)        += microblaze_ksyms.o module.o
 obj-$(CONFIG_MMU)        += misc.o

-obj-y    += entry$(MMUEXT).o
+obj-y    += entry$(MMU).o
diff --git a/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
b/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
index 153f57c..c259786 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo-pvr-full.c
@@ -22,7 +22,7 @@

 #define CI(c, p) { ci->c = PVR_##p(pvr); }
 #define err_printk(x) \
-    early_printk("ERROR: Microblaze " x " - different for PVR and DTS\n");
+    early_printk("ERROR: Microblaze " x "-different for PVR and DTS\n");

 void set_cpuinfo_pvr_full(struct cpuinfo *ci, struct device_node *cpu)
 {
diff --git a/arch/microblaze/kernel/cpu/cpuinfo-static.c
b/arch/microblaze/kernel/cpu/cpuinfo-static.c
index 450ca6b..adb448f 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo-static.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo-static.c
@@ -18,7 +18,7 @@ static const char family_string[] =
CONFIG_XILINX_MICROBLAZE0_FAMILY;
 static const char cpu_ver_string[] = CONFIG_XILINX_MICROBLAZE0_HW_VER;

 #define err_printk(x) \
-    early_printk("ERROR: Microblaze " x "- different for kernel and
DTS\n");
+    early_printk("ERROR: Microblaze " x "-different for kernel and DTS\n");

 void __init set_cpuinfo_static(struct cpuinfo *ci, struct device_node *cpu)
 {
diff --git a/arch/microblaze/kernel/cpu/cpuinfo.c
b/arch/microblaze/kernel/cpu/cpuinfo.c
index a10bea1..c411c67 100644
--- a/arch/microblaze/kernel/cpu/cpuinfo.c
+++ b/arch/microblaze/kernel/cpu/cpuinfo.c
@@ -26,6 +26,8 @@ const struct cpu_ver_key cpu_ver_lookup[] = {
     {"7.10.b", 0x09},
     {"7.10.c", 0x0a},
     {"7.10.d", 0x0b},
+    {"7.20.a", 0x0c},
+    {"7.20.b", 0x0d},
     /* FIXME There is no keycode defined in MBV for these versions */
     {"2.10.a", 0x10},
     {"3.00.a", 0x20},
diff --git a/arch/microblaze/kernel/head.S b/arch/microblaze/kernel/head.S
index e568d6e..e41c6ce 100644
--- a/arch/microblaze/kernel/head.S
+++ b/arch/microblaze/kernel/head.S
@@ -31,6 +31,7 @@
 #include <linux/linkage.h>
 #include <asm/thread_info.h>
 #include <asm/page.h>
+#include <asm/prom.h>        /* for OF_DT_HEADER */

 #ifdef CONFIG_MMU
 #include <asm/setup.h> /* COMMAND_LINE_SIZE */
@@ -54,11 +55,19 @@ ENTRY(_start)
     andi    r1, r1, ~2
     mts    rmsr, r1

-/* save fdt to kernel location */
-/* r7 stores pointer to fdt blob */
-    beqi    r7, no_fdt_arg
+/* r7 may point to an FDT, or there may be one linked in.
+   if it's in r7, we've got to save it away ASAP.
+   We ensure r7 points to a valid FDT, just in case the bootloader
+   is broken or non-existent */
+    beqi    r7, no_fdt_arg            /* NULL pointer?  don't copy */
+    lw    r11, r0, r7            /* Does r7 point to a */
+    rsubi    r11, r11, OF_DT_HEADER        /* valid FDT? */
+    beqi    r11, _prepare_copy_fdt
+    or    r7, r0, r0        /* clear R7 when not valid DTB */
+    bnei    r11, no_fdt_arg            /* No - get out of here */
+_prepare_copy_fdt:
     or    r11, r0, r0 /* incremment */
-    ori    r4, r0, TOPHYS(_fdt_start) /* save bram context */
+    ori    r4, r0, TOPHYS(_fdt_start)
     ori    r3, r0, (0x4000 - 4)
 _copy_fdt:
     lw    r12, r7, r11 /* r12 = r7 + r11 */
diff --git a/arch/microblaze/kernel/hw_exception_handler.S
b/arch/microblaze/kernel/hw_exception_handler.S
index 9d591cd..3288c97 100644
--- a/arch/microblaze/kernel/hw_exception_handler.S
+++ b/arch/microblaze/kernel/hw_exception_handler.S
@@ -74,6 +74,7 @@

 #include <asm/mmu.h>
 #include <asm/pgtable.h>
+#include <asm/signal.h>
 #include <asm/asm-offsets.h>

 /* Helpful Macros */
@@ -428,19 +429,9 @@ handle_unaligned_ex:
     mfs    r17, rbtr;    /* ESR[DS] set - return address in BTR */
     nop
 _no_delayslot:
-#endif
-
-#ifdef CONFIG_MMU
-    /* Check if unaligned address is last on a 4k page */
-        andi    r5, r4, 0xffc
-        xori    r5, r5, 0xffc
-        bnei    r5, _unaligned_ex2
-    _unaligned_ex1:
-        RESTORE_STATE;
-/* Another page must be accessed or physical address not in page table */
-        bri    unaligned_data_trap
-
-    _unaligned_ex2:
+    /* jump to high level unaligned handler */
+    RESTORE_STATE;
+    bri    unaligned_data_trap
 #endif
     andi    r6, r3, 0x3E0; /* Mask and extract the register operand */
     srl    r6, r6; /* r6 >> 5 */
@@ -450,45 +441,6 @@ _no_delayslot:
     srl    r6, r6;
     /* Store the register operand in a temporary location */
     sbi    r6, r0, TOPHYS(ex_reg_op);
-#ifdef CONFIG_MMU
-    /* Get physical address */
-    /* If we are faulting a kernel address, we have to use the
-     * kernel page tables.
-     */
-    ori    r5, r0, CONFIG_KERNEL_START
-    cmpu    r5, r4, r5
-    bgti    r5, _unaligned_ex3
-    ori    r5, r0, swapper_pg_dir
-    bri    _unaligned_ex4
-
-    /* Get the PGD for the current thread. */
-_unaligned_ex3: /* user thread */
-    addi    r5 ,CURRENT_TASK, TOPHYS(0); /* get current task address */
-    lwi    r5, r5, TASK_THREAD + PGDIR
-_unaligned_ex4:
-    tophys(r5,r5)
-    BSRLI(r6,r4,20)            /* Create L1 (pgdir/pmd) address */
-    andi    r6, r6, 0xffc
-/* Assume pgdir aligned on 4K boundary, no need for "andi
r5,r5,0xfffff003" */
-    or    r5, r5, r6
-    lwi    r6, r5, 0        /* Get L1 entry */
-    andi    r5, r6, 0xfffff000    /* Extract L2 (pte) base address. */
-    beqi    r5, _unaligned_ex1    /* Bail if no table */
-
-    tophys(r5,r5)
-    BSRLI(r6,r4,10)            /* Compute PTE address */
-    andi    r6, r6, 0xffc
-    andi    r5, r5, 0xfffff003
-    or    r5, r5, r6
-    lwi    r5, r5, 0        /* Get Linux PTE */
-
-    andi    r6, r5, _PAGE_PRESENT
-    beqi    r6, _unaligned_ex1    /* Bail if no page */
-
-    andi    r5, r5, 0xfffff000    /* Extract RPN */
-    andi    r4, r4, 0x00000fff    /* Extract offset */
-    or    r4, r4, r5        /* Create physical address */
-#endif /* CONFIG_MMU */

     andi    r6, r3, 0x400; /* Extract ESR[S] */
     bnei    r6, ex_sw;
@@ -959,15 +911,15 @@ _unaligned_data_exception:
     andi    r6, r3, 0x800;    /* Extract ESR[W] - delay slot */
 ex_lw_vm:
     beqid    r6, ex_lhw_vm;
-    lbui    r5, r4, 0;    /* Exception address in r4 - delay slot */
+load1:    lbui    r5, r4, 0;    /* Exception address in r4 - delay slot */
 /* Load a word, byte-by-byte from destination address and save it in
tmp space*/
     la    r6, r0, ex_tmp_data_loc_0;
     sbi    r5, r6, 0;
-    lbui    r5, r4, 1;
+load2:    lbui    r5, r4, 1;
     sbi    r5, r6, 1;
-    lbui    r5, r4, 2;
+load3:    lbui    r5, r4, 2;
     sbi    r5, r6, 2;
-    lbui    r5, r4, 3;
+load4:    lbui    r5, r4, 3;
     sbi    r5, r6, 3;
     brid    ex_lw_tail_vm;
 /* Get the destination register value into r3 - delay slot */
@@ -977,7 +929,7 @@ ex_lhw_vm:
      * save it in tmp space */
     la    r6, r0, ex_tmp_data_loc_0;
     sbi    r5, r6, 0;
-    lbui    r5, r4, 1;
+load5:    lbui    r5, r4, 1;
     sbi    r5, r6, 1;
     lhui    r3, r6, 0;    /* Get the destination register value into r3 */
 ex_lw_tail_vm:
@@ -996,22 +948,53 @@ ex_sw_tail_vm:
     swi    r3, r5, 0;    /* Get the word - delay slot */
     /* Store the word, byte-by-byte into destination address */
     lbui    r3, r5, 0;
-    sbi    r3, r4, 0;
+store1:    sbi    r3, r4, 0;
     lbui    r3, r5, 1;
-    sbi    r3, r4, 1;
+store2:    sbi    r3, r4, 1;
     lbui    r3, r5, 2;
-    sbi    r3, r4, 2;
+store3:    sbi    r3, r4, 2;
     lbui    r3, r5, 3;
     brid    ret_from_exc;
-    sbi    r3, r4, 3;    /* Delay slot */
+store4:    sbi    r3, r4, 3;    /* Delay slot */
 ex_shw_vm:
     /* Store the lower half-word, byte-by-byte into destination address */
     lbui    r3, r5, 2;
-    sbi    r3, r4, 0;
+store5:    sbi    r3, r4, 0;
     lbui    r3, r5, 3;
     brid    ret_from_exc;
-    sbi    r3, r4, 1;    /* Delay slot */
+store6:    sbi    r3, r4, 1;    /* Delay slot */
 ex_sw_end_vm:            /* Exception handling of store word, ends. */
+
+/* We have to prevent cases that get/put_user macros get unaligned pointer
+ * to bad page area. We have to find out which origin instruction caused it
+ * and called fixup for that origin instruction not instruction in
unaligned
+ * handler */
+ex_unaligned_fixup:
+    ori    r5, r7, 0 /* setup pointer to pt_regs */
+    lwi    r6, r7, PT_PC; /* faulting address is one instruction above */
+    addik    r6, r6, -4 /* for finding proper fixup */
+    swi    r6, r7, PT_PC; /* a save back it to PT_PC */
+    addik    r7, r0, SIGSEGV
+    /* call bad_page_fault for finding aligned fixup, fixup address is
saved
+     * in PT_PC which is used as return address from exception */
+    la    r15, r0, ret_from_exc-8 /* setup return address */
+    brid    bad_page_fault
+    nop
+
+/* We prevent all load/store because it could failed any attempt to
access */
+.section __ex_table,"a";
+    .word    load1,ex_unaligned_fixup;
+    .word    load2,ex_unaligned_fixup;
+    .word    load3,ex_unaligned_fixup;
+    .word    load4,ex_unaligned_fixup;
+    .word    load5,ex_unaligned_fixup;
+    .word    store1,ex_unaligned_fixup;
+    .word    store2,ex_unaligned_fixup;
+    .word    store3,ex_unaligned_fixup;
+    .word    store4,ex_unaligned_fixup;
+    .word    store5,ex_unaligned_fixup;
+    .word    store6,ex_unaligned_fixup;
+.previous;
 .end _unaligned_data_exception
 #endif /* CONFIG_MMU */

diff --git a/arch/microblaze/kernel/module.c
b/arch/microblaze/kernel/module.c
index 5141417..5a45b1a 100644
--- a/arch/microblaze/kernel/module.c
+++ b/arch/microblaze/kernel/module.c
@@ -57,7 +57,6 @@ int apply_relocate_add(Elf32_Shdr *sechdrs, const char
*strtab,
     Elf32_Rela *rela = (void *)sechdrs[relsec].sh_addr;
     Elf32_Sym *sym;
     unsigned long int *location;
-    unsigned long int locoffs;
     unsigned long int value;
 #if __GNUC__ < 4
     unsigned long int old_value;
@@ -113,10 +112,12 @@ int apply_relocate_add(Elf32_Shdr *sechdrs, const
char *strtab,
             break;

         case R_MICROBLAZE_64_PCREL:
-            locoffs = (location[0] & 0xFFFF) << 16 |
+#if __GNUC__ < 4
+            old_value = (location[0] & 0xFFFF) << 16 |
                 (location[1] & 0xFFFF);
-            value -= (unsigned long int)(location) + 4 +
-                locoffs;
+            value -= old_value;
+#endif
+            value -= (unsigned long int)(location) + 4;
             location[0] = (location[0] & 0xFFFF0000) |
                     (value >> 16);
             location[1] = (location[1] & 0xFFFF0000) |
@@ -125,6 +126,14 @@ int apply_relocate_add(Elf32_Shdr *sechdrs, const
char *strtab,
                 value);
             break;

+        case R_MICROBLAZE_32_PCREL_LO:
+            pr_debug("R_MICROBLAZE_32_PCREL_LO\n");
+            break;
+
+        case R_MICROBLAZE_64_NONE:
+            pr_debug("R_MICROBLAZE_NONE\n");
+            break;
+
         case R_MICROBLAZE_NONE:
             pr_debug("R_MICROBLAZE_NONE\n");
             break;
@@ -133,7 +142,7 @@ int apply_relocate_add(Elf32_Shdr *sechdrs, const
char *strtab,
             printk(KERN_ERR "module %s: "
                 "Unknown relocation: %u\n",
                 module->name,
-                ELF32_R_TYPE(rela->r_info));
+                ELF32_R_TYPE(rela[i].r_info));
             return -ENOEXEC;
         }
     }
diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
index 8709bea..2a97bf5 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -138,8 +138,12 @@ void __init machine_early_init(const char *cmdline,
unsigned int ram,
     setup_early_printk(NULL);
 #endif

-    early_printk("Ramdisk addr 0x%08x, FDT 0x%08x\n", ram, fdt);
-    printk(KERN_NOTICE "Found FDT at 0x%08x\n", fdt);
+    early_printk("Ramdisk addr 0x%08x, ", ram);
+    if (fdt)
+        early_printk("FDT at 0x%08x\n", fdt);
+    else
+        early_printk("Compiled-in FDT at 0x%08x\n",
+                    (unsigned int)_fdt_start);

 #ifdef CONFIG_MTD_UCLINUX
     early_printk("Found romfs @ 0x%08x (0x%08x)\n",
diff --git a/arch/microblaze/kernel/sys_microblaze.c
b/arch/microblaze/kernel/sys_microblaze.c
index e000bce..b96f168 100644
--- a/arch/microblaze/kernel/sys_microblaze.c
+++ b/arch/microblaze/kernel/sys_microblaze.c
@@ -33,105 +33,6 @@
 #include <linux/unistd.h>

 #include <asm/syscalls.h>
-/*
- * sys_ipc() is the de-multiplexer for the SysV IPC calls..
- *
- * This is really horribly ugly. This will be remove with new toolchain.
- */
-asmlinkage long
-sys_ipc(uint call, int first, int second, int third, void *ptr, long fifth)
-{
-    int version, ret;
-
-    version = call >> 16; /* hack for backward compatibility */
-    call &= 0xffff;
-
-    ret = -EINVAL;
-    switch (call) {
-    case SEMOP:
-        ret = sys_semop(first, (struct sembuf *)ptr, second);
-        break;
-    case SEMGET:
-        ret = sys_semget(first, second, third);
-        break;
-    case SEMCTL:
-    {
-        union semun fourth;
-
-        if (!ptr)
-            break;
-        ret = (access_ok(VERIFY_READ, ptr, sizeof(long)) ? 0 : -EFAULT)
-                || (get_user(fourth.__pad, (void **)ptr)) ;
-        if (ret)
-            break;
-        ret = sys_semctl(first, second, third, fourth);
-        break;
-    }
-    case MSGSND:
-        ret = sys_msgsnd(first, (struct msgbuf *) ptr, second, third);
-        break;
-    case MSGRCV:
-        switch (version) {
-        case 0: {
-            struct ipc_kludge tmp;
-
-            if (!ptr)
-                break;
-            ret = (access_ok(VERIFY_READ, ptr, sizeof(tmp))
-                ? 0 : -EFAULT) || copy_from_user(&tmp,
-                (struct ipc_kludge *) ptr, sizeof(tmp));
-            if (ret)
-                break;
-            ret = sys_msgrcv(first, tmp.msgp, second, tmp.msgtyp,
-                    third);
-            break;
-            }
-        default:
-            ret = sys_msgrcv(first, (struct msgbuf *) ptr,
-                    second, fifth, third);
-            break;
-        }
-        break;
-    case MSGGET:
-        ret = sys_msgget((key_t) first, second);
-        break;
-    case MSGCTL:
-        ret = sys_msgctl(first, second, (struct msqid_ds *) ptr);
-        break;
-    case SHMAT:
-        switch (version) {
-        default: {
-            ulong raddr;
-            ret = access_ok(VERIFY_WRITE, (ulong *) third,
-                    sizeof(ulong)) ? 0 : -EFAULT;
-            if (ret)
-                break;
-            ret = do_shmat(first, (char *) ptr, second, &raddr);
-            if (ret)
-                break;
-            ret = put_user(raddr, (ulong *) third);
-            break;
-            }
-        case 1:    /* iBCS2 emulator entry point */
-            if (!segment_eq(get_fs(), get_ds()))
-                break;
-            ret = do_shmat(first, (char *) ptr, second,
-                    (ulong *) third);
-            break;
-        }
-        break;
-    case SHMDT:
-        ret = sys_shmdt((char *)ptr);
-        break;
-    case SHMGET:
-        ret = sys_shmget(first, second, third);
-        break;
-    case SHMCTL:
-        ret = sys_shmctl(first, second, (struct shmid_ds *) ptr);
-        break;
-    }
-    return ret;
-}

 asmlinkage long microblaze_vfork(struct pt_regs *regs)
 {
diff --git a/arch/microblaze/kernel/syscall_table.S
b/arch/microblaze/kernel/syscall_table.S
index 31b32a6..216db81 100644
--- a/arch/microblaze/kernel/syscall_table.S
+++ b/arch/microblaze/kernel/syscall_table.S
@@ -121,7 +121,7 @@ ENTRY(sys_call_table)
     .long sys_wait4
     .long sys_swapoff        /* 115 */
     .long sys_sysinfo
-    .long sys_ipc
+    .long sys_ni_syscall        /* old sys_ipc */
     .long sys_fsync
     .long sys_ni_syscall        /* sys_sigreturn_wrapper */
     .long sys_clone        /* 120 */
diff --git a/arch/microblaze/mm/fault.c b/arch/microblaze/mm/fault.c
index 956607a..d9d249a 100644
--- a/arch/microblaze/mm/fault.c
+++ b/arch/microblaze/mm/fault.c
@@ -69,7 +69,7 @@ static int store_updates_sp(struct pt_regs *regs)
  * It is called from do_page_fault above and from some of the procedures
  * in traps.c.
  */
-static void bad_page_fault(struct pt_regs *regs, unsigned long address,
int sig)
+void bad_page_fault(struct pt_regs *regs, unsigned long address, int sig)
 {
     const struct exception_table_entry *fixup;
 /* MS: no context */
@@ -122,15 +122,10 @@ void do_page_fault(struct pt_regs *regs, unsigned
long address,
     }
 #endif /* CONFIG_KGDB */

-    if (in_atomic() || mm == NULL) {
-        /* FIXME */
-        if (kernel_mode(regs)) {
-            printk(KERN_EMERG
-                "Page fault in kernel mode - Oooou!!! pid %d\n",
-                current->pid);
-            _exception(SIGSEGV, regs, code, address);
-            return;
-        }
+    if (in_atomic() || !mm) {
+        if (kernel_mode(regs))
+            goto bad_area_nosemaphore;
+
         /* in_atomic() in user mode is really bad,
            as is current->mm == NULL. */
         printk(KERN_EMERG "Page fault in user mode with "



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854


