Return-Path: <linux-kernel-owner+w=401wt.eu-S932871AbZHUVbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871AbZHUVbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932857AbZHUVbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:31:22 -0400
Received: from www.tglx.de ([62.245.132.106]:51480 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932858AbZHUVbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:20 -0400
Message-Id: <20090821205601.988541427@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:29:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 04/32] x86: Add reserve_ebda_region to platform_setup
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline;
	filename=x86-add-reserve_ebda_region-to-platform-setup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reserve_ebda_region needs to be called befor start_kernel. Moorestown
needs to override it. Make it a platform_setup function and initialize
it with the default reserve_ebda_region.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/platform.h  |    2 ++
 arch/x86/kernel/head32.c         |    4 ++--
 arch/x86/kernel/head64.c         |    3 +--
 arch/x86/kernel/platform_setup.c |    2 ++
 4 files changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -13,11 +13,13 @@ struct platform_setup_quirks {
  * @probe_roms:			probe BIOS roms
  * @reserve_resources:		reserve the standard resources for the
  *				platform
+ * @reserve_ebda_region:	reserve the extended bios data area
  *
  */
 struct platform_setup_resources {
 	void (*probe_roms)(void);
 	void (*reserve_resources)(void);
+	void (*reserve_ebda_region)(void);
 };
 
 /**
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -11,7 +11,7 @@
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/e820.h>
-#include <asm/bios_ebda.h>
+#include <asm/page.h>
 #include <asm/trampoline.h>
 
 void __init i386_start_kernel(void)
@@ -33,7 +33,7 @@ void __init i386_start_kernel(void)
 	platform_setup.resources.probe_roms = probe_roms;
 	platform_setup.resources.reserve_resources = i386_reserve_resources;
 
-	reserve_ebda_region();
+	platform_setup.resources.reserve_ebda_region();
 
 	/*
 	 * At this point everything still needed from the boot loader
Index: linux-2.6/arch/x86/kernel/head64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head64.c
+++ linux-2.6/arch/x86/kernel/head64.c
@@ -23,7 +23,6 @@
 #include <asm/sections.h>
 #include <asm/kdebug.h>
 #include <asm/e820.h>
-#include <asm/bios_ebda.h>
 #include <asm/trampoline.h>
 
 static void __init zap_identity_mappings(void)
@@ -112,7 +111,7 @@ void __init x86_64_start_reservations(ch
 	}
 #endif
 
-	reserve_ebda_region();
+	platform_setup.resources.reserve_ebda_region();
 
 	/*
 	 * At this point everything still needed from the boot loader
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -5,6 +5,7 @@
  */
 #include <linux/init.h>
 
+#include <asm/bios_ebda.h>
 #include <asm/setup.h>
 
 void __cpuinit platform_setup_noop(void) { }
@@ -18,5 +19,6 @@ struct __initdata platform_setup_ops pla
 	.resources = {
 		.probe_roms = platform_setup_noop,
 		.reserve_resources = reserve_standard_io_resources,
+		.reserve_ebda_region = reserve_ebda_region,
 	},
 };


