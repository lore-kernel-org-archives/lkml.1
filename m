Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbZI2Ccg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbZI2Ccg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 22:32:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZI2Ccf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 22:32:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:18730 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZI2Ccf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 22:32:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,470,1249282800"; 
   d="scan'208";a="192715727"
Date: Tue, 29 Sep 2009 10:32:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090929023227.GA20153@localhost>
References: <20090922193622.42c00012.akpm@linux-foundation.org> <20090923140058.GA2794@think> <20090924031508.GD6456@localhost> <20090925001117.GA9464@discord.disaster> <20090925003820.GK2662@think> <20090925050413.GC9464@discord.disaster> <20090925064503.GA30450@localhost> <20090928010700.GE9464@discord.disaster> <20090928071507.GA20068@localhost> <20090928130804.GA25880@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090928130804.GA25880@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 09:08:04PM +0800, Christoph Hellwig wrote:
> On Mon, Sep 28, 2009 at 03:15:07PM +0800, Wu Fengguang wrote:
> > +		if (!PageActive(page))
> > +			SetPageReclaim(page);
> > +		err = mapping->a_ops->writepage(page, wbc);
> > +		if (err < 0)
> > +			handle_write_error(mapping, page, res);
> > +		if (err == AOP_WRITEPAGE_ACTIVATE) {
> > +			ClearPageReclaim(page);
> > +			res = PAGE_ACTIVATE;
> > +			break;
> > +		}
> 
> This should help a bit for XFS as it historically does multi-page
> writeouts from ->writepages (and apprently btrfs that added some

->writepage ?

> write-around recently?) but not those brave filesystems only
> implementing the multi-page writeout from writepages as designed.

Thanks.  Just tried write_cache_pages(), looks simple. Need to further
convert all aops->writepages to support lumpy pageout :)

> But really, the best would be to leave the writeout to the flusher
> threads and just reclaim the clean pages from the VM.

Yup, that's much larger behavior change, and could be pursued as a
long term goal.

Thanks,
Fengguang
