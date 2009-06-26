Return-Path: <linux-kernel-owner+w=401wt.eu-S1757005AbZFZAO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbZFZAO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZFZAOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:14:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:46155 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbZFZAOt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:14:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,293,1243839600"; 
   d="scan'208,223";a="469709485"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Thu, 25 Jun 2009 17:14:44 -0700
Subject: [PATCH 5/9] x86: make use of platform flags in setup code
Thread-Topic: [PATCH 5/9] x86: make use of platform flags in setup code
Thread-Index: Acn18xtOWd6nEAtUQ62P8MNJkwmbyA==
Message-ID: <43F901BD926A4E43B106BF17856F07556412B7E4@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7b51bf39f69dc9b2adc84113d76033facb9557bd Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Thu, 11 Jun 2009 20:48:54 -0700
Subject: [PATCH] x86: make use of platform flags in setup code

This patch uses platform feature flags to selectively perform platform
initialization. e.g. avoid reserve resources if certain feature is not
found.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/kernel/head32.c |    6 +++++-
 arch/x86/kernel/setup.c  |   12 ++++++++----
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 3f8579f..0989f5e 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -13,6 +13,8 @@
 #include <asm/e820.h>
 #include <asm/bios_ebda.h>
 #include <asm/trampoline.h>
+#include <asm/bootparam.h>
+#include <asm/platform_feature.h>
 
 void __init i386_start_kernel(void)
 {
@@ -29,7 +31,9 @@ void __init i386_start_kernel(void)
 		reserve_early(ramdisk_image, ramdisk_end, "RAMDISK");
 	}
 #endif
-	reserve_ebda_region();
+
+	if (platform_has(X86_PLATFORM_FEATURE_BIOS))
+		reserve_ebda_region();
 
 	/*
 	 * At this point everything still needed from the boot loader
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index be5ae80..1a5ef7b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -88,6 +88,7 @@
 #include <asm/processor.h>
 #include <asm/bugs.h>
 
+#include <asm/platform_feature.h>
 #include <asm/system.h>
 #include <asm/vsyscall.h>
 #include <asm/cpu.h>
@@ -731,7 +732,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	ARCH_SETUP
-
+	platform_feature_init_default(boot_params.hdr.hardware_subarch);
 	setup_memory_map();
 	parse_setup_data();
 	/* update the e820_saved too */
@@ -809,7 +810,8 @@ void __init setup_arch(char **cmdline_p)
 	init_hypervisor(&boot_cpu_data);
 
 #ifdef CONFIG_X86_32
-	probe_roms();
+	if (platform_has(X86_PLATFORM_FEATURE_BIOS))
+		probe_roms();
 #endif
 
 	/* after parse_early_param, so could debug it */
@@ -987,9 +989,11 @@ void __init setup_arch(char **cmdline_p)
 	e820_mark_nosave_regions(max_low_pfn);
 
 #ifdef CONFIG_X86_32
-	request_resource(&iomem_resource, &video_ram_resource);
+	if (platform_has(X86_PLATFORM_FEATURE_BIOS))
+		request_resource(&iomem_resource, &video_ram_resource);
 #endif
-	reserve_standard_io_resources();
+	if (platform_has(X86_PLATFORM_FEATURE_ISA))
+		reserve_standard_io_resources();
 
 	e820_setup_gap();
 
-- 
1.5.6.5

