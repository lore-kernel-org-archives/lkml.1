Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbYLCFGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbYLCFGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 00:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYLCFGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 00:06:07 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60001 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYLCFGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 00:06:06 -0500
Date: Wed, 3 Dec 2008 14:05:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH  15/21] memcg-show-reclaim-stat.patch
Message-Id: <20081203140512.85695b25.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added following four field to memory.stat file.
  - inactive_ratio
  - recent_rotated_anon
  - recent_rotated_file
  - recent_scanned_anon
  - recent_scanned_file

Changelog:
  - unified inactive_ratio patch and recent_rotate patch.
  - added documentation.
  - put under CONFIG_DEBUG_VM.

Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

 Documentation/controllers/memory.txt |   25 +++++++++++++++++++++++++
 mm/memcontrol.c                      |   30 ++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

Index: mmotm-2.6.28-Dec02/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Dec02.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Dec02/mm/memcontrol.c
@@ -1810,6 +1810,36 @@ static int mem_control_stat_show(struct 
 		cb->fill(cb, "unevictable", unevictable * PAGE_SIZE);
 
 	}
+
+#ifdef CONFIG_DEBUG_VM
+	cb->fill(cb, "inactive_ratio", mem_cont->inactive_ratio);
+
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
+#endif
+
 	return 0;
 }
 
Index: mmotm-2.6.28-Dec02/Documentation/controllers/memory.txt
===================================================================
--- mmotm-2.6.28-Dec02.orig/Documentation/controllers/memory.txt
+++ mmotm-2.6.28-Dec02/Documentation/controllers/memory.txt
@@ -289,6 +289,31 @@ will be charged as a new owner of it.
   Because rmdir() moves all pages to parent, some out-of-use page caches can be
   moved to the parent. If you want to avoid that, force_empty will be useful.
 
+5.2 stat file
+  memory.stat file includes following statistics (now)
+	cache			- # of pages from page-cache and shmem.
+	rss			- # of pages from anonymous memory.
+	pgpgin			- # of event of charging
+	pgpgout			- # of event of uncharging
+	active_anon		- # of pages on active lru of anon, shmem.
+	inactive_anon 		- # of pages on active lru of anon, shmem
+	active_file		- # of pages on active lru of file-cache
+	inactive_file		- # of pages on inactive lru of file cache
+	unevictable		- # of pages cannot be reclaimed.(mlocked etc)
+
+	Below is depend on CONFIG_DEBUG_VM.
+	inactive_ratio		- VM inernal parameter. (see mm/page_alloc.c)
+	recent_rotated_anon	- VM internal parameter. (see mm/vmscan.c)
+	recent_rotated_file	- VM internal parameter. (see mm/vmscan.c)
+	recent_scanned_anon 	- VM internal parameter. (see mm/vmscan.c)
+	recent_scanned_file 	- VM internal parameter. (see mm/vmscan.c)
+
+  Memo:
+	recent_rotated means recent frequency of lru rotation.
+	recent_scanned means recent # of scans to lru.
+	showing for better debug please see the code for meanings.
+
+
 6. Hierarchy support
 
 The memory controller supports a deep hierarchy and hierarchical accounting.

