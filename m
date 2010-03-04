Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0CDD7I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:59:08 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36189 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab0CDD55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:57:57 -0500
From: John Stultz <johnstul@us.ibm.com>
To: "	lkml" <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>,
       "David S. Miller\"" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 12/14] sparc: Convert sparc to use read/update_persistent_clock
Date: Wed,  3 Mar 2010 19:57:27 -0800
Message-Id: <1267675049-12337-13-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1267675049-12337-12-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-2-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-3-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-4-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-5-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-6-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-7-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-8-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-9-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-10-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-11-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-12-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the sparc architecture to use the generic read_persistent_clock and update_persistent_clock interfaces, reducing the amount of arch specific code we have to maintain, and allowing for further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers would be appreciated.

Cc: David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/sparc/Kconfig          |    2 +-
 arch/sparc/kernel/time_32.c |   15 +++++----------
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 4097f6a..0e8ec2a 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -72,7 +72,7 @@ config ARCH_USES_GETTIMEOFFSET
 
 config GENERIC_CMOS_UPDATE
 	bool
-	default y if SPARC64
+	default y
 
 config GENERIC_CLOCKEVENTS
 	bool
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index 0d4c09b..a3f1690 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -78,6 +78,11 @@ __volatile__ unsigned int *master_l10_counter;
 
 u32 (*do_arch_gettimeoffset)(void);
 
+int update_persistent_clock(struct timespec now)
+{
+	return set_rtc_mmss(now.tv_sec);
+}
+
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
@@ -101,16 +106,6 @@ static irqreturn_t timer_interrupt(int dummy, void *dev_id)
 
 	do_timer(1);
 
-	/* Determine when to update the Mostek clock. */
-	if (ntp_synced() &&
-	    xtime.tv_sec > last_rtc_update + 660 &&
-	    (xtime.tv_nsec / 1000) >= 500000 - ((unsigned) TICK_SIZE) / 2 &&
-	    (xtime.tv_nsec / 1000) <= 500000 + ((unsigned) TICK_SIZE) / 2) {
-	  if (set_rtc_mmss(xtime.tv_sec) == 0)
-	    last_rtc_update = xtime.tv_sec;
-	  else
-	    last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
-	}
 	write_sequnlock(&xtime_lock);
 
 #ifndef CONFIG_SMP
-- 
1.6.0.4

