Return-Path: <linux-kernel-owner+w=401wt.eu-S1757190AbXGHL6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190AbXGHL6U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 07:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbXGHLzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 07:55:18 -0400
Received: from il.qumranet.com ([82.166.9.18]:38406 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791AbXGHLyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 07:54:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [PATCH 11/20] KVM: SVM: Reliably detect if SVM was disabled by BIOS
Date: Sun,  8 Jul 2007 14:54:40 +0300
Message-Id: <11838956892580-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11838956891287-git-send-email-avi@qumranet.com>
References: <11838956891287-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch adds an implementation to the svm is_disabled function to
detect reliably if the BIOS disabled the SVM feature in the CPU. This
fixes the issues with kernel panics when loading the kvm-amd module on
machines where SVM is available but disabled.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/svm.c |    6 ++++++
 drivers/kvm/svm.h |    3 +++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 62ec38c..a0d4428 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1735,6 +1735,12 @@ static void svm_inject_page_fault(struct kvm_vcpu *vcpu,
 
 static int is_disabled(void)
 {
+	u64 vm_cr;
+
+	rdmsrl(MSR_VM_CR, vm_cr);
+	if (vm_cr & (1 << SVM_VM_CR_SVM_DISABLE))
+		return 1;
+
 	return 0;
 }
 
diff --git a/drivers/kvm/svm.h b/drivers/kvm/svm.h
index 5e93814..3b1b0f3 100644
--- a/drivers/kvm/svm.h
+++ b/drivers/kvm/svm.h
@@ -175,8 +175,11 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_CPUID_FUNC 0x8000000a
 
 #define MSR_EFER_SVME_MASK (1ULL << 12)
+#define MSR_VM_CR       0xc0010114
 #define MSR_VM_HSAVE_PA 0xc0010117ULL
 
+#define SVM_VM_CR_SVM_DISABLE 4
+
 #define SVM_SELECTOR_S_SHIFT 4
 #define SVM_SELECTOR_DPL_SHIFT 5
 #define SVM_SELECTOR_P_SHIFT 7
-- 
1.5.2.2

