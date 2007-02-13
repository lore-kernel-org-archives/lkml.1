Return-Path: <linux-kernel-owner+w=401wt.eu-S1750971AbXBMUSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971AbXBMUSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbXBMUR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:17:59 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:10996 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbXBMUR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:17:58 -0500
Date: Tue, 13 Feb 2007 12:12:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>, tony.luck@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Hugh Dickins <hugh@veritas.com>
Subject: [patch] build error: allnoconfig fails on mincore/swapper_space
Message-Id: <20070213121217.0f4e9f3a.randy.dunlap@oracle.com>
In-Reply-To: <45D12715.4070408@yahoo.com.au>
References: <20070212145040.c3aea56e.randy.dunlap@oracle.com>
	<20070212150802.f240e94f.akpm@linux-foundation.org>
	<45D12715.4070408@yahoo.com.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007 13:48:53 +1100 Nick Piggin wrote:

> Andrew Morton wrote:
> >>On Mon, 12 Feb 2007 14:50:40 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >>2.6.20-git8 on x86_64:
> >>
> >>
> >>  LD      init/built-in.o
> >>  LD      .tmp_vmlinux1
> >>mm/built-in.o: In function `sys_mincore':
> >>(.text+0xe584): undefined reference to `swapper_space'
> >>make: *** [.tmp_vmlinux1] Error 1
> > 
> > 
> > oops.  CONFIG_SWAP=n,  I assume?
> > 
> 
> Hmm, OK. Hugh can strip me of my bonus point now...
> 
> Hugh, you can strip me of my bonus point now... How about your other
> suggestion to just remove the stats from lookup_swap_cache? (and should
> we also rename it to find_get_swap_page?)

I need a fix for this.  It's killing my daily/automated builds.
So here is an ifdeffery-fix.

BUT:  what is <present> used for in that loop?  or is it used?

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Don't check for pte swap entries when CONFIG_SWAP=n.

mm/built-in.o: In function `sys_mincore':
(.text+0xe584): undefined reference to `swapper_space'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 mm/mincore.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2.6.20-git8.orig/mm/mincore.c
+++ linux-2.6.20-git8/mm/mincore.c
@@ -111,6 +111,7 @@ static long do_mincore(unsigned long add
 			present = mincore_page(vma->vm_file->f_mapping, pgoff);
 
 		} else { /* pte is a swap entry */
+#ifdef CONFIG_SWAP
 			swp_entry_t entry = pte_to_swp_entry(pte);
 			if (is_migration_entry(entry)) {
 				/* migration entries are always uptodate */
@@ -119,6 +120,9 @@ static long do_mincore(unsigned long add
 				pgoff = entry.val;
 				present = mincore_page(&swapper_space, pgoff);
 			}
+#else
+			present = 0;
+#endif
 		}
 	}
 	pte_unmap_unlock(ptep-1, ptl);
