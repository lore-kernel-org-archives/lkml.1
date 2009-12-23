Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZLWEOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZLWEOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:14:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbZLWEOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:14:15 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:54057 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbZLWEOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:14:14 -0500
Subject: [RFC][PATCH 12/14] Convert parisc to read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       linux-parisc@vger.kernel.org
In-Reply-To: <1261541567.3508.73.camel@localhost.localdomain>
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
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:14:03 -0800
Message-ID: <1261541643.3508.74.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the parisc architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 time.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

Index: gettimeoffset/arch/parisc/kernel/time.c
===================================================================
--- gettimeoffset.orig/arch/parisc/kernel/time.c	2009-12-22 18:50:55.000000000 -0800
+++ gettimeoffset/arch/parisc/kernel/time.c	2009-12-22 18:51:06.000000000 -0800
@@ -250,9 +250,21 @@ static int __init rtc_init(void)
 }
 module_init(rtc_init);
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	static struct pdc_tod tod_data;
+	if (pdc_tod_read(&tod_data) == 0) {
+		ts->tv_sec = tod_data.tod_sec;
+		ts->tv_nsec = tod_data.tod_usec * 1000;
+	} else {
+		printk(KERN_ERR "Error reading tod clock\n");
+	        ts->tv_sec = 0;
+		ts->tv_nsec = 0;
+	}
+}
+
+void __init time_init(void)
+{
 	unsigned long current_cr16_khz;
 
 	clocktick = (100 * PAGE0->mem_10msec) / HZ;
@@ -264,19 +276,4 @@ void __init time_init(void)
 	clocksource_cr16.mult = clocksource_khz2mult(current_cr16_khz,
 						clocksource_cr16.shift);
 	clocksource_register(&clocksource_cr16);
-
-	if (pdc_tod_read(&tod_data) == 0) {
-		unsigned long flags;
-
-		write_seqlock_irqsave(&xtime_lock, flags);
-		xtime.tv_sec = tod_data.tod_sec;
-		xtime.tv_nsec = tod_data.tod_usec * 1000;
-		set_normalized_timespec(&wall_to_monotonic,
-		                        -xtime.tv_sec, -xtime.tv_nsec);
-		write_sequnlock_irqrestore(&xtime_lock, flags);
-	} else {
-		printk(KERN_ERR "Error reading tod clock\n");
-	        xtime.tv_sec = 0;
-		xtime.tv_nsec = 0;
-	}
 }


