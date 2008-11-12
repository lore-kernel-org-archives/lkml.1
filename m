Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbYKLA2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbYKLA2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 19:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYKLA0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 19:26:09 -0500
Received: from kroah.org ([198.145.64.141]:42110 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750933AbYKLA0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 19:26:07 -0500
Date: Tue, 11 Nov 2008 16:23:05 -0800
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
       alan@lxorguk.ukuu.org.uk, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 07/49] cgroups: fix invalid cgrp->dentry before cgroup has
	been completely removed
Message-ID: <20081112002305.GH10989@kroah.com>
References: <20081112001401.926965113@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cgroups-fix-invalid-cgrp-dentry-before-cgroup-has-been-completely-removed.patch"
In-Reply-To: <20081112002215.GA10989@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Li Zefan <lizf@cn.fujitsu.com>

commit 24eb089950ce44603b30a3145a2c8520e2b55bb1 upstream

This fixes an oops when reading /proc/sched_debug.

A cgroup won't be removed completely until finishing cgroup_diput(), so we
shouldn't invalidate cgrp->dentry in cgroup_rmdir().  Otherwise, when a
group is being removed while cgroup_path() gets called, we may trigger
NULL dereference BUG.

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
..
Call Trace:
 [<c0420344>] ? print_cfs_rq+0x6e/0x75d
 [<c0421160>] ? sched_debug_show+0x72d/0xc1e
..

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/cgroup.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2443,7 +2443,6 @@ static int cgroup_rmdir(struct inode *un
 	list_del(&cgrp->sibling);
 	spin_lock(&cgrp->dentry->d_lock);
 	d = dget(cgrp->dentry);
-	cgrp->dentry = NULL;
 	spin_unlock(&d->d_lock);
 
 	cgroup_d_remove_dir(d);

-- 
