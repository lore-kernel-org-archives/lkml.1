Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbXL2Fvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbXL2Fvb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 00:51:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXL2FvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 00:51:21 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:49586 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751144AbXL2FvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 00:51:21 -0500
Message-ID: <398907485.23658@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 29 Dec 2007 13:51:13 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] jfs: clear PAGECACHE_TAG_DIRTY for no-write pages
References: <E1J8AC5-0002BE-RP@localhost> <1198841626.6821.92.camel@twins> <1198859101.13075.10.camel@norville.austin.ibm.com> <1198860794.13075.15.camel@norville.austin.ibm.com> <E1J8RJw-0001ge-DP@localhost> <1198903859.6353.7.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198903859.6353.7.camel@norville.austin.ibm.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.17 (2007-11-01)
Message-Id: <E1J8UbJ-0007Be-E3@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 10:50:59PM -0600, Dave Kleikamp wrote:
> 
> On Sat, 2007-12-29 at 10:21 +0800, Fengguang Wu wrote:
> > On Fri, Dec 28, 2007 at 10:53:14AM -0600, Dave Kleikamp wrote:
> > 
> > 
> > > ---
> > > 
> > > diff -Nurp linux-2.6.24-rc6-git5/fs/jfs/jfs_metapage.c linux/fs/jfs/jfs_metapage.c
> > > --- linux-2.6.24-rc6-git5/fs/jfs/jfs_metapage.c	2007-12-28 10:28:33.000000000 -0600
> > > +++ linux/fs/jfs/jfs_metapage.c	2007-12-28 10:37:30.000000000 -0600
> > > @@ -360,6 +360,7 @@ static int metapage_writepage(struct pag
> > >  	struct metapage *mp;
> > >  	int redirty = 0;
> > >  	sector_t lblock;
> > > +	int nr_underway = 0;
> > >  	sector_t pblock;
> > >  	sector_t next_block = 0;
> > >  	sector_t page_start;
> > > @@ -371,6 +372,7 @@ static int metapage_writepage(struct pag
> > >  		     (PAGE_CACHE_SHIFT - inode->i_blkbits);
> > >  	BUG_ON(!PageLocked(page));
> > >  	BUG_ON(PageWriteback(page));
> > 
> > This line should be moved below:
> > > +	set_page_writeback(page);
> 
> No.  set_page_writeback() needs to be called before submit_bio() is
> called.

Ah yes.

> I don't think there is any harm in calling set_page_writeback(),
> redirty_page_for_writeback() and end_page_writeback() in the case where
> there is no I/O to submit, and some dirty data cannot be written.  It is
> consistent with what happens in __block_write_full_page().
> 
> It's also possible that some part of the page was written, and another
> part cannot be, causing the page to be redirtied.

You are right. I revisited the code and there's nothing wrong with
your patch :-)

Regards,
Fengguang

