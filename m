Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZEZGP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZEZGP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 02:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZEZGPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 02:15:47 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51616 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZEZGPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 02:15:46 -0400
Date: Tue, 26 May 2009 15:15:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org
Subject: [PATCH] sched: Support current clocksource handling in fallback sched_clock().
Message-ID: <20090526061532.GD9188@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Ingo Molnar <mingo@elte.hu>, Andrew Victor <linux@maxim.org.za>,
	Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are presently a number of issues and limitations with how the
clocksource and sched_clock() interaction works today. Configurations
tend to be grouped in to one of the following:

	- Platform provides a low rated clocksource (< 100) and prefers
	  to use jiffies for sched_clock() due to reliability concerns.

	- Platform provides its own clocksource and sched_clock() that
	  wraps in to it.

	- Platform uses a generic clocksource (ie, drivers/clocksource/)
	  combined with the generic jiffies-backed sched_clock().

	- Platform supports a generic highly-rated clocksource but ends
	  up having to use the jiffies sched_clock() anyways.

	- Platform supports multiple highly-rated clocksources.

In the first case, simply using the rating information is sufficient to
figure out the proper course of action. In the second case, very few of
these do anything outside of the regular cyc2ns() work on the preferred
clocksource, so it tends to be more about having access to the reference
clocksource data structures more than really wanting to do any special
calculations in sched_clock().

The last few cases are presently what we are faced with on sh, and which
also impacts other drivers/clocksource drivers (while acpi_pm seems to
have alternate recourse for sched_clock(), ARM/AVR32/SH do not). In these
cases multiple clocksources can be provided, and the availability of
these will often depend on runtime constraints (pinmux and so forth), in
which case link time determination is simply not sufficient. While these
clocksources can be highly rated and can offer excellent granularity, the
jiffies clocksource is still used as a fallback given the inability to
sprinkle sched_clock() wrappers in the drivers themselves. Also, while
sched_clock() could be moved in to struct clocksource itself, this does
not help the case where sched_clock() is called in to repeatedly well
before a preferred clocksource has been determined and made available
(printk times and so on), so extra logic is needed regardless.

This patch does the only thing I could think of to address most of
these in one shot, abusing the current clocksource pointer and forcing
sched_clock() to read from it directly as soon as it becomes available
(and assuming that is is rated highly enough). This does add the cost of
the rating test on systems that only have the jiffies clocksource, but I
think this is acceptable collateral damage given that jiffies are not
very granular to begin with.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 kernel/sched_clock.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e1d16c9..59bbeeb 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -30,6 +30,7 @@
 #include <linux/percpu.h>
 #include <linux/ktime.h>
 #include <linux/sched.h>
+#include <linux/clocksource.h>
 
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -38,6 +39,15 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
+	/*
+	 * Use the current clocksource when it becomes available later in
+	 * the boot process, and ensure that it has a high enough rating
+	 * to make it suitable for general use.
+	 */
+	if (clock && clock->rating >= 100)
+		return cyc2ns(clock, clocksource_read(clock));
+
+	/* Otherwise just fall back on jiffies */
 	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
 					* (NSEC_PER_SEC / HZ);
 }
