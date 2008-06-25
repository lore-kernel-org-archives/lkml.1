Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYFYKF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYFYKF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 06:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbYFYKFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 06:05:17 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43175 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbYFYKFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:05:15 -0400
Date: Wed, 25 Jun 2008 19:03:36 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Rik van Riel <riel@redhat.com>
Subject: [-mm][PATCH 3/10] fix munlock page table walk - now requires 'mm'
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080625185717.D84C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080625185717.D84C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080625190251.D855.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


=
From: Lee Schermerhorn <lee.schermerhorn@hp.com>

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


