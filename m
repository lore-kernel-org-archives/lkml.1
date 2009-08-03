Return-Path: <linux-kernel-owner+w=401wt.eu-S932082AbZHCMXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbZHCMXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:23:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754885AbZHCMXD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:23:03 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:54828 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbZHCMXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:23:02 -0400
X-Trace: 240517028/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.63.67/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.63.67
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAIRzdkpPRT9D/2dsb2JhbACBUs4shBgFgUo
X-IronPort-AV: E=Sophos;i="4.43,314,1246834800"; 
   d="scan'208";a="240517028"
Date: Mon, 3 Aug 2009 13:22:53 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 12/12] ksm: remove VM_MERGEABLE_FLAGS
In-Reply-To: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
Message-ID: <Pine.LNX.4.64.0908031321380.16754@sister.anvils>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KSM originally stood for Kernel Shared Memory: but the kernel has long
supported shared memory, and VM_SHARED and VM_MAYSHARE vmas, and KSM is
something else.  So we switched to saying "merge" instead of "share".

But Chris Wright points out that this is confusing where mmap.c merges
adjacent vmas: most especially in the name VM_MERGEABLE_FLAGS, used by
is_mergeable_vma() to let vmas be merged despite flags being different.

Call it VMA_MERGE_DESPITE_FLAGS?  Perhaps, but at present it consists
only of VM_CAN_NONLINEAR: so for now it's clearer on all sides to use
that directly, with a comment on it in is_mergeable_vma().

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---
This patch got lost along the way last time: no big deal but try again.

 mm/mmap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- ksm11/mm/mmap.c	2009-08-02 13:50:41.000000000 +0100
+++ ksm12/mm/mmap.c	2009-08-02 13:51:04.000000000 +0100
@@ -660,9 +660,6 @@ again:			remove_next = 1 + (end > next->
 	validate_mm(mm);
 }
 
-/* Flags that can be inherited from an existing mapping when merging */
-#define VM_MERGEABLE_FLAGS (VM_CAN_NONLINEAR)
-
 /*
  * If the vma has a ->close operation then the driver probably needs to release
  * per-vma resources, so we don't attempt to merge those.
@@ -670,7 +667,8 @@ again:			remove_next = 1 + (end > next->
 static inline int is_mergeable_vma(struct vm_area_struct *vma,
 			struct file *file, unsigned long vm_flags)
 {
-	if ((vma->vm_flags ^ vm_flags) & ~VM_MERGEABLE_FLAGS)
+	/* VM_CAN_NONLINEAR may get set later by f_op->mmap() */
+	if ((vma->vm_flags ^ vm_flags) & ~VM_CAN_NONLINEAR)
 		return 0;
 	if (vma->vm_file != file)
 		return 0;
