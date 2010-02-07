Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab0BGRRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 12:17:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab0BGRRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 12:17:16 -0500
Date: Sun, 7 Feb 2010 18:16:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Frank Heckenbach <f.heckenbach@fh-soft.de>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] coredump: set ->group_exit_code for other CLONE_VM tasks
	too
Message-ID: <20100207171615.GA9854@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

User visible change.

do_coredump() kills all threads which share the same ->mm but only
the coredumping process gets the proper exit_code. Other tasks which
share the same ->mm die "silently" and return status == 0 to parent.

This is historical behaviour, not actually a bug. But I think Frank
Heckenbach rightly dislikes the current behaviour. Simple test-case:

	#include <stdio.h>
	#include <unistd.h>
	#include <signal.h>
	#include <sys/wait.h>

	int main(void)
	{
		int stat;

		if (!fork()) {
			if (!vfork())
				kill(getpid(), SIGQUIT);
		}

		wait(&stat);
		printf("stat=%x\n", stat);
		return 0;
	}

Before this patch it prints "stat=0" despite the fact the child was
killed by SIGQUIT. After this patch the output is "stat=3" which
obviously makes more sense.

Even with this patch, only the task which originates the coredumping
gets "|= 0x80" if the core was actually dumped, but at least the
coredumping signal is visible to do_wait/etc.

Reported-by: Frank Heckenbach <f.heckenbach@fh-soft.de>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/exec.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- V1/fs/exec.c~CD_STATUS	2009-12-18 00:20:50.000000000 +0100
+++ V1/fs/exec.c	2010-02-07 17:28:24.000000000 +0100
@@ -1536,12 +1536,13 @@ out:
 	return ispipe;
 }
 
-static int zap_process(struct task_struct *start)
+static int zap_process(struct task_struct *start, int exit_code)
 {
 	struct task_struct *t;
 	int nr = 0;
 
 	start->signal->flags = SIGNAL_GROUP_EXIT;
+	start->signal->group_exit_code = exit_code;
 	start->signal->group_stop_count = 0;
 
 	t = start;
@@ -1566,8 +1567,7 @@ static inline int zap_threads(struct tas
 	spin_lock_irq(&tsk->sighand->siglock);
 	if (!signal_group_exit(tsk->signal)) {
 		mm->core_state = core_state;
-		tsk->signal->group_exit_code = exit_code;
-		nr = zap_process(tsk);
+		nr = zap_process(tsk, exit_code);
 	}
 	spin_unlock_irq(&tsk->sighand->siglock);
 	if (unlikely(nr < 0))
@@ -1616,7 +1616,7 @@ static inline int zap_threads(struct tas
 			if (p->mm) {
 				if (unlikely(p->mm == mm)) {
 					lock_task_sighand(p, &flags);
-					nr += zap_process(p);
+					nr += zap_process(p, exit_code);
 					unlock_task_sighand(p, &flags);
 				}
 				break;

