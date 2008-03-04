Return-Path: <linux-kernel-owner+w=401wt.eu-S1764278AbYCDSx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764278AbYCDSx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757787AbYCDSxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:53:46 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:39977 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbYCDSxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:53:45 -0500
Subject: [BUG FIX] Fix mempolicy reference counting bugs
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Cc: ak@suse.de, clameter@sgi.com, mel@csn.ul.ie, linux-mm@kvack.org,
       rientjes@google.com, eric.whitney@hp.com
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 04 Mar 2008 13:53:56 -0500
Message-Id: <1204656837.5338.89.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[BUG FIX] Fix mempolicy reference counting bugs

This patch address 3 known bugs in the current memory policy
reference counting method.  I have a series of patches to
rework the reference counting to reduce overhead in the
allocation path. However, that series will require testing
in -mm once I repost it.

I'm making this patch available for the current upstream
[2.6.25-rc3] pending submittal and acceptance of the rework.
Note that these bugs exist back to 2.6.23, so this patch
may be a candidate for the stable tree.

Problem description:

1) alloc_page_vma() does not release the extra reference
   taken for vma/shared mempolicy when the mode ==
   MPOL_INTERLEAVE.  This can result in leaking mempolicy
   structures.  This is probably occurring, but not being
   noticed.

   Fix:  add the conditional release of the reference.

2) hugezonelist unconditionally releases a reference on
   the mempolicy when mode == MPOL_INTERLEAVE.  This can
   result in decrementing the reference count for system
   default policy [should have no ill effect] or premature
   freeing of task policy.  If this occurred, the next
   allocation using task mempolicy would use the freed
   structure and probably BUG out.

   Fix:  add the necessary check to the release.

3) The current reference counting method assumes that
   vma 'get_policy()' methods automatically add an extra
   reference a non-NULL returned mempolicy.  This is true
   for shmem_get_policy() used by tmpfs mappings, including
   regular page shm segments.  However, SHM_HUGETLB shm's,
   backed by hugetlbfs, just use the vma policy without the
   extra reference.  This results in freeing of the vma
   policy on the first allocation, with reuse of the freed
   mempolicy structure on subsequent allocations.

   Fix:  Rather than add another condition to the 
   conditional reference release, which occur in the allocation
   path, just add a reference when returning the vma policy in 
   shm_get_policy() to match the assumptions.

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>

 ipc/shm.c      |    5 +++--
 mm/mempolicy.c |    7 ++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6.25-rc3/mm/mempolicy.c
===================================================================
--- linux-2.6.25-rc3.orig/mm/mempolicy.c	2008-02-29 12:32:47.000000000 -0500
+++ linux-2.6.25-rc3/mm/mempolicy.c	2008-02-29 12:32:48.000000000 -0500
@@ -1296,7 +1296,9 @@ struct zonelist *huge_zonelist(struct vm
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, HPAGE_SHIFT);
-		__mpol_free(pol);		/* finished with pol */
+		if (unlikely(pol != &default_policy &&
+				pol != current->mempolicy))
+			__mpol_free(pol);	/* finished with pol */
 		return NODE_DATA(nid)->node_zonelists + gfp_zone(gfp_flags);
 	}
 
@@ -1360,6 +1362,9 @@ alloc_page_vma(gfp_t gfp, struct vm_area
 		unsigned nid;
 
 		nid = interleave_nid(pol, vma, addr, PAGE_SHIFT);
+		if (unlikely(pol != &default_policy &&
+				pol != current->mempolicy))
+			__mpol_free(pol);	/* finished with pol */
 		return alloc_page_interleave(gfp, 0, nid);
 	}
 	zl = zonelist_policy(gfp, pol);
Index: linux-2.6.25-rc3/ipc/shm.c
===================================================================
--- linux-2.6.25-rc3.orig/ipc/shm.c	2008-02-29 12:32:47.000000000 -0500
+++ linux-2.6.25-rc3/ipc/shm.c	2008-02-29 12:34:37.000000000 -0500
@@ -271,9 +271,10 @@ static struct mempolicy *shm_get_policy(
 
 	if (sfd->vm_ops->get_policy)
 		pol = sfd->vm_ops->get_policy(vma, addr);
-	else if (vma->vm_policy)
+	else if (vma->vm_policy) {
 		pol = vma->vm_policy;
-	else
+		mpol_get(pol);	/* get_vma_policy() expects this */
+	} else
 		pol = current->mempolicy;
 	return pol;
 }


