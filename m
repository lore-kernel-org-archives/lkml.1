Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYFDCqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYFDCqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbYFDCp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:45:59 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:29394 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbYFDCp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:45:58 -0400
Date: Tue, 3 Jun 2008 19:46:08 -0700
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 4/4] per-task-delay-accounting: /proc export for memory
 reclaim delay
Message-Id: <20080603194608.ed76ecf3.kobayashi.kk@ncos.nec.co.jp>
In-Reply-To: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
References: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
---
 fs/proc/array.c           |    3 ++-
 include/linux/delayacct.h |   10 ++++++++++
 kernel/delayacct.c        |   11 +++++++++++
 3 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 9e3b8c3..a3e6e86 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -498,7 +498,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,

 	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
+%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %llu %lu %ld\n",
 		pid_nr_ns(pid, ns),
 		tcomm,
 		state,
@@ -544,6 +544,7 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 		task->rt_priority,
 		task->policy,
 		(unsigned long long)delayacct_blkio_ticks(task),
+		(unsigned long long)delayacct_freepages_ticks(task),
 		cputime_to_clock_t(gtime),
 		cputime_to_clock_t(cgtime));
 	if (mm)
diff --git a/include/linux/delayacct.h b/include/linux/delayacct.h
index f352f06..226b754 100644
--- a/include/linux/delayacct.h
+++ b/include/linux/delayacct.h
@@ -41,6 +41,7 @@ extern int __delayacct_add_tsk(struct taskstats *, struct task_struct *);
 extern __u64 __delayacct_blkio_ticks(struct task_struct *);
 extern void __delayacct_freepages_start(void);
 extern void __delayacct_freepages_end(void);
+extern __u64 __delayacct_freepages_ticks(struct task_struct *);

 static inline int delayacct_is_task_waiting_on_io(struct task_struct *p)
 {
@@ -121,6 +122,13 @@ static inline void delayacct_freepages_end(void)
 		__delayacct_freepages_end();
 }

+static inline __u64 delayacct_freepages_ticks(struct task_struct *tsk)
+{
+	if (tsk->delays)
+		return __delayacct_freepages_ticks(tsk);
+	return 0;
+}
+
 #else
 static inline void delayacct_set_flag(int flag)
 {}
@@ -147,6 +155,8 @@ static inline void delayacct_freepages_start(void)
 {}
 static inline void delayacct_freepages_end(void)
 {}
+static inline __u64 delayacct_freepages_ticks(struct task_struct *tsk)
+{ return 0; }

 #endif /* CONFIG_TASK_DELAY_ACCT */

diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index b3179da..62601d3 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -181,3 +181,14 @@ void __delayacct_freepages_end(void)
 			&current->delays->freepages_count);
 }

+__u64 __delayacct_freepages_ticks(struct task_struct *tsk)
+{
+	__u64 ret;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tsk->delays->lock, flags);
+	ret = nsec_to_clock_t(tsk->delays->freepages_delay);
+	spin_unlock_irqrestore(&tsk->delays->lock, flags);
+	return ret;
+}
+
-- 
1.5.0.6
