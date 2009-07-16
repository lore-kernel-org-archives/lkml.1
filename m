Return-Path: <linux-kernel-owner+w=401wt.eu-S932335AbZGPK4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbZGPK4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932266AbZGPK4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:56:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:58058 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755171AbZGPKzb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:55:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,410,1243839600"; 
   d="scan'208,223";a="475407408"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Date: Thu, 16 Jul 2009 03:55:29 -0700
Subject: [PATCH v2 8/10] x86/timer: use platform feature to choose timer
 init function
Thread-Topic: [PATCH v2 8/10] x86/timer: use platform feature to choose
 timer init function
Thread-Index: AcoGA+6SIKHCRAvCSeafpPamxc6tsQ==
Message-ID: <43F901BD926A4E43B106BF17856F0755643EBDFA@orsmsx508.amr.corp.intel.com>
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

>From 0b134db20e9ee7d39b14da7a0cdf34459e12a1f8 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Wed, 15 Jul 2009 14:25:47 -0700
Subject: [PATCH] x86/timer: use platform feature to choose timer init function

with the introduction of non-pc x86 platforms, we have more choices in
selecting system timers. This patch selects timer init function based
on feature flags set during early boot.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/time.h |    4 ++--
 arch/x86/kernel/time_32.c   |   21 ++++++++++++++++++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/time.h b/arch/x86/include/asm/time.h
index 50c733a..af08d45 100644
--- a/arch/x86/include/asm/time.h
+++ b/arch/x86/include/asm/time.h
@@ -2,7 +2,8 @@
 #define _ASM_X86_TIME_H
 
 extern void hpet_time_init(void);
-
+#include <asm/platform_feature.h>
+#include <asm/apb_timer.h>
 #include <asm/mc146818rtc.h>
 #ifdef CONFIG_X86_32
 #include <linux/efi.h>
@@ -54,7 +55,6 @@ extern void time_init(void);
 
 #define get_wallclock() native_get_wallclock()
 #define set_wallclock(x) native_set_wallclock(x)
-#define choose_time_init() hpet_time_init
 
 #endif /* CONFIG_PARAVIRT */
 
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 5c5d87f..96b1c6f 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -35,8 +35,10 @@
 
 #include <asm/setup.h>
 #include <asm/hpet.h>
+#include <asm/apb_timer.h>
 #include <asm/time.h>
 #include <asm/timer.h>
+#include <asm/platform_feature.h>
 
 #include <asm/do_timer.h>
 
@@ -78,7 +80,7 @@ irqreturn_t timer_interrupt(int irq, void *dev_id)
 	inc_irq_stat(irq0_irqs);
 
 #ifdef CONFIG_X86_IO_APIC
-	if (timer_ack) {
+	if (timer_ack && platform_has(X86_PLATFORM_FEATURE_8259)) {
 		/*
 		 * Subtle, when I/O APICs are used we have to ack timer IRQ
 		 * manually to deassert NMI lines for the watchdog if run
@@ -118,9 +120,26 @@ void __init hpet_time_init(void)
 {
 	if (!hpet_enable())
 		setup_pit_timer();
+}
+#ifndef CONFIG_PARAVIRT
+static inline void __init native_time_init(void)
+{
+	if (platform_has(X86_PLATFORM_FEATURE_HPET))
+		hpet_time_init();
+	else if (platform_has(X86_PLATFORM_FEATURE_APBT)) {
+		apbt_enable();
+	} else {
+		/* should not get here, at least one timer should be found */
+		BUG();
+	}
 	x86_quirk_time_init();
 }
+static inline void (*choose_time_init(void))(void)
+{
+	return native_time_init;
+}
 
+#endif
 /*
  * This is called directly from init code; we must delay timer setup in the
  * HPET case as we can't make the decision to turn on HPET this early in the
-- 
1.5.6.5

