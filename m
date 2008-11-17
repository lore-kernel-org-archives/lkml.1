Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbYKQVFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbYKQVFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbYKQVEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:04:36 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48337 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbYKQVEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:04:33 -0500
From: Eduardo Habkost <ehabkost@redhat.com>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Simon Horman <horms@verge.net.au>, Andrew Morton <akpm@osdl.org>,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>, mingo@redhat.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Zachary Amsden <zach@vmware.com>,
       kexec@lists.infradead.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 05/12] x86: asm/virtext.h: add cpu_vmxoff() inline function
Date: Mon, 17 Nov 2008 19:03:17 -0200
Message-Id: <1226955804-16802-6-git-send-email-ehabkost@redhat.com>
In-Reply-To: <1226955804-16802-1-git-send-email-ehabkost@redhat.com>
References: <1226955804-16802-1-git-send-email-ehabkost@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately we can't use exactly the same code from vmx
hardware_disable(), because the KVM function uses the
__kvm_handle_fault_on_reboot() tricks.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/include/asm/virtext.h |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 298b6a0..7dee5b5 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -18,6 +18,8 @@
 #include <asm/processor.h>
 #include <asm/system.h>
 
+#include <asm/vmx.h>
+
 /*
  * VMX functions:
  */
@@ -28,4 +30,17 @@ static inline int cpu_has_vmx(void)
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

