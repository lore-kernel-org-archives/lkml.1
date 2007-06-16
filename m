Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbXFPK2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbXFPK2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 06:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754805AbXFPKYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 06:24:23 -0400
Received: from www.osadl.org ([213.239.205.134]:37216 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754162AbXFPKYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 06:24:18 -0400
Message-Id: <20070616101637.107940593@inhelltoy.tec.linutronix.de>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sat, 16 Jun 2007 10:36:15 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Tony Breeds <tony@bakeyournoodle.com>,
       john stultz <johnstul@us.ibm.com>
Subject: [patch-mm 15/25] clocksource: add settimeofday hook for PPC
Content-Disposition: inline; filename=clocksource-add-settimeofday-hook.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Breeds <tony@bakeyournoodle.com >

I'm working on a clocksource implementation for all powerpc platforms.
some of these platforms needs to do a little work as part of the
settimeofday() syscall and I can't see a way to do that without adding
this hook to clocksource.

From: Tony Breeds <tony@bakeyournoodle.com>

Add per clocksource hook to settimeofday().

Some clocksources need to do extra work as part of the settimeofday call, this
hook make it easy to do so.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>

---

 include/linux/clocksource.h |    3 +++
 kernel/time/timekeeping.c   |    3 +++
 2 files changed, 6 insertions(+)

Index: linux-2.6.22-rc4-mm/include/linux/clocksource.h
===================================================================
--- linux-2.6.22-rc4-mm.orig/include/linux/clocksource.h	2007-06-16 12:10:21.000000000 +0200
+++ linux-2.6.22-rc4-mm/include/linux/clocksource.h	2007-06-16 12:10:24.000000000 +0200
@@ -50,6 +50,7 @@ struct clocksource;
  * @flags:		flags describing special properties
  * @vread:		vsyscall based read
  * @resume:		resume function for the clocksource, if necessary
+ * @settimeofday:	[Optional] Do arch specific work during do_settimeofday
  * @cycle_interval:	Used internally by timekeeping core, please ignore.
  * @xtime_interval:	Used internally by timekeeping core, please ignore.
  */
@@ -68,6 +69,8 @@ struct clocksource {
 	cycle_t (*vread)(void);
 	void (*resume)(void);
 
+	void (*settimeofday)(struct clocksource *cs, struct timespec *ts);
+
 	/* timekeeping specific data, ignore */
 	cycle_t cycle_interval;
 	u64	xtime_interval;
Index: linux-2.6.22-rc4-mm/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.22-rc4-mm.orig/kernel/time/timekeeping.c	2007-06-16 12:10:23.000000000 +0200
+++ linux-2.6.22-rc4-mm/kernel/time/timekeeping.c	2007-06-16 12:10:24.000000000 +0200
@@ -159,6 +159,9 @@ int do_settimeofday(struct timespec *tv)
 	clock->error = 0;
 	ntp_clear();
 
+	if (clock->settimeofday)
+		clock->settimeofday(clock, tv);
+
 	update_vsyscall(&xtime, clock);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);

-- 

