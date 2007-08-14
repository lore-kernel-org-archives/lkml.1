Return-Path: <linux-kernel-owner+w=401wt.eu-S1761796AbXHNOfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761796AbXHNOfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 10:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762530AbXHNOeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 10:34:18 -0400
Received: from cm135.gamma145.maxonline.com.sg ([202.156.145.135]:43019 "EHLO
	kerndev.sin.redhat.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762172AbXHNOeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 10:34:15 -0400
Date: Tue, 14 Aug 2007 22:34:11 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix tsk->exit_state usage
Message-ID: <20070814143411.GA23268@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

tsk->exit_state can only be 0, EXIT_ZOMBIE, or EXIT_DEAD. A non-zero test
is the same as tsk->exit_state & (EXIT_ZOMBIE | EXIT_DEAD), so just testing
tsk->exit_state is sufficient.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 fs/proc/array.c |    3 +--
 kernel/fork.c   |    2 +-
 kernel/sched.c  |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 965625a..babb24d 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -145,8 +145,7 @@ static inline const char *get_task_state(struct task_struct *tsk)
 					    TASK_UNINTERRUPTIBLE |
 					    TASK_STOPPED |
 					    TASK_TRACED)) |
-			(tsk->exit_state & (EXIT_ZOMBIE |
-					    EXIT_DEAD));
+					   tsk->exit_state;
 	const char **p = &task_state_array[0];
 
 	while (state) {
diff --git a/kernel/fork.c b/kernel/fork.c
index 7332e23..56d1b8b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -115,7 +115,7 @@ EXPORT_SYMBOL(free_task);
 
 void __put_task_struct(struct task_struct *tsk)
 {
-	WARN_ON(!(tsk->exit_state & (EXIT_DEAD | EXIT_ZOMBIE)));
+	WARN_ON(!tsk->exit_state);
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 45e17b8..8c27f08 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5190,7 +5190,7 @@ static void migrate_dead(unsigned int dead_cpu, struct task_struct *p)
 	struct rq *rq = cpu_rq(dead_cpu);
 
 	/* Must be exiting, otherwise would be on tasklist. */
-	BUG_ON(p->exit_state != EXIT_ZOMBIE && p->exit_state != EXIT_DEAD);
+	BUG_ON(!p->exit_state);
 
 	/* Cannot have done final schedule yet: would have vanished. */
 	BUG_ON(p->state == TASK_DEAD);

