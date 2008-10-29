Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYJ2Pv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYJ2Pv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 11:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbYJ2PvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 11:51:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33835 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbYJ2PvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 11:51:13 -0400
Date: Wed, 29 Oct 2008 13:50:56 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v2] blktrace: conversion to tracepoints
Message-ID: <20081029155056.GE28123@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20081029120556.GD28123@ghostprotocols.net> <20081029131855.GC31673@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029131855.GC31673@kernel.dk>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 29, 2008 at 02:18:55PM +0100, Jens Axboe escreveu:
> On Wed, Oct 29 2008, Arnaldo Carvalho de Melo wrote:
> > Hi Jens,
> > 
> > 	Now that the tracepoints infrastructure is merged I updated the
> > patch, please take a look.
> > 
> > 	One suggestion I got was to have things like:
> > 
> >   trace_block_unplug_io(q, q->rq.count[READ] + q->rq.count[WRITE]);
> > 
> > 	That was:
> > 
> >   blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_IO, NULL,
> > 	                q->rq.count[READ] + q->rq.count[WRITE]);
> > 
> > 	To be:
> > 
> >   trace_block_unplug_io(q, q->rq.count[READ], q->rq.count[WRITE]);
> > 
> > 	Or even:
> > 
> >   trace_block_unplug_io(q);
> > 
> > 	And on  blk_add_trace_unplug_io tracepoint do the math and feed
> > it to __blk_add_trace.
> > 
> >         So that the information on the number of types of requests
> > instead of the sum, what do you think? Overengineering? For blktrace it
> > would end up being preserved as is in, say:
> > 
> > static void blk_add_trace_unplug_io(struct request_queue *q,
> > 				    unsigned int rd, unsigned int wr)
> > {
> >         struct blk_trace *bt = q->blk_trace;
> > 
> >         if (bt) {
> >                 __be64 rpdu = cpu_to_be64(rd + wr);
> > 
> >                 __blk_add_trace(bt, 0, 0, 0, BLK_TA_UNPLUG_IO, 0,
> >                                 sizeof(rpdu), &rpdu);
> >         }
> > }
> > 
> > 	Perhaps doing it as 'trace_block_unplug_io(q)' would be the best
> > scenario, as the tracepoint user can look at struct_request queue at
> > will anyway and the code gets cleaner :-)
> > 
> > 	Feel free to point any disgusting aspect, perhaps there is at
> > least one to warn me about fixing 8-)
> 
> You my as well pass the members separately now that it's a specific call
> anyway, to avoid doing the calculation when tracing is disabled.
> 
> Patch looks straight forward. Perhaps it would be cleaner to use an
> atomic type for the reference?

I'll do that now and repost, thanks,

- Arnaldo
