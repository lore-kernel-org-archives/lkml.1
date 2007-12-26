Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbXLZLZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbXLZLZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbXLZLHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:07:17 -0500
Received: from il.qumranet.com ([82.166.9.18]:50489 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbXLZLGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:11 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 51/55] KVM: Portability: Move x86 specific code from kvm_init() to kvm_arch()
Date: Wed, 26 Dec 2007 13:05:56 +0200
Message-Id: <1198667160-22953-52-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    5 +++--
 drivers/kvm/kvm_main.c |   26 ++++++--------------------
 drivers/kvm/x86.c      |   27 ++++++++++++++++++++++++++-
 3 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 5e7be15..96d9c7d 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -495,7 +495,7 @@ void vcpu_put(struct kvm_vcpu *vcpu);
 void decache_vcpus_on_cpu(int cpu);
 
 
-int kvm_init(struct kvm_x86_ops *ops, unsigned int vcpu_size,
+int kvm_init(void *opaque, unsigned int vcpu_size,
 		  struct module *module);
 void kvm_exit(void);
 
@@ -649,7 +649,8 @@ int kvm_arch_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
 				    struct kvm_debug_guest *dbg);
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run);
 
-__init void kvm_arch_init(void);
+int kvm_arch_init(void *opaque);
+void kvm_arch_exit(void);
 
 int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 510f2d1..5d6d5d4 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1434,7 +1434,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 	kvm_arch_vcpu_put(vcpu);
 }
 
-int kvm_init(struct kvm_x86_ops *ops, unsigned int vcpu_size,
+int kvm_init(void *opaque, unsigned int vcpu_size,
 		  struct module *module)
 {
 	int r;
@@ -1446,7 +1446,9 @@ int kvm_init(struct kvm_x86_ops *ops, unsigned int vcpu_size,
 
 	kvm_init_debug();
 
-	kvm_arch_init();
+	r = kvm_arch_init(opaque);
+	if (r)
+		goto out4;
 
 	bad_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 
@@ -1455,22 +1457,6 @@ int kvm_init(struct kvm_x86_ops *ops, unsigned int vcpu_size,
 		goto out;
 	}
 
-	if (kvm_x86_ops) {
-		printk(KERN_ERR "kvm: already loaded the other module\n");
-		return -EEXIST;
-	}
-
-	if (!ops->cpu_has_kvm_support()) {
-		printk(KERN_ERR "kvm: no hardware support\n");
-		return -EOPNOTSUPP;
-	}
-	if (ops->disabled_by_bios()) {
-		printk(KERN_ERR "kvm: disabled by bios\n");
-		return -EOPNOTSUPP;
-	}
-
-	kvm_x86_ops = ops;
-
 	r = kvm_arch_hardware_setup();
 	if (r < 0)
 		goto out;
@@ -1534,7 +1520,7 @@ out_free_1:
 out_free_0:
 	kvm_arch_hardware_unsetup();
 out:
-	kvm_x86_ops = NULL;
+	kvm_arch_exit();
 	kvm_exit_debug();
 	kvm_mmu_module_exit();
 out4:
@@ -1552,7 +1538,7 @@ void kvm_exit(void)
 	unregister_cpu_notifier(&kvm_cpu_notifier);
 	on_each_cpu(hardware_disable, NULL, 0, 1);
 	kvm_arch_hardware_unsetup();
-	kvm_x86_ops = NULL;
+	kvm_arch_exit();
 	kvm_exit_debug();
 	__free_page(bad_page);
 	kvm_mmu_module_exit();
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 4902b35..bbfa810 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1645,11 +1645,36 @@ int kvm_emulate_pio_string(struct kvm_vcpu *vcpu, struct kvm_run *run, int in,
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_pio_string);
 
-__init void kvm_arch_init(void)
+int kvm_arch_init(void *opaque)
 {
+	struct kvm_x86_ops *ops = (struct kvm_x86_ops *)opaque;
+
 	kvm_init_msr_list();
+
+	if (kvm_x86_ops) {
+		printk(KERN_ERR "kvm: already loaded the other module\n");
+		return -EEXIST;
+	}
+
+	if (!ops->cpu_has_kvm_support()) {
+		printk(KERN_ERR "kvm: no hardware support\n");
+		return -EOPNOTSUPP;
+	}
+	if (ops->disabled_by_bios()) {
+		printk(KERN_ERR "kvm: disabled by bios\n");
+		return -EOPNOTSUPP;
+	}
+
+	kvm_x86_ops = ops;
+
+	return 0;
 }
 
+void kvm_arch_exit(void)
+{
+	kvm_x86_ops = NULL;
+ }
+
 int kvm_emulate_halt(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.halt_exits;
-- 
1.5.3.7

