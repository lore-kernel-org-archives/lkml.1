Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbYBGRoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbYBGRoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYBGRnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:43:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46889 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287AbYBGRnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:43:51 -0500
Date: Thu, 7 Feb 2008 09:42:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com,
       npiggin@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@gmail.com>
Subject: Re: [patch] block layer: kmemcheck fixes
In-Reply-To: <20080207104901.GF16735@elte.hu>
Message-ID: <alpine.LFD.1.00.0802070940230.2883@woody.linux-foundation.org>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <1202375945-29525-5-git-send-email-jens.axboe@oracle.com> <20080207100738.GB7716@elte.hu> <20080207101727.GE15220@kernel.dk> <20080207102534.GB16735@elte.hu> <20080207103136.GG15220@kernel.dk>
 <20080207104901.GF16735@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Feb 2008, Ingo Molnar wrote:
>  	INIT_HLIST_NODE(&rq->hash);
>  	RB_CLEAR_NODE(&rq->rb_node);
> -	rq->ioprio = 0;
> -	rq->buffer = NULL;
> -	rq->ref_count = 1;
> -	rq->q = q;
> -	rq->special = NULL;
> -	rq->data_len = 0;
> -	rq->data = NULL;
> -	rq->nr_phys_segments = 0;
> -	rq->sense = NULL;
> -	rq->end_io = NULL;
> -	rq->end_io_data = NULL;
> -	rq->completion_data = NULL;
> -	rq->next_rq = NULL;
> +	rq->completion_data		= NULL;
> +	/* rq->elevator_private			*/
> +	/* rq->elevator_private2		*/
> +	/* rq->rq_disk				*/
> +	/* rq->start_time			*/
> +	rq->nr_phys_segments		= 0;
> +	/* rq->nr_hw_segments			*/
> +	rq->ioprio			= 0;
> +	rq->special			= NULL;
> +	rq->buffer			= NULL;
...

Can we please just stop doing these one-by-one assignments, and just do 
something like

	memset(rq, 0, sizeof(*rq));
	rq->q = q;
	rq->ref_count = 1;
	INIT_HLIST_NODE(&rq->hash);
	RB_CLEAR_NODE(&rq->rb_node);

instead?

The memset() is likely faster and smaller than one-by-one assignments 
anyway, even if the one-by-ones can avoid initializing some field or there 
ends up being a double initialization..

			Linus
