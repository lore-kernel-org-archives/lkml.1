Return-Path: <linux-kernel-owner+w=401wt.eu-S1161093AbXCVVjC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161093AbXCVVjC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 17:39:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161062AbXCVVjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 17:39:01 -0400
Received: from www.osadl.org ([213.239.205.134]:42547 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161053AbXCVVjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 17:39:00 -0400
Subject: [PATCH] i386: clockevents fix breakage on Geode/Cyrix PIT
	implementations
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: LKML <linux-kernel@vger.kernel.org>
Cc: idht4n@hotmail.com, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Jordan Crouse <jordan.crouse@amd.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 22:46:18 +0100
Message-Id: <1174599978.10840.252.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The PIT has no dedicated mode for shut down. The only way to disable PIT
is to put it into one shot mode. AMD implementations of PIT on Geode
(also observed on Cyrix) are confused by an "empty" transition from
CLOCK_EVT_MODE_UNUSED to CLOCK_EVT_MODE_SHUTDOWN, which puts the PIT
into one shot mode momentarily.

I realized after staring helpless at the bug report
http://bugzilla.kernel.org/show_bug.cgi?id=8027 for quite a while, that
the only change, which might influence the bogomips calibration, is the
above transition during the PIT initialization.

Avoiding the unnecessary switch to oneshot and later to periodic mode
fixes the weird bogomips value and also the resulting slowness.

The fix is confirmed on OLPC and another Geode based box.

Note: this is unrelated to the Dual Core problem discussed here:
http://lkml.org/lkml/2007/3/17/48

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/i386/kernel/i8253.c b/arch/i386/kernel/i8253.c
index 5cbb776..10cef5c 100644
--- a/arch/i386/kernel/i8253.c
+++ b/arch/i386/kernel/i8253.c
@@ -47,9 +47,17 @@ static void init_pit_timer(enum clock_event_mode mode,
 		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
 		break;
 
-	case CLOCK_EVT_MODE_ONESHOT:
+	/*
+	 * Avoid unnecessary state transitions, as it confuses
+	 * Geode / Cyrix based boxen.
+	 */
 	case CLOCK_EVT_MODE_SHUTDOWN:
+		if (evt->mode == CLOCK_EVT_MODE_UNUSED)
+			break;
 	case CLOCK_EVT_MODE_UNUSED:
+		if (evt->mode == CLOCK_EVT_MODE_SHUTDOWN)
+			break;
+	case CLOCK_EVT_MODE_ONESHOT:
 		/* One shot setup */
 		outb_p(0x38, PIT_MODE);
 		udelay(10);


