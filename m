Return-Path: <linux-kernel-owner+w=401wt.eu-S1752754AbZFBUQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbZFBUQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZFBUQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:16:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:59451 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbZFBUQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:16:35 -0400
Date: Tue, 2 Jun 2009 20:16:04 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       eranian@googlemail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, eranian@googlemail.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Add unique counter id
Message-ID: <tip-8e5799b1ad2a0567fdfaaf0e91b40efee010f2c1@git.kernel.org>
Git-Commit-ID: 8e5799b1ad2a0567fdfaaf0e91b40efee010f2c1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 20:16:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8e5799b1ad2a0567fdfaaf0e91b40efee010f2c1
Gitweb:     http://git.kernel.org/tip/8e5799b1ad2a0567fdfaaf0e91b40efee010f2c1
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Jun 2009 15:08:15 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 21:45:29 +0200

perf_counter: Add unique counter id

Stephan raised the issue that we currently cannot distinguish between
similar counters within a group (PERF_RECORD_GROUP uses the config
value as identifier).

Therefore, generate a new ID for each counter using a global u64
sequence counter.

Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    8 +++++---
 kernel/perf_counter.c        |    9 +++++++--
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 9ec20fc..4845a21 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -114,8 +114,9 @@ enum perf_counter_record_format {
  * in increasing order of bit value, after the counter value.
  */
 enum perf_counter_read_format {
-	PERF_FORMAT_TOTAL_TIME_ENABLED	=  1,
-	PERF_FORMAT_TOTAL_TIME_RUNNING	=  2,
+	PERF_FORMAT_TOTAL_TIME_ENABLED	=  1U << 0,
+	PERF_FORMAT_TOTAL_TIME_RUNNING	=  1U << 1,
+	PERF_FORMAT_ID			=  1U << 2,
 };
 
 /*
@@ -290,7 +291,7 @@ enum perf_event_type {
 	 *	{ u32			cpu, res; } && PERF_RECORD_CPU
 	 *
 	 *	{ u64			nr;
-	 *	  { u64 event, val; }	cnt[nr];  } && PERF_RECORD_GROUP
+	 *	  { u64 id, val; }	cnt[nr];  } && PERF_RECORD_GROUP
 	 *
 	 *	{ u16			nr,
 	 *				hv,
@@ -503,6 +504,7 @@ struct perf_counter {
 	struct rcu_head			rcu_head;
 
 	struct pid_namespace		*ns;
+	u64				id;
 #endif
 };
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index caa012c..978ecfc 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1510,6 +1510,8 @@ perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 	if (counter->hw_event.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
 		values[n++] = counter->total_time_running +
 			atomic64_read(&counter->child_total_time_running);
+	if (counter->hw_event.read_format & PERF_FORMAT_ID)
+		values[n++] = counter->id;
 	mutex_unlock(&counter->child_mutex);
 
 	if (count < n * sizeof(u64))
@@ -2303,7 +2305,7 @@ static void perf_counter_output(struct perf_counter *counter,
 		u32 pid, tid;
 	} tid_entry;
 	struct {
-		u64 event;
+		u64 id;
 		u64 counter;
 	} group_entry;
 	struct perf_callchain_entry *callchain = NULL;
@@ -2416,7 +2418,7 @@ static void perf_counter_output(struct perf_counter *counter,
 			if (sub != counter)
 				sub->pmu->read(sub);
 
-			group_entry.event = sub->hw_event.config;
+			group_entry.id = sub->id;
 			group_entry.counter = atomic64_read(&sub->count);
 
 			perf_output_put(&handle, group_entry);
@@ -3375,6 +3377,8 @@ done:
 	return counter;
 }
 
+static atomic64_t perf_counter_id;
+
 /**
  * sys_perf_counter_open - open a performance counter, associate it to a task/cpu
  *
@@ -3470,6 +3474,7 @@ SYSCALL_DEFINE5(perf_counter_open,
 	mutex_unlock(&current->perf_counter_mutex);
 
 	counter->ns = get_pid_ns(current->nsproxy->pid_ns);
+	counter->id = atomic64_inc_return(&perf_counter_id);
 
 	fput_light(counter_file, fput_needed2);
 
