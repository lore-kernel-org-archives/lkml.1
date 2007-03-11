Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbXCKNya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbXCKNya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 09:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXCKNy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 09:54:27 -0400
Received: from il.qumranet.com ([82.166.9.18]:43432 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933582AbXCKNxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 09:53:32 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 14/15] KVM: Allow kernel to select size of mmap() buffer
Date: Sun, 11 Mar 2007 15:53:26 +0200
Message-Id: <1173621208447-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11736212072915-git-send-email-avi@qumranet.com>
References: <11736212072915-git-send-email-avi@qumranet.com>
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
index ed95c9b..b81f007 100644
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
1.5.0.2

