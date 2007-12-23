Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbXLWO6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbXLWO6x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 09:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXLWOwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:03 -0500
Received: from il.qumranet.com ([82.166.9.18]:35922 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbXLWOvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 24/50] KVM: Hoist kvm_create_lapic() into kvm_vcpu_init()
Date: Sun, 23 Dec 2007 16:51:09 +0200
Message-Id: <1198421495-31481-25-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Move kvm_create_lapic() into kvm_vcpu_init(), rather than having svm
and vmx do it.  And make it return the error rather than a fairly
random -ENOMEM.

This also solves the problem that neither svm.c nor vmx.c actually
handles the error path properly.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   10 +++++++++-
 drivers/kvm/svm.c      |    6 ------
 drivers/kvm/vmx.c      |    6 ------
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 760753d..0a04b75 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -255,14 +255,22 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	if (r < 0)
 		goto fail_free_pio_data;
 
+	if (irqchip_in_kernel(kvm)) {
+		r = kvm_create_lapic(vcpu);
+		if (r < 0)
+			goto fail_mmu_destroy;
+	}
+
 	return 0;
 
+fail_mmu_destroy:
+	kvm_mmu_destroy(vcpu);
 fail_free_pio_data:
 	free_page((unsigned long)vcpu->pio_data);
 fail_free_run:
 	free_page((unsigned long)vcpu->run);
 fail:
-	return -ENOMEM;
+	return r;
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_init);
 
diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index a0eef78..f2278d0 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -588,12 +588,6 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (err)
 		goto free_svm;
 
-	if (irqchip_in_kernel(kvm)) {
-		err = kvm_create_lapic(&svm->vcpu);
-		if (err < 0)
-			goto free_svm;
-	}
-
 	page = alloc_page(GFP_KERNEL);
 	if (!page) {
 		err = -ENOMEM;
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index ce15e51..718d1f4 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -2431,12 +2431,6 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (err)
 		goto free_vcpu;
 
-	if (irqchip_in_kernel(kvm)) {
-		err = kvm_create_lapic(&vmx->vcpu);
-		if (err < 0)
-			goto free_vcpu;
-	}
-
 	vmx->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!vmx->guest_msrs) {
 		err = -ENOMEM;
-- 
1.5.3.7

