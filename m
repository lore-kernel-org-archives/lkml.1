Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbZEEKuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbZEEKuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 06:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756495AbZEEKup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 06:50:45 -0400
Received: from www.tglx.de ([62.245.132.106]:34298 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756044AbZEEKuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 06:50:44 -0400
Date: Tue, 5 May 2009 12:49:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timer fixes for 2.6.30
Message-ID: <alpine.LFD.2.00.0905051248280.3375@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers/urgent git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers/urgent

Thanks,

	tglx

------------------>
John Stultz (1):
      clockevents: prevent endless loop in tick_handle_periodic()


 kernel/time/tick-common.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 21a5ca8..83c4417 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -93,7 +93,17 @@ void tick_handle_periodic(struct clock_event_device *dev)
 	for (;;) {
 		if (!clockevents_program_event(dev, next, ktime_get()))
 			return;
-		tick_periodic(cpu);
+		/*
+		 * Have to be careful here. If we're in oneshot mode,
+		 * before we call tick_periodic() in a loop, we need
+		 * to be sure we're using a real hardware clocksource.
+		 * Otherwise we could get trapped in an infinite
+		 * loop, as the tick_periodic() increments jiffies,
+		 * when then will increment time, posibly causing
+		 * the loop to trigger again and again.
+		 */
+		if (timekeeping_valid_for_hres())
+			tick_periodic(cpu);
 		next = ktime_add(next, tick_period);
 	}
 }
