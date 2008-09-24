Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYIXQum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYIXQum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbYIXQtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:49:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205AbYIXQtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:49:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] MN10300: Make sched_clock() report time since boot
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, a.p.zijlstra@chello.nl, nico@cam.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Sep 2008 17:48:31 +0100
Message-ID: <20080924164831.14867.11054.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080924164826.14867.63020.stgit@warthog.procyon.org.uk>
References: <20080924164826.14867.63020.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sched_clock() report time since boot rather than time since last timer
interrupt.

Make sched_clock() expand and scale the 32-bit TSC value running at IOCLK
speed (~33MHz) to a 64-bit nanosecond counter, using cnt32_to_63() acquired
from the ARM arch and without using slow DIVU instructions every call.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/kernel/time.c |   52 +++++++++++++++++++++++++++++++++++---------
 1 files changed, 41 insertions(+), 11 deletions(-)


diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index babb7c2..e460658 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -1,6 +1,6 @@
 /* MN10300 Low level time management
  *
- * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
+ * Copyright (C) 2007-2008 Red Hat, Inc. All Rights Reserved.
  * Written by David Howells (dhowells@redhat.com)
  * - Derived from arch/i386/kernel/time.c
  *
@@ -16,6 +16,7 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <linux/profile.h>
+#include <linux/cnt32_to_63.h>
 #include <asm/irq.h>
 #include <asm/div64.h>
 #include <asm/processor.h>
@@ -40,27 +41,54 @@ static struct irqaction timer_irq = {
 	.name		= "timer",
 };
 
+static unsigned long sched_clock_multiplier;
+
 /*
  * scheduler clock - returns current time in nanosec units.
  */
 unsigned long long sched_clock(void)
 {
 	union {
-		unsigned long long l;
-		u32 w[2];
-	} quot;
+		unsigned long long ll;
+		unsigned l[2];
+	} tsc64, result;
+	unsigned long tsc, tmp;
+	unsigned product[3]; /* 96-bit intermediate value */
+
+	/* read the TSC value
+	 */
+	tsc = 0 - get_cycles(); /* get_cycles() counts down */
 
-	quot.w[0] = mn10300_last_tsc - get_cycles();
-	quot.w[1] = 1000000000;
+	/* expand to 64-bits.
+	 * - sched_clock() must be called once a minute or better or the
+	 *   following will go horribly wrong - see cnt32_to_63()
+	 */
+	tsc64.ll = cnt32_to_63(tsc) & 0x7fffffffffffffffULL;
 
-	asm("mulu %2,%3,%0,%1"
-	    : "=r"(quot.w[1]), "=r"(quot.w[0])
-	    : "0"(quot.w[1]), "1"(quot.w[0])
+	/* scale the 64-bit TSC value to a nanosecond value via a 96-bit
+	 * intermediate
+	 */
+	asm("mulu	%2,%0,%3,%0	\n"	/* LSW * mult ->  0:%3:%0 */
+	    "mulu	%2,%1,%2,%1	\n"	/* MSW * mult -> %2:%1:0 */
+	    "add	%3,%1		\n"
+	    "addc	0,%2		\n"	/* result in %2:%1:%0 */
+	    : "=r"(product[0]), "=r"(product[1]), "=r"(product[2]), "=r"(tmp)
+	    :  "0"(tsc64.l[0]),  "1"(tsc64.l[1]),  "2"(sched_clock_multiplier)
 	    : "cc");
 
-	do_div(quot.l, MN10300_TSCCLK);
+	result.l[0] = product[1] << 16 | product[0] >> 16;
+	result.l[1] = product[2] << 16 | product[1] >> 16;
 
-	return quot.l;
+	return result.ll;
+}
+
+/*
+ * initialise the scheduler clock
+ */
+static void __init mn10300_sched_clock_init(void)
+{
+	sched_clock_multiplier =
+		__muldiv64u(NSEC_PER_SEC, 1 << 16, MN10300_TSCCLK);
 }
 
 /*
@@ -128,4 +156,6 @@ void __init time_init(void)
 	/* start the watchdog timer */
 	watchdog_go();
 #endif
+
+	mn10300_sched_clock_init();
 }

