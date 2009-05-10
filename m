Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbZEJTMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbZEJTMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 15:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZEJTMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 15:12:06 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:51867 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZEJTMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 15:12:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0FAJbABkpMQW1W/2dsb2JhbACBUMt5gjaBSAU
Date: Sun, 10 May 2009 15:12:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ben Slusky <sluskyb@paranoiacs.org>, Dave Jones <davej@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC patch] cpufreq: fix circular locking in teardown
Message-ID: <20090510191202.GA14894@Krystal>
References: <2f11576a0905100822y5507a9f7m6f9aa0fcc05ac18@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <2f11576a0905100822y5507a9f7m6f9aa0fcc05ac18@mail.gmail.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:50:11 up 71 days, 15:16,  4 users,  load average: 0.58, 0.61,
	0.63
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> Hi
> 
> my box output following warnings.
> it seems regression by commit 7ccc7608b836e58fbacf65ee4f8eefa288e86fac.
> 
> A: work -> do_dbs_timer()  -> cpu_policy_rwsem
> B: store() -> cpu_policy_rwsem -> cpufreq_governor_dbs() -> work
> 
> 

Hrm, I think it must be due to my attempt to fix the timer teardown race
in ondemand governor mixed with new locking behavior in 2.6.30-rc.

The rwlock seems to be taken around the whole call to
cpufreq_governor_dbs(), when it should be only taken around accesses to
the locked data, and especially *not* around the call to
dbs_timer_exit().

Reverting my fix attempt would put the teardown race back in place
(replacing the cancel_delayed_work_sync by cancel_delayed_work).
Instead, a proper fix would imply modifying this critical section :

cpufreq.c: __cpufreq_remove_dev()
...
        if (cpufreq_driver->target)
                __cpufreq_governor(data, CPUFREQ_GOV_STOP);

        unlock_policy_rwsem_write(cpu);

To make sure the __cpufreq_governor() callback is not called with rwsem
held. This would allow execution of cancel_delayed_work_sync() without
being nested within the rwsem.

Here is a first cut at a RFC patch for cpufreq.c locking. This is 
currently untested.

Applies on top of the 2.6.30-rc5 tree with

cpufreq-fix-timer-teardown-in-conservative-governor.patch
cpufreq-fix-timer-teardown-in-ondemand-governor.patch

already applied. Should fix circular dep in teardown of both conservative and
ondemande governors. At a first glance, CPUFREQ_GOV_STOP does not seem to modify
the policy, therefore this locking seemed unneeded.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ben Slusky <sluskyb@paranoiacs.org>
CC: Dave Jones <davej@redhat.com>
CC: Chris Wright <chrisw@sous-sol.org>
CC: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/cpufreq/cpufreq.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/drivers/cpufreq/cpufreq.c
===================================================================
--- linux-2.6-lttng.orig/drivers/cpufreq/cpufreq.c	2009-05-10 14:41:53.000000000 -0400
+++ linux-2.6-lttng/drivers/cpufreq/cpufreq.c	2009-05-10 14:42:29.000000000 -0400
@@ -1070,11 +1070,11 @@ static int __cpufreq_remove_dev(struct s
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #endif
 
+	unlock_policy_rwsem_write(cpu);
+
 	if (cpufreq_driver->target)
 		__cpufreq_governor(data, CPUFREQ_GOV_STOP);
 
-	unlock_policy_rwsem_write(cpu);
-
 	kobject_put(&data->kobj);
 
 	/* we need to make sure that the underlying kobj is actually

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
