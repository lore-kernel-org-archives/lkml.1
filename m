Return-Path: <linux-kernel-owner+w=401wt.eu-S932189AbZAQScV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189AbZAQScV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 13:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765370AbZAQScF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 13:32:05 -0500
Received: from smtp-out.google.com ([216.239.45.13]:14643 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765346AbZAQScE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 13:32:04 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:in-reply-to:x-operating-system:
	user-agent:x-gmailtapped-by:x-gmailtapped;
	b=ap0vipRGvCz4KJyXYMeNAL9znF/qB8yJHzQTOU/bU7f62Owcg/qwby9xdQkvv2edY
	lmO7kTuIh2I8mNqITQTEw==
Date: Sat, 17 Jan 2009 10:31:48 -0800
From: Mandeep Singh Baines <msb@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hannes@cmpxchg.org, rientjes@google.com,
       mbligh@google.com, thockin@google.com
Subject: [PATCH] softlockup: fix potential race in hung_task when resetting timeout
Message-ID: <20090117183148.GA20173@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116171832.GA18799@elte.hu>
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.28.16.76
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch against tip/core/softlockup.

---

A potential race exists if sysctl_hung_task_timeout_secs is reset to 0
while inside check_hung_uniterruptible_tasks(). If check_task() is
entered, a comparison with 0 will result in a false hung_task being
detected.

If sysctl_hung_task_panic is set, the system will panic.

Signed-off-by: Mandeep Singh Baines <msb@google.com>
---
 kernel/hung_task.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index ba5a77c..ba8ccd4 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -72,7 +72,8 @@ static unsigned long get_timestamp(void)
 	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
-static void check_hung_task(struct task_struct *t, unsigned long now)
+static void check_hung_task(struct task_struct *t, unsigned long now,
+			    unsigned long timeout)
 {
 	unsigned long switch_count = t->nvcsw + t->nivcsw;
 
@@ -84,8 +85,7 @@ static void check_hung_task(struct task_struct *t, unsigned long now)
 		t->last_switch_timestamp = now;
 		return;
 	}
-	if ((long)(now - t->last_switch_timestamp) <
-					sysctl_hung_task_timeout_secs)
+	if ((long)(now - t->last_switch_timestamp) < timeout)
 		return;
 	if (!sysctl_hung_task_warnings)
 		return;
@@ -96,8 +96,7 @@ static void check_hung_task(struct task_struct *t, unsigned long now)
 	 * complain:
 	 */
 	printk(KERN_ERR "INFO: task %s:%d blocked for more than "
-			"%ld seconds.\n", t->comm, t->pid,
-			sysctl_hung_task_timeout_secs);
+			"%ld seconds.\n", t->comm, t->pid, timeout);
 	printk(KERN_ERR "\"echo 0 > /proc/sys/kernel/hung_task_timeout_secs\""
 			" disables this message.\n");
 	sched_show_task(t);
@@ -115,7 +114,7 @@ static void check_hung_task(struct task_struct *t, unsigned long now)
  * a really long time (120 seconds). If that happens, print out
  * a warning.
  */
-static void check_hung_uninterruptible_tasks(void)
+static void check_hung_uninterruptible_tasks(unsigned long timeout)
 {
 	int max_count = sysctl_hung_task_check_count;
 	unsigned long now = get_timestamp();
@@ -134,7 +133,7 @@ static void check_hung_uninterruptible_tasks(void)
 			goto unlock;
 		/* use "==" to skip the TASK_KILLABLE tasks waiting on NFS */
 		if (t->state == TASK_UNINTERRUPTIBLE)
-			check_hung_task(t, now);
+			check_hung_task(t, now, timeout);
 	} while_each_thread(g, t);
  unlock:
 	read_unlock(&tasklist_lock);
@@ -180,8 +179,17 @@ static int watchdog(void *dummy)
 	update_poll_jiffies();
 
 	for ( ; ; ) {
+		unsigned long timeout;
+
 		while (schedule_timeout_interruptible(hung_task_poll_jiffies));
-		check_hung_uninterruptible_tasks();
+
+		/*
+		 * Need to cache timeout here to avoid timeout being set
+		 * to 0 via sysctl while inside check_hung_*_tasks().
+		 */
+		timeout = sysctl_hung_task_timeout_secs;
+		if (timeout)
+			check_hung_uninterruptible_tasks(timeout);
 	}
 
 	return 0;
-- 
1.5.4.5

