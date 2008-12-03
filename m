Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbYLCMCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbYLCMCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYLCMCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:02:12 -0500
Received: from brick.kernel.dk ([93.163.65.50]:16630 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbYLCMCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:02:11 -0500
X-Greylist: delayed 1531 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Dec 2008 07:02:10 EST
Date: Wed, 3 Dec 2008 12:36:36 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2.6.28-rc6] block: internal dequeue shouldn't start timer
Message-ID: <20081203113636.GK18255@kernel.dk>
References: <492F6DFC.3010103@kernel.org> <20081201234529.GA14025@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201234529.GA14025@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01 2008, Mike Anderson wrote:
> Tejun Heo <tj@kernel.org> wrote:
> > blkdev_dequeue_request() and elv_dequeue_request() are equivalent and
> > both start the timeout timer.  Barrier code dequeues the original
> > barrier request but doesn't passes the request itself to lower level
> > driver, only broken down proxy requests; however, as the original
> > barrier code goes through the same dequeue path and timeout timer is
> > started on it.  If barrier sequence takes long enough, this timer
> > expires but the low level driver has no idea about this request and
> > oops follows.
> > 
> > Timeout timer shouldn't have been started on the original barrier
> > request as it never goes through actual IO.  This patch unexports
> > elv_dequeue_request(), which has no external user anyway, and makes it
> > operate on elevator proper w/o adding the timer and make
> > blkdev_dequeue_request() call elv_dequeue_request() and add timer.
> > Internal users which don't pass the request to driver - barrier code
> > and end_that_request_last() - are converted to use
> > elv_dequeue_request().
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
> > ---
> > Mike, this should fix the problem you were seeing (blk_add_timer on
> > requests w/o REQ_STARTED set).
> > 
> 
> Yes this fixed the "w/o REQ_STARTED" error I was seeing on a distro kernel
> and a mainline system. 

Thanks Tejun, this makes sense. I'll make sure it goes upstream asap.

-- 
Jens Axboe

