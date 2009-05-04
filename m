Return-Path: <linux-kernel-owner+w=401wt.eu-S1758701AbZEDRfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701AbZEDRfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbZEDRep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:34:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:54714 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758578AbZEDRen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:34:43 -0400
Date: Mon, 4 May 2009 17:34:06 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: convert perf_resource_mutex to a spinlock
Message-ID: <tip-1dce8d99b85aba6eddb8b8260baea944922e6fe7@git.kernel.org>
Git-Commit-ID: 1dce8d99b85aba6eddb8b8260baea944922e6fe7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 04 May 2009 17:34:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1dce8d99b85aba6eddb8b8260baea944922e6fe7
Gitweb:     http://git.kernel.org/tip/1dce8d99b85aba6eddb8b8260baea944922e6fe7
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 4 May 2009 19:23:18 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 4 May 2009 19:30:42 +0200

perf_counter: convert perf_resource_mutex to a spinlock

Now percpu counters can be initialized very early. But the init
sequence uses mutex_lock(). Fortunately, perf_resource_mutex should
be a spinlock anyway, so convert it.

[ Impact: fix crash due to early init mutex use ]

LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index fcdafa2..5f86a11 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -46,9 +46,9 @@ static atomic_t nr_comm_tracking __read_mostly;
 int sysctl_perf_counter_priv __read_mostly; /* do we need to be privileged */
 
 /*
- * Mutex for (sysadmin-configurable) counter reservations:
+ * Lock for (sysadmin-configurable) counter reservations:
  */
-static DEFINE_MUTEX(perf_resource_mutex);
+static DEFINE_SPINLOCK(perf_resource_lock);
 
 /*
  * Architecture provided APIs - weak aliases:
@@ -3207,9 +3207,9 @@ static void __cpuinit perf_counter_init_cpu(int cpu)
 	cpuctx = &per_cpu(perf_cpu_context, cpu);
 	__perf_counter_init_context(&cpuctx->ctx, NULL);
 
-	mutex_lock(&perf_resource_mutex);
+	spin_lock(&perf_resource_lock);
 	cpuctx->max_pertask = perf_max_counters - perf_reserved_percpu;
-	mutex_unlock(&perf_resource_mutex);
+	spin_unlock(&perf_resource_lock);
 
 	hw_perf_counter_setup(cpu);
 }
@@ -3292,7 +3292,7 @@ perf_set_reserve_percpu(struct sysdev_class *class,
 	if (val > perf_max_counters)
 		return -EINVAL;
 
-	mutex_lock(&perf_resource_mutex);
+	spin_lock(&perf_resource_lock);
 	perf_reserved_percpu = val;
 	for_each_online_cpu(cpu) {
 		cpuctx = &per_cpu(perf_cpu_context, cpu);
@@ -3302,7 +3302,7 @@ perf_set_reserve_percpu(struct sysdev_class *class,
 		cpuctx->max_pertask = mpt;
 		spin_unlock_irq(&cpuctx->ctx.lock);
 	}
-	mutex_unlock(&perf_resource_mutex);
+	spin_unlock(&perf_resource_lock);
 
 	return count;
 }
@@ -3324,9 +3324,9 @@ perf_set_overcommit(struct sysdev_class *class, const char *buf, size_t count)
 	if (val > 1)
 		return -EINVAL;
 
-	mutex_lock(&perf_resource_mutex);
+	spin_lock(&perf_resource_lock);
 	perf_overcommit = val;
-	mutex_unlock(&perf_resource_mutex);
+	spin_unlock(&perf_resource_lock);
 
 	return count;
 }
