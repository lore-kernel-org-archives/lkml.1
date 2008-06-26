Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbYFZMpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbYFZMpg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbYFZM35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:57 -0400
Received: from il.qumranet.com ([212.179.150.194]:32338 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752038AbYFZM2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng.yang@intel.com>
Subject: [PATCH 18/50] KVM: IOAPIC/LAPIC: Enable NMI support
Date: Thu, 26 Jun 2008 15:28:00 +0300
Message-Id: <1214483312-9265-19-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng.yang@intel.com>

[avi: fix ia64 build breakage]

Signed-off-by: Sheng Yang <sheng.yang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/lapic.c        |    3 ++-
 arch/x86/kvm/x86.c          |    6 ++++++
 include/asm-ia64/kvm_host.h |    2 ++
 include/asm-x86/kvm_host.h  |    4 ++++
 virt/kvm/ioapic.c           |   20 ++++++++++++++++++--
 5 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f9201fb..e48d193 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -356,8 +356,9 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 	case APIC_DM_SMI:
 		printk(KERN_DEBUG "Ignoring guest SMI\n");
 		break;
+
 	case APIC_DM_NMI:
-		printk(KERN_DEBUG "Ignoring guest NMI\n");
+		kvm_inject_nmi(vcpu);
 		break;
 
 	case APIC_DM_INIT:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 28642c4..2c308f0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -173,6 +173,12 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 	kvm_queue_exception_e(vcpu, PF_VECTOR, error_code);
 }
 
+void kvm_inject_nmi(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.nmi_pending = 1;
+}
+EXPORT_SYMBOL_GPL(kvm_inject_nmi);
+
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 {
 	WARN_ON(vcpu->arch.exception.pending);
diff --git a/include/asm-ia64/kvm_host.h b/include/asm-ia64/kvm_host.h
index c082c20..5c958b0 100644
--- a/include/asm-ia64/kvm_host.h
+++ b/include/asm-ia64/kvm_host.h
@@ -521,4 +521,6 @@ int kvm_emulate_halt(struct kvm_vcpu *vcpu);
 int kvm_pal_emul(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
 void kvm_sal_emul(struct kvm_vcpu *vcpu);
 
+static inline void kvm_inject_nmi(struct kvm_vcpu *vcpu) {}
+
 #endif
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 4bcdc7d..b666219 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -288,6 +288,8 @@ struct kvm_vcpu_arch {
 	unsigned int hv_clock_tsc_khz;
 	unsigned int time_offset;
 	struct page *time_page;
+
+	bool nmi_pending;
 };
 
 struct kvm_mem_alias {
@@ -515,6 +517,8 @@ void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long cr2,
 			   u32 error_code);
 
+void kvm_inject_nmi(struct kvm_vcpu *vcpu);
+
 void fx_init(struct kvm_vcpu *vcpu);
 
 int emulator_read_std(unsigned long addr,
diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 1dcf9f3..cb8a20b 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -146,6 +146,11 @@ static int ioapic_inj_irq(struct kvm_ioapic *ioapic,
 	return kvm_apic_set_irq(vcpu, vector, trig_mode);
 }
 
+static void ioapic_inj_nmi(struct kvm_vcpu *vcpu)
+{
+	kvm_inject_nmi(vcpu);
+}
+
 static u32 ioapic_get_delivery_bitmask(struct kvm_ioapic *ioapic, u8 dest,
 				       u8 dest_mode)
 {
@@ -239,8 +244,19 @@ static int ioapic_deliver(struct kvm_ioapic *ioapic, int irq)
 			}
 		}
 		break;
-
-		/* TODO: NMI */
+	case IOAPIC_NMI:
+		for (vcpu_id = 0; deliver_bitmask != 0; vcpu_id++) {
+			if (!(deliver_bitmask & (1 << vcpu_id)))
+				continue;
+			deliver_bitmask &= ~(1 << vcpu_id);
+			vcpu = ioapic->kvm->vcpus[vcpu_id];
+			if (vcpu)
+				ioapic_inj_nmi(vcpu);
+			else
+				ioapic_debug("NMI to vcpu %d failed\n",
+						vcpu->vcpu_id);
+		}
+		break;
 	default:
 		printk(KERN_WARNING "Unsupported delivery mode %d\n",
 		       delivery_mode);
-- 
1.5.6

