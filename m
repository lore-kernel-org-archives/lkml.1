Return-Path: <linux-kernel-owner+w=401wt.eu-S1754594AbYKMRrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbYKMRrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbYKMRpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:45:25 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37300 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbYKMRpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:45:19 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 04/11] kvm: vmx: extract kvm_cpu_vmxoff() from hardware_disable()
Date: Thu, 13 Nov 2008 15:43:44 -0200
Message-Id: <1226598231-18311-5-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
References: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Along with some comments on why it is different from the core cpu_vmxoff()
function.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/kvm/vmx.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 5cde1e3..5b15373 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1079,13 +1079,22 @@ static void vmclear_local_vcpus(void)
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
1.5.5.GIT

