Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbXBRVoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbXBRVoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 16:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbXBRVoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 16:44:08 -0500
Received: from mail.screens.ru ([213.234.233.54]:56909 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXBRVoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 16:44:07 -0500
Date: Mon, 19 Feb 2007 00:44:07 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jun Nakajima <jun.nakajima@intel.com>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] cpufreq_ondemand.c: don't use _WORK_NAR
Message-ID: <20070218214407.GA4229@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like dbs_timer() is very careful wrt per_cpu(cpu_dbs_info),
and it doesn't need the help of WORK_STRUCT_NOAUTOREL.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- WQ/drivers/cpufreq/cpufreq_ondemand.c~2_cpufreq	2007-02-18 22:56:47.000000000 +0300
+++ WQ/drivers/cpufreq/cpufreq_ondemand.c	2007-02-19 00:07:46.000000000 +0300
@@ -432,9 +432,6 @@ static void do_dbs_timer(struct work_str
 	/* We want all CPUs to do sampling nearly on same jiffy */
 	int delay = usecs_to_jiffies(dbs_tuners_ins.sampling_rate);
 
-	/* Permit rescheduling of this work item */
-	work_release(work);
-
 	delay -= jiffies % delay;
 
 	if (lock_policy_rwsem_write(cpu) < 0)
@@ -473,7 +470,7 @@ static inline void dbs_timer_init(struct
 	dbs_info->enable = 1;
 	ondemand_powersave_bias_init();
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
-	INIT_DELAYED_WORK_NAR(&dbs_info->work, do_dbs_timer);
+	INIT_DELAYED_WORK(&dbs_info->work, do_dbs_timer);
 	queue_delayed_work_on(dbs_info->cpu, kondemand_wq, &dbs_info->work,
 	                      delay);
 }

