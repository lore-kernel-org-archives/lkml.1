Return-Path: <linux-kernel-owner+w=401wt.eu-S1761219AbYD2RZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761219AbYD2RZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758199AbYD2RUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:20:48 -0400
Received: from mx1.suse.de ([195.135.220.2]:51965 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758187AbYD2RUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:20:47 -0400
Date: Tue, 29 Apr 2008 10:18:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>
Subject: [13/37] cgroup: fix a race condition in manipulating tsk->cg_list
Message-ID: <20080429171826.GN14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cgroup-fix-a-race-condition-in-manipulating-tsk-cg_list.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Li Zefan <lizf@cn.fujitsu.com>

commit: 0e04388f0189fa1f6812a8e1cb6172136eada87e

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
Acked-by: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cgroup.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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

-- 
