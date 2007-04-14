Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbXDNVYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbXDNVYF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbXDNVVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:21:54 -0400
Received: from gw.goop.org ([64.81.55.164]:59548 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867AbXDNVUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:18 -0400
Message-Id: <20070414204924.724969434@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:42:12 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: [PATCH 18/28] Copying of the pgd range must happen under the pgd_lock
Content-Disposition: inline; filename=i386-pgd-clone-under-lock-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Copying of the pgd range must happen under the pgd_lock.  This got broken by
the paravirt changes in the -mm tree.  Badness can result if you copy the pgd
before being added to the list when splitting or rejoining large pages.

From: Zachary Amsden <zach@vmware.com>
Signed-off-by: Zachary Amsden <zach@vmware.com>
Acked-by: William Lee Irwin III <wli@holomorphy.com>
---
 arch/i386/mm/pgtable.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

===================================================================
--- a/arch/i386/mm/pgtable.c
+++ b/arch/i386/mm/pgtable.c
@@ -241,18 +241,16 @@ void pgd_ctor(void *pgd, struct kmem_cac
 	/* !PAE, no pagetable sharing */
 	memset(pgd, 0, USER_PTRS_PER_PGD*sizeof(pgd_t));
 
+	spin_lock_irqsave(&pgd_lock, flags);
+
+	/* must happen under lock */
 	clone_pgd_range((pgd_t *)pgd + USER_PTRS_PER_PGD,
 			swapper_pg_dir + USER_PTRS_PER_PGD,
 			KERNEL_PGD_PTRS);
-
-	spin_lock_irqsave(&pgd_lock, flags);
-
-	/* must happen under lock */
 	paravirt_alloc_pd_clone(__pa(pgd) >> PAGE_SHIFT,
 				__pa(swapper_pg_dir) >> PAGE_SHIFT,
 				USER_PTRS_PER_PGD,
 				KERNEL_PGD_PTRS);
-
 	pgd_list_add(pgd);
 	spin_unlock_irqrestore(&pgd_lock, flags);
 }

-- 

