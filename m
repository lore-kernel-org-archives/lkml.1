Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZKJQ4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZKJQ4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757154AbZKJQ4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:56:08 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34047 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756859AbZKJQ4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:56:07 -0500
Date: Tue, 10 Nov 2009 08:55:07 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Jan Beulich <jbeulich@novell.com>, Vegard Nossum <vegardno@ifi.uio.no>,
       Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v5] [x86] detect and report lack of NX protections
Message-ID: <20091110165507.GG5129@outflux.net>
References: <4ADD1E03.4070200@zytor.com>
 <20091020045513.GU5394@outflux.net>
 <20091109221015.GB5129@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109221015.GB5129@outflux.net>
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

v2: use "Alert:" instead of "Warning:" to avoid confusion with WARN_ON()
v3: use "Notice:" instead of "Alert:" to avoid confusion with KERN_ALERT,
    and switch to KERN_NOTICE, in keeping with its use for "normal but
    significant condition" messages.
v4: check that _NX_PAGE is non-zero to avoid setting nx_enabled accidentally.
v5: check for disable_nx.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 arch/x86/mm/init.c     |   10 ++++++++++
 arch/x86/mm/setup_nx.c |    6 +++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 73ffd55..d98b43a 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -149,6 +149,16 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	set_nx();
 	if (nx_enabled)
 		printk(KERN_INFO "NX (Execute Disable) protection: active\n");
+	else if (cpu_has_pae)
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+		/* PAE kernel, PAE CPU, without NX */
+		printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
+		       "missing in CPU or disabled in BIOS!\n");
+#else
+		/* 32bit non-PAE kernel, PAE CPU */
+		printk(KERN_NOTICE "Notice: NX (Execute Disable) protection "
+		       "cannot be enabled: non-PAE kernel!\n");
+#endif
 
 	/* Enable PSE if available */
 	if (cpu_has_pse)
diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
index 513d8ed..93d7b43 100644
--- a/arch/x86/mm/setup_nx.c
+++ b/arch/x86/mm/setup_nx.c
@@ -51,8 +51,12 @@ void __init set_nx(void)
 	}
 }
 #else
-void set_nx(void)
+void __init set_nx(void)
 {
+	/* notice if _PAGE_NX exists and was removed during check_efer() */
+	if (!disable_nx && _PAGE_NX &&
+	    ((__supported_pte_mask & _PAGE_NX) == _PAGE_NX))
+		nx_enabled = 1;
 }
 #endif
 
-- 
1.6.5

-- 
Kees Cook
Ubuntu Security Team
