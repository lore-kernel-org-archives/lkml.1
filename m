Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab0CBKgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 05:36:52 -0500
Received: from cantor.suse.de ([195.135.220.2]:41302 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab0CBKgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 05:36:50 -0500
Date: Tue, 2 Mar 2010 21:36:46 +1100
From: Nick Piggin <npiggin@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
 due to "e084b - page-allocator: preserve PFN ordering when __GFP_COLD is
 set"
Message-ID: <20100302103646.GF8653@laptop>
References: <4B796C6D.80800@linux.vnet.ibm.com>
 <20100216112517.GE1194@csn.ul.ie>
 <4B7ACC1E.9080205@linux.vnet.ibm.com>
 <4B7BBCFC.4090101@linux.vnet.ibm.com>
 <20100218114310.GC32626@csn.ul.ie>
 <4B7D664C.20507@linux.vnet.ibm.com>
 <4B7E73BF.5030901@linux.vnet.ibm.com>
 <20100219151934.GA1445@csn.ul.ie>
 <20100302065225.GC8653@laptop>
 <20100302100402.GH3852@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302100402.GH3852@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 10:04:02AM +0000, Mel Gorman wrote:
> On Tue, Mar 02, 2010 at 05:52:25PM +1100, Nick Piggin wrote:
> > The zone pressure waitqueue patch makes sense.
> 
> I've just started the rebase and considering what sort of test is best
> for it.
> 
> > We may even want to make
> > it more strictly FIFO (eg. check upfront if there are waiters on the
> > queue before allocating a page, and if yes then add ourself to the back
> > of the waitqueue).
> 
> To be really strict about this, we'd have to check in the hot-path of the
> per-cpu allocator which would be undesirable.

Yes, but it would also be desirable for other reasons (eliminating
all unnecessary latency here). Which is why I say it is a tradeoff
but it might be worthwhile.

We obviously wouldn't load the waitqueue itself in the fastpath, but
probably some field in a cacheline we already touch.


> We could check further in the
> slow-path but I bet it'd be very rare that the logic would be triggered. For
> a process to enter the FIFO due to waiters that were not yet woken up, the
> system would have to be a) under heavy memory pressure b) reclaim taking such
> a long time that check_zone_pressure() is not being called in time and c)
> a process exiting or otherwise freeing memory such that the watermarks are
> cleared without reclaim being involved.

I don't think it would be too rare. Things can get freed up and
other allocations come in while reclaim is happening. But anyway
the nasty thing about the "rare" events is that they do add a
rare source of unexpected latency or starvation.

I'm not saying necessarily that it will make a noticable improvement
to throughput for this test case, but that now that we have the
waitqueue there, we should think about exactly how far we want to
go with it.


