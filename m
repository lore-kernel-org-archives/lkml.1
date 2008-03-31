Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYCaOno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYCaOno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbYCaOhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:42 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51320
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbYCaOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:33 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/40] KVM: make EFER_RESERVED_BITS configurable for architecture code
Date: Mon, 31 Mar 2008 17:37:00 +0300
Message-Id: <1206974244-9716-17-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch give the SVM and VMX implementations the ability to add some bits
the guest can set in its EFER register.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c         |   11 +++++++++--
 include/asm-x86/kvm_host.h |    1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6b01552..ec9265b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -41,7 +41,7 @@
 			  | X86_CR4_OSXMMEXCPT | X86_CR4_VMXE))
 
 #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
-#define EFER_RESERVED_BITS 0xfffffffffffff2fe
+static u64 __read_mostly efer_reserved_bits = 0xfffffffffffff2fe;
 
 #define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
 #define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
@@ -428,7 +428,7 @@ static u32 emulated_msrs[] = {
 
 static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
-	if (efer & EFER_RESERVED_BITS) {
+	if (efer & efer_reserved_bits) {
 		printk(KERN_DEBUG "set_efer: 0x%llx #GP, reserved bits\n",
 		       efer);
 		kvm_inject_gp(vcpu, 0);
@@ -452,6 +452,13 @@ static void set_efer(struct kvm_vcpu *vcpu, u64 efer)
 
 #endif
 
+void kvm_enable_efer_bits(u64 mask)
+{
+       efer_reserved_bits &= ~mask;
+}
+EXPORT_SYMBOL_GPL(kvm_enable_efer_bits);
+
+
 /*
  * Writes msr value into into the appropriate "register".
  * Returns 0 on success, non-0 otherwise.
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 67ae307..92668fa 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -429,6 +429,7 @@ void realmode_lmsw(struct kvm_vcpu *vcpu, unsigned long msw,
 unsigned long realmode_get_cr(struct kvm_vcpu *vcpu, int cr);
 void realmode_set_cr(struct kvm_vcpu *vcpu, int cr, unsigned long value,
 		     unsigned long *rflags);
+void kvm_enable_efer_bits(u64);
 int kvm_get_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *data);
 int kvm_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
 
-- 
1.5.4.5

