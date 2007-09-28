Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940AbXI1T2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbXI1T2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751613AbXI1T1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:27:54 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49812 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbXI1T1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:27:54 -0400
Date: Fri, 28 Sep 2007 12:26:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Chakri n <chakriin5@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: A unresponsive file system can hang all I/O in the system on
 linux-2.6.23-rc6 (dirty_thresh problem?)
Message-Id: <20070928122628.965137f2.akpm@linux-foundation.org>
In-Reply-To: <1191006971.6702.25.camel@heimdal.trondhjem.org>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	<20070927235034.ae7bd73d.akpm@linux-foundation.org>
	<1190998853.6702.17.camel@heimdal.trondhjem.org>
	<20070928114930.2c201324.akpm@linux-foundation.org>
	<1191006971.6702.25.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 15:16:11 -0400 Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Fri, 2007-09-28 at 11:49 -0700, Andrew Morton wrote:
> > On Fri, 28 Sep 2007 13:00:53 -0400 Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > > Do these patches also cause the memory reclaimers to steer clear of
> > > devices that are congested (and stop waiting on a congested device if
> > > they see that it remains congested for a long period of time)? Most of
> > > the collateral blocking I see tends to happen in memory allocation...
> > > 
> > 
> > No, they don't attempt to do that, but I suspect they put in place
> > infrastructure which could be used to improve direct-reclaimer latency.  In
> > the throttle_vm_writeout() path, at least.
> > 
> > Do you know where the stalls are occurring?  throttle_vm_writeout(), or via
> > direct calls to congestion_wait() from page_alloc.c and vmscan.c?  (running
> > sysrq-w five or ten times will probably be enough to determine this)
> 
> Looking back, they were getting caught up in
> balance_dirty_pages_ratelimited() and friends. See the attached
> example...

that one is nfs-on-loopback, which is a special case, isn't it?

NFS on loopback used to hang, but then we fixed it.  It looks like we
broke it again sometime in the intervening four years or so.
