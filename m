Return-Path: <linux-kernel-owner+w=401wt.eu-S933664AbZHWL6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664AbZHWL6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 07:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933600AbZHWL6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 07:58:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933550AbZHWL4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 07:56:50 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/46] KVM: Add trace points in irqchip code
Date: Sun, 23 Aug 2009 14:56:15 +0300
Message-Id: <1251028605-31977-17-git-send-email-avi@redhat.com>
In-Reply-To: <1251028605-31977-1-git-send-email-avi@redhat.com>
References: <1251028605-31977-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Add tracepoint in msi/ioapic/pic set_irq() functions,
in IPI sending and in the point where IRQ is placed into
apic's IRR.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/i8259.c       |    3 ++
 arch/x86/kvm/lapic.c       |    4 ++
 arch/x86/kvm/trace.h       |   85 ++++++++++++++++++++++++++++++++++++++++++++
 include/trace/events/kvm.h |   56 +++++++++++++++++++++++++++++
 virt/kvm/ioapic.c          |    2 +
 virt/kvm/irq_comm.c        |    2 +
 6 files changed, 152 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 1d1bb75..e4bcbdd 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -30,6 +30,7 @@
 #include "irq.h"
 
 #include <linux/kvm_host.h>
+#include "trace.h"
 
 static void pic_lock(struct kvm_pic *s)
 	__acquires(&s->lock)
@@ -190,6 +191,8 @@ int kvm_pic_set_irq(void *opaque, int irq, int level)
 	if (irq >= 0 && irq < PIC_NUM_PINS) {
 		ret = pic_set_irq1(&s->pics[irq >> 3], irq & 7, level);
 		pic_update_irq(s);
+		trace_kvm_pic_set_irq(irq >> 3, irq & 7, s->pics[irq >> 3].elcr,
+				      s->pics[irq >> 3].imr, ret == 0);
 	}
 	pic_unlock(s);
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 31f1d1c..3b03ebd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -375,6 +375,8 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 			break;
 
 		result = !apic_test_and_set_irr(vector, apic);
+		trace_kvm_apic_accept_irq(vcpu->vcpu_id, delivery_mode,
+					  trig_mode, vector, result);
 		if (!result) {
 			if (trig_mode)
 				apic_debug("level trig mode repeatedly for "
@@ -493,6 +495,8 @@ static void apic_send_ipi(struct kvm_lapic *apic)
 	else
 		irq.dest_id = GET_APIC_DEST_FIELD(icr_high);
 
+	trace_kvm_apic_ipi(icr_low, irq.dest_id);
+
 	apic_debug("icr_high 0x%x, icr_low 0x%x, "
 		   "short_hand 0x%x, dest 0x%x, trig_mode 0x%x, level 0x%x, "
 		   "dest_mode 0x%x, delivery_mode 0x%x, vector 0x%x\n",
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 6c2c87f..0d480e7 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -264,6 +264,91 @@ TRACE_EVENT(kvm_cr,
 #define trace_kvm_cr_read(cr, val)		trace_kvm_cr(0, cr, val)
 #define trace_kvm_cr_write(cr, val)		trace_kvm_cr(1, cr, val)
 
+TRACE_EVENT(kvm_pic_set_irq,
+	    TP_PROTO(__u8 chip, __u8 pin, __u8 elcr, __u8 imr, bool coalesced),
+	    TP_ARGS(chip, pin, elcr, imr, coalesced),
+
+	TP_STRUCT__entry(
+		__field(	__u8,		chip		)
+		__field(	__u8,		pin		)
+		__field(	__u8,		elcr		)
+		__field(	__u8,		imr		)
+		__field(	bool,		coalesced	)
+	),
+
+	TP_fast_assign(
+		__entry->chip		= chip;
+		__entry->pin		= pin;
+		__entry->elcr		= elcr;
+		__entry->imr		= imr;
+		__entry->coalesced	= coalesced;
+	),
+
+	TP_printk("chip %u pin %u (%s%s)%s",
+		  __entry->chip, __entry->pin,
+		  (__entry->elcr & (1 << __entry->pin)) ? "level":"edge",
+		  (__entry->imr & (1 << __entry->pin)) ? "|masked":"",
+		  __entry->coalesced ? " (coalesced)" : "")
+);
+
+#define kvm_apic_dst_shorthand		\
+	{0x0, "dst"},			\
+	{0x1, "self"},			\
+	{0x2, "all"},			\
+	{0x3, "all-but-self"}
+
+TRACE_EVENT(kvm_apic_ipi,
+	    TP_PROTO(__u32 icr_low, __u32 dest_id),
+	    TP_ARGS(icr_low, dest_id),
+
+	TP_STRUCT__entry(
+		__field(	__u32,		icr_low		)
+		__field(	__u32,		dest_id		)
+	),
+
+	TP_fast_assign(
+		__entry->icr_low	= icr_low;
+		__entry->dest_id	= dest_id;
+	),
+
+	TP_printk("dst %x vec %u (%s|%s|%s|%s|%s)",
+		  __entry->dest_id, (u8)__entry->icr_low,
+		  __print_symbolic((__entry->icr_low >> 8 & 0x7),
+				   kvm_deliver_mode),
+		  (__entry->icr_low & (1<<11)) ? "logical" : "physical",
+		  (__entry->icr_low & (1<<14)) ? "assert" : "de-assert",
+		  (__entry->icr_low & (1<<15)) ? "level" : "edge",
+		  __print_symbolic((__entry->icr_low >> 18 & 0x3),
+				   kvm_apic_dst_shorthand))
+);
+
+TRACE_EVENT(kvm_apic_accept_irq,
+	    TP_PROTO(__u32 apicid, __u16 dm, __u8 tm, __u8 vec, bool coalesced),
+	    TP_ARGS(apicid, dm, tm, vec, coalesced),
+
+	TP_STRUCT__entry(
+		__field(	__u32,		apicid		)
+		__field(	__u16,		dm		)
+		__field(	__u8,		tm		)
+		__field(	__u8,		vec		)
+		__field(	bool,		coalesced	)
+	),
+
+	TP_fast_assign(
+		__entry->apicid		= apicid;
+		__entry->dm		= dm;
+		__entry->tm		= tm;
+		__entry->vec		= vec;
+		__entry->coalesced	= coalesced;
+	),
+
+	TP_printk("apicid %x vec %u (%s|%s)%s",
+		  __entry->apicid, __entry->vec,
+		  __print_symbolic((__entry->dm >> 8 & 0x7), kvm_deliver_mode),
+		  __entry->tm ? "level" : "edge",
+		  __entry->coalesced ? " (coalesced)" : "")
+);
+
 #endif /* _TRACE_KVM_H */
 
 /* This part must be outside protection */
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 77022af..dbe1084 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -28,6 +28,62 @@ TRACE_EVENT(kvm_set_irq,
 		  __entry->gsi, __entry->level, __entry->irq_source_id)
 );
 
+#define kvm_deliver_mode		\
+	{0x0, "Fixed"},			\
+	{0x1, "LowPrio"},		\
+	{0x2, "SMI"},			\
+	{0x3, "Res3"},			\
+	{0x4, "NMI"},			\
+	{0x5, "INIT"},			\
+	{0x6, "SIPI"},			\
+	{0x7, "ExtINT"}
+
+TRACE_EVENT(kvm_ioapic_set_irq,
+	    TP_PROTO(__u64 e, int pin, bool coalesced),
+	    TP_ARGS(e, pin, coalesced),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		e		)
+		__field(	int,		pin		)
+		__field(	bool,		coalesced	)
+	),
+
+	TP_fast_assign(
+		__entry->e		= e;
+		__entry->pin		= pin;
+		__entry->coalesced	= coalesced;
+	),
+
+	TP_printk("pin %u dst %x vec=%u (%s|%s|%s%s)%s",
+		  __entry->pin, (u8)(__entry->e >> 56), (u8)__entry->e,
+		  __print_symbolic((__entry->e >> 8 & 0x7), kvm_deliver_mode),
+		  (__entry->e & (1<<11)) ? "logical" : "physical",
+		  (__entry->e & (1<<15)) ? "level" : "edge",
+		  (__entry->e & (1<<16)) ? "|masked" : "",
+		  __entry->coalesced ? " (coalesced)" : "")
+);
+
+TRACE_EVENT(kvm_msi_set_irq,
+	    TP_PROTO(__u64 address, __u64 data),
+	    TP_ARGS(address, data),
+
+	TP_STRUCT__entry(
+		__field(	__u64,		address		)
+		__field(	__u64,		data		)
+	),
+
+	TP_fast_assign(
+		__entry->address	= address;
+		__entry->data		= data;
+	),
+
+	TP_printk("dst %u vec %x (%s|%s|%s%s)",
+		  (u8)(__entry->address >> 12), (u8)__entry->data,
+		  __print_symbolic((__entry->data >> 8 & 0x7), kvm_deliver_mode),
+		  (__entry->address & (1<<2)) ? "logical" : "physical",
+		  (__entry->data & (1<<15)) ? "level" : "edge",
+		  (__entry->address & (1<<3)) ? "|rh" : "")
+);
 
 #define kvm_irqchips						\
 	{KVM_IRQCHIP_PIC_MASTER,	"PIC master"},		\
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 92496ff..b91fbb2 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -36,6 +36,7 @@
 #include <asm/processor.h>
 #include <asm/page.h>
 #include <asm/current.h>
+#include <trace/events/kvm.h>
 
 #include "ioapic.h"
 #include "lapic.h"
@@ -193,6 +194,7 @@ int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int level)
 			    (!edge && !entry.fields.remote_irr))
 				ret = ioapic_service(ioapic, irq);
 		}
+		trace_kvm_ioapic_set_irq(entry.bits, irq, ret == 0);
 	}
 	return ret;
 }
diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
index a9d7fd1..001663f 100644
--- a/virt/kvm/irq_comm.c
+++ b/virt/kvm/irq_comm.c
@@ -100,6 +100,8 @@ static int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 {
 	struct kvm_lapic_irq irq;
 
+	trace_kvm_msi_set_irq(e->msi.address_lo, e->msi.data);
+
 	irq.dest_id = (e->msi.address_lo &
 			MSI_ADDR_DEST_ID_MASK) >> MSI_ADDR_DEST_ID_SHIFT;
 	irq.vector = (e->msi.data &
-- 
1.6.4.1

