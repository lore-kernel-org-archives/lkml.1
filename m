Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZFZA7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZFZA7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 20:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbZFZA7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 20:59:17 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44535 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbZFZA7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 20:59:16 -0400
Date: Fri, 26 Jun 2009 09:57:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com,
       kamezawa.hiroyuki@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       lizf@cn.fujitsu.com, menage@google.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] memcg: add commens for expaing memory barrier (Was Re: Low
 overhead patches for the memory cgroup controller (v5)
Message-Id: <20090626095745.01cef410.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090623090116.556d4f97.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090615043900.GF23577@balbir.in.ibm.com>
	<20090622154343.9cdbf23a.akpm@linux-foundation.org>
	<20090623090116.556d4f97.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 09:01:16 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Do we still need the smp_wmb()?
> > 
> > It's hard to say, because we forgot to document it :(
> > 
> Sorry for lack of documentation.
> 
> pc->mem_cgroup should be visible before SetPageCgroupUsed(). Othrewise,
> A routine believes USED bit will see bad pc->mem_cgroup.
> 
> I'd like to  add a comment later (againt new mmotm.)
> 

Ok, it's now.
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Add comments for the reason of smp_wmb() in mem_cgroup_commit_charge().

Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: mmotm-2.6.31-Jun25/mm/memcontrol.c
===================================================================
--- mmotm-2.6.31-Jun25.orig/mm/memcontrol.c
+++ mmotm-2.6.31-Jun25/mm/memcontrol.c
@@ -1134,6 +1134,13 @@ static void __mem_cgroup_commit_charge(s
 	}
 
 	pc->mem_cgroup = mem;
+	/*
+ 	 * We access a page_cgroup asynchronously without lock_page_cgroup().
+ 	 * Especially when a page_cgroup is taken from a page, pc->mem_cgroup
+ 	 * is accessed after testing USED bit. To make pc->mem_cgroup visible
+ 	 * before USED bit, we need memory barrier here.
+ 	 * See mem_cgroup_add_lru_list(), etc.
+ 	 */
 	smp_wmb();
 	switch (ctype) {
 	case MEM_CGROUP_CHARGE_TYPE_CACHE:


