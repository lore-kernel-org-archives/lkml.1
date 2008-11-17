Return-Path: <linux-kernel-owner+w=401wt.eu-S1752344AbYKQVHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbYKQVHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:07:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbYKQVEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:04:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48370 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624AbYKQVEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:04:39 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 09/12] kvm: svm: move svm_hardware_disable() code to asm/virtext.h
Date: Mon, 17 Nov 2008 19:03:21 -0200
Message-Id: <1226955804-16802-10-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226955804-16802-1-git-send-email-ehabkost@redhat.com>
References: <1226955804-16802-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create cpu_svm_disable() function.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
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
index 64241f5..7ded2ee 100644
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
1.5.5.GIT

