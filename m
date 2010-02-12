Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757800Ab0BLB4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 20:56:52 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57673 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671Ab0BLB4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 20:56:51 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 12 Feb 2010 10:53:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, stable@kernel.org,
       minchan.kim@gmail.com, rientjes@google.com,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [BUGFIX][PATCH] memcg: fix oom killing a child process in an other
 cgroup
Message-Id: <20100212105318.caf37133.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch itself is againt mmotm-Feb10 but can be applied to 2.6.32.8
without problem.

==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, oom-killer is memcg aware and it finds the worst process from
processes under memcg(s) in oom. Then, it kills victim's child at first.
It may kill a child in other cgroup and may not be any help for recovery.
And it will break the assumption users have...

This patch fixes it.

CC: stable@kernel.org
CC: Minchan Kim <minchan.kim@gmail.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/oom_kill.c |    2 ++
 1 file changed, 2 insertions(+)

Index: mmotm-2.6.33-Feb10/mm/oom_kill.c
===================================================================
--- mmotm-2.6.33-Feb10.orig/mm/oom_kill.c
+++ mmotm-2.6.33-Feb10/mm/oom_kill.c
@@ -459,6 +459,8 @@ static int oom_kill_process(struct task_
 	list_for_each_entry(c, &p->children, sibling) {
 		if (c->mm == p->mm)
 			continue;
+		if (mem && !task_in_mem_cgroup(c, mem))
+			continue;
 		if (!oom_kill_task(c))
 			return 0;
 	}

