Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbYKYJeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbYKYJeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 04:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYKYJeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 04:34:16 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33781 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbYKYJeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 04:34:15 -0500
Date: Tue, 25 Nov 2008 18:33:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "xemul@openvz.org" <xemul@openvz.org>
Subject: [BUGFIX][PATCH] memcg: force_emtpy fix to confirm cgroup has no
 tasks.
Message-Id: <20081125183326.21f2067d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fix to memcg-new-force_empty-to-free-pages-under-group.patch

Thanks,
-Kame
==
Now, force_empty can be called and do reclaim pages
while there are tasks. fix it.
(reclaim occurs but move doesn't occur in this case.)

And, we have interface to count # of tasks under cgroup.
Using it is better.

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
 mm/memcontrol.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: mmotm-2.6.28-Nov24/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Nov24.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Nov24/mm/memcontrol.c
@@ -1481,6 +1481,7 @@ static int mem_cgroup_force_empty(struct
 	int ret;
 	int node, zid, shrink;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	struct cgroup *cgrp = mem->css.cgroup;
 
 	css_get(&mem->css);
 
@@ -1491,7 +1492,7 @@ static int mem_cgroup_force_empty(struct
 move_account:
 	while (mem->res.usage > 0) {
 		ret = -EBUSY;
-		if (atomic_read(&mem->css.cgroup->count) > 0)
+		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
 			goto out;
 		ret = -EINTR;
 		if (signal_pending(current))
@@ -1523,8 +1524,10 @@ out:
 	return ret;
 
 try_to_free:
-	/* returns EBUSY if we come here twice. */
-	if (shrink) {
+	/* returns EBUSY if there is a task or if we come here twice. */
+	if (cgroup_task_count(cgrp)
+	    || !list_empty(&cgrp->children)
+	    || shrink) {
 		ret = -EBUSY;
 		goto out;
 	}

