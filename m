Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbXKQVa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbXKQVa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 16:30:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbXKQVas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 16:30:48 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:35955 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbXKQVaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 16:30:46 -0500
Date: Sat, 17 Nov 2007 21:24:01 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Erez Zadok <ezk@cs.sunysb.edu>
cc: Dave Hansen <haveblue@us.ibm.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Ryan Finnie <ryan@finnie.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, cjwatson@ubuntu.com, linux-mm@kvack.org
Subject: Re: msync(2) bug(?), returns AOP_WRITEPAGE_ACTIVATE to userland 
In-Reply-To: <200711131018.lADAInYN017695@agora.fsl.cs.sunysb.edu>
Message-ID: <Pine.LNX.4.64.0711172103040.10619@blonde.wat.veritas.com>
References: <200711131018.lADAInYN017695@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007, Erez Zadok wrote:
> 
> I posted all of these patches just now.  You're CC'ed.  Hopefully Andrew can
> pull from my unionfs.git branch soon.
> 
> You also reported in your previous emails some hangs/oopses while doing make
> -j 20 in unionfs on top of a single tmpfs, using -mm.  After several days,
> I've not been able to reproduce this w/ my latest set of patches.  If you
> can send me your .config and the specs on the h/w you're using (cpus, mem,
> etc.), I'll see if I can find something similar to it on my end and run the
> same tests.

I'm glad to report that this unionfs, not the one in 2.6.24-rc2-mm1
but the one including those 9 patches you posted, now gets through
my testing with tmpfs without a problem.  I do still get occasional
"unionfs: new lower inode mtime (bindex=0, name=<directory>)"
messages, but nothing worse seen yet: a big improvement.

I deceived myself for a while that the danger of shmem_writepage
hitting its BUG_ON(entry->val) was dealt with too; but that's wrong,
I must go back to working out an escape from that one (despite never
seeing it).

I did think you could clean up the doubled set_page_dirtys,
but it's of no consequence.

Hugh

--- 2.6.24-rc2-mm1+9/fs/unionfs/mmap.c	2007-11-17 12:23:30.000000000 +0000
+++ linux/fs/unionfs/mmap.c	2007-11-17 20:22:29.000000000 +0000
@@ -56,6 +56,7 @@ static int unionfs_writepage(struct page
 	copy_highpage(lower_page, page);
 	flush_dcache_page(lower_page);
 	SetPageUptodate(lower_page);
+	set_page_dirty(lower_page);
 
 	/*
 	 * Call lower writepage (expects locked page).  However, if we are
@@ -66,12 +67,11 @@ static int unionfs_writepage(struct page
 	 * success.
 	 */
 	if (wbc->for_reclaim) {
-		set_page_dirty(lower_page);
 		unlock_page(lower_page);
 		goto out_release;
 	}
+
 	BUG_ON(!lower_mapping->a_ops->writepage);
-	set_page_dirty(lower_page);
 	clear_page_dirty_for_io(lower_page); /* emulate VFS behavior */
 	err = lower_mapping->a_ops->writepage(lower_page, wbc);
 	if (err < 0)
