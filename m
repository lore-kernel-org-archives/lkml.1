Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbZLKW7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbZLKW7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761464AbZLKW7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:59:35 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40051 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761093AbZLKW7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:59:30 -0500
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
Subject: [PATCH RFC v2 3/4] memcg: rework usage of stats by soft limit
Date: Sat, 12 Dec 2009 00:59:18 +0200
Message-Id: <747ea0ec22b9348208c80f86f7a813728bf8e50a.1260571675.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <c1847dfb5c4fed1374b7add236d38e0db02eeef3.1260571675.git.kirill@shutemov.name>
References: <cover.1260571675.git.kirill@shutemov.name>
 <ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
 <c1847dfb5c4fed1374b7add236d38e0db02eeef3.1260571675.git.kirill@shutemov.name>
In-Reply-To: <cover.1260571675.git.kirill@shutemov.name>
References: <cover.1260571675.git.kirill@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of incrementing counter on each page in/out and comparing it
with constant, we set counter to constant, decrement counter on each
page in/out and compare it with zero. We want to make comparing as fast
as possible. On many RISC systems (probably not only RISC) comparing
with zero is more effective than comparing with a constant, since not
every constant can be immediate operand for compare instruction.

Also, I've renamed MEM_CGROUP_STAT_EVENTS to MEM_CGROUP_STAT_SOFTLIMIT,
since really it's not a generic counter.

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 mm/memcontrol.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0ff65ed..c6081cc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -69,8 +69,9 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_MAPPED_FILE,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
 	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
-	MEM_CGROUP_STAT_EVENTS,	/* sum of pagein + pageout for internal use */
 	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
+	MEM_CGROUP_STAT_SOFTLIMIT, /* decrements on each page in/out.
+					used by soft limit implementation */
 
 	MEM_CGROUP_STAT_NSTATS,
 };
@@ -90,6 +91,13 @@ __mem_cgroup_stat_reset_safe(struct mem_cgroup_stat_cpu *stat,
 	stat->count[idx] = 0;
 }
 
+static inline void
+__mem_cgroup_stat_set(struct mem_cgroup_stat_cpu *stat,
+		enum mem_cgroup_stat_index idx, s64 val)
+{
+	stat->count[idx] = val;
+}
+
 static inline s64
 __mem_cgroup_stat_read_local(struct mem_cgroup_stat_cpu *stat,
 				enum mem_cgroup_stat_index idx)
@@ -374,9 +382,10 @@ static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem)
 
 	cpu = get_cpu();
 	cpustat = &mem->stat.cpustat[cpu];
-	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_EVENTS);
-	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
-		__mem_cgroup_stat_reset_safe(cpustat, MEM_CGROUP_STAT_EVENTS);
+	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_SOFTLIMIT);
+	if (unlikely(val < 0)) {
+		__mem_cgroup_stat_set(cpustat, MEM_CGROUP_STAT_SOFTLIMIT,
+				SOFTLIMIT_EVENTS_THRESH);
 		ret = true;
 	}
 	put_cpu();
@@ -509,7 +518,7 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
 	else
 		__mem_cgroup_stat_add_safe(cpustat,
 				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
-	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_EVENTS, 1);
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_SOFTLIMIT, -1);
 	put_cpu();
 }
 
-- 
1.6.5.3

