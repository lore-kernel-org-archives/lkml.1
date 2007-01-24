Return-Path: <linux-kernel-owner+w=401wt.eu-S1750774AbXAXPoB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750774AbXAXPoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 10:44:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbXAXPoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 10:44:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42711 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbXAXPoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 10:44:00 -0500
Date: Wed, 24 Jan 2007 16:42:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch] clocksource: add verification (watchdog) helper, fix
Message-ID: <20070124154227.GA20726@elte.hu>
References: <20070123211159.178138000@localhost.localdomain> <20070123211205.541044000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070123211205.541044000@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


one out of my 10 testsystems didnt properly enter high-res mode (but 
safely fell back to low-res mode), the patch below fixes this.

	Ingo

---------------------------->
Subject: [patch] clocksource: add verification (watchdog) helper, fix
From: Ingo Molnar <mingo@elte.hu>

if a clocksource is being verified by the watchdog, but the watchdog 
clocksource is registered /after/ the possibly-unstable clocksource has 
been registered, then when we switch that clocksource into high-res 
capable mode we also need to propagate this fact to the rest of the 
system - so that it properly switches into high-res mode.

this solves one particular system not entering high-res mode (but 
falling back to low-res mode) - with this patch it properly enters 
high-res mode:

 Switched to high resolution mode on CPU 0
 Switched to high resolution mode on CPU 1
 Switched to high resolution mode on CPU 2
 Switched to high resolution mode on CPU 3

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/clocksource.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux/kernel/time/clocksource.c
===================================================================
--- linux.orig/kernel/time/clocksource.c
+++ linux/kernel/time/clocksource.c
@@ -28,6 +28,7 @@
 #include <linux/sysdev.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/tick.h>
 
 /* XXX - Would like a better way for initializing curr_clocksource */
 extern struct clocksource clocksource_jiffies;
@@ -106,8 +107,16 @@ static void clocksource_watchdog(unsigne
 		/* Initialized ? */
 		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG)) {
 			if ((cs->flags & CLOCK_SOURCE_IS_CONTINUOUS) &&
-			    (watchdog->flags & CLOCK_SOURCE_IS_CONTINUOUS))
+			    (watchdog->flags & CLOCK_SOURCE_IS_CONTINUOUS)) {
 				cs->flags |= CLOCK_SOURCE_VALID_FOR_HRES;
+				/*
+				 * We just marked the clocksource as
+				 * highres-capable, notify the rest of the
+				 * system as well so that we transition
+				 * into high-res mode:
+				 */
+				tick_clock_notify();
+			}
 			cs->flags |= CLOCK_SOURCE_WATCHDOG;
 			cs->wd_last = csnow;
 		} else {
