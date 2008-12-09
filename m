Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbYLIU1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbYLIU1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbYLIUXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:23:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34857 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748AbYLIUXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:09 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 21/44] x86: asm/virtext.h: add cpu_vmxoff() inline function
Date: Tue,  9 Dec 2008 22:22:36 +0200
Message-Id: <1228854179-23002-22-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

Unfortunately we can't use exactly the same code from vmx
hardware_disable(), because the KVM function uses the
__kvm_handle_fault_on_reboot() tricks.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
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
1.6.0.3

