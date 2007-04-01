Return-Path: <linux-kernel-owner+w=401wt.eu-S933227AbXDAOsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227AbXDAOsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933152AbXDAOsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:48:08 -0400
Received: from il.qumranet.com ([82.166.9.18]:47540 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933158AbXDAOfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 15/41] KVM: Add a special exit reason when exiting due to an interrupt
Date: Sun,  1 Apr 2007 17:35:12 +0300
Message-Id: <11754381392382-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <11754381391514-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is redundant, as we also return -EINTR from the ioctl, but it
allows us to examine the exit_reason field on resume without seeing
old data.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c   |    2 ++
 drivers/kvm/vmx.c   |    2 ++
 include/linux/kvm.h |    3 ++-
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index b09928f..0311665 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1619,12 +1619,14 @@ again:
 		if (signal_pending(current)) {
 			++kvm_stat.signal_exits;
 			post_kvm_run_save(vcpu, kvm_run);
+			kvm_run->exit_reason = KVM_EXIT_INTR;
 			return -EINTR;
 		}
 
 		if (dm_request_for_irq_injection(vcpu, kvm_run)) {
 			++kvm_stat.request_irq_exits;
 			post_kvm_run_save(vcpu, kvm_run);
+			kvm_run->exit_reason = KVM_EXIT_INTR;
 			return -EINTR;
 		}
 		kvm_resched(vcpu);
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index cf9568f..e69bab6 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -1941,12 +1941,14 @@ again:
 			if (signal_pending(current)) {
 				++kvm_stat.signal_exits;
 				post_kvm_run_save(vcpu, kvm_run);
+				kvm_run->exit_reason = KVM_EXIT_INTR;
 				return -EINTR;
 			}
 
 			if (dm_request_for_irq_injection(vcpu, kvm_run)) {
 				++kvm_stat.request_irq_exits;
 				post_kvm_run_save(vcpu, kvm_run);
+				kvm_run->exit_reason = KVM_EXIT_INTR;
 				return -EINTR;
 			}
 
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 57f47ef..b3af92e 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -11,7 +11,7 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
-#define KVM_API_VERSION 8
+#define KVM_API_VERSION 9
 
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
@@ -45,6 +45,7 @@ enum kvm_exit_reason {
 	KVM_EXIT_IRQ_WINDOW_OPEN  = 7,
 	KVM_EXIT_SHUTDOWN         = 8,
 	KVM_EXIT_FAIL_ENTRY       = 9,
+	KVM_EXIT_INTR             = 10,
 };
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
-- 
1.5.0.5

