Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbXL3HNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbXL3HNq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbXL3HKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:10:55 -0500
Received: from il.qumranet.com ([82.166.9.18]:59485 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbXL3HKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Amit Shah <amit.shah@qumranet.com>
Subject: [PATCH 09/52] KVM: Make unloading of FPU state when putting vcpu arch-independent
Date: Sun, 30 Dec 2007 09:09:55 +0200
Message-Id: <1198998638-22713-10-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amit Shah <amit.shah@qumranet.com>

Instead of having each architecture do it individually, we
do this in the arch-independent code (just x86 as of now).

[avi: add svm to the mix, which was added to mainline during the
 2.6.24-rc process]

Signed-off-by: Amit Shah <amit.shah@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    1 -
 drivers/kvm/vmx.c |    1 -
 drivers/kvm/x86.c |    1 +
 3 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 94c51a0..928fb35 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -659,7 +659,6 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
 
 	rdtscll(vcpu->host_tsc);
-	kvm_put_guest_fpu(vcpu);
 }
 
 static void svm_vcpu_decache(struct kvm_vcpu *vcpu)
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index 4e60cf9..c23f399 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -541,7 +541,6 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	vmx_load_host_state(to_vmx(vcpu));
-	kvm_put_guest_fpu(vcpu);
 }
 
 static void vmx_fpu_activate(struct kvm_vcpu *vcpu)
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index fdc7632..9618fcb 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -678,6 +678,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	kvm_x86_ops->vcpu_put(vcpu);
+	kvm_put_guest_fpu(vcpu);
 }
 
 static void cpuid_fix_nx_cap(struct kvm_vcpu *vcpu)
-- 
1.5.3.7

