Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbYIDPTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbYIDPTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 11:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYIDPTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 11:19:07 -0400
Received: from www.tglx.de ([62.245.132.106]:56979 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872AbYIDPTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:19:05 -0400
Message-Id: <20080904151249.615344193@linutronix.de>
References: <20080904150339.896115280@linutronix.de>
User-Agent: quilt/0.46-1
Date: Thu, 04 Sep 2008 15:18:44 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>
Subject: [RFC patch 1/4] x86: TSC: define the PIT latch value separate
Content-Disposition: inline; filename=tsc-define-latch-value.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/tsc.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c
+++ linux-2.6/arch/x86/kernel/tsc.c
@@ -122,6 +122,10 @@ static u64 tsc_read_refs(u64 *pm, u64 *h
 	return ULLONG_MAX;
 }
 
+#define CAL_MS		50
+#define CAL_LATCH	(CLOCK_TICK_RATE / (1000 / CAL_MS))
+#define CAL_PIT_LOOPS	5000
+
 /*
  * Try to calibrate the TSC against the Programmable
  * Interrupt Timer and return the frequency of the TSC
@@ -144,8 +148,8 @@ static unsigned long pit_calibrate_tsc(v
 	 * (LSB then MSB) to begin countdown.
 	 */
 	outb(0xb0, 0x43);
-	outb((CLOCK_TICK_RATE / (1000 / 50)) & 0xff, 0x42);
-	outb((CLOCK_TICK_RATE / (1000 / 50)) >> 8, 0x42);
+	outb(CAL_LATCH & 0xff, 0x42);
+	outb(CAL_LATCH >> 8, 0x42);
 
 	tsc = t1 = t2 = get_cycles();
 
@@ -166,18 +170,18 @@ static unsigned long pit_calibrate_tsc(v
 	/*
 	 * Sanity checks:
 	 *
-	 * If we were not able to read the PIT more than 5000
+	 * If we were not able to read the PIT more than PIT_MIN_LOOPS
 	 * times, then we have been hit by a massive SMI
 	 *
 	 * If the maximum is 10 times larger than the minimum,
 	 * then we got hit by an SMI as well.
 	 */
-	if (pitcnt < 5000 || tscmax > 10 * tscmin)
+	if (pitcnt < CAL_PIT_LOOPS || tscmax > 10 * tscmin)
 		return ULONG_MAX;
 
 	/* Calculate the PIT value */
 	delta = t2 - t1;
-	do_div(delta, 50);
+	do_div(delta, CAL_MS);
 	return delta;
 }
 

-- 

