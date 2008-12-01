Return-Path: <linux-kernel-owner+w=401wt.eu-S1755789AbYLAMUD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbYLAMUD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:20:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbYLAMTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:19:53 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41782 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYLAMTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:19:52 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH 11/11] memcg: show reclaim_stat
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081201211905.1CEB.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  1 Dec 2008 21:19:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added following four field to memory.stat file.

  - recent_rotated_anon
  - recent_rotated_file
  - recent_scanned_anon
  - recent_scanned_file

it is useful for memcg reclaim debugging.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/memcontrol.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

Index: b/mm/memcontrol.c
===================================================================
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1799,6 +1799,31 @@ static int mem_control_stat_show(struct 
 
 	cb->fill(cb, "inactive_ratio", mem_cont->inactive_ratio);
 
+	{
+		int nid, zid;
+		struct mem_cgroup_per_zone *mz;
+		unsigned long recent_rotated[2] = {0, 0};
+		unsigned long recent_scanned[2] = {0, 0};
+
+		for_each_online_node(nid)
+			for (zid = 0; zid < MAX_NR_ZONES; zid++) {
+				mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
+
+				recent_rotated[0] +=
+					mz->reclaim_stat.recent_rotated[0];
+				recent_rotated[1] +=
+					mz->reclaim_stat.recent_rotated[1];
+				recent_scanned[0] +=
+					mz->reclaim_stat.recent_scanned[0];
+				recent_scanned[1] +=
+					mz->reclaim_stat.recent_scanned[1];
+			}
+		cb->fill(cb, "recent_rotated_anon", recent_rotated[0]);
+		cb->fill(cb, "recent_rotated_file", recent_rotated[1]);
+		cb->fill(cb, "recent_scanned_anon", recent_scanned[0]);
+		cb->fill(cb, "recent_scanned_file", recent_scanned[1]);
+	}
+
 	return 0;
 }
 


