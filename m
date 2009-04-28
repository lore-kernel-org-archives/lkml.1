Return-Path: <linux-kernel-owner+w=401wt.eu-S1760233AbZD1NAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233AbZD1NAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755444AbZD1NAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:00:36 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:46444 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753926AbZD1NAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:00:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEAPCW9klMQW1W/2dsb2JhbACBUM1Cg3MF
Date: Tue, 28 Apr 2009 09:00:32 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
Cc: gregkh@suse.de, stable@kernel.org, cpufreq@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rjw@sisk.pl,
       Ben Slusky <sluskyb@paranoiacs.org>, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq fix timer teardown in ondemand governor
	(2.6.28.x, 2.6.29.1, 2.6.30-rc2)
Message-ID: <20090428130032.GB26600@Krystal>
References: <20090423140002.GA12852@Krystal> <20090423164638.3b5769c6.akpm@linux-foundation.org> <20090424043809.GC8091@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090424043809.GC8091@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:57:23 up 59 days,  9:23,  2 users,  load average: 0.27, 0.58,
	0.56
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(this patch too has been forgotten. It fixes the same issue in ondemand
as we find in the very very similar (read : cut and pasted) conservative
cpufreq code). It applies to mainline head and -stable kernels.

The problem is that dbs_timer_exit() uses cancel_delayed_work() when it should
use cancel_delayed_work_sync(). cancel_delayed_work() does not wait for the
workqueue handler to exit.

The ondemand governor does not "seem" to be affected (read : race
condition occurs very rarely) because the "if (!dbs_info->enable)" check
at the beginning of the workqueue handler returns immediately without
rescheduling the work. The conservative governor in 2.6.30-rc has the
same check as the ondemand governor, which makes things usually run
smoothly. However, if the governor is quickly stopped and then started,
this could lead to the following race :

dbs_enable could be reenabled and multiple do_dbs_timer handlers would run.
This is why a synchronized teardown is required.

The following patch applies to, at least, 2.6.28.x, 2.6.29.1, 2.6.30-rc2.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: gregkh@suse.de
CC: stable@kernel.org
CC: cpufreq@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>
CC: rjw@sisk.pl
CC: Ben Slusky <sluskyb@paranoiacs.org>
CC: Dave Jones <davej@redhat.com>
CC: Chris Wright <chrisw@sous-sol.org>
---
 drivers/cpufreq/cpufreq_ondemand.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/drivers/cpufreq/cpufreq_ondemand.c
===================================================================
--- linux-2.6-lttng.orig/drivers/cpufreq/cpufreq_ondemand.c	2009-04-23 23:25:00.000000000 -0400
+++ linux-2.6-lttng/drivers/cpufreq/cpufreq_ondemand.c	2009-04-23 23:25:39.000000000 -0400
@@ -98,6 +98,9 @@ static unsigned int dbs_enable;	/* numbe
  * (like __cpufreq_driver_target()) is being called with dbs_mutex taken, then
  * cpu_hotplug lock should be taken before that. Note that cpu_hotplug lock
  * is recursive for the same process. -Venki
+ * DEADLOCK ALERT! (2) : do_dbs_timer() must not take the dbs_mutex, because it
+ * would deadlock with cancel_delayed_work_sync(), which is needed for proper
+ * raceless workqueue teardown.
  */
 static DEFINE_MUTEX(dbs_mutex);
 
@@ -562,7 +565,7 @@ static inline void dbs_timer_init(struct
 static inline void dbs_timer_exit(struct cpu_dbs_info_s *dbs_info)
 {
 	dbs_info->enable = 0;
-	cancel_delayed_work(&dbs_info->work);
+	cancel_delayed_work_sync(&dbs_info->work);
 }
 
 static int cpufreq_governor_dbs(struct cpufreq_policy *policy,

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
