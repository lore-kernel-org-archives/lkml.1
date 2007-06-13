Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbXFMGH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbXFMGH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 02:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbXFMGHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 02:07:15 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:59318 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbXFMGHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 02:07:13 -0400
Date: Wed, 13 Jun 2007 16:07:11 +1000
To: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] Add per clocksource hook to settimeofday().
Message-ID: <20070613060711.GM15955@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working on a clocksource implementation for all powerpc platforms.
some of these platforms needs to do a little work as part of the
settimeofday() syscall and I can't see a way to do that without adding
this hook to clocksource.

From: Tony Breeds <tony@bakeyournoodle.com>

Add per clocksource hook to settimeofday().

Some clocksources need to do extra work as part of the settimeofday call, this
hook make it easy to do so.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

---

 include/linux/clocksource.h |    3 +++
 kernel/time/timekeeping.c   |    3 +++
 2 files changed, 6 insertions(+)

Index: working/include/linux/clocksource.h
===================================================================
--- working.orig/include/linux/clocksource.h
+++ working/include/linux/clocksource.h
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
Index: working/kernel/time/timekeeping.c
===================================================================
--- working.orig/kernel/time/timekeeping.c
+++ working/kernel/time/timekeeping.c
@@ -151,6 +151,9 @@ int do_settimeofday(struct timespec *tv)
 	clock->error = 0;
 	ntp_clear();
 
+	if (clock->settimeofday)
+		clock->settimeofday(clock, tv);
+
 	update_vsyscall(&xtime, clock);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

