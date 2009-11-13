Return-Path: <linux-kernel-owner+w=401wt.eu-S932603AbZKMX2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603AbZKMX2b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932588AbZKMX21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:28:27 -0500
Received: from mga06.intel.com ([134.134.136.21]:23208 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932277AbZKMX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:28:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,739,1249282800"; 
   d="scan'208";a="569382163"
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
       Brian Gerst <brgerst@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegardno@ifi.uio.no>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 4/5] x86, mm: clean up and simplify NX enablement
Date: Fri, 13 Nov 2009 15:28:16 -0800
Message-Id: <1258154897-6770-5-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258154897-6770-1-git-send-email-hpa@zytor.com>
References: <1258154897-6770-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32- and 64-bit code used very different mechanisms for enabling
NX, but even the 32-bit code was enabling NX in head_32.S if it is
available.  Furthermore, we had a bewildering collection of tests for
the available of NX.

This patch:

a) merges the 32-bit set_nx() and the 64-bit check_efer() function
   into a single x86_configure_nx() function.  EFER control is left
   to the head code.

b) eliminates the nx_enabled variable entirely.  Things that need to
   test for NX enablement can verify __supported_pte_mask directly,
   and cpu_has_nx gives the supported status of NX.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/include/asm/proto.h |    2 +-
 arch/x86/kernel/cpu/common.c |    2 +-
 arch/x86/kernel/setup.c      |    8 +-----
 arch/x86/mm/init.c           |    4 +-
 arch/x86/mm/setup_nx.c       |   43 +++++------------------------------------
 arch/x86/xen/enlighten.c     |    4 +--
 6 files changed, 13 insertions(+), 50 deletions(-)

diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
index 621f56d..add7f18 100644
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -16,7 +16,7 @@ extern void ia32_sysenter_target(void);
 
 extern void syscall32_cpu_init(void);
 
-extern void check_efer(void);
+extern void x86_configure_nx(void);
 
 extern int reboot_force;
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cc25c2b..18346da 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1136,7 +1136,7 @@ void __cpuinit cpu_init(void)
 	wrmsrl(MSR_KERNEL_GS_BASE, 0);
 	barrier();
 
-	check_efer();
+	x86_configure_nx();
 	if (cpu != 0)
 		enable_x2apic();
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e09f0e2..cdb3ac4 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -783,21 +783,17 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 
-#ifdef CONFIG_X86_64
 	/*
 	 * Must call this twice: Once just to detect whether hardware doesn't
 	 * support NX (so that the early EHCI debug console setup can safely
 	 * call set_fixmap(), and then again after parsing early parameters to
 	 * honor the respective command line option.
 	 */
-	check_efer();
-#endif
+	x86_configure_nx();
 
 	parse_early_param();
 
-#ifdef CONFIG_X86_64
-	check_efer();
-#endif
+	x86_configure_nx();
 
 	/* Must be before kernel pagetables are setup */
 	vmi_activate();
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 73ffd55..27ec2c2 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -146,8 +146,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	use_gbpages = direct_gbpages;
 #endif
 
-	set_nx();
-	if (nx_enabled)
+	/* XXX: replace this with Kees' improved messages */
+	if (__supported_pte_mask & _PAGE_NX)
 		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
 
 	/* Enable PSE if available */
diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
index 513d8ed..355818b 100644
--- a/arch/x86/mm/setup_nx.c
+++ b/arch/x86/mm/setup_nx.c
@@ -3,10 +3,8 @@
 #include <linux/init.h>
 
 #include <asm/pgtable.h>
+#include <asm/proto.h>
 
-int nx_enabled;
-
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
 static int disable_nx __cpuinitdata;
 
 /*
@@ -22,48 +20,19 @@ static int __init noexec_setup(char *str)
 	if (!str)
 		return -EINVAL;
 	if (!strncmp(str, "on", 2)) {
-		__supported_pte_mask |= _PAGE_NX;
 		disable_nx = 0;
 	} else if (!strncmp(str, "off", 3)) {
 		disable_nx = 1;
-		__supported_pte_mask &= ~_PAGE_NX;
 	}
+	x86_configure_nx();
 	return 0;
 }
 early_param("noexec", noexec_setup);
-#endif
-
-#ifdef CONFIG_X86_PAE
-void __init set_nx(void)
-{
-	unsigned int v[4], l, h;
-
-	if (cpu_has_pae && (cpuid_eax(0x80000000) > 0x80000001)) {
-		cpuid(0x80000001, &v[0], &v[1], &v[2], &v[3]);
-
-		if ((v[3] & (1 << 20)) && !disable_nx) {
-			rdmsr(MSR_EFER, l, h);
-			l |= EFER_NX;
-			wrmsr(MSR_EFER, l, h);
-			nx_enabled = 1;
-			__supported_pte_mask |= _PAGE_NX;
-		}
-	}
-}
-#else
-void set_nx(void)
-{
-}
-#endif
 
-#ifdef CONFIG_X86_64
-void __cpuinit check_efer(void)
+void __cpuinit x86_configure_nx(void)
 {
-	unsigned long efer;
-
-	rdmsrl(MSR_EFER, efer);
-	if (!(efer & EFER_NX) || disable_nx)
+	if (cpu_has_nx && !disable_nx)
+		__supported_pte_mask |= _PAGE_NX;
+	else
 		__supported_pte_mask &= ~_PAGE_NX;
 }
-#endif
-
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index dfbf70e..c462cea 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1093,10 +1093,8 @@ asmlinkage void __init xen_start_kernel(void)
 
 	__supported_pte_mask |= _PAGE_IOMAP;
 
-#ifdef CONFIG_X86_64
 	/* Work out if we support NX */
-	check_efer();
-#endif
+	x86_configure_nx();
 
 	xen_setup_features();
 
-- 
1.6.2.5

