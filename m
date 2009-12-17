Return-Path: <linux-kernel-owner+w=401wt.eu-S1765282AbZLQSA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765282AbZLQSA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 13:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765257AbZLQSAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 13:00:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:18555 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765251AbZLQSAX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 13:00:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,414,1257148800"; 
   d="scan'208,223";a="477113242"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 17 Dec 2009 10:00:20 -0800
Subject: [PATCH 1/2] x86: initialize stack canary in secondary start
Thread-Topic: [PATCH 1/2] x86: initialize stack canary in secondary start
Thread-Index: Acp/QsyIiqakBg4bR2yfUCZgIThhPQ==
Message-ID: <43F901BD926A4E43B106BF17856F07559A257B5F@orsmsx508.amr.corp.intel.com>
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

>From 06503838368350268a46528e134c1dad9f4f8c93 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Thu, 17 Sep 2009 07:36:43 -0700
Subject: [PATCH 1/2] x86: initialize stack canary in secondary start

some secondary clockevent setup code needs to call request_irq, which will
cause fake stack check failure in schedule() if voluntary preemption
model is chosen, it is safe to have stack canary initialized here early,
since start_secondary() does not return.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/kernel/smpboot.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 678d0b8..56ce974 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -48,6 +48,7 @@
 #include <linux/err.h>
 #include <linux/nmi.h>
 #include <linux/tboot.h>
+#include <linux/stackprotector.h>
 
 #include <asm/acpi.h>
 #include <asm/desc.h>
@@ -324,6 +325,9 @@ notrace static void __cpuinit start_secondary(void *unused)
 	/* enable local interrupts */
 	local_irq_enable();
 
+	/* to prevent fake stack check failure in clock setup */
+	boot_init_stack_canary();
+
 	x86_cpuinit.setup_percpu_clockev();
 
 	wmb();
-- 
1.6.5.3

