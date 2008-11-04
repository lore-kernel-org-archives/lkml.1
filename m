Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbYKDPAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbYKDPAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 10:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbYKDOzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 09:55:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60648 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755030AbYKDOzj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 09:55:39 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, kexec@lists.infradead.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 13/16] kvm: vmx: crash_hardware_disable function
Date: Tue,  4 Nov 2008 12:52:41 -0200
Message-Id: <1225810364-8990-14-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
References: <1225810364-8990-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to first check if virtualization was enabled. We do this by
checking CR4.VMXE. If it is set, run vmxoff and clear CR4.VMXE.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kvm/vmx.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index ece9cb7..0f4e191 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1091,13 +1091,24 @@ static void vmclear_local_vcpus(void)
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
+static void crash_hardware_disable(void *garbage)
+{
+	if (read_cr4() & X86_CR4_VMXE)
+		__hardware_disable();
+}
+
 static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 				      u32 msr, u32 *result)
 {
@@ -3589,6 +3600,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_enable = hardware_enable,
 	.hardware_disable = hardware_disable,
+	.crash_hardware_disable = crash_hardware_disable,
 	.cpu_has_accelerated_tpr = cpu_has_vmx_virtualize_apic_accesses,
 
 	.vcpu_create = vmx_create_vcpu,
-- 
1.5.5.GIT

