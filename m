Return-Path: <linux-kernel-owner+w=401wt.eu-S1756434AbYGJXY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434AbYGJXY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 19:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYGJXYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 19:24:21 -0400
Received: from gw.goop.org ([64.81.55.164]:48991 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbYGJXYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 19:24:20 -0400
Message-ID: <48769A18.4030402@goop.org>
Date: Thu, 10 Jul 2008 16:24:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] xen64: disable 32-bit syscall/sysenter if not supported.
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old versions of Xen (3.1 and before) don't support sysenter or syscall
from 32-bit compat userspaces.  If we can't set the appropriate
syscall callback, then disable the corresponding feature bit, which
will cause the vdso32 setup to fall back appropriately.

Linux assumes that syscall is always available to 32-bit userspace,
and installs it by default if sysenter isn't available.  In that case,
we just disable vdso altogether, forcing userspace libc to fall back
to int $0x80.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/setup.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

===================================================================
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -106,46 +106,46 @@ static __cpuinit int register_callback(u
 
 void __cpuinit xen_enable_sysenter(void)
 {
-	int cpu = smp_processor_id();
 	extern void xen_sysenter_target(void);
 	int ret;
+	unsigned sysenter_feature;
 
 #ifdef CONFIG_X86_32
-	if (!boot_cpu_has(X86_FEATURE_SEP)) {
-		return;
-	}
+	sysenter_feature = X86_FEATURE_SEP;
 #else
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL &&
-	    boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR) {
-		return;
-	}
+	sysenter_feature = X86_FEATURE_SYSENTER32;
 #endif
 
+	if (!boot_cpu_has(sysenter_feature))
+		return;
+
 	ret = register_callback(CALLBACKTYPE_sysenter, xen_sysenter_target);
-	if(ret != 0) {
-		clear_cpu_cap(&cpu_data(cpu), X86_FEATURE_SEP);
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_SEP);
-	}
+	if(ret != 0)
+		setup_clear_cpu_cap(sysenter_feature);
 }
 
 void __cpuinit xen_enable_syscall(void)
 {
 #ifdef CONFIG_X86_64
-	int cpu = smp_processor_id();
 	int ret;
 	extern void xen_syscall_target(void);
 	extern void xen_syscall32_target(void);
 
 	ret = register_callback(CALLBACKTYPE_syscall, xen_syscall_target);
 	if (ret != 0) {
-		printk("failed to set syscall: %d\n", ret);
-		clear_cpu_cap(&cpu_data(cpu), X86_FEATURE_SYSCALL);
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_SYSCALL);
-	} else {
+		printk(KERN_ERR "Failed to set syscall: %d\n", ret);
+		/* Pretty fatal; 64-bit userspace has no other
+		   mechanism for syscalls. */
+	}
+
+	if (boot_cpu_has(X86_FEATURE_SYSCALL32)) {
 		ret = register_callback(CALLBACKTYPE_syscall32,
 					xen_syscall32_target);
-		if (ret != 0)
-			printk("failed to set 32-bit syscall: %d\n", ret);
+		if (ret != 0) {
+			printk(KERN_INFO "Xen: 32-bit syscall not supported: disabling vdso\n");
+			setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
+			sysctl_vsyscall32 = 0;
+		}
 	}
 #endif /* CONFIG_X86_64 */
 }


