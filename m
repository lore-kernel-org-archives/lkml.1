Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbZHOJDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbZHOJDh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 05:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbZHOJDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 05:03:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:55295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbZHOJDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 05:03:33 -0400
Date: Sat, 15 Aug 2009 09:01:56 GMT
From: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dwalker@fifo99.com, hpa@zytor.com,
       mingo@redhat.com, johnstul@us.ibm.com, schwidefsky@de.ibm.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, dwalker@fifo99.com,
       linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
       schwidefsky@de.ibm.com, tglx@linutronix.de
In-Reply-To: <20090814134808.142191175@de.ibm.com>
References: <20090814134808.142191175@de.ibm.com>
Subject: [tip:timers/core] timekeeping: Move reset of cycle_last for tsc clocksource to tsc
Message-ID: <tip-1be396794897f80bfc8774719ba60309a9e3d374@git.kernel.org>
Git-Commit-ID: 1be396794897f80bfc8774719ba60309a9e3d374
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 15 Aug 2009 09:02:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1be396794897f80bfc8774719ba60309a9e3d374
Gitweb:     http://git.kernel.org/tip/1be396794897f80bfc8774719ba60309a9e3d374
Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
AuthorDate: Fri, 14 Aug 2009 15:47:20 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 15 Aug 2009 10:55:45 +0200

timekeeping: Move reset of cycle_last for tsc clocksource to tsc

change_clocksource resets the cycle_last value to zero then sets it to
a value read from the clocksource. The reset to zero is required only
for the TSC clocksource to make the read_tsc function work after a
resume. The reason is that the TSC read function uses cycle_last to
detect backwards going TSCs. In the resume case cycle_last contains
the TSC value from the last update before the suspend. On resume the
TSC starts counting from 0 again and would trip over the cycle_last
comparison.

This is subtle and surprising. Move the reset to a resume function in
the tsc code.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: John Stultz <johnstul@us.ibm.com>
Cc: Daniel Walker <dwalker@fifo99.com>
LKML-Reference: <20090814134808.142191175@de.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 arch/x86/kernel/tsc.c     |    6 ++++++
 kernel/time/timekeeping.c |    1 -
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 71f4368..9684254 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -744,10 +744,16 @@ static cycle_t __vsyscall_fn vread_tsc(void)
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
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 016a259..b567301 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -295,7 +295,6 @@ static void change_clocksource(void)
 	if (old->disable)
 		old->disable(old);
 
-	clock->cycle_last = 0;
 	clock->cycle_last = clock->read(clock);
 	clock->error = 0;
 	clock->xtime_nsec = 0;
