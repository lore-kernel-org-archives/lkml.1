Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbZBBGQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbZBBGQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 01:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZBBGQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 01:16:39 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:59393 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbZBBGQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 01:16:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=WXyMH97USuJsTX8tT9yJKaXd6pxx5agAm+3m8fINdz9+3DdihrBWiY5gm8+NKoBBaR
         pEmaUviN2fDIXIiNmhoPlig+KCKvtktYe5Ppz1ZmjSSu77spwk9PczUwn+jXUhzkAj7t
         I2BrPsOVc6bP1l8ZyzJjhIO2GTAUhSlu07gwY=
Date: Mon, 2 Feb 2009 15:16:22 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: linux mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH] fix mlocked page counter mismatch
Message-ID: <20090202061622.GA13286@barrios-desktop>
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

This patch is based on 2.6.28-rc2-mm1.

-- my test program --

#include <stdio.h>
#include <sys/mman.h>
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


--

diff --git a/mm/rmap.c b/mm/rmap.c
index 1099394..9ba1fdf 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1073,6 +1073,9 @@ static int try_to_unmap_file(struct page *page, int unlock, int migration)
 	unsigned long max_nl_size = 0;
 	unsigned int mapcount;
 	unsigned int mlocked = 0;
+	unsigned long address;
+	pte_t *pte;
+	spinlock_t *ptl;
 
 	if (MLOCK_PAGES && unlikely(unlock))
 		ret = SWAP_SUCCESS;	/* default for try_to_munlock() */
@@ -1089,6 +1092,13 @@ static int try_to_unmap_file(struct page *page, int unlock, int migration)
 				goto out;
 		}
 		if (ret == SWAP_MLOCK) {
+     address = vma_address(page, vma);
+     if (address != -EFAULT) {
+       pte = page_check_address(page, vma->vm_mm, address, &ptl, 0);
+       if (!pte)
+            continue; 
+       pte_unmap_unlock(pte, ptl);
+     } 
 			mlocked = try_to_mlock_page(page, vma);
 			if (mlocked)
 				break;  /* stop if actually mlocked page */



-- 
Kinds Regards
MinChan Kim

