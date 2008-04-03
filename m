Return-Path: <linux-kernel-owner+w=401wt.eu-S1763078AbYDCTij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763078AbYDCTij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761086AbYDCTdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:14 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53041
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760370AbYDCTc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:59 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/35] KVM: Provide unlocked version of emulator_write_phys()
Date: Thu,  3 Apr 2008 22:32:35 +0300
Message-Id: <1207251170-5013-21-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c         |   21 ++++++++++++++-------
 include/asm-x86/kvm_host.h |    3 +++
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b9e695..03ba402 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1840,22 +1840,29 @@ mmio:
 	return X86EMUL_UNHANDLEABLE;
 }
 
-static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
-			       const void *val, int bytes)
+int __emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+			  const void *val, int bytes)
 {
 	int ret;
 
-	down_read(&vcpu->kvm->slots_lock);
 	ret = kvm_write_guest(vcpu->kvm, gpa, val, bytes);
-	if (ret < 0) {
-		up_read(&vcpu->kvm->slots_lock);
+	if (ret < 0)
 		return 0;
-	}
 	kvm_mmu_pte_write(vcpu, gpa, val, bytes);
-	up_read(&vcpu->kvm->slots_lock);
 	return 1;
 }
 
+static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+			const void *val, int bytes)
+{
+	int ret;
+
+	down_read(&vcpu->kvm->slots_lock);
+	ret =__emulator_write_phys(vcpu, gpa, val, bytes);
+	up_read(&vcpu->kvm->slots_lock);
+	return ret;
+}
+
 static int emulator_write_emulated_onepage(unsigned long addr,
 					   const void *val,
 					   unsigned int bytes,
diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index 12932bb..c8e51f8 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -431,6 +431,9 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int kvm_nr_mmu_pages);
 
 int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 
+int __emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
+			  const void *val, int bytes);
+
 enum emulation_result {
 	EMULATE_DONE,       /* no further processing */
 	EMULATE_DO_MMIO,      /* kvm_run filled with mmio request */
-- 
1.5.4.5

