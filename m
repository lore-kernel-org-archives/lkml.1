Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbYAFOkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbYAFOkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbYAFOjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:44 -0500
Received: from il.qumranet.com ([82.166.9.18]:46587 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbYAFOjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:41 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 03/33] KVM: Portability: Move kvm{pic,ioapic} accesors to x86 specific code
Date: Sun,  6 Jan 2008 16:39:09 +0200
Message-Id: <1199630379-28638-4-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/irq.h |   18 ++++++++++++++++--
 drivers/kvm/kvm.h |   18 +++---------------
 drivers/kvm/x86.h |    1 -
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/kvm/irq.h b/drivers/kvm/irq.h
index 730a87c..e88d939 100644
--- a/drivers/kvm/irq.h
+++ b/drivers/kvm/irq.h
@@ -26,6 +26,7 @@
 #include <linux/hrtimer.h>
 #include <asm/kvm.h>
 #include "iodev.h"
+#include "x86.h"
 
 struct kvm;
 struct kvm_vcpu;
@@ -63,8 +64,6 @@ struct kvm_pic {
 struct kvm_pic *kvm_create_pic(struct kvm *kvm);
 void kvm_pic_set_irq(void *opaque, int irq, int level);
 int kvm_pic_read_irq(struct kvm_pic *s);
-int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
-int kvm_cpu_has_interrupt(struct kvm_vcpu *v);
 void kvm_pic_update_irq(struct kvm_pic *s);
 
 #define IOAPIC_NUM_PINS  KVM_IOAPIC_NUM_PINS
@@ -147,6 +146,21 @@ do {									\
 #define ASSERT(x) do { } while (0)
 #endif
 
+static inline struct kvm_pic *pic_irqchip(struct kvm *kvm)
+{
+	return kvm->vpic;
+}
+
+static inline struct kvm_ioapic *ioapic_irqchip(struct kvm *kvm)
+{
+	return kvm->vioapic;
+}
+
+static inline int irqchip_in_kernel(struct kvm *kvm)
+{
+	return pic_irqchip(kvm) != NULL;
+}
+
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
 int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu);
 int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu);
diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index ceefb44..668a830 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -273,21 +273,6 @@ struct kvm {
 	struct kvm_vm_stat stat;
 };
 
-static inline struct kvm_pic *pic_irqchip(struct kvm *kvm)
-{
-	return kvm->vpic;
-}
-
-static inline struct kvm_ioapic *ioapic_irqchip(struct kvm *kvm)
-{
-	return kvm->vioapic;
-}
-
-static inline int irqchip_in_kernel(struct kvm *kvm)
-{
-	return pic_irqchip(kvm) != NULL;
-}
-
 /* The guest did something we don't support. */
 #define pr_unimpl(vcpu, fmt, ...)					\
  do {									\
@@ -417,6 +402,9 @@ void kvm_free_physmem(struct kvm *kvm);
 struct  kvm *kvm_arch_create_vm(void);
 void kvm_arch_destroy_vm(struct kvm *kvm);
 
+int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
+int kvm_cpu_has_interrupt(struct kvm_vcpu *v);
+
 static inline void kvm_guest_enter(void)
 {
 	account_system_vtime(current);
diff --git a/drivers/kvm/x86.h b/drivers/kvm/x86.h
index 78396d6..0fc7020 100644
--- a/drivers/kvm/x86.h
+++ b/drivers/kvm/x86.h
@@ -12,7 +12,6 @@
 #define KVM_X86_H
 
 #include "kvm.h"
-#include "irq.h"
 
 #include <linux/types.h>
 #include <linux/mm.h>
-- 
1.5.3.7

