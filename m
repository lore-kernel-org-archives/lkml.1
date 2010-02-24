Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab0BXP7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 10:59:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54468 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756886Ab0BXP7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 10:59:07 -0500
Date: Wed, 24 Feb 2010 10:59:05 -0500 (EST)
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
In-Reply-To: <20100223221635.GP1025@kernel.dk>
Message-ID: <Pine.LNX.4.44L0.1002241051470.2436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, Jens Axboe wrote:

> > > And that's back to the question of whether or not that is a nice thing to
> > > do. It seems a bit dirty, but otoh where else to do it. Perhaps just
> > > using the kblockd to postpone the del_gendisk() to out-of-resume context
> > > would be the best approach.
> > 
> > That would involve a layering violation, wouldn't it?  Either the 
> > driver would have to interface with kblockd directly, or else 
> > del_gendisk() would need to know whether the writeback task was frozen.
> > 
> > On the whole, I think it's best for the block layer to retain full
> > control over its own tasks and requirements.
> 
> You would export such functionality - del_gendisk_deferred(), or
> something like that. The kblockd suggestion was implementation detail,
> not something the driver would concern itself with. It's not exactly
> picture perfect, but it could be used from eg resume context where the
> device isn't fully live yet.

Hmm.  There's still no way for the driver to know whether or not the
writeback task is frozen when it wants to call del_gendisk().  It
would have to defer _all_ such calls.  And all hot-pluggable block
drivers would have to do this -- would that be acceptable?

How about plugging the request queue instead of freezing the writeback 
task?  Would that work?  It should be easy enough for a driver to 
unplug the queue before unregistering its device from within a resume 
method.

Alan Stern

