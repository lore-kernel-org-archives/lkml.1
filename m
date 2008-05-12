Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYELO3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYELO3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 10:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbYELO3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 10:29:10 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64882 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751032AbYELO3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 10:29:09 -0400
Date: Mon, 12 May 2008 15:28:09 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] NTP: Make the RTC sync mode 11-minute again
Message-ID: <Pine.LNX.4.55.0805121510160.535@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 As a result of the rewrite to drive the RTC sync from NTP code to use a
timer, the piece of code responsible for doing this is triggered each time
do_adjtimex() is called.  Which may be as often as once per 64 seconds as
this is the minimum interval between NTP packets used by the daemon.  
Make the interval 11 minutes again, by not reactivating the timer if
pending already.

 Note with this approach, there is a small window where the timer has
expired, but has not been rearmed yet, for example when the handler is
still early in sync_cmos_clock() by the time this function is called.  
The likelihood of this event is epsilon and it should not be enough of a
problem to justify designing a mutex solution to avoid it -- if the
scenario happens either the RTC will be updated twice or mod_timer() will
be called from sync_cmos_clock() even before the newly-armed timer
expires, cancelling the additional update.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Tested successfully at the run time with a MIPS64 system (Broadcom 
SWARM).  Please apply.

  Maciej

patch-2.6.26-rc1-20080505-ntp-11min-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/kernel/time/ntp.c linux-2.6.26-rc1-20080505/kernel/time/ntp.c
--- linux-2.6.26-rc1-20080505.macro/kernel/time/ntp.c	2008-05-05 02:56:03.000000000 +0000
+++ linux-2.6.26-rc1-20080505/kernel/time/ntp.c	2008-05-12 01:51:21.000000000 +0000
@@ -263,7 +263,7 @@ static void sync_cmos_clock(unsigned lon
 
 static void notify_cmos_timer(void)
 {
-	if (!no_sync_cmos_clock)
+	if (!no_sync_cmos_clock && !timer_pending(&sync_cmos_timer))
 		mod_timer(&sync_cmos_timer, jiffies + 1);
 }
 
