Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZEQOeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZEQOeq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 10:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbZEQOeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 10:34:36 -0400
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:44651 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751499AbZEQOef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 10:34:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8IAMK4D0pMQW1W/2dsb2JhbACBT4EwzSSCQoE/BQ
Date: Sun, 17 May 2009 10:29:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       stable@kernel.org, cpufreq@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       rjw@sisk.pl, Ben Slusky <sluskyb@paranoiacs.org>,
       Dave Jones <davej@redhat.com>
Subject: [PATCH] cpufreq fix timer teardown in conservative governor
Message-ID: <20090517142933.GB27882@Krystal>
References: <yO1BmxN79sN.A.xAG.8_zDKB@chimera> <pQ9WADCjgyE.A.PTG.HA0DKB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <pQ9WADCjgyE.A.PTG.HA0DKB@chimera>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:25:56 up 78 days, 10:52,  3 users,  load average: 0.16, 0.25,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13186
> Subject		: cpufreq timer teardown problem
> Submitter	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date		: 2009-04-23 14:00 (24 days old)
> References	: http://marc.info/?l=linux-kernel&m=124049523515036&w=4
> Handled-By	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Patch		: http://patchwork.kernel.org/patch/19754/
> 		  http://patchwork.kernel.org/patch/19753/
> 

(re-send with updated changelog)

cpufreq fix timer teardown in conservative governor

The problem is that dbs_timer_exit() uses cancel_delayed_work() when it should
use cancel_delayed_work_sync(). cancel_delayed_work() does not wait for the
workqueue handler to exit.

The ondemand governor does not seem to be affected because the
"if (!dbs_info->enable)" check at the beginning of the workqueue handler returns
immediately without rescheduling the work. The conservative governor in
2.6.30-rc has the same check as the ondemand governor, which makes things
usually run smoothly. However, if the governor is quickly stopped and then
started, this could lead to the following race :

dbs_enable could be reenabled and multiple do_dbs_timer handlers would run.
This is why a synchronized teardown is required.

Depends on patch
cpufreq: remove rwsem lock from CPUFREQ_GOV_STOP call

The following patch applies to 2.6.30-rc2. Stable kernels have a similar
issue which should also be fixed, but the code changed between 2.6.29
and 2.6.30, so this patch only applies to 2.6.30-rc.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: gregkh@suse.de
CC: stable@kernel.org
CC: cpufreq@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>
CC: rjw@sisk.pl
CC: Ben Slusky <sluskyb@paranoiacs.org>
CC: Dave Jones <davej@redhat.com>
---
 drivers/cpufreq/cpufreq_conservative.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/drivers/cpufreq/cpufreq_conservative.c
===================================================================
--- linux-2.6-lttng.orig/drivers/cpufreq/cpufreq_conservative.c	2009-04-23 23:22:15.000000000 -0400
+++ linux-2.6-lttng/drivers/cpufreq/cpufreq_conservative.c	2009-04-23 23:24:38.000000000 -0400
@@ -91,6 +91,9 @@ static unsigned int dbs_enable;	/* numbe
  * (like __cpufreq_driver_target()) is being called with dbs_mutex taken, then
  * cpu_hotplug lock should be taken before that. Note that cpu_hotplug lock
  * is recursive for the same process. -Venki
+ * DEADLOCK ALERT! (2) : do_dbs_timer() must not take the dbs_mutex, because it
+ * would deadlock with cancel_delayed_work_sync(), which is needed for proper
+ * raceless workqueue teardown.
  */
 static DEFINE_MUTEX(dbs_mutex);
 
@@ -542,7 +545,7 @@ static inline void dbs_timer_init(struct
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
