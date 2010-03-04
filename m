Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab0CDGli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 01:41:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53488
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206Ab0CDGlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 01:41:37 -0500
Date: Wed, 03 Mar 2010 22:41:54 -0800 (PST)
Message-Id: <20100303.224154.193731539.davem@davemloft.net>
To: johnstul@us.ibm.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [PATCH 12/14] sparc: Convert sparc to use
 read/update_persistent_clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1267675049-12337-13-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-11-git-send-email-johnstul@us.ibm.com>
	<1267675049-12337-12-git-send-email-johnstul@us.ibm.com>
	<1267675049-12337-13-git-send-email-johnstul@us.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Stultz <johnstul@us.ibm.com>
Date: Wed,  3 Mar 2010 19:57:27 -0800

> This patch converts the sparc architecture to use the generic read_persistent_clock and update_persistent_clock interfaces, reducing the amount of arch specific code we have to maintain, and allowing for further cleanups in the future.
> 
> I have not built or tested this patch, so help from arch maintainers would be appreciated.
> 
> Cc: David S. Miller" <davem@davemloft.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

Here's a version that compiles, you have to get rid of the now unused
variably last_rtc_update since we build with -Werror, and you can also
add my:

Acked-by: David S. Miller <davem@davemloft.net>

Also, you'll reach more sparc developers by CC:'ing sparclinux@vger.kernel.org
on your patches :-)

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
index 0d4c09b..4453003 100644
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
@@ -87,9 +92,6 @@ u32 (*do_arch_gettimeoffset)(void);
 
 static irqreturn_t timer_interrupt(int dummy, void *dev_id)
 {
-	/* last time the cmos clock got updated */
-	static long last_rtc_update;
-
 #ifndef CONFIG_SMP
 	profile_tick(CPU_PROFILING);
 #endif
@@ -101,16 +103,6 @@ static irqreturn_t timer_interrupt(int dummy, void *dev_id)
 
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
