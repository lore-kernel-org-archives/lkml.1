Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbXIWBVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbXIWBVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 21:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXIWBUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 21:20:55 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:54327 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752194AbXIWBUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 21:20:53 -0400
Message-ID: <390510451.02278@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sun, 23 Sep 2007 09:20:49 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Hugh Dickins <hugh@veritas.com>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       spamtrap@knobisoft.de
Subject: Re: 2.6.23-rc6-mm1 -- mkfs stuck in 'D'
Message-ID: <20070923012049.GA6010@mail.ustc.edu.cn>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070919164348.GC2519@shadowen.org> <Pine.LNX.4.64.0709192035370.14804@blonde.wat.veritas.com> <20070919224409.24baa75b@lappy> <Pine.LNX.4.64.0709201210470.13752@blonde.wat.veritas.com> <390426111.11400@ustc.edu.cn> <20070922151622.711178e2@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070922151622.711178e2@lappy>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2007 at 03:16:22PM +0200, Peter Zijlstra wrote:
> On Sat, 22 Sep 2007 09:55:09 +0800 Fengguang Wu <wfg@mail.ustc.edu.cn>
> wrote:
> 
> > --- linux-2.6.22.orig/mm/page-writeback.c
> > +++ linux-2.6.22/mm/page-writeback.c
> > @@ -426,6 +426,14 @@ static void balance_dirty_pages(struct a
> >  			bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
> >  		}
> >  
> > +		printk(KERN_DEBUG "balance_dirty_pages written %lu %lu congested %d limits %lu %lu %lu %lu %lu %ld\n",
> > +				pages_written,
> > +				write_chunk - wbc.nr_to_write,
> > +				bdi_write_congested(bdi),
> > +				background_thresh, dirty_thresh,
> > +				bdi_thresh, bdi_nr_reclaimable, bdi_nr_writeback,
> > +				bdi_thresh - bdi_nr_reclaimable - bdi_nr_writeback);
> > +
> >  		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
> >  			break;
> >  		if (pages_written >= write_chunk)
> > 
> 
> > [ 1305.361511] balance_dirty_pages written 0 0 congested 0 limits 48869 195477 5801 5760 288 -247
> 
> <snip long series of mostly identical lines>
> 
> Could you perhaps instrument the writeback_inodes() path to see why
> nothing is written out? - the attached patch would be a nice start.

Curiously the lockup problem disappeared after upgrading to 2.6.23-rc6-mm1.
(need to watch it in a longer time window).

Anyway here's the output of your patch:
        sb_locked 0
        sb_empty 97011

> Most peculiar. It seems writeback_inodes() doesn't even attempt to
> write out stuff. Nor are outstanding writeback pages completed.

Still true. Another problem is that balance_dirty_pages() is being called even
when there are only 54 dirty pages. That could slow down writers unnecessarily.

balance_dirty_pages() should not be entered at all with small nr_dirty.

Look at these lines:
[  197.471619] balance_dirty_pages for tar written 405 405 congested 0 global 196554 54 403 196097 bdi 0 0 398 -398
[  197.472196] balance_dirty_pages for tar written 405 0 congested 0 global 196554 54 372 196128 bdi 0 0 380 -380
[  197.472893] balance_dirty_pages for tar written 405 0 congested 0 global 196554 54 372 196128 bdi 23 0 369 -346
[  197.473158] balance_dirty_pages for tar written 405 0 congested 0 global 196554 54 372 196128 bdi 23 0 366 -343
[  197.473403] balance_dirty_pages for tar written 405 0 congested 0 global 196554 54 372 196128 bdi 23 0 365 -342
[  197.473674] balance_dirty_pages for tar written 405 0 congested 0 global 196554 54 372 196128 bdi 23 0 364 -341
[  197.474265] balance_dirty_pages for tar written 405 0 congested 0 global 196554 54 372 196128 bdi 23 0 362 -339
[  197.475440] balance_dirty_pages for tar written 405 0 congested 0 global 196554 54 341 196159 bdi 47 0 327 -280
[  197.476970] balance_dirty_pages for tar written 405 0 congested 0 global 196546 54 279 196213 bdi 95 0 279 -184
[  197.477773] balance_dirty_pages for tar written 405 0 congested 0 global 196546 54 248 196244 bdi 95 0 255 -160
[  197.479463] balance_dirty_pages for tar written 405 0 congested 0 global 196546 54 217 196275 bdi 143 0 210 -67
[  197.479656] balance_dirty_pages for tar written 405 0 congested 0 global 196546 54 217 196275 bdi 143 0 209 -66
[  197.481159] balance_dirty_pages for tar written 405 0 congested 0 global 196546 54 155 196337 bdi 167 0 163 4

The trace messages are generated by the following code:

--- linux-2.6.23-rc6-mm1.orig/mm/page-writeback.c
+++ linux-2.6.23-rc6-mm1/mm/page-writeback.c
@@ -421,6 +421,18 @@ static void balance_dirty_pages(struct a
                        bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
                }

+               printk(KERN_DEBUG "balance_dirty_pages for %s written %lu %lu congested %d "
+                               "global %lu %lu %lu %ld bdi %lu %lu %lu %ld\n",
+                               current->comm,
+                               pages_written, write_chunk - wbc.nr_to_write,
+                               bdi_write_congested(bdi),
+                               dirty_thresh,
+                               global_dirty_unstable_pages(), global_page_state(NR_WRITEBACK),
+                               dirty_thresh -
+                               global_dirty_unstable_pages() - global_page_state(NR_WRITEBACK),
+                               bdi_thresh, bdi_nr_reclaimable, bdi_nr_writeback,
+                               bdi_thresh - bdi_nr_reclaimable - bdi_nr_writeback);
+               
                if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
                        break;
                if (pages_written >= write_chunk)


