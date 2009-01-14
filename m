Return-Path: <linux-kernel-owner+w=401wt.eu-S1760687AbZANIL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760687AbZANIL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 03:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758872AbZANILk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 03:11:40 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49896 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758367AbZANILj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 03:11:39 -0500
Message-ID: <496D9E0C.4060806@cn.fujitsu.com>
Date: Wed, 14 Jan 2009 16:10:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] memcg: fix return value of mem_cgroup_hierarchy_write()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there are sub-dirs, writing to memory.use_hierarchy returns -EBUSY,
this doesn't seem to fit the meaning of EBUSY, and is inconsistent with
memory.swappiness, which returns -EINVAL in this case.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 mm/memcontrol.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bc8f101..2497f7d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1760,6 +1760,9 @@ static int mem_cgroup_hierarchy_write(struct cgroup *cont, struct cftype *cft,
 	struct cgroup *parent = cont->parent;
 	struct mem_cgroup *parent_mem = NULL;
 
+	if (val != 0 && val != 1)
+		return -EINVAL;
+
 	if (parent)
 		parent_mem = mem_cgroup_from_cont(parent);
 
@@ -1773,12 +1776,9 @@ static int mem_cgroup_hierarchy_write(struct cgroup *cont, struct cftype *cft,
 	 * set if there are no children.
 	 */
 	if ((!parent_mem || !parent_mem->use_hierarchy) &&
-				(val == 1 || val == 0)) {
-		if (list_empty(&cont->children))
+	    list_empty(&cont->children))
 			mem->use_hierarchy = val;
-		else
-			retval = -EBUSY;
-	} else
+	else
 		retval = -EINVAL;
 	cgroup_unlock();
 
-- 
1.5.4.rc3
