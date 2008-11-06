Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbYKFBVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbYKFBVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 20:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYKFBVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 20:21:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53752 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753095AbYKFBVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 20:21:32 -0500
Message-ID: <491245F1.5070707@cn.fujitsu.com>
Date: Thu, 06 Nov 2008 09:18:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Matt Helsley <matthltc@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH -v2] freezer_cg: disable writing freezer.state of root cgroup
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change, control file 'freezer.state' doesn't exist in root
cgroup, making root cgroup unfreezable.

I think it's reasonable to disallow freeze tasks in the root cgroup.
And then we can avoid fork overhead when freezer subsystem is
compiled but not used.

Also make writing invalid value to freezer.state returns EINVAL
rather than EIO. This is more consistent with other cgroup subsystem.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

patch is based on freezer_cg-remove-task_lock-from-freezer_fork.patch

---
 Documentation/cgroups/freezer-subsystem.txt |    3 +++
 kernel/cgroup_freezer.c                     |   11 ++++++++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/freezer-subsystem.txt b/Documentation/cgroups/freezer-subsystem.txt
index c50ab58..91572b9 100644
--- a/Documentation/cgroups/freezer-subsystem.txt
+++ b/Documentation/cgroups/freezer-subsystem.txt
@@ -54,6 +54,9 @@ freezer.state. Writing "FROZEN" to the state file will freeze all tasks in the
 cgroup. Subsequently writing "THAWED" will unfreeze the tasks in the cgroup.
 Reading will return the current state.
 
+Note freezer.state doesn't exist in root cgroup, which means root cgroup
+is unfreezable.
+
 * Examples of usage :
 
    # mkdir /containers/freezer
diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 6605907..cf3fce9 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -192,6 +192,13 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 	 */
 	freezer = task_freezer(task);
 
+	/*
+	 * The root cgroup is unfreezable, so we can skip the
+	 * following check.
+	 */
+	if (!freezer->css.cgroup->parent)
+		return;
+
 	spin_lock_irq(&freezer->lock);
 	BUG_ON(freezer->state == CGROUP_FROZEN);
 
@@ -335,7 +342,7 @@ static int freezer_write(struct cgroup *cgroup,
 	else if (strcmp(buffer, freezer_state_strs[CGROUP_FROZEN]) == 0)
 		goal_state = CGROUP_FROZEN;
 	else
-		return -EIO;
+		return -EINVAL;
 
 	if (!cgroup_lock_live_group(cgroup))
 		return -ENODEV;
@@ -354,6 +361,8 @@ static struct cftype files[] = {
 
 static int freezer_populate(struct cgroup_subsys *ss, struct cgroup *cgroup)
 {
+	if (!cgroup->parent)
+		return 0;
 	return cgroup_add_files(cgroup, ss, files, ARRAY_SIZE(files));
 }
 
-- 
1.5.4.rc3

