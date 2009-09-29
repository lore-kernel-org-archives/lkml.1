Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZI2OAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZI2OAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZI2OAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:00:48 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:62106 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbZI2OAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:00:47 -0400
Date: Tue, 29 Sep 2009 10:00:07 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090929140007.GP6405@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Li, Shaohua" <shaohua.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
	"jens.axboe@oracle.com" <jens.axboe@oracle.com>
References: <20090923140058.GA2794@think>
 <20090924031508.GD6456@localhost>
 <20090925001117.GA9464@discord.disaster>
 <20090925003820.GK2662@think>
 <20090925050413.GC9464@discord.disaster>
 <20090925064503.GA30450@localhost>
 <20090928010700.GE9464@discord.disaster>
 <20090928071507.GA20068@localhost>
 <20090928130804.GA25880@infradead.org>
 <20090929023227.GA20153@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929023227.GA20153@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt003.oracle.com [141.146.116.12]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4AC212F3.00CE:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 10:32:27AM +0800, Wu Fengguang wrote:
> On Mon, Sep 28, 2009 at 09:08:04PM +0800, Christoph Hellwig wrote:
> > On Mon, Sep 28, 2009 at 03:15:07PM +0800, Wu Fengguang wrote:
> > > +		if (!PageActive(page))
> > > +			SetPageReclaim(page);
> > > +		err = mapping->a_ops->writepage(page, wbc);
> > > +		if (err < 0)
> > > +			handle_write_error(mapping, page, res);
> > > +		if (err == AOP_WRITEPAGE_ACTIVATE) {
> > > +			ClearPageReclaim(page);
> > > +			res = PAGE_ACTIVATE;
> > > +			break;
> > > +		}
> > 
> > This should help a bit for XFS as it historically does multi-page
> > writeouts from ->writepages (and apprently btrfs that added some
> 
> ->writepage ?
> 
> > write-around recently?) but not those brave filesystems only
> > implementing the multi-page writeout from writepages as designed.
> 
> Thanks.  Just tried write_cache_pages(), looks simple. Need to further
> convert all aops->writepages to support lumpy pageout :)
> 
> > But really, the best would be to leave the writeout to the flusher
> > threads and just reclaim the clean pages from the VM.
> 
> Yup, that's much larger behavior change, and could be pursued as a
> long term goal.

I don't think we can just change kswapd to wait on flusher thread
progress because the flusher thread can happily spend forever writing
pages that can't actually be freed.  Lumpy pageout is a better middle
ground I think.

-chris

