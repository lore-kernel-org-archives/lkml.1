Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbZKPWIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbZKPWIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbZKPWH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:07:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:49532 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbZKPWH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:07:56 -0500
Date: Mon, 16 Nov 2009 22:07:45 GMT
From: tip-bot for Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       kees.cook@canonical.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       kees.cook@canonical.com, tglx@linutronix.de
In-Reply-To: <1258154897-6770-6-git-send-email-hpa@zytor.com>
References: <1258154897-6770-6-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Report state of NX protections during boot
Message-ID: <tip-4b0f3b81eb33ef18283aa71440cccfede1753ae0@git.kernel.org>
Git-Commit-ID: 4b0f3b81eb33ef18283aa71440cccfede1753ae0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b0f3b81eb33ef18283aa71440cccfede1753ae0
Gitweb:     http://git.kernel.org/tip/4b0f3b81eb33ef18283aa71440cccfede1753ae0
Author:     Kees Cook <kees.cook@canonical.com>
AuthorDate: Fri, 13 Nov 2009 15:28:17 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 16 Nov 2009 13:44:59 -0800

x86, mm: Report state of NX protections during boot

It is possible for x86_64 systems to lack the NX bit either due to the
hardware lacking support or the BIOS having turned off the CPU capability,
so NX status should be reported.  Additionally, anyone booting NX-capable
CPUs in 32bit mode without PAE will lack NX functionality, so this change
provides feedback for that case as well.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <1258154897-6770-6-git-send-email-hpa@zytor.com>
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
index 23b7f46..d2043a0 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -788,16 +788,17 @@ void __init setup_arch(char **cmdline_p)
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
