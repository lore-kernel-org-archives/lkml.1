Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZIEV1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZIEV1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 17:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZIEV1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 17:27:52 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:3332 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbZIEV1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 17:27:52 -0400
X-Trace: 254199618/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.92.10/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.92.10
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAAp0okpPRVwK/2dsb2JhbACBU9Y7hBgF
X-IronPort-AV: E=Sophos;i="4.44,339,1249254000"; 
   d="scan'208";a="254199618"
Date: Sat, 5 Sep 2009 22:26:48 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 3/3] ksm: mremap use err from ksm_madvise
In-Reply-To: <Pine.LNX.4.64.0909052219580.7381@sister.anvils>
Message-ID: <Pine.LNX.4.64.0909052225250.7387@sister.anvils>
References: <Pine.LNX.4.64.0909052219580.7381@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mremap move's use of ksm_madvise() was assuming -ENOMEM on failure,
because ksm_madvise used to say -EAGAIN for that; but ksm_madvise now
says -ENOMEM (letting madvise convert that to -EAGAIN), and can also
say -ERESTARTSYS when signalled: so pass the error from ksm_madvise.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/mremap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- mmotm/mm/mremap.c	2009-09-05 14:40:16.000000000 +0100
+++ linux/mm/mremap.c	2009-09-05 16:41:55.000000000 +0100
@@ -175,6 +175,7 @@ static unsigned long move_vma(struct vm_
 	unsigned long excess = 0;
 	unsigned long hiwater_vm;
 	int split = 0;
+	int err;
 
 	/*
 	 * We'd prefer to avoid failure later on in do_munmap:
@@ -190,9 +191,10 @@ static unsigned long move_vma(struct vm_
 	 * pages recently unmapped.  But leave vma->vm_flags as it was,
 	 * so KSM can come around to merge on vma and new_vma afterwards.
 	 */
-	if (ksm_madvise(vma, old_addr, old_addr + old_len,
-						MADV_UNMERGEABLE, &vm_flags))
-		return -ENOMEM;
+	err = ksm_madvise(vma, old_addr, old_addr + old_len,
+						MADV_UNMERGEABLE, &vm_flags);
+	if (err)
+		return err;
 
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
 	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff);
