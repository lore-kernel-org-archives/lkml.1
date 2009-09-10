Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZIJANS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZIJANS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 20:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbZIJANS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 20:13:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:1609 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbZIJANR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 20:13:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185940956"
Date: Thu, 10 Sep 2009 08:13:06 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>, jack@suse.cz,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC][PATCH 5/7] writeback: use 64MB MAX_WRITEBACK_PAGES
Message-ID: <20090910001306.GA6693@localhost>
References: <20090909145141.293229693@intel.com> <20090909150600.874037375@intel.com> <20090909232938.GD24951@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909232938.GD24951@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 07:29:38AM +0800, Theodore Tso wrote:
> On Wed, Sep 09, 2009 at 10:51:46PM +0800, Wu Fengguang wrote:
> > + * The maximum number of pages to writeout in a single periodic/background
> > + * writeback operation. 64MB means I_SYNC may be hold for up to 1 second.
> > + * This is not a big problem since we normally do kind of trylock on I_SYNC
> > + * for non-data-integrity writes.  Userspace tasks doing throttled writeback
> > + * do not use this value.
> 
> What's your justification for using 64MB?  Where are you getting 1
> second from?  On a fast RAID array 64MB can be written in much less
> than 1 second.

Because this value will be used for desktop and server alike, we have
to consider the worst case - for a laptop, it takes about 1 second to
write 64MB. It's not accurate to say I_SYNC may be hold for up to 1
second, but the same I_SYNC will be taken, dropped because of
congestion, retaken, and this loop could go on for 1 second until a
large file have been written 64MB. In the mean while, in the normal
case of a single kupdate thread per bdi, that file blocks writeout of
other files for 1 second.

> More generally, I assume your patches conflict with Jens' per-bdi patches?

It is based on latest linux-next tree with the vm.max_writeback_mb
patch reverted. The changelog only states the need to increase the
size, but not mentioned why it should be made tunable. So I tend to
just bump up MAX_WRITEBACK_PAGES. It seems that a large value won't
hurt anyone. Or are there demand to further increase it a lot for some
server configurations?

Thanks,
Fengguang
