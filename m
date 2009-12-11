Return-Path: <linux-kernel-owner+w=401wt.eu-S1761558AbZLKW77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761558AbZLKW77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:59:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761384AbZLKW7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:59:36 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:37122 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758396AbZLKW72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:59:28 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: containers@lists.linux-foundation.org, linux-mm@kvack.org
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH RFC v2 2/4] memcg: extract mem_group_usage() from mem_cgroup_read()
Date: Sat, 12 Dec 2009 00:59:17 +0200
Message-Id: <c1847dfb5c4fed1374b7add236d38e0db02eeef3.1260571675.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
References: <cover.1260571675.git.kirill@shutemov.name>
 <ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
In-Reply-To: <cover.1260571675.git.kirill@shutemov.name>
References: <cover.1260571675.git.kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helper to get memory or mem+swap usage of the cgroup.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 mm/memcontrol.c |   53 ++++++++++++++++++++++++++++++++---------------------
 1 files changed, 32 insertions(+), 21 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c31a310..0ff65ed 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2510,39 +2510,50 @@ mem_cgroup_get_recursive_idx_stat(struct mem_cgroup *mem,
 	*val = d.val;
 }
 
+static inline u64 mem_cgroup_usage(struct mem_cgroup *mem, bool swap)
+{
+	u64 idx_val, val;
+
+	if (!mem_cgroup_is_root(mem)) {
+		if (!swap)
+			return res_counter_read_u64(&mem->res, RES_USAGE);
+		else
+			return res_counter_read_u64(&mem->memsw, RES_USAGE);
+	}
+
+	mem_cgroup_get_recursive_idx_stat(mem, MEM_CGROUP_STAT_CACHE, &idx_val);
+	val = idx_val;
+	mem_cgroup_get_recursive_idx_stat(mem, MEM_CGROUP_STAT_RSS, &idx_val);
+	val += idx_val;
+
+	if (swap) {
+		mem_cgroup_get_recursive_idx_stat(mem,
+				MEM_CGROUP_STAT_SWAPOUT, &idx_val);
+		val += idx_val;
+	}
+
+	return val << PAGE_SHIFT;
+}
+
 static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	u64 idx_val, val;
+	u64 val;
 	int type, name;
 
 	type = MEMFILE_TYPE(cft->private);
 	name = MEMFILE_ATTR(cft->private);
 	switch (type) {
 	case _MEM:
-		if (name == RES_USAGE && mem_cgroup_is_root(mem)) {
-			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_CACHE, &idx_val);
-			val = idx_val;
-			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_RSS, &idx_val);
-			val += idx_val;
-			val <<= PAGE_SHIFT;
-		} else
+		if (name == RES_USAGE)
+			val = mem_cgroup_usage(mem, false);
+		else
 			val = res_counter_read_u64(&mem->res, name);
 		break;
 	case _MEMSWAP:
-		if (name == RES_USAGE && mem_cgroup_is_root(mem)) {
-			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_CACHE, &idx_val);
-			val = idx_val;
-			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_RSS, &idx_val);
-			val += idx_val;
-			mem_cgroup_get_recursive_idx_stat(mem,
-				MEM_CGROUP_STAT_SWAPOUT, &idx_val);
-			val <<= PAGE_SHIFT;
-		} else
+		if (name == RES_USAGE)
+			val = mem_cgroup_usage(mem, true);
+		else
 			val = res_counter_read_u64(&mem->memsw, name);
 		break;
 	default:
-- 
1.6.5.3

