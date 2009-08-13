Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZHMTrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZHMTrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbZHMTrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:47:41 -0400
Received: from kroah.org ([198.145.64.141]:36677 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754795AbZHMTrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:47:40 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:43:35 2009
Message-Id: <20090813194335.584926188@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:40:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: [patch 01/28] hugetlbfs: fix i_blocks accounting
References: <20090813194021.446758568@mini.kroah.org>
Content-Disposition: inline; filename=hugetlbfs-fix-i_blocks-accounting.patch
In-Reply-To: <20090813194554.GA13947@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Sandeen <sandeen@sandeen.net>

commit e4c6f8bed01f9f9a5c607bd689bf67e7b8a36bd8 upstream.

As reported in Red Hat bz #509671, i_blocks for files on hugetlbfs get
accounting wrong when doing something like:

   $ > foo
   $ date  > foo
   date: write error: Invalid argument
   $ /usr/bin/stat foo
     File: `foo'
     Size: 0          Blocks: 18446744073709547520 IO Block: 2097152 regular
...

This is because hugetlb_unreserve_pages() is unconditionally removing
blocks_per_huge_page(h) on each call rather than using the freed amount.
If there were 0 blocks, it goes negative, resulting in the above.

This is a regression from commit a5516438959d90b071ff0a484ce4f3f523dc3152
("hugetlb: modular state for hugetlb page size")

which did:

-	inode->i_blocks -= BLOCKS_PER_HUGEPAGE * freed;
+	inode->i_blocks -= blocks_per_huge_page(h);

so just put back the freed multiplier, and it's all happy again.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Andi Kleen <andi@firstfloor.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2257,7 +2257,7 @@ void hugetlb_unreserve_pages(struct inod
 	long chg = region_truncate(&inode->i_mapping->private_list, offset);
 
 	spin_lock(&inode->i_lock);
-	inode->i_blocks -= blocks_per_huge_page(h);
+	inode->i_blocks -= (blocks_per_huge_page(h) * freed);
 	spin_unlock(&inode->i_lock);
 
 	hugetlb_put_quota(inode->i_mapping, (chg - freed));


