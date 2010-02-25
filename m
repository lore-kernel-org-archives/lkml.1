Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934244Ab0BYWTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:19:11 -0500
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:44797 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934167Ab0BYWTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:19:09 -0500
Date: Fri, 26 Feb 2010 09:19:04 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Testing for dirty buffers on a block device
Message-ID: <20100225221904.GN16175@discord.disaster>
References: <20100224190942.GG1025@kernel.dk> <Pine.LNX.4.44L0.1002241503300.1253-100000@iolanthe.rowland.org> <20100225082035.GR1025@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100225082035.GR1025@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 09:20:35AM +0100, Jens Axboe wrote:
> On Wed, Feb 24 2010, Alan Stern wrote:
> > On Wed, 24 Feb 2010, Jens Axboe wrote:
> > 
> > > > > But if you wanted, I guess the only way would be to lookup
> > > > > dirty/writeback pages on the bdev inode mapping. For that you'd need the
> > > > > bdev, not the gendisk or the queue though.
> > > > 
> > > > I can get the bdev from the gendisk by calling bdget_disk() with a 
> > > > partition number of 0, right?  What would the next step be?  Would this 
> > > > check for dirty pages associated with any of the partitions or would it 
> > > > only look at pages associated with the inode for the entire disk?
> > > 
> > > It would cover the entire bdev.
> > 
> > Okay, so once I've got the bdev, how do I look up the dirty/writeback 
> > pages on the inode mapping?
> 
> I _think_ you can get away with not doing a radix lookup for dirty
> pages, just looking at the BDI_RECLAIMABLE stat on the bdi. That would
> be:
> 
> bdi_stat(bdev->bd_inode->i_mapping->backing_dev_info, BDI_RECLAIMABLE);

mapping_tagged(bdev->bd_inode->i_mapping, PAGECACHE_TAG_DIRTY);

is about as low overhead as it gets as the radix tree propagateѕ
tags back up to the root. i.e. no page lookups needed at all to
determine if it is dirty.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
