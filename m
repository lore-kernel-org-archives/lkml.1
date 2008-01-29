Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbYA2Nwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbYA2Nwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932825AbYA2Nwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:52:32 -0500
Received: from sacred.ru ([62.205.161.221]:51936 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418AbYA2Nwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:52:31 -0500
Message-ID: <479F2F99.5080509@openvz.org>
Date: Tue, 29 Jan 2008 16:52:25 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Paul Menage <menage@google.com>
Subject: [PATCH 5/12] Handle pid namespaces in cgroups code
References: <479F2C5C.1050303@openvz.org>
In-Reply-To: <479F2C5C.1050303@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 29 Jan 2008 16:52:04 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's one place that works with task pids - its the "tasks" file
in cgroups. The read/write handlers assume, that the pid values 
go to/come from the user space and thus it is a virtual pid, i.e. 
the pid as it is seen from inside a namespace.

Tune the code accordingly.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 kernel/cgroup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2c5cccb..4766bb6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1269,7 +1269,7 @@ static int attach_task_by_pid(struct cgroup *cgrp, char *pidbuf)
 
 	if (pid) {
 		rcu_read_lock();
-		tsk = find_task_by_pid(pid);
+		tsk = find_task_by_vpid(pid);
 		if (!tsk || tsk->flags & PF_EXITING) {
 			rcu_read_unlock();
 			return -ESRCH;
@@ -1955,7 +1955,7 @@ static int pid_array_load(pid_t *pidarray, int npids, struct cgroup *cgrp)
 	while ((tsk = cgroup_iter_next(cgrp, &it))) {
 		if (unlikely(n == npids))
 			break;
-		pidarray[n++] = task_pid_nr(tsk);
+		pidarray[n++] = task_pid_vnr(tsk);
 	}
 	cgroup_iter_end(cgrp, &it);
 	return n;
-- 
1.5.3.4

