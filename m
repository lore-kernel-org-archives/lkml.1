Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbYJ3VBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbYJ3VBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYJ3VBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:01:04 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:56440 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687AbYJ3VBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:01:03 -0400
Subject: [PATCH] fix compile breakage caused by
	dc1e35c6e95e8923cf1d3510438b63c600fee1e2
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:00:59 -0500
Message-Id: <1225400459.19324.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 101b41be2124c11a5c43c6e5428ce42683a59b1a Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 29 Oct 2008 10:54:47 -0500
Subject: [VOYAGER] x86: add ability to test for boot CPU

Given commits like this:

Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Tue Jul 29 10:29:19 2008 -0700

    x86, xsave: enable xsave/xrstor on cpus with xsave support

Which deliberately expose boot cpu dependence to pieces of the system,
I think it's time to explicitly have a variable for it to prevent this
continual misassumption that the boot CPU is zero.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/Kconfig             |    4 ++++
 arch/x86/include/asm/smp.h   |    6 ++++++
 arch/x86/kernel/cpu/common.c |    2 +-
 3 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 350bee1..4e529cc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -235,6 +235,10 @@ config X86_FIND_SMP_CONFIG
 	def_bool y
 	depends on X86_MPPARSE || X86_VOYAGER
 
+config X86_HAS_BOOT_CPU_ID
+	def_bool y
+	depends on X86_VOYAGER
+
 if ACPI
 config X86_MPPARSE
 	def_bool y
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 2766021..d12811c 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -225,5 +225,11 @@ static inline int hard_smp_processor_id(void)
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
+#ifdef CONFIG_X86_HAS_BOOT_CPU_ID
+extern unsigned char boot_cpu_id;
+#else
+#define boot_cpu_id	0
+#endif
+
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 25581dc..93e9393 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1134,7 +1134,7 @@ void __cpuinit cpu_init(void)
 	/*
 	 * Boot processor to setup the FP and extended state context info.
 	 */
-	if (!smp_processor_id())
+	if (smp_processor_id() == boot_cpu_id)
 		init_thread_xstate();
 
 	xsave_init();
-- 
1.5.6.5



