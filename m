Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbZKSNks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbZKSNks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbZKSNjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:39:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbZKSNfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:35:08 -0500
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 16/35] KVM: Enable 32bit dirty log pointers on 64bit host
Date: Thu, 19 Nov 2009 15:34:52 +0200
Message-Id: <1258637711-11674-17-git-send-email-avi@redhat.com>
In-Reply-To: <1258637711-11674-1-git-send-email-avi@redhat.com>
References: <1258637711-11674-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

With big endian userspace, we can't quite figure out if a pointer
is 32 bit (shifted >> 32) or 64 bit when we read a 64 bit pointer.

This is what happens with dirty logging. To get the pointer interpreted
correctly, we thus need Arnd's patch to implement a compat layer for
the ioctl:

A better way to do this is to add a separate compat_ioctl() method that
converts this for you.

Based on initial patch from Arnd Bergmann.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |   51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 50 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index cac69c4..bd44fb4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -43,6 +43,7 @@
 #include <linux/swap.h>
 #include <linux/bitops.h>
 #include <linux/spinlock.h>
+#include <linux/compat.h>
 
 #include <asm/processor.h>
 #include <asm/io.h>
@@ -1542,6 +1543,52 @@ out:
 	return r;
 }
 
+#ifdef CONFIG_COMPAT
+struct compat_kvm_dirty_log {
+	__u32 slot;
+	__u32 padding1;
+	union {
+		compat_uptr_t dirty_bitmap; /* one bit per page */
+		__u64 padding2;
+	};
+};
+
+static long kvm_vm_compat_ioctl(struct file *filp,
+			   unsigned int ioctl, unsigned long arg)
+{
+	struct kvm *kvm = filp->private_data;
+	int r;
+
+	if (kvm->mm != current->mm)
+		return -EIO;
+	switch (ioctl) {
+	case KVM_GET_DIRTY_LOG: {
+		struct compat_kvm_dirty_log compat_log;
+		struct kvm_dirty_log log;
+
+		r = -EFAULT;
+		if (copy_from_user(&compat_log, (void __user *)arg,
+				   sizeof(compat_log)))
+			goto out;
+		log.slot	 = compat_log.slot;
+		log.padding1	 = compat_log.padding1;
+		log.padding2	 = compat_log.padding2;
+		log.dirty_bitmap = compat_ptr(compat_log.dirty_bitmap);
+
+		r = kvm_vm_ioctl_get_dirty_log(kvm, &log);
+		if (r)
+			goto out;
+		break;
+	}
+	default:
+		r = kvm_vm_ioctl(filp, ioctl, arg);
+	}
+
+out:
+	return r;
+}
+#endif
+
 static int kvm_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct page *page[1];
@@ -1576,7 +1623,9 @@ static int kvm_vm_mmap(struct file *file, struct vm_area_struct *vma)
 static struct file_operations kvm_vm_fops = {
 	.release        = kvm_vm_release,
 	.unlocked_ioctl = kvm_vm_ioctl,
-	.compat_ioctl   = kvm_vm_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = kvm_vm_compat_ioctl,
+#endif
 	.mmap           = kvm_vm_mmap,
 };
 
-- 
1.6.5.2

