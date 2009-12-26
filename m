Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbZLZAcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbZLZAcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 19:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757445AbZLZAbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 19:31:32 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:40911 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757406AbZLZAb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 19:31:28 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: containers@lists.linux-foundation.org, linux-mm@kvack.org
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
       "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH v3 3/4] memcg: rework usage of stats by soft limit
Date: Sat, 26 Dec 2009 02:30:59 +0200
Message-Id: <8e6612d3d0cb5fcf9ab6495bbaf2578578ce8e91.1261786326.git.kirill@shutemov.name>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <4d7e4854676423c2d63663f6dbafb1eb9eecd500.1261786326.git.kirill@shutemov.name>
References: <cover.1261786326.git.kirill@shutemov.name>
 <d7bfc1a5360d5cb03ad263767cd2c3ad11cb5fc6.1261786326.git.kirill@shutemov.name>
 <4d7e4854676423c2d63663f6dbafb1eb9eecd500.1261786326.git.kirill@shutemov.name>
In-Reply-To: <cover.1261786326.git.kirill@shutemov.name>
References: <cover.1261786326.git.kirill@shutemov.name>
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
index 1d71cb4..36eb7af 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -69,8 +69,9 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
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
@@ -380,9 +388,10 @@ static bool mem_cgroup_soft_limit_check(struct mem_cgroup *mem)
 
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
@@ -515,7 +524,7 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
 	else
 		__mem_cgroup_stat_add_safe(cpustat,
 				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
-	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_EVENTS, 1);
+	__mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_SOFTLIMIT, -1);
 	put_cpu();
 }
 
-- 
1.6.5.7

