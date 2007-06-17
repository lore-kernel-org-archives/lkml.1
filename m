Return-Path: <linux-kernel-owner+w=401wt.eu-S1761066AbXFQJwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761066AbXFQJwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759610AbXFQJpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:00 -0400
Received: from il.qumranet.com ([82.166.9.18]:55201 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759001AbXFQJop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 23/58] KVM: VMX: Use local labels in inline assembly
Date: Sun, 17 Jun 2007 12:44:04 +0300
Message-Id: <1182073480627-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This makes oprofile dumps and disassebly easier to read.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/vmx.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 34171d9..c4c5535 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1188,7 +1188,7 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 	struct descriptor_table dt;
 	int i;
 	int ret = 0;
-	extern asmlinkage void kvm_vmx_return(void);
+	unsigned long kvm_vmx_return;
 
 	if (!init_rmode_tss(vcpu->kvm)) {
 		ret = -ENOMEM;
@@ -1306,8 +1306,8 @@ static int vmx_vcpu_setup(struct kvm_vcpu *vcpu)
 	get_idt(&dt);
 	vmcs_writel(HOST_IDTR_BASE, dt.base);   /* 22.2.4 */
 
-
-	vmcs_writel(HOST_RIP, (unsigned long)kvm_vmx_return); /* 22.2.5 */
+	asm ("mov $.Lkvm_vmx_return, %0" : "=r"(kvm_vmx_return));
+	vmcs_writel(HOST_RIP, kvm_vmx_return); /* 22.2.5 */
 
 	rdmsr(MSR_IA32_SYSENTER_CS, host_sysenter_cs, junk);
 	vmcs_write32(HOST_IA32_SYSENTER_CS, host_sysenter_cs);
@@ -1997,12 +1997,11 @@ again:
 		"mov %c[rcx](%3), %%ecx \n\t" /* kills %3 (ecx) */
 #endif
 		/* Enter guest mode */
-		"jne launched \n\t"
+		"jne .Llaunched \n\t"
 		ASM_VMX_VMLAUNCH "\n\t"
-		"jmp kvm_vmx_return \n\t"
-		"launched: " ASM_VMX_VMRESUME "\n\t"
-		".globl kvm_vmx_return \n\t"
-		"kvm_vmx_return: "
+		"jmp .Lkvm_vmx_return \n\t"
+		".Llaunched: " ASM_VMX_VMRESUME "\n\t"
+		".Lkvm_vmx_return: "
 		/* Save guest registers, load host registers, keep flags */
 #ifdef CONFIG_X86_64
 		"xchg %3,     (%%rsp) \n\t"
-- 
1.5.0.6

