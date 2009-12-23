Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZLWEQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZLWEQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:16:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbZLWEQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:16:23 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:54733 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbZLWEQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:16:22 -0500
Subject: [RFC][PATCH 14/14] Convert sparc to read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
In-Reply-To: <1261541703.3508.75.camel@localhost.localdomain>
References: <1261540762.3508.61.camel@localhost.localdomain>
	 <1261540826.3508.62.camel@localhost.localdomain>
	 <1261540902.3508.63.camel@localhost.localdomain>
	 <1261540988.3508.64.camel@localhost.localdomain>
	 <1261541054.3508.65.camel@localhost.localdomain>
	 <1261541130.3508.66.camel@localhost.localdomain>
	 <1261541188.3508.67.camel@localhost.localdomain>
	 <1261541286.3508.69.camel@localhost.localdomain>
	 <1261541342.3508.70.camel@localhost.localdomain>
	 <1261541415.3508.71.camel@localhost.localdomain>
	 <1261541491.3508.72.camel@localhost.localdomain>
	 <1261541567.3508.73.camel@localhost.localdomain>
	 <1261541643.3508.74.camel@localhost.localdomain>
	 <1261541703.3508.75.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:16:11 -0800
Message-ID: <1261541771.3508.76.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the sparc architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 Kconfig          |    2 +-
 kernel/time_32.c |   15 +++++----------
 2 files changed, 6 insertions(+), 11 deletions(-)


Index: gettimeoffset/arch/sparc/Kconfig
===================================================================
--- gettimeoffset.orig/arch/sparc/Kconfig	2009-12-22 18:50:54.000000000 -0800
+++ gettimeoffset/arch/sparc/Kconfig	2009-12-22 18:51:25.000000000 -0800
@@ -69,7 +69,7 @@ config GENERIC_TIME
 
 config GENERIC_CMOS_UPDATE
 	bool
-	default y if SPARC64
+	default y
 
 config GENERIC_CLOCKEVENTS
 	bool
Index: gettimeoffset/arch/sparc/kernel/time_32.c
===================================================================
--- gettimeoffset.orig/arch/sparc/kernel/time_32.c	2009-12-22 18:50:54.000000000 -0800
+++ gettimeoffset/arch/sparc/kernel/time_32.c	2009-12-22 18:51:25.000000000 -0800
@@ -76,6 +76,11 @@ EXPORT_SYMBOL(profile_pc);
 
 __volatile__ unsigned int *master_l10_counter;
 
+int update_persistent_clock(struct timespec now)
+{
+	return set_rtc_mmss(now.tv_sec);
+}
+
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
@@ -99,16 +104,6 @@ static irqreturn_t timer_interrupt(int d
 
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


