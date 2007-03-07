Return-Path: <linux-kernel-owner+w=401wt.eu-S1422897AbXCGRe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422897AbXCGRe7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422867AbXCGRQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:16:35 -0500
Received: from mail.suse.de ([195.135.220.2]:44017 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422841AbXCGRQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:16:08 -0500
Message-Id: <20070307171412.301042427@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Roman Zippel <zippel@linux-m68k.org>, Mike Galbraith <efault@gmx.de>,
       Ken Chen <kenneth.w.chen@intel.com>, balducci@units.it,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 053/101] Fix posix-cpu-timer breakage caused by stale p->last_ran value
Content-Disposition: inline; filename=fix-posix-cpu-timer-breakage-caused-by-stale-p-last_ran-value.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Problem description at:
http://bugzilla.kernel.org/show_bug.cgi?id=8048

Commit b18ec80396834497933d77b81ec0918519f4e2a7 
    [PATCH] sched: improve migration accuracy
optimized the scheduler time calculations, but broke posix-cpu-timers.

The problem is that the p->last_ran value is not updated after a context
switch. So a subsequent call to current_sched_time() calculates with a
stale p->last_ran value, i.e. accounts the full time, which the task was
scheduled away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/kernel/sched.c
+++ linux-2.6.20.1/kernel/sched.c
@@ -3547,7 +3547,7 @@ switch_tasks:
 
 	sched_info_switch(prev, next);
 	if (likely(prev != next)) {
-		next->timestamp = now;
+		next->timestamp = next->last_ran = now;
 		rq->nr_switches++;
 		rq->curr = next;
 		++*switch_count;

--
