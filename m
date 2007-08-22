Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbXHVI4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbXHVI4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 04:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbXHVIwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:52:47 -0400
Received: from 1wt.eu ([62.212.114.60]:1932 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950AbXHVIwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:52:45 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822083950.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:38:57 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@qumranet.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 13/58] KVM: SVM: Reliably detect if SVM was disabled by BIOS
Content-Disposition: inline; filename=0013-KVM-SVM-Reliably-detect-if-SVM-was-disabled-by-BIO.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an implementation to the svm is_disabled function to
detect reliably if the BIOS disabled the SVM feature in the CPU. This
fixes the issues with kernel panics when loading the kvm-amd module on
machines where SVM is available but disabled.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/kvm/svm.c |    6 ++++++
 drivers/kvm/svm.h |    3 +++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index c79df79..1e90401 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -1655,6 +1655,12 @@ static void svm_inject_page_fault(struct kvm_vcpu *vcpu,
 
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
index df731c3..e8f0349 100644
--- a/drivers/kvm/svm.h
+++ b/drivers/kvm/svm.h
@@ -172,8 +172,11 @@ struct __attribute__ ((__packed__)) vmcb {
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
1.5.2.5

-- 
