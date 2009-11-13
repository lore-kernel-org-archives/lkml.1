Return-Path: <linux-kernel-owner+w=401wt.eu-S932590AbZKMX3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590AbZKMX3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932435AbZKMX3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:29:36 -0500
Received: from mga06.intel.com ([134.134.136.21]:58800 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932405AbZKMX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:28:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,739,1249282800"; 
   d="scan'208";a="569382166"
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de, x86@kernel.org,
       Kees Cook <kees.cook@canonical.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 5/5] x86, mm: report state of NX protections during boot
Date: Fri, 13 Nov 2009 15:28:17 -0800
Message-Id: <1258154897-6770-6-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258154897-6770-1-git-send-email-hpa@zytor.com>
References: <1258154897-6770-1-git-send-email-hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <kees.cook@canonical.com>

It is possible for x86_64 systems to lack the NX bit either due to the
hardware lacking support or the BIOS having turned off the CPU capability,
so NX status should be reported.  Additionally, anyone booting NX-capable
CPUs in 32bit mode without PAE will lack NX functionality, so this change
provides feedback for that case as well.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/proto.h |    1 +
 arch/x86/kernel/setup.c      |   11 ++++++-----
 arch/x86/mm/init.c           |    4 ----
 arch/x86/mm/setup_nx.c       |   22 ++++++++++++++++++++++
 4 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
index add7f18..450c56b 100644
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -17,6 +17,7 @@ extern void ia32_sysenter_target(void);
 extern void syscall32_cpu_init(void);
 
 extern void x86_configure_nx(void);
+extern void x86_report_nx(void);
 
 extern int reboot_force;
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cdb3ac4..29a645f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -784,16 +784,17 @@ void __init setup_arch(char **cmdline_p)
 	*cmdline_p = command_line;
 
 	/*
-	 * Must call this twice: Once just to detect whether hardware doesn't
-	 * support NX (so that the early EHCI debug console setup can safely
-	 * call set_fixmap(), and then again after parsing early parameters to
-	 * honor the respective command line option.
+	 * x86_configure_nx() is called before parse_early_param() to detect
+	 * whether hardware doesn't support NX (so that the early EHCI debug
+	 * console setup can safely call set_fixmap()). It may then be called
+	 * again from within noexec_setup() during parsing early parameters
+	 * to honor the respective command line option.
 	 */
 	x86_configure_nx();
 
 	parse_early_param();
 
-	x86_configure_nx();
+	x86_report_nx();
 
 	/* Must be before kernel pagetables are setup */
 	vmi_activate();
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 27ec2c2..d406c52 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -146,10 +146,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	use_gbpages = direct_gbpages;
 #endif
 
-	/* XXX: replace this with Kees' improved messages */
-	if (__supported_pte_mask & _PAGE_NX)
-		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
-
 	/* Enable PSE if available */
 	if (cpu_has_pse)
 		set_in_cr4(X86_CR4_PSE);
diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
index 355818b..a3250aa 100644
--- a/arch/x86/mm/setup_nx.c
+++ b/arch/x86/mm/setup_nx.c
@@ -36,3 +36,25 @@ void __cpuinit x86_configure_nx(void)
 	else
 		__supported_pte_mask &= ~_PAGE_NX;
 }
+
+void __init x86_report_nx(void)
+{
+	if (!cpu_has_nx) {
+		printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
+		       "missing in CPU or disabled in BIOS!\n");
+	} else {
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+		if (disable_nx) {
+			printk(KERN_INFO "NX (Execute Disable) protection: "
+			       "disabled by kernel command line option\n");
+		} else {
+			printk(KERN_INFO "NX (Execute Disable) protection: "
+			       "active\n");
+		}
+#else
+		/* 32bit non-PAE kernel, NX cannot be used */
+		printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
+		       "cannot be enabled: non-PAE kernel!\n");
+#endif
+	}
+}
-- 
1.6.2.5

