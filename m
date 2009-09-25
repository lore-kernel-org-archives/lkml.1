Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326AbZIYD0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbZIYD0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 23:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753235AbZIYD0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 23:26:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:10088 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226AbZIYD0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 23:26:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,449,1249282800"; 
   d="scan'208";a="191490838"
Date: Fri, 25 Sep 2009 11:26:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>,
       "hch@infradead.org" <hch@infradead.org>
Subject: Re: regression in page writeback
Message-ID: <20090925032611.GC10487@localhost>
References: <20090922175452.d66400dd.akpm@linux-foundation.org> <20090923011758.GC6382@localhost> <20090922182832.28e7f73a.akpm@linux-foundation.org> <20090923014500.GA11076@localhost> <20090922185941.1118e011.akpm@linux-foundation.org> <20090923022622.GB11918@localhost> <20090922193622.42c00012.akpm@linux-foundation.org> <20090923140058.GA2794@think> <20090924031508.GD6456@localhost> <20090924121034.GA2797@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924121034.GA2797@think>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 08:10:34PM +0800, Chris Mason wrote:
> On Thu, Sep 24, 2009 at 11:15:08AM +0800, Wu Fengguang wrote:
> 
> [ why do the bdi-writeback work? ]
> 
[snip]
> > > The congestion checks prevent any attempts from the filesystem to write
> > > a whole extent (or a large portion of an extent) at a time.
> > 
> > Since writepage is called one by one for each page, will its
> > interleaveness impact filesystem decisions? Ie. between these two
> > writepage sequences.
> > 
> >         A1, B1, A2, B2, A3, B3, A4, B4
> >         A1, A2, A3, A4, B1, B2, B3, B4
> > 
> > Where each An/Bn stands for one page of file A/B, n is page index.
> 
> For XFS this is the key question.  We're doing streaming writes, so the
> delayed allocation code is responsible for allocating extents, and this
> is triggered from writepage.  Your first example becomes:
> 
>          A1 [allocate extent A1-A50 ], submit A1
> 	 B1 [allocate extent B1-B50 ], submit B1 (seek)
> 	 A2, (seek back to A1's extent)
> 	 B2, (seek back to B1's extent)
> 	 ...
> 
> This is why the XFS graph for pdflush isn't a straight line.   When we
> back off file A and switch to file B, we seek between extents created by
> delalloc.

Does it mean XFS writeback is somehow serialized, so that the elevator
cannot do request merges well?  Hope that's not true..

> Thanks for spending time reading through all of this.  It's a ton of data
> and your improvements are much appreciated!

Thank you :)

Regards,
Fengguang
