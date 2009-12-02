Return-Path: <linux-kernel-owner+w=401wt.eu-S1754568AbZLBI1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbZLBI1N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZLBI1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:27:12 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41956 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbZLBI1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:27:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B1624C7.7040302@jp.fujitsu.com>
Date: Wed, 02 Dec 2009 17:26:47 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Balbir Singh <balbir@in.ibm.com>
Subject: [PATCH -v2 1/2] sched, cputime: cleanups related to task_times()
References: <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <4B01A8DB.6090002@bluehost.com> <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com> <1258464288.7816.305.camel@laptop> <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com> <4B05F835.10401@jp.fujitsu.com> <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com> <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com>
In-Reply-To: <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove if({u,s}t)s because no one call it with NULL now.
- Use cputime_{add,sub}().
- Add ifndef-endif for prev_{u,s}time since they are used
  only when !VIRT_CPU_ACCOUNTING.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 include/linux/sched.h |    2 ++
 kernel/fork.c         |    2 ++
 kernel/sched.c        |   16 ++++++----------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d47f394..12dbb5c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1331,7 +1331,9 @@ struct task_struct {
 
 	cputime_t utime, stime, utimescaled, stimescaled;
 	cputime_t gtime;
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	cputime_t prev_utime, prev_stime;
+#endif
 	unsigned long nvcsw, nivcsw; /* context switch counts */
 	struct timespec start_time; 		/* monotonic time */
 	struct timespec real_start_time;	/* boot based time */
diff --git a/kernel/fork.c b/kernel/fork.c
index 166b8c4..ad7cb6d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1066,8 +1066,10 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->gtime = cputime_zero;
 	p->utimescaled = cputime_zero;
 	p->stimescaled = cputime_zero;
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
 	p->prev_utime = cputime_zero;
 	p->prev_stime = cputime_zero;
+#endif
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
 
diff --git a/kernel/sched.c b/kernel/sched.c
index db1f6b2..3674f77 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5164,10 +5164,8 @@ void account_idle_ticks(unsigned long ticks)
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
-	if (ut)
-		*ut = p->utime;
-	if (st)
-		*st = p->stime;
+	*ut = p->utime;
+	*st = p->stime;
 }
 #else
 
@@ -5177,7 +5175,7 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 
 void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, utime = p->utime, total = utime + p->stime;
+	cputime_t rtime, utime = p->utime, total = cputime_add(utime, p->stime);
 
 	/*
 	 * Use CFS's precise accounting:
@@ -5197,12 +5195,10 @@ void task_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
 	 * Compare with previous values, to keep monotonicity:
 	 */
 	p->prev_utime = max(p->prev_utime, utime);
-	p->prev_stime = max(p->prev_stime, rtime - p->prev_utime);
+	p->prev_stime = max(p->prev_stime, cputime_sub(rtime, p->prev_utime));
 
-	if (ut)
-		*ut = p->prev_utime;
-	if (st)
-		*st = p->prev_stime;
+	*ut = p->prev_utime;
+	*st = p->prev_stime;
 }
 #endif
 
-- 
1.6.5.3


