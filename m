Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYFSJJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYFSJJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 05:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYFSJJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 05:09:47 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43932 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbYFSJJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 05:09:45 -0400
Date: Thu, 19 Jun 2008 18:08:54 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [-mm][PATCH 1/5]  fix munlock page table walk
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080619172241.E7FC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080619172241.E7FC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080619180721.E802.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Schermerhorn <lee.schermerhorn@hp.com>

PATCH:  fix munlock page table walk - now requires 'mm'

Against 2.6.26-rc5-mm3.

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
@@ -301,6 +301,7 @@ static void __munlock_vma_pages_range(st
 		.pmd_entry = __munlock_pmd_handler,
 		.pte_entry = __munlock_pte_handler,
 		.private = &mpw,
+		.mm = mm,
 	};
 
 	VM_BUG_ON(start & ~PAGE_MASK || end & ~PAGE_MASK);


