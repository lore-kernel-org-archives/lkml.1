Return-Path: <linux-kernel-owner+w=401wt.eu-S1752630AbZL3JcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbZL3JcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 04:32:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbZL3JcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 04:32:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:57482 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbZL3JcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 04:32:14 -0500
Date: Wed, 30 Dec 2009 09:31:25 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <4B3AF1EC.9010608@cn.fujitsu.com>
References: <4B3AF1EC.9010608@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] ksym_tracer: Fix race when incrementing count
Message-ID: <tip-e6d9491bf8ba6728cc86aeabbc688d20ec0563b5@git.kernel.org>
Git-Commit-ID: e6d9491bf8ba6728cc86aeabbc688d20ec0563b5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6d9491bf8ba6728cc86aeabbc688d20ec0563b5
Gitweb:     http://git.kernel.org/tip/e6d9491bf8ba6728cc86aeabbc688d20ec0563b5
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Wed, 30 Dec 2009 14:23:40 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Dec 2009 07:50:49 +0100

ksym_tracer: Fix race when incrementing count

We are under rcu read section but not holding the write lock, so
count++ is not atomic. Use atomic64_t instead.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B3AF1EC.9010608@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/trace_ksym.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 160a8d8..67d79f7 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -32,6 +32,8 @@
 #include <linux/hw_breakpoint.h>
 #include <asm/hw_breakpoint.h>
 
+#include <asm/atomic.h>
+
 /*
  * For now, let us restrict the no. of symbols traced simultaneously to number
  * of available hardware breakpoint registers.
@@ -44,7 +46,7 @@ struct trace_ksym {
 	struct perf_event	**ksym_hbp;
 	struct perf_event_attr	attr;
 #ifdef CONFIG_PROFILE_KSYM_TRACER
-	unsigned long		counter;
+	atomic64_t		counter;
 #endif
 	struct hlist_node	ksym_hlist;
 };
@@ -69,9 +71,8 @@ void ksym_collect_stats(unsigned long hbp_hit_addr)
 
 	rcu_read_lock();
 	hlist_for_each_entry_rcu(entry, node, &ksym_filter_head, ksym_hlist) {
-		if ((entry->attr.bp_addr == hbp_hit_addr) &&
-		    (entry->counter <= MAX_UL_INT)) {
-			entry->counter++;
+		if (entry->attr.bp_addr == hbp_hit_addr) {
+			atomic64_inc(&entry->counter);
 			break;
 		}
 	}
@@ -501,7 +502,8 @@ static int ksym_tracer_stat_show(struct seq_file *m, void *v)
 		seq_printf(m, "  %-36s", fn_name);
 	else
 		seq_printf(m, "  %-36s", "<NA>");
-	seq_printf(m, " %15lu\n", entry->counter);
+	seq_printf(m, " %15llu\n",
+		   (unsigned long long)atomic64_read(&entry->counter));
 
 	return 0;
 }
