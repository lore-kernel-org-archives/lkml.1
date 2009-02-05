Return-Path: <linux-kernel-owner+w=401wt.eu-S1761107AbZBEAhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107AbZBEAhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757006AbZBEAhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:37:36 -0500
Received: from ti-out-0910.google.com ([209.85.142.186]:41790 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761374AbZBEAhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:37:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=M28EoydJFGy4SGO4861cw7muo9XNK2bFWgYyUmf6qET5gHy3eO5ki1jlt7al+ZAwMQ
         4BFxGpK1KNGuK2g/UHNBc2gafpeqKJmsLZYC0LcULMRhhFKFXZN/lf8Ws/JfzHkqq3kl
         B3PQ4dEeN08tCTqeIgaYWy2qlsRjlr40qYrjc=
Date: Thu, 5 Feb 2009 09:37:00 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux mm <linux-mm@kvack.org>
Subject: [PATCH v2][RESEND] fix mlocked page counter mismatch
Message-ID: <20090205003700.GA26618@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will resend this patch with Kosaki-san's ACK.

-- 

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
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
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

