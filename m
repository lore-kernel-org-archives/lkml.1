Return-Path: <linux-kernel-owner+w=401wt.eu-S1761702AbXFQJ5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbXFQJ5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759705AbXFQJpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:24 -0400
Received: from il.qumranet.com ([82.166.9.18]:55154 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759437AbXFQJot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:49 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 49/58] KVM: Fix adding an smp virtual machine to the vm list
Date: Sun, 17 Jun 2007 12:44:30 +0300
Message-Id: <1182073481659-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If we add the vm once per vcpu, we corrupt the list if the guest has
multiple vcpus.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 3ff8ee5..230b25a 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -319,6 +319,9 @@ static struct kvm *kvm_create_vm(void)
 
 	spin_lock_init(&kvm->lock);
 	INIT_LIST_HEAD(&kvm->active_mmu_pages);
+	spin_lock(&kvm_lock);
+	list_add(&kvm->vm_list, &vm_list);
+	spin_unlock(&kvm_lock);
 	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
 		struct kvm_vcpu *vcpu = &kvm->vcpus[i];
 
@@ -326,9 +329,6 @@ static struct kvm *kvm_create_vm(void)
 		vcpu->cpu = -1;
 		vcpu->kvm = kvm;
 		vcpu->mmu.root_hpa = INVALID_PAGE;
-		spin_lock(&kvm_lock);
-		list_add(&kvm->vm_list, &vm_list);
-		spin_unlock(&kvm_lock);
 	}
 	return kvm;
 }
-- 
1.5.0.6

