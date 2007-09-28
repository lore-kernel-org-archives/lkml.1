Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbXI1Ucx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbXI1Ucx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 16:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155AbXI1Uce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 16:32:34 -0400
Received: from pat.uio.no ([129.240.10.15]:41264 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220AbXI1Ucb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 16:32:31 -0400
Subject: Re: A unresponsive file system can hang all I/O in the system on
	linux-2.6.23-rc6 (dirty_thresh problem?)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: chakriin5@gmail.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net,
       a.p.zijlstra@chello.nl
In-Reply-To: <20070928131012.4a03c53e.akpm@linux-foundation.org>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	 <20070927235034.ae7bd73d.akpm@linux-foundation.org>
	 <1190998853.6702.17.camel@heimdal.trondhjem.org>
	 <20070928114930.2c201324.akpm@linux-foundation.org>
	 <1191006971.6702.25.camel@heimdal.trondhjem.org>
	 <20070928122628.965137f2.akpm@linux-foundation.org>
	 <1191009148.6702.46.camel@heimdal.trondhjem.org>
	 <20070928131012.4a03c53e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 16:32:18 -0400
Message-Id: <1191011538.6702.59.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.053)
X-UiO-Scanned: 90FB5535FB90CF580650EDB7E9C38F8577B4C039
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 288 total 4179136 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 13:10 -0700, Andrew Morton wrote:
> On Fri, 28 Sep 2007 15:52:28 -0400
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > On Fri, 2007-09-28 at 12:26 -0700, Andrew Morton wrote:
> > > On Fri, 28 Sep 2007 15:16:11 -0400 Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > > > Looking back, they were getting caught up in
> > > > balance_dirty_pages_ratelimited() and friends. See the attached
> > > > example...
> > > 
> > > that one is nfs-on-loopback, which is a special case, isn't it?
> > 
> > I'm not sure that the hang that is illustrated here is so special. It is
> > an example of a bog-standard ext3 write, that ends up calling the NFS
> > client, which is hanging. The fact that it happens to be hanging on the
> > nfsd process is more or less irrelevant here: the same thing could
> > happen to any other process in the case where we have an NFS server that
> > is down.
> 
> hm, so ext3 got stuck in nfs via __alloc_pages direct reclaim?
> 
> We should be able to fix that by marking the backing device as
> write-congested.  That'll have small race windows, but it should be a 99.9%
> fix?

No. The problem would rather appear to be that we're doing
per-backing_dev writeback (if I read sync_sb_inodes() correctly), but
we're measuring variables which are global to the VM. The backing device
that we are selecting may not be writing out any dirty pages, in which
case, we're just spinning in balance_dirty_pages_ratelimited().

Should we therefore perhaps be looking at adding per-backing_dev stats
too?

Trond

