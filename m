Return-Path: <linux-kernel-owner+w=401wt.eu-S1752147AbYLYDs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbYLYDs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 22:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbYLYDsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 22:48:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49385 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751481AbYLYDsV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 22:48:21 -0500
Message-ID: <4953023D.4010401@cn.fujitsu.com>
Date: Thu, 25 Dec 2008 11:47:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: fix a race between cgroup_clone and umount
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The race is calling cgroup_clone() while umounting the ns cgroup subsys,
and thus cgroup_clone() might access invalid cgroup_fs, or kill_sb() is
called after cgroup_clone() created a new dir in it.

The BUG I triggered is BUG_ON(root->number_of_cgroups != 1);

------------[ cut here ]------------
kernel BUG at kernel/cgroup.c:1093!
invalid opcode: 0000 [#1] SMP
...
Process umount (pid: 5177, ti=e411e000 task=e40c4670 task.ti=e411e000)
...
Call Trace:
 [<c0493df7>] ? deactivate_super+0x3f/0x51
 [<c04a3600>] ? mntput_no_expire+0xb3/0xdd
 [<c04a3ab2>] ? sys_umount+0x265/0x2ac
 [<c04a3b06>] ? sys_oldumount+0xd/0xf
 [<c0403911>] ? sysenter_do_call+0x12/0x31
...
EIP: [<c0456e76>] cgroup_kill_sb+0x23/0xe0 SS:ESP 0068:e411ef2c
---[ end trace c766c1be3bf944ac ]---

CC: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

affected kernel: 2.6.24 to 2.6.28

---
 kernel/cgroup.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2606d0f..c882385 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2942,7 +2942,11 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
 	parent = task_cgroup(tsk, subsys->subsys_id);
 
 	/* Pin the hierarchy */
-	atomic_inc(&parent->root->sb->s_active);
+	if (!atomic_inc_not_zero(&parent->root->sb->s_active)) {
+		/* We race with the final deactivate_super() */
+		mutex_unlock(&cgroup_mutex);
+		return 0;
+	}
 
 	/* Keep the cgroup alive */
 	get_css_set(cg);
-- 
1.5.4.rc3
