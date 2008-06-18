Return-Path: <linux-kernel-owner+w=401wt.eu-S1759804AbYFRDdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbYFRDdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 23:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757803AbYFRDdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 23:33:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46294 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbYFRDdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 23:33:38 -0400
Date: Wed, 18 Jun 2008 12:33:02 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH] unevictable mlocked pages:  initialize mm member of munlock mm_walk structure
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org
In-Reply-To: <1213732843.8707.70.camel@lts-notebook>
References: <1213727385.8707.53.camel@lts-notebook> <1213732843.8707.70.camel@lts-notebook>
Message-Id: <20080618122828.37A0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> PATCH:  fix munlock page table walk - now requires 'mm'
> 
> Against 2.6.26-rc5-mm3.
> 
> Incremental fix for: mlock-mlocked-pages-are-unevictable-fix.patch 
> 
> Initialize the 'mm' member of the mm_walk structure, else the
> page table walk doesn't occur, and mlocked pages will not be
> munlocked.  This is visible in the vmstats:  

Yup, Dave Hansen changed page_walk interface recently.
thus, his and ours patch is conflicted ;)

below patch is just nit cleanups.


===========================================
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

This [freeing of mlocked pages] also occurs in unpatched 26-rc5-mm3.

Fixed by the following:

PATCH:  fix munlock page table walk - now requires 'mm'

Against 2.6.26-rc5-mm3.

Incremental fix for: mlock-mlocked-pages-are-unevictable-fix.patch 

Initialize the 'mm' member of the mm_walk structure, else the
page table walk doesn't occur, and mlocked pages will not be
munlocked.  This is visible in the vmstats:  

	noreclaim_pgs_munlocked - should equal noreclaim_pgs_mlocked
	  less (nr_mlock + noreclaim_pgs_cleared), but is always zero 
	  [munlock_vma_page() never called]

	noreclaim_pgs_mlockfreed - should be zero [for debug only],
	  but == noreclaim_pgs_mlocked - (nr_mlock + noreclaim_pgs_cleared)


Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

 mm/mlock.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/mm/mlock.c
===================================================================
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -310,6 +310,7 @@ static void __munlock_vma_pages_range(st
 		.pmd_entry = __munlock_pmd_handler,
 		.pte_entry = __munlock_pte_handler,
 		.private = &mpw,
+		.mm = mm,
 	};
 
 	VM_BUG_ON(start & ~PAGE_MASK || end & ~PAGE_MASK);


