Return-Path: <linux-kernel-owner+w=401wt.eu-S1761912AbZCYNku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761912AbZCYNku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZCYNkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:40:42 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:54323 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbZCYNkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:40:42 -0400
X-IronPort-AV: E=Sophos;i="4.38,419,1233550800"; 
   d="scan'208";a="45082399"
From: Ian Campbell <Ian.Campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "Alex.Zeffertt" <Alex.Zeffertt@citrix.com>, stable@kernel.org
Subject: [PATCH] clockevent: on resume program the next oneshot tick with the next actual event
Date: Wed, 25 Mar 2009 13:40:29 +0000
Message-Id: <1237988429-26474-1-git-send-email-Ian.Campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 25 Mar 2009 13:40:34.0790 (UTC) FILETIME=[46294060:01C9AD4F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When resuming a Xen domU we were seeing an issue where the timer ticks never
seemed to start up again. This was with CONFIG_NO_HZ=y, the Xen clocksource
has CLOCK_EVT_FEAT_ONESHOT but not CLOCK_EVT_FEAT_PERIODIC.

The issue is that on resume tick_resume_oneshot() tries to program an event for
"now", e.g.
	tick_program_event(ktime_get(), 1);

However further down the call chain tick_dev_program_event() then compares that
expiry time with a second call to ktime_get() and discards the event if the
timeout is negative -- which it always will be since some time must have passed
since tick_program_event was called.

Instead of asking for an immediate event on resume, instead ask for the next
actual event.

With this fix I can successfully resume a Xen domain.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alex.Zeffertt <Alex.Zeffertt@citrix.com>
Cc: stable@kernel.org
---
 kernel/time/tick-oneshot.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-oneshot.c b/kernel/time/tick-oneshot.c
index 2e8de67..8b2c8ed 100644
--- a/kernel/time/tick-oneshot.c
+++ b/kernel/time/tick-oneshot.c
@@ -81,7 +81,7 @@ void tick_resume_oneshot(void)
 	struct clock_event_device *dev = td->evtdev;
 
 	clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
-	tick_program_event(ktime_get(), 1);
+	tick_program_event(dev->next_event, 1);
 }
 
 /**
-- 
1.5.6.5

