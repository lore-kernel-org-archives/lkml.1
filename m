Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbYFDCik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbYFDCik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbYFDCiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:38:19 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:27558 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757633AbYFDCiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:38:16 -0400
Date: Tue, 3 Jun 2008 19:38:25 -0700
From: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH 1/4] per-task-delay-accounting: add memory reclaim delay
Message-Id: <20080603193825.12dbfff1.kobayashi.kk@ncos.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes, application responses become bad under heavy memory load.
Applications take a bit time to reclaim memory.
The statistics, how long memory reclaim takes, will be useful to
measure memory usage.

This patch adds accounting memory reclaim to per-task-delay-accounting
for accounting the time of try_to_free_pages().

<i.e>

- When System is under low memory load,
  memory reclaim may not occur.

$ free
             total       used       free     shared    buffers     cached
Mem:       8197800    1577300    6620500          0       4808    1516724
-/+ buffers/cache:      55768    8142032
Swap:     16386292          0   16386292

$ vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 5069748  10612 3014060    0    0     0     0    3   26  0  0 100  0
 0  0      0 5069748  10612 3014060    0    0     0     0    4   22  0  0 100  0
 0  0      0 5069748  10612 3014060    0    0     0     0    3   18  0  0 100  0

Measure the time of tar command.

$ ls -s test.dat
1501472 test.dat

$ time tar cvf test.tar test.dat
real    0m13.388s
user    0m0.116s
sys     0m5.304s

$ ./delayget -d -p <pid>
CPU             count     real total  virtual total    delay total
                  428     5528345500     5477116080       62749891
IO              count    delay total
                  338     8078977189
SWAP            count    delay total
                    0              0
RECLAIM         count    delay total
                    0              0

- When system is under heavy memory load
  memory reclaim may occur.

$ vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0 7159032  49724   1812   3012    0    0     0     0    3   24  0  0 100  0
 0  0 7159032  49724   1812   3012    0    0     0     0    4   24  0  0 100  0
 0  0 7159032  49848   1812   3012    0    0     0     0    3   22  0  0 100  0

In this case, one process uses more 8G memory 
by execution of malloc() and memset().


$ time tar cvf test.tar test.dat
real    1m38.563s        <-  increased by 85 sec
user    0m0.140s
sys     0m7.060s

$ ./delayget -d -p <pid>
CPU             count     real total  virtual total    delay total
                 9021     7140446250     7315277975      923201824
IO              count    delay total
                 8965    90466349669
SWAP            count    delay total
                    3       21036367
RECLAIM         count    delay total
                  740    61011951153

In the later case, the value of RECLAIM is increasing.
So, taskstats can show how much memory reclaim influences TAT.


Signed-off-by: Keika Kobayashi <kobayashi.kk@ncos.nec.co.jp>
---
 include/linux/delayacct.h |   19 +++++++++++++++++++
 include/linux/sched.h     |    4 ++++
 kernel/delayacct.c        |   13 +++++++++++++
 mm/page_alloc.c           |    3 +++
 4 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/delayacct.h b/include/linux/delayacct.h
index ab94bc0..f352f06 100644
--- a/include/linux/delayacct.h
+++ b/include/linux/delayacct.h
@@ -39,6 +39,8 @@ extern void __delayacct_blkio_start(void);
 extern void __delayacct_blkio_end(void);
 extern int __delayacct_add_tsk(struct taskstats *, struct task_struct *);
 extern __u64 __delayacct_blkio_ticks(struct task_struct *);
+extern void __delayacct_freepages_start(void);
+extern void __delayacct_freepages_end(void);

 static inline int delayacct_is_task_waiting_on_io(struct task_struct *p)
 {
@@ -107,6 +109,18 @@ static inline __u64 delayacct_blkio_ticks(struct task_struct *tsk)
 	return 0;
 }

+static inline void delayacct_freepages_start(void)
+{
+	if (current->delays)
+		__delayacct_freepages_start();
+}
+
+static inline void delayacct_freepages_end(void)
+{
+	if (current->delays)
+		__delayacct_freepages_end();
+}
+
 #else
 static inline void delayacct_set_flag(int flag)
 {}
@@ -129,6 +143,11 @@ static inline __u64 delayacct_blkio_ticks(struct task_struct *tsk)
 { return 0; }
 static inline int delayacct_is_task_waiting_on_io(struct task_struct *p)
 { return 0; }
+static inline void delayacct_freepages_start(void)
+{}
+static inline void delayacct_freepages_end(void)
+{}
+
 #endif /* CONFIG_TASK_DELAY_ACCT */

 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3e05e54..e6c557c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -666,6 +666,10 @@ struct task_delay_info {
 				/* io operations performed */
 	u32 swapin_count;	/* total count of the number of swapin block */
 				/* io operations performed */
+
+	struct timespec freepages_start, freepages_end;
+	u64 freepages_delay;	/* wait for memory reclaim */
+	u32 freepages_count;	/* total count of memory reclaim */
 };
 #endif	/* CONFIG_TASK_DELAY_ACCT */

diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index 10e43fd..84b6782 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -165,3 +165,16 @@ __u64 __delayacct_blkio_ticks(struct task_struct *tsk)
 	return ret;
 }

+void __delayacct_freepages_start(void)
+{
+	delayacct_start(&current->delays->freepages_start);
+}
+
+void __delayacct_freepages_end(void)
+{
+	delayacct_end(&current->delays->freepages_start,
+			&current->delays->freepages_end,
+			&current->delays->freepages_delay,
+			&current->delays->freepages_count);
+}
+
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8e83f02..8b4e606 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -46,6 +46,7 @@
 #include <linux/page-isolation.h>
 #include <linux/memcontrol.h>
 #include <linux/debugobjects.h>
+#include <linux/delayacct.h>

 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -1571,7 +1572,9 @@ nofail_alloc:
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;

+	delayacct_freepages_start();
 	did_some_progress = try_to_free_pages(zonelist, order, gfp_mask);
+	delayacct_freepages_end();

 	p->reclaim_state = NULL;
 	p->flags &= ~PF_MEMALLOC;
-- 
1.5.0.6
