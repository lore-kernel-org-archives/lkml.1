Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935182Ab0CMAWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:22:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:47411 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935116Ab0CMAWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:22:32 -0500
Date: Sat, 13 Mar 2010 00:21:34 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       geert@linux-m68k.org, akpm@linux-foundation.org, johnstul@us.ibm.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       geert@linux-m68k.org, johnstul@us.ibm.com, akpm@linux-foundation.org,
       tglx@linutronix.de
In-Reply-To: <1267675049-12337-12-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-12-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] m68k: Convert m68k to use read/update_persistent_clock
Message-ID: <tip-ffbcad49e79cd82428010b44a87401446ea7f370@git.kernel.org>
Git-Commit-ID: ffbcad49e79cd82428010b44a87401446ea7f370
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Mar 2010 00:21:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffbcad49e79cd82428010b44a87401446ea7f370
Gitweb:     http://git.kernel.org/tip/ffbcad49e79cd82428010b44a87401446ea7f370
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Wed, 3 Mar 2010 19:57:26 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 13 Mar 2010 01:14:13 +0100

m68k: Convert m68k to use read/update_persistent_clock

This patch converts the m68k architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1267675049-12337-12-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/m68k/kernel/time.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 17dc2a3..4926b38 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -73,21 +73,24 @@ static irqreturn_t timer_interrupt(int irq, void *dummy)
 	return IRQ_HANDLED;
 }
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	struct rtc_time time;
+	ts->tv_sec = 0;
+	ts->tv_nsec = 0;
 
 	if (mach_hwclk) {
 		mach_hwclk(0, &time);
 
 		if ((time.tm_year += 1900) < 1970)
 			time.tm_year += 100;
-		xtime.tv_sec = mktime(time.tm_year, time.tm_mon, time.tm_mday,
+		ts->tv_sec = mktime(time.tm_year, time.tm_mon, time.tm_mday,
 				      time.tm_hour, time.tm_min, time.tm_sec);
-		xtime.tv_nsec = 0;
 	}
-	wall_to_monotonic.tv_sec = -xtime.tv_sec;
+}
 
+void __init time_init(void)
+{
 	mach_sched_init(timer_interrupt);
 }
 
