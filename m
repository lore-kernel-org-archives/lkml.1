Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963Ab0BXUTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:19:15 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37663 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757580Ab0BXUTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:19:14 -0500
Date: Wed, 24 Feb 2010 15:19:13 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <jens.axboe@oracle.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
In-Reply-To: <20100224191213.GH1025@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1002241509210.1253-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Feb 2010, Jens Axboe wrote:

> > How about plugging the request queue instead of freezing the writeback 
> > task?  Would that work?  It should be easy enough for a driver to 
> > unplug the queue before unregistering its device from within a resume 
> > method.
> 
> We have specific methods for either freezing of stopping or starting the
> queue, perhaps those would be appropriate for suspend/resume actions. It
> effectively prevents the queueing function from being called. If there
> are dirty pages for the device, then it would not help though, as you
> would still get stuck waiting for that IO to complete.

If the resume method would restart the queue before unregistering the
device, pending dirty pages wouldn't cause any problems.  They'd get
sent down to the driver and rejected immediately because the device was
dead or done.

The difficulty with this approach is that it requires individual
attention for each block device driver.  Either the driver has to
freeze/stop/plug the queue during suspend (and restart it during
resume) or else the device's writeback task has to be frozen.

Can this be encapsulated by a function in the block layer?  For
example, drivers could call blk_set_hot_unpluggable(bdev) for devices
that might need to be unregistered during resume.  Then they would
become responsible for managing the device's queue.

Alan Stern

