Return-Path: <linux-kernel-owner+w=401wt.eu-S1758363AbYLIUi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363AbYLIUi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754794AbYLIUYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:40 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34863 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783AbYLIUXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:10 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 25/44] KVM: SVM: move svm_hardware_disable() code to asm/virtext.h
Date: Tue,  9 Dec 2008 22:22:40 +0200
Message-Id: <1228854179-23002-26-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

Create cpu_svm_disable() function.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/virtext.h |   14 ++++++++++++++
 arch/x86/kvm/svm.c             |    6 +-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 6f0d409..2cfe363 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -107,4 +107,18 @@ static inline int cpu_has_svm(const char **msg)
 	return 1;
 }
 
+
+/** Disable SVM on the current CPU
+ *
+ * You should call this only if cpu_has_svm() returned true.
+ */
+static inline void cpu_svm_disable(void)
+{
+	uint64_t efer;
+
+	wrmsrl(MSR_VM_HSAVE_PA, 0);
+	rdmsrl(MSR_EFER, efer);
+	wrmsrl(MSR_EFER, efer & ~MSR_EFER_SVME_MASK);
+}
+
 #endif /* _ASM_X86_VIRTEX_H */
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0667c6d..1452851 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -259,11 +259,7 @@ static int has_svm(void)
 
 static void svm_hardware_disable(void *garbage)
 {
-	uint64_t efer;
-
-	wrmsrl(MSR_VM_HSAVE_PA, 0);
-	rdmsrl(MSR_EFER, efer);
-	wrmsrl(MSR_EFER, efer & ~MSR_EFER_SVME_MASK);
+	cpu_svm_disable();
 }
 
 static void svm_hardware_enable(void *garbage)
-- 
1.6.0.3

