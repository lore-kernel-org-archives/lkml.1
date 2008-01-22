Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbYAVT11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbYAVT11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 14:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbYAVT1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 14:27:18 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:24857 "EHLO
	outbound1-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799AbYAVT1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 14:27:17 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Tue, 22 Jan 2008 12:27:57 -0700
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "Arnd Hannemann" <hannemann@i4.informatik.rwth-aachen.de>
cc: "Lars Heete" <hel@admin.de>, "Andres Salomon" <dilinger@queued.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc8 hangs at mfgpt-timer
Message-ID: <20080122192757.GC5241@cosmic.amd.com>
References: <20080116165606.3ebc06a4@ephemeral>
 <478FCDB6.4010708@i4.informatik.rwth-aachen.de>
 <4795B14C.7040502@i4.informatik.rwth-aachen.de>
 <200801221111.21240.hel@admin.de>
 <4795D120.7070806@i4.informatik.rwth-aachen.de>
MIME-Version: 1.0
In-Reply-To: <4795D120.7070806@i4.informatik.rwth-aachen.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 22 Jan 2008 19:26:43.0813 (UTC)
 FILETIME=[B8A9A950:01C85D2C]
X-WSS-ID: 6B889C0D24S8628212-06-01
Content-Type: multipart/mixed;
 boundary=OXfL5xGRrasGEqWY
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

> Indeed.
> Strange, it works at least with mfgpt_irq=8 (rtc) and mfgpt_irq=5 (audio):

I have most excellent news.  I was able to get tinyBIOS booting on my
development platform.  I looked at the problem with the debugger and
I think I might have found something.  It looks like the interrupt is
firing immediately before the clock is enabled.  In the handler, we
were returning immediately if the clock wasn't enabled (and not clearing
the event), so we were caught in a classic interrupt storm.

The attached patch rearranges the code so that the handler is installed
before we setup the interrupt (so we have somebody to listen to the
immediate interrupt), and it makes sure that we clear the event in the IRQ
handler regardless of the state of the timer tick.

I'm not 100% sure why this happens on IRQ7 but not on 5 or 8, but it might
have something to do with the interrupts already being enabled on the other
vectors.  Anyway, please try this test patch and let me know what happens.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

--OXfL5xGRrasGEqWY
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline;
 filename=fix-mfgpt-race.patch
Content-Transfer-Encoding: 7bit

[GEODE] fix a race condition in the MFGPT timer tick

From: Jordan Crouse <jordan.crouse@amd.com>

When we set the MFGPT timer tick, there is a chance that we'll
immediately assert an event.  If for some reason the IRQ routing
for this clock has been setup for some other purpose, then we
could end up firing an interrupt into the SMM handler or worse.

This rearranges the timer tick init function to initalize the handler
before we set up the MFGPT clock to make sure that even if we get
an event, it will go to the handler.

Furthermore, in the handler we need to make sure that we clear the
event, even if the timer isn't running.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
---

 arch/x86/kernel/mfgpt_32.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

Index: git/arch/x86/kernel/mfgpt_32.c
===================================================================
--- git.orig/arch/x86/kernel/mfgpt_32.c	2008-01-21 17:09:54.000000000 -0700
+++ git/arch/x86/kernel/mfgpt_32.c	2008-01-22 12:21:21.000000000 -0700
@@ -278,12 +278,12 @@
 
 static irqreturn_t mfgpt_tick(int irq, void *dev_id)
 {
+	/* Turn off the clock (and clear the event) */
+	mfgpt_disable_timer(mfgpt_event_clock);
+
 	if (mfgpt_tick_mode == CLOCK_EVT_MODE_SHUTDOWN)
 		return IRQ_HANDLED;
 
-	/* Turn off the clock */
-	mfgpt_disable_timer(mfgpt_event_clock);
-
 	/* Clear the counter */
 	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_COUNTER, 0);
 
@@ -319,10 +319,6 @@
 	}
 
 	mfgpt_event_clock = timer;
-	/* Set the clock scale and enable the event mode for CMP2 */
-	val = MFGPT_SCALE | (3 << 8);
-
-	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_SETUP, val);
 
 	/* Set up the IRQ on the MFGPT side */
 	if (geode_mfgpt_setup_irq(mfgpt_event_clock, MFGPT_CMP2, irq)) {
@@ -339,6 +335,11 @@
 		goto err;
 	}
 
+	/* Set the clock scale and enable the event mode for CMP2 */
+	val = MFGPT_SCALE | (3 << 8);
+
+	geode_mfgpt_write(mfgpt_event_clock, MFGPT_REG_SETUP, val);
+
 	/* Set up the clock event */
 	mfgpt_clockevent.mult = div_sc(MFGPT_HZ, NSEC_PER_SEC, 32);
 	mfgpt_clockevent.min_delta_ns = clockevent_delta2ns(0xF,

--OXfL5xGRrasGEqWY--


