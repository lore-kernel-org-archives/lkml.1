Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZIBTwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZIBTwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 15:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZIBTwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 15:52:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:58029 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbZIBTwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 15:52:23 -0400
Date: Wed, 2 Sep 2009 19:51:37 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf_counter: Introduce new (non-)paranoia level to allow raw tracepoint access
Message-ID: <tip-5380c1056d267eff49854c1fa03399bfe761da1e@git.kernel.org>
Git-Commit-ID: 5380c1056d267eff49854c1fa03399bfe761da1e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 02 Sep 2009 19:51:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5380c1056d267eff49854c1fa03399bfe761da1e
Gitweb:     http://git.kernel.org/tip/5380c1056d267eff49854c1fa03399bfe761da1e
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Wed, 2 Sep 2009 21:46:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 2 Sep 2009 21:47:06 +0200

perf_counter: Introduce new (non-)paranoia level to allow raw tracepoint access

I want to sample inherited tracepoint workloads as a normal
user and the CAP_SYS_ADMIN check prevents me from doing that
right now.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d988dfb..53ca946 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -46,12 +46,18 @@ static atomic_t nr_task_counters __read_mostly;
 
 /*
  * perf counter paranoia level:
- *  0 - not paranoid
- *  1 - disallow cpu counters to unpriv
- *  2 - disallow kernel profiling to unpriv
+ *  -1 - not paranoid at all
+ *   0 - disallow raw tracepoint access for unpriv
+ *   1 - disallow cpu counters for unpriv
+ *   2 - disallow kernel profiling for unpriv
  */
 int sysctl_perf_counter_paranoid __read_mostly = 1;
 
+static inline bool perf_paranoid_tracepoint_raw(void)
+{
+	return sysctl_perf_counter_paranoid > -1;
+}
+
 static inline bool perf_paranoid_cpu(void)
 {
 	return sysctl_perf_counter_paranoid > 0;
@@ -3971,6 +3977,7 @@ static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 	 * have these.
 	 */
 	if ((counter->attr.sample_type & PERF_SAMPLE_RAW) &&
+			&& perf_paranoid_tracepoint_raw() &&
 			!capable(CAP_SYS_ADMIN))
 		return ERR_PTR(-EPERM);
 
