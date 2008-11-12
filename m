Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbYKLEax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbYKLEax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 23:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbYKLEan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 23:30:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58084 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbYKLEan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 23:30:43 -0500
Date: Wed, 12 Nov 2008 13:30:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH] [BUGFIX]cgroup: fix potential deadlock in pre_destroy.
Message-Id: <20081112133002.15c929c3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir, Paul, Li, How about this ?
=
As Balbir pointed out, memcg's pre_destroy handler has potential deadlock.

It has following lock sequence.

	cgroup_mutex (cgroup_rmdir)
	    -> pre_destroy
		-> mem_cgroup_pre_destroy
			-> force_empty
			   -> lru_add_drain_all->
			      -> schedule_work_on_all_cpus
                                 -> get_online_cpus -> cpuhotplug.lock.

But, cpuset has following.
	cpu_hotplug.lock (call notifier)
		-> cgroup_mutex. (within notifier)

Then, this lock sequence should be fixed.

Considering how pre_destroy works, it's not necessary to holding
cgroup_mutex() while calling it. 

As side effect, we don't have to wait at this mutex while memcg's force_empty
works.(it can be long when there are tons of pages.)

Note: memcg is an only user of pre_destroy, now.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 kernel/cgroup.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: mmotm-2.6.28-Nov10/kernel/cgroup.c
===================================================================
--- mmotm-2.6.28-Nov10.orig/kernel/cgroup.c
+++ mmotm-2.6.28-Nov10/kernel/cgroup.c
@@ -2475,10 +2475,7 @@ static int cgroup_rmdir(struct inode *un
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}
-
-	parent = cgrp->parent;
-	root = cgrp->root;
-	sb = root->sb;
+	mutex_unlock(&cgroup_mutex);
 
 	/*
 	 * Call pre_destroy handlers of subsys. Notify subsystems
@@ -2486,7 +2483,14 @@ static int cgroup_rmdir(struct inode *un
 	 */
 	cgroup_call_pre_destroy(cgrp);
 
-	if (cgroup_has_css_refs(cgrp)) {
+	mutex_lock(&cgroup_mutex);
+	parent = cgrp->parent;
+	root = cgrp->root;
+	sb = root->sb;
+
+	if (atomic_read(&cgrp->count)
+	    || list_empty(&cgrp->children)
+	    || cgroup_has_css_refs(cgrp)) {
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}

