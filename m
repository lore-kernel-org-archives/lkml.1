Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab0BXUhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:37:21 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33033 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757966Ab0BXUhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:37:19 -0500
Subject: [PATCH] Fix oops on !GENERIC_TIME systems when accessing
 current_clocksource
From: john stultz <johnstul@us.ibm.com>
To: greg kh <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, aaro.koskinen@iki.fi,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Feb 2010 12:37:11 -0800
Message-ID: <1267043831.3314.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aaro Koskinen reported an issue in bug #15366, where on non-GENERIC_TIME
systems,
accessing /sys/devices/system/clocksource/clocksource0/current_clocksource would oops the system. 

It seems the timekeeper/clocksource rework missed initializing the
curr_clocksource value in the !GENERIC_TIME.

The following patch makes sure it gets initialized, and avoids the
issue.

Thanks to Aaro for reporting and diagnosing the issue as well as testing
the fix!

Bug Details: http://bugzilla.kernel.org/show_bug.cgi?id=15366

Too late for 2.6.33, but this likely should go into 2.6.33-stable and
2.6.32-stable.

thanks
-john


Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index e85c234..c436ee5 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -568,6 +568,10 @@ static inline void clocksource_select(void) { }
  */
 static int __init clocksource_done_booting(void)
 {
+	mutex_lock(&clocksource_mutex);
+	curr_clocksource = clocksource_default_clock();
+	mutex_unlock(&clocksource_mutex);
+
 	finished_booting = 1;
 
 	/*


