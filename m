Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbYFJDNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbYFJDNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 23:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758447AbYFJDN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 23:13:26 -0400
Received: from ns1.suse.de ([195.135.220.2]:52129 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001AbYFJDNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 23:13:25 -0400
Date: Mon, 9 Jun 2008 20:11:09 -0700
From: Greg KH <gregkh@suse.de>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kay Sievers <kay.sievers@vrfy.org>, Neil Brown <neilb@suse.de>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in
	blk_lookup_devt()/prepare_namespace()
Message-ID: <20080610031109.GE6796@suse.de>
References: <20080609020623.b6727f2b.akpm@linux-foundation.org> <19f34abd0806090209l541d93c6jaba2704314b34418@mail.gmail.com> <20080609133426.GB20194@cs181133002.pp.htv.fi> <19f34abd0806090658v54f3a912n2ed30ad6cc20d00@mail.gmail.com> <19f34abd0806090728s3b3fdbeq7dd3d31d02c8f28e@mail.gmail.com> <20080609165757.184724ff@gondolin.boeblingen.de.ibm.com> <alpine.LFD.1.10.0806090819410.3473@woody.linux-foundation.org> <20080609153856.GA5149@elte.hu> <alpine.LFD.1.10.0806090858310.3473@woody.linux-foundation.org> <20080609191521.1a56b6a6@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609191521.1a56b6a6@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 07:15:21PM +0200, Cornelia Huck wrote:
> On Mon, 9 Jun 2008 09:15:40 -0700 (PDT),
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > And this is all still ignoring the locking issue, of course. It would be 
> > trivial to just remove the block_class_lock, and change
> > 
> > 	mutex_[un]lock(&block_class_lock);
> > 
> > into
> > 
> > 	down|up(&block_class.sem);
> > 
> > except for _one_ case, which is
> > 
> > 	bdev_map = kobj_map_init(base_probe, &block_class_lock);
> > 
> > which really wants a mutex, not a sempahore.
> > 
> > So to fix that, we'd need to make the class->sem be a mutex, and pass that 
> > in. Which is probably a good change too, but makes the whole thing much 
> > bigger.
> 
> The driver core changes in -next convert class->sem to
> class->p->class_mutex, which makes it non-accessible to drivers.
> Most of the locking is easily done through converting to the class
> iterator functions, but there are some cases where this is not going to
> work:
> 
> - The {register,unregister}_blkdev() functions, which don't directly
> involve the class.
> - The iterators for /proc/partitions, which take the lock in
> part_start() and give it up again in part_stop().
> 
> Maybe we need a possibilty for a driver to lock a class from outside?

Why would that be needed?  We protect walking the class lists internally
with the lock, that should be sufficient, right?

thanks,

greg k-h
