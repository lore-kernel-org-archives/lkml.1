Return-Path: <linux-kernel-owner+w=401wt.eu-S937238AbZAPTMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937238AbZAPTMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937135AbZAPTLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:11:12 -0500
Received: from relay3.sgi.com ([192.48.171.31]:58125 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764053AbZAPTLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:11:10 -0500
Message-Id: <20090116191108.392536000@polaris-admin.engr.sgi.com>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Jan 2009 11:11:09 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] work_on_cpu: dont try to get_online_cpus() in work_on_cpu.
Content-Disposition: inline; filename=remove-get_online_cpus-from-work_on_cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Impact: remove potential circular lock dependency with cpu hotplug lock

This has caused more problems than it solved, with a pile of cpu
hotplug locking issues.

Followup patches will get_online_cpus() in callers that need it, but
if they don't do it they're no worse than before when they were using
set_cpus_allowed without locking.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/workqueue.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- linux-2.6-for-ingo.orig/kernel/workqueue.c
+++ linux-2.6-for-ingo/kernel/workqueue.c
@@ -991,8 +991,8 @@ static void do_work_for_cpu(struct work_
  * @fn: the function to run
  * @arg: the function arg
  *
- * This will return -EINVAL in the cpu is not online, or the return value
- * of @fn otherwise.
+ * This will return the value @fn returns.
+ * It is up to the caller to ensure that the cpu doesn't go offline.
  */
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
@@ -1001,14 +1001,8 @@ long work_on_cpu(unsigned int cpu, long 
 	INIT_WORK(&wfc.work, do_work_for_cpu);
 	wfc.fn = fn;
 	wfc.arg = arg;
-	get_online_cpus();
-	if (unlikely(!cpu_online(cpu)))
-		wfc.ret = -EINVAL;
-	else {
-		schedule_work_on(cpu, &wfc.work);
-		flush_work(&wfc.work);
-	}
-	put_online_cpus();
+	schedule_work_on(cpu, &wfc.work);
+	flush_work(&wfc.work);
 
 	return wfc.ret;
 }

-- 
