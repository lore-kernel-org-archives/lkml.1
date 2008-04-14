Return-Path: <linux-kernel-owner+w=401wt.eu-S1763284AbYDNRhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763284AbYDNRhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbYDNRh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:37:28 -0400
Received: from brick.kernel.dk ([87.55.233.238]:1721 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753336AbYDNRh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:37:27 -0400
Date: Mon, 14 Apr 2008 19:37:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: scameron@beardog.cca.cpqcorp.net
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com,
       mikem@beardog.cca.cpqcorp.net
Subject: Re: [patch] cciss: Fix race between disk-adding code and interrupt handler
Message-ID: <20080414173720.GQ12774@kernel.dk>
References: <20080414142019.GG16584@beardog.cca.cpqcorp.net> <20080414170505.GO12774@kernel.dk> <20080414172716.GM16584@beardog.cca.cpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414172716.GM16584@beardog.cca.cpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14 2008, scameron@beardog.cca.cpqcorp.net wrote:
> 
> 
> > On Mon, Apr 14 2008, scameron@beardog.cca.cpqcorp.net wrote:
> > > 
> > > 
> > > Fix race condition between cciss_init_one(), cciss_update_drive_info(),
> > > and cciss_check_queues().  cciss_softirq_done would try to start
> > > queues which were not quite ready to be started, as its checks for
> > > readiness were not sufficiently synchronized with the queue initializing
> > > code in cciss_init_one and cciss_update_drive_info.  Slow cpu and
> > > large numbers of logical drives seem to make the race more likely 
> > > to cause a problem.
> > 
> > Hmm, this seems backwards to me.  cciss_softirq_done() isn't going to
> > start the queues, until an irq has triggered for instance. Why isn't the
> > init properly ordered instead of band-aiding around this with a
> > 'queue_ready' variable?
> >
> 
> Each call to add_disk() will trigger some interrupts, 
> and earlier added disks may cause the queues of later,
> not-yet-completely added disks to be started.
> 
> I suppose the init routine might be reorganized to initialize all
> the queues, then have second loop call add_disk() for all
> of them.  Is that what you had in mind by "properly ordered?"

Yep precisely, don't call add_disk() until everything is set up.

> Disks may be added at run time though, and I think this tears
> down all but the first disk, and re-adds them all, if I remember
> right, so there is some complication there to think about.

Well, other drivers manage quite fine without resorting to work-arounds
:-)

-- 
Jens Axboe

