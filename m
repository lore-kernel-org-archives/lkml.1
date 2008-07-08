Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbYGHXd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbYGHXd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbYGHXPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:33 -0400
Received: from gw.goop.org ([64.81.55.164]:51210 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849AbYGHXOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:41 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 12 of 55] xen64: define asm/xen/interface for 64-bit
X-Mercurial-Node: b7292ebdbc785cc0542b7abf2448340b54972e8c
Message-Id: <b7292ebdbc785cc0542b.1215554794@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy 64-bit definitions of various interface structures into place.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.h                 |   12 --
 include/asm-x86/xen/interface.h    |  139 +++++++++++--------------------
 include/asm-x86/xen/interface_32.h |   97 +++++++++++++++++++++
 include/asm-x86/xen/interface_64.h |  159 ++++++++++++++++++++++++++++++++++++
 include/xen/interface/callback.h   |    6 -
 5 files changed, 308 insertions(+), 105 deletions(-)

diff --git a/arch/x86/xen/mmu.h b/arch/x86/xen/mmu.h
--- a/arch/x86/xen/mmu.h
+++ b/arch/x86/xen/mmu.h
@@ -9,18 +9,6 @@
 	PT_PMD,
 	PT_PTE
 };
-
-/*
- * Page-directory addresses above 4GB do not fit into architectural %cr3.
- * When accessing %cr3, or equivalent field in vcpu_guest_context, guests
- * must use the following accessor macros to pack/unpack valid MFNs.
- *
- * Note that Xen is using the fact that the pagetable base is always
- * page-aligned, and putting the 12 MSB of the address into the 12 LSB
- * of cr3.
- */
-#define xen_pfn_to_cr3(pfn) (((unsigned)(pfn) << 12) | ((unsigned)(pfn) >> 20))
-#define xen_cr3_to_pfn(cr3) (((unsigned)(cr3) >> 12) | ((unsigned)(cr3) << 20))
 
 
 void set_pte_mfn(unsigned long vaddr, unsigned long pfn, pgprot_t flags);
diff --git a/include/asm-x86/xen/interface.h b/include/asm-x86/xen/interface.h
--- a/include/asm-x86/xen/interface.h
+++ b/include/asm-x86/xen/interface.h
@@ -1,13 +1,13 @@
 /******************************************************************************
  * arch-x86_32.h
  *
- * Guest OS interface to x86 32-bit Xen.
+ * Guest OS interface to x86 Xen.
  *
  * Copyright (c) 2004, K A Fraser
  */
 
-#ifndef __XEN_PUBLIC_ARCH_X86_32_H__
-#define __XEN_PUBLIC_ARCH_X86_32_H__
+#ifndef __ASM_X86_XEN_INTERFACE_H
+#define __ASM_X86_XEN_INTERFACE_H
 
 #ifdef __XEN__
 #define __DEFINE_GUEST_HANDLE(name, type) \
@@ -57,6 +57,17 @@
 DEFINE_GUEST_HANDLE(void);
 #endif
 
+#ifndef HYPERVISOR_VIRT_START
+#define HYPERVISOR_VIRT_START mk_unsigned_long(__HYPERVISOR_VIRT_START)
+#endif
+
+#ifndef machine_to_phys_mapping
+#define machine_to_phys_mapping ((unsigned long *)HYPERVISOR_VIRT_START)
+#endif
+
+/* Maximum number of virtual CPUs in multi-processor guests. */
+#define MAX_VIRT_CPUS 32
+
 /*
  * SEGMENT DESCRIPTOR TABLES
  */
@@ -71,58 +82,21 @@
 #define FIRST_RESERVED_GDT_ENTRY (FIRST_RESERVED_GDT_BYTE / 8)
 
 /*
- * These flat segments are in the Xen-private section of every GDT. Since these
- * are also present in the initial GDT, many OSes will be able to avoid
- * installing their own GDT.
- */
-#define FLAT_RING1_CS 0xe019    /* GDT index 259 */
-#define FLAT_RING1_DS 0xe021    /* GDT index 260 */
-#define FLAT_RING1_SS 0xe021    /* GDT index 260 */
-#define FLAT_RING3_CS 0xe02b    /* GDT index 261 */
-#define FLAT_RING3_DS 0xe033    /* GDT index 262 */
-#define FLAT_RING3_SS 0xe033    /* GDT index 262 */
-
-#define FLAT_KERNEL_CS FLAT_RING1_CS
-#define FLAT_KERNEL_DS FLAT_RING1_DS
-#define FLAT_KERNEL_SS FLAT_RING1_SS
-#define FLAT_USER_CS    FLAT_RING3_CS
-#define FLAT_USER_DS    FLAT_RING3_DS
-#define FLAT_USER_SS    FLAT_RING3_SS
-
-/* And the trap vector is... */
-#define TRAP_INSTR "int $0x82"
-
-/*
- * Virtual addresses beyond this are not modifiable by guest OSes. The
- * machine->physical mapping table starts at this address, read-only.
- */
-#ifdef CONFIG_X86_PAE
-#define __HYPERVISOR_VIRT_START 0xF5800000
-#else
-#define __HYPERVISOR_VIRT_START 0xFC000000
-#endif
-
-#ifndef HYPERVISOR_VIRT_START
-#define HYPERVISOR_VIRT_START mk_unsigned_long(__HYPERVISOR_VIRT_START)
-#endif
-
-#ifndef machine_to_phys_mapping
-#define machine_to_phys_mapping ((unsigned long *)HYPERVISOR_VIRT_START)
-#endif
-
-/* Maximum number of virtual CPUs in multi-processor guests. */
-#define MAX_VIRT_CPUS 32
-
-#ifndef __ASSEMBLY__
-
-/*
  * Send an array of these to HYPERVISOR_set_trap_table()
+ * The privilege level specifies which modes may enter a trap via a software
+ * interrupt. On x86/64, since rings 1 and 2 are unavailable, we allocate
+ * privilege levels as follows:
+ *  Level == 0: Noone may enter
+ *  Level == 1: Kernel may enter
+ *  Level == 2: Kernel may enter
+ *  Level == 3: Everyone may enter
  */
 #define TI_GET_DPL(_ti)		((_ti)->flags & 3)
 #define TI_GET_IF(_ti)		((_ti)->flags & 4)
 #define TI_SET_DPL(_ti, _dpl)	((_ti)->flags |= (_dpl))
 #define TI_SET_IF(_ti, _if)	((_ti)->flags |= ((!!(_if))<<2))
 
+#ifndef __ASSEMBLY__
 struct trap_info {
     uint8_t       vector;  /* exception vector                              */
     uint8_t       flags;   /* 0-3: privilege level; 4: clear event enable?  */
@@ -131,32 +105,21 @@
 };
 DEFINE_GUEST_HANDLE_STRUCT(trap_info);
 
-struct cpu_user_regs {
-    uint32_t ebx;
-    uint32_t ecx;
-    uint32_t edx;
-    uint32_t esi;
-    uint32_t edi;
-    uint32_t ebp;
-    uint32_t eax;
-    uint16_t error_code;    /* private */
-    uint16_t entry_vector;  /* private */
-    uint32_t eip;
-    uint16_t cs;
-    uint8_t  saved_upcall_mask;
-    uint8_t  _pad0;
-    uint32_t eflags;        /* eflags.IF == !saved_upcall_mask */
-    uint32_t esp;
-    uint16_t ss, _pad1;
-    uint16_t es, _pad2;
-    uint16_t ds, _pad3;
-    uint16_t fs, _pad4;
-    uint16_t gs, _pad5;
+struct arch_shared_info {
+    unsigned long max_pfn;                  /* max pfn that appears in table */
+    /* Frame containing list of mfns containing list of mfns containing p2m. */
+    unsigned long pfn_to_mfn_frame_list_list;
+    unsigned long nmi_reason;
 };
-DEFINE_GUEST_HANDLE_STRUCT(cpu_user_regs);
+#endif	/* !__ASSEMBLY__ */
 
-typedef uint64_t tsc_timestamp_t; /* RDTSC timestamp */
+#ifdef CONFIG_X86_32
+#include "interface_32.h"
+#else
+#include "interface_64.h"
+#endif
 
+#ifndef __ASSEMBLY__
 /*
  * The following is all CPU context. Note that the fpu_ctxt block is filled
  * in by FXSAVE if the CPU has feature FXSR; otherwise FSAVE is used.
@@ -173,33 +136,29 @@
     unsigned long ldt_base, ldt_ents;       /* LDT (linear address, # ents) */
     unsigned long gdt_frames[16], gdt_ents; /* GDT (machine frames, # ents) */
     unsigned long kernel_ss, kernel_sp;     /* Virtual TSS (only SS1/SP1)   */
+    /* NB. User pagetable on x86/64 is placed in ctrlreg[1]. */
     unsigned long ctrlreg[8];               /* CR0-CR7 (control registers)  */
     unsigned long debugreg[8];              /* DB0-DB7 (debug registers)    */
+#ifdef __i386__
     unsigned long event_callback_cs;        /* CS:EIP of event callback     */
     unsigned long event_callback_eip;
     unsigned long failsafe_callback_cs;     /* CS:EIP of failsafe callback  */
     unsigned long failsafe_callback_eip;
+#else
+    unsigned long event_callback_eip;
+    unsigned long failsafe_callback_eip;
+    unsigned long syscall_callback_eip;
+#endif
     unsigned long vm_assist;                /* VMASST_TYPE_* bitmap */
+#ifdef __x86_64__
+    /* Segment base addresses. */
+    uint64_t      fs_base;
+    uint64_t      gs_base_kernel;
+    uint64_t      gs_base_user;
+#endif
 };
 DEFINE_GUEST_HANDLE_STRUCT(vcpu_guest_context);
-
-struct arch_shared_info {
-    unsigned long max_pfn;                  /* max pfn that appears in table */
-    /* Frame containing list of mfns containing list of mfns containing p2m. */
-    unsigned long pfn_to_mfn_frame_list_list;
-    unsigned long nmi_reason;
-};
-
-struct arch_vcpu_info {
-    unsigned long cr2;
-    unsigned long pad[5]; /* sizeof(struct vcpu_info) == 64 */
-};
-
-struct xen_callback {
-	unsigned long cs;
-	unsigned long eip;
-};
-#endif /* !__ASSEMBLY__ */
+#endif	/* !__ASSEMBLY__ */
 
 /*
  * Prefix forces emulation of some non-trapping instructions.
@@ -213,4 +172,4 @@
 #define XEN_CPUID          XEN_EMULATE_PREFIX "cpuid"
 #endif
 
-#endif
+#endif	/* __ASM_X86_XEN_INTERFACE_H */
diff --git a/include/asm-x86/xen/interface_32.h b/include/asm-x86/xen/interface_32.h
new file mode 100644
--- /dev/null
+++ b/include/asm-x86/xen/interface_32.h
@@ -0,0 +1,97 @@
+/******************************************************************************
+ * arch-x86_32.h
+ *
+ * Guest OS interface to x86 32-bit Xen.
+ *
+ * Copyright (c) 2004, K A Fraser
+ */
+
+#ifndef __ASM_X86_XEN_INTERFACE_32_H
+#define __ASM_X86_XEN_INTERFACE_32_H
+
+
+/*
+ * These flat segments are in the Xen-private section of every GDT. Since these
+ * are also present in the initial GDT, many OSes will be able to avoid
+ * installing their own GDT.
+ */
+#define FLAT_RING1_CS 0xe019    /* GDT index 259 */
+#define FLAT_RING1_DS 0xe021    /* GDT index 260 */
+#define FLAT_RING1_SS 0xe021    /* GDT index 260 */
+#define FLAT_RING3_CS 0xe02b    /* GDT index 261 */
+#define FLAT_RING3_DS 0xe033    /* GDT index 262 */
+#define FLAT_RING3_SS 0xe033    /* GDT index 262 */
+
+#define FLAT_KERNEL_CS FLAT_RING1_CS
+#define FLAT_KERNEL_DS FLAT_RING1_DS
+#define FLAT_KERNEL_SS FLAT_RING1_SS
+#define FLAT_USER_CS    FLAT_RING3_CS
+#define FLAT_USER_DS    FLAT_RING3_DS
+#define FLAT_USER_SS    FLAT_RING3_SS
+
+/* And the trap vector is... */
+#define TRAP_INSTR "int $0x82"
+
+/*
+ * Virtual addresses beyond this are not modifiable by guest OSes. The
+ * machine->physical mapping table starts at this address, read-only.
+ */
+#define __HYPERVISOR_VIRT_START 0xF5800000
+
+#ifndef __ASSEMBLY__
+
+struct cpu_user_regs {
+    uint32_t ebx;
+    uint32_t ecx;
+    uint32_t edx;
+    uint32_t esi;
+    uint32_t edi;
+    uint32_t ebp;
+    uint32_t eax;
+    uint16_t error_code;    /* private */
+    uint16_t entry_vector;  /* private */
+    uint32_t eip;
+    uint16_t cs;
+    uint8_t  saved_upcall_mask;
+    uint8_t  _pad0;
+    uint32_t eflags;        /* eflags.IF == !saved_upcall_mask */
+    uint32_t esp;
+    uint16_t ss, _pad1;
+    uint16_t es, _pad2;
+    uint16_t ds, _pad3;
+    uint16_t fs, _pad4;
+    uint16_t gs, _pad5;
+};
+DEFINE_GUEST_HANDLE_STRUCT(cpu_user_regs);
+
+typedef uint64_t tsc_timestamp_t; /* RDTSC timestamp */
+
+struct arch_vcpu_info {
+    unsigned long cr2;
+    unsigned long pad[5]; /* sizeof(struct vcpu_info) == 64 */
+};
+
+struct xen_callback {
+	unsigned long cs;
+	unsigned long eip;
+};
+typedef struct xen_callback xen_callback_t;
+
+#define XEN_CALLBACK(__cs, __eip)				\
+	((struct xen_callback){ .cs = (__cs), .eip = (unsigned long)(__eip) })
+#endif /* !__ASSEMBLY__ */
+
+
+/*
+ * Page-directory addresses above 4GB do not fit into architectural %cr3.
+ * When accessing %cr3, or equivalent field in vcpu_guest_context, guests
+ * must use the following accessor macros to pack/unpack valid MFNs.
+ *
+ * Note that Xen is using the fact that the pagetable base is always
+ * page-aligned, and putting the 12 MSB of the address into the 12 LSB
+ * of cr3.
+ */
+#define xen_pfn_to_cr3(pfn) (((unsigned)(pfn) << 12) | ((unsigned)(pfn) >> 20))
+#define xen_cr3_to_pfn(cr3) (((unsigned)(cr3) >> 12) | ((unsigned)(cr3) << 20))
+
+#endif	/* __ASM_X86_XEN_INTERFACE_32_H */
diff --git a/include/asm-x86/xen/interface_64.h b/include/asm-x86/xen/interface_64.h
new file mode 100644
--- /dev/null
+++ b/include/asm-x86/xen/interface_64.h
@@ -0,0 +1,159 @@
+#ifndef __ASM_X86_XEN_INTERFACE_64_H
+#define __ASM_X86_XEN_INTERFACE_64_H
+
+/*
+ * 64-bit segment selectors
+ * These flat segments are in the Xen-private section of every GDT. Since these
+ * are also present in the initial GDT, many OSes will be able to avoid
+ * installing their own GDT.
+ */
+
+#define FLAT_RING3_CS32 0xe023  /* GDT index 260 */
+#define FLAT_RING3_CS64 0xe033  /* GDT index 261 */
+#define FLAT_RING3_DS32 0xe02b  /* GDT index 262 */
+#define FLAT_RING3_DS64 0x0000  /* NULL selector */
+#define FLAT_RING3_SS32 0xe02b  /* GDT index 262 */
+#define FLAT_RING3_SS64 0xe02b  /* GDT index 262 */
+
+#define FLAT_KERNEL_DS64 FLAT_RING3_DS64
+#define FLAT_KERNEL_DS32 FLAT_RING3_DS32
+#define FLAT_KERNEL_DS   FLAT_KERNEL_DS64
+#define FLAT_KERNEL_CS64 FLAT_RING3_CS64
+#define FLAT_KERNEL_CS32 FLAT_RING3_CS32
+#define FLAT_KERNEL_CS   FLAT_KERNEL_CS64
+#define FLAT_KERNEL_SS64 FLAT_RING3_SS64
+#define FLAT_KERNEL_SS32 FLAT_RING3_SS32
+#define FLAT_KERNEL_SS   FLAT_KERNEL_SS64
+
+#define FLAT_USER_DS64 FLAT_RING3_DS64
+#define FLAT_USER_DS32 FLAT_RING3_DS32
+#define FLAT_USER_DS   FLAT_USER_DS64
+#define FLAT_USER_CS64 FLAT_RING3_CS64
+#define FLAT_USER_CS32 FLAT_RING3_CS32
+#define FLAT_USER_CS   FLAT_USER_CS64
+#define FLAT_USER_SS64 FLAT_RING3_SS64
+#define FLAT_USER_SS32 FLAT_RING3_SS32
+#define FLAT_USER_SS   FLAT_USER_SS64
+
+#define __HYPERVISOR_VIRT_START 0xFFFF800000000000
+#define __HYPERVISOR_VIRT_END   0xFFFF880000000000
+#define __MACH2PHYS_VIRT_START  0xFFFF800000000000
+#define __MACH2PHYS_VIRT_END    0xFFFF804000000000
+
+#ifndef HYPERVISOR_VIRT_START
+#define HYPERVISOR_VIRT_START mk_unsigned_long(__HYPERVISOR_VIRT_START)
+#define HYPERVISOR_VIRT_END   mk_unsigned_long(__HYPERVISOR_VIRT_END)
+#endif
+
+#define MACH2PHYS_VIRT_START  mk_unsigned_long(__MACH2PHYS_VIRT_START)
+#define MACH2PHYS_VIRT_END    mk_unsigned_long(__MACH2PHYS_VIRT_END)
+#define MACH2PHYS_NR_ENTRIES  ((MACH2PHYS_VIRT_END-MACH2PHYS_VIRT_START)>>3)
+#ifndef machine_to_phys_mapping
+#define machine_to_phys_mapping ((unsigned long *)HYPERVISOR_VIRT_START)
+#endif
+
+/*
+ * int HYPERVISOR_set_segment_base(unsigned int which, unsigned long base)
+ *  @which == SEGBASE_*  ;  @base == 64-bit base address
+ * Returns 0 on success.
+ */
+#define SEGBASE_FS          0
+#define SEGBASE_GS_USER     1
+#define SEGBASE_GS_KERNEL   2
+#define SEGBASE_GS_USER_SEL 3 /* Set user %gs specified in base[15:0] */
+
+/*
+ * int HYPERVISOR_iret(void)
+ * All arguments are on the kernel stack, in the following format.
+ * Never returns if successful. Current kernel context is lost.
+ * The saved CS is mapped as follows:
+ *   RING0 -> RING3 kernel mode.
+ *   RING1 -> RING3 kernel mode.
+ *   RING2 -> RING3 kernel mode.
+ *   RING3 -> RING3 user mode.
+ * However RING0 indicates that the guest kernel should return to iteself
+ * directly with
+ *      orb   $3,1*8(%rsp)
+ *      iretq
+ * If flags contains VGCF_in_syscall:
+ *   Restore RAX, RIP, RFLAGS, RSP.
+ *   Discard R11, RCX, CS, SS.
+ * Otherwise:
+ *   Restore RAX, R11, RCX, CS:RIP, RFLAGS, SS:RSP.
+ * All other registers are saved on hypercall entry and restored to user.
+ */
+/* Guest exited in SYSCALL context? Return to guest with SYSRET? */
+#define _VGCF_in_syscall 8
+#define VGCF_in_syscall  (1<<_VGCF_in_syscall)
+#define VGCF_IN_SYSCALL  VGCF_in_syscall
+
+#ifndef __ASSEMBLY__
+
+struct iret_context {
+    /* Top of stack (%rsp at point of hypercall). */
+    uint64_t rax, r11, rcx, flags, rip, cs, rflags, rsp, ss;
+    /* Bottom of iret stack frame. */
+};
+
+#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
+/* Anonymous union includes both 32- and 64-bit names (e.g., eax/rax). */
+#define __DECL_REG(name) union { \
+    uint64_t r ## name, e ## name; \
+    uint32_t _e ## name; \
+}
+#else
+/* Non-gcc sources must always use the proper 64-bit name (e.g., rax). */
+#define __DECL_REG(name) uint64_t r ## name
+#endif
+
+struct cpu_user_regs {
+    uint64_t r15;
+    uint64_t r14;
+    uint64_t r13;
+    uint64_t r12;
+    __DECL_REG(bp);
+    __DECL_REG(bx);
+    uint64_t r11;
+    uint64_t r10;
+    uint64_t r9;
+    uint64_t r8;
+    __DECL_REG(ax);
+    __DECL_REG(cx);
+    __DECL_REG(dx);
+    __DECL_REG(si);
+    __DECL_REG(di);
+    uint32_t error_code;    /* private */
+    uint32_t entry_vector;  /* private */
+    __DECL_REG(ip);
+    uint16_t cs, _pad0[1];
+    uint8_t  saved_upcall_mask;
+    uint8_t  _pad1[3];
+    __DECL_REG(flags);      /* rflags.IF == !saved_upcall_mask */
+    __DECL_REG(sp);
+    uint16_t ss, _pad2[3];
+    uint16_t es, _pad3[3];
+    uint16_t ds, _pad4[3];
+    uint16_t fs, _pad5[3]; /* Non-zero => takes precedence over fs_base.     */
+    uint16_t gs, _pad6[3]; /* Non-zero => takes precedence over gs_base_usr. */
+};
+DEFINE_GUEST_HANDLE_STRUCT(cpu_user_regs);
+
+#undef __DECL_REG
+
+#define xen_pfn_to_cr3(pfn) ((unsigned long)(pfn) << 12)
+#define xen_cr3_to_pfn(cr3) ((unsigned long)(cr3) >> 12)
+
+struct arch_vcpu_info {
+    unsigned long cr2;
+    unsigned long pad; /* sizeof(vcpu_info_t) == 64 */
+};
+
+typedef unsigned long xen_callback_t;
+
+#define XEN_CALLBACK(__cs, __rip)				\
+	((unsigned long)(__rip))
+
+#endif /* !__ASSEMBLY__ */
+
+
+#endif	/* __ASM_X86_XEN_INTERFACE_64_H */
diff --git a/include/xen/interface/callback.h b/include/xen/interface/callback.h
--- a/include/xen/interface/callback.h
+++ b/include/xen/interface/callback.h
@@ -82,9 +82,9 @@
  */
 #define CALLBACKOP_register                0
 struct callback_register {
-    uint16_t type;
-    uint16_t flags;
-    struct xen_callback address;
+	uint16_t type;
+	uint16_t flags;
+	xen_callback_t address;
 };
 
 /*


