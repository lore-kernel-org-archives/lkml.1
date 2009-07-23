Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZGWSrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZGWSrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbZGWSrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:47:19 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:39922 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbZGWSrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:47:18 -0400
Subject: Re: [PATCH 08/19] ceph: address space operations
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0907231122070.2930@cobra.newdream.net>
References: <1248292313-31326-1-git-send-email-sage@newdream.net>
	 <1248292313-31326-2-git-send-email-sage@newdream.net>
	 <1248292313-31326-3-git-send-email-sage@newdream.net>
	 <1248292313-31326-4-git-send-email-sage@newdream.net>
	 <1248292313-31326-5-git-send-email-sage@newdream.net>
	 <1248292313-31326-6-git-send-email-sage@newdream.net>
	 <1248292313-31326-7-git-send-email-sage@newdream.net>
	 <1248292313-31326-8-git-send-email-sage@newdream.net>
	 <1248292313-31326-9-git-send-email-sage@newdream.net>
	 <874ot33ddd.fsf@basil.nowhere.org>
	 <Pine.LNX.4.64.0907231122070.2930@cobra.newdream.net>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 14:47:14 -0400
Message-Id: <1248374834.6139.13.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 4 msgs/h 1 sum rcpts/h 7 sum msgs/h 1 total rcpts 944 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: DF9458A2CFE152E573A4E708FB92A320E1801DF6
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 86 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-23 at 11:26 -0700, Sage Weil wrote:
> A related question I had on writepages failures: what is the 'right' thing 
> to do if we get a server error on writeback?  If we believe it may be 
> transient (say, ENOSPC), should we redirty pages and hope for better luck 
> next time?

How would ENOSPC be transient? On most systems, ENOSPC requires some
kind of user action in order to allow recovery, so will they pass the
error back to the application.

On the other hand, an error due to a storage element rebooting might be
transient, and can probably be dealt with by retrying. It depends on
what kind of contract you have with applications w.r.t. data integrity.

> What if we decide it's a fatal error?

Well, the NFS client will record the error, and then pass it back to the
application on the next write() or on close(). However this strategy
relies partly on the fact that all NFS clients are required to flush
pending writes to permanent storage on close().

Cheers
  Trond

> sage
> 
> 
> On Thu, 23 Jul 2009, Andi Kleen wrote:
> 
> > Sage Weil <sage@newdream.net> writes:
> > 
> > > The ceph address space methods are concerned primarily with managing
> > > the dirty page accounting in the inode, which (among other things)
> > > must keep track of which snapshot context each page was dirtied in,
> > > and ensure that dirty data is written out to the OSDs in snapshort
> > > order.
> > >
> > > A writepage() on a page that is not currently writeable due to
> > > snapshot writeback ordering constraints is ignored (it was presumably
> > > called from kswapd).
> > 
> > Not a detailed review. You would need to get one from someone who
> > knows the VFS interfaces very well (unfortunately those people are hard
> > to find). I just read through it.
> > 
> > One thing I noticed is that you seem to do a lot of memory allocation
> > in the write out paths (some of it even GFP_KERNEL, not GFP_NOFS) 
> > 
> > The traditional wisdom is that you should not allocate memory in block
> > writeout, because that can deadlock. The worst case is swapfile
> > on it, but it can happen with mmap too (e.g. one process using
> > most memory with a file mmap from your fs)  GFP_KERNEL can also recurse,
> > which can cause other problems in your fs.
> > 
> > There were some changes to make this problem less severe (e.g. better
> > dirty pages accounting), but I don't think anyone has really declared
> > it solved yet. The standard workaround for this is to use mempools 
> > for anything allocated in the writeout path, then you are at least
> > guaranteed to make forward progress.
> > 
> > You also had at least one unchecked kmalloc I think.
> > 
> > -Andi
> > 
> > -- 
> > ak@linux.intel.com -- Speaking for myself only.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


