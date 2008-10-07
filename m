Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbYJGBF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbYJGBF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756414AbYJGAqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:46:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:32905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758087AbYJGAqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:46:48 -0400
Date: Mon, 6 Oct 2008 17:40:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jiri Slaby <jirislaby@gmail.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: [patch 70/71] mm owner: fix race between swapoff and exit
Message-ID: <20081007004029.GS3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-owner-fix-race-between-swapoff-and-exit.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Balbir Singh <balbir@linux.vnet.ibm.com>

[Here's a backport of 2.6.27-rc8's 31a78f23bac0069004e69f98808b6988baccb6b6
 to 2.6.26 or 2.6.26.5: I wouldn't trouble -stable for the (root only)
 swapoff case which uncovered the bug, but the /proc/<pid>/<mmstats> case
 is open to all, so I think worth plugging in the next 2.6.26-stable.
 - Hugh]


There's a race between mm->owner assignment and swapoff, more easily
seen when task slab poisoning is turned on.  The condition occurs when
try_to_unuse() runs in parallel with an exiting task.  A similar race
can occur with callers of get_task_mm(), such as /proc/<pid>/<mmstats>
or ptrace or page migration.

CPU0                                    CPU1
                                        try_to_unuse
                                        looks at mm = task0->mm
                                        increments mm->mm_users
task 0 exits
mm->owner needs to be updated, but no
new owner is found (mm_users > 1, but
no other task has task->mm = task0->mm)
mm_update_next_owner() leaves
                                        mmput(mm) decrements mm->mm_users
task0 freed
                                        dereferencing mm->owner fails

The fix is to notify the subsystem via mm_owner_changed callback(),
if no new owner is found, by specifying the new task as NULL.

Jiri Slaby:
mm->owner was set to NULL prior to calling cgroup_mm_owner_callbacks(), but
must be set after that, so as not to pass NULL as old owner causing oops.

Daisuke Nishimura:
mm_update_next_owner() may set mm->owner to NULL, but mem_cgroup_from_task()
and its callers need to take account of this situation to avoid oops.

Hugh Dickins:
Lockdep warning and hang below exec_mmap() when testing these patches.
exit_mm() up_reads mmap_sem before calling mm_update_next_owner(),
so exec_mmap() now needs to do the same.  And with that repositioning,
there's now no point in mm_need_new_owner() allowing for NULL mm.

Reported-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c       |    2 +-
 kernel/cgroup.c |    5 +++--
 kernel/exit.c   |   12 ++++++++++--
 mm/memcontrol.c |   13 +++++++++++++
 4 files changed, 27 insertions(+), 5 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -740,11 +740,11 @@ static int exec_mmap(struct mm_struct *m
 	tsk->active_mm = mm;
 	activate_mm(active_mm, mm);
 	task_unlock(tsk);
-	mm_update_next_owner(old_mm);
 	arch_pick_mmap_layout(mm);
 	if (old_mm) {
 		up_read(&old_mm->mmap_sem);
 		BUG_ON(active_mm != old_mm);
+		mm_update_next_owner(old_mm);
 		mmput(old_mm);
 		return 0;
 	}
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2761,14 +2761,15 @@ void cgroup_fork_callbacks(struct task_s
  */
 void cgroup_mm_owner_callbacks(struct task_struct *old, struct task_struct *new)
 {
-	struct cgroup *oldcgrp, *newcgrp;
+	struct cgroup *oldcgrp, *newcgrp = NULL;
 
 	if (need_mm_owner_callback) {
 		int i;
 		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
 			oldcgrp = task_cgroup(old, ss->subsys_id);
-			newcgrp = task_cgroup(new, ss->subsys_id);
+			if (new)
+				newcgrp = task_cgroup(new, ss->subsys_id);
 			if (oldcgrp == newcgrp)
 				continue;
 			if (ss->mm_owner_changed)
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -577,8 +577,6 @@ mm_need_new_owner(struct mm_struct *mm, 
 	 * If there are other users of the mm and the owner (us) is exiting
 	 * we need to find a new owner to take on the responsibility.
 	 */
-	if (!mm)
-		return 0;
 	if (atomic_read(&mm->mm_users) <= 1)
 		return 0;
 	if (mm->owner != p)
@@ -621,6 +619,16 @@ retry:
 	} while_each_thread(g, c);
 
 	read_unlock(&tasklist_lock);
+	/*
+	 * We found no owner yet mm_users > 1: this implies that we are
+	 * most likely racing with swapoff (try_to_unuse()) or /proc or
+	 * ptrace or page migration (get_task_mm()).  Mark owner as NULL,
+	 * so that subsystems can understand the callback and take action.
+	 */
+	down_write(&mm->mmap_sem);
+	cgroup_mm_owner_callbacks(mm->owner, NULL);
+	mm->owner = NULL;
+	up_write(&mm->mmap_sem);
 	return;
 
 assign_new_owner:
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -250,6 +250,14 @@ static struct mem_cgroup *mem_cgroup_fro
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 {
+	/*
+	 * mm_update_next_owner() may clear mm->owner to NULL
+	 * if it races with swapoff, page migration, etc.
+	 * So this can be called with p == NULL.
+	 */
+	if (unlikely(!p))
+		return NULL;
+
 	return container_of(task_subsys_state(p, mem_cgroup_subsys_id),
 				struct mem_cgroup, css);
 }
@@ -574,6 +582,11 @@ retry:
 
 	rcu_read_lock();
 	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
+	if (unlikely(!mem)) {
+		rcu_read_unlock();
+		kmem_cache_free(page_cgroup_cache, pc);
+		return 0;
+	}
 	/*
 	 * For every charge from the cgroup, increment reference count
 	 */

-- 
