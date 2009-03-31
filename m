Return-Path: <linux-kernel-owner+w=401wt.eu-S1757120AbZCaRLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120AbZCaRLv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 13:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756818AbZCaRLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 13:11:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57535 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756707AbZCaRLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 13:11:40 -0400
Date: Tue, 31 Mar 2009 09:57:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: Ric Wheeler <rwheeler@redhat.com>,
       =?ISO-8859-15?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@infradead.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
Subject: Re: [PATCH 1/7] block: Add block_flush_device()
In-Reply-To: <20090331164312.GP5178@kernel.dk>
Message-ID: <alpine.LFD.2.00.0903310953310.4093@localhost.localdomain>
References: <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain> <49D17CA2.5060105@redhat.com>
 <alpine.LFD.2.00.0903301931230.4093@localhost.localdomain> <49D1FB64.8000505@redhat.com> <alpine.LFD.2.00.0903310746460.4093@localhost.localdomain> <49D239A0.5080405@redhat.com> <alpine.LFD.2.00.0903310854570.4093@localhost.localdomain>
 <20090331164312.GP5178@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Mar 2009, Jens Axboe wrote:
> 
> So here's a test patch that attempts to just ignore such a failure to
> flush the caches.

I suspect you should not do it like this.

> diff --git a/fs/bio.c b/fs/bio.c
> index a040cde..79e3cec 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -1380,7 +1380,17 @@ void bio_check_pages_dirty(struct bio *bio)
>   **/
>  void bio_endio(struct bio *bio, int error)
>  {
> -	if (error)
> +	/*
> +	 * Special case here - hide the -EOPNOTSUPP from the driver or
> +	 * block layer, dump a warning the first time this happens so that
> +	 * the admin knows that we may not provide the ordering guarantees
> +	 * that are needed. Don't clear the uptodate bit.
> +	 */
> +	if (error == -EOPNOTSUPP && bio_barrier(bio)) {
> +		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
> +		blk_queue_set_noflush(bio->bi_bdev);
> +		error = 0;
> +	} else if (error)

I suspect this part is just wrong.

I could easily imagine a driver that returns EOPNOTSUPP only for a certain 
_kind_ of bio.

For example, if the drive doesn't support FUA, then you cannot do a 
serialized IO operation, but you can still mostly do a serialized op 
without any IO attached to it.

IOW, the "empty flush" really _is_ special. An this check should not be in 
the generic "bio_endio()" case, it should only be in the special 
blkdev_issue_flush() case.

I think. No?

		Linus
