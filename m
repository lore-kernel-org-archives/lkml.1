Return-Path: <linux-kernel-owner+w=401wt.eu-S1756871AbZHNNu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbZHNNu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:50:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756859AbZHNNux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:50:53 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:47778 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbZHNNsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:48:09 -0400
Message-Id: <20090814134808.142191175@de.ibm.com>
References: <20090814134717.859098725@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Fri, 14 Aug 2009 15:47:20 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Daniel Walker <dwalker@fifo99.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 03/15] reset of cycle_last for tsc clocksource
Content-Disposition: inline; filename=clocksource-resume-tsc.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

change_clocksource resets the cycle_last value to zero then sets
it to a value read from the clocksource. The reset to zero is
required only for the TSC clocksource to make the read_tsc function
work. This is subtle and surprising. Move the reset to a resume
function in the tsc code.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Daniel Walker <dwalker@fifo99.com>
Cc: John Stultz <johnstul@us.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/x86/kernel/tsc.c     |    6 ++++++
 kernel/time/timekeeping.c |    1 -
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/tsc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/tsc.c
+++ linux-2.6/arch/x86/kernel/tsc.c
@@ -744,10 +744,16 @@ static cycle_t __vsyscall_fn vread_tsc(v
 }
 #endif
 
+static void resume_tsc(void)
+{
+	clocksource_tsc.cycle_last = 0;
+}
+
 static struct clocksource clocksource_tsc = {
 	.name                   = "tsc",
 	.rating                 = 300,
 	.read                   = read_tsc,
+	.resume			= resume_tsc,
 	.mask                   = CLOCKSOURCE_MASK(64),
 	.shift                  = 22,
 	.flags                  = CLOCK_SOURCE_IS_CONTINUOUS |
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c
+++ linux-2.6/kernel/time/timekeeping.c
@@ -295,7 +295,6 @@ static void change_clocksource(void)
 	if (old->disable)
 		old->disable(old);
 
-	clock->cycle_last = 0;
 	clock->cycle_last = clock->read(clock);
 	clock->error = 0;
 	clock->xtime_nsec = 0;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

