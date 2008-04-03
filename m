Return-Path: <linux-kernel-owner+w=401wt.eu-S1762299AbYDCTgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762299AbYDCTgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760853AbYDCTdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:33:05 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:53029
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758392AbYDCTc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:32:57 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/35] KVM: detect if VCPU triple faults
Date: Thu,  3 Apr 2008 22:32:26 +0300
Message-Id: <1207251170-5013-12-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1207251170-5013-1-git-send-email-avi@qumranet.com>
References: <1207251170-5013-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

In the current inject_page_fault path KVM only checks if there is another PF
pending and injects a DF then. But it has to check for a pending DF too to
detect a shutdown condition in the VCPU.  If this is not detected the VCPU goes
to a PF -> DF -> PF loop when it should triple fault. This patch detects this
condition and handles it with an KVM_SHUTDOWN exit to userspace.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c       |   20 +++++++++++++++-----
 include/linux/kvm_host.h |    1 +
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dbcff38..491eda3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -155,11 +155,16 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 			   u32 error_code)
 {
 	++vcpu->stat.pf_guest;
-	if (vcpu->arch.exception.pending && vcpu->arch.exception.nr == PF_VECTOR) {
-		printk(KERN_DEBUG "kvm: inject_page_fault:"
-		       " double fault 0x%lx\n", addr);
-		vcpu->arch.exception.nr = DF_VECTOR;
-		vcpu->arch.exception.error_code = 0;
+	if (vcpu->arch.exception.pending) {
+		if (vcpu->arch.exception.nr == PF_VECTOR) {
+			printk(KERN_DEBUG "kvm: inject_page_fault:"
+					" double fault 0x%lx\n", addr);
+			vcpu->arch.exception.nr = DF_VECTOR;
+			vcpu->arch.exception.error_code = 0;
+		} else if (vcpu->arch.exception.nr == DF_VECTOR) {
+			/* triple fault -> shutdown */
+			set_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests);
+		}
 		return;
 	}
 	vcpu->arch.cr2 = addr;
@@ -2676,6 +2681,11 @@ again:
 			r = 0;
 			goto out;
 		}
+		if (test_and_clear_bit(KVM_REQ_TRIPLE_FAULT, &vcpu->requests)) {
+			kvm_run->exit_reason = KVM_EXIT_SHUTDOWN;
+			r = 0;
+			goto out;
+		}
 	}
 
 	kvm_inject_pending_timer_irqs(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9750bb3..958e003 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -38,6 +38,7 @@
 #define KVM_REQ_MIGRATE_TIMER      1
 #define KVM_REQ_REPORT_TPR_ACCESS  2
 #define KVM_REQ_MMU_RELOAD         3
+#define KVM_REQ_TRIPLE_FAULT       4
 
 struct kvm_vcpu;
 extern struct kmem_cache *kvm_vcpu_cache;
-- 
1.5.4.5

