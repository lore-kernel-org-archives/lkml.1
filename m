Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYAAPiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYAAPiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 10:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbYAAPg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 10:36:29 -0500
Received: from il.qumranet.com ([82.166.9.18]:33785 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbYAAPgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 10:36:24 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 05/54] KVM: Disallow fork() and similar games when using a VM
Date: Tue,  1 Jan 2008 17:35:31 +0200
Message-Id: <1199201780-14001-6-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199201780-14001-1-git-send-email-avi@qumranet.com>
References: <1199201780-14001-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't want the meaning of guest userspace changing under our feet.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |    9 +++++++++
 kernel/fork.c          |    1 +
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 1fd8158..be18620 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -305,6 +305,7 @@ struct kvm_vm_stat {
 
 struct kvm {
 	struct mutex lock; /* protects everything except vcpus */
+	struct mm_struct *mm; /* userspace tied to this vm */
 	int naliases;
 	struct kvm_mem_alias aliases[KVM_ALIAS_SLOTS];
 	int nmemslots;
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 411b2bd..a9e1c77 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -165,6 +165,8 @@ static struct kvm *kvm_create_vm(void)
 	if (IS_ERR(kvm))
 		goto out;
 
+	kvm->mm = current->mm;
+	atomic_inc(&kvm->mm->mm_count);
 	kvm_io_bus_init(&kvm->pio_bus);
 	mutex_init(&kvm->lock);
 	kvm_io_bus_init(&kvm->mmio_bus);
@@ -202,12 +204,15 @@ void kvm_free_physmem(struct kvm *kvm)
 
 static void kvm_destroy_vm(struct kvm *kvm)
 {
+	struct mm_struct *mm = kvm->mm;
+
 	spin_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
 	spin_unlock(&kvm_lock);
 	kvm_io_bus_destroy(&kvm->pio_bus);
 	kvm_io_bus_destroy(&kvm->mmio_bus);
 	kvm_arch_destroy_vm(kvm);
+	mmdrop(mm);
 }
 
 static int kvm_vm_release(struct inode *inode, struct file *filp)
@@ -818,6 +823,8 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	void __user *argp = (void __user *)arg;
 	int r;
 
+	if (vcpu->kvm->mm != current->mm)
+		return -EIO;
 	switch (ioctl) {
 	case KVM_RUN:
 		r = -EINVAL;
@@ -976,6 +983,8 @@ static long kvm_vm_ioctl(struct file *filp,
 	void __user *argp = (void __user *)arg;
 	int r;
 
+	if (kvm->mm != current->mm)
+		return -EIO;
 	switch (ioctl) {
 	case KVM_CREATE_VCPU:
 		r = kvm_vm_ioctl_create_vcpu(kvm, arg);
diff --git a/kernel/fork.c b/kernel/fork.c
index 8dd8ff2..591c8df 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -392,6 +392,7 @@ void fastcall __mmdrop(struct mm_struct *mm)
 	destroy_context(mm);
 	free_mm(mm);
 }
+EXPORT_SYMBOL_GPL(__mmdrop);
 
 /*
  * Decrement the use count and release all resources for an mm.
-- 
1.5.3.7

