Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYDNR10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYDNR10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 13:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbYDNR1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 13:27:17 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:25768 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148AbYDNR1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 13:27:17 -0400
Date: Mon, 14 Apr 2008 12:27:16 -0500
From: scameron@beardog.cca.cpqcorp.net
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com,
       mikem@beardog.cca.cpqcorp.net, scameron@beardog.cca.cpqcorp.net
Subject: Re: [patch] cciss: Fix race between disk-adding code and interrupt handler
Message-ID: <20080414172716.GM16584@beardog.cca.cpqcorp.net>
References: <20080414142019.GG16584@beardog.cca.cpqcorp.net> <20080414170505.GO12774@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414170505.GO12774@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On Mon, Apr 14 2008, scameron@beardog.cca.cpqcorp.net wrote:
> > 
> > 
> > Fix race condition between cciss_init_one(), cciss_update_drive_info(),
> > and cciss_check_queues().  cciss_softirq_done would try to start
> > queues which were not quite ready to be started, as its checks for
> > readiness were not sufficiently synchronized with the queue initializing
> > code in cciss_init_one and cciss_update_drive_info.  Slow cpu and
> > large numbers of logical drives seem to make the race more likely 
> > to cause a problem.
> 
> Hmm, this seems backwards to me.  cciss_softirq_done() isn't going to
> start the queues, until an irq has triggered for instance. Why isn't the
> init properly ordered instead of band-aiding around this with a
> 'queue_ready' variable?
>

Each call to add_disk() will trigger some interrupts, 
and earlier added disks may cause the queues of later,
not-yet-completely added disks to be started.

I suppose the init routine might be reorganized to initialize all
the queues, then have second loop call add_disk() for all
of them.  Is that what you had in mind by "properly ordered?"

Disks may be added at run time though, and I think this tears
down all but the first disk, and re-adds them all, if I remember
right, so there is some complication there to think about.

-- steve

On Mon, Apr 14, 2008 at 07:05:05PM +0200, Jens Axboe wrote:
> -- 
> Jens Axboe
> 
