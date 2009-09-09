Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbZIIHfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbZIIHfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 03:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbZIIHfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 03:35:41 -0400
Received: from mail-pz0-f201.google.com ([209.85.222.201]:42372 "EHLO
	mail-pz0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZIIHfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 03:35:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Fb7TcivfFvk0vV+ppkHxUb+5F+SHIF2Wg1qiZ6B80ytja90lTvbd+AdIsQR9a3c/kY
         kwEaJ08qtveeqGq6pq1nEfXxxcRldTwHu2YLc3R7NLulzHg4+yh40bJoIRxPlV6Sqxw2
         oEx/7CvpGQnrJGtaQ3Ptu/g2aaeJjBBi1WAGo=
MIME-Version: 1.0
Date: Wed, 9 Sep 2009 15:35:43 +0800
Message-ID: <af3ea28a0909090035t710f5895i135760a2c7bd8a02@mail.gmail.com>
Subject: [PATCH] update clocksource raw_time in timekeeping_suspend
From: ye janboe <janboe.ye@gmail.com>
To: johnstul@us.ibm.com, zippel@linux-m68k.org, akpm@linux-foundation.org,
       mingo@elte.hu
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

after resume from suspend, raw_time is not updated in
timekeeping_suspend. CLOCK_MONOTONIC_RAW could not get the real hw
time.
This patch fix this issue.

Signed-off-by: janboe <janboe.ye@gmail.com>
---
 kernel/time/timekeeping.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e8c77d9..8420b85 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -331,6 +331,8 @@ static unsigned long timekeeping_suspend_time;
 static int timekeeping_resume(struct sys_device *dev)
 {
        unsigned long flags;
+       s64 nsec;
+       cycle_t last_cycle, cycle_delta;
        unsigned long now = read_persistent_clock();

        clocksource_resume();
@@ -346,8 +348,12 @@ static int timekeeping_resume(struct sys_device *dev)
        }
        update_xtime_cache(0);
        /* re-base the last cycle value */
+       last_cycle = clock->cycle_last;
        clock->cycle_last = 0;
        clock->cycle_last = clocksource_read(clock);
+       cycle_delta = clock->cycle_last - last_cycle;
+       nsec = cyc2ns(clock, cycle_delta);
+       timespec_add_ns(&clock->raw_time, nsec);
        clock->error = 0;
        timekeeping_suspended = 0;
        write_sequnlock_irqrestore(&xtime_lock, flags);
