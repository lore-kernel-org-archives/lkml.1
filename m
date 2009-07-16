Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZGPK4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZGPK4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZGPK4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:56:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:2706 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbZGPKyn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:54:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,410,1243839600"; 
   d="scan'208,223";a="708333218"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Date: Thu, 16 Jul 2009 03:54:41 -0700
Subject: [PATCH v2 2/10] x86/boot: add setup_secondary_clock to x86 quirk
Thread-Topic: [PATCH v2 2/10] x86/boot: add setup_secondary_clock to x86
 quirk
Thread-Index: AcoGA9JMNVIIb3doROSsIX3J2X8YqA==
Message-ID: <43F901BD926A4E43B106BF17856F0755643EBDF4@orsmsx508.amr.corp.intel.com>
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

>From 8d2ba963b3f352ee478fda838422425aaed0a97a Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Tue, 9 Jun 2009 17:02:48 -0700
Subject: [PATCH] x86/boot: add setup_secondary_clock to x86 quirk

Some x86 platform such as Intel Moorestown use external timers for per
cpu clockevent devices. This quirk is added such as we can override the
default local APIC timers if such platform is detected.

Should not have impact on other platforms that uses default or platform
specific x86_quirks.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/setup.h |    1 +
 arch/x86/kernel/smpboot.c    |   15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 4093d1e..7bf325a 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -31,6 +31,7 @@ struct x86_quirks {
 	void (*smp_read_mpc_oem)(struct mpc_oemtable *oemtable,
 				unsigned short oemsize);
 	int (*setup_ioapic_ids)(void);
+	void (*setup_secondary_clock)(void);
 };
 
 extern void x86_quirk_intr_init(void);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 2fecda6..3260159 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -66,6 +66,8 @@
 #include <linux/mc146818rtc.h>
 
 #include <asm/smpboot_hooks.h>
+#include <asm/platform_feature.h>
+#include <asm/apb_timer.h>
 
 #ifdef CONFIG_X86_32
 u8 apicid_2_node[MAX_APICID];
@@ -263,6 +265,17 @@ static void __cpuinit smp_callin(void)
 }
 
 /*
+ * Setup secondary clock
+ */
+notrace static void __cpuinit __setup_secondary_clock(void)
+{
+	if (x86_quirks->setup_secondary_clock)
+		x86_quirks->setup_secondary_clock();
+	else
+		setup_secondary_clock();
+}
+
+/*
  * Activate a secondary processor.
  */
 notrace static void __cpuinit start_secondary(void *unused)
@@ -323,7 +336,7 @@ notrace static void __cpuinit start_secondary(void *unused)
 	/* enable local interrupts */
 	local_irq_enable();
 
-	setup_secondary_clock();
+	__setup_secondary_clock();
 
 	wmb();
 	cpu_idle();
-- 
1.5.6.5

