Return-Path: <linux-kernel-owner+w=401wt.eu-S1756775AbXI1UoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775AbXI1UoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867AbXI1UoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:44:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41552 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754463AbXI1UoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:44:03 -0400
Date: Fri, 28 Sep 2007 13:43:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: chakriin5@gmail.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       a.p.zijlstra@chello.nl
Subject: Re: A unresponsive file system can hang all I/O in the system on
 linux-2.6.23-rc6 (dirty_thresh problem?)
Message-Id: <20070928134326.e3bb63b1.akpm@linux-foundation.org>
In-Reply-To: <1191011538.6702.59.camel@heimdal.trondhjem.org>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	<20070927235034.ae7bd73d.akpm@linux-foundation.org>
	<1190998853.6702.17.camel@heimdal.trondhjem.org>
	<20070928114930.2c201324.akpm@linux-foundation.org>
	<1191006971.6702.25.camel@heimdal.trondhjem.org>
	<20070928122628.965137f2.akpm@linux-foundation.org>
	<1191009148.6702.46.camel@heimdal.trondhjem.org>
	<20070928131012.4a03c53e.akpm@linux-foundation.org>
	<1191011538.6702.59.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 16:32:18 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Fri, 2007-09-28 at 13:10 -0700, Andrew Morton wrote:
> > On Fri, 28 Sep 2007 15:52:28 -0400
> > Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > 
> > > On Fri, 2007-09-28 at 12:26 -0700, Andrew Morton wrote:
> > > > On Fri, 28 Sep 2007 15:16:11 -0400 Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > > > > Looking back, they were getting caught up in
> > > > > balance_dirty_pages_ratelimited() and friends. See the attached
> > > > > example...
> > > > 
> > > > that one is nfs-on-loopback, which is a special case, isn't it?
> > > 
> > > I'm not sure that the hang that is illustrated here is so special. It is
> > > an example of a bog-standard ext3 write, that ends up calling the NFS
> > > client, which is hanging. The fact that it happens to be hanging on the
> > > nfsd process is more or less irrelevant here: the same thing could
> > > happen to any other process in the case where we have an NFS server that
> > > is down.
> > 
> > hm, so ext3 got stuck in nfs via __alloc_pages direct reclaim?
> > 
> > We should be able to fix that by marking the backing device as
> > write-congested.  That'll have small race windows, but it should be a 99.9%
> > fix?
> 
> No. The problem would rather appear to be that we're doing
> per-backing_dev writeback (if I read sync_sb_inodes() correctly), but
> we're measuring variables which are global to the VM. The backing device
> that we are selecting may not be writing out any dirty pages, in which
> case, we're just spinning in balance_dirty_pages_ratelimited().

OK, so it's unrelated to page reclaim.

> Should we therefore perhaps be looking at adding per-backing_dev stats
> too?

That's what mm-per-device-dirty-threshold.patch and friends are doing. 
Whether it works adequately is not really known at this time. 
Unfortunately kernel developers don't test -mm much.  
