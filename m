Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbYJ3H0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbYJ3H0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 03:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbYJ3H0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 03:26:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51264 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbYJ3H0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:26:30 -0400
Message-ID: <490960EF.7020500@cn.fujitsu.com>
Date: Thu, 30 Oct 2008 15:23:27 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroup: fix invalid cgrp->dentry before cgroup has been completely
 removed
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes oops when reading /proc/sched_debug.

A cgroup won't be removed completely until finishing cgroup_diput(), so we
shouldn't invalidate cgrp->dentry in cgroup_rmdir(). Otherwise, when a
group is being removed while cgroup_path() gets called, we may trigger NULL
dereference BUG.

The bug can be reproduced:

 # cat test.sh
 #!/bin/sh
 mount -t cgroup -o cpu xxx /mnt
 for (( ; ; ))
 {
	mkdir /mnt/sub
	rmdir /mnt/sub
 }
 # ./test.sh &
 # cat /proc/sched_debug

BUG: unable to handle kernel NULL pointer dereference at 00000038
IP: [<c045a47f>] cgroup_path+0x39/0x90
...
Call Trace:
 [<c0420344>] ? print_cfs_rq+0x6e/0x75d
 [<c0421160>] ? sched_debug_show+0x72d/0xc1e
...

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 35eebd5..358e775 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2497,7 +2497,6 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
 	list_del(&cgrp->sibling);
 	spin_lock(&cgrp->dentry->d_lock);
 	d = dget(cgrp->dentry);
-	cgrp->dentry = NULL;
 	spin_unlock(&d->d_lock);
 
 	cgroup_d_remove_dir(d);
-- 
1.5.4.rc3

