Return-Path: <linux-kernel-owner+w=401wt.eu-S1761632AbYDUKjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761632AbYDUKjh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 06:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbYDUKal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 06:30:41 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:37889
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbYDUKaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 06:30:10 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Hollis Blanchard <hollisb@us.ibm.com>
Subject: [PATCH 23/31] KVM: ppc: PowerPC 440 KVM implementation
Date: Mon, 21 Apr 2008 13:29:49 +0300
Message-Id: <1208773797-7829-24-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208773797-7829-1-git-send-email-avi@qumranet.com>
References: <1208773797-7829-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hollis Blanchard <hollisb@us.ibm.com>

This functionality is definitely experimental, but is capable of running
unmodified PowerPC 440 Linux kernels as guests on a PowerPC 440 host. (Only
tested with 440EP "Bamboo" guests so far, but with appropriate userspace
support other SoC/board combinations should work.)

See Documentation/powerpc/kvm_440.txt for technical details.

Signed-off-by: Hollis Blanchard <hollisb@us.ibm.com>
Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 Documentation/powerpc/kvm_440.txt   |   41 ++
 arch/powerpc/Kconfig                |    1 +
 arch/powerpc/Kconfig.debug          |    3 +
 arch/powerpc/Makefile               |    1 +
 arch/powerpc/kernel/asm-offsets.c   |   26 ++
 arch/powerpc/kvm/44x_tlb.c          |  224 ++++++++++
 arch/powerpc/kvm/44x_tlb.h          |   91 +++++
 arch/powerpc/kvm/Kconfig            |   44 ++
 arch/powerpc/kvm/Makefile           |   15 +
 arch/powerpc/kvm/booke_guest.c      |  615 ++++++++++++++++++++++++++++
 arch/powerpc/kvm/booke_host.c       |   83 ++++
 arch/powerpc/kvm/booke_interrupts.S |  436 ++++++++++++++++++++
 arch/powerpc/kvm/emulate.c          |  760 +++++++++++++++++++++++++++++++++++
 arch/powerpc/kvm/powerpc.c          |  436 ++++++++++++++++++++
 include/asm-powerpc/kvm.h           |   53 +++-
 include/asm-powerpc/kvm_asm.h       |   55 +++
 include/asm-powerpc/kvm_host.h      |  152 +++++++
 include/asm-powerpc/kvm_para.h      |   38 ++
 include/asm-powerpc/kvm_ppc.h       |   88 ++++
 19 files changed, 3160 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/powerpc/kvm_440.txt
 create mode 100644 arch/powerpc/kvm/44x_tlb.c
 create mode 100644 arch/powerpc/kvm/44x_tlb.h
 create mode 100644 arch/powerpc/kvm/Kconfig
 create mode 100644 arch/powerpc/kvm/Makefile
 create mode 100644 arch/powerpc/kvm/booke_guest.c
 create mode 100644 arch/powerpc/kvm/booke_host.c
 create mode 100644 arch/powerpc/kvm/booke_interrupts.S
 create mode 100644 arch/powerpc/kvm/emulate.c
 create mode 100644 arch/powerpc/kvm/powerpc.c
 create mode 100644 include/asm-powerpc/kvm_asm.h
 create mode 100644 include/asm-powerpc/kvm_host.h
 create mode 100644 include/asm-powerpc/kvm_para.h
 create mode 100644 include/asm-powerpc/kvm_ppc.h

diff --git a/Documentation/powerpc/kvm_440.txt b/Documentation/powerpc/kvm_440.txt
new file mode 100644
index 0000000..c02a003
--- /dev/null
+++ b/Documentation/powerpc/kvm_440.txt
@@ -0,0 +1,41 @@
+Hollis Blanchard <hollisb@us.ibm.com>
+15 Apr 2008
+
+Various notes on the implementation of KVM for PowerPC 440:
+
+To enforce isolation, host userspace, guest kernel, and guest userspace all
+run at user privilege level. Only the host kernel runs in supervisor mode.
+Executing privileged instructions in the guest traps into KVM (in the host
+kernel), where we decode and emulate them. Through this technique, unmodified
+440 Linux kernels can be run (slowly) as guests. Future performance work will
+focus on reducing the overhead and frequency of these traps.
+
+The usual code flow is started from userspace invoking an "run" ioctl, which
+causes KVM to switch into guest context. We use IVPR to hijack the host
+interrupt vectors while running the guest, which allows us to direct all
+interrupts to kvmppc_handle_interrupt(). At this point, we could either
+- handle the interrupt completely (e.g. emulate "mtspr SPRG0"), or
+- let the host interrupt handler run (e.g. when the decrementer fires), or
+- return to host userspace (e.g. when the guest performs device MMIO)
+
+Address spaces: We take advantage of the fact that Linux doesn't use the AS=1
+address space (in host or guest), which gives us virtual address space to use
+for guest mappings. While the guest is running, the host kernel remains mapped
+in AS=0, but the guest can only use AS=1 mappings.
+
+TLB entries: The TLB entries covering the host linear mapping remain
+present while running the guest. This reduces the overhead of lightweight
+exits, which are handled by KVM running in the host kernel. We keep three
+copies of the TLB:
+ - guest TLB: contents of the TLB as the guest sees it
+ - shadow TLB: the TLB that is actually in hardware while guest is running
+ - host TLB: to restore TLB state when context switching guest -> host
+When a TLB miss occurs because a mapping was not present in the shadow TLB,
+but was present in the guest TLB, KVM handles the fault without invoking the
+guest. Large guest pages are backed by multiple 4KB shadow pages through this
+mechanism.
+
+IO: MMIO and DCR accesses are emulated by userspace. We use virtio for network
+and block IO, so those drivers must be enabled in the guest. It's possible
+that some qemu device emulation (e.g. e1000 or rtl8139) may also work with
+little effort.
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 1189d8d..c27ad5e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -722,3 +722,4 @@ config PPC_CLOCK
 config PPC_LIB_RHEAP
 	bool
 
+source "arch/powerpc/kvm/Kconfig"
diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index db7cc34..9aec870 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -151,6 +151,9 @@ config BOOTX_TEXT
 
 config PPC_EARLY_DEBUG
 	bool "Early debugging (dangerous)"
+	# PPC_EARLY_DEBUG on 440 leaves AS=1 mappings above the TLB high water
+	# mark, which doesn't work with current 440 KVM.
+	depends on !KVM
 	help
 	  Say Y to enable some early debugging facilities that may be available
 	  for your processor/board combination. Those facilities are hacks
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index ab5cfe8..6df2d6c 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -147,6 +147,7 @@ core-y				+= arch/powerpc/kernel/ \
 				   arch/powerpc/platforms/
 core-$(CONFIG_MATH_EMULATION)	+= arch/powerpc/math-emu/
 core-$(CONFIG_XMON)		+= arch/powerpc/xmon/
+core-$(CONFIG_KVM) 		+= arch/powerpc/kvm/
 
 drivers-$(CONFIG_OPROFILE)	+= arch/powerpc/oprofile/
 
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 4b749c4..f8088d2 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/suspend.h>
 #include <linux/hrtimer.h>
+#include <linux/kvm_host.h>
 #ifdef CONFIG_PPC64
 #include <linux/time.h>
 #include <linux/hardirq.h>
@@ -329,5 +330,30 @@ int main(void)
 
 	DEFINE(PGD_TABLE_SIZE, PGD_TABLE_SIZE);
 
+#ifdef CONFIG_KVM
+	DEFINE(TLBE_BYTES, sizeof(struct tlbe));
+
+	DEFINE(VCPU_HOST_STACK, offsetof(struct kvm_vcpu, arch.host_stack));
+	DEFINE(VCPU_HOST_PID, offsetof(struct kvm_vcpu, arch.host_pid));
+	DEFINE(VCPU_HOST_TLB, offsetof(struct kvm_vcpu, arch.host_tlb));
+	DEFINE(VCPU_SHADOW_TLB, offsetof(struct kvm_vcpu, arch.shadow_tlb));
+	DEFINE(VCPU_GPRS, offsetof(struct kvm_vcpu, arch.gpr));
+	DEFINE(VCPU_LR, offsetof(struct kvm_vcpu, arch.lr));
+	DEFINE(VCPU_CR, offsetof(struct kvm_vcpu, arch.cr));
+	DEFINE(VCPU_XER, offsetof(struct kvm_vcpu, arch.xer));
+	DEFINE(VCPU_CTR, offsetof(struct kvm_vcpu, arch.ctr));
+	DEFINE(VCPU_PC, offsetof(struct kvm_vcpu, arch.pc));
+	DEFINE(VCPU_MSR, offsetof(struct kvm_vcpu, arch.msr));
+	DEFINE(VCPU_SPRG4, offsetof(struct kvm_vcpu, arch.sprg4));
+	DEFINE(VCPU_SPRG5, offsetof(struct kvm_vcpu, arch.sprg5));
+	DEFINE(VCPU_SPRG6, offsetof(struct kvm_vcpu, arch.sprg6));
+	DEFINE(VCPU_SPRG7, offsetof(struct kvm_vcpu, arch.sprg7));
+	DEFINE(VCPU_PID, offsetof(struct kvm_vcpu, arch.pid));
+
+	DEFINE(VCPU_LAST_INST, offsetof(struct kvm_vcpu, arch.last_inst));
+	DEFINE(VCPU_FAULT_DEAR, offsetof(struct kvm_vcpu, arch.fault_dear));
+	DEFINE(VCPU_FAULT_ESR, offsetof(struct kvm_vcpu, arch.fault_esr));
+#endif
+
 	return 0;
 }
diff --git a/arch/powerpc/kvm/44x_tlb.c b/arch/powerpc/kvm/44x_tlb.c
new file mode 100644
index 0000000..f5d7a5e
--- /dev/null
+++ b/arch/powerpc/kvm/44x_tlb.c
@@ -0,0 +1,224 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2007
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/kvm_host.h>
+#include <linux/highmem.h>
+#include <asm/mmu-44x.h>
+#include <asm/kvm_ppc.h>
+
+#include "44x_tlb.h"
+
+#define PPC44x_TLB_USER_PERM_MASK (PPC44x_TLB_UX|PPC44x_TLB_UR|PPC44x_TLB_UW)
+#define PPC44x_TLB_SUPER_PERM_MASK (PPC44x_TLB_SX|PPC44x_TLB_SR|PPC44x_TLB_SW)
+
+static unsigned int kvmppc_tlb_44x_pos;
+
+static u32 kvmppc_44x_tlb_shadow_attrib(u32 attrib, int usermode)
+{
+	/* Mask off reserved bits. */
+	attrib &= PPC44x_TLB_PERM_MASK|PPC44x_TLB_ATTR_MASK;
+
+	if (!usermode) {
+		/* Guest is in supervisor mode, so we need to translate guest
+		 * supervisor permissions into user permissions. */
+		attrib &= ~PPC44x_TLB_USER_PERM_MASK;
+		attrib |= (attrib & PPC44x_TLB_SUPER_PERM_MASK) << 3;
+	}
+
+	/* Make sure host can always access this memory. */
+	attrib |= PPC44x_TLB_SX|PPC44x_TLB_SR|PPC44x_TLB_SW;
+
+	return attrib;
+}
+
+/* Search the guest TLB for a matching entry. */
+int kvmppc_44x_tlb_index(struct kvm_vcpu *vcpu, gva_t eaddr, unsigned int pid,
+                         unsigned int as)
+{
+	int i;
+
+	/* XXX Replace loop with fancy data structures. */
+	for (i = 0; i < PPC44x_TLB_SIZE; i++) {
+		struct tlbe *tlbe = &vcpu->arch.guest_tlb[i];
+		unsigned int tid;
+
+		if (eaddr < get_tlb_eaddr(tlbe))
+			continue;
+
+		if (eaddr > get_tlb_end(tlbe))
+			continue;
+
+		tid = get_tlb_tid(tlbe);
+		if (tid && (tid != pid))
+			continue;
+
+		if (!get_tlb_v(tlbe))
+			continue;
+
+		if (get_tlb_ts(tlbe) != as)
+			continue;
+
+		return i;
+	}
+
+	return -1;
+}
+
+struct tlbe *kvmppc_44x_itlb_search(struct kvm_vcpu *vcpu, gva_t eaddr)
+{
+	unsigned int as = !!(vcpu->arch.msr & MSR_IS);
+	unsigned int index;
+
+	index = kvmppc_44x_tlb_index(vcpu, eaddr, vcpu->arch.pid, as);
+	if (index == -1)
+		return NULL;
+	return &vcpu->arch.guest_tlb[index];
+}
+
+struct tlbe *kvmppc_44x_dtlb_search(struct kvm_vcpu *vcpu, gva_t eaddr)
+{
+	unsigned int as = !!(vcpu->arch.msr & MSR_DS);
+	unsigned int index;
+
+	index = kvmppc_44x_tlb_index(vcpu, eaddr, vcpu->arch.pid, as);
+	if (index == -1)
+		return NULL;
+	return &vcpu->arch.guest_tlb[index];
+}
+
+static int kvmppc_44x_tlbe_is_writable(struct tlbe *tlbe)
+{
+	return tlbe->word2 & (PPC44x_TLB_SW|PPC44x_TLB_UW);
+}
+
+/* Must be called with mmap_sem locked for writing. */
+static void kvmppc_44x_shadow_release(struct kvm_vcpu *vcpu,
+                                      unsigned int index)
+{
+	struct tlbe *stlbe = &vcpu->arch.shadow_tlb[index];
+	struct page *page = vcpu->arch.shadow_pages[index];
+
+	kunmap(vcpu->arch.shadow_pages[index]);
+
+	if (get_tlb_v(stlbe)) {
+		if (kvmppc_44x_tlbe_is_writable(stlbe))
+			kvm_release_page_dirty(page);
+		else
+			kvm_release_page_clean(page);
+	}
+}
+
+/* Caller must ensure that the specified guest TLB entry is safe to insert into
+ * the shadow TLB. */
+void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn, u64 asid,
+                    u32 flags)
+{
+	struct page *new_page;
+	struct tlbe *stlbe;
+	hpa_t hpaddr;
+	unsigned int victim;
+
+	/* Future optimization: don't overwrite the TLB entry containing the
+	 * current PC (or stack?). */
+	victim = kvmppc_tlb_44x_pos++;
+	if (kvmppc_tlb_44x_pos > tlb_44x_hwater)
+		kvmppc_tlb_44x_pos = 0;
+	stlbe = &vcpu->arch.shadow_tlb[victim];
+
+	/* Get reference to new page. */
+	down_write(&current->mm->mmap_sem);
+	new_page = gfn_to_page(vcpu->kvm, gfn);
+	if (is_error_page(new_page)) {
+		printk(KERN_ERR "Couldn't get guest page!\n");
+		kvm_release_page_clean(new_page);
+		return;
+	}
+	hpaddr = page_to_phys(new_page);
+
+	/* Drop reference to old page. */
+	kvmppc_44x_shadow_release(vcpu, victim);
+	up_write(&current->mm->mmap_sem);
+
+	vcpu->arch.shadow_pages[victim] = new_page;
+
+	/* XXX Make sure (va, size) doesn't overlap any other
+	 * entries. 440x6 user manual says the result would be
+	 * "undefined." */
+
+	/* XXX what about AS? */
+
+	stlbe->tid = asid & 0xff;
+
+	/* Force TS=1 for all guest mappings. */
+	/* For now we hardcode 4KB mappings, but it will be important to
+	 * use host large pages in the future. */
+	stlbe->word0 = (gvaddr & PAGE_MASK) | PPC44x_TLB_VALID | PPC44x_TLB_TS
+	               | PPC44x_TLB_4K;
+
+	stlbe->word1 = (hpaddr & 0xfffffc00) | ((hpaddr >> 32) & 0xf);
+	stlbe->word2 = kvmppc_44x_tlb_shadow_attrib(flags,
+	                                            vcpu->arch.msr & MSR_PR);
+}
+
+void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, u64 eaddr, u64 asid)
+{
+	unsigned int pid = asid & 0xff;
+	int i;
+
+	/* XXX Replace loop with fancy data structures. */
+	down_write(&current->mm->mmap_sem);
+	for (i = 0; i <= tlb_44x_hwater; i++) {
+		struct tlbe *stlbe = &vcpu->arch.shadow_tlb[i];
+		unsigned int tid;
+
+		if (!get_tlb_v(stlbe))
+			continue;
+
+		if (eaddr < get_tlb_eaddr(stlbe))
+			continue;
+
+		if (eaddr > get_tlb_end(stlbe))
+			continue;
+
+		tid = get_tlb_tid(stlbe);
+		if (tid && (tid != pid))
+			continue;
+
+		kvmppc_44x_shadow_release(vcpu, i);
+		stlbe->word0 = 0;
+	}
+	up_write(&current->mm->mmap_sem);
+}
+
+/* Invalidate all mappings, so that when they fault back in they will get the
+ * proper permission bits. */
+void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode)
+{
+	int i;
+
+	/* XXX Replace loop with fancy data structures. */
+	down_write(&current->mm->mmap_sem);
+	for (i = 0; i <= tlb_44x_hwater; i++) {
+		kvmppc_44x_shadow_release(vcpu, i);
+		vcpu->arch.shadow_tlb[i].word0 = 0;
+	}
+	up_write(&current->mm->mmap_sem);
+}
diff --git a/arch/powerpc/kvm/44x_tlb.h b/arch/powerpc/kvm/44x_tlb.h
new file mode 100644
index 0000000..2ccd46b
--- /dev/null
+++ b/arch/powerpc/kvm/44x_tlb.h
@@ -0,0 +1,91 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2007
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
+#ifndef __KVM_POWERPC_TLB_H__
+#define __KVM_POWERPC_TLB_H__
+
+#include <linux/kvm_host.h>
+#include <asm/mmu-44x.h>
+
+extern int kvmppc_44x_tlb_index(struct kvm_vcpu *vcpu, gva_t eaddr,
+                                unsigned int pid, unsigned int as);
+extern struct tlbe *kvmppc_44x_dtlb_search(struct kvm_vcpu *vcpu, gva_t eaddr);
+extern struct tlbe *kvmppc_44x_itlb_search(struct kvm_vcpu *vcpu, gva_t eaddr);
+
+/* TLB helper functions */
+static inline unsigned int get_tlb_size(const struct tlbe *tlbe)
+{
+	return (tlbe->word0 >> 4) & 0xf;
+}
+
+static inline gva_t get_tlb_eaddr(const struct tlbe *tlbe)
+{
+	return tlbe->word0 & 0xfffffc00;
+}
+
+static inline gva_t get_tlb_bytes(const struct tlbe *tlbe)
+{
+	unsigned int pgsize = get_tlb_size(tlbe);
+	return 1 << 10 << (pgsize << 1);
+}
+
+static inline gva_t get_tlb_end(const struct tlbe *tlbe)
+{
+	return get_tlb_eaddr(tlbe) + get_tlb_bytes(tlbe) - 1;
+}
+
+static inline u64 get_tlb_raddr(const struct tlbe *tlbe)
+{
+	u64 word1 = tlbe->word1;
+	return ((word1 & 0xf) << 32) | (word1 & 0xfffffc00);
+}
+
+static inline unsigned int get_tlb_tid(const struct tlbe *tlbe)
+{
+	return tlbe->tid & 0xff;
+}
+
+static inline unsigned int get_tlb_ts(const struct tlbe *tlbe)
+{
+	return (tlbe->word0 >> 8) & 0x1;
+}
+
+static inline unsigned int get_tlb_v(const struct tlbe *tlbe)
+{
+	return (tlbe->word0 >> 9) & 0x1;
+}
+
+static inline unsigned int get_mmucr_stid(const struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mmucr & 0xff;
+}
+
+static inline unsigned int get_mmucr_sts(const struct kvm_vcpu *vcpu)
+{
+	return (vcpu->arch.mmucr >> 16) & 0x1;
+}
+
+static inline gpa_t tlb_xlate(struct tlbe *tlbe, gva_t eaddr)
+{
+	unsigned int pgmask = get_tlb_bytes(tlbe) - 1;
+
+	return get_tlb_raddr(tlbe) | (eaddr & pgmask);
+}
+
+#endif /* __KVM_POWERPC_TLB_H__ */
diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
new file mode 100644
index 0000000..989ee82
--- /dev/null
+++ b/arch/powerpc/kvm/Kconfig
@@ -0,0 +1,44 @@
+#
+# KVM configuration
+#
+
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
+	---help---
+	  Say Y here to get to see options for using your Linux host to run
+	  other operating systems inside virtual machines (guests).
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and
+	  disabled.
+
+if VIRTUALIZATION
+
+config KVM
+	tristate "Kernel-based Virtual Machine (KVM) support"
+	depends on EXPERIMENTAL
+	select PREEMPT_NOTIFIERS
+	select ANON_INODES
+	---help---
+	  Support hosting virtualized guest machines. You will also
+	  need to select one or more of the processor modules below.
+
+	  This module provides access to the hardware capabilities through
+	  a character device node named /dev/kvm.
+
+	  To compile this as a module, choose M here: the module
+	  will be called kvm.
+
+	  If unsure, say N.
+
+config KVM_BOOKE_HOST
+	tristate "KVM host support for Book E PowerPC processors"
+	depends on KVM && 44x
+	---help---
+	  Provides host support for KVM on Book E PowerPC processors. Currently
+	  this works on 440 processors only.
+
+source drivers/virtio/Kconfig
+
+endif # VIRTUALIZATION
+
diff --git a/arch/powerpc/kvm/Makefile b/arch/powerpc/kvm/Makefile
new file mode 100644
index 0000000..d0d358d
--- /dev/null
+++ b/arch/powerpc/kvm/Makefile
@@ -0,0 +1,15 @@
+#
+# Makefile for Kernel-based Virtual Machine module
+#
+
+EXTRA_CFLAGS += -Ivirt/kvm -Iarch/powerpc/kvm
+
+common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o)
+
+kvm-objs := $(common-objs) powerpc.o emulate.o booke_guest.o
+obj-$(CONFIG_KVM) += kvm.o
+
+AFLAGS_booke_interrupts.o := -I$(obj)
+
+kvm-booke-host-objs := booke_host.o booke_interrupts.o 44x_tlb.o
+obj-$(CONFIG_KVM_BOOKE_HOST) += kvm-booke-host.o
diff --git a/arch/powerpc/kvm/booke_guest.c b/arch/powerpc/kvm/booke_guest.c
new file mode 100644
index 0000000..6d9884a
--- /dev/null
+++ b/arch/powerpc/kvm/booke_guest.c
@@ -0,0 +1,615 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2007
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ *          Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/fs.h>
+#include <asm/cputable.h>
+#include <asm/uaccess.h>
+#include <asm/kvm_ppc.h>
+
+#include "44x_tlb.h"
+
+#define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
+#define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
+
+struct kvm_stats_debugfs_item debugfs_entries[] = {
+	{ "exits",      VCPU_STAT(sum_exits) },
+	{ "mmio",       VCPU_STAT(mmio_exits) },
+	{ "dcr",        VCPU_STAT(dcr_exits) },
+	{ "sig",        VCPU_STAT(signal_exits) },
+	{ "light",      VCPU_STAT(light_exits) },
+	{ "itlb_r",     VCPU_STAT(itlb_real_miss_exits) },
+	{ "itlb_v",     VCPU_STAT(itlb_virt_miss_exits) },
+	{ "dtlb_r",     VCPU_STAT(dtlb_real_miss_exits) },
+	{ "dtlb_v",     VCPU_STAT(dtlb_virt_miss_exits) },
+	{ "sysc",       VCPU_STAT(syscall_exits) },
+	{ "isi",        VCPU_STAT(isi_exits) },
+	{ "dsi",        VCPU_STAT(dsi_exits) },
+	{ "inst_emu",   VCPU_STAT(emulated_inst_exits) },
+	{ "dec",        VCPU_STAT(dec_exits) },
+	{ "ext_intr",   VCPU_STAT(ext_intr_exits) },
+	{ NULL }
+};
+
+static const u32 interrupt_msr_mask[16] = {
+	[BOOKE_INTERRUPT_CRITICAL]      = MSR_ME,
+	[BOOKE_INTERRUPT_MACHINE_CHECK] = 0,
+	[BOOKE_INTERRUPT_DATA_STORAGE]  = MSR_CE|MSR_ME|MSR_DE,
+	[BOOKE_INTERRUPT_INST_STORAGE]  = MSR_CE|MSR_ME|MSR_DE,
+	[BOOKE_INTERRUPT_EXTERNAL]      = MSR_CE|MSR_ME|MSR_DE,
+	[BOOKE_INTERRUPT_ALIGNMENT]     = MSR_CE|MSR_ME|MSR_DE,
+	[BOOKE_INTERRUPT_PROGRAM]       = MSR_CE|MSR_ME|MSR_DE,
+	[BOOKE_INTERRUPT_FP_UNAVAIL]    = MSR_CE|MSR_ME|MSR_DE,
+	[BOOKE_INTERRUPT_SYSCALL]       = MSR_CE|MSR_ME|MSR_DE,
+	[BOOKE_INTERRUPT_AP_UNAVAIL]    = MSR_CE|MSR_ME|MSR_DE,
+	[BOOKE_INTERRUPT_DECREMENTER]   = MSR_CE|MSR_ME|MSR_DE,
+	[BOOKE_INTERRUPT_FIT]           = MSR_CE|MSR_ME|MSR_DE,
+	[BOOKE_INTERRUPT_WATCHDOG]      = MSR_ME,
+	[BOOKE_INTERRUPT_DTLB_MISS]     = MSR_CE|MSR_ME|MSR_DE,
+	[BOOKE_INTERRUPT_ITLB_MISS]     = MSR_CE|MSR_ME|MSR_DE,
+	[BOOKE_INTERRUPT_DEBUG]         = MSR_ME,
+};
+
+const unsigned char exception_priority[] = {
+	[BOOKE_INTERRUPT_DATA_STORAGE] = 0,
+	[BOOKE_INTERRUPT_INST_STORAGE] = 1,
+	[BOOKE_INTERRUPT_ALIGNMENT] = 2,
+	[BOOKE_INTERRUPT_PROGRAM] = 3,
+	[BOOKE_INTERRUPT_FP_UNAVAIL] = 4,
+	[BOOKE_INTERRUPT_SYSCALL] = 5,
+	[BOOKE_INTERRUPT_AP_UNAVAIL] = 6,
+	[BOOKE_INTERRUPT_DTLB_MISS] = 7,
+	[BOOKE_INTERRUPT_ITLB_MISS] = 8,
+	[BOOKE_INTERRUPT_MACHINE_CHECK] = 9,
+	[BOOKE_INTERRUPT_DEBUG] = 10,
+	[BOOKE_INTERRUPT_CRITICAL] = 11,
+	[BOOKE_INTERRUPT_WATCHDOG] = 12,
+	[BOOKE_INTERRUPT_EXTERNAL] = 13,
+	[BOOKE_INTERRUPT_FIT] = 14,
+	[BOOKE_INTERRUPT_DECREMENTER] = 15,
+};
+
+const unsigned char priority_exception[] = {
+	BOOKE_INTERRUPT_DATA_STORAGE,
+	BOOKE_INTERRUPT_INST_STORAGE,
+	BOOKE_INTERRUPT_ALIGNMENT,
+	BOOKE_INTERRUPT_PROGRAM,
+	BOOKE_INTERRUPT_FP_UNAVAIL,
+	BOOKE_INTERRUPT_SYSCALL,
+	BOOKE_INTERRUPT_AP_UNAVAIL,
+	BOOKE_INTERRUPT_DTLB_MISS,
+	BOOKE_INTERRUPT_ITLB_MISS,
+	BOOKE_INTERRUPT_MACHINE_CHECK,
+	BOOKE_INTERRUPT_DEBUG,
+	BOOKE_INTERRUPT_CRITICAL,
+	BOOKE_INTERRUPT_WATCHDOG,
+	BOOKE_INTERRUPT_EXTERNAL,
+	BOOKE_INTERRUPT_FIT,
+	BOOKE_INTERRUPT_DECREMENTER,
+};
+
+
+void kvmppc_dump_tlbs(struct kvm_vcpu *vcpu)
+{
+	struct tlbe *tlbe;
+	int i;
+
+	printk("vcpu %d TLB dump:\n", vcpu->vcpu_id);
+	printk("| %2s | %3s | %8s | %8s | %8s |\n",
+			"nr", "tid", "word0", "word1", "word2");
+
+	for (i = 0; i < PPC44x_TLB_SIZE; i++) {
+		tlbe = &vcpu->arch.guest_tlb[i];
+		if (tlbe->word0 & PPC44x_TLB_VALID)
+			printk(" G%2d |  %02X | %08X | %08X | %08X |\n",
+			       i, tlbe->tid, tlbe->word0, tlbe->word1,
+			       tlbe->word2);
+	}
+
+	for (i = 0; i < PPC44x_TLB_SIZE; i++) {
+		tlbe = &vcpu->arch.shadow_tlb[i];
+		if (tlbe->word0 & PPC44x_TLB_VALID)
+			printk(" S%2d | %02X | %08X | %08X | %08X |\n",
+			       i, tlbe->tid, tlbe->word0, tlbe->word1,
+			       tlbe->word2);
+	}
+}
+
+/* TODO: use vcpu_printf() */
+void kvmppc_dump_vcpu(struct kvm_vcpu *vcpu)
+{
+	int i;
+
+	printk("pc:   %08x msr:  %08x\n", vcpu->arch.pc, vcpu->arch.msr);
+	printk("lr:   %08x ctr:  %08x\n", vcpu->arch.lr, vcpu->arch.ctr);
+	printk("srr0: %08x srr1: %08x\n", vcpu->arch.srr0, vcpu->arch.srr1);
+
+	printk("exceptions: %08lx\n", vcpu->arch.pending_exceptions);
+
+	for (i = 0; i < 32; i += 4) {
+		printk("gpr%02d: %08x %08x %08x %08x\n", i,
+		       vcpu->arch.gpr[i],
+		       vcpu->arch.gpr[i+1],
+		       vcpu->arch.gpr[i+2],
+		       vcpu->arch.gpr[i+3]);
+	}
+}
+
+/* Check if we are ready to deliver the interrupt */
+static int kvmppc_can_deliver_interrupt(struct kvm_vcpu *vcpu, int interrupt)
+{
+	int r;
+
+	switch (interrupt) {
+	case BOOKE_INTERRUPT_CRITICAL:
+		r = vcpu->arch.msr & MSR_CE;
+		break;
+	case BOOKE_INTERRUPT_MACHINE_CHECK:
+		r = vcpu->arch.msr & MSR_ME;
+		break;
+	case BOOKE_INTERRUPT_EXTERNAL:
+		r = vcpu->arch.msr & MSR_EE;
+		break;
+	case BOOKE_INTERRUPT_DECREMENTER:
+		r = vcpu->arch.msr & MSR_EE;
+		break;
+	case BOOKE_INTERRUPT_FIT:
+		r = vcpu->arch.msr & MSR_EE;
+		break;
+	case BOOKE_INTERRUPT_WATCHDOG:
+		r = vcpu->arch.msr & MSR_CE;
+		break;
+	case BOOKE_INTERRUPT_DEBUG:
+		r = vcpu->arch.msr & MSR_DE;
+		break;
+	default:
+		r = 1;
+	}
+
+	return r;
+}
+
+static void kvmppc_deliver_interrupt(struct kvm_vcpu *vcpu, int interrupt)
+{
+	switch (interrupt) {
+	case BOOKE_INTERRUPT_DECREMENTER:
+		vcpu->arch.tsr |= TSR_DIS;
+		break;
+	}
+
+	vcpu->arch.srr0 = vcpu->arch.pc;
+	vcpu->arch.srr1 = vcpu->arch.msr;
+	vcpu->arch.pc = vcpu->arch.ivpr | vcpu->arch.ivor[interrupt];
+	kvmppc_set_msr(vcpu, vcpu->arch.msr & interrupt_msr_mask[interrupt]);
+}
+
+/* Check pending exceptions and deliver one, if possible. */
+void kvmppc_check_and_deliver_interrupts(struct kvm_vcpu *vcpu)
+{
+	unsigned long *pending = &vcpu->arch.pending_exceptions;
+	unsigned int exception;
+	unsigned int priority;
+
+	priority = find_first_bit(pending, BITS_PER_BYTE * sizeof(*pending));
+	while (priority <= BOOKE_MAX_INTERRUPT) {
+		exception = priority_exception[priority];
+		if (kvmppc_can_deliver_interrupt(vcpu, exception)) {
+			kvmppc_clear_exception(vcpu, exception);
+			kvmppc_deliver_interrupt(vcpu, exception);
+			break;
+		}
+
+		priority = find_next_bit(pending,
+		                         BITS_PER_BYTE * sizeof(*pending),
+		                         priority + 1);
+	}
+}
+
+static int kvmppc_emulate_mmio(struct kvm_run *run, struct kvm_vcpu *vcpu)
+{
+	enum emulation_result er;
+	int r;
+
+	er = kvmppc_emulate_instruction(run, vcpu);
+	switch (er) {
+	case EMULATE_DONE:
+		/* Future optimization: only reload non-volatiles if they were
+		 * actually modified. */
+		r = RESUME_GUEST_NV;
+		break;
+	case EMULATE_DO_MMIO:
+		run->exit_reason = KVM_EXIT_MMIO;
+		/* We must reload nonvolatiles because "update" load/store
+		 * instructions modify register state. */
+		/* Future optimization: only reload non-volatiles if they were
+		 * actually modified. */
+		r = RESUME_HOST_NV;
+		break;
+	case EMULATE_FAIL:
+		/* XXX Deliver Program interrupt to guest. */
+		printk(KERN_EMERG "%s: emulation failed (%08x)\n", __func__,
+		       vcpu->arch.last_inst);
+		r = RESUME_HOST;
+		break;
+	default:
+		BUG();
+	}
+
+	return r;
+}
+
+/**
+ * kvmppc_handle_exit
+ *
+ * Return value is in the form (errcode<<2 | RESUME_FLAG_HOST | RESUME_FLAG_NV)
+ */
+int kvmppc_handle_exit(struct kvm_run *run, struct kvm_vcpu *vcpu,
+                       unsigned int exit_nr)
+{
+	enum emulation_result er;
+	int r = RESUME_HOST;
+
+	local_irq_enable();
+
+	run->exit_reason = KVM_EXIT_UNKNOWN;
+	run->ready_for_interrupt_injection = 1;
+
+	switch (exit_nr) {
+	case BOOKE_INTERRUPT_MACHINE_CHECK:
+		printk("MACHINE CHECK: %lx\n", mfspr(SPRN_MCSR));
+		kvmppc_dump_vcpu(vcpu);
+		r = RESUME_HOST;
+		break;
+
+	case BOOKE_INTERRUPT_EXTERNAL:
+	case BOOKE_INTERRUPT_DECREMENTER:
+		/* Since we switched IVPR back to the host's value, the host
+		 * handled this interrupt the moment we enabled interrupts.
+		 * Now we just offer it a chance to reschedule the guest. */
+
+		/* XXX At this point the TLB still holds our shadow TLB, so if
+		 * we do reschedule the host will fault over it. Perhaps we
+		 * should politely restore the host's entries to minimize
+		 * misses before ceding control. */
+		if (need_resched())
+			cond_resched();
+		if (exit_nr == BOOKE_INTERRUPT_DECREMENTER)
+			vcpu->stat.dec_exits++;
+		else
+			vcpu->stat.ext_intr_exits++;
+		r = RESUME_GUEST;
+		break;
+
+	case BOOKE_INTERRUPT_PROGRAM:
+		if (vcpu->arch.msr & MSR_PR) {
+			/* Program traps generated by user-level software must be handled
+			 * by the guest kernel. */
+			vcpu->arch.esr = vcpu->arch.fault_esr;
+			kvmppc_queue_exception(vcpu, BOOKE_INTERRUPT_PROGRAM);
+			r = RESUME_GUEST;
+			break;
+		}
+
+		er = kvmppc_emulate_instruction(run, vcpu);
+		switch (er) {
+		case EMULATE_DONE:
+			/* Future optimization: only reload non-volatiles if
+			 * they were actually modified by emulation. */
+			vcpu->stat.emulated_inst_exits++;
+			r = RESUME_GUEST_NV;
+			break;
+		case EMULATE_DO_DCR:
+			run->exit_reason = KVM_EXIT_DCR;
+			r = RESUME_HOST;
+			break;
+		case EMULATE_FAIL:
+			/* XXX Deliver Program interrupt to guest. */
+			printk(KERN_CRIT "%s: emulation at %x failed (%08x)\n",
+			       __func__, vcpu->arch.pc, vcpu->arch.last_inst);
+			/* For debugging, encode the failing instruction and
+			 * report it to userspace. */
+			run->hw.hardware_exit_reason = ~0ULL << 32;
+			run->hw.hardware_exit_reason |= vcpu->arch.last_inst;
+			r = RESUME_HOST;
+			break;
+		default:
+			BUG();
+		}
+		break;
+
+	case BOOKE_INTERRUPT_DATA_STORAGE:
+		vcpu->arch.dear = vcpu->arch.fault_dear;
+		vcpu->arch.esr = vcpu->arch.fault_esr;
+		kvmppc_queue_exception(vcpu, exit_nr);
+		vcpu->stat.dsi_exits++;
+		r = RESUME_GUEST;
+		break;
+
+	case BOOKE_INTERRUPT_INST_STORAGE:
+		vcpu->arch.esr = vcpu->arch.fault_esr;
+		kvmppc_queue_exception(vcpu, exit_nr);
+		vcpu->stat.isi_exits++;
+		r = RESUME_GUEST;
+		break;
+
+	case BOOKE_INTERRUPT_SYSCALL:
+		kvmppc_queue_exception(vcpu, exit_nr);
+		vcpu->stat.syscall_exits++;
+		r = RESUME_GUEST;
+		break;
+
+	case BOOKE_INTERRUPT_DTLB_MISS: {
+		struct tlbe *gtlbe;
+		unsigned long eaddr = vcpu->arch.fault_dear;
+		gfn_t gfn;
+
+		/* Check the guest TLB. */
+		gtlbe = kvmppc_44x_dtlb_search(vcpu, eaddr);
+		if (!gtlbe) {
+			/* The guest didn't have a mapping for it. */
+			kvmppc_queue_exception(vcpu, exit_nr);
+			vcpu->arch.dear = vcpu->arch.fault_dear;
+			vcpu->arch.esr = vcpu->arch.fault_esr;
+			vcpu->stat.dtlb_real_miss_exits++;
+			r = RESUME_GUEST;
+			break;
+		}
+
+		vcpu->arch.paddr_accessed = tlb_xlate(gtlbe, eaddr);
+		gfn = vcpu->arch.paddr_accessed >> PAGE_SHIFT;
+
+		if (kvm_is_visible_gfn(vcpu->kvm, gfn)) {
+			/* The guest TLB had a mapping, but the shadow TLB
+			 * didn't, and it is RAM. This could be because:
+			 * a) the entry is mapping the host kernel, or
+			 * b) the guest used a large mapping which we're faking
+			 * Either way, we need to satisfy the fault without
+			 * invoking the guest. */
+			kvmppc_mmu_map(vcpu, eaddr, gfn, gtlbe->tid,
+			               gtlbe->word2);
+			vcpu->stat.dtlb_virt_miss_exits++;
+			r = RESUME_GUEST;
+		} else {
+			/* Guest has mapped and accessed a page which is not
+			 * actually RAM. */
+			r = kvmppc_emulate_mmio(run, vcpu);
+		}
+
+		break;
+	}
+
+	case BOOKE_INTERRUPT_ITLB_MISS: {
+		struct tlbe *gtlbe;
+		unsigned long eaddr = vcpu->arch.pc;
+		gfn_t gfn;
+
+		r = RESUME_GUEST;
+
+		/* Check the guest TLB. */
+		gtlbe = kvmppc_44x_itlb_search(vcpu, eaddr);
+		if (!gtlbe) {
+			/* The guest didn't have a mapping for it. */
+			kvmppc_queue_exception(vcpu, exit_nr);
+			vcpu->stat.itlb_real_miss_exits++;
+			break;
+		}
+
+		vcpu->stat.itlb_virt_miss_exits++;
+
+		gfn = tlb_xlate(gtlbe, eaddr) >> PAGE_SHIFT;
+
+		if (kvm_is_visible_gfn(vcpu->kvm, gfn)) {
+			/* The guest TLB had a mapping, but the shadow TLB
+			 * didn't. This could be because:
+			 * a) the entry is mapping the host kernel, or
+			 * b) the guest used a large mapping which we're faking
+			 * Either way, we need to satisfy the fault without
+			 * invoking the guest. */
+			kvmppc_mmu_map(vcpu, eaddr, gfn, gtlbe->tid,
+			               gtlbe->word2);
+		} else {
+			/* Guest mapped and leaped at non-RAM! */
+			kvmppc_queue_exception(vcpu,
+			                       BOOKE_INTERRUPT_MACHINE_CHECK);
+		}
+
+		break;
+	}
+
+	default:
+		printk(KERN_EMERG "exit_nr %d\n", exit_nr);
+		BUG();
+	}
+
+	local_irq_disable();
+
+	kvmppc_check_and_deliver_interrupts(vcpu);
+
+	/* Do some exit accounting. */
+	vcpu->stat.sum_exits++;
+	if (!(r & RESUME_HOST)) {
+		/* To avoid clobbering exit_reason, only check for signals if
+		 * we aren't already exiting to userspace for some other
+		 * reason. */
+		if (signal_pending(current)) {
+			run->exit_reason = KVM_EXIT_INTR;
+			r = (-EINTR << 2) | RESUME_HOST | (r & RESUME_FLAG_NV);
+
+			vcpu->stat.signal_exits++;
+		} else {
+			vcpu->stat.light_exits++;
+		}
+	} else {
+		switch (run->exit_reason) {
+		case KVM_EXIT_MMIO:
+			vcpu->stat.mmio_exits++;
+			break;
+		case KVM_EXIT_DCR:
+			vcpu->stat.dcr_exits++;
+			break;
+		case KVM_EXIT_INTR:
+			vcpu->stat.signal_exits++;
+			break;
+		}
+	}
+
+	return r;
+}
+
+/* Initial guest state: 16MB mapping 0 -> 0, PC = 0, MSR = 0, R1 = 16MB */
+int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
+{
+	struct tlbe *tlbe = &vcpu->arch.guest_tlb[0];
+
+	tlbe->tid = 0;
+	tlbe->word0 = PPC44x_TLB_16M | PPC44x_TLB_VALID;
+	tlbe->word1 = 0;
+	tlbe->word2 = PPC44x_TLB_SX | PPC44x_TLB_SW | PPC44x_TLB_SR;
+
+	tlbe++;
+	tlbe->tid = 0;
+	tlbe->word0 = 0xef600000 | PPC44x_TLB_4K | PPC44x_TLB_VALID;
+	tlbe->word1 = 0xef600000;
+	tlbe->word2 = PPC44x_TLB_SX | PPC44x_TLB_SW | PPC44x_TLB_SR
+	              | PPC44x_TLB_I | PPC44x_TLB_G;
+
+	vcpu->arch.pc = 0;
+	vcpu->arch.msr = 0;
+	vcpu->arch.gpr[1] = (16<<20) - 8; /* -8 for the callee-save LR slot */
+
+	/* Eye-catching number so we know if the guest takes an interrupt
+	 * before it's programmed its own IVPR. */
+	vcpu->arch.ivpr = 0x55550000;
+
+	/* Since the guest can directly access the timebase, it must know the
+	 * real timebase frequency. Accordingly, it must see the state of
+	 * CCR1[TCS]. */
+	vcpu->arch.ccr1 = mfspr(SPRN_CCR1);
+
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	int i;
+
+	regs->pc = vcpu->arch.pc;
+	regs->cr = vcpu->arch.cr;
+	regs->ctr = vcpu->arch.ctr;
+	regs->lr = vcpu->arch.lr;
+	regs->xer = vcpu->arch.xer;
+	regs->msr = vcpu->arch.msr;
+	regs->srr0 = vcpu->arch.srr0;
+	regs->srr1 = vcpu->arch.srr1;
+	regs->pid = vcpu->arch.pid;
+	regs->sprg0 = vcpu->arch.sprg0;
+	regs->sprg1 = vcpu->arch.sprg1;
+	regs->sprg2 = vcpu->arch.sprg2;
+	regs->sprg3 = vcpu->arch.sprg3;
+	regs->sprg5 = vcpu->arch.sprg4;
+	regs->sprg6 = vcpu->arch.sprg5;
+	regs->sprg7 = vcpu->arch.sprg6;
+
+	for (i = 0; i < ARRAY_SIZE(regs->gpr); i++)
+		regs->gpr[i] = vcpu->arch.gpr[i];
+
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	int i;
+
+	vcpu->arch.pc = regs->pc;
+	vcpu->arch.cr = regs->cr;
+	vcpu->arch.ctr = regs->ctr;
+	vcpu->arch.lr = regs->lr;
+	vcpu->arch.xer = regs->xer;
+	vcpu->arch.msr = regs->msr;
+	vcpu->arch.srr0 = regs->srr0;
+	vcpu->arch.srr1 = regs->srr1;
+	vcpu->arch.sprg0 = regs->sprg0;
+	vcpu->arch.sprg1 = regs->sprg1;
+	vcpu->arch.sprg2 = regs->sprg2;
+	vcpu->arch.sprg3 = regs->sprg3;
+	vcpu->arch.sprg5 = regs->sprg4;
+	vcpu->arch.sprg6 = regs->sprg5;
+	vcpu->arch.sprg7 = regs->sprg6;
+
+	for (i = 0; i < ARRAY_SIZE(vcpu->arch.gpr); i++)
+		vcpu->arch.gpr[i] = regs->gpr[i];
+
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
+                                  struct kvm_sregs *sregs)
+{
+	return -ENOTSUPP;
+}
+
+int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
+                                  struct kvm_sregs *sregs)
+{
+	return -ENOTSUPP;
+}
+
+int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	return -ENOTSUPP;
+}
+
+int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	return -ENOTSUPP;
+}
+
+/* 'linear_address' is actually an encoding of AS|PID|EADDR . */
+int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
+                                  struct kvm_translation *tr)
+{
+	struct tlbe *gtlbe;
+	int index;
+	gva_t eaddr;
+	u8 pid;
+	u8 as;
+
+	eaddr = tr->linear_address;
+	pid = (tr->linear_address >> 32) & 0xff;
+	as = (tr->linear_address >> 40) & 0x1;
+
+	index = kvmppc_44x_tlb_index(vcpu, eaddr, pid, as);
+	if (index == -1) {
+		tr->valid = 0;
+		return 0;
+	}
+
+	gtlbe = &vcpu->arch.guest_tlb[index];
+
+	tr->physical_address = tlb_xlate(gtlbe, eaddr);
+	/* XXX what does "writeable" and "usermode" even mean? */
+	tr->valid = 1;
+
+	return 0;
+}
diff --git a/arch/powerpc/kvm/booke_host.c b/arch/powerpc/kvm/booke_host.c
new file mode 100644
index 0000000..b480341
--- /dev/null
+++ b/arch/powerpc/kvm/booke_host.c
@@ -0,0 +1,83 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/kvm_host.h>
+#include <linux/module.h>
+#include <asm/cacheflush.h>
+#include <asm/kvm_ppc.h>
+
+unsigned long kvmppc_booke_handlers;
+
+static int kvmppc_booke_init(void)
+{
+	unsigned long ivor[16];
+	unsigned long max_ivor = 0;
+	int i;
+
+	/* We install our own exception handlers by hijacking IVPR. IVPR must
+	 * be 16-bit aligned, so we need a 64KB allocation. */
+	kvmppc_booke_handlers = __get_free_pages(GFP_KERNEL | __GFP_ZERO,
+	                                         VCPU_SIZE_ORDER);
+	if (!kvmppc_booke_handlers)
+		return -ENOMEM;
+
+	/* XXX make sure our handlers are smaller than Linux's */
+
+	/* Copy our interrupt handlers to match host IVORs. That way we don't
+	 * have to swap the IVORs on every guest/host transition. */
+	ivor[0] = mfspr(SPRN_IVOR0);
+	ivor[1] = mfspr(SPRN_IVOR1);
+	ivor[2] = mfspr(SPRN_IVOR2);
+	ivor[3] = mfspr(SPRN_IVOR3);
+	ivor[4] = mfspr(SPRN_IVOR4);
+	ivor[5] = mfspr(SPRN_IVOR5);
+	ivor[6] = mfspr(SPRN_IVOR6);
+	ivor[7] = mfspr(SPRN_IVOR7);
+	ivor[8] = mfspr(SPRN_IVOR8);
+	ivor[9] = mfspr(SPRN_IVOR9);
+	ivor[10] = mfspr(SPRN_IVOR10);
+	ivor[11] = mfspr(SPRN_IVOR11);
+	ivor[12] = mfspr(SPRN_IVOR12);
+	ivor[13] = mfspr(SPRN_IVOR13);
+	ivor[14] = mfspr(SPRN_IVOR14);
+	ivor[15] = mfspr(SPRN_IVOR15);
+
+	for (i = 0; i < 16; i++) {
+		if (ivor[i] > max_ivor)
+			max_ivor = ivor[i];
+
+		memcpy((void *)kvmppc_booke_handlers + ivor[i],
+		       kvmppc_handlers_start + i * kvmppc_handler_len,
+		       kvmppc_handler_len);
+	}
+	flush_icache_range(kvmppc_booke_handlers,
+	                   kvmppc_booke_handlers + max_ivor + kvmppc_handler_len);
+
+	return kvm_init(NULL, sizeof(struct kvm_vcpu), THIS_MODULE);
+}
+
+static void __exit kvmppc_booke_exit(void)
+{
+	free_pages(kvmppc_booke_handlers, VCPU_SIZE_ORDER);
+	kvm_exit();
+}
+
+module_init(kvmppc_booke_init)
+module_exit(kvmppc_booke_exit)
diff --git a/arch/powerpc/kvm/booke_interrupts.S b/arch/powerpc/kvm/booke_interrupts.S
new file mode 100644
index 0000000..3b653b5
--- /dev/null
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@ -0,0 +1,436 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2007
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
+#include <asm/ppc_asm.h>
+#include <asm/kvm_asm.h>
+#include <asm/reg.h>
+#include <asm/mmu-44x.h>
+#include <asm/page.h>
+#include <asm/asm-offsets.h>
+
+#define KVMPPC_MSR_MASK (MSR_CE|MSR_EE|MSR_PR|MSR_DE|MSR_ME|MSR_IS|MSR_DS)
+
+#define VCPU_GPR(n)     (VCPU_GPRS + (n * 4))
+
+/* The host stack layout: */
+#define HOST_R1         0 /* Implied by stwu. */
+#define HOST_CALLEE_LR  4
+#define HOST_RUN        8
+/* r2 is special: it holds 'current', and it made nonvolatile in the
+ * kernel with the -ffixed-r2 gcc option. */
+#define HOST_R2         12
+#define HOST_NV_GPRS    16
+#define HOST_NV_GPR(n)  (HOST_NV_GPRS + ((n - 14) * 4))
+#define HOST_MIN_STACK_SIZE (HOST_NV_GPR(31) + 4)
+#define HOST_STACK_SIZE (((HOST_MIN_STACK_SIZE + 15) / 16) * 16) /* Align. */
+#define HOST_STACK_LR   (HOST_STACK_SIZE + 4) /* In caller stack frame. */
+
+#define NEED_INST_MASK ((1<<BOOKE_INTERRUPT_PROGRAM) | \
+                        (1<<BOOKE_INTERRUPT_DTLB_MISS))
+
+#define NEED_DEAR_MASK ((1<<BOOKE_INTERRUPT_DATA_STORAGE) | \
+                        (1<<BOOKE_INTERRUPT_DTLB_MISS))
+
+#define NEED_ESR_MASK ((1<<BOOKE_INTERRUPT_DATA_STORAGE) | \
+                       (1<<BOOKE_INTERRUPT_INST_STORAGE) | \
+                       (1<<BOOKE_INTERRUPT_PROGRAM) | \
+                       (1<<BOOKE_INTERRUPT_DTLB_MISS))
+
+.macro KVM_HANDLER ivor_nr
+_GLOBAL(kvmppc_handler_\ivor_nr)
+	/* Get pointer to vcpu and record exit number. */
+	mtspr	SPRN_SPRG0, r4
+	mfspr	r4, SPRN_SPRG1
+	stw	r5, VCPU_GPR(r5)(r4)
+	stw	r6, VCPU_GPR(r6)(r4)
+	mfctr	r5
+	lis	r6, kvmppc_resume_host@h
+	stw	r5, VCPU_CTR(r4)
+	li	r5, \ivor_nr
+	ori	r6, r6, kvmppc_resume_host@l
+	mtctr	r6
+	bctr
+.endm
+
+_GLOBAL(kvmppc_handlers_start)
+KVM_HANDLER BOOKE_INTERRUPT_CRITICAL
+KVM_HANDLER BOOKE_INTERRUPT_MACHINE_CHECK
+KVM_HANDLER BOOKE_INTERRUPT_DATA_STORAGE
+KVM_HANDLER BOOKE_INTERRUPT_INST_STORAGE
+KVM_HANDLER BOOKE_INTERRUPT_EXTERNAL
+KVM_HANDLER BOOKE_INTERRUPT_ALIGNMENT
+KVM_HANDLER BOOKE_INTERRUPT_PROGRAM
+KVM_HANDLER BOOKE_INTERRUPT_FP_UNAVAIL
+KVM_HANDLER BOOKE_INTERRUPT_SYSCALL
+KVM_HANDLER BOOKE_INTERRUPT_AP_UNAVAIL
+KVM_HANDLER BOOKE_INTERRUPT_DECREMENTER
+KVM_HANDLER BOOKE_INTERRUPT_FIT
+KVM_HANDLER BOOKE_INTERRUPT_WATCHDOG
+KVM_HANDLER BOOKE_INTERRUPT_DTLB_MISS
+KVM_HANDLER BOOKE_INTERRUPT_ITLB_MISS
+KVM_HANDLER BOOKE_INTERRUPT_DEBUG
+
+_GLOBAL(kvmppc_handler_len)
+	.long kvmppc_handler_1 - kvmppc_handler_0
+
+
+/* Registers:
+ *  SPRG0: guest r4
+ *  r4: vcpu pointer
+ *  r5: KVM exit number
+ */
+_GLOBAL(kvmppc_resume_host)
+	stw	r3, VCPU_GPR(r3)(r4)
+	mfcr	r3
+	stw	r3, VCPU_CR(r4)
+	stw	r7, VCPU_GPR(r7)(r4)
+	stw	r8, VCPU_GPR(r8)(r4)
+	stw	r9, VCPU_GPR(r9)(r4)
+
+	li	r6, 1
+	slw	r6, r6, r5
+
+	/* Save the faulting instruction and all GPRs for emulation. */
+	andi.	r7, r6, NEED_INST_MASK
+	beq	..skip_inst_copy
+	mfspr	r9, SPRN_SRR0
+	mfmsr	r8
+	ori	r7, r8, MSR_DS
+	mtmsr	r7
+	isync
+	lwz	r9, 0(r9)
+	mtmsr	r8
+	isync
+	stw	r9, VCPU_LAST_INST(r4)
+
+	stw	r15, VCPU_GPR(r15)(r4)
+	stw	r16, VCPU_GPR(r16)(r4)
+	stw	r17, VCPU_GPR(r17)(r4)
+	stw	r18, VCPU_GPR(r18)(r4)
+	stw	r19, VCPU_GPR(r19)(r4)
+	stw	r20, VCPU_GPR(r20)(r4)
+	stw	r21, VCPU_GPR(r21)(r4)
+	stw	r22, VCPU_GPR(r22)(r4)
+	stw	r23, VCPU_GPR(r23)(r4)
+	stw	r24, VCPU_GPR(r24)(r4)
+	stw	r25, VCPU_GPR(r25)(r4)
+	stw	r26, VCPU_GPR(r26)(r4)
+	stw	r27, VCPU_GPR(r27)(r4)
+	stw	r28, VCPU_GPR(r28)(r4)
+	stw	r29, VCPU_GPR(r29)(r4)
+	stw	r30, VCPU_GPR(r30)(r4)
+	stw	r31, VCPU_GPR(r31)(r4)
+..skip_inst_copy:
+
+	/* Also grab DEAR and ESR before the host can clobber them. */
+
+	andi.	r7, r6, NEED_DEAR_MASK
+	beq	..skip_dear
+	mfspr	r9, SPRN_DEAR
+	stw	r9, VCPU_FAULT_DEAR(r4)
+..skip_dear:
+
+	andi.	r7, r6, NEED_ESR_MASK
+	beq	..skip_esr
+	mfspr	r9, SPRN_ESR
+	stw	r9, VCPU_FAULT_ESR(r4)
+..skip_esr:
+
+	/* Save remaining volatile guest register state to vcpu. */
+	stw	r0, VCPU_GPR(r0)(r4)
+	stw	r1, VCPU_GPR(r1)(r4)
+	stw	r2, VCPU_GPR(r2)(r4)
+	stw	r10, VCPU_GPR(r10)(r4)
+	stw	r11, VCPU_GPR(r11)(r4)
+	stw	r12, VCPU_GPR(r12)(r4)
+	stw	r13, VCPU_GPR(r13)(r4)
+	stw	r14, VCPU_GPR(r14)(r4) /* We need a NV GPR below. */
+	mflr	r3
+	stw	r3, VCPU_LR(r4)
+	mfxer	r3
+	stw	r3, VCPU_XER(r4)
+	mfspr	r3, SPRN_SPRG0
+	stw	r3, VCPU_GPR(r4)(r4)
+	mfspr	r3, SPRN_SRR0
+	stw	r3, VCPU_PC(r4)
+
+	/* Restore host stack pointer and PID before IVPR, since the host
+	 * exception handlers use them. */
+	lwz	r1, VCPU_HOST_STACK(r4)
+	lwz	r3, VCPU_HOST_PID(r4)
+	mtspr	SPRN_PID, r3
+
+	/* Restore host IVPR before re-enabling interrupts. We cheat and know
+	 * that Linux IVPR is always 0xc0000000. */
+	lis	r3, 0xc000
+	mtspr	SPRN_IVPR, r3
+
+	/* Switch to kernel stack and jump to handler. */
+	LOAD_REG_ADDR(r3, kvmppc_handle_exit)
+	mtctr	r3
+	lwz	r3, HOST_RUN(r1)
+	lwz	r2, HOST_R2(r1)
+	mr	r14, r4 /* Save vcpu pointer. */
+
+	bctrl	/* kvmppc_handle_exit() */
+
+	/* Restore vcpu pointer and the nonvolatiles we used. */
+	mr	r4, r14
+	lwz	r14, VCPU_GPR(r14)(r4)
+
+	/* Sometimes instruction emulation must restore complete GPR state. */
+	andi.	r5, r3, RESUME_FLAG_NV
+	beq	..skip_nv_load
+	lwz	r15, VCPU_GPR(r15)(r4)
+	lwz	r16, VCPU_GPR(r16)(r4)
+	lwz	r17, VCPU_GPR(r17)(r4)
+	lwz	r18, VCPU_GPR(r18)(r4)
+	lwz	r19, VCPU_GPR(r19)(r4)
+	lwz	r20, VCPU_GPR(r20)(r4)
+	lwz	r21, VCPU_GPR(r21)(r4)
+	lwz	r22, VCPU_GPR(r22)(r4)
+	lwz	r23, VCPU_GPR(r23)(r4)
+	lwz	r24, VCPU_GPR(r24)(r4)
+	lwz	r25, VCPU_GPR(r25)(r4)
+	lwz	r26, VCPU_GPR(r26)(r4)
+	lwz	r27, VCPU_GPR(r27)(r4)
+	lwz	r28, VCPU_GPR(r28)(r4)
+	lwz	r29, VCPU_GPR(r29)(r4)
+	lwz	r30, VCPU_GPR(r30)(r4)
+	lwz	r31, VCPU_GPR(r31)(r4)
+..skip_nv_load:
+
+	/* Should we return to the guest? */
+	andi.	r5, r3, RESUME_FLAG_HOST
+	beq	lightweight_exit
+
+	srawi	r3, r3, 2 /* Shift -ERR back down. */
+
+heavyweight_exit:
+	/* Not returning to guest. */
+
+	/* We already saved guest volatile register state; now save the
+	 * non-volatiles. */
+	stw	r15, VCPU_GPR(r15)(r4)
+	stw	r16, VCPU_GPR(r16)(r4)
+	stw	r17, VCPU_GPR(r17)(r4)
+	stw	r18, VCPU_GPR(r18)(r4)
+	stw	r19, VCPU_GPR(r19)(r4)
+	stw	r20, VCPU_GPR(r20)(r4)
+	stw	r21, VCPU_GPR(r21)(r4)
+	stw	r22, VCPU_GPR(r22)(r4)
+	stw	r23, VCPU_GPR(r23)(r4)
+	stw	r24, VCPU_GPR(r24)(r4)
+	stw	r25, VCPU_GPR(r25)(r4)
+	stw	r26, VCPU_GPR(r26)(r4)
+	stw	r27, VCPU_GPR(r27)(r4)
+	stw	r28, VCPU_GPR(r28)(r4)
+	stw	r29, VCPU_GPR(r29)(r4)
+	stw	r30, VCPU_GPR(r30)(r4)
+	stw	r31, VCPU_GPR(r31)(r4)
+
+	/* Load host non-volatile register state from host stack. */
+	lwz	r14, HOST_NV_GPR(r14)(r1)
+	lwz	r15, HOST_NV_GPR(r15)(r1)
+	lwz	r16, HOST_NV_GPR(r16)(r1)
+	lwz	r17, HOST_NV_GPR(r17)(r1)
+	lwz	r18, HOST_NV_GPR(r18)(r1)
+	lwz	r19, HOST_NV_GPR(r19)(r1)
+	lwz	r20, HOST_NV_GPR(r20)(r1)
+	lwz	r21, HOST_NV_GPR(r21)(r1)
+	lwz	r22, HOST_NV_GPR(r22)(r1)
+	lwz	r23, HOST_NV_GPR(r23)(r1)
+	lwz	r24, HOST_NV_GPR(r24)(r1)
+	lwz	r25, HOST_NV_GPR(r25)(r1)
+	lwz	r26, HOST_NV_GPR(r26)(r1)
+	lwz	r27, HOST_NV_GPR(r27)(r1)
+	lwz	r28, HOST_NV_GPR(r28)(r1)
+	lwz	r29, HOST_NV_GPR(r29)(r1)
+	lwz	r30, HOST_NV_GPR(r30)(r1)
+	lwz	r31, HOST_NV_GPR(r31)(r1)
+
+	/* Return to kvm_vcpu_run(). */
+	lwz	r4, HOST_STACK_LR(r1)
+	addi	r1, r1, HOST_STACK_SIZE
+	mtlr	r4
+	/* r3 still contains the return code from kvmppc_handle_exit(). */
+	blr
+
+
+/* Registers:
+ *  r3: kvm_run pointer
+ *  r4: vcpu pointer
+ */
+_GLOBAL(__kvmppc_vcpu_run)
+	stwu	r1, -HOST_STACK_SIZE(r1)
+	stw	r1, VCPU_HOST_STACK(r4)	/* Save stack pointer to vcpu. */
+
+	/* Save host state to stack. */
+	stw	r3, HOST_RUN(r1)
+	mflr	r3
+	stw	r3, HOST_STACK_LR(r1)
+
+	/* Save host non-volatile register state to stack. */
+	stw	r14, HOST_NV_GPR(r14)(r1)
+	stw	r15, HOST_NV_GPR(r15)(r1)
+	stw	r16, HOST_NV_GPR(r16)(r1)
+	stw	r17, HOST_NV_GPR(r17)(r1)
+	stw	r18, HOST_NV_GPR(r18)(r1)
+	stw	r19, HOST_NV_GPR(r19)(r1)
+	stw	r20, HOST_NV_GPR(r20)(r1)
+	stw	r21, HOST_NV_GPR(r21)(r1)
+	stw	r22, HOST_NV_GPR(r22)(r1)
+	stw	r23, HOST_NV_GPR(r23)(r1)
+	stw	r24, HOST_NV_GPR(r24)(r1)
+	stw	r25, HOST_NV_GPR(r25)(r1)
+	stw	r26, HOST_NV_GPR(r26)(r1)
+	stw	r27, HOST_NV_GPR(r27)(r1)
+	stw	r28, HOST_NV_GPR(r28)(r1)
+	stw	r29, HOST_NV_GPR(r29)(r1)
+	stw	r30, HOST_NV_GPR(r30)(r1)
+	stw	r31, HOST_NV_GPR(r31)(r1)
+
+	/* Load guest non-volatiles. */
+	lwz	r14, VCPU_GPR(r14)(r4)
+	lwz	r15, VCPU_GPR(r15)(r4)
+	lwz	r16, VCPU_GPR(r16)(r4)
+	lwz	r17, VCPU_GPR(r17)(r4)
+	lwz	r18, VCPU_GPR(r18)(r4)
+	lwz	r19, VCPU_GPR(r19)(r4)
+	lwz	r20, VCPU_GPR(r20)(r4)
+	lwz	r21, VCPU_GPR(r21)(r4)
+	lwz	r22, VCPU_GPR(r22)(r4)
+	lwz	r23, VCPU_GPR(r23)(r4)
+	lwz	r24, VCPU_GPR(r24)(r4)
+	lwz	r25, VCPU_GPR(r25)(r4)
+	lwz	r26, VCPU_GPR(r26)(r4)
+	lwz	r27, VCPU_GPR(r27)(r4)
+	lwz	r28, VCPU_GPR(r28)(r4)
+	lwz	r29, VCPU_GPR(r29)(r4)
+	lwz	r30, VCPU_GPR(r30)(r4)
+	lwz	r31, VCPU_GPR(r31)(r4)
+
+lightweight_exit:
+	stw	r2, HOST_R2(r1)
+
+	mfspr	r3, SPRN_PID
+	stw	r3, VCPU_HOST_PID(r4)
+	lwz	r3, VCPU_PID(r4)
+	mtspr	SPRN_PID, r3
+
+	/* Prevent all TLB updates. */
+	mfmsr	r5
+	lis	r6, (MSR_EE|MSR_CE|MSR_ME|MSR_DE)@h
+	ori	r6, r6, (MSR_EE|MSR_CE|MSR_ME|MSR_DE)@l
+	andc	r6, r5, r6
+	mtmsr	r6
+
+	/* Save the host's non-pinned TLB mappings, and load the guest mappings
+	 * over them. Leave the host's "pinned" kernel mappings in place. */
+	/* XXX optimization: use generation count to avoid swapping unmodified
+	 * entries. */
+	mfspr	r10, SPRN_MMUCR			/* Save host MMUCR. */
+	lis	r8, tlb_44x_hwater@ha
+	lwz	r8, tlb_44x_hwater@l(r8)
+	addi	r3, r4, VCPU_HOST_TLB - 4
+	addi	r9, r4, VCPU_SHADOW_TLB - 4
+	li	r6, 0
+1:
+	/* Save host entry. */
+	tlbre	r7, r6, PPC44x_TLB_PAGEID
+	mfspr	r5, SPRN_MMUCR
+	stwu	r5, 4(r3)
+	stwu	r7, 4(r3)
+	tlbre	r7, r6, PPC44x_TLB_XLAT
+	stwu	r7, 4(r3)
+	tlbre	r7, r6, PPC44x_TLB_ATTRIB
+	stwu	r7, 4(r3)
+	/* Load guest entry. */
+	lwzu	r7, 4(r9)
+	mtspr	SPRN_MMUCR, r7
+	lwzu	r7, 4(r9)
+	tlbwe	r7, r6, PPC44x_TLB_PAGEID
+	lwzu	r7, 4(r9)
+	tlbwe	r7, r6, PPC44x_TLB_XLAT
+	lwzu	r7, 4(r9)
+	tlbwe	r7, r6, PPC44x_TLB_ATTRIB
+	/* Increment index. */
+	addi	r6, r6, 1
+	cmpw	r6, r8
+	blt	1b
+	mtspr	SPRN_MMUCR, r10			/* Restore host MMUCR. */
+
+	iccci	0, 0 /* XXX hack */
+
+	/* Load some guest volatiles. */
+	lwz	r0, VCPU_GPR(r0)(r4)
+	lwz	r2, VCPU_GPR(r2)(r4)
+	lwz	r9, VCPU_GPR(r9)(r4)
+	lwz	r10, VCPU_GPR(r10)(r4)
+	lwz	r11, VCPU_GPR(r11)(r4)
+	lwz	r12, VCPU_GPR(r12)(r4)
+	lwz	r13, VCPU_GPR(r13)(r4)
+	lwz	r3, VCPU_LR(r4)
+	mtlr	r3
+	lwz	r3, VCPU_XER(r4)
+	mtxer	r3
+
+	/* Switch the IVPR. XXX If we take a TLB miss after this we're screwed,
+	 * so how do we make sure vcpu won't fault? */
+	lis	r8, kvmppc_booke_handlers@ha
+	lwz	r8, kvmppc_booke_handlers@l(r8)
+	mtspr	SPRN_IVPR, r8
+
+	/* Save vcpu pointer for the exception handlers. */
+	mtspr	SPRN_SPRG1, r4
+
+	/* Can't switch the stack pointer until after IVPR is switched,
+	 * because host interrupt handlers would get confused. */
+	lwz	r1, VCPU_GPR(r1)(r4)
+
+	/* XXX handle USPRG0 */
+	/* Host interrupt handlers may have clobbered these guest-readable
+	 * SPRGs, so we need to reload them here with the guest's values. */
+	lwz	r3, VCPU_SPRG4(r4)
+	mtspr	SPRN_SPRG4, r3
+	lwz	r3, VCPU_SPRG5(r4)
+	mtspr	SPRN_SPRG5, r3
+	lwz	r3, VCPU_SPRG6(r4)
+	mtspr	SPRN_SPRG6, r3
+	lwz	r3, VCPU_SPRG7(r4)
+	mtspr	SPRN_SPRG7, r3
+
+	/* Finish loading guest volatiles and jump to guest. */
+	lwz	r3, VCPU_CTR(r4)
+	mtctr	r3
+	lwz	r3, VCPU_CR(r4)
+	mtcr	r3
+	lwz	r5, VCPU_GPR(r5)(r4)
+	lwz	r6, VCPU_GPR(r6)(r4)
+	lwz	r7, VCPU_GPR(r7)(r4)
+	lwz	r8, VCPU_GPR(r8)(r4)
+	lwz	r3, VCPU_PC(r4)
+	mtsrr0	r3
+	lwz	r3, VCPU_MSR(r4)
+	oris	r3, r3, KVMPPC_MSR_MASK@h
+	ori	r3, r3, KVMPPC_MSR_MASK@l
+	mtsrr1	r3
+	lwz	r3, VCPU_GPR(r3)(r4)
+	lwz	r4, VCPU_GPR(r4)(r4)
+	rfi
diff --git a/arch/powerpc/kvm/emulate.c b/arch/powerpc/kvm/emulate.c
new file mode 100644
index 0000000..a03fe0c
--- /dev/null
+++ b/arch/powerpc/kvm/emulate.c
@@ -0,0 +1,760 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2007
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
+#include <linux/jiffies.h>
+#include <linux/timer.h>
+#include <linux/types.h>
+#include <linux/string.h>
+#include <linux/kvm_host.h>
+
+#include <asm/dcr.h>
+#include <asm/dcr-regs.h>
+#include <asm/time.h>
+#include <asm/byteorder.h>
+#include <asm/kvm_ppc.h>
+
+#include "44x_tlb.h"
+
+/* Instruction decoding */
+static inline unsigned int get_op(u32 inst)
+{
+	return inst >> 26;
+}
+
+static inline unsigned int get_xop(u32 inst)
+{
+	return (inst >> 1) & 0x3ff;
+}
+
+static inline unsigned int get_sprn(u32 inst)
+{
+	return ((inst >> 16) & 0x1f) | ((inst >> 6) & 0x3e0);
+}
+
+static inline unsigned int get_dcrn(u32 inst)
+{
+	return ((inst >> 16) & 0x1f) | ((inst >> 6) & 0x3e0);
+}
+
+static inline unsigned int get_rt(u32 inst)
+{
+	return (inst >> 21) & 0x1f;
+}
+
+static inline unsigned int get_rs(u32 inst)
+{
+	return (inst >> 21) & 0x1f;
+}
+
+static inline unsigned int get_ra(u32 inst)
+{
+	return (inst >> 16) & 0x1f;
+}
+
+static inline unsigned int get_rb(u32 inst)
+{
+	return (inst >> 11) & 0x1f;
+}
+
+static inline unsigned int get_rc(u32 inst)
+{
+	return inst & 0x1;
+}
+
+static inline unsigned int get_ws(u32 inst)
+{
+	return (inst >> 11) & 0x1f;
+}
+
+static inline unsigned int get_d(u32 inst)
+{
+	return inst & 0xffff;
+}
+
+static int tlbe_is_host_safe(const struct kvm_vcpu *vcpu,
+                             const struct tlbe *tlbe)
+{
+	gpa_t gpa;
+
+	if (!get_tlb_v(tlbe))
+		return 0;
+
+	/* Does it match current guest AS? */
+	/* XXX what about IS != DS? */
+	if (get_tlb_ts(tlbe) != !!(vcpu->arch.msr & MSR_IS))
+		return 0;
+
+	gpa = get_tlb_raddr(tlbe);
+	if (!gfn_to_memslot(vcpu->kvm, gpa >> PAGE_SHIFT))
+		/* Mapping is not for RAM. */
+		return 0;
+
+	return 1;
+}
+
+static int kvmppc_emul_tlbwe(struct kvm_vcpu *vcpu, u32 inst)
+{
+	u64 eaddr;
+	u64 raddr;
+	u64 asid;
+	u32 flags;
+	struct tlbe *tlbe;
+	unsigned int ra;
+	unsigned int rs;
+	unsigned int ws;
+	unsigned int index;
+
+	ra = get_ra(inst);
+	rs = get_rs(inst);
+	ws = get_ws(inst);
+
+	index = vcpu->arch.gpr[ra];
+	if (index > PPC44x_TLB_SIZE) {
+		printk("%s: index %d\n", __func__, index);
+		kvmppc_dump_vcpu(vcpu);
+		return EMULATE_FAIL;
+	}
+
+	tlbe = &vcpu->arch.guest_tlb[index];
+
+	/* Invalidate shadow mappings for the about-to-be-clobbered TLBE. */
+	if (tlbe->word0 & PPC44x_TLB_VALID) {
+		eaddr = get_tlb_eaddr(tlbe);
+		asid = (tlbe->word0 & PPC44x_TLB_TS) | tlbe->tid;
+		kvmppc_mmu_invalidate(vcpu, eaddr, asid);
+	}
+
+	switch (ws) {
+	case PPC44x_TLB_PAGEID:
+		tlbe->tid = vcpu->arch.mmucr & 0xff;
+		tlbe->word0 = vcpu->arch.gpr[rs];
+		break;
+
+	case PPC44x_TLB_XLAT:
+		tlbe->word1 = vcpu->arch.gpr[rs];
+		break;
+
+	case PPC44x_TLB_ATTRIB:
+		tlbe->word2 = vcpu->arch.gpr[rs];
+		break;
+
+	default:
+		return EMULATE_FAIL;
+	}
+
+	if (tlbe_is_host_safe(vcpu, tlbe)) {
+		eaddr = get_tlb_eaddr(tlbe);
+		raddr = get_tlb_raddr(tlbe);
+		asid = (tlbe->word0 & PPC44x_TLB_TS) | tlbe->tid;
+		flags = tlbe->word2 & 0xffff;
+
+		/* Create a 4KB mapping on the host. If the guest wanted a
+		 * large page, only the first 4KB is mapped here and the rest
+		 * are mapped on the fly. */
+		kvmppc_mmu_map(vcpu, eaddr, raddr >> PAGE_SHIFT, asid, flags);
+	}
+
+	return EMULATE_DONE;
+}
+
+static void kvmppc_emulate_dec(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.tcr & TCR_DIE) {
+		/* The decrementer ticks at the same rate as the timebase, so
+		 * that's how we convert the guest DEC value to the number of
+		 * host ticks. */
+		unsigned long nr_jiffies;
+
+		nr_jiffies = vcpu->arch.dec / tb_ticks_per_jiffy;
+		mod_timer(&vcpu->arch.dec_timer,
+		          get_jiffies_64() + nr_jiffies);
+	} else {
+		del_timer(&vcpu->arch.dec_timer);
+	}
+}
+
+static void kvmppc_emul_rfi(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.pc = vcpu->arch.srr0;
+	kvmppc_set_msr(vcpu, vcpu->arch.srr1);
+}
+
+/* XXX to do:
+ * lhax
+ * lhaux
+ * lswx
+ * lswi
+ * stswx
+ * stswi
+ * lha
+ * lhau
+ * lmw
+ * stmw
+ *
+ * XXX is_bigendian should depend on MMU mapping or MSR[LE]
+ */
+int kvmppc_emulate_instruction(struct kvm_run *run, struct kvm_vcpu *vcpu)
+{
+	u32 inst = vcpu->arch.last_inst;
+	u32 ea;
+	int ra;
+	int rb;
+	int rc;
+	int rs;
+	int rt;
+	int sprn;
+	int dcrn;
+	enum emulation_result emulated = EMULATE_DONE;
+	int advance = 1;
+
+	switch (get_op(inst)) {
+	case 3:                                                 /* trap */
+		printk("trap!\n");
+		kvmppc_queue_exception(vcpu, BOOKE_INTERRUPT_PROGRAM);
+		advance = 0;
+		break;
+
+	case 19:
+		switch (get_xop(inst)) {
+		case 50:                                        /* rfi */
+			kvmppc_emul_rfi(vcpu);
+			advance = 0;
+			break;
+
+		default:
+			emulated = EMULATE_FAIL;
+			break;
+		}
+		break;
+
+	case 31:
+		switch (get_xop(inst)) {
+
+		case 83:                                        /* mfmsr */
+			rt = get_rt(inst);
+			vcpu->arch.gpr[rt] = vcpu->arch.msr;
+			break;
+
+		case 87:                                        /* lbzx */
+			rt = get_rt(inst);
+			emulated = kvmppc_handle_load(run, vcpu, rt, 1, 1);
+			break;
+
+		case 131:                                       /* wrtee */
+			rs = get_rs(inst);
+			vcpu->arch.msr = (vcpu->arch.msr & ~MSR_EE)
+			                 | (vcpu->arch.gpr[rs] & MSR_EE);
+			break;
+
+		case 146:                                       /* mtmsr */
+			rs = get_rs(inst);
+			kvmppc_set_msr(vcpu, vcpu->arch.gpr[rs]);
+			break;
+
+		case 163:                                       /* wrteei */
+			vcpu->arch.msr = (vcpu->arch.msr & ~MSR_EE)
+			                 | (inst & MSR_EE);
+			break;
+
+		case 215:                                       /* stbx */
+			rs = get_rs(inst);
+			emulated = kvmppc_handle_store(run, vcpu,
+			                               vcpu->arch.gpr[rs],
+			                               1, 1);
+			break;
+
+		case 247:                                       /* stbux */
+			rs = get_rs(inst);
+			ra = get_ra(inst);
+			rb = get_rb(inst);
+
+			ea = vcpu->arch.gpr[rb];
+			if (ra)
+				ea += vcpu->arch.gpr[ra];
+
+			emulated = kvmppc_handle_store(run, vcpu,
+			                               vcpu->arch.gpr[rs],
+			                               1, 1);
+			vcpu->arch.gpr[rs] = ea;
+			break;
+
+		case 279:                                       /* lhzx */
+			rt = get_rt(inst);
+			emulated = kvmppc_handle_load(run, vcpu, rt, 2, 1);
+			break;
+
+		case 311:                                       /* lhzux */
+			rt = get_rt(inst);
+			ra = get_ra(inst);
+			rb = get_rb(inst);
+
+			ea = vcpu->arch.gpr[rb];
+			if (ra)
+				ea += vcpu->arch.gpr[ra];
+
+			emulated = kvmppc_handle_load(run, vcpu, rt, 2, 1);
+			vcpu->arch.gpr[ra] = ea;
+			break;
+
+		case 323:                                       /* mfdcr */
+			dcrn = get_dcrn(inst);
+			rt = get_rt(inst);
+
+			/* The guest may access CPR0 registers to determine the timebase
+			 * frequency, and it must know the real host frequency because it
+			 * can directly access the timebase registers.
+			 *
+			 * It would be possible to emulate those accesses in userspace,
+			 * but userspace can really only figure out the end frequency.
+			 * We could decompose that into the factors that compute it, but
+			 * that's tricky math, and it's easier to just report the real
+			 * CPR0 values.
+			 */
+			switch (dcrn) {
+			case DCRN_CPR0_CONFIG_ADDR:
+				vcpu->arch.gpr[rt] = vcpu->arch.cpr0_cfgaddr;
+				break;
+			case DCRN_CPR0_CONFIG_DATA:
+				local_irq_disable();
+				mtdcr(DCRN_CPR0_CONFIG_ADDR,
+				      vcpu->arch.cpr0_cfgaddr);
+				vcpu->arch.gpr[rt] = mfdcr(DCRN_CPR0_CONFIG_DATA);
+				local_irq_enable();
+				break;
+			default:
+				run->dcr.dcrn = dcrn;
+				run->dcr.data =  0;
+				run->dcr.is_write = 0;
+				vcpu->arch.io_gpr = rt;
+				vcpu->arch.dcr_needed = 1;
+				emulated = EMULATE_DO_DCR;
+			}
+
+			break;
+
+		case 339:                                       /* mfspr */
+			sprn = get_sprn(inst);
+			rt = get_rt(inst);
+
+			switch (sprn) {
+			case SPRN_SRR0:
+				vcpu->arch.gpr[rt] = vcpu->arch.srr0; break;
+			case SPRN_SRR1:
+				vcpu->arch.gpr[rt] = vcpu->arch.srr1; break;
+			case SPRN_MMUCR:
+				vcpu->arch.gpr[rt] = vcpu->arch.mmucr; break;
+			case SPRN_PID:
+				vcpu->arch.gpr[rt] = vcpu->arch.pid; break;
+			case SPRN_IVPR:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivpr; break;
+			case SPRN_CCR0:
+				vcpu->arch.gpr[rt] = vcpu->arch.ccr0; break;
+			case SPRN_CCR1:
+				vcpu->arch.gpr[rt] = vcpu->arch.ccr1; break;
+			case SPRN_PVR:
+				vcpu->arch.gpr[rt] = vcpu->arch.pvr; break;
+			case SPRN_DEAR:
+				vcpu->arch.gpr[rt] = vcpu->arch.dear; break;
+			case SPRN_ESR:
+				vcpu->arch.gpr[rt] = vcpu->arch.esr; break;
+			case SPRN_DBCR0:
+				vcpu->arch.gpr[rt] = vcpu->arch.dbcr0; break;
+			case SPRN_DBCR1:
+				vcpu->arch.gpr[rt] = vcpu->arch.dbcr1; break;
+
+			/* Note: mftb and TBRL/TBWL are user-accessible, so
+			 * the guest can always access the real TB anyways.
+			 * In fact, we probably will never see these traps. */
+			case SPRN_TBWL:
+				vcpu->arch.gpr[rt] = mftbl(); break;
+			case SPRN_TBWU:
+				vcpu->arch.gpr[rt] = mftbu(); break;
+
+			case SPRN_SPRG0:
+				vcpu->arch.gpr[rt] = vcpu->arch.sprg0; break;
+			case SPRN_SPRG1:
+				vcpu->arch.gpr[rt] = vcpu->arch.sprg1; break;
+			case SPRN_SPRG2:
+				vcpu->arch.gpr[rt] = vcpu->arch.sprg2; break;
+			case SPRN_SPRG3:
+				vcpu->arch.gpr[rt] = vcpu->arch.sprg3; break;
+			/* Note: SPRG4-7 are user-readable, so we don't get
+			 * a trap. */
+
+			case SPRN_IVOR0:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[0]; break;
+			case SPRN_IVOR1:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[1]; break;
+			case SPRN_IVOR2:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[2]; break;
+			case SPRN_IVOR3:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[3]; break;
+			case SPRN_IVOR4:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[4]; break;
+			case SPRN_IVOR5:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[5]; break;
+			case SPRN_IVOR6:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[6]; break;
+			case SPRN_IVOR7:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[7]; break;
+			case SPRN_IVOR8:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[8]; break;
+			case SPRN_IVOR9:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[9]; break;
+			case SPRN_IVOR10:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[10]; break;
+			case SPRN_IVOR11:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[11]; break;
+			case SPRN_IVOR12:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[12]; break;
+			case SPRN_IVOR13:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[13]; break;
+			case SPRN_IVOR14:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[14]; break;
+			case SPRN_IVOR15:
+				vcpu->arch.gpr[rt] = vcpu->arch.ivor[15]; break;
+
+			default:
+				printk("mfspr: unknown spr %x\n", sprn);
+				vcpu->arch.gpr[rt] = 0;
+				break;
+			}
+			break;
+
+		case 407:                                       /* sthx */
+			rs = get_rs(inst);
+			ra = get_ra(inst);
+			rb = get_rb(inst);
+
+			emulated = kvmppc_handle_store(run, vcpu,
+			                               vcpu->arch.gpr[rs],
+			                               2, 1);
+			break;
+
+		case 439:                                       /* sthux */
+			rs = get_rs(inst);
+			ra = get_ra(inst);
+			rb = get_rb(inst);
+
+			ea = vcpu->arch.gpr[rb];
+			if (ra)
+				ea += vcpu->arch.gpr[ra];
+
+			emulated = kvmppc_handle_store(run, vcpu,
+			                               vcpu->arch.gpr[rs],
+			                               2, 1);
+			vcpu->arch.gpr[ra] = ea;
+			break;
+
+		case 451:                                       /* mtdcr */
+			dcrn = get_dcrn(inst);
+			rs = get_rs(inst);
+
+			/* emulate some access in kernel */
+			switch (dcrn) {
+			case DCRN_CPR0_CONFIG_ADDR:
+				vcpu->arch.cpr0_cfgaddr = vcpu->arch.gpr[rs];
+				break;
+			default:
+				run->dcr.dcrn = dcrn;
+				run->dcr.data = vcpu->arch.gpr[rs];
+				run->dcr.is_write = 1;
+				vcpu->arch.dcr_needed = 1;
+				emulated = EMULATE_DO_DCR;
+			}
+
+			break;
+
+		case 467:                                       /* mtspr */
+			sprn = get_sprn(inst);
+			rs = get_rs(inst);
+			switch (sprn) {
+			case SPRN_SRR0:
+				vcpu->arch.srr0 = vcpu->arch.gpr[rs]; break;
+			case SPRN_SRR1:
+				vcpu->arch.srr1 = vcpu->arch.gpr[rs]; break;
+			case SPRN_MMUCR:
+				vcpu->arch.mmucr = vcpu->arch.gpr[rs]; break;
+			case SPRN_PID:
+				vcpu->arch.pid = vcpu->arch.gpr[rs]; break;
+			case SPRN_CCR0:
+				vcpu->arch.ccr0 = vcpu->arch.gpr[rs]; break;
+			case SPRN_CCR1:
+				vcpu->arch.ccr1 = vcpu->arch.gpr[rs]; break;
+			case SPRN_DEAR:
+				vcpu->arch.dear = vcpu->arch.gpr[rs]; break;
+			case SPRN_ESR:
+				vcpu->arch.esr = vcpu->arch.gpr[rs]; break;
+			case SPRN_DBCR0:
+				vcpu->arch.dbcr0 = vcpu->arch.gpr[rs]; break;
+			case SPRN_DBCR1:
+				vcpu->arch.dbcr1 = vcpu->arch.gpr[rs]; break;
+
+			/* XXX We need to context-switch the timebase for
+			 * watchdog and FIT. */
+			case SPRN_TBWL: break;
+			case SPRN_TBWU: break;
+
+			case SPRN_DEC:
+				vcpu->arch.dec = vcpu->arch.gpr[rs];
+				kvmppc_emulate_dec(vcpu);
+				break;
+
+			case SPRN_TSR:
+				vcpu->arch.tsr &= ~vcpu->arch.gpr[rs]; break;
+
+			case SPRN_TCR:
+				vcpu->arch.tcr = vcpu->arch.gpr[rs];
+				kvmppc_emulate_dec(vcpu);
+				break;
+
+			case SPRN_SPRG0:
+				vcpu->arch.sprg0 = vcpu->arch.gpr[rs]; break;
+			case SPRN_SPRG1:
+				vcpu->arch.sprg1 = vcpu->arch.gpr[rs]; break;
+			case SPRN_SPRG2:
+				vcpu->arch.sprg2 = vcpu->arch.gpr[rs]; break;
+			case SPRN_SPRG3:
+				vcpu->arch.sprg3 = vcpu->arch.gpr[rs]; break;
+
+			/* Note: SPRG4-7 are user-readable. These values are
+			 * loaded into the real SPRGs when resuming the
+			 * guest. */
+			case SPRN_SPRG4:
+				vcpu->arch.sprg4 = vcpu->arch.gpr[rs]; break;
+			case SPRN_SPRG5:
+				vcpu->arch.sprg5 = vcpu->arch.gpr[rs]; break;
+			case SPRN_SPRG6:
+				vcpu->arch.sprg6 = vcpu->arch.gpr[rs]; break;
+			case SPRN_SPRG7:
+				vcpu->arch.sprg7 = vcpu->arch.gpr[rs]; break;
+
+			case SPRN_IVPR:
+				vcpu->arch.ivpr = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR0:
+				vcpu->arch.ivor[0] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR1:
+				vcpu->arch.ivor[1] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR2:
+				vcpu->arch.ivor[2] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR3:
+				vcpu->arch.ivor[3] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR4:
+				vcpu->arch.ivor[4] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR5:
+				vcpu->arch.ivor[5] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR6:
+				vcpu->arch.ivor[6] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR7:
+				vcpu->arch.ivor[7] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR8:
+				vcpu->arch.ivor[8] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR9:
+				vcpu->arch.ivor[9] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR10:
+				vcpu->arch.ivor[10] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR11:
+				vcpu->arch.ivor[11] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR12:
+				vcpu->arch.ivor[12] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR13:
+				vcpu->arch.ivor[13] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR14:
+				vcpu->arch.ivor[14] = vcpu->arch.gpr[rs]; break;
+			case SPRN_IVOR15:
+				vcpu->arch.ivor[15] = vcpu->arch.gpr[rs]; break;
+
+			default:
+				printk("mtspr: unknown spr %x\n", sprn);
+				emulated = EMULATE_FAIL;
+				break;
+			}
+			break;
+
+		case 470:                                       /* dcbi */
+			/* Do nothing. The guest is performing dcbi because
+			 * hardware DMA is not snooped by the dcache, but
+			 * emulated DMA either goes through the dcache as
+			 * normal writes, or the host kernel has handled dcache
+			 * coherence. */
+			break;
+
+		case 534:                                       /* lwbrx */
+			rt = get_rt(inst);
+			emulated = kvmppc_handle_load(run, vcpu, rt, 4, 0);
+			break;
+
+		case 566:                                       /* tlbsync */
+			break;
+
+		case 662:                                       /* stwbrx */
+			rs = get_rs(inst);
+			ra = get_ra(inst);
+			rb = get_rb(inst);
+
+			emulated = kvmppc_handle_store(run, vcpu,
+			                               vcpu->arch.gpr[rs],
+			                               4, 0);
+			break;
+
+		case 978:                                       /* tlbwe */
+			emulated = kvmppc_emul_tlbwe(vcpu, inst);
+			break;
+
+		case 914:       {                               /* tlbsx */
+			int index;
+			unsigned int as = get_mmucr_sts(vcpu);
+			unsigned int pid = get_mmucr_stid(vcpu);
+
+			rt = get_rt(inst);
+			ra = get_ra(inst);
+			rb = get_rb(inst);
+			rc = get_rc(inst);
+
+			ea = vcpu->arch.gpr[rb];
+			if (ra)
+				ea += vcpu->arch.gpr[ra];
+
+			index = kvmppc_44x_tlb_index(vcpu, ea, pid, as);
+			if (rc) {
+				if (index < 0)
+					vcpu->arch.cr &= ~0x20000000;
+				else
+					vcpu->arch.cr |= 0x20000000;
+			}
+			vcpu->arch.gpr[rt] = index;
+
+			}
+			break;
+
+		case 790:                                       /* lhbrx */
+			rt = get_rt(inst);
+			emulated = kvmppc_handle_load(run, vcpu, rt, 2, 0);
+			break;
+
+		case 918:                                       /* sthbrx */
+			rs = get_rs(inst);
+			ra = get_ra(inst);
+			rb = get_rb(inst);
+
+			emulated = kvmppc_handle_store(run, vcpu,
+			                               vcpu->arch.gpr[rs],
+			                               2, 0);
+			break;
+
+		case 966:                                       /* iccci */
+			break;
+
+		default:
+			printk("unknown: op %d xop %d\n", get_op(inst),
+				get_xop(inst));
+			emulated = EMULATE_FAIL;
+			break;
+		}
+		break;
+
+	case 32:                                                /* lwz */
+		rt = get_rt(inst);
+		emulated = kvmppc_handle_load(run, vcpu, rt, 4, 1);
+		break;
+
+	case 33:                                                /* lwzu */
+		ra = get_ra(inst);
+		rt = get_rt(inst);
+		emulated = kvmppc_handle_load(run, vcpu, rt, 4, 1);
+		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
+		break;
+
+	case 34:                                                /* lbz */
+		rt = get_rt(inst);
+		emulated = kvmppc_handle_load(run, vcpu, rt, 1, 1);
+		break;
+
+	case 35:                                                /* lbzu */
+		ra = get_ra(inst);
+		rt = get_rt(inst);
+		emulated = kvmppc_handle_load(run, vcpu, rt, 1, 1);
+		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
+		break;
+
+	case 36:                                                /* stw */
+		rs = get_rs(inst);
+		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
+		                               4, 1);
+		break;
+
+	case 37:                                                /* stwu */
+		ra = get_ra(inst);
+		rs = get_rs(inst);
+		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
+		                               4, 1);
+		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
+		break;
+
+	case 38:                                                /* stb */
+		rs = get_rs(inst);
+		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
+		                               1, 1);
+		break;
+
+	case 39:                                                /* stbu */
+		ra = get_ra(inst);
+		rs = get_rs(inst);
+		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
+		                               1, 1);
+		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
+		break;
+
+	case 40:                                                /* lhz */
+		rt = get_rt(inst);
+		emulated = kvmppc_handle_load(run, vcpu, rt, 2, 1);
+		break;
+
+	case 41:                                                /* lhzu */
+		ra = get_ra(inst);
+		rt = get_rt(inst);
+		emulated = kvmppc_handle_load(run, vcpu, rt, 2, 1);
+		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
+		break;
+
+	case 44:                                                /* sth */
+		rs = get_rs(inst);
+		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
+		                               2, 1);
+		break;
+
+	case 45:                                                /* sthu */
+		ra = get_ra(inst);
+		rs = get_rs(inst);
+		emulated = kvmppc_handle_store(run, vcpu, vcpu->arch.gpr[rs],
+		                               2, 1);
+		vcpu->arch.gpr[ra] = vcpu->arch.paddr_accessed;
+		break;
+
+	default:
+		printk("unknown op %d\n", get_op(inst));
+		emulated = EMULATE_FAIL;
+		break;
+	}
+
+	if (advance)
+		vcpu->arch.pc += 4; /* Advance past emulated instruction. */
+
+	return emulated;
+}
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
new file mode 100644
index 0000000..bad40bd
--- /dev/null
+++ b/arch/powerpc/kvm/powerpc.c
@@ -0,0 +1,436 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2007
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ *          Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include <linux/fs.h>
+#include <asm/cputable.h>
+#include <asm/uaccess.h>
+#include <asm/kvm_ppc.h>
+
+
+gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
+{
+	return gfn;
+}
+
+int kvm_cpu_has_interrupt(struct kvm_vcpu *v)
+{
+	/* XXX implement me */
+	return 0;
+}
+
+int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
+{
+	return 1;
+}
+
+
+int kvmppc_emulate_mmio(struct kvm_run *run, struct kvm_vcpu *vcpu)
+{
+	enum emulation_result er;
+	int r;
+
+	er = kvmppc_emulate_instruction(run, vcpu);
+	switch (er) {
+	case EMULATE_DONE:
+		/* Future optimization: only reload non-volatiles if they were
+		 * actually modified. */
+		r = RESUME_GUEST_NV;
+		break;
+	case EMULATE_DO_MMIO:
+		run->exit_reason = KVM_EXIT_MMIO;
+		/* We must reload nonvolatiles because "update" load/store
+		 * instructions modify register state. */
+		/* Future optimization: only reload non-volatiles if they were
+		 * actually modified. */
+		r = RESUME_HOST_NV;
+		break;
+	case EMULATE_FAIL:
+		/* XXX Deliver Program interrupt to guest. */
+		printk(KERN_EMERG "%s: emulation failed (%08x)\n", __func__,
+		       vcpu->arch.last_inst);
+		r = RESUME_HOST;
+		break;
+	default:
+		BUG();
+	}
+
+	return r;
+}
+
+void kvm_arch_hardware_enable(void *garbage)
+{
+}
+
+void kvm_arch_hardware_disable(void *garbage)
+{
+}
+
+int kvm_arch_hardware_setup(void)
+{
+	return 0;
+}
+
+void kvm_arch_hardware_unsetup(void)
+{
+}
+
+void kvm_arch_check_processor_compat(void *rtn)
+{
+	int r;
+
+	if (strcmp(cur_cpu_spec->platform, "ppc440") == 0)
+		r = 0;
+	else
+		r = -ENOTSUPP;
+
+	*(int *)rtn = r;
+}
+
+struct kvm *kvm_arch_create_vm(void)
+{
+	struct kvm *kvm;
+
+	kvm = kzalloc(sizeof(struct kvm), GFP_KERNEL);
+	if (!kvm)
+		return ERR_PTR(-ENOMEM);
+
+	return kvm;
+}
+
+static void kvmppc_free_vcpus(struct kvm *kvm)
+{
+	unsigned int i;
+
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		if (kvm->vcpus[i]) {
+			kvm_arch_vcpu_free(kvm->vcpus[i]);
+			kvm->vcpus[i] = NULL;
+		}
+	}
+}
+
+void kvm_arch_destroy_vm(struct kvm *kvm)
+{
+	kvmppc_free_vcpus(kvm);
+	kvm_free_physmem(kvm);
+	kfree(kvm);
+}
+
+int kvm_dev_ioctl_check_extension(long ext)
+{
+	int r;
+
+	switch (ext) {
+	case KVM_CAP_USER_MEMORY:
+		r = 1;
+		break;
+	default:
+		r = 0;
+		break;
+	}
+	return r;
+
+}
+
+long kvm_arch_dev_ioctl(struct file *filp,
+                        unsigned int ioctl, unsigned long arg)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_set_memory_region(struct kvm *kvm,
+                               struct kvm_userspace_memory_region *mem,
+                               struct kvm_memory_slot old,
+                               int user_alloc)
+{
+	return 0;
+}
+
+struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
+{
+	struct kvm_vcpu *vcpu;
+	int err;
+
+	vcpu = kmem_cache_zalloc(kvm_vcpu_cache, GFP_KERNEL);
+	if (!vcpu) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = kvm_vcpu_init(vcpu, kvm, id);
+	if (err)
+		goto free_vcpu;
+
+	return vcpu;
+
+free_vcpu:
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
+out:
+	return ERR_PTR(err);
+}
+
+void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	kvm_vcpu_uninit(vcpu);
+	kmem_cache_free(kvm_vcpu_cache, vcpu);
+}
+
+void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	kvm_arch_vcpu_free(vcpu);
+}
+
+int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
+{
+	unsigned int priority = exception_priority[BOOKE_INTERRUPT_DECREMENTER];
+
+	return test_bit(priority, &vcpu->arch.pending_exceptions);
+}
+
+static void kvmppc_decrementer_func(unsigned long data)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *)data;
+
+	kvmppc_queue_exception(vcpu, BOOKE_INTERRUPT_DECREMENTER);
+}
+
+int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	setup_timer(&vcpu->arch.dec_timer, kvmppc_decrementer_func,
+	            (unsigned long)vcpu);
+
+	return 0;
+}
+
+void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
+{
+}
+
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+}
+
+void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
+{
+}
+
+void decache_vcpus_on_cpu(int cpu)
+{
+}
+
+int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
+                                    struct kvm_debug_guest *dbg)
+{
+	return -ENOTSUPP;
+}
+
+static void kvmppc_complete_dcr_load(struct kvm_vcpu *vcpu,
+                                     struct kvm_run *run)
+{
+	u32 *gpr = &vcpu->arch.gpr[vcpu->arch.io_gpr];
+	*gpr = run->dcr.data;
+}
+
+static void kvmppc_complete_mmio_load(struct kvm_vcpu *vcpu,
+                                      struct kvm_run *run)
+{
+	u32 *gpr = &vcpu->arch.gpr[vcpu->arch.io_gpr];
+
+	if (run->mmio.len > sizeof(*gpr)) {
+		printk(KERN_ERR "bad MMIO length: %d\n", run->mmio.len);
+		return;
+	}
+
+	if (vcpu->arch.mmio_is_bigendian) {
+		switch (run->mmio.len) {
+		case 4: *gpr = *(u32 *)run->mmio.data; break;
+		case 2: *gpr = *(u16 *)run->mmio.data; break;
+		case 1: *gpr = *(u8 *)run->mmio.data; break;
+		}
+	} else {
+		/* Convert BE data from userland back to LE. */
+		switch (run->mmio.len) {
+		case 4: *gpr = ld_le32((u32 *)run->mmio.data); break;
+		case 2: *gpr = ld_le16((u16 *)run->mmio.data); break;
+		case 1: *gpr = *(u8 *)run->mmio.data; break;
+		}
+	}
+}
+
+int kvmppc_handle_load(struct kvm_run *run, struct kvm_vcpu *vcpu,
+                       unsigned int rt, unsigned int bytes, int is_bigendian)
+{
+	if (bytes > sizeof(run->mmio.data)) {
+		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
+		       run->mmio.len);
+	}
+
+	run->mmio.phys_addr = vcpu->arch.paddr_accessed;
+	run->mmio.len = bytes;
+	run->mmio.is_write = 0;
+
+	vcpu->arch.io_gpr = rt;
+	vcpu->arch.mmio_is_bigendian = is_bigendian;
+	vcpu->mmio_needed = 1;
+	vcpu->mmio_is_write = 0;
+
+	return EMULATE_DO_MMIO;
+}
+
+int kvmppc_handle_store(struct kvm_run *run, struct kvm_vcpu *vcpu,
+                        u32 val, unsigned int bytes, int is_bigendian)
+{
+	void *data = run->mmio.data;
+
+	if (bytes > sizeof(run->mmio.data)) {
+		printk(KERN_ERR "%s: bad MMIO length: %d\n", __func__,
+		       run->mmio.len);
+	}
+
+	run->mmio.phys_addr = vcpu->arch.paddr_accessed;
+	run->mmio.len = bytes;
+	run->mmio.is_write = 1;
+	vcpu->mmio_needed = 1;
+	vcpu->mmio_is_write = 1;
+
+	/* Store the value at the lowest bytes in 'data'. */
+	if (is_bigendian) {
+		switch (bytes) {
+		case 4: *(u32 *)data = val; break;
+		case 2: *(u16 *)data = val; break;
+		case 1: *(u8  *)data = val; break;
+		}
+	} else {
+		/* Store LE value into 'data'. */
+		switch (bytes) {
+		case 4: st_le32(data, val); break;
+		case 2: st_le16(data, val); break;
+		case 1: *(u8 *)data = val; break;
+		}
+	}
+
+	return EMULATE_DO_MMIO;
+}
+
+int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	int r;
+	sigset_t sigsaved;
+
+	if (vcpu->sigset_active)
+		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
+
+	if (vcpu->mmio_needed) {
+		if (!vcpu->mmio_is_write)
+			kvmppc_complete_mmio_load(vcpu, run);
+		vcpu->mmio_needed = 0;
+	} else if (vcpu->arch.dcr_needed) {
+		if (!vcpu->arch.dcr_is_write)
+			kvmppc_complete_dcr_load(vcpu, run);
+		vcpu->arch.dcr_needed = 0;
+	}
+
+	kvmppc_check_and_deliver_interrupts(vcpu);
+
+	local_irq_disable();
+	kvm_guest_enter();
+	r = __kvmppc_vcpu_run(run, vcpu);
+	kvm_guest_exit();
+	local_irq_enable();
+
+	if (vcpu->sigset_active)
+		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
+
+	return r;
+}
+
+int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_interrupt *irq)
+{
+	kvmppc_queue_exception(vcpu, BOOKE_INTERRUPT_EXTERNAL);
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
+                                    struct kvm_mp_state *mp_state)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
+                                    struct kvm_mp_state *mp_state)
+{
+	return -EINVAL;
+}
+
+long kvm_arch_vcpu_ioctl(struct file *filp,
+                         unsigned int ioctl, unsigned long arg)
+{
+	struct kvm_vcpu *vcpu = filp->private_data;
+	void __user *argp = (void __user *)arg;
+	long r;
+
+	switch (ioctl) {
+	case KVM_INTERRUPT: {
+		struct kvm_interrupt irq;
+		r = -EFAULT;
+		if (copy_from_user(&irq, argp, sizeof(irq)))
+			goto out;
+		r = kvm_vcpu_ioctl_interrupt(vcpu, &irq);
+		break;
+	}
+	default:
+		r = -EINVAL;
+	}
+
+out:
+	return r;
+}
+
+int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
+{
+	return -ENOTSUPP;
+}
+
+long kvm_arch_vm_ioctl(struct file *filp,
+                       unsigned int ioctl, unsigned long arg)
+{
+	long r;
+
+	switch (ioctl) {
+	default:
+		r = -EINVAL;
+	}
+
+	return r;
+}
+
+int kvm_arch_init(void *opaque)
+{
+	return 0;
+}
+
+void kvm_arch_exit(void)
+{
+}
diff --git a/include/asm-powerpc/kvm.h b/include/asm-powerpc/kvm.h
index d1b530f..f993e41 100644
--- a/include/asm-powerpc/kvm.h
+++ b/include/asm-powerpc/kvm.h
@@ -1,6 +1,55 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2007
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
 #ifndef __LINUX_KVM_POWERPC_H
 #define __LINUX_KVM_POWERPC_H
 
-/* powerpc does not support KVM */
+#include <asm/types.h>
+
+struct kvm_regs {
+	__u64 pc;
+	__u64 cr;
+	__u64 ctr;
+	__u64 lr;
+	__u64 xer;
+	__u64 msr;
+	__u64 srr0;
+	__u64 srr1;
+	__u64 pid;
+
+	__u64 sprg0;
+	__u64 sprg1;
+	__u64 sprg2;
+	__u64 sprg3;
+	__u64 sprg4;
+	__u64 sprg5;
+	__u64 sprg6;
+	__u64 sprg7;
+
+	__u64 gpr[32];
+};
+
+struct kvm_sregs {
+};
+
+struct kvm_fpu {
+	__u64 fpr[32];
+};
 
-#endif
+#endif /* __LINUX_KVM_POWERPC_H */
diff --git a/include/asm-powerpc/kvm_asm.h b/include/asm-powerpc/kvm_asm.h
new file mode 100644
index 0000000..2197764
--- /dev/null
+++ b/include/asm-powerpc/kvm_asm.h
@@ -0,0 +1,55 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
+#ifndef __POWERPC_KVM_ASM_H__
+#define __POWERPC_KVM_ASM_H__
+
+/* IVPR must be 64KiB-aligned. */
+#define VCPU_SIZE_ORDER 4
+#define VCPU_SIZE_LOG   (VCPU_SIZE_ORDER + 12)
+#define VCPU_TLB_PGSZ   PPC44x_TLB_64K
+#define VCPU_SIZE_BYTES (1<<VCPU_SIZE_LOG)
+
+#define BOOKE_INTERRUPT_CRITICAL 0
+#define BOOKE_INTERRUPT_MACHINE_CHECK 1
+#define BOOKE_INTERRUPT_DATA_STORAGE 2
+#define BOOKE_INTERRUPT_INST_STORAGE 3
+#define BOOKE_INTERRUPT_EXTERNAL 4
+#define BOOKE_INTERRUPT_ALIGNMENT 5
+#define BOOKE_INTERRUPT_PROGRAM 6
+#define BOOKE_INTERRUPT_FP_UNAVAIL 7
+#define BOOKE_INTERRUPT_SYSCALL 8
+#define BOOKE_INTERRUPT_AP_UNAVAIL 9
+#define BOOKE_INTERRUPT_DECREMENTER 10
+#define BOOKE_INTERRUPT_FIT 11
+#define BOOKE_INTERRUPT_WATCHDOG 12
+#define BOOKE_INTERRUPT_DTLB_MISS 13
+#define BOOKE_INTERRUPT_ITLB_MISS 14
+#define BOOKE_INTERRUPT_DEBUG 15
+#define BOOKE_MAX_INTERRUPT 15
+
+#define RESUME_FLAG_NV          (1<<0)  /* Reload guest nonvolatile state? */
+#define RESUME_FLAG_HOST        (1<<1)  /* Resume host? */
+
+#define RESUME_GUEST            0
+#define RESUME_GUEST_NV         RESUME_FLAG_NV
+#define RESUME_HOST             RESUME_FLAG_HOST
+#define RESUME_HOST_NV          (RESUME_FLAG_HOST|RESUME_FLAG_NV)
+
+#endif /* __POWERPC_KVM_ASM_H__ */
diff --git a/include/asm-powerpc/kvm_host.h b/include/asm-powerpc/kvm_host.h
new file mode 100644
index 0000000..04ffbb8
--- /dev/null
+++ b/include/asm-powerpc/kvm_host.h
@@ -0,0 +1,152 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2007
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
+#ifndef __POWERPC_KVM_HOST_H__
+#define __POWERPC_KVM_HOST_H__
+
+#include <linux/mutex.h>
+#include <linux/timer.h>
+#include <linux/types.h>
+#include <linux/kvm_types.h>
+#include <asm/kvm_asm.h>
+
+#define KVM_MAX_VCPUS 1
+#define KVM_MEMORY_SLOTS 32
+/* memory slots that does not exposed to userspace */
+#define KVM_PRIVATE_MEM_SLOTS 4
+
+/* We don't currently support large pages. */
+#define KVM_PAGES_PER_HPAGE (1<<31)
+
+struct kvm;
+struct kvm_run;
+struct kvm_vcpu;
+
+struct kvm_vm_stat {
+	u32 remote_tlb_flush;
+};
+
+struct kvm_vcpu_stat {
+	u32 sum_exits;
+	u32 mmio_exits;
+	u32 dcr_exits;
+	u32 signal_exits;
+	u32 light_exits;
+	/* Account for special types of light exits: */
+	u32 itlb_real_miss_exits;
+	u32 itlb_virt_miss_exits;
+	u32 dtlb_real_miss_exits;
+	u32 dtlb_virt_miss_exits;
+	u32 syscall_exits;
+	u32 isi_exits;
+	u32 dsi_exits;
+	u32 emulated_inst_exits;
+	u32 dec_exits;
+	u32 ext_intr_exits;
+};
+
+struct tlbe {
+	u32 tid; /* Only the low 8 bits are used. */
+	u32 word0;
+	u32 word1;
+	u32 word2;
+};
+
+struct kvm_arch {
+};
+
+struct kvm_vcpu_arch {
+	/* Unmodified copy of the guest's TLB. */
+	struct tlbe guest_tlb[PPC44x_TLB_SIZE];
+	/* TLB that's actually used when the guest is running. */
+	struct tlbe shadow_tlb[PPC44x_TLB_SIZE];
+	/* Pages which are referenced in the shadow TLB. */
+	struct page *shadow_pages[PPC44x_TLB_SIZE];
+	/* Copy of the host's TLB. */
+	struct tlbe host_tlb[PPC44x_TLB_SIZE];
+
+	u32 host_stack;
+	u32 host_pid;
+
+	u64 fpr[32];
+	u32 gpr[32];
+
+	u32 pc;
+	u32 cr;
+	u32 ctr;
+	u32 lr;
+	u32 xer;
+
+	u32 msr;
+	u32 mmucr;
+	u32 sprg0;
+	u32 sprg1;
+	u32 sprg2;
+	u32 sprg3;
+	u32 sprg4;
+	u32 sprg5;
+	u32 sprg6;
+	u32 sprg7;
+	u32 srr0;
+	u32 srr1;
+	u32 csrr0;
+	u32 csrr1;
+	u32 dsrr0;
+	u32 dsrr1;
+	u32 dear;
+	u32 esr;
+	u32 dec;
+	u32 decar;
+	u32 tbl;
+	u32 tbu;
+	u32 tcr;
+	u32 tsr;
+	u32 ivor[16];
+	u32 ivpr;
+	u32 pir;
+	u32 pid;
+	u32 pvr;
+	u32 ccr0;
+	u32 ccr1;
+	u32 dbcr0;
+	u32 dbcr1;
+
+	u32 last_inst;
+	u32 fault_dear;
+	u32 fault_esr;
+	gpa_t paddr_accessed;
+
+	u8 io_gpr; /* GPR used as IO source/target */
+	u8 mmio_is_bigendian;
+	u8 dcr_needed;
+	u8 dcr_is_write;
+
+	u32 cpr0_cfgaddr; /* holds the last set cpr0_cfgaddr */
+
+	struct timer_list dec_timer;
+	unsigned long pending_exceptions;
+};
+
+struct kvm_guest_debug {
+	int enabled;
+	unsigned long bp[4];
+	int singlestep;
+};
+
+#endif /* __POWERPC_KVM_HOST_H__ */
diff --git a/include/asm-powerpc/kvm_para.h b/include/asm-powerpc/kvm_para.h
new file mode 100644
index 0000000..e69c78e
--- /dev/null
+++ b/include/asm-powerpc/kvm_para.h
@@ -0,0 +1,38 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
+#ifndef __POWERPC_KVM_PARA_H__
+#define __POWERPC_KVM_PARA_H__
+
+#ifdef __KERNEL__
+
+static inline int kvm_para_available(void)
+{
+	return 0;
+}
+
+static inline unsigned int kvm_arch_para_features(void)
+{
+	return 0;
+}
+
+#endif /* __KERNEL__ */
+
+#endif /* __POWERPC_KVM_PARA_H__ */
+
diff --git a/include/asm-powerpc/kvm_ppc.h b/include/asm-powerpc/kvm_ppc.h
new file mode 100644
index 0000000..7ac8203
--- /dev/null
+++ b/include/asm-powerpc/kvm_ppc.h
@@ -0,0 +1,88 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright IBM Corp. 2008
+ *
+ * Authors: Hollis Blanchard <hollisb@us.ibm.com>
+ */
+
+#ifndef __POWERPC_KVM_PPC_H__
+#define __POWERPC_KVM_PPC_H__
+
+/* This file exists just so we can dereference kvm_vcpu, avoiding nested header
+ * dependencies. */
+
+#include <linux/mutex.h>
+#include <linux/timer.h>
+#include <linux/types.h>
+#include <linux/kvm_types.h>
+#include <linux/kvm_host.h>
+
+struct kvm_tlb {
+	struct tlbe guest_tlb[PPC44x_TLB_SIZE];
+	struct tlbe shadow_tlb[PPC44x_TLB_SIZE];
+};
+
+enum emulation_result {
+	EMULATE_DONE,         /* no further processing */
+	EMULATE_DO_MMIO,      /* kvm_run filled with MMIO request */
+	EMULATE_DO_DCR,       /* kvm_run filled with DCR request */
+	EMULATE_FAIL,         /* can't emulate this instruction */
+};
+
+extern const unsigned char exception_priority[];
+extern const unsigned char priority_exception[];
+
+extern int __kvmppc_vcpu_run(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu);
+extern char kvmppc_handlers_start[];
+extern unsigned long kvmppc_handler_len;
+
+extern void kvmppc_dump_vcpu(struct kvm_vcpu *vcpu);
+extern int kvmppc_handle_load(struct kvm_run *run, struct kvm_vcpu *vcpu,
+                              unsigned int rt, unsigned int bytes,
+                              int is_bigendian);
+extern int kvmppc_handle_store(struct kvm_run *run, struct kvm_vcpu *vcpu,
+                               u32 val, unsigned int bytes, int is_bigendian);
+
+extern int kvmppc_emulate_instruction(struct kvm_run *run,
+                                      struct kvm_vcpu *vcpu);
+
+extern void kvmppc_mmu_map(struct kvm_vcpu *vcpu, u64 gvaddr, gfn_t gfn,
+                           u64 asid, u32 flags);
+extern void kvmppc_mmu_invalidate(struct kvm_vcpu *vcpu, u64 eaddr, u64 asid);
+extern void kvmppc_mmu_priv_switch(struct kvm_vcpu *vcpu, int usermode);
+
+extern void kvmppc_check_and_deliver_interrupts(struct kvm_vcpu *vcpu);
+
+static inline void kvmppc_queue_exception(struct kvm_vcpu *vcpu, int exception)
+{
+	unsigned int priority = exception_priority[exception];
+	set_bit(priority, &vcpu->arch.pending_exceptions);
+}
+
+static inline void kvmppc_clear_exception(struct kvm_vcpu *vcpu, int exception)
+{
+	unsigned int priority = exception_priority[exception];
+	clear_bit(priority, &vcpu->arch.pending_exceptions);
+}
+
+static inline void kvmppc_set_msr(struct kvm_vcpu *vcpu, u32 new_msr)
+{
+	if ((new_msr & MSR_PR) != (vcpu->arch.msr & MSR_PR))
+		kvmppc_mmu_priv_switch(vcpu, new_msr & MSR_PR);
+
+	vcpu->arch.msr = new_msr;
+}
+
+#endif /* __POWERPC_KVM_PPC_H__ */
-- 
1.5.5

