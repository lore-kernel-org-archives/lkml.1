Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbYKQVJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbYKQVJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbYKQVE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:04:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48396 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbYKQVEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:04:47 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 04/12] kvm: vmx: move cpu_has_kvm_support() to an inline on asm/virtext.h
Date: Mon, 17 Nov 2008 19:03:16 -0200
Message-Id: <1226955804-16802-5-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226955804-16802-1-git-send-email-ehabkost@redhat.com>
References: <1226955804-16802-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will be used by core code on kdump and reboot, to disable
vmx if needed.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
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
index e97ef1a..b07681e 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -31,6 +31,7 @@
 #include <asm/io.h>
 #include <asm/desc.h>
 #include <asm/vmx.h>
+#include <asm/virtext.h>
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
@@ -1032,8 +1033,7 @@ static int vmx_get_irq(struct kvm_vcpu *vcpu)
 
 static __init int cpu_has_kvm_support(void)
 {
-	unsigned long ecx = cpuid_ecx(1);
-	return test_bit(5, &ecx); /* CPUID.1:ECX.VMX[bit 5] -> VT */
+	return cpu_has_vmx();
 }
 
 static __init int vmx_disabled_by_bios(void)
-- 
1.5.5.GIT

