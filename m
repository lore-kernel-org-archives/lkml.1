Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609Ab0A2IVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab0A2IVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 03:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232Ab0A2IVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 03:21:34 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:27195 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab0A2IVd convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Fri, 29 Jan 2010 03:21:33 -0500
Message-Id: <4B62A3E5020000780002CA96@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 29 Jan 2010 08:01:25 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86: enlightenment for ticket spinlocks - Xen
	 implementation
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the (alternative instructions based) callout hooks to the ticket
spinlock code to enlighten ticket locks when running fully virtualized
on Xen. Ultimately, this code might also be a candidate to be used
when running para-virtualized.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 arch/x86/include/asm/processor.h |    1 
 arch/x86/include/asm/xen.h       |    7 +
 arch/x86/include/asm/xen/cpuid.h |   68 ++++++++++
 arch/x86/kernel/cpu/Makefile     |    2 
 arch/x86/kernel/cpu/hypervisor.c |   11 +
 arch/x86/kernel/cpu/xen.c        |  259 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 345 insertions(+), 3 deletions(-)

--- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/include/asm/processor.h
+++ 2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/processor.h
@@ -129,6 +129,7 @@ struct cpuinfo_x86 {
 
 #define X86_HYPER_VENDOR_NONE  0
 #define X86_HYPER_VENDOR_VMWARE 1
+#define X86_HYPER_VENDOR_XEN   2
 
 /*
  * capabilities of CPUs
--- /dev/null
+++ 2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/xen.h
@@ -0,0 +1,7 @@
+#ifndef ASM_X86__XEN_H
+#define ASM_X86__XEN_H
+
+extern int xen_platform(void);
+extern void xen_set_feature_bits(struct cpuinfo_x86 *c);
+
+#endif
--- /dev/null
+++ 2.6.33-rc5-virt-spinlocks/arch/x86/include/asm/xen/cpuid.h
@@ -0,0 +1,68 @@
+/******************************************************************************
+ * arch-x86/cpuid.h
+ *
+ * CPUID interface to Xen.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Copyright (c) 2007 Citrix Systems, Inc.
+ *
+ * Authors:
+ *    Keir Fraser <keir.fraser@citrix.com>
+ */
+
+#ifndef __XEN_PUBLIC_ARCH_X86_CPUID_H__
+#define __XEN_PUBLIC_ARCH_X86_CPUID_H__
+
+/* Xen identification leaves start at 0x40000000. */
+#define XEN_CPUID_FIRST_LEAF 0x40000000
+#define XEN_CPUID_LEAF(i)    (XEN_CPUID_FIRST_LEAF + (i))
+
+/*
+ * Leaf 1 (0x40000000)
+ * EAX: Largest Xen-information leaf. All leaves up to an including @EAX
+ *      are supported by the Xen host.
+ * EBX-EDX: "XenVMMXenVMM" signature, allowing positive identification
+ *      of a Xen host.
+ */
+#define XEN_CPUID_SIGNATURE_EBX 0x566e6558 /* "XenV" */
+#define XEN_CPUID_SIGNATURE_ECX 0x65584d4d /* "MMXe" */
+#define XEN_CPUID_SIGNATURE_EDX 0x4d4d566e /* "nVMM" */
+
+/*
+ * Leaf 2 (0x40000001)
+ * EAX[31:16]: Xen major version.
+ * EAX[15: 0]: Xen minor version.
+ * EBX-EDX: Reserved (currently all zeroes).
+ */
+
+/*
+ * Leaf 3 (0x40000002)
+ * EAX: Number of hypercall transfer pages. This register is always guaranteed
+ *      to specify one hypercall page.
+ * EBX: Base address of Xen-specific MSRs.
+ * ECX: Features 1. Unused bits are set to zero.
+ * EDX: Features 2. Unused bits are set to zero.
+ */
+
+/* Does the host support MMU_PT_UPDATE_PRESERVE_AD for this guest? */
+#define _XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD 0
+#define XEN_CPUID_FEAT1_MMU_PT_UPDATE_PRESERVE_AD  (1u<<0)
+
+#endif /* __XEN_PUBLIC_ARCH_X86_CPUID_H__ */
--- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/kernel/cpu/Makefile
+++ 2.6.33-rc5-virt-spinlocks/arch/x86/kernel/cpu/Makefile
@@ -14,7 +14,7 @@ CFLAGS_common.o		:= $(nostackp)
 
 obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
-obj-y			+= vmware.o hypervisor.o sched.o
+obj-y			+= vmware.o xen.o hypervisor.o sched.o
 
 obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
--- 2.6.33-rc5-virt-spinlocks.orig/arch/x86/kernel/cpu/hypervisor.c
+++ 2.6.33-rc5-virt-spinlocks/arch/x86/kernel/cpu/hypervisor.c
@@ -23,6 +23,7 @@
 
 #include <asm/processor.h>
 #include <asm/vmware.h>
+#include <asm/xen.h>
 #include <asm/hypervisor.h>
 
 #ifdef CONFIG_ENLIGHTEN_SPINLOCKS
@@ -39,6 +40,8 @@ detect_hypervisor_vendor(struct cpuinfo_
 {
 	if (vmware_platform())
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_VMWARE;
+	else if (xen_platform())
+		c->x86_hyper_vendor = X86_HYPER_VENDOR_XEN;
 	else
 		c->x86_hyper_vendor = X86_HYPER_VENDOR_NONE;
 }
@@ -46,9 +49,13 @@ detect_hypervisor_vendor(struct cpuinfo_
 static inline void __cpuinit
 hypervisor_set_feature_bits(struct cpuinfo_x86 *c)
 {
-	if (boot_cpu_data.x86_hyper_vendor == X86_HYPER_VENDOR_VMWARE) {
+	switch (boot_cpu_data.x86_hyper_vendor) {
+	case X86_HYPER_VENDOR_VMWARE:
 		vmware_set_feature_bits(c);
-		return;
+		break;
+	case X86_HYPER_VENDOR_XEN:
+		xen_set_feature_bits(c);
+		break;
 	}
 }
 
--- /dev/null
+++ 2.6.33-rc5-virt-spinlocks/arch/x86/kernel/cpu/xen.c
@@ -0,0 +1,259 @@
+#define __XEN_INTERFACE_VERSION__ 0x00030207
+#include <linux/bootmem.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/smp.h>
+#include <linux/spinlock.h>
+#include <linux/stringify.h>
+#include <asm/sync_bitops.h>
+#include <asm/xen.h>
+#include <asm/xen/cpuid.h>
+#include <asm/xen/hypercall.h>
+#include <xen/interface/event_channel.h>
+#include <xen/interface/memory.h>
+#include <xen/interface/vcpu.h>
+
+#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
+struct spinning {
+	volatile struct arch_spinlock *lock;
+	unsigned int ticket;
+	struct spinning *prev;
+};
+
+static struct shared_info *__read_mostly xen_shared_info;
+EXPORT_SYMBOL_GPL(xen_shared_info);
+
+static DEFINE_PER_CPU(struct vcpu_runstate_info, runstate);
+static DEFINE_PER_CPU(evtchn_port_t, poll_evtchn);
+static DEFINE_PER_CPU(struct spinning *, spinning);
+/*
+ * Protect removal of objects: Insertion can be done lockless, and even
+ * removal itself doesn't need protection - what needs to be prevented is
+ * removed objects going out of scope (as they're living on the stack).
+ */
+static DEFINE_PER_CPU(arch_rwlock_t, spinning_rm_lock) = __ARCH_RW_LOCK_UNLOCKED;
+
+static unsigned int __read_mostly spin_count = 1000;
+static int __init setup_spin_count(char *s)
+{
+	if (!s)
+		return -EINVAL;
+	spin_count = simple_strtoul(s, &s, 0);
+	return !*s ? 0 : -EINVAL;
+}
+early_param("spin_count", setup_spin_count);
+
+#ifndef CONFIG_XEN
+__asm__(".pushsection .text, \"ax\", @progbits\n"
+	".p2align " __stringify(PAGE_SHIFT) "\n"
+	"hypercall_page:\n"
+	".skip 1 << " __stringify(PAGE_SHIFT) "\n"
+	".popsection");
+#endif
+
+static void xen_spin_lock(volatile struct arch_spinlock *lock,
+			  unsigned int token)
+{
+	arch_rwlock_t *rm_lock;
+	unsigned long flags;
+	unsigned int count;
+	struct spinning spinning;
+
+	if (unlikely(percpu_read(runstate.state) != RUNSTATE_running))
+		xen_set_feature_bits(&__get_cpu_var(cpu_info));
+
+	token >>= TICKET_SHIFT;
+	spinning.ticket = token;
+	spinning.lock = lock;
+	spinning.prev = percpu_read(spinning);
+	smp_wmb();
+	percpu_write(spinning, &spinning);
+
+	sync_clear_bit(percpu_read(poll_evtchn),
+		       xen_shared_info->evtchn_pending);
+
+	for (count = spin_count; lock->cur != token; )
+		if (likely(cpu_online(raw_smp_processor_id()))
+		    && (per_cpu(runstate.state, lock->owner) != RUNSTATE_running
+			|| unlikely(!--count))) {
+			struct sched_poll sched_poll;
+
+			set_xen_guest_handle(sched_poll.ports,
+					     &__get_cpu_var(poll_evtchn));
+			sched_poll.nr_ports = 1;
+			sched_poll.timeout = 0;
+			HYPERVISOR_sched_op(SCHEDOP_poll, &sched_poll);
+			count = spin_count;
+		} else
+			cpu_relax();
+
+	/*
+	 * If we interrupted another spinlock while it was blocking, make
+	 * sure it doesn't block (again) without re-checking the lock.
+	 */
+	if (spinning.prev)
+		sync_set_bit(percpu_read(poll_evtchn),
+			     xen_shared_info->evtchn_pending);
+
+	percpu_write(spinning, spinning.prev);
+	rm_lock = &__get_cpu_var(spinning_rm_lock);
+	raw_local_irq_save(flags);
+	arch_write_lock(rm_lock);
+	arch_write_unlock(rm_lock);
+	raw_local_irq_restore(flags);
+}
+
+static void xen_spin_unlock(volatile struct arch_spinlock *lock,
+			    unsigned int token)
+{
+	unsigned int cpu;
+
+	token &= (1U << TICKET_SHIFT) - 1;
+	for_each_online_cpu(cpu) {
+		arch_rwlock_t *rm_lock;
+		unsigned long flags;
+		struct spinning *spinning;
+
+		if (cpu == raw_smp_processor_id())
+			continue;
+
+		rm_lock = &per_cpu(spinning_rm_lock, cpu);
+		raw_local_irq_save(flags);
+		arch_read_lock(rm_lock);
+
+		spinning = per_cpu(spinning, cpu);
+		smp_rmb();
+		if (spinning
+		    && (spinning->lock != lock || spinning->ticket != token))
+			spinning = NULL;
+
+		arch_read_unlock(rm_lock);
+		raw_local_irq_restore(flags);
+
+		if (unlikely(spinning)) {
+			struct evtchn_send send;
+
+			send.port = per_cpu(poll_evtchn, cpu);
+			HYPERVISOR_event_channel_op(EVTCHNOP_send, &send);
+			return;
+		}
+	}
+}
+
+static void __init _prepare_shared_info_page(void)
+{
+	struct xen_add_to_physmap xatp;
+
+	xen_shared_info = alloc_bootmem_pages(PAGE_SIZE);
+
+	xatp.domid = DOMID_SELF;
+	xatp.idx = 0;
+	xatp.space = XENMAPSPACE_shared_info;
+	xatp.gpfn = __pa(xen_shared_info) >> PAGE_SHIFT;
+	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
+		BUG();
+}
+
+static void __ref prepare_shared_info_page(void)
+{
+	_prepare_shared_info_page();
+}
+#endif
+
+int __cpuinit xen_platform(void)
+{
+	unsigned int first = XEN_CPUID_FIRST_LEAF;
+
+#if 0 /* So far, Xen sets this only for PV guests. */
+	if (!cpu_has_hypervisor)
+		return 0;
+#endif
+
+	while (first < XEN_CPUID_LEAF(0x10000)) {
+		unsigned int eax, ebx, ecx, edx;
+
+		cpuid(first, &eax, &ebx, &ecx, &edx);
+		if (ebx == XEN_CPUID_SIGNATURE_EBX
+		    && ecx == XEN_CPUID_SIGNATURE_ECX
+		    && edx == XEN_CPUID_SIGNATURE_EDX) {
+			if (!smp_processor_id()) {
+				cpuid(first + 1, &eax, &ebx, &ecx, &edx);
+				printk(KERN_INFO "Running on Xen %u.%u\n",
+				       eax >> 16, eax & 0xffff);
+			}
+			return 1;
+		}
+		first += 0x100;
+	}
+
+	return 0;
+}
+
+void xen_set_feature_bits(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_ENLIGHTEN_SPINLOCKS
+	unsigned int msr, eax, ebx, ecx, edx;
+	unsigned int first = XEN_CPUID_FIRST_LEAF;
+	int ret;
+	struct vcpu_register_runstate_memory_area vrrma;
+
+	if (num_possible_cpus() <= 1
+	    || !spin_count
+	    || (c != &boot_cpu_data
+		&& !boot_cpu_has(X86_FEATURE_SPINLOCK_YIELD)))
+		return;
+
+	while (first < XEN_CPUID_LEAF(0x10000)) {
+		cpuid(first, &eax, &ebx, &ecx, &edx);
+		if (ebx == XEN_CPUID_SIGNATURE_EBX
+		    && ecx == XEN_CPUID_SIGNATURE_ECX
+		    && edx == XEN_CPUID_SIGNATURE_EDX)
+			break;
+		first += 0x100;
+	}
+	BUG_ON(first >= XEN_CPUID_LEAF(0x10000));
+
+	cpuid(first + 2, &eax, &msr, &ecx, &edx);
+	BUG_ON(!eax);
+	wrmsrl(msr, __pa_symbol(hypercall_page));
+
+	if (!xen_shared_info)
+		prepare_shared_info_page();
+
+	memset(&vrrma, 0, sizeof(vrrma));
+	set_xen_guest_handle(vrrma.addr.h, &__get_cpu_var(runstate));
+	ret = HYPERVISOR_vcpu_op(VCPUOP_register_runstate_memory_area,
+				 c->cpu_index, &vrrma);
+	if (ret) {
+		printk(KERN_WARNING
+		       "Could not register runstate area for CPU%u: %d\n",
+		       c->cpu_index, ret);
+		BUG_ON(boot_cpu_has(X86_FEATURE_SPINLOCK_YIELD));
+		return;
+	}
+
+	if (c != &boot_cpu_data || !percpu_read(poll_evtchn)) {
+		struct evtchn_bind_ipi bind_ipi;
+
+		bind_ipi.vcpu = c->cpu_index;
+		ret = HYPERVISOR_event_channel_op(EVTCHNOP_bind_ipi,
+						  &bind_ipi);
+		if (ret) {
+			printk(KERN_WARNING
+			       "Could not bind event channel for CPU%u: %d\n",
+			       c->cpu_index, ret);
+			BUG_ON(boot_cpu_has(X86_FEATURE_SPINLOCK_YIELD));
+			return;
+		}
+		sync_set_bit(bind_ipi.port, xen_shared_info->evtchn_mask);
+		percpu_write(poll_evtchn, bind_ipi.port);
+		printk(KERN_INFO "CPU%u spinlock poll event channel: %u\n",
+		       c->cpu_index, bind_ipi.port);
+	}
+
+	virt_spin_lock = xen_spin_lock;
+	virt_spin_unlock = xen_spin_unlock;
+	set_cpu_cap(c, X86_FEATURE_SPINLOCK_YIELD);
+#endif
+}


