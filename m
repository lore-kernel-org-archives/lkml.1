Return-Path: <linux-kernel-owner+w=401wt.eu-S934243AbZIDUWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243AbZIDUWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 16:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933960AbZIDUOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 16:14:12 -0400
Received: from kroah.org ([198.145.64.141]:36091 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933927AbZIDUOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 16:14:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 13:08:50 2009
Message-Id: <20090904200850.199599575@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 13:07:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [patch 02/48] clone(): fix race between copy_process() and de_thread()
References: <20090904200712.724048145@mini.kroah.org>
Content-Disposition: inline; filename=clone-fix-race-between-copy_process-and-de_thread.patch
In-Reply-To: <20090904201112.GA8274@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Oleg Nesterov <oleg@redhat.com>

commit 4ab6c08336535f8c8e42cf45d7adeda882eff06e upstream.

Spotted by Hiroshi Shimamoto who also provided the test-case below.

copy_process() uses signal->count as a reference counter, but it is not.
This test case

	#include <sys/types.h>
	#include <sys/wait.h>
	#include <unistd.h>
	#include <stdio.h>
	#include <errno.h>
	#include <pthread.h>

	void *null_thread(void *p)
	{
		for (;;)
			sleep(1);

		return NULL;
	}

	void *exec_thread(void *p)
	{
		execl("/bin/true", "/bin/true", NULL);

		return null_thread(p);
	}

	int main(int argc, char **argv)
	{
		for (;;) {
			pid_t pid;
			int ret, status;

			pid = fork();
			if (pid < 0)
				break;

			if (!pid) {
				pthread_t tid;

				pthread_create(&tid, NULL, exec_thread, NULL);
				for (;;)
					pthread_create(&tid, NULL, null_thread, NULL);
			}

			do {
				ret = waitpid(pid, &status, 0);
			} while (ret == -1 && errno == EINTR);
		}

		return 0;
	}

quickly creates an unkillable task.

If copy_process(CLONE_THREAD) races with de_thread()
copy_signal()->atomic(signal->count) breaks the signal->notify_count
logic, and the execing thread can hang forever in kernel space.

Change copy_process() to increment count/live only when we know for sure
we can't fail.  In this case the forked thread will take care of its
reference to signal correctly.

If copy_process() fails, check CLONE_THREAD flag.  If it it set - do
nothing, the counters were not changed and current belongs to the same
thread group.  If it is not set, ->signal must be released in any case
(and ->count must be == 1), the forked child is the only thread in the
thread group.

We need more cleanups here, in particular signal->count should not be used
by de_thread/__exit_signal at all.  This patch only fixes the bug.

Reported-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Tested-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/fork.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -767,11 +767,9 @@ static int copy_signal(unsigned long clo
 	struct signal_struct *sig;
 	int ret;
 
-	if (clone_flags & CLONE_THREAD) {
-		atomic_inc(&current->signal->count);
-		atomic_inc(&current->signal->live);
+	if (clone_flags & CLONE_THREAD)
 		return 0;
-	}
+
 	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
 	tsk->signal = sig;
 	if (!sig)
@@ -844,16 +842,6 @@ void __cleanup_signal(struct signal_stru
 	kmem_cache_free(signal_cachep, sig);
 }
 
-static void cleanup_signal(struct task_struct *tsk)
-{
-	struct signal_struct *sig = tsk->signal;
-
-	atomic_dec(&sig->live);
-
-	if (atomic_dec_and_test(&sig->count))
-		__cleanup_signal(sig);
-}
-
 static void copy_flags(unsigned long clone_flags, struct task_struct *p)
 {
 	unsigned long new_flags = p->flags;
@@ -1201,6 +1189,8 @@ static struct task_struct *copy_process(
 	}
 
 	if (clone_flags & CLONE_THREAD) {
+		atomic_inc(&current->signal->count);
+		atomic_inc(&current->signal->live);
 		p->group_leader = current->group_leader;
 		list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
 
@@ -1261,7 +1251,8 @@ bad_fork_cleanup_mm:
 	if (p->mm)
 		mmput(p->mm);
 bad_fork_cleanup_signal:
-	cleanup_signal(p);
+	if (!(clone_flags & CLONE_THREAD))
+		__cleanup_signal(p->signal);
 bad_fork_cleanup_sighand:
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:


