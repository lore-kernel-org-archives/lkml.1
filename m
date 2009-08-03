Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbZHCJeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbZHCJeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZHCJea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:34:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:9850 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbZHCJe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:34:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,313,1246863600"; 
   d="scan'208";a="171637864"
Date: Mon, 3 Aug 2009 17:34:26 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>, Neil Brown <neilb@suse.de>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
Subject: Re: Why does __do_page_cache_readahead submit READ, not READA?
Message-ID: <20090803093426.GA25139@localhost>
References: <20090729161456.GB8059@barkeeper1-xen.linbit> <20090729211845.GB4148@kernel.dk> <20090729225501.GH24801@think> <20090730060649.GC4148@kernel.dk> <20090803075202.GA13485@localhost> <20090803075933.GI12579@kernel.dk> <20090803082318.GA18731@localhost> <20090803092515.GK12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803092515.GK12579@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 05:25:15PM +0800, Jens Axboe wrote:
> On Mon, Aug 03 2009, Wu Fengguang wrote:
> > On Mon, Aug 03, 2009 at 03:59:33PM +0800, Jens Axboe wrote:
> > > On Mon, Aug 03 2009, Wu Fengguang wrote:
> > > > On Thu, Jul 30, 2009 at 08:06:49AM +0200, Jens Axboe wrote:
> > > > > > > read at that level. I did some experimentation some time ago for
> > > > > > > flagging this, see:
> > > > > > > 
> > > > > > > http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=16cfe64e3568cda412b3cf6b7b891331946b595e
> > > > > > > 
> > > > > > > which should pass down READA properly.
> > > > > > 
> > > > > > One of the problems in the past was that reada would fail if there
> > > > > > wasn't a free request when we actually wanted it to go ahead and wait.
> > > > > > Or something.  We've switched it around a few times I think.
> > > > > 
> > > > > Yes, we did used to do that, whether it was 2.2 or 2.4 I
> > > > > don't recall :-)
> > > > > 
> > > > > It should be safe to enable know, whether there's a prettier way
> > > > > than the above, I don't know. It works by detecting the read-ahead
> > > > > marker, but it's a bit of a fragile design.
> > > > 
> > > > Another consideration is io-priority reversion and the overheads
> > > > required to avoid it:
> > > > 
> > > >         readahead(pages A-Z)    => READA IO for pages A-Z
> > > >         <short time later>
> > > >         read(page A) => blocked => find the request that contains page A
> > > >                                    and requeue/kick it as READ IO
> > > > 
> > > > The page-to-request lookups are not always required but nevertheless
> > > > the complexity and overheads won't be trivial.
> > > > 
> > > > The page-to-request lookup feature would be also useful for "advanced"
> > > > features like io-canceling (if implemented, hwpoison could be its
> > > > first user ;)
> > > 
> > > I added that 3-4 years ago or so, to experiment with in-kernel
> > > cancellation for things like truncate(). Tracking pages is not cheap,
> > > and since the write cancelling wasn't really very sucessful, I didn't go
> > > ahead with it.
> > 
> > Ah OK.
> > 
> > > So I'm not sure it's a viable alternative, even if we restricted it to
> > > just tracking READA's, for instance.
> > 
> > Kind of agreed. I guess it won't benefit too much workloads to default
> > to READA; for most workloads it would be pure overheads if considering
> > priority inversion.
> > 
> > > But I don't think we have any priority inversion to worry about, at
> > > least not from the CFQ perspective.
> > 
> > The priority inversion problem showed up in an early attempt to do
> > boot time prefetching. I guess this problem was somehow circumvented
> > by limiting the prefetch depth and do prefetches in original read
> > order instead of disk location order (Arjan cc'ed).
> 
> But was that not due to the prefetcher running at a lower cpu priority?

Yes, it is. Thus the priority inversion problem.

> Just flagging a reada hint will not change your priority in the IO
> scheduler, so we should have no priority inversion there.

Ah OK. So READA merely means "don't try hard on error" for now.
Sorry I implicitly associated it with some priority class..

Thanks,
Fengguang
