Return-Path: <linux-kernel-owner+w=401wt.eu-S934931AbXEHJwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934931AbXEHJwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 05:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934930AbXEHJwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 05:52:31 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49528 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934928AbXEHJw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 05:52:29 -0400
Date: Tue, 8 May 2007 02:46:28 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Chris Wright <chrisw@sous-sol.org>, LKML <linux-kernel@vger.kernel.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joachim Deguara <joachim.deguara@amd.com>
Subject: [PATCH 4/5] i386: i8253 clockevent shutdown and unused using pit
Message-ID: <20070508094628.GW3505@sequoia.sous-sol.org>
References: <1178485128.31213.98.camel@localhost.localdomain> <20070507163110.GP3505@sequoia.sous-sol.org> <1178556361.3042.16.camel@localhost.localdomain> <20070508093957.GS3505@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508093957.GS3505@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Disable by programming pit directly when performing CLOCK_EVT_MODE_UNUSED
or CLOCK_EVT_MODE_SHUTDOWN transitions.  (A variant) tested successfully
by Joachim Deguara on a Geode that exhibited BZ 8027 behaviour (with
bad bogomips).

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Joachim Deguara <joachim.deguara@amd.com>
---
 arch/i386/kernel/i8253.c |   25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

--- tglx.orig/arch/i386/kernel/i8253.c
+++ tglx/arch/i386/kernel/i8253.c
@@ -29,24 +29,6 @@ EXPORT_SYMBOL(i8253_lock);
  */
 struct clock_event_device *global_clock_event;
 
-/* Status of the PIT interrupt */
-static int pit_irq_disabled;
-
-/*
- * Control pit interrupt enable / disable
- */
-static void pit_control_irq(int disable)
-{
-	if (pit_irq_disabled == disable)
-		return;
-
-	pit_irq_disabled = disable;
-	if (disable)
-		disable_irq(0);
-	else
-		enable_irq(0);
-}
-
 /*
  * Initialize the PIT timer.
  *
@@ -65,17 +47,18 @@ static void init_pit_timer(enum clock_ev
 		outb_p(0x34, PIT_MODE);
 		outb_p(LATCH & 0xff , PIT_CH0);	/* LSB */
 		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
-		pit_control_irq(0);
 		break;
 
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	case CLOCK_EVT_MODE_UNUSED:
-		pit_control_irq(1);
+		outb_p(0x30, PIT_MODE);
+		outb_p(0, PIT_CH0);	/* LSB */
+		outb_p(0, PIT_CH0);	/* MSB */
 		break;
+
 	case CLOCK_EVT_MODE_ONESHOT:
 		/* One shot setup */
 		outb_p(0x38, PIT_MODE);
-		pit_control_irq(0);
 		break;
 
 	case CLOCK_EVT_MODE_RESUME:
