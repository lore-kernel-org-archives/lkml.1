Return-Path: <linux-kernel-owner+w=401wt.eu-S1752825AbZHXQcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbZHXQcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbZHXQcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:32:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbZHXQcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:32:07 -0400
Date: Mon, 24 Aug 2009 18:27:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, stable@kernel.org
Subject: [PATCH v3] fix race copy_process() vs de_thread()
Message-ID: <20090824162730.GA14367@redhat.com>
References: <4A9210A4.4010108@ct.jp.nec.com> <20090824061420.341A9414DF@magilla.sf.frob.com> <4A923403.6010201@ct.jp.nec.com> <20090824083826.GA475@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824083826.GA475@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spotted by Hiroshi Shimamoto who also provided the test-case below.

copy_process() pathes use signal->count as a reference counter, but
it is not. This test case

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

quickly creates the unkillable task.

If copy_process(CLONE_THREAD) races with de_thread()
copy_signal()->atomic(signal->count) breaks the signal->notify_count
logic, and the execing thread can hang forever in kernel space.

Change copy_process() to increment count/live only when we know for
sure we can't fail. In this case the forked thread will take care
of its reference to signal correctly.

If copy_process() fails, check CLONE_THREAD flag. If it it set - do
nothing, the counters were not changed and current belongs to the same
thread group. If it is not set, ->signal must be released in any case
(and ->count must be == 1), the forked child is the only thread in the
thread group.

We need more cleanups here, in particular signal->count should not be
used by de_thread/__exit_signal at all. This patch only fixes the bug.

Reported-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/fork.c |   20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

--- PU/kernel/fork.c~FORK_SIG_CNT	2009-08-04 19:48:28.000000000 +0200
+++ PU/kernel/fork.c	2009-08-24 17:39:59.000000000 +0200
@@ -816,11 +816,8 @@ static int copy_signal(unsigned long clo
 {
 	struct signal_struct *sig;
 
-	if (clone_flags & CLONE_THREAD) {
-		atomic_inc(&current->signal->count);
-		atomic_inc(&current->signal->live);
+	if (clone_flags & CLONE_THREAD)
 		return 0;
-	}
 
 	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
 	tsk->signal = sig;
@@ -878,16 +875,6 @@ void __cleanup_signal(struct signal_stru
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
@@ -1240,6 +1227,8 @@ static struct task_struct *copy_process(
 	}
 
 	if (clone_flags & CLONE_THREAD) {
+		atomic_inc(&current->signal->count);
+		atomic_inc(&current->signal->live);
 		p->group_leader = current->group_leader;
 		list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
 	}
@@ -1282,7 +1271,8 @@ bad_fork_cleanup_mm:
 	if (p->mm)
 		mmput(p->mm);
 bad_fork_cleanup_signal:
-	cleanup_signal(p);
+	if (!(clone_flags & CLONE_THREAD))
+		__cleanup_signal(p->signal);
 bad_fork_cleanup_sighand:
 	__cleanup_sighand(p->sighand);
 bad_fork_cleanup_fs:

