Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbYLDCPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbYLDCPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 21:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYLDCO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 21:14:56 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57370 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbYLDCOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 21:14:55 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH] mm: remove UP version lru_add_drain_all()
Cc: kosaki.motohiro@jp.fujitsu.com, Dave Hansen <dave@linux.vnet.ibm.com>,
       gerald.schaefer@de.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
       y-goto@jp.fujitsu.com, npiggin@suse.de,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20081204093143.390afa9f.kamezawa.hiroyu@jp.fujitsu.com>
References: <1228342567.13111.11.camel@nimitz> <20081204093143.390afa9f.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20081204110013.1D62.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  4 Dec 2008 11:14:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC to  Christoph Lameter and Lee Schermerhorn)


> On Wed, 03 Dec 2008 14:16:07 -0800
> Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> > > This let us run
> > > into the BUG_ON(!PageBuddy(page)) in __offline_isolated_pages() during
> > > memory hotplug stress test on s390. The page in question was still on the
> > > pcp list, because of a race with lru_add_drain_all() and drain_all_pages()
> > > on different cpus.
> > > 
> > > This is fixed with this patch by adding CONFIG_MEMORY_HOTREMOVE to the
> > > lru_add_drain_all() #ifdef, to let it run on each cpu.
> > 
> > This doesn't seem right to me.  CONFIG_MEMORY_HOTREMOVE doesn't change
> > the layout of the LRUs, unlike NUMA or UNEVICTABLE_LRU.  So, I think
> > this bug is more due to the hotremove code mis-expecting behavior out of
> > lru_add_drain_all().
> > 
> How about 
> 
> #ifdef CONFIG_SMP
> 
> #else..
> 
> #endif
> 
> rather than
> 
> -#if defined(CONFIG_NUMA) || defined(CONFIG_UNEVICTABLE_LRU)
> +#if defined(CONFIG_NUMA) || defined(CONFIG_UNEVICTABLE_LRU) || \
> +    defined(CONFIG_MEMORY_HOTREMOVE)
> ...


The default value of CONFIG_UNEVICTABLE_LRU is ON.
Then, almost machine use CONFIG_NUMA version lru_add_drain_all().

Therefore, this config option is not so valuable.
I like simple removing.

following patch can boot on UP machine.
===
Currently, lru_add_drain_all() has two version.
  (1) use schedule_on_each_cpu()
  (2) don't use schedule_on_each_cpu()

Gerald Schaefer reported it doesn't works well on SMP (not NUMA) S390 machine.

  offline_pages() calls lru_add_drain_all() followed by drain_all_pages().
  While drain_all_pages() works on each cpu, lru_add_drain_all() only runs
  on the current cpu for architectures w/o CONFIG_NUMA. This let us run
  into the BUG_ON(!PageBuddy(page)) in __offline_isolated_pages() during
  memory hotplug stress test on s390. The page in question was still on the
  pcp list, because of a race with lru_add_drain_all() and drain_all_pages()
  on different cpus.

Actually, Almost machine has CONFIG_UNEVICTABLE_LRU=y. Then almost machine use
(1) version lru_add_drain_all although the machine is UP.

Then this ifdef is not valueable.
simple removing is better.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Christoph Lameter <cl@linux-foundation.org>
CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

---
 mm/swap.c |   13 -------------
 1 file changed, 13 deletions(-)

Index: b/mm/swap.c
===================================================================
--- a/mm/swap.c	2008-11-24 19:33:26.000000000 +0900
+++ b/mm/swap.c	2008-12-04 09:49:05.000000000 +0900
@@ -299,7 +299,6 @@ void lru_add_drain(void)
 	put_cpu();
 }
 
-#if defined(CONFIG_NUMA) || defined(CONFIG_UNEVICTABLE_LRU)
 static void lru_add_drain_per_cpu(struct work_struct *dummy)
 {
 	lru_add_drain();
@@ -313,18 +312,6 @@ int lru_add_drain_all(void)
 	return schedule_on_each_cpu(lru_add_drain_per_cpu);
 }
 
-#else
-
-/*
- * Returns 0 for success
- */
-int lru_add_drain_all(void)
-{
-	lru_add_drain();
-	return 0;
-}
-#endif
-
 /*
  * Batched page_cache_release().  Decrement the reference count on all the
  * passed pages.  If it fell to zero then remove the page from the LRU and



