Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbYGLJWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbYGLJWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 05:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbYGLJW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 05:22:26 -0400
Received: from gw.goop.org ([64.81.55.164]:40334 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYGLJWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 05:22:18 -0400
Message-ID: <487877BE.9020700@goop.org>
Date: Sat, 12 Jul 2008 02:22:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: [PATCH 2/3] xen: no need to disable vdso32
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the vdso32 code can cope with both syscall and sysenter
missing for 32-bit compat processes, just disable the features without
disabling vdso altogether.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/setup.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

===================================================================
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -137,7 +137,7 @@ void __cpuinit xen_enable_syscall(void)
 
 	ret = register_callback(CALLBACKTYPE_syscall, xen_syscall_target);
 	if (ret != 0) {
-		printk(KERN_ERR "Failed to set syscall: %d\n", ret);
+		printk(KERN_ERR "Failed to set syscall callback: %d\n", ret);
 		/* Pretty fatal; 64-bit userspace has no other
 		   mechanism for syscalls. */
 	}
@@ -145,13 +145,8 @@ void __cpuinit xen_enable_syscall(void)
 	if (boot_cpu_has(X86_FEATURE_SYSCALL32)) {
 		ret = register_callback(CALLBACKTYPE_syscall32,
 					xen_syscall32_target);
-		if (ret != 0) {
-			printk(KERN_INFO "Xen: 32-bit syscall not supported: disabling vdso\n");
+		if (ret != 0)
 			setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
-#ifdef CONFIG_COMPAT
-			sysctl_vsyscall32 = 0;
-#endif
-		}
 	}
 #endif /* CONFIG_X86_64 */
 }


