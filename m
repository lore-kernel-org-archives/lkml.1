Return-Path: <linux-kernel-owner+w=401wt.eu-S965199AbXCIHvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965199AbXCIHvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 02:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965267AbXCIHvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 02:51:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43917 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965199AbXCIHvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 02:51:32 -0500
Date: Fri, 9 Mar 2007 07:51:23 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/9] lguest: block device speedup
Message-ID: <20070309075123.GC8798@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>
References: <1173409524.32234.67.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173409524.32234.67.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 02:05:24PM +1100, Rusty Russell wrote:
> diff -r fdc8cbc1fd61 drivers/block/lguest_blk.c
> --- a/drivers/block/lguest_blk.c	Thu Mar 08 13:35:39 2007 +1100
> +++ b/drivers/block/lguest_blk.c	Thu Mar 08 15:51:55 2007 +1100
> @@ -45,6 +45,16 @@ struct blockdev
>  	struct request *req;
>  };
>  
> +/* Jens gave me this nice helper to end all chunks of a request. */
> +static void end_entire_request(struct request *req, int uptodate)
> +{
> +	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
> +		BUG();
> +	add_disk_randomness(req->rq_disk);
> +	blkdev_dequeue_request(req);
> +	end_that_request_last(req, uptodate);
> +}

I think we really want this in common code, ll_rw_blk.c should have:

static int __end_request(struct request *req, int uptodate,
		unsigned int sectors)
{
        if (!end_that_request_first(req, uptodate, sectors)) {
		add_disk_randomness(req->rq_disk);
		blkdev_dequeue_request(req);
		end_that_request_last(req, uptodate);
		return 1;
	}
	return 0;
}

/* TODO: add kerneldoc comment */
/* XXX: should be called end_partial_request */
void end_request(struct request *req, int uptodate)
{
	__end_request(req, uptodate, req->hard_cur_sectors);
}

/* TODO: add kerneldoc comment */
void end_entired_request(struct request *req, int uptodate)
{
	if (!__end_request(req, uptodate, req->hard_nr_sectors))
		BUG();
}

the latter two maybe as inlines
