Return-Path: <linux-kernel-owner+w=401wt.eu-S932318AbZGPKzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318AbZGPKzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932178AbZGPKzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:55:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:20362 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbZGPKzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:55:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,410,1243839600"; 
   d="scan'208,223";a="430730416"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Date: Thu, 16 Jul 2009 03:55:04 -0700
Subject: [PATCH v2 5/10] x86: add moorestown related setup code
Thread-Topic: [PATCH v2 5/10] x86: add moorestown related setup code
Thread-Index: AcoGA9+8MhbSyJh9TPu5eZZ/DxsoYw==
Message-ID: <43F901BD926A4E43B106BF17856F0755643EBDF7@orsmsx508.amr.corp.intel.com>
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

>From b94a617ac1efaae78d8c3d88b646afbe194b0b5d Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Wed, 15 Jul 2009 13:05:04 -0700
Subject: [PATCH] x86: add moorestown related setup code

Intel moorestown platform does not contain many devices found on a PC.
This patch adds x86_quirks and assigns platform feature sets for
Moorestown.

The impact to other platform is that we have to move x86_quirks out of
__initdata such that setup_secondary_clock quirk can be used at runtime
this is needed by moorestown per cpu external timer.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/setup.h |    6 +++++
 arch/x86/kernel/Makefile     |    1 +
 arch/x86/kernel/mrst.c       |   48 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup.c      |    2 +-
 4 files changed, 56 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kernel/mrst.c

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index c0839f7..9da2e9a 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -84,6 +84,12 @@ static inline int is_visws_box(void) { return 0; }
 extern struct x86_quirks *x86_quirks;
 extern unsigned long saved_video_mode;
 
+#ifdef CONFIG_MRST
+extern void setup_mrst_default_feature(void);
+#else
+static inline void setup_mrst_default_feature(void) { };
+#endif
+
 #ifndef CONFIG_PARAVIRT
 #define paravirt_post_allocator_init()	do {} while (0)
 #endif
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 8d1ae61..370aba5 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -103,6 +103,7 @@ obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
+obj-$(CONFIG_MRST)		+= mrst.o
 
 microcode-y				:= microcode_core.o
 microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
new file mode 100644
index 0000000..e2476e8
--- /dev/null
+++ b/arch/x86/kernel/mrst.c
@@ -0,0 +1,48 @@
+/*
+ * mrst.c: Intel Moorestown platform specific setup code
+ *
+ * (C) Copyright 2008 Intel Corporation
+ * Author: Jacob Pan (jacob.jun.pan@intel.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ *
+ * Note:
+ *
+ */
+
+#include <asm/platform_feature.h>
+#include <asm/apb_timer.h>
+#include <asm/setup.h>
+#include <asm/apic.h>
+
+static int __init mrst_pre_intr_init(void)
+{
+#ifdef CONFIG_X86_IO_APIC
+	if (platform_has(X86_PLATFORM_FEATURE_APBT)) {
+		pre_init_apic_IRQ();
+		return 1;
+	}
+#endif
+	return 0;
+}
+
+static struct x86_quirks mrst_x86_quirks = {
+	.arch_pre_intr_init		= mrst_pre_intr_init,
+	.setup_secondary_clock		= apbt_setup_secondary_clock,
+	.reserve_ebda_region		= NULL,
+};
+
+inline void setup_mrst_default_feature(void)
+{
+	clear_all_platform_feature();
+	platform_feature_set_flag(X86_PLATFORM_FEATURE_SFI);
+	platform_feature_set_flag(X86_PLATFORM_FEATURE_IOAPIC);
+	platform_feature_set_flag(X86_PLATFORM_FEATURE_APBT);
+	platform_feature_set_flag(X86_PLATFORM_FEATURE_VRTC);
+	platform_feature_set_flag(X86_PLATFORM_FEATURE_PCISHIM);
+
+	x86_quirks = &mrst_x86_quirks;
+}
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e063689..be56f82 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -640,7 +640,7 @@ early_param("elfcorehdr", setup_elfcorehdr);
 
 static struct x86_quirks default_x86_quirks __initdata;
 
-struct x86_quirks *x86_quirks __initdata = &default_x86_quirks;
+struct x86_quirks *x86_quirks = &default_x86_quirks;
 
 #ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
-- 
1.5.6.5

