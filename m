Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbZHMLwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbZHMLwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 07:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbZHMLwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 07:52:34 -0400
Received: from mail.df.lth.se ([194.47.250.12]:57772 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751060AbZHMLwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 07:52:33 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mundt <lethal@linux-sh.org>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] U300 sched_clock implementation
Date: Thu, 13 Aug 2009 13:49:38 +0200
Message-Id: <1250164178-11076-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the long debated sched_clock() override for the weak
in-kernel jiffybased sched_clock(). The implementation is more or
less identical to the one used in arch/arm/plat-omap/common.c
and at last attempt to merge this the merge was postponed at the
request of Peter Zijlstra due to pending discussions regarding
generalized clocksource-based sched_clock() implementations by
adding a flag to the clocksource. However that discussion ended
up with the generic code needing to be rewritten and Paul Mundt
see no reason not to proceed with this for the time being as it
can be easily converted once the generic code is in place.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/arm/mach-u300/timer.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-u300/timer.c b/arch/arm/mach-u300/timer.c
index cce5320..63b5186 100644
--- a/arch/arm/mach-u300/timer.c
+++ b/arch/arm/mach-u300/timer.c
@@ -346,6 +346,22 @@ static struct clocksource clocksource_u300_1mhz = {
 	.flags          = CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
+/*
+ * Override the global weak sched_clock symbol with this
+ * local implementation which uses the clocksource to get some
+ * better resolution when scheduling the kernel. We accept that
+ * this wraps around for now, since it is just a relative time
+ * stamp. (Inspired by OMAP implementation.)
+ */
+unsigned long long notrace sched_clock(void)
+{
+	unsigned long long ret;
+
+	ret = (unsigned long long) u300_get_cycles(&clocksource_u300_1mhz);
+	ret = (ret * clocksource_u300_1mhz.mult_orig) >>
+		clocksource_u300_1mhz.shift;
+	return ret;
+}
 
 /*
  * This sets up the system timers, clock source and clock event.
-- 
1.6.2.1

