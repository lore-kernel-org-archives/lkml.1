Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbZISPjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbZISPjx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 11:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZISPjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 11:39:52 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:57475 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZISPjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 11:39:52 -0400
Message-ID: <4AB4F74E.7000908@ce.jp.nec.com>
Date: Sun, 20 Sep 2009 00:22:54 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>,
       Mike Snitzer <snitzer@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [dm-devel] [PATCH 1/3] block: Add blk_queue_copy_limits()
References: <4AB3B43D.9000802@ce.jp.nec.com> <yq1eiq46ohz.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1eiq46ohz.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "Jun'ichi" == Jun'ichi Nomura <j-nomura@ce.jp.nec.com> writes:
> 
> +	if (q->limits.max_sectors == 0 || q->limits.max_hw_sectors == 0)
> +		blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
> 
> I'm really not keen on perpetuating SAFE_MAX_SECTORS for something that
> was written in this millennium.
> 
> I'd much rather we just do this, then:
> 
> block: Set max_sectors correctly for stacking devices
> 
> The topology changes unintentionally caused SAFE_MAX_SECTORS to be set
> for stacking devices.  Set the default limit to BLK_DEF_MAX_SECTORS and
> provide SAFE_MAX_SECTORS in blk_queue_make_request() for legacy hw
> drivers that depend on the old behavior.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> ---
> 
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 83413ff..cd9b730 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -111,7 +111,7 @@ void blk_set_default_limits(struct queue_limits *lim)
>  	lim->max_hw_segments = MAX_HW_SEGMENTS;
>  	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
>  	lim->max_segment_size = MAX_SEGMENT_SIZE;
> -	lim->max_sectors = lim->max_hw_sectors = SAFE_MAX_SECTORS;
> +	lim->max_sectors = lim->max_hw_sectors = BLK_DEF_MAX_SECTORS;

Umm, with this, BLK_DEF_MAX_SECTORS becomes upper bound of max_hw_sectors
and the values of underlying devices are not propagated to the stacking
devices.
Is it intended?

>  	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
>  	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
>  	lim->alignment_offset = 0;
> @@ -164,6 +164,7 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
>  	q->unplug_timer.data = (unsigned long)q;
>  
>  	blk_set_default_limits(&q->limits);
> +	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
>  
>  	/*
>  	 * If the caller didn't supply a lock, fall back to our embedded

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
