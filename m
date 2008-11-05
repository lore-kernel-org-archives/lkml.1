Return-Path: <linux-kernel-owner+w=401wt.eu-S1758349AbYKEUCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349AbYKEUCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbYKET60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:58:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41443 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756994AbYKET6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:58:09 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 14/15] kvm: vmx: crash_hardware_disable function
Date: Wed,  5 Nov 2008 17:56:57 -0200
Message-Id: <1225915018-6548-15-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
References: <1225915018-6548-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to first check if virtualization was enabled. We do this by
checking CR4.VMXE. If it is set, run vmxoff and clear CR4.VMXE.

Register it using set_virt_disable_func() on hardware_setup, and
unregister it on hardware_unsetup.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kvm/vmx.c |   40 +++++++++++++++++++++++++++++++++++-----
 1 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ece9cb7..4b10768 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -31,6 +31,7 @@
 
 #include <asm/io.h>
 #include <asm/desc.h>
+#include <asm/virtext.h>
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
@@ -1091,13 +1092,24 @@ static void vmclear_local_vcpus(void)
 		__vcpu_clear(vmx);
 }
 
-static void hardware_disable(void *garbage)
+static void __hardware_disable(void)
 {
-	vmclear_local_vcpus();
 	asm volatile (__ex(ASM_VMX_VMXOFF) : : : "cc");
 	write_cr4(read_cr4() & ~X86_CR4_VMXE);
 }
 
+static void hardware_disable(void *garbage)
+{
+	vmclear_local_vcpus();
+	__hardware_disable();
+}
+
+static void crash_hardware_disable(void)
+{
+	if (read_cr4() & X86_CR4_VMXE)
+		__hardware_disable();
+}
+
 static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 				      u32 msr, u32 *result)
 {
@@ -1281,18 +1293,36 @@ static __init int alloc_kvm_area(void)
 
 static __init int hardware_setup(void)
 {
-	if (setup_vmcs_config(&vmcs_config) < 0)
-		return -EIO;
+	int r;
+
+	r = set_virt_disable_func(crash_hardware_disable);
+	if (r)
+		goto err;
+
+	if (setup_vmcs_config(&vmcs_config) < 0) {
+		r = -EIO;
+		goto err_clear_virt_disable;
+	}
 
 	if (boot_cpu_has(X86_FEATURE_NX))
 		kvm_enable_efer_bits(EFER_NX);
 
-	return alloc_kvm_area();
+	r = alloc_kvm_area();
+	if (r)
+		goto err_clear_virt_disable;
+
+	return 0;
+
+err_clear_virt_disable:
+	clear_virt_disable_func();
+err:
+	return r;
 }
 
 static __exit void hardware_unsetup(void)
 {
 	free_kvm_area();
+	clear_virt_disable_func();
 }
 
 static void fix_pmode_dataseg(int seg, struct kvm_save_segment *save)
-- 
1.5.5.GIT

