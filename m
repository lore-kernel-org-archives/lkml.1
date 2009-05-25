Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbZEYNFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbZEYNFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 09:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbZEYNEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 09:04:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:53305 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146AbZEYNEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 09:04:39 -0400
Date: Mon, 25 May 2009 13:03:55 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090525124600.203151469@chello.nl>
References: <20090525124600.203151469@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Make pctrl() affect inherited counters too
Message-ID: <tip-771d7cde144d87f2d1fbee4da3c6234d61f7e42a@git.kernel.org>
Git-Commit-ID: 771d7cde144d87f2d1fbee4da3c6234d61f7e42a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 25 May 2009 13:03:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  771d7cde144d87f2d1fbee4da3c6234d61f7e42a
Gitweb:     http://git.kernel.org/tip/771d7cde144d87f2d1fbee4da3c6234d61f7e42a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 25 May 2009 14:45:26 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 25 May 2009 14:55:00 +0200

perf_counter: Make pctrl() affect inherited counters too

Paul noted that the new ptcrl() didn't work on child counters.

Reported-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090525124600.203151469@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   48 ++++++++++++++++++++++++------------------------
 1 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 6cdf824..217dbcc 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1067,30 +1067,6 @@ static void perf_counter_cpu_sched_in(struct perf_cpu_context *cpuctx, int cpu)
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
@@ -1505,6 +1481,30 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
