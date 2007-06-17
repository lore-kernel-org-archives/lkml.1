Return-Path: <linux-kernel-owner+w=401wt.eu-S1761638AbXFQJ6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761638AbXFQJ6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbXFQJp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:29 -0400
Received: from il.qumranet.com ([82.166.9.18]:55207 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759455AbXFQJou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:50 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 53/58] KVM: Keep an upper bound of initialized vcpus
Date: Sun, 17 Jun 2007 12:44:34 +0300
Message-Id: <1182073481358-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That way, we don't need to loop for KVM_MAX_VCPUS for a single vcpu
vm.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index d49b16c..528a56b 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -379,6 +379,7 @@ struct kvm {
 	struct list_head active_mmu_pages;
 	int n_free_mmu_pages;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
+	int nvcpus;
 	struct kvm_vcpu vcpus[KVM_MAX_VCPUS];
 	int memory_config_version;
 	int busy;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 5564169..4e1a017 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2391,6 +2391,11 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 	if (r < 0)
 		goto out_free_vcpus;
 
+	spin_lock(&kvm_lock);
+	if (n >= kvm->nvcpus)
+		kvm->nvcpus = n + 1;
+	spin_unlock(&kvm_lock);
+
 	return r;
 
 out_free_vcpus:
-- 
1.5.0.6

