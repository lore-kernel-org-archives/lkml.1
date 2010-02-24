Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757615Ab0BXTMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 14:12:16 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49735 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757364Ab0BXTMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:12:14 -0500
Date: Wed, 24 Feb 2010 20:12:13 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
	userspace is frozen?
Message-ID: <20100224191213.GH1025@kernel.dk>
References: <20100223221635.GP1025@kernel.dk> <Pine.LNX.4.44L0.1002241051470.2436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1002241051470.2436-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24 2010, Alan Stern wrote:
> On Tue, 23 Feb 2010, Jens Axboe wrote:
> 
> > > > And that's back to the question of whether or not that is a nice thing to
> > > > do. It seems a bit dirty, but otoh where else to do it. Perhaps just
> > > > using the kblockd to postpone the del_gendisk() to out-of-resume context
> > > > would be the best approach.
> > > 
> > > That would involve a layering violation, wouldn't it?  Either the 
> > > driver would have to interface with kblockd directly, or else 
> > > del_gendisk() would need to know whether the writeback task was frozen.
> > > 
> > > On the whole, I think it's best for the block layer to retain full
> > > control over its own tasks and requirements.
> > 
> > You would export such functionality - del_gendisk_deferred(), or
> > something like that. The kblockd suggestion was implementation detail,
> > not something the driver would concern itself with. It's not exactly
> > picture perfect, but it could be used from eg resume context where the
> > device isn't fully live yet.
> 
> Hmm.  There's still no way for the driver to know whether or not the
> writeback task is frozen when it wants to call del_gendisk().  It
> would have to defer _all_ such calls.  And all hot-pluggable block
> drivers would have to do this -- would that be acceptable?

I was assuming it knew it was being called from a critical location,
like from resume. I guess the callback just iterates the bus devices and
calls the device remove, so that doesn't quite work without other
changes.

> How about plugging the request queue instead of freezing the writeback 
> task?  Would that work?  It should be easy enough for a driver to 
> unplug the queue before unregistering its device from within a resume 
> method.

We have specific methods for either freezing of stopping or starting the
queue, perhaps those would be appropriate for suspend/resume actions. It
effectively prevents the queueing function from being called. If there
are dirty pages for the device, then it would not help though, as you
would still get stuck waiting for that IO to complete.

-- 
Jens Axboe

