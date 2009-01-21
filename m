Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbZAUBqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbZAUBqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 20:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZAUBq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 20:46:26 -0500
Received: from smtp-out.google.com ([216.239.45.13]:28757 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbZAUBq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 20:46:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:content-transfer-encoding:
	x-operating-system:user-agent:x-gmailtapped-by:x-gmailtapped;
	b=hyaOJbUj046a8G7ZiRv8O2RJLG8Z+SSvpnZJ0VuBfizkTnSdwqxRjL3O7X8Luu/HW
	j6lS/prmwcOY8GRSMOHwA==
Date: Tue, 20 Jan 2009 17:46:15 -0800
From: Mandeep Singh Baines <msb@google.com>
To: fweisbec@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: rientjes@google.com, mbligh@google.com, thockin@google.com
Subject: [PATCH] softlockup: remove hung_task_check_count
Message-ID: <20090121014615.GA21018@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.25.146.18
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As suggested by Frederic Weisbecker.

Patch against tip/core/softlockup.

---
To avoid holding the tasklist lock too long, hung_task_check_count was used
as an upper bound on the number of tasks that are checked by hung_task.
This can be problematic if hung_task_check_count is set much lower than
the number of tasks in the system. A large number of tasks will not get
checked. This patch removes the hung_task_check_count sysctl.

Instead of checking a limited number of tasks, all tasks are checked. To
avoid holding the tasklist lock too long, the lock is released and the
processor rescheduled (if necessary) every n tasks (currently 1024).

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
 kernel/hung_task.c    |   25 +++++++++++++++++++++----
 kernel/sysctl.c       |    9 ---------
 3 files changed, 21 insertions(+), 14 deletions(-)

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
index ba8ccd4..f9b18e2 100644
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
@@ -116,7 +116,7 @@ static void check_hung_task(struct task_struct *t, unsigned long now,
  */
 static void check_hung_uninterruptible_tasks(unsigned long timeout)
 {
-	int max_count = sysctl_hung_task_check_count;
+	int max_count = HUNG_TASK_CHECK_COUNT;
 	unsigned long now = get_timestamp();
 	struct task_struct *g, *t;
 
@@ -129,8 +129,25 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
 
 	read_lock(&tasklist_lock);
 	do_each_thread(g, t) {
-		if (!--max_count)
-			goto unlock;
+		if (!--max_count) {
+			/*
+			 * Drop the lock every once in a while and resched if
+			 * necessary. Don't want to hold the lock too long.
+			 */
+			get_task_struct(t);
+			read_unlock(&tasklist_lock);
+			max_count = HUNG_TASK_CHECK_COUNT;
+			if (need_resched())
+				schedule();
+			read_lock(&tasklist_lock);
+			put_task_struct(t);
+			/*
+			 * t was unlinked from tasklist. Can't continue in this
+			 * case. Exit and try again next time.
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

