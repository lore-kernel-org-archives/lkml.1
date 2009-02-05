Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbZBEEgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbZBEEgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 23:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbZBEEgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 23:36:10 -0500
Received: from smtp-out.google.com ([216.239.33.17]:1798 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbZBEEgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 23:36:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:content-transfer-encoding:in-reply-to:
	x-operating-system:user-agent:x-gmailtapped-by:x-gmailtapped;
	b=Itz47DRv7wFIP4iKKdDho4jxTsJqcCJUv1uBv5G9HIX5V5Gg1z71IY5wYr2oTVMbz
	iewJsZR7NsuZQFZJ2MtgQ==
Date: Wed, 4 Feb 2009 20:35:48 -0800
From: Mandeep Singh Baines <msb@google.com>
To: Ingo Molnar <mingo@elte.hu>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, mbligh@google.com, thockin@google.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/2 v4] softlockup: check all tasks in hung_task
Message-ID: <20090205043548.GA18933@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090204194339.GB22608@elte.hu>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.25.146.75
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mandeep Singh Baines <msb@google.com> wrote:
> 
> > +static void check_hung_rcu_refresh(struct task_struct *g, struct task_struct *t)
> 
> please rename this to rcu_lock_break().
> 

Fixed.

> >  	do_each_thread(g, t) {
> > -		if (!--max_count)
> > -			goto unlock;
> > +		if (!--max_count) {
> > +			max_count = sysctl_hung_task_check_count;
> > +			check_hung_rcu_refresh(g, t);
> > +			/* Exit if t or g was unhashed during refresh. */
> > +			if (t->state == TASK_DEAD || g->state == TASK_DEAD)
> > +				goto unlock;
> 
> Thinking about it some more, i think a slightly different approach (that has 
> the same end effect):
> 
>  - Add a "static const int check_count_batching = 1024;" variable that adds 
>    some natural batching - and initialize max_count to that value. There's 
>    little point to make that batching configurable.
> 

Fixed.

The batch_count controls the preemptibility of hung_task. While it might
not make sense to expose the value to user-space, we may want to use a
different value for the PREEMPT config (not sure what the specific values
should be):

#if defined(CONFIG_PREEMPT) && !defined(CONFIG_PREEMPT_RCU)
static const int check_count_batching = 256;
#else
static const int check_count_batching = 2048;
#endif

>  - Leave sysctl_hung_task_check_count present but change its default to 
>    something really large like MAX_PID.

Fixed.

Alternatively, the user could renice khungtaskd in order to control the share
of CPU used.

---
Changed the default value of hung_task_check_count to PID_MAX_LIMIT.
hung_task_batch_count added to put an upper bound on the critical
section. Every hung_task_batch_count checks, the rcu lock is broken.
Keeping the critical section small minimizes time preemption is disabled
and keeps rcu grace periods small.

To prevent following a stale pointer, get_task_struct is called on g and t.
To verify that g and t have not been unhashed while outside the critical
section, the task states are checked.

The design was proposed by Frédéric Weisbecker.

Frédéric Weisbecker (fweisbec@gmail.com) wrote:
>
> Instead of having this arbitrary limit of tasks, why not just
> lurk the need_resched() and then schedule if it needs too.
>
> I know that sounds a bit racy, because you will have to release the
> tasklist_lock and
> a lot of things can happen in the task list until you become resched.
> But you can do a get_task_struct() on g and t before your thread is
> going to sleep and then put them
> when it is awaken.
> Perhaps some tasks will disappear or be appended in the list before g
> and t, but that doesn't really matter:
> if they disappear, they didn't lockup, and if they were appended, they
> are not enough cold to be analyzed :-)
>
> This way you can drop the arbitrary limit of task number given by the user....
>
> Frederic.
>

Signed-off-by: Mandeep Singh Baines <msb@google.com>
---
 kernel/hung_task.c |   39 +++++++++++++++++++++++++++++++++++++--
 1 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index a841db3..34b678c 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -17,9 +17,18 @@
 #include <linux/sysctl.h>
 
 /*
- * Have a reasonable limit on the number of tasks checked:
+ * The number of tasks checked:
  */
-unsigned long __read_mostly sysctl_hung_task_check_count = 1024;
+unsigned long __read_mostly sysctl_hung_task_check_count = PID_MAX_LIMIT;
+
+/*
+ * Limit number of tasks checked in a batch.
+ *
+ * This value controls the preemptibility of khungtaskd since preemption
+ * is disabled during the critical section. It also controls the size of
+ * the RCU grace period. So it needs to be upper-bound.
+ */
+static const int hung_task_batching = 1024;
 
 /*
  * Zero means infinite timeout - no checking done:
@@ -109,6 +118,24 @@ static void check_hung_task(struct task_struct *t, unsigned long now,
 		panic("hung_task: blocked tasks");
 }
 
+ /*
+  * To avoid extending the RCU grace period for an unbounded amount of time,
+  * periodically exit the critical section and enter a new one.
+  *
+  * For preemptible RCU it is sufficient to call rcu_read_unlock in order
+  * exit the grace period. For classic RCU, a reschedule is required.
+  */
+static void rcu_lock_break(struct task_struct *g, struct task_struct *t)
+{
+	get_task_struct(g);
+	get_task_struct(t);
+	rcu_read_unlock();
+	cond_resched();
+	rcu_read_lock();
+	put_task_struct(t);
+	put_task_struct(g);
+}
+
 /*
  * Check whether a TASK_UNINTERRUPTIBLE does not get woken up for
  * a really long time (120 seconds). If that happens, print out
@@ -116,6 +143,7 @@ static void check_hung_task(struct task_struct *t, unsigned long now,
  */
 static void check_hung_uninterruptible_tasks(unsigned long timeout)
 {
+	int batch_count = hung_task_batching;
 	int max_count = sysctl_hung_task_check_count;
 	unsigned long now = get_timestamp();
 	struct task_struct *g, *t;
@@ -131,6 +159,13 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 	do_each_thread(g, t) {
 		if (!--max_count)
 			goto unlock;
+		if (!--batch_count) {
+			batch_count = hung_task_batching;
+			rcu_lock_break(g, t);
+			/* Exit if t or g was unhashed during refresh. */
+			if (t->state == TASK_DEAD || g->state == TASK_DEAD)
+				goto unlock;
+		}
 		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
 		if (t->state == TASK_UNINTERRUPTIBLE)
 			check_hung_task(t, now, timeout);
-- 
1.5.4.5

