Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbYAKMOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbYAKMOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759299AbYAKMO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:14:26 -0500
Received: from brick.kernel.dk ([87.55.233.238]:21107 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759150AbYAKMOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:14:25 -0500
Date: Fri, 11 Jan 2008 13:14:21 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oakad@exemail.com.au, linux-kernel@vger.kernel.org,
       Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] [MEMSTICK] Initial commit for Sony MemoryStick support
Message-ID: <20080111121420.GS6258@kernel.dk>
References: <1199256144-1019-1-git-send-email-oakad@exemail.com.au> <20080110010049.695da076.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110010049.695da076.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10 2008, Andrew Morton wrote:
> > +static void mspro_block_request(struct request_queue *q)
> > +{
> > +	struct memstick_dev *card = q->queuedata;
> > +	struct mspro_block_data *msb = memstick_get_drvdata(card);
> > +	struct request *req = NULL;
> > +
> > +	if (!msb->q_thread) {
> > +		for (req = elv_next_request(q); req;
> > +		     req = elv_next_request(q)) {
> > +			while (end_that_request_chunk(req, -ENODEV,
> > +						      req->current_nr_sectors
> > +						      << 9)) {}
> > +			end_that_request_last(req, -ENODEV);
> > +		}
> > +	} else {
> > +		msb->has_request = 1;
> > +		wake_up_all(&msb->q_wait);
> > +	}
> > +}
> 
> Suggest that you cc Jens on this, see if he can check it all over.

It's suboptimal and doesn't work for non-fs request. Just use
end_queued_request() instead:

if (msb->q_thread) {
        msb->has_request = 1;
        wake_up(&msb->q_wait);
} else {
        while ((req = elv_next_request(q)) != NULL)
                end_queued_request(req, -ENODEV);
}

which is simpler and gets all cases correct. Reordering for normal case
as well.

-- 
Jens Axboe

