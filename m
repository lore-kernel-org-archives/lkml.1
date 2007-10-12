Return-Path: <linux-kernel-owner+w=401wt.eu-S1760221AbXJLHfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760221AbXJLHfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbXJLHex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:34:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41492 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbXJLHew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:34:52 -0400
Date: Fri, 12 Oct 2007 16:35:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: [BUGFIX][PATCH][ for -mm] bugfix for memory cgroup controller [1/5]
 charge refcnt race fix
Message-Id: <20071012163526.81dd66b6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071012163412.2f1ca1ea.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071012163412.2f1ca1ea.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The logic of uncharge is 
 - decrement refcnt -> lock page cgroup -> remove page cgroup.
But the logic of charging is
 - lock page cgroup -> increment refcnt -> return.

Then, one charge will be added to a page_cgroup under being removed.
This makes no big trouble (like panic) but one charge is lost.

This patch add a test at charging to verify page_cgroup's refcnt is
greater than 0. If not, unlock and retry.

Changelog v2->v3
 * adjusted to 2.6.23-mm1
Changelog v1->v2:
 * added cpu_relax() before retry.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


 mm/memcontrol.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: devel-2.6.23-mm1/mm/memcontrol.c
===================================================================
--- devel-2.6.23-mm1.orig/mm/memcontrol.c
+++ devel-2.6.23-mm1/mm/memcontrol.c
@@ -281,14 +281,20 @@ int mem_cgroup_charge(struct page *page,
 	 * to see if the cgroup page already has a page_cgroup associated
 	 * with it
 	 */
+retry:
 	lock_page_cgroup(page);
 	pc = page_get_page_cgroup(page);
 	/*
 	 * The page_cgroup exists and the page has already been accounted
 	 */
 	if (pc) {
-		atomic_inc(&pc->ref_cnt);
-		goto done;
+		if (unlikely(!atomic_inc_not_zero(&pc->ref_cnt))) {
+			/* this page is under being uncharged ? */
+			unlock_page_cgroup(page);
+			cpu_relax();
+			goto retry;
+		} else
+			goto done;
 	}
 
 	unlock_page_cgroup(page);

