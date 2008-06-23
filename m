Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbYFWLPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbYFWLPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYFWLPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:15:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42415 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYFWLPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:15:39 -0400
Date: Mon, 23 Jun 2008 20:21:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       balbir@linux.vnet.ibm.com, xemul@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [bad page] memcg: another bad page at page migration
 (2.6.26-rc5-mm3 + patch collection)
Message-Id: <20080623202111.f2c54e21.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080623150817.628aef9f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20080623145341.0a365c67.nishimura@mxp.nes.nec.co.jp>
	<20080623150817.628aef9f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 15:08:17 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Mon, 23 Jun 2008 14:53:41 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > Hi.
> > 
> > It seems the current -mm has been gradually stabilized,
> > but I encounter another bad page problem in my test(*1)
> > on 2.6.26-rc5-mm3 + patch collection(*2).
> > 
> > Compared to previous probrems fixed by the patch collection,
> > the frequency is law.
> > 
> > - 1 time in 1 hour running(1'st one was seen after 30 minutes)
> > - 3 times in 16 hours running(1'st one was seen after 4 hours)
> > - 10 times in 70 hours running(1'st one was seen after 8 hours)
> > 
> > All bad pages show similar message like below:
> > 
> Thank you. I'll dig this.
> 
> 
Here is one possibilty. But if your test doesn't migrate any shmem, 
I'll have to dig more ;)
Anyway, I'll schedule this patch.

-Kame
=
mem_cgroup_uncharge() against old page is done after radix-tree-replacement.
And there were special handling to ingore swap-cache page. But, shmem can
be swap-cache and file-cache at the same time. Chekcing PageSwapCache() is
not correct here. Check PageAnon() instead.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 mm/migrate.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: test2-2.6.26-rc5-mm3/mm/migrate.c
===================================================================
--- test2-2.6.26-rc5-mm3.orig/mm/migrate.c
+++ test2-2.6.26-rc5-mm3/mm/migrate.c
@@ -330,7 +330,13 @@ static int migrate_page_move_mapping(str
 	__inc_zone_page_state(newpage, NR_FILE_PAGES);
 
 	spin_unlock_irq(&mapping->tree_lock);
-	if (!PageSwapCache(newpage))
+
+	/*
+	 * The page is removed from radix-tree implicitly.
+	 * We uncharge it here but swap cache of anonymous page should be
+	 * uncharged by mem_cgroup_ucharge_page().
+	 */
+	if (!PageAnon(newpage))
 		mem_cgroup_uncharge_cache_page(page);
 
 	return 0;
@@ -379,7 +385,8 @@ static void migrate_page_copy(struct pag
 		/*
 		 * SwapCache is removed implicitly. Uncharge against swapcache
 		 * should be called after ClearPageSwapCache() because
-		 * mem_cgroup_uncharge_page checks the flag.
+		 * mem_cgroup_uncharge_page checks the flag. shmem's swap cache
+		 * is uncharged before here.
 		 */
 		mem_cgroup_uncharge_page(page);
 	}

