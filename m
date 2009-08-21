Return-Path: <linux-kernel-owner+w=401wt.eu-S932814AbZHUVbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbZHUVbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:31:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755624AbZHUVbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:31:13 -0400
Received: from www.tglx.de ([62.245.132.106]:51444 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbZHUVbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:31:11 -0400
Message-Id: <20090821205601.934265417@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:29:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 03/32] x86: Add request_standard_resources to
	platform_setup
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline;
	filename=x86-add-request-standard-resources-to-platform.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 32bit and the 64bit code are slighty different in the reservation
of standard resources. Also the upcoming Moorestown support needs its
own version of that.

Add it to the platform_setup and initialize it with the 64bit
default. 32bit overrides it in early boot. Now moorestown can add it's
own override w/o sprinkling the code with more #ifdefs

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/platform.h  |    3 +++
 arch/x86/include/asm/setup.h     |    3 +++
 arch/x86/kernel/head32.c         |    1 +
 arch/x86/kernel/platform_setup.c |    3 ++-
 arch/x86/kernel/setup.c          |   28 ++++++++++++++++------------
 5 files changed, 25 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/x86/include/asm/platform.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/platform.h
+++ linux-2.6/arch/x86/include/asm/platform.h
@@ -11,10 +11,13 @@ struct platform_setup_quirks {
 /**
  * struct platform_setup_resources - platform specific resource related ops
  * @probe_roms:			probe BIOS roms
+ * @reserve_resources:		reserve the standard resources for the
+ *				platform
  *
  */
 struct platform_setup_resources {
 	void (*probe_roms)(void);
+	void (*reserve_resources)(void);
 };
 
 /**
Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -88,6 +88,9 @@ extern unsigned long saved_video_mode;
 #define paravirt_post_allocator_init()	do {} while (0)
 #endif
 
+extern void reserve_standard_io_resources(void);
+extern void i386_reserve_resources(void);
+
 #ifndef _SETUP
 
 /*
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -31,6 +31,7 @@ void __init i386_start_kernel(void)
 #endif
 	/* Initilize 32bit specific setup functions */
 	platform_setup.resources.probe_roms = probe_roms;
+	platform_setup.resources.reserve_resources = i386_reserve_resources;
 
 	reserve_ebda_region();
 
Index: linux-2.6/arch/x86/kernel/platform_setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/platform_setup.c
+++ linux-2.6/arch/x86/kernel/platform_setup.c
@@ -5,7 +5,7 @@
  */
 #include <linux/init.h>
 
-#include <asm/platform.h>
+#include <asm/setup.h>
 
 void __cpuinit platform_setup_noop(void) { }
 
@@ -17,5 +17,6 @@ struct __initdata platform_setup_ops pla
 
 	.resources = {
 		.probe_roms = platform_setup_noop,
+		.reserve_resources = reserve_standard_io_resources,
 	},
 };
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -171,13 +171,6 @@ static struct resource bss_resource = {
 
 
 #ifdef CONFIG_X86_32
-static struct resource video_ram_resource = {
-	.name	= "Video RAM area",
-	.start	= 0xa0000,
-	.end	= 0xbffff,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
-};
-
 /* cpu data as detected by the assembly code in head.S */
 struct cpuinfo_x86 new_cpu_data __cpuinitdata = {0, 0, 0, 0, -1, 1, 0, 0, -1};
 /* common cpu data for all cpus */
@@ -605,7 +598,7 @@ static struct resource standard_io_resou
 		.flags = IORESOURCE_BUSY | IORESOURCE_IO }
 };
 
-static void __init reserve_standard_io_resources(void)
+void __init reserve_standard_io_resources(void)
 {
 	int i;
 
@@ -1013,10 +1006,7 @@ void __init setup_arch(char **cmdline_p)
 	e820_reserve_resources();
 	e820_mark_nosave_regions(max_low_pfn);
 
-#ifdef CONFIG_X86_32
-	request_resource(&iomem_resource, &video_ram_resource);
-#endif
-	reserve_standard_io_resources();
+	platform_setup.resources.reserve_resources();
 
 	e820_setup_gap();
 
@@ -1102,4 +1092,18 @@ void __init x86_quirk_time_init(void)
 	irq0.mask = cpumask_of_cpu(0);
 	setup_irq(0, &irq0);
 }
+
+static struct resource video_ram_resource = {
+	.name	= "Video RAM area",
+	.start	= 0xa0000,
+	.end	= 0xbffff,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_MEM
+};
+
+void __init i386_reserve_resources(void)
+{
+	request_resource(&iomem_resource, &video_ram_resource);
+	reserve_standard_io_resources();
+}
+
 #endif /* CONFIG_X86_32 */


