Return-Path: <linux-kernel-owner+w=401wt.eu-S932821AbYDQJUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821AbYDQJUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763515AbYDQJLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:11:23 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58957
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762773AbYDQJLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:11:02 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Izik Eidus <izike@qumranet.com>
Subject: [PATCH 22/45] KVM: add vm refcounting
Date: Thu, 17 Apr 2008 12:10:27 +0300
Message-Id: <1208423450-29415-23-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

the main purpose of adding this functions is the abilaty to release the
spinlock that protect the kvm list while still be able to do operations
on a specific kvm in a safe way.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm_host.h |    4 ++++
 virt/kvm/kvm_main.c      |   17 ++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4e1436..a2ceb51 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -114,6 +114,7 @@ struct kvm {
 	struct kvm_io_bus pio_bus;
 	struct kvm_vm_stat stat;
 	struct kvm_arch arch;
+	atomic_t users_count;
 };
 
 /* The guest did something we don't support. */
@@ -140,6 +141,9 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 		  struct module *module);
 void kvm_exit(void);
 
+void kvm_get_kvm(struct kvm *kvm);
+void kvm_put_kvm(struct kvm *kvm);
+
 #define HPA_MSB ((sizeof(hpa_t) * 8) - 1)
 #define HPA_ERR_MASK ((hpa_t)1 << HPA_MSB)
 static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 41d4b65..93ed78b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -193,6 +193,7 @@ static struct kvm *kvm_create_vm(void)
 	mutex_init(&kvm->lock);
 	kvm_io_bus_init(&kvm->mmio_bus);
 	init_rwsem(&kvm->slots_lock);
+	atomic_set(&kvm->users_count, 1);
 	spin_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	spin_unlock(&kvm_lock);
@@ -242,11 +243,25 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	mmdrop(mm);
 }
 
+void kvm_get_kvm(struct kvm *kvm)
+{
+	atomic_inc(&kvm->users_count);
+}
+EXPORT_SYMBOL_GPL(kvm_get_kvm);
+
+void kvm_put_kvm(struct kvm *kvm)
+{
+	if (atomic_dec_and_test(&kvm->users_count))
+		kvm_destroy_vm(kvm);
+}
+EXPORT_SYMBOL_GPL(kvm_put_kvm);
+
+
 static int kvm_vm_release(struct inode *inode, struct file *filp)
 {
 	struct kvm *kvm = filp->private_data;
 
-	kvm_destroy_vm(kvm);
+	kvm_put_kvm(kvm);
 	return 0;
 }
 
-- 
1.5.5

