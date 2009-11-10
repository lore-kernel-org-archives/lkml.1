Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbZKJWQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbZKJWQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:16:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbZKJWQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:16:41 -0500
Received: from smtp.outflux.net ([198.145.64.163]:59886 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbZKJWQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:16:41 -0500
Date: Tue, 10 Nov 2009 14:15:37 -0800
From: Kees Cook <kees.cook@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jan Beulich <jbeulich@novell.com>, Vegard Nossum <vegardno@ifi.uio.no>,
       Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] [x86] detect and report lack of NX protections
Message-ID: <20091110221537.GB5129@outflux.net>
References: <20091110154956.GF5129@outflux.net>
 <4AF9991B.20400@zytor.com>
 <20091110165738.GH5129@outflux.net>
 <4AF99F0C.2050806@zytor.com>
 <20091110174622.GK5129@outflux.net>
 <4AF9B6AD.8020505@zytor.com>
 <20091110194304.GW5129@outflux.net>
 <4AF9C627.1070206@zytor.com>
 <20091110205544.GZ5129@outflux.net>
 <4AF9D98A.90808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF9D98A.90808@zytor.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 01:22:18PM -0800, H. Peter Anvin wrote:
> Yes, it should be.  set_nx() and check_efer() are doing the same thing,
> except in different ways, and they are - IMO - *both* doing something
> dumb -- although check_efer() is saner.

BTW, it seems like set_nx() should move from init_memory_mapping to
setup_arch, since init_memory_mapping can be called twice, but I don't
think set_nx needs to be.

Also, disable_nx is only defined in setup_nx.c when
"defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)", so I re-arranged the
logic to match that.

How about the following clean-up and merge...

---
It is possible for x86_64 systems to lack the NX bit (see check_efer())
either due to the hardware lacking support or the BIOS having turned
off the CPU capability, so NX status should be reported.  Additionally,
anyone booting NX-capable CPUs in 32bit mode without PAE will lack NX
functionality, so this change provides feedback for that case as well.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 arch/x86/kernel/setup.c |    2 ++
 arch/x86/mm/init.c      |    4 ----
 arch/x86/mm/setup_nx.c  |   31 ++++++++++++++++++++-----------
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e09f0e2..72181c1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -895,6 +895,8 @@ void __init setup_arch(char **cmdline_p)
 
 	init_gbpages();
 
+	set_nx();
+
 	/* max_pfn_mapped is updated here */
 	max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
 	max_pfn_mapped = max_low_pfn_mapped;
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 73ffd55..d406c52 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -146,10 +146,6 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	use_gbpages = direct_gbpages;
 #endif
 
-	set_nx();
-	if (nx_enabled)
-		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
-
 	/* Enable PSE if available */
 	if (cpu_has_pse)
 		set_in_cr4(X86_CR4_PSE);
diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
index 513d8ed..269b668 100644
--- a/arch/x86/mm/setup_nx.c
+++ b/arch/x86/mm/setup_nx.c
@@ -33,28 +33,37 @@ static int __init noexec_setup(char *str)
 early_param("noexec", noexec_setup);
 #endif
 
-#ifdef CONFIG_X86_PAE
 void __init set_nx(void)
 {
-	unsigned int v[4], l, h;
-
-	if (cpu_has_pae && (cpuid_eax(0x80000000) > 0x80000001)) {
-		cpuid(0x80000001, &v[0], &v[1], &v[2], &v[3]);
+	if (!cpu_has_nx) {
+		printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
+		       "missing in CPU or disabled in BIOS!\n");
+	} else {
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+		if (disable_nx)
+			printk(KERN_INFO "NX (Execute Disable) protection: "
+			       "disabled by kernel command line option\n");
+		else {
+# ifdef CONFIG_X86_PAE
+			/* 32-bit PAE */
+			unsigned int l, h;
 
-		if ((v[3] & (1 << 20)) && !disable_nx) {
 			rdmsr(MSR_EFER, l, h);
 			l |= EFER_NX;
 			wrmsr(MSR_EFER, l, h);
 			nx_enabled = 1;
 			__supported_pte_mask |= _PAGE_NX;
+# endif
+			printk(KERN_INFO "NX (Execute Disable) protection: "
+			       "active\n");
 		}
-	}
-}
 #else
-void set_nx(void)
-{
-}
+		/* 32bit non-PAE kernel, NX cannot be used */
+		printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
+		       "cannot be enabled: non-PAE kernel!\n");
 #endif
+	}
+}
 
 #ifdef CONFIG_X86_64
 void __cpuinit check_efer(void)
-- 
1.6.5



-- 
Kees Cook
Ubuntu Security Team
