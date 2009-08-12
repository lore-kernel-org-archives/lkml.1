Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbZHLCQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbZHLCQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 22:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755491AbZHLCQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 22:16:22 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:62152 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbZHLCQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 22:16:21 -0400
Message-ID: <4A8225DC.1060200@ct.jp.nec.com>
Date: Wed, 12 Aug 2009 11:15:56 +0900
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Nikanth Karthikesan <knikanth@suse.de>
CC: Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH-v2 2/2] Initialize mempool and elevator only for request-based
 dm devices
References: <200908081026.01097.knikanth@suse.de> <200908101618.21060.knikanth@suse.de> <4A812680.7040804@ct.jp.nec.com> <200908111435.12020.knikanth@suse.de>
In-Reply-To: <200908111435.12020.knikanth@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikanth,

On 08/11/2009 06:05 PM +0900, Nikanth Karthikesan wrote:
> On Tuesday 11 August 2009 13:36:24 Kiyoshi Ueda wrote:
>> On 08/10/2009 07:48 PM +0900, Nikanth Karthikesan wrote:
>>> +
>>> +		/*
>>> +		 * reinitialize make_request_fn as it was reset to the
>>> +		 * default __make_request by blk_init_allocate_queue
>>> +		 */
>>> +		md->saved_make_request_fn = md->queue->make_request_fn;
>>> +		blk_queue_make_request(md->queue, dm_request);
>>> +
>>> +		blk_queue_softirq_done(md->queue, dm_softirq_done);
>>> +		blk_queue_prep_rq(md->queue, dm_prep_fn);
>>> +		blk_queue_lld_busy(md->queue, dm_lld_busy);
>>> +	}
>>> +
>>>  	__unbind(md);
>>>  	r = __bind(md, table, &limits);
>> The queue has been registered at the device creation time by
>> add_disk() in alloc_dev().
>> Since the queue is reconfigured (elevator is attached), you have to
>> update the queue registration (e.g. unregister, then re-register).
>> But it may not be easy.  At least, there is no exported interface to
>> unregister/re-register queue.
> 
> Ah, yes. The scheduler attributes will not be exported in 
> /sys/block/dm*/queue/iosched. Exporting elv_register_queue() and calling it 
> here solves it. Something like..
> 
> @@ -2203,6 +2199,29 @@ int dm_swap_table(struct mapped_device *md, struct 
> dm_table *table)
>  		goto out;
>  	}
>  
> +	/* new device is being marked as request-based */
> +	if (!md->map && dm_table_request_based(table)) {
> +		/* initialize queue for request-based dm */
> +		r = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
> +		if (r)
> +			goto out;
> +
> +		r = elv_register_queue(md->queue);
> +		/* if (r)
> +		 *	 goto out; Better to ignore, just like add_disk does ;-)
> +		 */
> +		/*
> +		 * reinitialize make_request_fn as it was reset to the
> +		 * default __make_request by blk_init_allocate_queue
> +		 */
> +		md->saved_make_request_fn = md->queue->make_request_fn;
> +		blk_queue_make_request(md->queue, dm_request);
> +
> +		blk_queue_softirq_done(md->queue, dm_softirq_done);
> +		blk_queue_prep_rq(md->queue, dm_prep_fn);
> +		blk_queue_lld_busy(md->queue, dm_lld_busy);
> +	}
> +
>  	__unbind(md);
>  	r = __bind(md, table, &limits);
>  
> I would post the v3 of the patches with this change. Do you see any problems 
> in this?

Humm, it might work for now, but I disagree with that.

Since elevator is block internal and dm doesn't really care
(its initialization is actually hidden in blk_init_allocated_queue()),
directly calling elv_register_queue() from dm seems not right.
It will likely introduce a bug by future changes in block layer.

I think the right approach is to define a proper block layer interface
to reflect the queue configuration change.
That's why I said "Updating the queue registration may not be easy".

Thanks,
Kiyoshi Ueda

