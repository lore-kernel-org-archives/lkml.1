Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbZGIRjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbZGIRjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754326AbZGIRjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:39:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48290 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbZGIRjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:39:12 -0400
Date: Thu, 9 Jul 2009 19:36:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dominic Duval <dduval@redhat.com>, Frank Hirtz <fhirtz@redhat.com>,
       "Fuller, Johnray" <Johnray.Fuller@gs.com>,
       "James M. Leddy" <jleddy@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>,
       Paul Batkowski <pbatkowski@redhat.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] proc_flush_task: flush /proc/tid/task/pid when a
	sub-thread exits
Message-ID: <20090709173614.GA29076@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The exiting sub-thread flushes /proc/pid only, but this doesn't buy
too much: ps and friends mostly use /proc/tid/task/pid.

Remove "if (thread_group_leader())" checks from proc_flush_task() path,
this means we always remove /proc/tid/task/pid dentry on exit, and this
actually matches the comment above proc_flush_task().

The test-case:

	static void* tfunc(void *arg)
	{
		char name[256];

		sprintf(name, "/proc/%d/task/%ld/status", getpid(), gettid());
		close(open(name, O_RDONLY));

		return NULL;
	}

	int main(void)
	{
		pthread_t t;

		for (;;) {
			if (!pthread_create(&t, NULL, &tfunc, NULL))
				pthread_join(t, NULL);
		}
	}

slabtop shows that pid/proc_inode_cache/etc grow quickly and "indefinitely"
until the task is killed or shrink_slab() is called, not good. And the main
thread needs a lot of time to exit.

The same can happen if something like "ps -efL" runs continuously, while
some application spawns short-living threads.

Reported-by: "James M. Leddy" <jleddy@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- WAIT/fs/proc/base.c~PROC_FLUSH_THREAD	2009-06-23 20:16:44.000000000 +0200
+++ WAIT/fs/proc/base.c	2009-07-09 17:56:27.000000000 +0200
@@ -2601,9 +2601,6 @@ static void proc_flush_task_mnt(struct v
 		dput(dentry);
 	}
 
-	if (tgid == 0)
-		goto out;
-
 	name.name = buf;
 	name.len = snprintf(buf, sizeof(buf), "%d", tgid);
 	leader = d_hash_and_lookup(mnt->mnt_root, &name);
@@ -2660,17 +2657,16 @@ out:
 void proc_flush_task(struct task_struct *task)
 {
 	int i;
-	struct pid *pid, *tgid = NULL;
+	struct pid *pid, *tgid;
 	struct upid *upid;
 
 	pid = task_pid(task);
-	if (thread_group_leader(task))
-		tgid = task_tgid(task);
+	tgid = task_tgid(task);
 
 	for (i = 0; i <= pid->level; i++) {
 		upid = &pid->numbers[i];
 		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
-			tgid ? tgid->numbers[i].nr : 0);
+					tgid->numbers[i].nr);
 	}
 
 	upid = &pid->numbers[pid->level];

