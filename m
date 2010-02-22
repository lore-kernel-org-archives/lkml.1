Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab0BVSYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:24:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:65162 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab0BVSYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:24:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,520,1262592000"; 
   d="scan'208";a="542848099"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       "mingo@redhat.com" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
CC: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 22 Feb 2010 10:24:14 -0800
Subject: RE: [tip:x86/mrst] x86: Initialize stack canary in secondary start
Thread-Topic: [tip:x86/mrst] x86: Initialize stack canary in secondary start
Thread-Index: AcqyA1mRymuW8te8SkeN39LRqqi3SAB4EMuw
Message-ID: <43F901BD926A4E43B106BF17856F0755A318CD2C@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80D02@orsmsx508.amr.corp.intel.com>
 <tip-35f720c5930f689647d51ad77e2a8d6f0abf66c8@git.kernel.org>
 <alpine.LFD.2.00.1002200903170.2811@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002200903170.2811@localhost.localdomain>
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


>So with that patch applied we can remove the boot_init_stack_canary()
>in process_32/64.c cpu_idle(), can't we ?
>

[[JPAN]] i agree, bsp stack canary will be initialized in start_kernel() and
ap stack canary will be covered in start_secondary().
arjan, do you have any comments? here is the new patch.

>From 1073c9f6e1e3b0012f85b5a9c7c83e35bcc16107 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Mon, 22 Feb 2010 04:14:11 -0800
Subject: [PATCH] x86/boot: reduce redundant stack canary init

move secondary cpu boot stack canary initialization prior to cpu_idle()
then remove boot_init_stack_canary() calls from cpu_idle().
this change reduced redundent stack canary init for the bsp also avoid
fake stack check failure for secondary if early schedule needed before
cpu_idle.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/kernel/process_32.c |    9 ---------
 arch/x86/kernel/process_64.c |    9 ---------
 arch/x86/kernel/smpboot.c    |    4 ++++
 3 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f6c6266..d4c764a 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -85,15 +85,6 @@ void cpu_idle(void)
 {
 	int cpu = smp_processor_id();
 
-	/*
-	 * If we're the non-boot CPU, nothing set the stack canary up
-	 * for us.  CPU0 already has it initialized but no harm in
-	 * doing it again.  This is a good place for updating it, as
-	 * we wont ever return from this function (so the invalid
-	 * canaries already on the stack wont ever trigger).
-	 */
-	boot_init_stack_canary();
-
 	current_thread_info()->status |= TS_POLLING;
 
 	/* endless idle loop with no priority at all */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index fc6ad4b..1fd6713 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -110,15 +110,6 @@ void cpu_idle(void)
 {
 	current_thread_info()->status |= TS_POLLING;
 
-	/*
-	 * If we're the non-boot CPU, nothing set the stack canary up
-	 * for us.  CPU0 already has it initialized but no harm in
-	 * doing it again.  This is a good place for updating it, as
-	 * we wont ever return from this function (so the invalid
-	 * canaries already on the stack wont ever trigger).
-	 */
-	boot_init_stack_canary();
-
 	/* endless idle loop with no priority at all */
 	while (1) {
 		tick_nohz_stop_sched_tick(1);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c08829a..820638d 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -48,6 +48,7 @@
 #include <linux/err.h>
 #include <linux/nmi.h>
 #include <linux/tboot.h>
+#include <linux/stackprotector.h>
 
 #include <asm/acpi.h>
 #include <asm/desc.h>
@@ -328,6 +329,9 @@ notrace static void __cpuinit start_secondary(void *unused)
 	/* enable local interrupts */
 	local_irq_enable();
 
+	/* to prevent fake stack check failure in clock setup */
+	boot_init_stack_canary();
+
 	x86_cpuinit.setup_percpu_clockev();
 
 	wmb();
-- 
1.5.6.5


