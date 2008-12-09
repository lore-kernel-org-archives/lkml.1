Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbYLIUgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbYLIUgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:36:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755495AbYLIUY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34874 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbYLIUXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:11 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 20/44] KVM: VMX: move cpu_has_kvm_support() to an inline on asm/virtext.h
Date: Tue,  9 Dec 2008 22:22:35 +0200
Message-Id: <1228854179-23002-21-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

It will be used by core code on kdump and reboot, to disable
vmx if needed.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/virtext.h |   31 +++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx.c             |    4 ++--
 2 files changed, 33 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/virtext.h

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
new file mode 100644
index 0000000..298b6a0
--- /dev/null
+++ b/arch/x86/include/asm/virtext.h
@@ -0,0 +1,31 @@
+/* CPU virtualization extensions handling
+ *
+ * This should carry the code for handling CPU virtualization extensions
+ * that needs to live in the kernel core.
+ *
+ * Author: Eduardo Habkost <ehabkost@redhat.com>
+ *
+ * Copyright (C) 2008, Red Hat Inc.
+ *
+ * Contains code from KVM, Copyright (C) 2006 Qumranet, Inc.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ */
+#ifndef _ASM_X86_VIRTEX_H
+#define _ASM_X86_VIRTEX_H
+
+#include <asm/processor.h>
+#include <asm/system.h>
+
+/*
+ * VMX functions:
+ */
+
+static inline int cpu_has_vmx(void)
+{
+	unsigned long ecx = cpuid_ecx(1);
+	return test_bit(5, &ecx); /* CPUID.1:ECX.VMX[bit 5] -> VT */
+}
+
+#endif /* _ASM_X86_VIRTEX_H */
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ec71f64..defaeeb 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -31,6 +31,7 @@
 #include <asm/io.h>
 #include <asm/desc.h>
 #include <asm/vmx.h>
+#include <asm/virtext.h>
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
@@ -1044,8 +1045,7 @@ static int vmx_get_irq(struct kvm_vcpu *vcpu)
 
 static __init int cpu_has_kvm_support(void)
 {
-	unsigned long ecx = cpuid_ecx(1);
-	return test_bit(5, &ecx); /* CPUID.1:ECX.VMX[bit 5] -> VT */
+	return cpu_has_vmx();
 }
 
 static __init int vmx_disabled_by_bios(void)
-- 
1.6.0.3

