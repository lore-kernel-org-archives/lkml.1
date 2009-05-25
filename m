Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZEYMsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZEYMsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbZEYMrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:47:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43547 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbZEYMrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:47:10 -0400
Message-Id: <20090525124600.203151469@chello.nl>
References: <20090525124523.010479297@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 25 May 2009 14:45:26 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 3/5] perf_counter: make pctrl() affect inherited counters too
Content-Disposition: inline; filename=perf_counter-pctrl-child.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul noted that the new ptcrl() didn't work on child counters.

LKML-Reference: <new-submission>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |   48 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1067,30 +1067,6 @@ static void perf_counter_cpu_sched_in(st
 	__perf_counter_sched_in(ctx, cpuctx, cpu);
 }
 
-int perf_counter_task_enable(void)
-{
-	struct perf_counter *counter;
-
-	mutex_lock(&current->perf_counter_mutex);
-	list_for_each_entry(counter, &current->perf_counter_list, owner_entry)
-		perf_counter_enable(counter);
-	mutex_unlock(&current->perf_counter_mutex);
-
-	return 0;
-}
-
-int perf_counter_task_disable(void)
-{
-	struct perf_counter *counter;
-
-	mutex_lock(&current->perf_counter_mutex);
-	list_for_each_entry(counter, &current->perf_counter_list, owner_entry)
-		perf_counter_disable(counter);
-	mutex_unlock(&current->perf_counter_mutex);
-
-	return 0;
-}
-
 static void perf_log_period(struct perf_counter *counter, u64 period);
 
 static void perf_adjust_freq(struct perf_counter_context *ctx)
@@ -1505,6 +1481,30 @@ static long perf_ioctl(struct file *file
 	return 0;
 }
 
+int perf_counter_task_enable(void)
+{
+	struct perf_counter *counter;
+
+	mutex_lock(&current->perf_counter_mutex);
+	list_for_each_entry(counter, &current->perf_counter_list, owner_entry)
+		perf_counter_for_each_child(counter, perf_counter_enable);
+	mutex_unlock(&current->perf_counter_mutex);
+
+	return 0;
+}
+
+int perf_counter_task_disable(void)
+{
+	struct perf_counter *counter;
+
+	mutex_lock(&current->perf_counter_mutex);
+	list_for_each_entry(counter, &current->perf_counter_list, owner_entry)
+		perf_counter_for_each_child(counter, perf_counter_disable);
+	mutex_unlock(&current->perf_counter_mutex);
+
+	return 0;
+}
+
 /*
  * Callers need to ensure there can be no nesting of this function, otherwise
  * the seqlock logic goes bad. We can not serialize this because the arch

-- 

