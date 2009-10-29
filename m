Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbZJ2AdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbZJ2AdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 20:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbZJ2AdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 20:33:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34585 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbZJ2AdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 20:33:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 29 Oct 2009 09:30:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       Lee.Schermerhorn@hp.com
Subject: [BUGFIX][PATCH] memcg: fix wrong pointer initialization at page
 migration when memcg is disabled.
Message-Id: <20091029093013.cd58f3a5.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lee Schermerhorn reported that he saw bad pointer dereference
in mem_cgroup_end_migration() when he disabled memcg by boot option.

memcg's page migration logic works as

	mem_cgroup_prepare_migration(page, &ptr);
	do page migration
	mem_cgroup_end_migration(page, ptr);

Now, ptr is not initialized in prepare_migration when memcg is disabled
by boot option. This causes panic in end_migration. This patch fixes it.

Reported-by: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.32-rc5/mm/memcontrol.c
===================================================================
--- linux-2.6.32-rc5.orig/mm/memcontrol.c
+++ linux-2.6.32-rc5/mm/memcontrol.c
@@ -1990,7 +1990,8 @@ int mem_cgroup_prepare_migration(struct 
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
 	int ret = 0;
-
+	/* this pointer will be checked at end_migration */
+	*ptr = NULL;
 	if (mem_cgroup_disabled())
 		return 0;
 

