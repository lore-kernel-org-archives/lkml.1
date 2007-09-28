Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbXI1SuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbXI1SuS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbXI1SuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:50:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50695 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751636AbXI1SuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:50:04 -0400
Date: Fri, 28 Sep 2007 11:49:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Chakri n <chakriin5@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: A unresponsive file system can hang all I/O in the system on
 linux-2.6.23-rc6 (dirty_thresh problem?)
Message-Id: <20070928114930.2c201324.akpm@linux-foundation.org>
In-Reply-To: <1190998853.6702.17.camel@heimdal.trondhjem.org>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	<20070927235034.ae7bd73d.akpm@linux-foundation.org>
	<1190998853.6702.17.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 13:00:53 -0400 Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> On Thu, 2007-09-27 at 23:50 -0700, Andrew Morton wrote:
> 
> > Actually we perhaps could address this at the VFS level in another way. 
> > Processes which are writing to the dead NFS server will eventually block in
> > balance_dirty_pages() once they've exceeded the memory limits and will
> > remain blocked until the server wakes up - that's the behaviour we want.
> > 
> > What we _don't_ want to happen is for other processes which are writing to
> > other, non-dead devices to get collaterally blocked.  We have patches which
> > might fix that queued for 2.6.24.  Peter?
> 
> Do these patches also cause the memory reclaimers to steer clear of
> devices that are congested (and stop waiting on a congested device if
> they see that it remains congested for a long period of time)? Most of
> the collateral blocking I see tends to happen in memory allocation...
> 

No, they don't attempt to do that, but I suspect they put in place
infrastructure which could be used to improve direct-reclaimer latency.  In
the throttle_vm_writeout() path, at least.

Do you know where the stalls are occurring?  throttle_vm_writeout(), or via
direct calls to congestion_wait() from page_alloc.c and vmscan.c?  (running
sysrq-w five or ten times will probably be enough to determine this)

