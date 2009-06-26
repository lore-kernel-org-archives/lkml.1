Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZFZAOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZFZAOQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbZFZAOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:14:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:49431 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbZFZAOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:14:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,293,1243839600"; 
   d="scan'208";a="469709369"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Thu, 25 Jun 2009 17:14:05 -0700
Subject: [PATCH 1/9] x86/boot: add setup_secondary_clock to x86 quirk
Thread-Topic: [PATCH 1/9] x86/boot: add setup_secondary_clock to x86 quirk
Thread-Index: Acn18wQG83VnmHP/QyyQtuX0+C2RGQ==
Message-ID: <43F901BD926A4E43B106BF17856F07556412B7E0@orsmsx508.amr.corp.intel.com>
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

This patch was suggested by Thomas Gleixner in the early discussion below. the code will be used by the follow up patches written for Intel Moorestown platform.

Thanks to Thomas for the idea.

http://lkml.org/lkml/2009/6/9/459

>From ed9e77d627a661ad0bcb515cc84106c91ea58257 Mon Sep 17 00:00:00 2001
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


