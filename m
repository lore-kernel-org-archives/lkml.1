Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbZIAM1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbZIAM1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 08:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754375AbZIAM1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 08:27:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346AbZIAM1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 08:27:11 -0400
Date: Tue, 1 Sep 2009 14:23:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/2] do_wait-wakeup-optimization: fix
	child_wait_callback()->eligible_child() usage
Message-ID: <20090901122325.GB20989@redhat.com>
References: <20090827144453.25f1161b.kamezawa.hiroyu@jp.fujitsu.com> <20090827160532.d6386722.kamezawa.hiroyu@jp.fujitsu.com> <20090827093441.GA3451@redhat.com> <20090827184303.500ac1f0.kamezawa.hiroyu@jp.fujitsu.com> <20090827100846.GA6462@redhat.com> <20090827193133.b7eed4a9.kamezawa.hiroyu@jp.fujitsu.com> <20090827105209.GA8469@redhat.com> <20090828171724.GA17445@redhat.com> <20090828191624.0F5BC45B02@magilla.sf.frob.com> <20090901122240.GA20989@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901122240.GA20989@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(on top of do_wait-wakeup-optimization-child_wait_callback-check-__wnothread-case.patch,
 fixes do_wait-wakeup-optimization-change-__wake_up_parent-to-use-filtered-wakeup.patch)

child_wait_callback()->eligible_child() is not right, we can miss the
wakeup if the task was detached before __wake_up_parent() and the caller
of do_wait() didn't use __WALL.

Move ->wo_pid checks from eligible_child() to the new helper, eligible_pid(),
and change child_wait_callback() to use it instead of eligible_child().

Note: actually I think it would be better to fix the __WCLONE check in
eligible_child(), it doesn't look exactly right. But it is not clear what
is the supposed behaviour, and any change is user-visible.

Reported-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/exit.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- WAIT/kernel/exit.c~2_WAKE_PARENT_ELIGIBLE_FIX	2009-09-01 12:49:27.000000000 +0200
+++ WAIT/kernel/exit.c	2009-09-01 12:59:23.000000000 +0200
@@ -1106,13 +1106,16 @@ static struct pid *task_pid_type(struct 
 	return pid;
 }
 
-static int eligible_child(struct wait_opts *wo, struct task_struct *p)
+static inline int eligible_pid(struct wait_opts *wo, struct task_struct *p)
 {
-	if (wo->wo_type < PIDTYPE_MAX) {
-		if (task_pid_type(p, wo->wo_type) != wo->wo_pid)
-			return 0;
-	}
+	return	wo->wo_type == PIDTYPE_MAX ||
+		task_pid_type(p, wo->wo_type) == wo->wo_pid;
+}
 
+static int eligible_child(struct wait_opts *wo, struct task_struct *p)
+{
+	if (!eligible_pid(wo, p))
+		return 0;
 	/* Wait for all children (clone and not) if __WALL is set;
 	 * otherwise, wait for clone children *only* if __WCLONE is
 	 * set; otherwise, wait for non-clone children *only*.  (Note:
@@ -1564,7 +1567,7 @@ static int child_wait_callback(wait_queu
 						child_wait);
 	struct task_struct *p = key;
 
-	if (!eligible_child(wo, p))
+	if (!eligible_pid(wo, p))
 		return 0;
 
 	if ((wo->wo_flags & __WNOTHREAD) && wait->private != p->parent)

