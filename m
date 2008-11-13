Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbYKMRqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbYKMRqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYKMRpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:45:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37275 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbYKMRpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:45:15 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 07/11] kvm: svm: move has_svm() code to asm/virtext.h
Date: Thu, 13 Nov 2008 15:43:47 -0200
Message-Id: <1226598231-18311-8-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
References: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a trick to keep the printk()s on has_svm() working as before. gcc
will take care of not generating code for the 'msg' stuff when the
function is called with a NULL msg argument.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/include/asm/virtext.h |   33 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm.c             |   19 +++++--------------
 2 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index f6adf9d..e900015 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -95,4 +95,37 @@ static inline void cpu_emergency_vmxoff(void)
 
 #define SVM_VM_CR_SVM_DISABLE 4
 
+/** Check if the CPU has SVM support
+ *
+ * You can use the 'msg' arg to get a message describing the problem,
+ * if the function returns zero. Simply pass NULL if you are not interested
+ * on the messages; gcc should take care of not generating code for
+ * the messages on this case.
+ */
+static inline int cpu_has_svm(const char **msg)
+{
+	uint32_t eax, ebx, ecx, edx;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD) {
+		if (msg)
+			*msg = "not amd";
+		return 0;
+	}
+
+	cpuid(0x80000000, &eax, &ebx, &ecx, &edx);
+	if (eax < SVM_CPUID_FUNC) {
+		if (msg)
+			*msg = "can't execute cpuid_8000000a";
+		return 0;
+	}
+
+	cpuid(0x80000001, &eax, &ebx, &ecx, &edx);
+	if (!(ecx & (1 << SVM_CPUID_FEATURE_SHIFT))) {
+		if (msg)
+			*msg = "svm not available";
+		return 0;
+	}
+	return 1;
+}
+
 #endif /* _ASM_X86_VIRTEX_H */
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 9c4ce65..64241f5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -28,6 +28,8 @@
 
 #include <asm/desc.h>
 
+#include <asm/virtext.h>
+
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
 MODULE_AUTHOR("Qumranet");
@@ -245,24 +247,13 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 
 static int has_svm(void)
 {
-	uint32_t eax, ebx, ecx, edx;
-
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_AMD) {
-		printk(KERN_INFO "has_svm: not amd\n");
-		return 0;
-	}
+	const char *msg;
 
-	cpuid(0x80000000, &eax, &ebx, &ecx, &edx);
-	if (eax < SVM_CPUID_FUNC) {
-		printk(KERN_INFO "has_svm: can't execute cpuid_8000000a\n");
+	if (!cpu_has_svm(&msg)) {
+		printk(KERN_INFO "has_svn: %s\n", msg);
 		return 0;
 	}
 
-	cpuid(0x80000001, &eax, &ebx, &ecx, &edx);
-	if (!(ecx & (1 << SVM_CPUID_FEATURE_SHIFT))) {
-		printk(KERN_DEBUG "has_svm: svm not available\n");
-		return 0;
-	}
 	return 1;
 }
 
-- 
1.5.5.GIT

