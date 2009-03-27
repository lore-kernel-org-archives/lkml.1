Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbZC0FPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbZC0FPK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbZC0FOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:14:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47576 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbZC0FOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:14:53 -0400
Date: Fri, 27 Mar 2009 14:13:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH 8/8] extends soft limit event filter
Message-Id: <20090327141322.6606cabe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce softlimit update ratio depends on its priority(usage).

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: mmotm-2.6.29-Mar23/mm/memcontrol.c
===================================================================
--- mmotm-2.6.29-Mar23.orig/mm/memcontrol.c
+++ mmotm-2.6.29-Mar23/mm/memcontrol.c
@@ -945,11 +945,15 @@ static bool mem_cgroup_soft_limit_check(
 	bool ret = false;
 	int cpu = get_cpu();
 	s64 val;
+	int thresh;
 	struct mem_cgroup_stat_cpu *cpustat;
 
 	cpustat = &mem->stat.cpustat[cpu];
 	val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_EVENTS);
-	if (unlikely(val > SOFTLIMIT_EVENTS_THRESH)) {
+	/* If usage is big, this check can be rough */
+	thresh = SOFTLIMIT_EVENTS_THRESH;
+	thresh <<= (mem->soft_limit_priority >> 1);
+	if (unlikely(val > thresh)) {
 		__mem_cgroup_stat_reset_safe(cpustat, MEM_CGROUP_STAT_EVENTS);
 		ret = true;
 	}

