Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbYKEIRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYKEIRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 03:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYKEIRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 03:17:16 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43172 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYKEIRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 03:17:15 -0500
Date: Wed, 5 Nov 2008 17:16:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: [RFC][PATCH 0/6] memcg updates (05/Nov)
Message-Id: <20081105171637.1b393333.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Weekly (RFC) update for memcg.

This set includes

1. change force_empty to do move account rather than forget all
2. swap cache handling
3. mem+swap controller kconfig
4. swap_cgroup for rememver swap account information
5. mem+swap controller core
6. synchronize memcg's LRU and global LRU.

"1" is already sent, "6" is a newcomer.
I'd like to push out "2" or "2-5" in the next week (if no bugs.)

after 6, next candidates are
  - dirty_ratio handler
  - account move at task move.

Some more explanation about purpose of "6". (see details in patch itself)
Now, one of complicated logic in memcg is LRU handling. Because the place of
lru_head depends on page_cgroup->mem_cgroup pointer, we have to take
lock as following even under zone->lru_lock.
==
  pc = lookup_page_cgroup(page);
  if (!trylock_page_cgroup(pc))
  	return -EBUSY;

   if (PageCgroupUsed(pc)) {
	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
	spin_lock_irqsave(&mz->lru_lock, flags);
	....some operation on LRU.
	spin_unlock_irqrestore(&mz->lru_lock, flags);
   }
   unlock_page_cgroup(pc);
==
Sigh..

After "6", page_cgroup's LRU management can be done independently to some extent.
== as
  (zone->lru_lock is held here)
  pc = lookup_page_cgroup(page);
  list operation on pc.
  (unlock zone->lru_lock)
==
Maybe good for maintainance and as a bonus, we can make use of isolate_lru_page() when
doing some racy operation.

	isolate_lru_page(page);
	pc = lookup_page_cgroup(page);
	do some jobs.
	putback_lru_page(page);

Maybe this will be a help to implement "account move at task move".

Thanks,
-Kame




