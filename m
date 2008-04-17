Return-Path: <linux-kernel-owner+w=401wt.eu-S1756734AbYDQDij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734AbYDQDij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 23:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYDQDib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 23:38:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60298 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbYDQDia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 23:38:30 -0400
Message-ID: <4806C5EB.3040102@cn.fujitsu.com>
Date: Thu, 17 Apr 2008 11:37:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Jackson <pj@sgi.com>
Subject: [PATCH] cgroup: fix a race condition in manipulating tsk->cg_list
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I ran a test program to fork mass processes and at the same time
'cat /cgroup/tasks', I got the following oops:

------------[ cut here ]------------
kernel BUG at lib/list_debug.c:72!
invalid opcode: 0000 [#1] SMP
Pid: 4178, comm: a.out Not tainted (2.6.25-rc9 #72)
...
Call Trace:
 [<c044a5f9>] ? cgroup_exit+0x55/0x94
 [<c0427acf>] ? do_exit+0x217/0x5ba
 [<c0427ed7>] ? do_group_exit+0.65/0x7c
 [<c0427efd>] ? sys_exit_group+0xf/0x11
 [<c0404842>] ? syscall_call+0x7/0xb
 [<c05e0000>] ? init_cyrix+0x2fa/0x479
...
EIP: [<c04df671>] list_del+0x35/0x53 SS:ESP 0068:ebc7df4
---[ end trace caffb7332252612b ]---
Fixing recursive fault but reboot is needed!

After digging into the code and debugging, I finlly found out a race
situation:
				do_exit()
				  ->cgroup_exit()
				    ->if (!list_empty(&tsk->cg_list))
				        list_del(&tsk->cg_list);

cgroup_iter_start()
  ->cgroup_enable_task_cg_list()
    ->list_add(&tsk->cg_list, ..);

In this case the list won't be deleted though the process has exited.

We got two bug reports in the past, which seem to be the same bug as
this one:
	http://lkml.org/lkml/2008/3/5/332
	http://lkml.org/lkml/2007/10/17/224

Actually sometimes I got oops on list_del, sometimes oops on list_add.
And I can change my test program a bit to trigger other oops.

The patch has been tested both on x86_32 and x86_64.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2727f92..6d8de05 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1722,7 +1722,12 @@ void cgroup_enable_task_cg_lists(void)
 	use_task_css_set_links = 1;
 	do_each_thread(g, p) {
 		task_lock(p);
-		if (list_empty(&p->cg_list))
+		/*
+		 * We should check if the process is exiting, otherwise
+		 * it will race with cgroup_exit() in that the list
+		 * entry won't be deleted though the process has exited.
+		 */
+		if (!(p->flags & PF_EXITING) && list_empty(&p->cg_list))
 			list_add(&p->cg_list, &p->cgroups->tasks);
 		task_unlock(p);
 	} while_each_thread(g, p);
-- 1.5.4.rc3


