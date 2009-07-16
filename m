Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbZGPKze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbZGPKze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbZGPKza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:55:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:2313 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbZGPKzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:55:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,410,1243839600"; 
   d="scan'208,223";a="165663807"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Date: Thu, 16 Jul 2009 03:55:21 -0700
Subject: [PATCH v2 7/10] x86/tsc: enable APB timer based calibration
Thread-Topic: [PATCH v2 7/10] x86/tsc: enable APB timer based calibration
Thread-Index: AcoGA+pTiC7WODigQQeyHD8u/x6hFg==
Message-ID: <43F901BD926A4E43B106BF17856F0755643EBDF9@orsmsx508.amr.corp.intel.com>
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

>From e9264a1e5f8662d64f7d042544a03504b325bac9 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Wed, 15 Jul 2009 14:20:02 -0700
Subject: [PATCH] x86/tsc: enable APB timer based calibration

for platform that do not have PIT, we can use APB timer (if available)
to calibrate TSC by counting the two. APB timer frequency is known to
the system by SFI table provided by FW.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/kernel/tsc.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 6e1a368..8b38a9d 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -18,6 +18,9 @@
 #include <asm/delay.h>
 #include <asm/hypervisor.h>
 
+#include <asm/platform_feature.h>
+#include <asm/apb_timer.h>
+
 unsigned int __read_mostly cpu_khz;	/* TSC clocks / usec, not used here */
 EXPORT_SYMBOL(cpu_khz);
 
@@ -394,6 +397,14 @@ unsigned long native_calibrate_tsc(void)
 		return hv_tsc_khz;
 	}
 
+	/* first check if apb timer exist and is usable */
+	if (platform_has(X86_PLATFORM_FEATURE_APBT)) {
+		local_irq_save(flags);
+		fast_calibrate = apbt_quick_calibrate();
+		local_irq_restore(flags);
+		if (fast_calibrate)
+			return fast_calibrate;
+	}
 	local_irq_save(flags);
 	fast_calibrate = quick_pit_calibrate();
 	local_irq_restore(flags);
-- 
1.5.6.5

