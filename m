Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbZDIEjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbZDIEjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759775AbZDIEiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:38:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:57138 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759979AbZDIEiv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:38:51 -0400
Date: Thu, 9 Apr 2009 04:37:25 GMT
From: Nathan Lynch <ntl@pobox.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       matthltc@us.ibm.com, nigel@tuxonice.net, akpm@linux-foundation.org,
       tglx@linutronix.de, ntl@pobox.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       matthltc@us.ibm.com, nigel@tuxonice.net, akpm@linux-foundation.org,
       tglx@linutronix.de, ntl@pobox.com, mingo@elte.hu
In-Reply-To: <20090408194512.47a99b95@manatee.lan>
References: <20090408194512.47a99b95@manatee.lan>
Subject: [tip:sched/urgent] sched: do not count frozen tasks toward load
Message-ID: <tip-34f2beeec5591259c43d195122de3cd26262d63b@git.kernel.org>
Git-Commit-ID: 34f2beeec5591259c43d195122de3cd26262d63b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 09 Apr 2009 04:37:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34f2beeec5591259c43d195122de3cd26262d63b
Gitweb:     http://git.kernel.org/tip/34f2beeec5591259c43d195122de3cd26262d63b
Author:     Nathan Lynch <ntl@pobox.com>
AuthorDate: Wed, 8 Apr 2009 19:45:12 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 9 Apr 2009 06:09:49 +0200

sched: do not count frozen tasks toward load

Freezing tasks via the cgroup freezer causes the load average to climb
because the freezer's current implementation puts frozen tasks in
uninterruptible sleep (D state).

Some applications which perform job-scheduling functions consult the
load average when making decisions.  If a cgroup is frozen, the load
average does not provide a useful measure of the system's utilization
to such applications.  This is especially inconvenient if the job
scheduler employs the cgroup freezer as a mechanism for preempting low
priority jobs.  Contrast this with using SIGSTOP for the same purpose:
the stopped tasks do not count toward system load.

Change task_contributes_to_load() to return false if the task is
frozen.  This results in /proc/loadavg behavior that better meets
users' expectations.

Signed-off-by: Nathan Lynch <ntl@pobox.com>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Nigel Cunningham <nigel@tuxonice.net>
Tested-by: Nigel Cunningham <nigel@tuxonice.net>
Cc: containers@lists.linux-foundation.org
Cc: linux-pm@lists.linux-foundation.org
Cc: Matt Helsley <matthltc@us.ibm.com>
LKML-Reference: <20090408194512.47a99b95@manatee.lan>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/sched.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 98e1fe5..b4c38bc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -205,7 +205,8 @@ extern unsigned long long time_sync_thresh;
 #define task_is_stopped_or_traced(task)	\
 			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 #define task_contributes_to_load(task)	\
-				((task->state & TASK_UNINTERRUPTIBLE) != 0)
+				((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
+				 (task->flags & PF_FROZEN) == 0)
 
 #define __set_task_state(tsk, state_value)		\
 	do { (tsk)->state = (state_value); } while (0)
