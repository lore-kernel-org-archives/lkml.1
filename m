Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZL3GXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZL3GXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 01:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZL3GXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 01:23:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56824 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbZL3GXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 01:23:50 -0500
Message-ID: <4B3AF1EC.9010608@cn.fujitsu.com>
Date: Wed, 30 Dec 2009 14:23:40 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] ksym_tracer: Fix race when incrementing count
References: <4B3AF19E.1010201@cn.fujitsu.com>
In-Reply-To: <4B3AF19E.1010201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are under rcu read section but not holding the write lock, so
count++ is not atomic. Use atomic64_t instead.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
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
-- 
1.6.3

