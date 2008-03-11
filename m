Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbYCKKUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbYCKKUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 06:20:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752445AbYCKKT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 06:19:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42960 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYCKKT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 06:19:58 -0400
Message-ID: <47D65A36.4020008@cn.fujitsu.com>
Date: Tue, 11 Mar 2008 19:08:54 +0900
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH 2/3] memcg: put a restriction on writing memory.force_empty
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can write whatever to memory.force_empty:

        echo 999 > memory.force_empty
        echo wow > memory.force_empty

This is odd, so let's make '1' to be the only valid value.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 mm/memcontrol.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index eb681a6..6145031 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -868,15 +868,18 @@ static ssize_t mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
 				mem_cgroup_write_strategy);
 }
 
-static ssize_t mem_force_empty_write(struct cgroup *cont,
-				struct cftype *cft, struct file *file,
-				const char __user *userbuf,
-				size_t nbytes, loff_t *ppos)
+static int mem_force_empty_write(struct cgroup *cont, struct cftype *cft,
+				 u64 val)
 {
-	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	int ret = mem_cgroup_force_empty(mem);
-	if (!ret)
-		ret = nbytes;
+	struct mem_cgroup *mem;
+	int ret;
+
+	if (val != 1)
+		return -EINVAL;
+
+	mem = mem_cgroup_from_cont(cont);
+	ret = mem_cgroup_force_empty(mem);
+
 	return ret;
 }
 
@@ -935,7 +938,7 @@ static struct cftype mem_cgroup_files[] = {
 	},
 	{
 		.name = "force_empty",
-		.write = mem_force_empty_write,
+		.write_u64 = mem_force_empty_write,
 	},
 	{
 		.name = "stat",
-- 
1.5.4.rc3
