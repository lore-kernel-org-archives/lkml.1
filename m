Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbXL3HOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbXL3HOB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbXL3HK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:10:57 -0500
Received: from il.qumranet.com ([82.166.9.18]:59487 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbXL3HKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:44 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 11/52] KVM: Portability: MMU initialization and teardown split
Date: Sun, 30 Dec 2007 09:09:57 +0200
Message-Id: <1198998638-22713-12-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Move out kvm_mmu init and exit functionality from kvm_main.c

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    8 --------
 drivers/kvm/x86.c      |   24 +++++++++++++++++++-----
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index e64dfa2..f9fd865 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1383,10 +1383,6 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 	int r;
 	int cpu;
 
-	r = kvm_mmu_module_init();
-	if (r)
-		goto out4;
-
 	kvm_init_debug();
 
 	r = kvm_arch_init(opaque);
@@ -1446,8 +1442,6 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
 
-	kvm_mmu_set_nonpresent_ptes(0ull, 0ull);
-
 	return 0;
 
 out_free:
@@ -1466,7 +1460,6 @@ out_free_0:
 out:
 	kvm_arch_exit();
 	kvm_exit_debug();
-	kvm_mmu_module_exit();
 out4:
 	return r;
 }
@@ -1485,6 +1478,5 @@ void kvm_exit(void)
 	kvm_arch_exit();
 	kvm_exit_debug();
 	__free_page(bad_page);
-	kvm_mmu_module_exit();
 }
 EXPORT_SYMBOL_GPL(kvm_exit);
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 935e276..2257a0a 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1711,33 +1711,47 @@ EXPORT_SYMBOL_GPL(kvm_emulate_pio_string);
 
 int kvm_arch_init(void *opaque)
 {
+	int r;
 	struct kvm_x86_ops *ops = (struct kvm_x86_ops *)opaque;
 
+	r = kvm_mmu_module_init();
+	if (r)
+		goto out_fail;
+
 	kvm_init_msr_list();
 
 	if (kvm_x86_ops) {
 		printk(KERN_ERR "kvm: already loaded the other module\n");
-		return -EEXIST;
+		r = -EEXIST;
+		goto out;
 	}
 
 	if (!ops->cpu_has_kvm_support()) {
 		printk(KERN_ERR "kvm: no hardware support\n");
-		return -EOPNOTSUPP;
+		r = -EOPNOTSUPP;
+		goto out;
 	}
 	if (ops->disabled_by_bios()) {
 		printk(KERN_ERR "kvm: disabled by bios\n");
-		return -EOPNOTSUPP;
+		r = -EOPNOTSUPP;
+		goto out;
 	}
 
 	kvm_x86_ops = ops;
-
+	kvm_mmu_set_nonpresent_ptes(0ull, 0ull);
 	return 0;
+
+out:
+	kvm_mmu_module_exit();
+out_fail:
+	return r;
 }
 
 void kvm_arch_exit(void)
 {
 	kvm_x86_ops = NULL;
- }
+	kvm_mmu_module_exit();
+}
 
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 {
-- 
1.5.3.7

