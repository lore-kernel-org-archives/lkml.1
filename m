Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbZBCEYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbZBCEYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZBCEY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:24:27 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:42638 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbZBCEY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:24:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=N2e776XqjWPXehSShLrMNIq0eO4q0I/E1M9Gelo0/vAvfNcxpB2y6BdWrUQPCu3gmZ
         EPRSvsoqShMalKFW18cMMVIze/N8l6BvxbwiSOKOl6GRO/44kBibNlQ8ZSdgEtM5r8X0
         aDnXNI0t3srz426FH/DTwWArLTBY4gzfMjL2k=
Date: Tue, 3 Feb 2009 13:24:05 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux mm <linux-mm@kvack.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>
Subject: [PATCH v2] fix mlocked page counter mistmatch
Message-ID: <20090203042405.GB16179@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When I tested following program, I found that mlocked counter
is strange.
It couldn't free some mlocked pages of test program.
It is caused that try_to_unmap_file don't check real
page mapping in vmas. 

That's because goal of address_space for file is to find all processes
into which the file's specific interval is mapped.
What I mean is that it's not related page but file's interval.

Even if the page isn't really mapping at the vma, it returns
SWAP_MLOCK since the vma have VM_LOCKED, then calls
try_to_mlock_page. After all, mlocked counter is increased again.

COWed anon page in a file-backed vma could be a such case.
This patch resolves it. 

This patch is based on 2.6.28-rc2-mm1.

-- my test program --

int main()
{
       mlockall(MCL_CURRENT);
       return 0;
}

-- before --

root@barrios-target-linux:~# cat /proc/meminfo | egrep 'Mlo|Unev'
Unevictable:           0 kB
Mlocked:               0 kB

-- after --

root@barrios-target-linux:~# cat /proc/meminfo | egrep 'Mlo|Unev'
Unevictable:           8 kB
Mlocked:               8 kB

Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Tested-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

---
 mm/rmap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1099394..bd24b55 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1080,7 +1080,8 @@ static int try_to_unmap_file(struct page *page, int unlock, int migration)
 	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		if (MLOCK_PAGES && unlikely(unlock)) {
-			if (!(vma->vm_flags & VM_LOCKED))
+			if (!((vma->vm_flags & VM_LOCKED) &&
+						page_mapped_in_vma(page, vma)))
 				continue;	/* must visit all vmas */
 			ret = SWAP_MLOCK;
 		} else {
-- 
1.5.4.3

-- 
Kinds Regards
MinChan Kim

