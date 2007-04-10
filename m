Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbXDJAKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbXDJAKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXDJAJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:09:46 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53701 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679AbXDJAIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:08:37 -0400
Date: Mon, 9 Apr 2007 17:06:11 -0700
Message-Id: <200704100006.l3A06Bao020614@zach-dev.vmware.com>
Subject: [PATCH 4/10] I386 pgd clone under lock fix.patch
From: Zachary Amsden <zach@vmware.com>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
CC: William Lee Irwin III <wli@holomorphy.com>
X-OriginalArrivalTime: 10 Apr 2007 00:08:37.0422 (UTC) FILETIME=[62FD94E0:01C77B04]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Copying of the pgd range must happen under the pgd_lock.  This got broken by
the paravirt changes in the -mm tree.  Badness can result if you copy the pgd
before being added to the list when splitting or rejoining large pages.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 2247ff2c3fdb arch/i386/mm/pgtable.c
--- a/arch/i386/mm/pgtable.c	Thu Apr 05 17:29:15 2007 -0700
+++ b/arch/i386/mm/pgtable.c	Thu Apr 05 17:40:02 2007 -0700
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
