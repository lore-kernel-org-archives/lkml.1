Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbXLZLIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbXLZLIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:08:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbXLZLGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:23 -0500
Received: from il.qumranet.com ([82.166.9.18]:50468 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbXLZLGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:04 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 07/55] KVM: Unmap kernel-allocated memory on slot destruction
Date: Wed, 26 Dec 2007 13:05:12 +0200
Message-Id: <1198667160-22953-8-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

kvm_vm_ioctl_set_memory_region() is able to remove memory in addition to
adding it.  Therefore when using kernel swapping support for old userspaces,
we need to munmap the memory if the user request to remove it

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    1 +
 drivers/kvm/kvm_main.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index f7181a4..12de42c 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -353,6 +353,7 @@ struct kvm_memory_slot {
 	unsigned long *rmap;
 	unsigned long *dirty_bitmap;
 	unsigned long userspace_addr;
+	int user_alloc;
 };
 
 struct kvm {
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 005f2d5..0e8f77d 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -713,6 +713,7 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 
 		memset(new.rmap, 0, npages * sizeof(*new.rmap));
 
+		new.user_alloc = user_alloc;
 		if (user_alloc)
 			new.userspace_addr = mem->userspace_addr;
 		else {
@@ -727,6 +728,19 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 			if (IS_ERR((void *)new.userspace_addr))
 				goto out_unlock;
 		}
+	} else {
+		if (!old.user_alloc && old.rmap) {
+			int ret;
+
+			down_write(&current->mm->mmap_sem);
+			ret = do_munmap(current->mm, old.userspace_addr,
+					old.npages * PAGE_SIZE);
+			up_write(&current->mm->mmap_sem);
+			if (ret < 0)
+				printk(KERN_WARNING
+				       "kvm_vm_ioctl_set_memory_region: "
+				       "failed to munmap memory\n");
+		}
 	}
 
 	/* Allocate page dirty bitmap if needed */
-- 
1.5.3.7

