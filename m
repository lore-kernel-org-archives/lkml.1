Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbYKUKEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbYKUKEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbYKUKEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:04:37 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50154 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbYKUKEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:04:35 -0500
Date: Fri, 21 Nov 2008 19:03:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       pbadari@us.ibm.com, jblunck@suse.de, taka@valinux.co.jp,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       npiggin@suse.de
Subject: [PATCH 2/2] memcg: fix reclaim result checks.
Message-Id: <20081121190339.65f453a6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081121185829.e04c8116.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081114191246.4f69ff31.kamezawa.hiroyu@jp.fujitsu.com>
	<20081114191949.926bf99d.kamezawa.hiroyu@jp.fujitsu.com>
	<49261F87.50209@cn.fujitsu.com>
	<20081121185829.e04c8116.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_under_limit logic was wrong and this check should be against
mem_over_limit rather than mem.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: mmotm-2.6.28-Nov20/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Nov20.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Nov20/mm/memcontrol.c
@@ -714,17 +714,17 @@ static int __mem_cgroup_try_charge(struc
 		 * current usage of the cgroup before giving up
 		 *
 		 */
-		if (!do_swap_account &&
-			res_counter_check_under_limit(&mem->res))
-			continue;
-		if (do_swap_account &&
-			res_counter_check_under_limit(&mem->memsw))
-			continue;
+		if (do_swap_account) {
+			if (res_counter_check_under_limit(&mem_over_limit->res) &&
+			    res_counter_check_under_limit(&mem_over_limit->memsw))
+				continue;
+		} else if (res_counter_check_under_limit(&mem_over_limit->res))
+				continue;
 
 		if (!nr_retries--) {
 			if (oom) {
-				mem_cgroup_out_of_memory(mem, gfp_mask);
-				mem->last_oom_jiffies = jiffies;
+				mem_cgroup_out_of_memory(mem_over_limit, gfp_mask);
+				mem_over_limit->last_oom_jiffies = jiffies;
 			}
 			goto nomem;
 		}

