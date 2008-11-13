Return-Path: <linux-kernel-owner+w=401wt.eu-S1755254AbYKMRro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbYKMRro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbYKMRp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:45:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:37299 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYKMRpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 03/11] x86: asm/virtext.h: add cpu_vmxoff() inline function
Date: Thu, 13 Nov 2008 15:43:43 -0200
Message-Id: <1226598231-18311-4-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
References: <1226598231-18311-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately we can't use exactly the same code from vmx
hardware_disable(), because the KVM function uses the
__kvm_handle_fault_on_reboot() tricks.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/include/asm/virtext.h |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 351fa23..475fb17 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -45,4 +45,17 @@ static inline int cpu_has_vmx(void)
 	return test_bit(5, &ecx); /* CPUID.1:ECX.VMX[bit 5] -> VT */
 }
 
+
+/** Disable VMX on the current CPU
+ *
+ * vmxoff causes a undefined-opcode exception if vmxon was not run
+ * on the CPU previously. Only call this function if you know VMX
+ * is enabled.
+ */
+static inline void cpu_vmxoff(void)
+{
+	asm volatile (ASM_VMX_VMXOFF : : : "cc");
+	write_cr4(read_cr4() & ~X86_CR4_VMXE);
+}
+
 #endif /* _ASM_X86_VIRTEX_H */
-- 
1.5.5.GIT

