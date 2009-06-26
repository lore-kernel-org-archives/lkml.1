Return-Path: <linux-kernel-owner+w=401wt.eu-S1753082AbZFZAOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbZFZAOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754331AbZFZAOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:14:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:27524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbZFZAOW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:14:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,293,1243839600"; 
   d="scan'208,223";a="702623882"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Date: Thu, 25 Jun 2009 17:14:24 -0700
Subject: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Thread-Topic: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Thread-Index: Acn18w+B1igitG4ASrecfEQsnRnTEA==
Message-ID: <43F901BD926A4E43B106BF17856F07556412B7E2@orsmsx508.amr.corp.intel.com>
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

>From 365e3a59c34055490f137af2da281d4305535237 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Thu, 11 Jun 2009 09:42:42 -0700
Subject: [PATCH] x86/moorestown: add moorestown platform flags

This patch adds some new features to the x86 platform feature flags.

These new features are first introduced in Intel Moorestown platform but
may continue to be present in the next generations.

Feature flags are initialized based on HW subarchitecture ID provided
by the FW via boot protocol.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/Kconfig                        |   13 ++++++++++++-
 arch/x86/include/asm/platform_feature.h |    2 ++
 arch/x86/kernel/platform_info.c         |   12 +++++++++++-
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d1430ef..c48c291 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1658,7 +1658,18 @@ config CMDLINE_OVERRIDE
 
 	  This is used to work around broken boot loaders.  This should
 	  be set to 'N' under normal conditions.
-
+config MRST
+	bool "Moorestown MID platform"
+	default n
+	depends on X86_32
+	select SFI
+	help
+	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
+	  Internet Device(MID) platform. Moorestown consists of two chips:
+	  Lincroft (CPU core, graphics, and memory controller) and Langwell IOH.
+	  Unlike standard x86 PCs, Moorestown does not have many legacy devices
+	  nor standard legacy replacement devices/features. e.g. Moorestown does
+	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
 endmenu
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
diff --git a/arch/x86/include/asm/platform_feature.h b/arch/x86/include/asm/platform_feature.h
index bcadda5..026bdc7 100644
--- a/arch/x86/include/asm/platform_feature.h
+++ b/arch/x86/include/asm/platform_feature.h
@@ -45,6 +45,8 @@
 #define X86_PLATFORM_FEATURE_ACPI		(0*32+8) /* has ACPI support */
 #define X86_PLATFORM_FEATURE_SFI		(0*32+9) /* has SFI support */
 #define X86_PLATFORM_FEATURE_8042		(0*32+10) /* i8042 KBC */
+#define X86_PLATFORM_FEATURE_APBT		(0*32+11) /* APB timer */
+#define X86_PLATFORM_FEATURE_VRTC		(0*32+12) /* virtual RTC */
 
 extern __u32 platform_feature[N_PLATFORM_CAPINTS];
 extern const char *const
diff --git a/arch/x86/kernel/platform_info.c b/arch/x86/kernel/platform_info.c
index b39898a..3021ea9 100644
--- a/arch/x86/kernel/platform_info.c
+++ b/arch/x86/kernel/platform_info.c
@@ -105,7 +105,17 @@ static int __init sysfs_platforminfo_init(void)
 }
 arch_initcall(sysfs_platforminfo_init);
 
+/* Initialize a set of default feature flags based on subarch IDs
+ * Currently, only MRST platform has non-X86 PC standard feature set.
+ */
 void platform_feature_init_default(int subarch_id)
 {
-	printk(KERN_INFO "Use default X86 platform feature set\n");
+	if ((subarch_id >= 0) && (subarch_id < N_X86_SUBARCHS)) {
+		if (subarch_id == X86_SUBARCH_MRST) {
+			setup_mrst_default_feature();
+			return;
+		}
+	} else {
+		printk(KERN_INFO "Use default X86 platform feature set\n");
+	}
 }
-- 
1.5.6.5

