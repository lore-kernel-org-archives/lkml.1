Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbZJSS7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbZJSS7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 14:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757231AbZJSS7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 14:59:36 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42557 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829AbZJSS7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 14:59:35 -0400
X-Greylist: delayed 698 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Oct 2009 14:59:35 EDT
Date: Mon, 19 Oct 2009 11:42:34 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Jan Beulich <jbeulich@novell.com>, Vegard Nossum <vegardno@ifi.uio.no>,
       Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [x86] detect and report lack of NX protections
Message-ID: <20091019184234.GN5394@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible for x86_64 systems to lack the NX bit (see check_efer())
either due to the hardware lacking support or the BIOS having turned
off the CPU capability, so NX status should be reported.  Additionally,
anyone booting NX-capable CPUs in 32bit mode without PAE will lack NX
functionality, so this change provides feedback for that case as well.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 arch/x86/mm/init.c     |   10 ++++++++++
 arch/x86/mm/setup_nx.c |    2 ++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 73ffd55..8472293 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -149,6 +149,16 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	set_nx();
 	if (nx_enabled)
 		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
+	else if (cpu_has_pae)
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+		/* PAE kernel, PAE CPU, without NX */
+		printk(KERN_WARNING "Warning: NX (Execute Disable) protection "
+		       "missing in CPU or disabled in BIOS!\n");
+#else
+		/* 32bit non-PAE kernel, PAE CPU */
+		printk(KERN_WARNING "Warning: NX (Execute Disable) protection "
+		       "cannot be enabled: non-PAE kernel!\n");
+#endif
 
 	/* Enable PSE if available */
 	if (cpu_has_pse)
diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
index 513d8ed..b039a4c 100644
--- a/arch/x86/mm/setup_nx.c
+++ b/arch/x86/mm/setup_nx.c
@@ -53,6 +53,8 @@ void __init set_nx(void)
 #else
 void set_nx(void)
 {
+	/* notice if _PAGE_NX was removed during check_efer() */
+	nx_enabled = ((__supported_pte_mask & _PAGE_NX) == _PAGE_NX);
 }
 #endif
 
-- 
1.6.3.3


-- 
Kees Cook
Ubuntu Security Team
