Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZKPWIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZKPWIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 17:08:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbZKPWIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 17:08:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:49538 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310AbZKPWIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 17:08:22 -0500
Date: Mon, 16 Nov 2009 22:07:28 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, penberg@cs.helsinki.fi, brgerst@gmail.com,
       jeremy.fitzhardinge@citrix.com, vegardno@ifi.uio.no,
       chrisw@sous-sol.org, kees.cook@canonical.com, tj@kernel.org,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, brgerst@gmail.com, penberg@cs.helsinki.fi,
       jeremy.fitzhardinge@citrix.com, vegardno@ifi.uio.no,
       chrisw@sous-sol.org, kees.cook@canonical.com, tj@kernel.org,
       tglx@linutronix.de
In-Reply-To: <1258154897-6770-5-git-send-email-hpa@zytor.com>
References: <1258154897-6770-5-git-send-email-hpa@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Clean up and simplify NX enablement
Message-ID: <tip-4763ed4d45522b876c97e1f7f4b659d211f75571@git.kernel.org>
Git-Commit-ID: 4763ed4d45522b876c97e1f7f4b659d211f75571
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4763ed4d45522b876c97e1f7f4b659d211f75571
Gitweb:     http://git.kernel.org/tip/4763ed4d45522b876c97e1f7f4b659d211f75571
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 13 Nov 2009 15:28:16 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 16 Nov 2009 13:44:59 -0800

x86, mm: Clean up and simplify NX enablement

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
LKML-Reference: <1258154897-6770-5-git-send-email-hpa@zytor.com>
Acked-by: Kees Cook <kees.cook@canonical.com>
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
index 0a6e94a..23b7f46 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -787,21 +787,17 @@ void __init setup_arch(char **cmdline_p)
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
index 3439616..c5e805d 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1082,10 +1082,8 @@ asmlinkage void __init xen_start_kernel(void)
 
 	__supported_pte_mask |= _PAGE_IOMAP;
 
-#ifdef CONFIG_X86_64
 	/* Work out if we support NX */
-	check_efer();
-#endif
+	x86_configure_nx();
 
 	xen_setup_features();
 
