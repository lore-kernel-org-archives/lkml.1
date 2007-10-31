Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbXJaPwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbXJaPwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbXJaPwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:52:21 -0400
Received: from ns1.suse.de ([195.135.220.2]:53420 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755697AbXJaPwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:52:21 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Use 64bit timer values while calibrating BogoMips
Date: Wed, 31 Oct 2007 16:52:16 +0100
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710311652.16776.ak@suse.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When calibrating BogoMips 32bit architectures using 
read_current_timer will truncate the timer value to 32bit.
This is a problem on x86 when the TSC timer is already beyond
2^32-1 or wraps during the calibration. The current code
has no wrap handling.  

This could potentially lead to wrong BogoMips, causing 
incorrect delays e.g. in hardware drivers and then difficult
to track down bugs.

Change read_current_timer() to always return a 64bit
value even on 32bit and do the computation in 64bit.

Only found by code inspection; i haven't seen a failure 
in the wild.

avr32/sparc64 read_current_timer() updated, but I haven't 
compiled/tested them.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6.24-rc1-hack/arch/avr32/lib/delay.c
===================================================================
--- linux-2.6.24-rc1-hack.orig/arch/avr32/lib/delay.c
+++ linux-2.6.24-rc1-hack/arch/avr32/lib/delay.c
@@ -18,7 +18,7 @@
 #include <asm/processor.h>
 #include <asm/sysreg.h>
 
-int read_current_timer(unsigned long *timer_value)
+int read_current_timer(unsigned long long *timer_value)
 {
 	*timer_value = sysreg_read(COUNT);
 	return 0;
Index: linux-2.6.24-rc1-hack/arch/x86/lib/delay_32.c
===================================================================
--- linux-2.6.24-rc1-hack.orig/arch/x86/lib/delay_32.c
+++ linux-2.6.24-rc1-hack/arch/x86/lib/delay_32.c
@@ -60,10 +60,10 @@ void use_tsc_delay(void)
 	delay_fn = delay_tsc;
 }
 
-int read_current_timer(unsigned long *timer_val)
+int read_current_timer(unsigned long long *timer_val)
 {
 	if (delay_fn == delay_tsc) {
-		rdtscl(*timer_val);
+		rdtscll(*timer_val);
 		return 0;
 	}
 	return -1;
Index: linux-2.6.24-rc1-hack/arch/x86/lib/delay_64.c
===================================================================
--- linux-2.6.24-rc1-hack.orig/arch/x86/lib/delay_64.c
+++ linux-2.6.24-rc1-hack/arch/x86/lib/delay_64.c
@@ -18,7 +18,7 @@
 #include <asm/smp.h>
 #endif
 
-int read_current_timer(unsigned long *timer_value)
+int read_current_timer(unsigned long long *timer_value)
 {
 	rdtscll(*timer_value);
 	return 0;
Index: linux-2.6.24-rc1-hack/include/asm-avr32/timex.h
===================================================================
--- linux-2.6.24-rc1-hack.orig/include/asm-avr32/timex.h
+++ linux-2.6.24-rc1-hack/include/asm-avr32/timex.h
@@ -34,7 +34,7 @@ static inline cycles_t get_cycles (void)
 	return 0;
 }
 
-extern int read_current_timer(unsigned long *timer_value);
+extern int read_current_timer(unsigned long long *timer_value);
 #define ARCH_HAS_READ_CURRENT_TIMER	1
 
 #endif /* __ASM_AVR32_TIMEX_H */
Index: linux-2.6.24-rc1-hack/include/asm-x86/timex.h
===================================================================
--- linux-2.6.24-rc1-hack.orig/include/asm-x86/timex.h
+++ linux-2.6.24-rc1-hack/include/asm-x86/timex.h
@@ -12,7 +12,7 @@
 #endif
 #define CLOCK_TICK_RATE	PIT_TICK_RATE
 
-extern int read_current_timer(unsigned long *timer_value);
+extern int read_current_timer(unsigned long long *timer_value);
 #define ARCH_HAS_READ_CURRENT_TIMER	1
 
 #endif
Index: linux-2.6.24-rc1-hack/init/calibrate.c
===================================================================
--- linux-2.6.24-rc1-hack.orig/init/calibrate.c
+++ linux-2.6.24-rc1-hack/init/calibrate.c
@@ -31,8 +31,8 @@ __setup("lpj=", lpj_setup);
 
 static unsigned long __devinit calibrate_delay_direct(void)
 {
-	unsigned long pre_start, start, post_start;
-	unsigned long pre_end, end, post_end;
+	unsigned long long pre_start, start, post_start;
+	unsigned long long pre_end, end, post_end;
 	unsigned long start_jiffies;
 	unsigned long tsc_rate_min, tsc_rate_max;
 	unsigned long good_tsc_sum = 0;
