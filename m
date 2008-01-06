Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbYAFOoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbYAFOoy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758393AbYAFOkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:00 -0500
Received: from il.qumranet.com ([82.166.9.18]:46607 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741AbYAFOjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 17/33] KVM: Move irqchip declarations into new ioapic.h and lapic.h
Date: Sun,  6 Jan 2008 16:39:23 +0200
Message-Id: <1199630379-28638-18-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

This allows reuse of ioapic in ia64.

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/ioapic.c |    5 ++-
 arch/x86/kvm/ioapic.h |   95 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/irq.h    |  115 ++----------------------------------------------
 arch/x86/kvm/lapic.h  |   44 +++++++++++++++++++
 4 files changed, 148 insertions(+), 111 deletions(-)
 create mode 100644 arch/x86/kvm/ioapic.h
 create mode 100644 arch/x86/kvm/lapic.h

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 72f12f7..40cd53e 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -36,7 +36,10 @@
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/current.h>
-#include "irq.h"
+
+#include "ioapic.h"
+#include "lapic.h"
+
 #if 0
 #define ioapic_debug(fmt,arg...) printk(KERN_WARNING fmt,##arg)
 #else
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
new file mode 100644
index 0000000..7f16675
--- /dev/null
+++ b/arch/x86/kvm/ioapic.h
@@ -0,0 +1,95 @@
+#ifndef __KVM_IO_APIC_H
+#define __KVM_IO_APIC_H
+
+#include <linux/kvm_host.h>
+
+#include "iodev.h"
+
+struct kvm;
+struct kvm_vcpu;
+
+#define IOAPIC_NUM_PINS  KVM_IOAPIC_NUM_PINS
+#define IOAPIC_VERSION_ID 0x11	/* IOAPIC version */
+#define IOAPIC_EDGE_TRIG  0
+#define IOAPIC_LEVEL_TRIG 1
+
+#define IOAPIC_DEFAULT_BASE_ADDRESS  0xfec00000
+#define IOAPIC_MEM_LENGTH            0x100
+
+/* Direct registers. */
+#define IOAPIC_REG_SELECT  0x00
+#define IOAPIC_REG_WINDOW  0x10
+#define IOAPIC_REG_EOI     0x40	/* IA64 IOSAPIC only */
+
+/* Indirect registers. */
+#define IOAPIC_REG_APIC_ID 0x00	/* x86 IOAPIC only */
+#define IOAPIC_REG_VERSION 0x01
+#define IOAPIC_REG_ARB_ID  0x02	/* x86 IOAPIC only */
+
+/*ioapic delivery mode*/
+#define	IOAPIC_FIXED			0x0
+#define	IOAPIC_LOWEST_PRIORITY		0x1
+#define	IOAPIC_PMI			0x2
+#define	IOAPIC_NMI			0x4
+#define	IOAPIC_INIT			0x5
+#define	IOAPIC_EXTINT			0x7
+
+struct kvm_ioapic {
+	u64 base_address;
+	u32 ioregsel;
+	u32 id;
+	u32 irr;
+	u32 pad;
+	union ioapic_redir_entry {
+		u64 bits;
+		struct {
+			u8 vector;
+			u8 delivery_mode:3;
+			u8 dest_mode:1;
+			u8 delivery_status:1;
+			u8 polarity:1;
+			u8 remote_irr:1;
+			u8 trig_mode:1;
+			u8 mask:1;
+			u8 reserve:7;
+			u8 reserved[4];
+			u8 dest_id;
+		} fields;
+	} redirtbl[IOAPIC_NUM_PINS];
+	struct kvm_io_device dev;
+	struct kvm *kvm;
+};
+
+#ifdef DEBUG
+#define ASSERT(x)  							\
+do {									\
+	if (!(x)) {							\
+		printk(KERN_EMERG "assertion failed %s: %d: %s\n",	\
+		       __FILE__, __LINE__, #x);				\
+		BUG();							\
+	}								\
+} while (0)
+#else
+#define ASSERT(x) do { } while (0)
+#endif
+
+static inline struct kvm_ioapic *ioapic_irqchip(struct kvm *kvm)
+{
+	return kvm->arch.vioapic;
+}
+
+#ifdef CONFIG_IA64
+static inline int irqchip_in_kernel(struct kvm *kvm)
+{
+	return 1;
+}
+#endif
+
+struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
+				       unsigned long bitmap);
+void kvm_ioapic_update_eoi(struct kvm *kvm, int vector);
+int kvm_ioapic_init(struct kvm *kvm);
+void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
+void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
+
+#endif
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index 6316638..c376b5b 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -25,7 +25,10 @@
 #include <linux/mm_types.h>
 #include <linux/hrtimer.h>
 #include <linux/kvm_host.h>
+
 #include "iodev.h"
+#include "ioapic.h"
+#include "lapic.h"
 
 struct kvm;
 struct kvm_vcpu;
@@ -65,131 +68,23 @@ void kvm_pic_set_irq(void *opaque, int irq, int level);
 int kvm_pic_read_irq(struct kvm_pic *s);
 void kvm_pic_update_irq(struct kvm_pic *s);
 
-#define IOAPIC_NUM_PINS  KVM_IOAPIC_NUM_PINS
-#define IOAPIC_VERSION_ID 0x11	/* IOAPIC version */
-#define IOAPIC_EDGE_TRIG  0
-#define IOAPIC_LEVEL_TRIG 1
-
-#define IOAPIC_DEFAULT_BASE_ADDRESS  0xfec00000
-#define IOAPIC_MEM_LENGTH            0x100
-
-/* Direct registers. */
-#define IOAPIC_REG_SELECT  0x00
-#define IOAPIC_REG_WINDOW  0x10
-#define IOAPIC_REG_EOI     0x40	/* IA64 IOSAPIC only */
-
-/* Indirect registers. */
-#define IOAPIC_REG_APIC_ID 0x00	/* x86 IOAPIC only */
-#define IOAPIC_REG_VERSION 0x01
-#define IOAPIC_REG_ARB_ID  0x02	/* x86 IOAPIC only */
-
-/*ioapic delivery mode*/
-#define	IOAPIC_FIXED			0x0
-#define	IOAPIC_LOWEST_PRIORITY		0x1
-#define	IOAPIC_PMI			0x2
-#define	IOAPIC_NMI			0x4
-#define	IOAPIC_INIT			0x5
-#define	IOAPIC_EXTINT			0x7
-
-struct kvm_ioapic {
-	u64 base_address;
-	u32 ioregsel;
-	u32 id;
-	u32 irr;
-	u32 pad;
-	union ioapic_redir_entry {
-		u64 bits;
-		struct {
-			u8 vector;
-			u8 delivery_mode:3;
-			u8 dest_mode:1;
-			u8 delivery_status:1;
-			u8 polarity:1;
-			u8 remote_irr:1;
-			u8 trig_mode:1;
-			u8 mask:1;
-			u8 reserve:7;
-			u8 reserved[4];
-			u8 dest_id;
-		} fields;
-	} redirtbl[IOAPIC_NUM_PINS];
-	struct kvm_io_device dev;
-	struct kvm *kvm;
-};
-
-struct kvm_lapic {
-	unsigned long base_address;
-	struct kvm_io_device dev;
-	struct {
-		atomic_t pending;
-		s64 period;	/* unit: ns */
-		u32 divide_count;
-		ktime_t last_update;
-		struct hrtimer dev;
-	} timer;
-	struct kvm_vcpu *vcpu;
-	struct page *regs_page;
-	void *regs;
-};
-
-#ifdef DEBUG
-#define ASSERT(x)  							\
-do {									\
-	if (!(x)) {							\
-		printk(KERN_EMERG "assertion failed %s: %d: %s\n",	\
-		       __FILE__, __LINE__, #x);				\
-		BUG();							\
-	}								\
-} while (0)
-#else
-#define ASSERT(x) do { } while (0)
-#endif
-
 static inline struct kvm_pic *pic_irqchip(struct kvm *kvm)
 {
 	return kvm->arch.vpic;
 }
 
-static inline struct kvm_ioapic *ioapic_irqchip(struct kvm *kvm)
-{
-	return kvm->arch.vioapic;
-}
-
 static inline int irqchip_in_kernel(struct kvm *kvm)
 {
 	return pic_irqchip(kvm) != NULL;
 }
 
-void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
-int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu);
-int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
-int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu);
-int kvm_create_lapic(struct kvm_vcpu *vcpu);
-void kvm_lapic_reset(struct kvm_vcpu *vcpu);
 void kvm_pic_reset(struct kvm_kpic_state *s);
-void kvm_ioapic_reset(struct kvm_ioapic *ioapic);
-void kvm_free_lapic(struct kvm_vcpu *vcpu);
-u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
-void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
-void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
 
-struct kvm_vcpu *kvm_get_lowest_prio_vcpu(struct kvm *kvm, u8 vector,
-				       unsigned long bitmap);
-u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
-void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data);
-int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
-void kvm_ioapic_update_eoi(struct kvm *kvm, int vector);
-int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
-int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 trig);
-void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu);
-int kvm_ioapic_init(struct kvm *kvm);
-void kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level);
-int kvm_lapic_enabled(struct kvm_vcpu *vcpu);
-int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
-void kvm_apic_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
 void kvm_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
 void kvm_inject_pending_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_inject_apic_timer_irqs(struct kvm_vcpu *vcpu);
 void kvm_migrate_apic_timer(struct kvm_vcpu *vcpu);
 
+void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
+
 #endif
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
new file mode 100644
index 0000000..447b654
--- /dev/null
+++ b/arch/x86/kvm/lapic.h
@@ -0,0 +1,44 @@
+#ifndef __KVM_X86_LAPIC_H
+#define __KVM_X86_LAPIC_H
+
+#include "iodev.h"
+
+#include <linux/kvm_host.h>
+
+struct kvm_lapic {
+	unsigned long base_address;
+	struct kvm_io_device dev;
+	struct {
+		atomic_t pending;
+		s64 period;	/* unit: ns */
+		u32 divide_count;
+		ktime_t last_update;
+		struct hrtimer dev;
+	} timer;
+	struct kvm_vcpu *vcpu;
+	struct page *regs_page;
+	void *regs;
+};
+int kvm_create_lapic(struct kvm_vcpu *vcpu);
+void kvm_free_lapic(struct kvm_vcpu *vcpu);
+
+int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu);
+int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
+int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu);
+void kvm_lapic_reset(struct kvm_vcpu *vcpu);
+u64 kvm_lapic_get_cr8(struct kvm_vcpu *vcpu);
+void kvm_lapic_set_tpr(struct kvm_vcpu *vcpu, unsigned long cr8);
+void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
+
+int kvm_apic_match_physical_addr(struct kvm_lapic *apic, u16 dest);
+int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda);
+int kvm_apic_set_irq(struct kvm_vcpu *vcpu, u8 vec, u8 trig);
+
+u64 kvm_get_apic_base(struct kvm_vcpu *vcpu);
+void kvm_set_apic_base(struct kvm_vcpu *vcpu, u64 data);
+void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu);
+int kvm_lapic_enabled(struct kvm_vcpu *vcpu);
+int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
+void kvm_apic_timer_intr_post(struct kvm_vcpu *vcpu, int vec);
+
+#endif
-- 
1.5.3.7

