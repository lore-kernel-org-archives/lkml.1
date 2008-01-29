Return-Path: <linux-kernel-owner+w=401wt.eu-S933140AbYA2Nqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140AbYA2Nqw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932692AbYA2Nq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:46:26 -0500
Received: from sacred.ru ([62.205.161.221]:52690 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932571AbYA2NqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:46:16 -0500
Message-ID: <479F2E27.5010300@openvz.org>
Date: Tue, 29 Jan 2008 16:46:15 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [PATCH 3/12] Use find_task_by_vpid in taskstats
References: <479F2C5C.1050303@openvz.org>
In-Reply-To: <479F2C5C.1050303@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 29 Jan 2008 16:45:54 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pid to lookup a task by is passed inside taskstats code
via genetlink message.

Since netlink packets are now processed in the context of the
sending task, this is correct to lookup the task with 
find_task_by_vpid() here.

Besides, I fix the call to fill_pid() from taskstats_exit(),
since the tsk->pid is not required in fill_pid() in this case,
and the pid field on task_struct is going to be deprecated
as well.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 kernel/taskstats.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 07e86a8..4a23517 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -183,7 +183,7 @@ static int fill_pid(pid_t pid, struct task_struct *tsk,
 
 	if (!tsk) {
 		rcu_read_lock();
-		tsk = find_task_by_pid(pid);
+		tsk = find_task_by_vpid(pid);
 		if (tsk)
 			get_task_struct(tsk);
 		rcu_read_unlock();
@@ -230,7 +230,7 @@ static int fill_tgid(pid_t tgid, struct task_struct *first,
 	 */
 	rcu_read_lock();
 	if (!first)
-		first = find_task_by_pid(tgid);
+		first = find_task_by_vpid(tgid);
 
 	if (!first || !lock_task_sighand(first, &flags))
 		goto out;
@@ -547,7 +547,7 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
 	if (!stats)
 		goto err;
 
-	rc = fill_pid(tsk->pid, tsk, stats);
+	rc = fill_pid(-1, tsk, stats);
 	if (rc < 0)
 		goto err;
 
-- 
1.5.3.4

