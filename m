Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbXIWNCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbXIWNCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 09:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbXIWNCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 09:02:41 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:39248 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753302AbXIWNCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 09:02:40 -0400
Date: Sun, 23 Sep 2007 15:02:35 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Hugh Dickins <hugh@veritas.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       spamtrap@knobisoft.de
Subject: Re: 2.6.23-rc6-mm1 -- mkfs stuck in 'D'
Message-ID: <20070923150235.284b49bf@twins>
In-Reply-To: <390510451.02278@ustc.edu.cn>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	<20070919164348.GC2519@shadowen.org>
	<Pine.LNX.4.64.0709192035370.14804@blonde.wat.veritas.com>
	<20070919224409.24baa75b@lappy>
	<Pine.LNX.4.64.0709201210470.13752@blonde.wat.veritas.com>
	<390426111.11400@ustc.edu.cn>
	<20070922151622.711178e2@lappy>
	<390510451.02278@ustc.edu.cn>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Sep 2007 09:20:49 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn>
wrote:

> On Sat, Sep 22, 2007 at 03:16:22PM +0200, Peter Zijlstra wrote:
> > On Sat, 22 Sep 2007 09:55:09 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn>
> > wrote:
> > 
> > > --- linux-2.6.22.orig/mm/page-writeback.c
> > > +++ linux-2.6.22/mm/page-writeback.c
> > > @@ -426,6 +426,14 @@ static void balance_dirty_pages(struct a
> > >  			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
> > >  		}
> > >  
> > > +		printk(KERN_DEBUG "balance_dirty_pages written %lu %lu congested %d limits %lu %lu %lu %lu %lu %ld\n",
> > > +				pages_written,
> > > +				write_chunk - wbc.nr_to_write,
> > > +				bdi_write_congested(bdi),
> > > +				background_thresh, dirty_thresh,
> > > +				bdi_thresh, bdi_nr_reclaimable, bdi_nr_writeback,
> > > +				bdi_thresh - bdi_nr_reclaimable - bdi_nr_writeback);
> > > +
> > >  		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
> > >  			break;
> > >  		if (pages_written >= write_chunk)
> > > 
> > 
> > > [ 1305.361511] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
> > 
> > <snip long series of mostly identical lines>
> > 
> > Could you perhaps instrument the writeback_inodes() path to see why
> > nothing is written out? - the attached patch would be a nice start.
> 
> Curiously the lockup problem disappeared after upgrading to 2.6.23-rc6-mm1.
> (need to watch it in a longer time window).
> 
> Anyway here's the output of your patch:
>         sb_locked 0
>         sb_empty 97011

It this the delta during one of these lockups? If so, it would seem
that although dirty pages are reported against the BDI, no actual dirty
inodes could be found.

[ note to self: writeback_inodes() seems to write out to any superblock
  in the system. Might want to limit that to superblocks on wbc->bdi ]

You say that switching to .23-rc6-mm1 solved it in your case. You are
developing in the writeback_inodes() path, right? Could it be one of
your local changes that confused it here?

> > Most peculiar. It seems writeback_inodes() doesn't even attempt to
> > write out stuff. Nor are outstanding writeback pages completed.
> 
> Still true. Another problem is that balance_dirty_pages() is being called even
> when there are only 54 dirty pages. That could slow down writers unnecessarily.
> 
> balance_dirty_pages() should not be entered at all with small nr_dirty.
> 
> Look at these lines:
> [  197.471619] balance_dirty_pages for tar written 405 405 congested 0 global 196554 54 403 196097 bdi 0 0 398 -398
> [  197.472196] balance_dirty_pages for tar written 405 0 congested 0 global 196554 54 372 196128 bdi 0 0 380 -380
> [  197.472893] balance_dirty_pages for tar written 405 0 congested 0 global 196554 54 372 196128 bdi 23 0 369 -346
> [  197.473158] balance_dirty_pages for tar written 405 0 congested 0 global 196554 54 372 196128 bdi 23 0 366 -343
> [  197.473403] balance_dirty_pages for tar written 405 0 congested 0 global 196554 54 372 196128 bdi 23 0 365 -342
> [  197.473674] balance_dirty_pages for tar written 405 0 congested 0 global 196554 54 372 196128 bdi 23 0 364 -341
> [  197.474265] balance_dirty_pages for tar written 405 0 congested 0 global 196554 54 372 196128 bdi 23 0 362 -339
> [  197.475440] balance_dirty_pages for tar written 405 0 congested 0 global 196554 54 341 196159 bdi 47 0 327 -280
> [  197.476970] balance_dirty_pages for tar written 405 0 congested 0 global 196546 54 279 196213 bdi 95 0 279 -184
> [  197.477773] balance_dirty_pages for tar written 405 0 congested 0 global 196546 54 248 196244 bdi 95 0 255 -160
> [  197.479463] balance_dirty_pages for tar written 405 0 congested 0 global 196546 54 217 196275 bdi 143 0 210 -67
> [  197.479656] balance_dirty_pages for tar written 405 0 congested 0 global 196546 54 217 196275 bdi 143 0 209 -66
> [  197.481159] balance_dirty_pages for tar written 405 0 congested 0 global 196546 54 155 196337 bdi 167 0 163 4

That is an interesting idea how about this:

---
Subject: mm: speed up writeback ramp-up on clean systems

We allow violation of bdi limits if there is a lot of room on the
system. Once we hit half the total limit we start enforcing bdi limits
and bdi ramp-up should happen. Doing it this way avoids many small
writeouts on an otherwise idle system and should also speed up the
ramp-up.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c
+++ linux-2.6/mm/page-writeback.c
@@ -355,8 +355,8 @@ get_dirty_limits(long *pbackground, long
  */
 static void balance_dirty_pages(struct address_space *mapping)
 {
-	long bdi_nr_reclaimable;
-	long bdi_nr_writeback;
+	long nr_reclaimable, bdi_nr_reclaimable;
+	long nr_writeback, bdi_nr_writeback;
 	long background_thresh;
 	long dirty_thresh;
 	long bdi_thresh;
@@ -376,9 +376,24 @@ static void balance_dirty_pages(struct a
 
 		get_dirty_limits(&background_thresh, &dirty_thresh,
 				&bdi_thresh, bdi);
+
+		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
+					global_page_state(NR_UNSTABLE_NFS);
+		nr_writeback = global_page_state(NR_WRITEBACK);
+
 		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
 		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
-		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
+
+		/*
+		 * break out early when:
+		 *  - we're below the bdi limit
+		 *  - we're below half the total limit
+		 *
+		 * we let the numbers exceed the strict bdi limit if the total
+		 * numbers are too low, this avoids (excessive) small writeouts.
+		 */
+		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh ||
+		    nr_reclaimable + nr_writeback < dirty_thresh / 2)
 			break;
 
 		if (!bdi->dirty_exceeded)
