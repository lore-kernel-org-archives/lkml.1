Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbZGHTqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbZGHTqG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:46:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZGHTpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:45:54 -0400
Received: from sandeen.net ([209.173.210.139]:22354 "EHLO mail.sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309AbZGHTpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:45:54 -0400
Message-ID: <4A54F771.3060908@sandeen.net>
Date: Wed, 08 Jul 2009 14:45:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andi Kleen <andi@firstfloor.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: [PATCH] hugetlbfs: fix i_blocks accounting
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported in Red Hat bz #509671, i_blocks for files on hugetlbfs
get accounting wrong when doing something like:

   $ > foo
   $ date  > foo
   date: write error: Invalid argument
   $ /usr/bin/stat foo
     File: `foo'
     Size: 0          Blocks: 18446744073709547520 IO Block: 2097152 regular
...

This is because hugetlb_unreserve_pages() is unconditionally 
removing blocks_per_huge_page(h) on each call rather than using
the freed amount.  If there were 0 blocks, it goes negative,
resulting in the above.

This is a regression from commit
a5516438959d90b071ff0a484ce4f3f523dc3152

which did:

-	inode->i_blocks -= BLOCKS_PER_HUGEPAGE * freed;
+	inode->i_blocks -= blocks_per_huge_page(h);

so just put back the freed multiplier, and it's all happy again.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
---

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d0351e3..cafdcee 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2370,7 +2370,7 @@ void hugetlb_unreserve_pages(struct inode *inode, long offset, long freed)
 	long chg = region_truncate(&inode->i_mapping->private_list, offset);
 
 	spin_lock(&inode->i_lock);
-	inode->i_blocks -= blocks_per_huge_page(h);
+	inode->i_blocks -= (blocks_per_huge_page(h) * freed);
 	spin_unlock(&inode->i_lock);
 
 	hugetlb_put_quota(inode->i_mapping, (chg - freed));

