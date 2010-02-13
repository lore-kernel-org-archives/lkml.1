Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab0BMBkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:40:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:22628 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224Ab0BMBk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:40:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208,223";a="772528575"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Du, Alek" <alek.du@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Feb 2010 17:40:22 -0800
Subject: [PATCH 6/9] x86: initialize stack canary in secondary start
Thread-Topic: [PATCH 6/9] x86: initialize stack canary in secondary start
Thread-Index: AcqsTYHufGoLBzRlS56j3Psgbjp8Uw==
Message-ID: <43F901BD926A4E43B106BF17856F07559FB80D02@orsmsx508.amr.corp.intel.com>
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

>From 0d84c04b845a36cf43aaa14c175ef10ff5e50480 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Thu, 17 Sep 2009 07:36:43 -0700
Subject: [PATCH 6/9] x86: initialize stack canary in secondary start

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

