Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbYH3RES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbYH3RES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 13:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYH3RD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 13:03:58 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:49054 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbYH3RD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 13:03:57 -0400
Date: Sat, 30 Aug 2008 21:08:41 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Albert Cahalan <acahalan@gmail.com>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] proc: don't confuse /bin/ps by zombie delay_group_leader's
Message-ID: <20080830170841.GA7887@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the main thread exits,

	void *do_thread(void *arg)
	{
		pause();
		return NULL;
	}

	int main(void)
	{
		pthread_t thr;
		pthread_create(&thr, NULL, do_thread, NULL);

		syscall(__NR_exit, 0);
		return 0;
	}

/bin/ps's output looks really confusing, as if the whole process is dead.
I think this even looks like a kernel bug to the user, because it sees a
zombie which is not going to be reaped.

Change get_task_state() to report "S (sleeping)" in this case. Still not
perfect because the task can be confused with the kernel thread (its ->mm
is NULL), but imho better anyway.

Also, uninline get_task_state(), it has 2 callers.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.27-rc4/fs/proc/array.c~ZOMBIE_LEADER	2008-07-30 13:12:47.000000000 +0400
+++ 2.6.27-rc4/fs/proc/array.c	2008-08-30 18:17:10.000000000 +0400
@@ -146,10 +146,14 @@ static const char *task_state_array[] = 
 	"X (dead)"		/* 32 */
 };
 
-static inline const char *get_task_state(struct task_struct *tsk)
+static const char *get_task_state(struct task_struct *tsk)
 {
-	unsigned int state = (tsk->state & TASK_REPORT) | tsk->exit_state;
 	const char **p = &task_state_array[0];
+	unsigned int state = tsk->exit_state | (tsk->state & TASK_REPORT);
+
+	/* don't confuse /bin/ps if the whole process is not dead */
+	if (tsk->exit_state && delay_group_leader(tsk))
+		state = TASK_INTERRUPTIBLE;
 
 	while (state) {
 		p++;

