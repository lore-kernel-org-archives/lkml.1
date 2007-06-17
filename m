Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbXFQJ5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbXFQJ5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759505AbXFQJpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:23 -0400
Received: from il.qumranet.com ([82.166.9.18]:55161 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759436AbXFQJot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:49 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 48/58] KVM: Fix vcpu freeing for guest smp
Date: Sun, 17 Jun 2007 12:44:29 +0300
Message-Id: <11820734812868-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A vcpu can pin up to four mmu shadow pages, which means the freeing
loop will never terminate.  Fix by first unpinning shadow pages on
all vcpus, then freeing shadow pages.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |   15 +++++++++++++++
 drivers/kvm/mmu.c      |    4 ++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 3c3231d..3ff8ee5 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -381,6 +381,16 @@ static void free_pio_guest_pages(struct kvm_vcpu *vcpu)
 		}
 }
 
+static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->vmcs)
+		return;
+
+	vcpu_load(vcpu);
+	kvm_mmu_unload(vcpu);
+	vcpu_put(vcpu);
+}
+
 static void kvm_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	if (!vcpu->vmcs)
@@ -401,6 +411,11 @@ static void kvm_free_vcpus(struct kvm *kvm)
 {
 	unsigned int i;
 
+	/*
+	 * Unpin any mmu pages first.
+	 */
+	for (i = 0; i < KVM_MAX_VCPUS; ++i)
+		kvm_unload_vcpu_mmu(&kvm->vcpus[i]);
 	for (i = 0; i < KVM_MAX_VCPUS; ++i)
 		kvm_free_vcpu(&kvm->vcpus[i]);
 }
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 5915d7a..d4de988 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -838,11 +838,12 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 	int i;
 	struct kvm_mmu_page *page;
 
+	if (!VALID_PAGE(vcpu->mmu.root_hpa))
+		return;
 #ifdef CONFIG_X86_64
 	if (vcpu->mmu.shadow_root_level == PT64_ROOT_LEVEL) {
 		hpa_t root = vcpu->mmu.root_hpa;
 
-		ASSERT(VALID_PAGE(root));
 		page = page_header(root);
 		--page->root_count;
 		vcpu->mmu.root_hpa = INVALID_PAGE;
@@ -853,7 +854,6 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 		hpa_t root = vcpu->mmu.pae_root[i];
 
 		if (root) {
-			ASSERT(VALID_PAGE(root));
 			root &= PT64_BASE_ADDR_MASK;
 			page = page_header(root);
 			--page->root_count;
-- 
1.5.0.6

