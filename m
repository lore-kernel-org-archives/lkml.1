Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbYFJVGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbYFJVGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbYFJVGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:06:47 -0400
Received: from mail.macqel.be ([194.78.208.39]:28965 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbYFJVGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:06:46 -0400
Date: Tue, 10 Jun 2008 23:06:42 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org
Subject: [PATCH] m68knommu: init coldfire timer TRR with n - 1, not n
Message-ID: <20080610210642.GA23486@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

The coldfire timer must be initialised to n - 1 if we want it to count
n cycles between each tick interrupt.  This was already fixed, but has been
lost with the conversion to GENERIC_TIMER.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -r 184e1bb486cf arch/m68knommu/platform/coldfire/timers.c
--- a/arch/m68knommu/platform/coldfire/timers.c	Mon Jun  9 19:30:13 2008 -0700
+++ b/arch/m68knommu/platform/coldfire/timers.c	Tue Jun 10 13:25:22 2008 +0200
@@ -111,7 +111,13 @@ void hw_timer_init(void)
 
 	__raw_writew(MCFTIMER_TMR_DISABLE, TA(MCFTIMER_TMR));
 	mcftmr_cycles_per_jiffy = FREQ / HZ;
-	__raw_writetrr(mcftmr_cycles_per_jiffy, TA(MCFTIMER_TRR));
+	/*
+	 *	The coldfire timer runs from 0 to TRR included, then 0
+	 *	again and so on.  It counts thus actually TRR + 1 steps
+	 *	for 1 tick, not TRR.  So if you want n cycles,
+	 *	initialize TRR with n - 1.
+	 */
+	__raw_writetrr(mcftmr_cycles_per_jiffy - 1, TA(MCFTIMER_TRR));
 	__raw_writew(MCFTIMER_TMR_ENORI | MCFTIMER_TMR_CLK16 |
 		MCFTIMER_TMR_RESTART | MCFTIMER_TMR_ENABLE, TA(MCFTIMER_TMR));
 
