Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbXDAOgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbXDAOgK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933113AbXDAOfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:35:47 -0400
Received: from il.qumranet.com ([82.166.9.18]:47541 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933127AbXDAOfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:41 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 06/41] KVM: Use a shared page for kernel/user communication when runing a vcpu
Date: Sun,  1 Apr 2007 17:35:03 +0300
Message-Id: <11754381383144-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381383730-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of passing a 'struct kvm_run' back and forth between the kernel and
userspace, allocate a page and allow the user to mmap() it.  This reduces
needless copying and makes the interface expandable by providing lots of
free space.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   54 +++++++++++++++++++++++++++++++++++------------
 include/linux/kvm.h    |    6 ++--
 3 files changed, 44 insertions(+), 17 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 0d122bf..901b8d9 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -228,6 +228,7 @@ struct kvm_vcpu {
 	struct mutex mutex;
 	int   cpu;
 	int   launched;
+	struct kvm_run *run;
 	int interrupt_window_open;
 	unsigned long irq_summary; /* bit vector: 1 per word in irq_pending */
 #define NR_IRQ_WORDS KVM_IRQ_BITMAP_SIZE(unsigned long)
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 946ed86..42be8a8 100755
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -355,6 +355,8 @@ static void kvm_free_vcpu(struct kvm_vcpu *vcpu)
 	kvm_mmu_destroy(vcpu);
 	vcpu_put(vcpu);
 	kvm_arch_ops->vcpu_free(vcpu);
+	free_page((unsigned long)vcpu->run);
+	vcpu->run = NULL;
 }
 
 static void kvm_free_vcpus(struct kvm *kvm)
@@ -1887,6 +1889,33 @@ static int kvm_vcpu_ioctl_debug_guest(struct kvm_vcpu *vcpu,
 	return r;
 }
 
+static struct page *kvm_vcpu_nopage(struct vm_area_struct *vma,
+				    unsigned long address,
+				    int *type)
+{
+	struct kvm_vcpu *vcpu = vma->vm_file->private_data;
+	unsigned long pgoff;
+	struct page *page;
+
+	*type = VM_FAULT_MINOR;
+	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+	if (pgoff != 0)
+		return NOPAGE_SIGBUS;
+	page = virt_to_page(vcpu->run);
+	get_page(page);
+	return page;
+}
+
+static struct vm_operations_struct kvm_vcpu_vm_ops = {
+	.nopage = kvm_vcpu_nopage,
+};
+
+static int kvm_vcpu_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	vma->vm_ops = &kvm_vcpu_vm_ops;
+	return 0;
+}
+
 static int kvm_vcpu_release(struct inode *inode, struct file *filp)
 {
 	struct kvm_vcpu *vcpu = filp->private_data;
@@ -1899,6 +1928,7 @@ static struct file_operations kvm_vcpu_fops = {
 	.release        = kvm_vcpu_release,
 	.unlocked_ioctl = kvm_vcpu_ioctl,
 	.compat_ioctl   = kvm_vcpu_ioctl,
+	.mmap           = kvm_vcpu_mmap,
 };
 
 /*
@@ -1947,6 +1977,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 {
 	int r;
 	struct kvm_vcpu *vcpu;
+	struct page *page;
 
 	r = -EINVAL;
 	if (!valid_vcpu(n))
@@ -1961,6 +1992,12 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 		return -EEXIST;
 	}
 
+	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
+	r = -ENOMEM;
+	if (!page)
+		goto out_unlock;
+	vcpu->run = page_address(page);
+
 	vcpu->host_fx_image = (char*)ALIGN((hva_t)vcpu->fx_buf,
 					   FX_IMAGE_ALIGN);
 	vcpu->guest_fx_image = vcpu->host_fx_image + FX_IMAGE_SIZE;
@@ -1990,6 +2027,7 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, int n)
 
 out_free_vcpus:
 	kvm_free_vcpu(vcpu);
+out_unlock:
 	mutex_unlock(&vcpu->mutex);
 out:
 	return r;
@@ -2003,21 +2041,9 @@ static long kvm_vcpu_ioctl(struct file *filp,
 	int r = -EINVAL;
 
 	switch (ioctl) {
-	case KVM_RUN: {
-		struct kvm_run kvm_run;
-
-		r = -EFAULT;
-		if (copy_from_user(&kvm_run, argp, sizeof kvm_run))
-			goto out;
-		r = kvm_vcpu_ioctl_run(vcpu, &kvm_run);
-		if (r < 0 &&  r != -EINTR)
-			goto out;
-		if (copy_to_user(argp, &kvm_run, sizeof kvm_run)) {
-			r = -EFAULT;
-			goto out;
-		}
+	case KVM_RUN:
+		r = kvm_vcpu_ioctl_run(vcpu, vcpu->run);
 		break;
-	}
 	case KVM_GET_REGS: {
 		struct kvm_regs kvm_regs;
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 275354f..d88e750 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -11,7 +11,7 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
-#define KVM_API_VERSION 4
+#define KVM_API_VERSION 5
 
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
@@ -49,7 +49,7 @@ enum kvm_exit_reason {
 	KVM_EXIT_SHUTDOWN         = 8,
 };
 
-/* for KVM_RUN */
+/* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
 	/* in */
 	__u32 emulated;  /* skip current instruction */
@@ -233,7 +233,7 @@ struct kvm_dirty_log {
 /*
  * ioctls for vcpu fds
  */
-#define KVM_RUN                   _IOWR(KVMIO, 2, struct kvm_run)
+#define KVM_RUN                   _IO(KVMIO, 16)
 #define KVM_GET_REGS              _IOR(KVMIO, 3, struct kvm_regs)
 #define KVM_SET_REGS              _IOW(KVMIO, 4, struct kvm_regs)
 #define KVM_GET_SREGS             _IOR(KVMIO, 5, struct kvm_sregs)
-- 
1.5.0.5

