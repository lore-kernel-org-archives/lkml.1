Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbYLIU17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbYLIU17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:27:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbYLIUXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:32 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34858 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbYLIUXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:10 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 24/44] KVM: SVM: move has_svm() code to asm/virtext.h
Date: Tue,  9 Dec 2008 22:22:39 +0200
Message-Id: <1228854179-23002-25-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

Use a trick to keep the printk()s on has_svm() working as before. gcc
will take care of not generating code for the 'msg' stuff when the
function is called with a NULL msg argument.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/virtext.h |   41 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm.c             |   19 ++++-------------
 2 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 6bcf0ac..6f0d409 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -19,6 +19,7 @@
 #include <asm/system.h>
 
 #include <asm/vmx.h>
+#include <asm/svm.h>
 
 /*
  * VMX functions:
@@ -66,4 +67,44 @@ static inline void cpu_emergency_vmxoff(void)
 		__cpu_emergency_vmxoff();
 }
 
+
+
+
+/*
+ * SVM functions:
+ */
+
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
index f0ad4d4..0667c6d 100644
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
1.6.0.3

