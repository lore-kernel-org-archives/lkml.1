Return-Path: <linux-kernel-owner+w=401wt.eu-S1752199AbZIJQJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199AbZIJQJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 12:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZIJQJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 12:09:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:1869 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbZIJQJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 12:09:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="186213758"
Date: Fri, 11 Sep 2009 00:08:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Dave Chinner <david@fromorbit.com>,
       Christoph Hellwig <hch@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC][PATCH 7/7] writeback: balance_dirty_pages() shall write
	more than dirtied pages
Message-ID: <20090910160857.GA14984@localhost>
References: <20090909150601.159061863@intel.com> <20090909154413.GC7949@duck.suse.cz> <20090910014201.GB10957@localhost> <20090910125742.GH5106@think> <20090910132154.GA6446@localhost> <1252594564.7205.36.camel@laptop> <20090910151458.GA10767@localhost> <1252596698.7205.59.camel@laptop> <20090910154116.GA10856@localhost> <1252598069.7205.87.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252598069.7205.87.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 11:54:29PM +0800, Peter Zijlstra wrote:
> On Thu, 2009-09-10 at 23:41 +0800, Wu Fengguang wrote:
> > > > So btrfs_file_write() explicitly calls
> > > > balance_dirty_pages_ratelimited_nr() to get throttled.
> > > 
> > > Right, so what is wrong with than, and how does this patch fix that?
> > > 
> > > [ the only thing you have to be careful with is that you don't
> > > excessively grow the error bound on the dirty limit ]
> > 
> > Then we could form a loop:
> > 
> >         btrfs_file_write():     dirty 1024 pages
> >         balance_dirty_pages():  write up to 12 pages (= ratelimit_pages * 1.5)
> > 
> > in which the writeback rate cannot keep up with dirty rate,
> > and the dirty pages go all the way beyond dirty_thresh.
> 
> Ah, ok so this is to keep the error bound on the dirty limit bounded,
> because we can break out of balance_dirty_pages() early, the /* We've
> done our duty */ break.
> 
> Which unbalances the duty vs the dirty ratio.

Right!

> I figure that with the task dirty limit stuff we could maybe try to get
> rid of this break.. worth a try.

Be careful. Without that break, the time a task get throttled in a
single trip may go out of control. For example, task B get blocked
for 1000 seconds because there is a task A keep dirtying pages, in
the mean time task A's dirty thresh going down slowly, but still
larger than B's.

> > Sorry for writing such a vague changelog!
> 
> np, as long as we get there :-)
> 
> Change makes sense now, thanks!

May I add you ack?

Thanks,
Fengguang
