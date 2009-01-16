Return-Path: <linux-kernel-owner+w=401wt.eu-S937386AbZAPTNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937386AbZAPTNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 14:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937136AbZAPTLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 14:11:18 -0500
Received: from relay1.sgi.com ([192.48.179.29]:55276 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937109AbZAPTLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 14:11:10 -0500
Message-Id: <20090116191108.533053000@polaris-admin.engr.sgi.com>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Jan 2009 11:11:10 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Content-Disposition: inline; filename=separate-work-queue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Impact: remove potential clashes with generic kevent workqueue

Annoyingly, some places we want to use work_on_cpu are already in
workqueues.  As per Ingo's suggestion, we create a different workqueue
for work_on_cpu.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/workqueue.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- linux-2.6-for-ingo.orig/kernel/workqueue.c
+++ linux-2.6-for-ingo/kernel/workqueue.c
@@ -971,6 +971,8 @@ undo:
 }
 
 #ifdef CONFIG_SMP
+static struct workqueue_struct *work_on_cpu_wq __read_mostly;
+
 struct work_for_cpu {
 	struct work_struct work;
 	long (*fn)(void *);
@@ -1001,7 +1003,7 @@ long work_on_cpu(unsigned int cpu, long 
 	INIT_WORK(&wfc.work, do_work_for_cpu);
 	wfc.fn = fn;
 	wfc.arg = arg;
-	schedule_work_on(cpu, &wfc.work);
+	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);
 	flush_work(&wfc.work);
 
 	return wfc.ret;
@@ -1019,4 +1021,8 @@ void __init init_workqueues(void)
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
+#ifdef CONFIG_SMP
+	work_on_cpu_wq = create_workqueue("work_on_cpu");
+	BUG_ON(!work_on_cpu_wq);
+#endif
 }

-- 
