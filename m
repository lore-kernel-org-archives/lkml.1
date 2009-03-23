Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbZCWTLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbZCWTLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbZCWTK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:10:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33407 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754726AbZCWTK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:10:59 -0400
Message-ID: <49C7DEA4.5070100@redhat.com>
Date: Mon, 23 Mar 2009 14:10:28 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       "MASON,CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: Barriers still not passing on simple dm devices...
References: <49C7DD3C.2020401@redhat.com>
In-Reply-To: <49C7DD3C.2020401@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:

(oops, get Andi's email right!)

> I've noticed that on 2.6.29-rcX, with Andi's patch
> (ab4c1424882be9cd70b89abf2b484add355712fa, dm: support barriers on
> simple devices) barriers are still getting rejected on these simple devices.
> 
> The problem is in __generic_make_request():
> 
>                 if (bio_barrier(bio) && bio_has_data(bio) &&
>                     (q->next_ordered == QUEUE_ORDERED_NONE)) {
>                         err = -EOPNOTSUPP;
>                         goto end_io;
>                 }
> 
> and dm isn't flagging its queue as supporting ordered writes, so it's
> rejected here.
> 
> Doing something like this:
> 
> + if (t->barriers_supported)
> +         blk_queue_ordered(q, QUEUE_ORDERED_DRAIN, NULL);
> 
> somewhere in dm (I stuck it in dm_table_set_restrictions() - almost
> certainly the wrong thing to do) did get my dm-linear device to mount
> with xfs, w/o xfs complaining that its mount-time barrier tests failed.
> 
> So what's the right way around this?  What should dm (or md for that
> matter) advertise on their queues about ordered-ness?  Should there be
> some sort of "QUEUE_ORDERED_PASSTHROUGH" or something to say "this level
> doesn't care, ask the next level" or somesuch?  Or should it inherit the
> flag from the next level down?  Ideas?
> 
> Thanks,
> -Eric
> 

