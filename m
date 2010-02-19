Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab0BSC5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 21:57:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143Ab0BSC5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 21:57:23 -0500
From: Don Zickus <dzickus@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Don Zickus <dzickus@redhat.com>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       gorcunov@gmail.com, aris@redhat.com
Subject: [PATCH] nmi_watchdog: undefined 'apic' compile fix
Date: Thu, 18 Feb 2010 21:56:52 -0500
Message-Id: <1266548212-24243-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo provided me a config that fails to compile with

arch/x86/built-in.o: In function `arch_trigger_all_cpu_backtrace':
(.text+0x17e78): undefined reference to `apic'
make: *** [.tmp_vmlinux1] Error 1

I realized I changed the compile behaviour of the nmi code by not wrapping
it with CONFIG_LOCAL_APIC.  To fix this I add a compile check for
ARCH_HAS_NMI_WATCHDOG around arch_trigger_all_cpu_backtrace.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/apic/hw_nmi.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 312d772..0b4d205 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -92,6 +92,7 @@ u64 hw_nmi_get_sample_period(void)
         return cpu_khz * 1000;
 }
 
+#ifdef ARCH_HAS_NMI_WATCHDOG
 void arch_trigger_all_cpu_backtrace(void)
 {
 	int i;
@@ -108,6 +109,7 @@ void arch_trigger_all_cpu_backtrace(void)
 		mdelay(1);
 	}
 }
+#endif
 
 /* STUB calls to mimic old nmi_watchdog behaviour */
 #if defined(CONFIG_X86_LOCAL_APIC)
-- 
1.6.6.83.gc9a2

