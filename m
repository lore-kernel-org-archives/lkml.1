Return-Path: <linux-kernel-owner+w=401wt.eu-S933374AbYDQJY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbYDQJY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763606AbYDQJLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:32 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:59016
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763225AbYDQJLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:08 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Xiantao Zhang <xiantao.zhang@intel.com>
Subject: [PATCH 31/45] KVM: ia64: Add header files for kvm/ia64
Date: Thu, 17 Apr 2008 12:10:36 +0300
Message-Id: <1208423450-29415-32-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiantao Zhang <xiantao.zhang@intel.com>

Three header files are added:
asm-ia64/kvm.h
asm-ia64/kvm_host.h
asm-ia64/kvm_para.h

Signed-off-by: Xiantao Zhang <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-ia64/kvm.h      |  205 +++++++++++++++++-
 include/asm-ia64/kvm_host.h |  524 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-ia64/kvm_para.h |   29 +++
 3 files changed, 755 insertions(+), 3 deletions(-)
 create mode 100644 include/asm-ia64/kvm_host.h
 create mode 100644 include/asm-ia64/kvm_para.h

diff --git a/include/asm-ia64/kvm.h b/include/asm-ia64/kvm.h
index 030d29b..eb2d355 100644
--- a/include/asm-ia64/kvm.h
+++ b/include/asm-ia64/kvm.h
@@ -1,6 +1,205 @@
-#ifndef __LINUX_KVM_IA64_H
-#define __LINUX_KVM_IA64_H
+#ifndef __ASM_IA64_KVM_H
+#define __ASM_IA64_KVM_H
 
-/* ia64 does not support KVM */
+/*
+ * asm-ia64/kvm.h: kvm structure definitions  for ia64
+ *
+ * Copyright (C) 2007 Xiantao Zhang <xiantao.zhang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ */
+
+#include <asm/types.h>
+#include <asm/fpu.h>
+
+#include <linux/ioctl.h>
+
+/* Architectural interrupt line count. */
+#define KVM_NR_INTERRUPTS 256
+
+#define KVM_IOAPIC_NUM_PINS  24
+
+struct kvm_ioapic_state {
+	__u64 base_address;
+	__u32 ioregsel;
+	__u32 id;
+	__u32 irr;
+	__u32 pad;
+	union {
+		__u64 bits;
+		struct {
+			__u8 vector;
+			__u8 delivery_mode:3;
+			__u8 dest_mode:1;
+			__u8 delivery_status:1;
+			__u8 polarity:1;
+			__u8 remote_irr:1;
+			__u8 trig_mode:1;
+			__u8 mask:1;
+			__u8 reserve:7;
+			__u8 reserved[4];
+			__u8 dest_id;
+		} fields;
+	} redirtbl[KVM_IOAPIC_NUM_PINS];
+};
+
+#define KVM_IRQCHIP_PIC_MASTER   0
+#define KVM_IRQCHIP_PIC_SLAVE    1
+#define KVM_IRQCHIP_IOAPIC       2
+
+#define KVM_CONTEXT_SIZE	8*1024
+
+union context {
+	/* 8K size */
+	char	dummy[KVM_CONTEXT_SIZE];
+	struct {
+		unsigned long       psr;
+		unsigned long       pr;
+		unsigned long       caller_unat;
+		unsigned long       pad;
+		unsigned long       gr[32];
+		unsigned long       ar[128];
+		unsigned long       br[8];
+		unsigned long       cr[128];
+		unsigned long       rr[8];
+		unsigned long       ibr[8];
+		unsigned long       dbr[8];
+		unsigned long       pkr[8];
+		struct ia64_fpreg   fr[128];
+	};
+};
+
+struct thash_data {
+	union {
+		struct {
+			unsigned long p    :  1; /* 0 */
+			unsigned long rv1  :  1; /* 1 */
+			unsigned long ma   :  3; /* 2-4 */
+			unsigned long a    :  1; /* 5 */
+			unsigned long d    :  1; /* 6 */
+			unsigned long pl   :  2; /* 7-8 */
+			unsigned long ar   :  3; /* 9-11 */
+			unsigned long ppn  : 38; /* 12-49 */
+			unsigned long rv2  :  2; /* 50-51 */
+			unsigned long ed   :  1; /* 52 */
+			unsigned long ig1  : 11; /* 53-63 */
+		};
+		struct {
+			unsigned long __rv1 : 53;     /* 0-52 */
+			unsigned long contiguous : 1; /*53 */
+			unsigned long tc : 1;         /* 54 TR or TC */
+			unsigned long cl : 1;
+			/* 55 I side or D side cache line */
+			unsigned long len  :  4;      /* 56-59 */
+			unsigned long io  : 1;	/* 60 entry is for io or not */
+			unsigned long nomap : 1;
+			/* 61 entry cann't be inserted into machine TLB.*/
+			unsigned long checked : 1;
+			/* 62 for VTLB/VHPT sanity check */
+			unsigned long invalid : 1;
+			/* 63 invalid entry */
+		};
+		unsigned long page_flags;
+	};                  /* same for VHPT and TLB */
+
+	union {
+		struct {
+			unsigned long rv3  :  2;
+			unsigned long ps   :  6;
+			unsigned long key  : 24;
+			unsigned long rv4  : 32;
+		};
+		unsigned long itir;
+	};
+	union {
+		struct {
+			unsigned long ig2  :  12;
+			unsigned long vpn  :  49;
+			unsigned long vrn  :   3;
+		};
+		unsigned long ifa;
+		unsigned long vadr;
+		struct {
+			unsigned long tag  :  63;
+			unsigned long ti   :  1;
+		};
+		unsigned long etag;
+	};
+	union {
+		struct thash_data *next;
+		unsigned long rid;
+		unsigned long gpaddr;
+	};
+};
+
+#define	NITRS	8
+#define NDTRS	8
+
+struct saved_vpd {
+	unsigned long  vhpi;
+	unsigned long  vgr[16];
+	unsigned long  vbgr[16];
+	unsigned long  vnat;
+	unsigned long  vbnat;
+	unsigned long  vcpuid[5];
+	unsigned long  vpsr;
+	unsigned long  vpr;
+	unsigned long  vcr[128];
+};
+
+struct kvm_regs {
+	char *saved_guest;
+	char *saved_stack;
+	struct saved_vpd vpd;
+	/*Arch-regs*/
+	int mp_state;
+	unsigned long vmm_rr;
+	/* TR and TC.  */
+	struct thash_data itrs[NITRS];
+	struct thash_data dtrs[NDTRS];
+	/* Bit is set if there is a tr/tc for the region.  */
+	unsigned char itr_regions;
+	unsigned char dtr_regions;
+	unsigned char tc_regions;
+
+	char irq_check;
+	unsigned long saved_itc;
+	unsigned long itc_check;
+	unsigned long timer_check;
+	unsigned long timer_pending;
+	unsigned long last_itc;
+
+	unsigned long vrr[8];
+	unsigned long ibr[8];
+	unsigned long dbr[8];
+	unsigned long insvc[4];		/* Interrupt in service.  */
+	unsigned long xtp;
+
+	unsigned long metaphysical_rr0; /* from kvm_arch (so is pinned) */
+	unsigned long metaphysical_rr4;	/* from kvm_arch (so is pinned) */
+	unsigned long metaphysical_saved_rr0; /* from kvm_arch          */
+	unsigned long metaphysical_saved_rr4; /* from kvm_arch          */
+	unsigned long fp_psr;       /*used for lazy float register */
+	unsigned long saved_gp;
+	/*for phycial  emulation */
+};
+
+struct kvm_sregs {
+};
+
+struct kvm_fpu {
+};
 
 #endif
diff --git a/include/asm-ia64/kvm_host.h b/include/asm-ia64/kvm_host.h
new file mode 100644
index 0000000..d6d6e15
--- /dev/null
+++ b/include/asm-ia64/kvm_host.h
@@ -0,0 +1,524 @@
+/*
+ * kvm_host.h: used for kvm module, and hold ia64-specific sections.
+ *
+ * Copyright (C) 2007, Intel Corporation.
+ *
+ * Xiantao Zhang <xiantao.zhang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ */
+
+#ifndef __ASM_KVM_HOST_H
+#define __ASM_KVM_HOST_H
+
+
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/kvm.h>
+#include <linux/kvm_para.h>
+#include <linux/kvm_types.h>
+
+#include <asm/pal.h>
+#include <asm/sal.h>
+
+#define KVM_MAX_VCPUS 4
+#define KVM_MEMORY_SLOTS 32
+/* memory slots that does not exposed to userspace */
+#define KVM_PRIVATE_MEM_SLOTS 4
+
+
+/* define exit reasons from vmm to kvm*/
+#define EXIT_REASON_VM_PANIC		0
+#define EXIT_REASON_MMIO_INSTRUCTION	1
+#define EXIT_REASON_PAL_CALL		2
+#define EXIT_REASON_SAL_CALL		3
+#define EXIT_REASON_SWITCH_RR6		4
+#define EXIT_REASON_VM_DESTROY		5
+#define EXIT_REASON_EXTERNAL_INTERRUPT	6
+#define EXIT_REASON_IPI			7
+#define EXIT_REASON_PTC_G		8
+
+/*Define vmm address space and vm data space.*/
+#define KVM_VMM_SIZE (16UL<<20)
+#define KVM_VMM_SHIFT 24
+#define KVM_VMM_BASE 0xD000000000000000UL
+#define VMM_SIZE (8UL<<20)
+
+/*
+ * Define vm_buffer, used by PAL Services, base address.
+ * Note: vmbuffer is in the VMM-BLOCK, the size must be < 8M
+ */
+#define KVM_VM_BUFFER_BASE (KVM_VMM_BASE + VMM_SIZE)
+#define KVM_VM_BUFFER_SIZE (8UL<<20)
+
+/*Define Virtual machine data layout.*/
+#define KVM_VM_DATA_SHIFT  24
+#define KVM_VM_DATA_SIZE (1UL << KVM_VM_DATA_SHIFT)
+#define KVM_VM_DATA_BASE (KVM_VMM_BASE + KVM_VMM_SIZE)
+
+
+#define KVM_P2M_BASE    KVM_VM_DATA_BASE
+#define KVM_P2M_OFS     0
+#define KVM_P2M_SIZE    (8UL << 20)
+
+#define KVM_VHPT_BASE   (KVM_P2M_BASE + KVM_P2M_SIZE)
+#define KVM_VHPT_OFS    KVM_P2M_SIZE
+#define KVM_VHPT_BLOCK_SIZE   (2UL << 20)
+#define VHPT_SHIFT      18
+#define VHPT_SIZE       (1UL << VHPT_SHIFT)
+#define VHPT_NUM_ENTRIES (1<<(VHPT_SHIFT-5))
+
+#define KVM_VTLB_BASE   (KVM_VHPT_BASE+KVM_VHPT_BLOCK_SIZE)
+#define KVM_VTLB_OFS    (KVM_VHPT_OFS+KVM_VHPT_BLOCK_SIZE)
+#define KVM_VTLB_BLOCK_SIZE   (1UL<<20)
+#define VTLB_SHIFT      17
+#define VTLB_SIZE       (1UL<<VTLB_SHIFT)
+#define VTLB_NUM_ENTRIES (1<<(VTLB_SHIFT-5))
+
+#define KVM_VPD_BASE   (KVM_VTLB_BASE+KVM_VTLB_BLOCK_SIZE)
+#define KVM_VPD_OFS    (KVM_VTLB_OFS+KVM_VTLB_BLOCK_SIZE)
+#define KVM_VPD_BLOCK_SIZE   (2UL<<20)
+#define VPD_SHIFT       16
+#define VPD_SIZE        (1UL<<VPD_SHIFT)
+
+#define KVM_VCPU_BASE   (KVM_VPD_BASE+KVM_VPD_BLOCK_SIZE)
+#define KVM_VCPU_OFS    (KVM_VPD_OFS+KVM_VPD_BLOCK_SIZE)
+#define KVM_VCPU_BLOCK_SIZE   (2UL<<20)
+#define VCPU_SHIFT 18
+#define VCPU_SIZE (1UL<<VCPU_SHIFT)
+#define MAX_VCPU_NUM KVM_VCPU_BLOCK_SIZE/VCPU_SIZE
+
+#define KVM_VM_BASE     (KVM_VCPU_BASE+KVM_VCPU_BLOCK_SIZE)
+#define KVM_VM_OFS      (KVM_VCPU_OFS+KVM_VCPU_BLOCK_SIZE)
+#define KVM_VM_BLOCK_SIZE     (1UL<<19)
+
+#define KVM_MEM_DIRTY_LOG_BASE (KVM_VM_BASE+KVM_VM_BLOCK_SIZE)
+#define KVM_MEM_DIRTY_LOG_OFS  (KVM_VM_OFS+KVM_VM_BLOCK_SIZE)
+#define KVM_MEM_DIRTY_LOG_SIZE (1UL<<19)
+
+/* Get vpd, vhpt, tlb, vcpu, base*/
+#define VPD_ADDR(n) (KVM_VPD_BASE+n*VPD_SIZE)
+#define VHPT_ADDR(n) (KVM_VHPT_BASE+n*VHPT_SIZE)
+#define VTLB_ADDR(n) (KVM_VTLB_BASE+n*VTLB_SIZE)
+#define VCPU_ADDR(n) (KVM_VCPU_BASE+n*VCPU_SIZE)
+
+/*IO section definitions*/
+#define IOREQ_READ      1
+#define IOREQ_WRITE     0
+
+#define STATE_IOREQ_NONE        0
+#define STATE_IOREQ_READY       1
+#define STATE_IOREQ_INPROCESS   2
+#define STATE_IORESP_READY      3
+
+/*Guest Physical address layout.*/
+#define GPFN_MEM        (0UL << 60) /* Guest pfn is normal mem */
+#define GPFN_FRAME_BUFFER   (1UL << 60) /* VGA framebuffer */
+#define GPFN_LOW_MMIO       (2UL << 60) /* Low MMIO range */
+#define GPFN_PIB        (3UL << 60) /* PIB base */
+#define GPFN_IOSAPIC        (4UL << 60) /* IOSAPIC base */
+#define GPFN_LEGACY_IO      (5UL << 60) /* Legacy I/O base */
+#define GPFN_GFW        (6UL << 60) /* Guest Firmware */
+#define GPFN_HIGH_MMIO      (7UL << 60) /* High MMIO range */
+
+#define GPFN_IO_MASK        (7UL << 60) /* Guest pfn is I/O type */
+#define GPFN_INV_MASK       (1UL << 63) /* Guest pfn is invalid */
+#define INVALID_MFN       (~0UL)
+#define MEM_G   (1UL << 30)
+#define MEM_M   (1UL << 20)
+#define MMIO_START       (3 * MEM_G)
+#define MMIO_SIZE        (512 * MEM_M)
+#define VGA_IO_START     0xA0000UL
+#define VGA_IO_SIZE      0x20000
+#define LEGACY_IO_START  (MMIO_START + MMIO_SIZE)
+#define LEGACY_IO_SIZE   (64 * MEM_M)
+#define IO_SAPIC_START   0xfec00000UL
+#define IO_SAPIC_SIZE    0x100000
+#define PIB_START 0xfee00000UL
+#define PIB_SIZE 0x200000
+#define GFW_START        (4 * MEM_G - 16 * MEM_M)
+#define GFW_SIZE         (16 * MEM_M)
+
+/*Deliver mode, defined for ioapic.c*/
+#define dest_Fixed IOSAPIC_FIXED
+#define dest_LowestPrio IOSAPIC_LOWEST_PRIORITY
+
+#define NMI_VECTOR      		2
+#define ExtINT_VECTOR       		0
+#define NULL_VECTOR     		(-1)
+#define IA64_SPURIOUS_INT_VECTOR    	0x0f
+
+#define VCPU_LID(v) (((u64)(v)->vcpu_id) << 24)
+
+/*
+ *Delivery mode
+ */
+#define SAPIC_DELIV_SHIFT      8
+#define SAPIC_FIXED            0x0
+#define SAPIC_LOWEST_PRIORITY  0x1
+#define SAPIC_PMI              0x2
+#define SAPIC_NMI              0x4
+#define SAPIC_INIT             0x5
+#define SAPIC_EXTINT           0x7
+
+/*
+ * vcpu->requests bit members for arch
+ */
+#define KVM_REQ_PTC_G		32
+#define KVM_REQ_RESUME		33
+
+#define KVM_PAGES_PER_HPAGE	1
+
+struct kvm;
+struct kvm_vcpu;
+struct kvm_guest_debug{
+};
+
+struct kvm_mmio_req {
+	uint64_t addr;          /*  physical address		*/
+	uint64_t size;          /*  size in bytes		*/
+	uint64_t data;          /*  data (or paddr of data)     */
+	uint8_t state:4;
+	uint8_t dir:1;          /*  1=read, 0=write             */
+};
+
+/*Pal data struct */
+struct kvm_pal_call{
+	/*In area*/
+	uint64_t gr28;
+	uint64_t gr29;
+	uint64_t gr30;
+	uint64_t gr31;
+	/*Out area*/
+	struct ia64_pal_retval ret;
+};
+
+/* Sal data structure */
+struct kvm_sal_call{
+	/*In area*/
+	uint64_t in0;
+	uint64_t in1;
+	uint64_t in2;
+	uint64_t in3;
+	uint64_t in4;
+	uint64_t in5;
+	uint64_t in6;
+	uint64_t in7;
+	struct sal_ret_values ret;
+};
+
+/*Guest change rr6*/
+struct kvm_switch_rr6 {
+	uint64_t old_rr;
+	uint64_t new_rr;
+};
+
+union ia64_ipi_a{
+	unsigned long val;
+	struct {
+		unsigned long rv  : 3;
+		unsigned long ir  : 1;
+		unsigned long eid : 8;
+		unsigned long id  : 8;
+		unsigned long ib_base : 44;
+	};
+};
+
+union ia64_ipi_d {
+	unsigned long val;
+	struct {
+		unsigned long vector : 8;
+		unsigned long dm  : 3;
+		unsigned long ig  : 53;
+	};
+};
+
+/*ipi check exit data*/
+struct kvm_ipi_data{
+	union ia64_ipi_a addr;
+	union ia64_ipi_d data;
+};
+
+/*global purge data*/
+struct kvm_ptc_g {
+	unsigned long vaddr;
+	unsigned long rr;
+	unsigned long ps;
+	struct kvm_vcpu *vcpu;
+};
+
+/*Exit control data */
+struct exit_ctl_data{
+	uint32_t exit_reason;
+	uint32_t vm_status;
+	union {
+		struct kvm_mmio_req	ioreq;
+		struct kvm_pal_call	pal_data;
+		struct kvm_sal_call	sal_data;
+		struct kvm_switch_rr6	rr_data;
+		struct kvm_ipi_data	ipi_data;
+		struct kvm_ptc_g	ptc_g_data;
+	} u;
+};
+
+union pte_flags {
+	unsigned long val;
+	struct {
+		unsigned long p    :  1; /*0      */
+		unsigned long      :  1; /* 1     */
+		unsigned long ma   :  3; /* 2-4   */
+		unsigned long a    :  1; /* 5     */
+		unsigned long d    :  1; /* 6     */
+		unsigned long pl   :  2; /* 7-8   */
+		unsigned long ar   :  3; /* 9-11  */
+		unsigned long ppn  : 38; /* 12-49 */
+		unsigned long      :  2; /* 50-51 */
+		unsigned long ed   :  1; /* 52    */
+	};
+};
+
+union ia64_pta {
+	unsigned long val;
+	struct {
+		unsigned long ve : 1;
+		unsigned long reserved0 : 1;
+		unsigned long size : 6;
+		unsigned long vf : 1;
+		unsigned long reserved1 : 6;
+		unsigned long base : 49;
+	};
+};
+
+struct thash_cb {
+	/* THASH base information */
+	struct thash_data	*hash; /* hash table pointer */
+	union ia64_pta		pta;
+	int           num;
+};
+
+struct kvm_vcpu_stat {
+};
+
+struct kvm_vcpu_arch {
+	int launched;
+	int last_exit;
+	int last_run_cpu;
+	int vmm_tr_slot;
+	int vm_tr_slot;
+
+#define VCPU_MP_STATE_RUNNABLE          0
+#define VCPU_MP_STATE_UNINITIALIZED     1
+#define VCPU_MP_STATE_INIT_RECEIVED     2
+#define VCPU_MP_STATE_HALTED            3
+	int mp_state;
+
+#define MAX_PTC_G_NUM			3
+	int ptc_g_count;
+	struct kvm_ptc_g ptc_g_data[MAX_PTC_G_NUM];
+
+	/*halt timer to wake up sleepy vcpus*/
+	struct hrtimer hlt_timer;
+	long ht_active;
+
+	struct kvm_lapic *apic;    /* kernel irqchip context */
+	struct vpd *vpd;
+
+	/* Exit data for vmm_transition*/
+	struct exit_ctl_data exit_data;
+
+	cpumask_t cache_coherent_map;
+
+	unsigned long vmm_rr;
+	unsigned long host_rr6;
+	unsigned long psbits[8];
+	unsigned long cr_iipa;
+	unsigned long cr_isr;
+	unsigned long vsa_base;
+	unsigned long dirty_log_lock_pa;
+	unsigned long __gp;
+	/* TR and TC.  */
+	struct thash_data itrs[NITRS];
+	struct thash_data dtrs[NDTRS];
+	/* Bit is set if there is a tr/tc for the region.  */
+	unsigned char itr_regions;
+	unsigned char dtr_regions;
+	unsigned char tc_regions;
+	/* purge all */
+	unsigned long ptce_base;
+	unsigned long ptce_count[2];
+	unsigned long ptce_stride[2];
+	/* itc/itm */
+	unsigned long last_itc;
+	long itc_offset;
+	unsigned long itc_check;
+	unsigned long timer_check;
+	unsigned long timer_pending;
+
+	unsigned long vrr[8];
+	unsigned long ibr[8];
+	unsigned long dbr[8];
+	unsigned long insvc[4];		/* Interrupt in service.  */
+	unsigned long xtp;
+
+	unsigned long metaphysical_rr0; /* from kvm_arch (so is pinned) */
+	unsigned long metaphysical_rr4;	/* from kvm_arch (so is pinned) */
+	unsigned long metaphysical_saved_rr0; /* from kvm_arch          */
+	unsigned long metaphysical_saved_rr4; /* from kvm_arch          */
+	unsigned long fp_psr;       /*used for lazy float register */
+	unsigned long saved_gp;
+	/*for phycial  emulation */
+	int mode_flags;
+	struct thash_cb vtlb;
+	struct thash_cb vhpt;
+	char irq_check;
+	char irq_new_pending;
+
+	unsigned long opcode;
+	unsigned long cause;
+	union context host;
+	union context guest;
+};
+
+struct kvm_vm_stat {
+	u64 remote_tlb_flush;
+};
+
+struct kvm_sal_data {
+	unsigned long boot_ip;
+	unsigned long boot_gp;
+};
+
+struct kvm_arch {
+	unsigned long	vm_base;
+	unsigned long	metaphysical_rr0;
+	unsigned long	metaphysical_rr4;
+	unsigned long	vmm_init_rr;
+	unsigned long	vhpt_base;
+	unsigned long	vtlb_base;
+	unsigned long 	vpd_base;
+	spinlock_t dirty_log_lock;
+	struct kvm_ioapic *vioapic;
+	struct kvm_vm_stat stat;
+	struct kvm_sal_data rdv_sal_data;
+};
+
+union cpuid3_t {
+	u64 value;
+	struct {
+		u64 number : 8;
+		u64 revision : 8;
+		u64 model : 8;
+		u64 family : 8;
+		u64 archrev : 8;
+		u64 rv : 24;
+	};
+};
+
+struct kvm_pt_regs {
+	/* The following registers are saved by SAVE_MIN: */
+	unsigned long b6;  /* scratch */
+	unsigned long b7;  /* scratch */
+
+	unsigned long ar_csd; /* used by cmp8xchg16 (scratch) */
+	unsigned long ar_ssd; /* reserved for future use (scratch) */
+
+	unsigned long r8;  /* scratch (return value register 0) */
+	unsigned long r9;  /* scratch (return value register 1) */
+	unsigned long r10; /* scratch (return value register 2) */
+	unsigned long r11; /* scratch (return value register 3) */
+
+	unsigned long cr_ipsr; /* interrupted task's psr */
+	unsigned long cr_iip;  /* interrupted task's instruction pointer */
+	unsigned long cr_ifs;  /* interrupted task's function state */
+
+	unsigned long ar_unat; /* interrupted task's NaT register (preserved) */
+	unsigned long ar_pfs;  /* prev function state  */
+	unsigned long ar_rsc;  /* RSE configuration */
+	/* The following two are valid only if cr_ipsr.cpl > 0: */
+	unsigned long ar_rnat;  /* RSE NaT */
+	unsigned long ar_bspstore; /* RSE bspstore */
+
+	unsigned long pr;  /* 64 predicate registers (1 bit each) */
+	unsigned long b0;  /* return pointer (bp) */
+	unsigned long loadrs;  /* size of dirty partition << 16 */
+
+	unsigned long r1;  /* the gp pointer */
+	unsigned long r12; /* interrupted task's memory stack pointer */
+	unsigned long r13; /* thread pointer */
+
+	unsigned long ar_fpsr;  /* floating point status (preserved) */
+	unsigned long r15;  /* scratch */
+
+	/* The remaining registers are NOT saved for system calls.  */
+	unsigned long r14;  /* scratch */
+	unsigned long r2;  /* scratch */
+	unsigned long r3;  /* scratch */
+	unsigned long r16;  /* scratch */
+	unsigned long r17;  /* scratch */
+	unsigned long r18;  /* scratch */
+	unsigned long r19;  /* scratch */
+	unsigned long r20;  /* scratch */
+	unsigned long r21;  /* scratch */
+	unsigned long r22;  /* scratch */
+	unsigned long r23;  /* scratch */
+	unsigned long r24;  /* scratch */
+	unsigned long r25;  /* scratch */
+	unsigned long r26;  /* scratch */
+	unsigned long r27;  /* scratch */
+	unsigned long r28;  /* scratch */
+	unsigned long r29;  /* scratch */
+	unsigned long r30;  /* scratch */
+	unsigned long r31;  /* scratch */
+	unsigned long ar_ccv;  /* compare/exchange value (scratch) */
+
+	/*
+	 * Floating point registers that the kernel considers scratch:
+	 */
+	struct ia64_fpreg f6;  /* scratch */
+	struct ia64_fpreg f7;  /* scratch */
+	struct ia64_fpreg f8;  /* scratch */
+	struct ia64_fpreg f9;  /* scratch */
+	struct ia64_fpreg f10;  /* scratch */
+	struct ia64_fpreg f11;  /* scratch */
+
+	unsigned long r4;  /* preserved */
+	unsigned long r5;  /* preserved */
+	unsigned long r6;  /* preserved */
+	unsigned long r7;  /* preserved */
+	unsigned long eml_unat;    /* used for emulating instruction */
+	unsigned long pad0;     /* alignment pad */
+};
+
+static inline struct kvm_pt_regs *vcpu_regs(struct kvm_vcpu *v)
+{
+	return (struct kvm_pt_regs *) ((unsigned long) v + IA64_STK_OFFSET) - 1;
+}
+
+typedef int kvm_vmm_entry(void);
+typedef void kvm_tramp_entry(union context *host, union context *guest);
+
+struct kvm_vmm_info{
+	struct module	*module;
+	kvm_vmm_entry 	*vmm_entry;
+	kvm_tramp_entry *tramp_entry;
+	unsigned long 	vmm_ivt;
+};
+
+int kvm_highest_pending_irq(struct kvm_vcpu *vcpu);
+int kvm_emulate_halt(struct kvm_vcpu *vcpu);
+int kvm_pal_emul(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
+void kvm_sal_emul(struct kvm_vcpu *vcpu);
+
+#endif
diff --git a/include/asm-ia64/kvm_para.h b/include/asm-ia64/kvm_para.h
new file mode 100644
index 0000000..9f9796b
--- /dev/null
+++ b/include/asm-ia64/kvm_para.h
@@ -0,0 +1,29 @@
+#ifndef __IA64_KVM_PARA_H
+#define __IA64_KVM_PARA_H
+
+/*
+ * asm-ia64/kvm_para.h
+ *
+ * Copyright (C) 2007 Xiantao Zhang <xiantao.zhang@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
+ * Place - Suite 330, Boston, MA 02111-1307 USA.
+ *
+ */
+
+static inline unsigned int kvm_arch_para_features(void)
+{
+	return 0;
+}
+
+#endif
-- 
1.5.5

