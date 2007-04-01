Return-Path: <linux-kernel-owner+w=401wt.eu-S933185AbXDAOrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185AbXDAOrT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933257AbXDAOpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:45:55 -0400
Received: from il.qumranet.com ([82.166.9.18]:47561 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933217AbXDAOfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:43 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 18/41] KVM: Allow kernel to select size of mmap() buffer
Date: Sun,  1 Apr 2007 17:35:15 +0300
Message-Id: <11754381392921-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <1175438139872-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to store offsets in the kernel/user kvm_run area, and be
sure that userspace has them mapped.  As offsets can be outside the
kvm_run struct, userspace has no way of knowing how much to mmap.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    8 +++++++-
 include/linux/kvm.h    |    4 ++++
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index df85f5f..cba0b87 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -2436,7 +2436,7 @@ static long kvm_dev_ioctl(struct file *filp,
 			  unsigned int ioctl, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
-	int r = -EINVAL;
+	long r = -EINVAL;
 
 	switch (ioctl) {
 	case KVM_GET_API_VERSION:
@@ -2478,6 +2478,12 @@ static long kvm_dev_ioctl(struct file *filp,
 		 */
 		r = 0;
 		break;
+	case KVM_GET_VCPU_MMAP_SIZE:
+		r = -EINVAL;
+		if (arg)
+			goto out;
+		r = PAGE_SIZE;
+		break;
 	default:
 		;
 	}
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index c0d10cd..dad9081 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -253,6 +253,10 @@ struct kvm_signal_mask {
  * return is 1 (yes) or 0 (no, sorry).
  */
 #define KVM_CHECK_EXTENSION       _IO(KVMIO,   0x03)
+/*
+ * Get size for mmap(vcpu_fd)
+ */
+#define KVM_GET_VCPU_MMAP_SIZE    _IO(KVMIO,   0x04) /* in bytes */
 
 /*
  * ioctls for VM fds
-- 
1.5.0.5

