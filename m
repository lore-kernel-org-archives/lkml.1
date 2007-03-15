Return-Path: <linux-kernel-owner+w=401wt.eu-S965150AbXCOEgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965150AbXCOEgp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 00:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965149AbXCOEgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 00:36:45 -0400
Received: from ns2.suse.de ([195.135.220.15]:35762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965085AbXCOEgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 00:36:44 -0400
Date: Thu, 15 Mar 2007 05:36:42 +0100
From: Nick Piggin <npiggin@suse.de>
To: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/5] fs: introduce new aops and infrastructure
Message-ID: <20070315043642.GF15069@wotan.suse.de>
References: <20070314112529.13798.35417.sendpatchset@linux.site> <20070314112540.13798.97719.sendpatchset@linux.site> <20070315041329.GB21942@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315041329.GB21942@ca-server1.us.oracle.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 09:13:29PM -0700, Mark Fasheh wrote:
> Hi Nick,
> 
> On Wed, Mar 14, 2007 at 02:38:22PM +0100, Nick Piggin wrote:
> > Introduce write_begin, write_end, and perform_write aops.
> > 
> > These are intended to replace prepare_write and commit_write with more
> > flexible alternatives that are also able to avoid the buffered write
> > deadlock problems efficiently (which prepare_write is unable to do).
> 
> > Index: linux-2.6/include/linux/fs.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/fs.h
> > +++ linux-2.6/include/linux/fs.h
> > @@ -449,6 +449,17 @@ struct address_space_operations {
> >  	 */
> >  	int (*prepare_write)(struct file *, struct page *, unsigned, unsigned);
> >  	int (*commit_write)(struct file *, struct page *, unsigned, unsigned);
> > +
> > +	int (*write_begin)(struct file *, struct address_space *mapping,
> > +				loff_t pos, unsigned len, int intr,
> > +				struct page **pagep, void **fsdata);
> > +	int (*write_end)(struct file *, struct address_space *mapping,
> > +				loff_t pos, unsigned len, unsigned copied,
> > +				struct page *page, void *fsdata);
> 
> Are we going to get rid of the file and intr arguments btw? I'm not sure
> intr is useful, and mapping is probably enough to get whatever we inside
> ->write_begin / ->write_end.

Yeah, I was going to, but I had this version ready to go so decided
to leave them in at the last minute. We can definitely take them out
if people agree.

However a side note about intr -- I wonder if it might be wise to
include a flags argument, in case we might want to add something like
that later? (definitely if we do keep intr, then it should be done as
a flag rather than its own int).


> Also, I noticed that you didn't export block_write_begin(),
> simple_write_begin(), block_write_end() and simple_write_end() - I think we
> want those for client modules.

Yep, simple oversight on my part.


> Attached is a quick patch to hook up the existing ocfs2 write code. This has
> been compile tested only for now - one of my test machines isn't
> cooperating, so a runtime test will have to wait until tommorrow.
> 
> One interesting side effect is that we no longer pass AOP_TRUNCATE_PAGE up a
> level. This gives callers less to deal with. And it means that ocfs2 doesn't
> have to use the ocfs2_*_lock_with_page() cluster lock variants in
> ocfs2_block_write_begin() because it can order cluster locks outside of the
> page lock there.

OK that's very cool. I was hoping that would be the case. If GFS2 can
avoid that too, then we might be able to get rid of AOP_TRUNCATE_PAGE
handling from the legacy prepare/commit_write paths, which will make
them simpler.

> My ocfs2 write rework will be a more serious user of these stuff, including
> the fsdata backpointer. That code will also eliminate the entire
> ocfs2_*_lock_with_page() cluster locking workarounds for write (they'll have
> to remain for ->readpage()). I'm beginning work on cleaning those ocfs2
> patches up and getting them plugged into this stuff. I hope to post them in
> the next day or two.

OK, well I'll add this to my queue for now, and post the full patchset
after incorporating feedback I've had so far, and doing more testing,
so people can actually apply them and boot kernels.

Thanks,
Nick
