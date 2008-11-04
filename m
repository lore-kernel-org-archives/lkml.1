Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbYKDHiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbYKDHiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 02:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbYKDHiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 02:38:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52889 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbYKDHiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 02:38:46 -0500
Message-ID: <490FFB56.7030300@cn.fujitsu.com>
Date: Tue, 04 Nov 2008 15:35:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>
CC: Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [RFC][PATCH] freezer_cg: disable writing freezer.state of root cgroup
References: <20080811235323.872291138@us.ibm.com>	 <20080811235325.121356317@us.ibm.com>	 <6599ad830811032143h51eae533k5b0c17e65a7fa675@mail.gmail.com>	 <490FE7B5.8020400@cn.fujitsu.com> <6599ad830811032240n640f3fao48f1a9f05892b797@mail.gmail.com>
In-Reply-To: <6599ad830811032240n640f3fao48f1a9f05892b797@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change, the root cgroup is unfreezable, and writing to
its freezer.state returns -EIO.

I think it's reasonable to disallow freezing all the tasks in the
root cgroup. And this avoids fork overhead when freezer subsystem
is compiled but not used.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/cgroups/freezer-subsystem.txt |   18 ++++++++++--------
 kernel/cgroup_freezer.c                     |    7 +++++++
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/Documentation/cgroups/freezer-subsystem.txt b/Documentation/cgroups/freezer-subsystem.txt
index c50ab58..e842bad 100644
--- a/Documentation/cgroups/freezer-subsystem.txt
+++ b/Documentation/cgroups/freezer-subsystem.txt
@@ -1,4 +1,4 @@
-	The cgroup freezer is useful to batch job management system which start
+The cgroup freezer is useful to batch job management system which start
 and stop sets of tasks in order to schedule the resources of a machine
 according to the desires of a system administrator. This sort of program
 is often used on HPC clusters to schedule access to the cluster as a
@@ -6,7 +6,7 @@ whole. The cgroup freezer uses cgroups to describe the set of tasks to
 be started/stopped by the batch job management system. It also provides
 a means to start and stop the tasks composing the job.
 
-	The cgroup freezer will also be useful for checkpointing running groups
+The cgroup freezer will also be useful for checkpointing running groups
 of tasks. The freezer allows the checkpoint code to obtain a consistent
 image of the tasks by attempting to force the tasks in a cgroup into a
 quiescent state. Once the tasks are quiescent another task can
@@ -16,7 +16,7 @@ recoverable error occur. This also allows the checkpointed tasks to be
 migrated between nodes in a cluster by copying the gathered information
 to another node and restarting the tasks there.
 
-	Sequences of SIGSTOP and SIGCONT are not always sufficient for stopping
+Sequences of SIGSTOP and SIGCONT are not always sufficient for stopping
 and resuming tasks in userspace. Both of these signals are observable
 from within the tasks we wish to freeze. While SIGSTOP cannot be caught,
 blocked, or ignored it can be seen by waiting or ptracing parent tasks.
@@ -37,26 +37,28 @@ demonstrate this problem using nested bash shells:
 
 	<at this point 16990 exits and causes 16644 to exit too>
 
-	This happens because bash can observe both signals and choose how it
+This happens because bash can observe both signals and choose how it
 responds to them.
 
-	Another example of a program which catches and responds to these
+Another example of a program which catches and responds to these
 signals is gdb. In fact any program designed to use ptrace is likely to
 have a problem with this method of stopping and resuming tasks.
 
-	 In contrast, the cgroup freezer uses the kernel freezer code to
+In contrast, the cgroup freezer uses the kernel freezer code to
 prevent the freeze/unfreeze cycle from becoming visible to the tasks
 being frozen. This allows the bash example above and gdb to run as
 expected.
 
-	The freezer subsystem in the container filesystem defines a file named
+The freezer subsystem in the container filesystem defines a file named
 freezer.state. Writing "FROZEN" to the state file will freeze all tasks in the
 cgroup. Subsequently writing "THAWED" will unfreeze the tasks in the cgroup.
 Reading will return the current state.
 
+Note it's not allowed to freeze the root cgroup.
+
 * Examples of usage :
 
-   # mkdir /containers/freezer
+   # mkdir /containers/
    # mount -t cgroup -ofreezer freezer  /containers
    # mkdir /containers/0
    # echo $some_pid > /containers/0/tasks
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 6605907..6b5c45d 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -192,6 +192,9 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	 */
 	freezer = task_freezer(task);
 
+	if (!freezer->css.cgroup->parent)
+		return;
+
 	spin_lock_irq(&freezer->lock);
 	BUG_ON(freezer->state == CGROUP_FROZEN);
 
@@ -330,6 +333,10 @@ static int freezer_write(struct cgroup *cgroup,
 	int retval;
 	enum freezer_state goal_state;
 
+	/* It's not allowed to freeze the root cgroup */
+	if (!cgroup->parent)
+		return -EIO;
+
 	if (strcmp(buffer, freezer_state_strs[CGROUP_THAWED]) == 0)
 		goal_state = CGROUP_THAWED;
 	else if (strcmp(buffer, freezer_state_strs[CGROUP_FROZEN]) == 0)
-- 
1.5.4.rc3
