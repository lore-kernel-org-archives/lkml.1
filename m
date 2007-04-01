Return-Path: <linux-kernel-owner+w=401wt.eu-S933291AbXDAOjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbXDAOjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:39:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbXDAOiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:38:55 -0400
Received: from il.qumranet.com ([82.166.9.18]:47541 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933291AbXDAOfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:45 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Dor Laor <dor.laor@qumranet.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 37/41] KVM: Add mmu cache clear function
Date: Sun,  1 Apr 2007 17:35:34 +0300
Message-Id: <1175438139458-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381392948-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com> <1175438139141-git-send-email-avi@qumranet.com> <11754381391993-git-send-email-avi@qumranet.com> <1175438139877-git-send-email-avi@qumranet.com> <11754381391119-git-send-email-avi@qumranet.com> <1175438139312-git-send-email-avi@qumranet.com> <11754381392527-git-send-email-avi@qumranet.com> <11754381393184-git-send-email-avi@qumranet.com> <1175438139249-git-send-email-avi@qumranet.com> <11754381391161-git-send-email-avi@qumranet.com> <11754381393714-git-send-email-avi@qumranet.com> <11754381392948-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dor Laor <dor.laor@qumranet.com>

Functions that play around with the physical memory map
need a way to clear mappings to possibly nonexistent or
invalid memory.  Both the mmu cache and the processor tlb
are cleared.

Signed-off-by: Dor Laor <dor.laor@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h |    1 +
 drivers/kvm/mmu.c |   17 +++++++++++++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 6d0bd7a..59357be 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -430,6 +430,7 @@ int kvm_mmu_setup(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_reset_context(struct kvm_vcpu *vcpu);
 void kvm_mmu_slot_remove_write_access(struct kvm_vcpu *vcpu, int slot);
+void kvm_mmu_zap_all(struct kvm_vcpu *vcpu);
 
 hpa_t gpa_to_hpa(struct kvm_vcpu *vcpu, gpa_t gpa);
 #define HPA_MSB ((sizeof(hpa_t) * 8) - 1)
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index c2487b6..707f63c 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1313,6 +1313,23 @@ void kvm_mmu_slot_remove_write_access(struct kvm_vcpu *vcpu, int slot)
 	}
 }
 
+void kvm_mmu_zap_all(struct kvm_vcpu *vcpu)
+{
+	destroy_kvm_mmu(vcpu);
+
+	while (!list_empty(&vcpu->kvm->active_mmu_pages)) {
+		struct kvm_mmu_page *page;
+
+		page = container_of(vcpu->kvm->active_mmu_pages.next,
+				    struct kvm_mmu_page, link);
+		kvm_mmu_zap_page(vcpu, page);
+	}
+
+	mmu_free_memory_caches(vcpu);
+	kvm_arch_ops->tlb_flush(vcpu);
+	init_kvm_mmu(vcpu);
+}
+
 #ifdef AUDIT
 
 static const char *audit_msg;
-- 
1.5.0.5

