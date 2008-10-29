Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbYJ2N3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbYJ2N3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYJ2N32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:29:28 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:47349 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820AbYJ2N31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:29:27 -0400
Date: Wed, 29 Oct 2008 14:18:55 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][v2] blktrace: conversion to tracepoints
Message-ID: <20081029131855.GC31673@kernel.dk>
References: <20081029120556.GD28123@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029120556.GD28123@ghostprotocols.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29 2008, Arnaldo Carvalho de Melo wrote:
> Hi Jens,
> 
> 	Now that the tracepoints infrastructure is merged I updated the
> patch, please take a look.
> 
> 	One suggestion I got was to have things like:
> 
>   trace_block_unplug_io(q, q->rq.count[READ] + q->rq.count[WRITE]);
> 
> 	That was:
> 
>   blk_add_trace_pdu_int(q, BLK_TA_UNPLUG_IO, NULL,
> 	                q->rq.count[READ] + q->rq.count[WRITE]);
> 
> 	To be:
> 
>   trace_block_unplug_io(q, q->rq.count[READ], q->rq.count[WRITE]);
> 
> 	Or even:
> 
>   trace_block_unplug_io(q);
> 
> 	And on  blk_add_trace_unplug_io tracepoint do the math and feed
> it to __blk_add_trace.
> 
>         So that the information on the number of types of requests
> instead of the sum, what do you think? Overengineering? For blktrace it
> would end up being preserved as is in, say:
> 
> static void blk_add_trace_unplug_io(struct request_queue *q,
> 				    unsigned int rd, unsigned int wr)
> {
>         struct blk_trace *bt = q->blk_trace;
> 
>         if (bt) {
>                 __be64 rpdu = cpu_to_be64(rd + wr);
> 
>                 __blk_add_trace(bt, 0, 0, 0, BLK_TA_UNPLUG_IO, 0,
>                                 sizeof(rpdu), &rpdu);
>         }
> }
> 
> 	Perhaps doing it as 'trace_block_unplug_io(q)' would be the best
> scenario, as the tracepoint user can look at struct_request queue at
> will anyway and the code gets cleaner :-)
> 
> 	Feel free to point any disgusting aspect, perhaps there is at
> least one to warn me about fixing 8-)

You my as well pass the members separately now that it's a specific call
anyway, to avoid doing the calculation when tracing is disabled.

Patch looks straight forward. Perhaps it would be cleaner to use an
atomic type for the reference?

> @@ -237,6 +243,10 @@ static void blk_trace_cleanup(struct blk_trace *bt)
>  	free_percpu(bt->sequence);
>  	free_percpu(bt->msg_data);
>  	kfree(bt);
> +	mutex_lock(&blk_probe_mutex);
> +	if (--blk_probes_ref == 0)
> +		blk_unregister_tracepoints();
> +	mutex_unlock(&blk_probe_mutex);
>  }

Then this would be

        if (atomic_dec_and_test(&blk_probes_ref))
                blk_unregister_tracepoints();

>  int blk_trace_remove(struct request_queue *q)
> @@ -428,6 +438,14 @@ int do_blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
>  	bt->pid = buts->pid;
>  	bt->trace_state = Blktrace_setup;
>  
> +	mutex_lock(&blk_probe_mutex);
> +	if (!blk_probes_ref++) {
> +		ret = blk_register_tracepoints();
> +		if (ret)
> +			goto probe_err;
> +	}
> +	mutex_unlock(&blk_probe_mutex);
> +

And this would be

        if (atomic_add_return(&blk_probes_ref, 1) == 1) {
		ret = blk_register_tracepoints();
		if (ret)
			goto probe_err;
        }

-- 
Jens Axboe

