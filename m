Return-Path: <linux-kernel-owner+w=401wt.eu-S932926AbZHUVh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbZHUVh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932326AbZHUVbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:31:14 -0400
Received: from www.tglx.de ([62.245.132.106]:51446 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459AbZHUVbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:11 -0400
Message-Id: <20090821205601.878468441@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:29:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 02/32] x86: Add probe_roms to platform_setup
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline;
	filename=x86-add-probe-roms-to-platform-setup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

probe_roms is only used on 32bit. Add it to the platform_setup code
and remove the #ifdefs.

Default initializer is platform_setup_noop() which is overridden in
the 32bit boot code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/platform.h  |   10 ++++++++++
 arch/x86/kernel/head32.c         |    3 +++
 arch/x86/kernel/platform_setup.c |    4 ++++
 arch/x86/kernel/setup.c          |    4 +---
 4 files changed, 18 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -9,10 +9,20 @@ struct platform_setup_quirks {
 };
 
 /**
+ * struct platform_setup_resources - platform specific resource related ops
+ * @probe_roms:			probe BIOS roms
+ *
+ */
+struct platform_setup_resources {
+	void (*probe_roms)(void);
+};
+
+/**
  * struct platform_setup_ops - functions for platform specific setup
  *
  */
 struct platform_setup_ops {
+	struct platform_setup_resources resources;
 	struct platform_setup_quirks quirks;
 };
 
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -29,6 +29,9 @@ void __init i386_start_kernel(void)
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
+	/* Initilize 32bit specific setup functions */
+	platform_setup.resources.probe_roms = probe_roms;
+
 	reserve_ebda_region();
 
 	/*
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -14,4 +14,8 @@ void __cpuinit platform_setup_noop(void)
  * for standard PC hardware.
  */
 struct __initdata platform_setup_ops platform_setup = {
+
+	.resources = {
+		.probe_roms = platform_setup_noop,
+	},
 };
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -835,9 +835,7 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	init_hypervisor(&boot_cpu_data);
 
-#ifdef CONFIG_X86_32
-	probe_roms();
-#endif
+	platform_setup.resources.probe_roms();
 
 	/* after parse_early_param, so could debug it */
 	insert_resource(&iomem_resource, &code_resource);


