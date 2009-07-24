Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZGXEpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZGXEpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 00:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbZGXEo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 00:44:59 -0400
Received: from cobra.newdream.net ([66.33.216.30]:39620 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbZGXEo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 00:44:58 -0400
Date: Thu, 23 Jul 2009 21:44:57 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
cc: linux-fsdevel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/19] ceph: address space operations
In-Reply-To: <1248374834.6139.13.camel@heimdal.trondhjem.org>
Message-ID: <Pine.LNX.4.64.0907231642590.2930@cobra.newdream.net>
References: <1248292313-31326-1-git-send-email-sage@newdream.net>
 <1248292313-31326-2-git-send-email-sage@newdream.net>
 <1248292313-31326-3-git-send-email-sage@newdream.net>
 <1248292313-31326-4-git-send-email-sage@newdream.net>
 <1248292313-31326-5-git-send-email-sage@newdream.net>
 <1248292313-31326-6-git-send-email-sage@newdream.net>
 <1248292313-31326-7-git-send-email-sage@newdream.net>
 <1248292313-31326-8-git-send-email-sage@newdream.net>
 <1248292313-31326-9-git-send-email-sage@newdream.net> <874ot33ddd.fsf@basil.nowhere.org>
 <Pine.LNX.4.64.0907231122070.2930@cobra.newdream.net>
 <1248374834.6139.13.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009, Trond Myklebust wrote:
> On Thu, 2009-07-23 at 11:26 -0700, Sage Weil wrote:
> > A related question I had on writepages failures: what is the 'right' thing 
> > to do if we get a server error on writeback?  If we believe it may be 
> > transient (say, ENOSPC), should we redirty pages and hope for better luck 
> > next time?
> 
> How would ENOSPC be transient? On most systems, ENOSPC requires some
> kind of user action in order to allow recovery, so will they pass the
> error back to the application.

In a distributed environment, other users may be deleting data, or the 
cluster might be expanding/rebalancing as new storage is added to the 
system.  Of course, any retry after ENOSPC should be limited to a small 
number of additional attempts.

> On the other hand, an error due to a storage element rebooting might be
> transient, and can probably be dealt with by retrying. It depends on
> what kind of contract you have with applications w.r.t. data integrity.

The general strategy with an unresponsive server is the same as NFS: just 
wait indefinitely.  (Control-c works, though.)
 
> > What if we decide it's a fatal error?
> 
> Well, the NFS client will record the error, and then pass it back to the
> application on the next write() or on close(). However this strategy
> relies partly on the fact that all NFS clients are required to flush
> pending writes to permanent storage on close().

I see.  Looking through the code, I see SetPageError(page) along with the 
end_page_writeback stuff, and the error code in the nfs_open_context.  

The part I don't understand is what actually happens to pages after the 
error flag set.  They're still uptodate, but no longer dirty?  And can be 
overwritten/redirtied?  There's also an error flag on the address_space.  
Are there any guidelines as far as which should be used?

Thanks-
sage



> 
> Cheers
>   Trond
> 
> > sage
> > 
> > 
> > On Thu, 23 Jul 2009, Andi Kleen wrote:
> > 
> > > Sage Weil <sage@newdream.net> writes:
> > > 
> > > > The ceph address space methods are concerned primarily with managing
> > > > the dirty page accounting in the inode, which (among other things)
> > > > must keep track of which snapshot context each page was dirtied in,
> > > > and ensure that dirty data is written out to the OSDs in snapshort
> > > > order.
> > > >
> > > > A writepage() on a page that is not currently writeable due to
> > > > snapshot writeback ordering constraints is ignored (it was presumably
> > > > called from kswapd).
> > > 
> > > Not a detailed review. You would need to get one from someone who
> > > knows the VFS interfaces very well (unfortunately those people are hard
> > > to find). I just read through it.
> > > 
> > > One thing I noticed is that you seem to do a lot of memory allocation
> > > in the write out paths (some of it even GFP_KERNEL, not GFP_NOFS) 
> > > 
> > > The traditional wisdom is that you should not allocate memory in block
> > > writeout, because that can deadlock. The worst case is swapfile
> > > on it, but it can happen with mmap too (e.g. one process using
> > > most memory with a file mmap from your fs)  GFP_KERNEL can also recurse,
> > > which can cause other problems in your fs.
> > > 
> > > There were some changes to make this problem less severe (e.g. better
> > > dirty pages accounting), but I don't think anyone has really declared
> > > it solved yet. The standard workaround for this is to use mempools 
> > > for anything allocated in the writeout path, then you are at least
> > > guaranteed to make forward progress.
> > > 
> > > You also had at least one unchecked kmalloc I think.
> > > 
> > > -Andi
> > > 
> > > -- 
> > > ak@linux.intel.com -- Speaking for myself only.
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
