Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbZAOULx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbZAOULx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:11:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761218AbZAOUAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:42 -0500
Received: from kroah.org ([198.145.64.141]:48907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765710AbZAOUAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:32 -0500
Date: Thu, 15 Jan 2009 11:57:54 -0800
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
       alan@lxorguk.ukuu.org.uk, "Serge E. Hallyn" <serue@us.ibm.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: [patch 19/94] cgroups: fix a race between cgroup_clone and umount
Message-ID: <20090115195754.GS14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cgroups-fix-a-race-between-cgroup_clone-and-umount.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Li Zefan <lizf@cn.fujitsu.com>

commit 7b574b7b0124ed344911f5d581e9bc2d83bbeb19 upstream.

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

Cc: Serge E. Hallyn <serue@us.ibm.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cgroup.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2942,7 +2942,11 @@ int cgroup_clone(struct task_struct *tsk
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

