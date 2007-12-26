Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbXLZLTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbXLZLTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbXLZLG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:57 -0500
Received: from il.qumranet.com ([82.166.9.18]:50468 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbXLZLGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:07 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 37/55] KVM: VMX: Use vmx to inject real-mode interrupts
Date: Wed, 26 Dec 2007 13:05:42 +0200
Message-Id: <1198667160-22953-38-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of injecting real-mode interrupts by writing the interrupt frame into
guest memory, abuse vmx by injecting a software interrupt.  We need to
pretend the software interrupt instruction had a length > 0, so we have to
adjust rip backward.

This lets us not to mess with writing guest memory, which is complex and also
sleeps.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   53 ++++-------------------------------------------------
 drivers/kvm/vmx.h |    1 +
 2 files changed, 5 insertions(+), 49 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 6fc981d..1166132 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1709,58 +1709,13 @@ out:
 	return ret;
 }
 
-static void inject_rmode_irq(struct kvm_vcpu *vcpu, int irq)
-{
-	u16 ent[2];
-	u16 cs;
-	u16 ip;
-	unsigned long flags;
-	unsigned long ss_base = vmcs_readl(GUEST_SS_BASE);
-	u16 sp =  vmcs_readl(GUEST_RSP);
-	u32 ss_limit = vmcs_read32(GUEST_SS_LIMIT);
-
-	if (sp > ss_limit || sp < 6) {
-		vcpu_printf(vcpu, "%s: #SS, rsp 0x%lx ss 0x%lx limit 0x%x\n",
-			    __FUNCTION__,
-			    vmcs_readl(GUEST_RSP),
-			    vmcs_readl(GUEST_SS_BASE),
-			    vmcs_read32(GUEST_SS_LIMIT));
-		return;
-	}
-
-	if (emulator_read_std(irq * sizeof(ent), &ent, sizeof(ent), vcpu) !=
-							X86EMUL_CONTINUE) {
-		vcpu_printf(vcpu, "%s: read guest err\n", __FUNCTION__);
-		return;
-	}
-
-	flags =  vmcs_readl(GUEST_RFLAGS);
-	cs =  vmcs_readl(GUEST_CS_BASE) >> 4;
-	ip =  vmcs_readl(GUEST_RIP);
-
-
-	if (emulator_write_emulated(
-		    ss_base + sp - 2, &flags, 2, vcpu) != X86EMUL_CONTINUE ||
-	    emulator_write_emulated(
-		    ss_base + sp - 4, &cs, 2, vcpu) != X86EMUL_CONTINUE ||
-	    emulator_write_emulated(
-		    ss_base + sp - 6, &ip, 2, vcpu) != X86EMUL_CONTINUE) {
-		vcpu_printf(vcpu, "%s: write guest err\n", __FUNCTION__);
-		return;
-	}
-
-	vmcs_writel(GUEST_RFLAGS, flags &
-		    ~(X86_EFLAGS_IF | X86_EFLAGS_AC | X86_EFLAGS_TF));
-	vmcs_write16(GUEST_CS_SELECTOR, ent[1]) ;
-	vmcs_writel(GUEST_CS_BASE, ent[1] << 4);
-	vmcs_writel(GUEST_RIP, ent[0]);
-	vmcs_writel(GUEST_RSP, (vmcs_readl(GUEST_RSP) & ~0xffff) | (sp - 6));
-}
-
 static void vmx_inject_irq(struct kvm_vcpu *vcpu, int irq)
 {
 	if (vcpu->rmode.active) {
-		inject_rmode_irq(vcpu, irq);
+		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
+			     irq | INTR_TYPE_SOFT_INTR | INTR_INFO_VALID_MASK);
+		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN, 1);
+		vmcs_writel(GUEST_RIP, vmcs_readl(GUEST_RIP) - 1);
 		return;
 	}
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
diff --git a/drivers/kvm/vmx.h b/drivers/kvm/vmx.h
index c84bd37..d757b36 100644
--- a/drivers/kvm/vmx.h
+++ b/drivers/kvm/vmx.h
@@ -233,6 +233,7 @@ enum vmcs_field {
 
 #define INTR_TYPE_EXT_INTR              (0 << 8) /* external interrupt */
 #define INTR_TYPE_EXCEPTION             (3 << 8) /* processor exception */
+#define INTR_TYPE_SOFT_INTR             (4 << 8) /* software interrupt */
 
 /*
  * Exit Qualifications for MOV for Control Register Access
-- 
1.5.3.7

