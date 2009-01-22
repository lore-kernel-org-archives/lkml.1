Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbZAVA4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbZAVA4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 19:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZAVA4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 19:56:09 -0500
Received: from smtp-out.google.com ([216.239.45.13]:29583 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbZAVA4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 19:56:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:in-reply-to:message-id:
	mime-version:content-type:content-disposition:
	content-transfer-encoding:x-operating-system:user-agent:x-gmailtapped-by:x-gmailtapped;
	b=hNfqGmCcYAP+hF5gFrnBr2tXAA74rV8AFd0xwBzWb2Rwt39+CNEua/CoydMm3r7Zw
	LdSTD9mYrCyzV/6SMh+5g==
Date: Wed, 21 Jan 2009 16:54:05 -0800
From: Mandeep Singh Baines <msb@google.com>
To: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, mbligh@google.com, thockin@google.com
Subject: [PATCH v2] softlockup: remove hung_task_check_count
In-Reply-To: <20090121111314.GA23469@elte.hu>
Message-ID: <20090122005405.GA6067@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.24.198.101
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar (mingo@elte.hu) wrote:
> 
> firstly, this bit should move into a helper function. Also, why dont you 

Done.

> do the need_resched() check first (it's very lighweight) - and thus only 
> do the heavy ops (get-task-struct & tasklist_lock unlock) if that is set?
> 

Wanted to upper-bound the amount of time the lock is held. In order to
give others a chance to write_lock the tasklist, released the lock
regardless of whether a re-schedule is need.

> But most importantly, isnt the logic above confused? --max_count will 
> reach zero exactly once, and then we'll loop for a long time.

max_count was being reset. I just put it in a strange place. To make
the critical section a little smaller, max_count was being reset after
the read_lock was released. This was probably over-kill. Moved this to
right after the max_count check.

Frédéric Weisbecker (fweisbec@gmail.com) wrote:
> 
> Thanks Mandeep for this patch.
> 

np. Thanks for proposing it.

> By reading Ingo's review, I notice that the checks done by
> check_hung_task() are quite lightweight and then quick.
> I guess your loop is able to go through a good number of tasks before
> actually needing to be resched.
> Perhaps the max_count can be dropped actually, since it is a kind of
> arbitrary chosen constant.
> So you would just need to check need_resched() at each iteration.
> 

Would like to upper-bound the amount of time the read_lock is held. So the
lock is released every max_count iterations. But yeah, it is set to
an arbitrary value. Probably needs some tuning. Its a trade-off between
overhead and latency. The larger max_count, the more you amortize the
locks but increase the time other have to wait to write_lock the tasklist.

> 
> There are good chances that your "t" task hasn't died, but if so, you
> can just retry the whole thing.
> Perhaps that should require some tests to see if there is a good
> average of t->stat == TASK_DEAD path not taken,
> but of course, it depends on what the system is doing most.
> 
> What do you think?

Wanted to avoid doing an unbounded amount of work in check_hung_*_tasks.
So erring on the side of caution, decided to exit the loop as opposed
to retrying immediately. t->state == TASK_DEAD should be a rare event but
if it does happen the worst case is a delay in reporting hung tasks.

---
To avoid holding the tasklist lock too long, hung_task_check_count was used
as an upper bound on the number of tasks that are checked by hung_task.
This patch removes the hung_task_check_count sysctl.

Instead of checking a limited number of tasks, all tasks are checked. To
avoid holding the tasklist lock too long, the lock is released periodically
and the processor rescheduled if necessary.

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
 include/linux/sched.h |    1 -
 kernel/hung_task.c    |   31 +++++++++++++++++++++++++++----
 kernel/sysctl.c       |    9 ---------
 3 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f2f94d5..278121c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -315,7 +315,6 @@ static inline void touch_all_softlockup_watchdogs(void)
 
 #ifdef CONFIG_DETECT_HUNG_TASK
 extern unsigned int  sysctl_hung_task_panic;
-extern unsigned long sysctl_hung_task_check_count;
 extern unsigned long sysctl_hung_task_timeout_secs;
 extern unsigned long sysctl_hung_task_warnings;
 extern int proc_dohung_task_timeout_secs(struct ctl_table *table, int write,
diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index ba8ccd4..2880574 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -19,7 +19,7 @@
 /*
  * Have a reasonable limit on the number of tasks checked:
  */
-unsigned long __read_mostly sysctl_hung_task_check_count = 1024;
+#define HUNG_TASK_CHECK_COUNT 1024
 
 /*
  * Zero means infinite timeout - no checking done:
@@ -110,13 +110,28 @@ static void check_hung_task(struct task_struct *t, unsigned long now,
 }
 
 /*
+ * To avoid holding the tasklist read_lock for an unbounded amount of time,
+ * periodically release the lock and reschedule if necessary. This gives other
+ * tasks a chance to run and a chance to grab the write_lock.
+ */
+static void check_hung_reschedule(struct task_struct *t)
+{
+	get_task_struct(t);
+	read_unlock(&tasklist_lock);
+	if (need_resched())
+		schedule();
+	read_lock(&tasklist_lock);
+	put_task_struct(t);
+}
+
+/*
  * Check whether a TASK_UNINTERRUPTIBLE does not get woken up for
  * a really long time (120 seconds). If that happens, print out
  * a warning.
  */
 static void check_hung_uninterruptible_tasks(unsigned long timeout)
 {
-	int max_count = sysctl_hung_task_check_count;
+	int max_count = HUNG_TASK_CHECK_COUNT;
 	unsigned long now = get_timestamp();
 	struct task_struct *g, *t;
 
@@ -129,8 +144,16 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, t) {
-		if (!--max_count)
-			goto unlock;
+		if (!--max_count) {
+			max_count = HUNG_TASK_CHECK_COUNT;
+			check_hung_reschedule(t);
+			/*
+			 * Exit loop if t was unlinked during reschedule.
+			 * Try again later.
+			 */
+			if (t->state == TASK_DEAD)
+				goto unlock;
+		}
 		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
 		if (t->state == TASK_UNINTERRUPTIBLE)
 			check_hung_task(t, now, timeout);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 2481ed3..16526a2 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -820,15 +820,6 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "hung_task_check_count",
-		.data		= &sysctl_hung_task_check_count,
-		.maxlen		= sizeof(unsigned long),
-		.mode		= 0644,
-		.proc_handler	= &proc_doulongvec_minmax,
-		.strategy	= &sysctl_intvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "hung_task_timeout_secs",
 		.data		= &sysctl_hung_task_timeout_secs,
 		.maxlen		= sizeof(unsigned long),
-- 
1.5.4.5

