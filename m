Return-Path: <linux-kernel-owner+w=401wt.eu-S1757677AbZFCNIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbZFCNIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 09:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757148AbZFCNHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 09:07:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:36930 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392AbZFCNHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 09:07:49 -0400
Date: Wed, 3 Jun 2009 13:07:08 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Fix race in counter initialization
Message-ID: <tip-a96bbc16418bc691317f265d6bf98ba941ca9c1a@git.kernel.org>
Git-Commit-ID: a96bbc16418bc691317f265d6bf98ba941ca9c1a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 03 Jun 2009 13:07:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a96bbc16418bc691317f265d6bf98ba941ca9c1a
Gitweb:     http://git.kernel.org/tip/a96bbc16418bc691317f265d6bf98ba941ca9c1a
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 3 Jun 2009 14:01:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 3 Jun 2009 14:57:03 +0200

perf_counter: Fix race in counter initialization

We need the PID namespace and counter ID available when the
counter overflows and we need to generate a sample event.

[ Impact: fix kernel crash with high-frequency sampling ]

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
[ fixed a further crash and cleaned up the initialization a bit ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 317cef7..ab44554 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -48,6 +48,8 @@ int sysctl_perf_counter_priv __read_mostly; /* do we need to be privileged */
 int sysctl_perf_counter_mlock __read_mostly = 512; /* 'free' kb per user */
 int sysctl_perf_counter_limit __read_mostly = 100000; /* max NMIs per second */
 
+static atomic64_t perf_counter_id;
+
 /*
  * Lock for (sysadmin-configurable) counter reservations:
  */
@@ -3351,14 +3353,18 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 
 	mutex_init(&counter->mmap_mutex);
 
-	counter->cpu			= cpu;
+	counter->cpu		= cpu;
 	counter->attr		= *attr;
-	counter->group_leader		= group_leader;
-	counter->pmu			= NULL;
-	counter->ctx			= ctx;
-	counter->oncpu			= -1;
+	counter->group_leader	= group_leader;
+	counter->pmu		= NULL;
+	counter->ctx		= ctx;
+	counter->oncpu		= -1;
+
+	counter->ns		= get_pid_ns(current->nsproxy->pid_ns);
+	counter->id		= atomic64_inc_return(&perf_counter_id);
+
+	counter->state		= PERF_COUNTER_STATE_INACTIVE;
 
-	counter->state = PERF_COUNTER_STATE_INACTIVE;
 	if (attr->disabled)
 		counter->state = PERF_COUNTER_STATE_OFF;
 
@@ -3402,6 +3408,8 @@ done:
 		err = PTR_ERR(pmu);
 
 	if (err) {
+		if (counter->ns)
+			put_pid_ns(counter->ns);
 		kfree(counter);
 		return ERR_PTR(err);
 	}
@@ -3419,8 +3427,6 @@ done:
 	return counter;
 }
 
-static atomic64_t perf_counter_id;
-
 /**
  * sys_perf_counter_open - open a performance counter, associate it to a task/cpu
  *
@@ -3515,9 +3521,6 @@ SYSCALL_DEFINE5(perf_counter_open,
 	list_add_tail(&counter->owner_entry, &current->perf_counter_list);
 	mutex_unlock(&current->perf_counter_mutex);
 
-	counter->ns = get_pid_ns(current->nsproxy->pid_ns);
-	counter->id = atomic64_inc_return(&perf_counter_id);
-
 	fput_light(counter_file, fput_needed2);
 
 out_fput:
