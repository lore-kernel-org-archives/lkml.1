Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYLIUcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYLIUcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbYLIUX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34897 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945AbYLIUXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 22/44] KVM: VMX: extract kvm_cpu_vmxoff() from hardware_disable()
Date: Tue,  9 Dec 2008 22:22:37 +0200
Message-Id: <1228854179-23002-23-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

Along with some comments on why it is different from the core cpu_vmxoff()
function.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/vmx.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index defaeeb..f5958a7 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1091,13 +1091,22 @@ static void vmclear_local_vcpus(void)
 		__vcpu_clear(vmx);
 }
 
-static void hardware_disable(void *garbage)
+
+/* Just like cpu_vmxoff(), but with the __kvm_handle_fault_on_reboot()
+ * tricks.
+ */
+static void kvm_cpu_vmxoff(void)
 {
-	vmclear_local_vcpus();
 	asm volatile (__ex(ASM_VMX_VMXOFF) : : : "cc");
 	write_cr4(read_cr4() & ~X86_CR4_VMXE);
 }
 
+static void hardware_disable(void *garbage)
+{
+	vmclear_local_vcpus();
+	kvm_cpu_vmxoff();
+}
+
 static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 				      u32 msr, u32 *result)
 {
-- 
1.6.0.3

