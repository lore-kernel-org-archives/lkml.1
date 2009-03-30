Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbZC3Rz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbZC3Rz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 13:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbZC3Rzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 13:55:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50800 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbZC3Rzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 13:55:48 -0400
Date: Mon, 30 Mar 2009 19:55:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
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
Message-ID: <20090330175544.GX5178@kernel.dk>
References: <20090326032445.GA16999@havoc.gtf.org> <20090327205046.GA2036@havoc.gtf.org> <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30 2009, Linus Torvalds wrote:
> 
> 
> On Mon, 30 Mar 2009, Fernando Luis Vázquez Cao wrote:
> > +	int ret = 0;
> > +
> > +	ret = blkdev_issue_flush(bdev, NULL);
> > +
> > +	return (ret == -EOPNOTSUPP) ? 0 : ret;
> 
> Btw, why do we do that silly EOPNOTSUPP at all?
> 
> If the device doesn't support flushing, we should
> 
>  - set a flag in the device saying so, and not ever try to flush again on
>    that device (who knows how long it took for the device to say "I can't
>    do this"? We don't want to keep on doing it)
> 
>  - return "done". There's nothing sane the caller can do with the error
>    code anyway, it just has to assume that the device basically doesn't
>    reorder writes.
> 
> So wouldn't it be better to just fix blkdev_issue_flush() to not do those
> crazy error codes?

The problem is that we may not know upfront, so it sort-of has to be
this trial approach where the first barrier issued will notice and fail
with -EOPNOTSUPP. Sure, we could cache this value, but it's pretty
pointless since the filesystem will stop sending barriers in this case.
As it also modifed fs behaviour, we need to pass the info back.

For blkdev_issue_flush() it may not be very interesting, since there's
not much we can do about that. Just seems like very bad style to NOT
return an error in such a case. You can assume that ordering is fine,
but it definitely wont be in all case (eg devices that have write back
caching on by default and don't support flush). So the nice thing to do
there is actually tell the caller about it. So the same error is reused
as we do for actualy write barriers that have data attached.

> [ The same thing probably goes for those ENXIO errors, btw. If we don't
>   have a bd_disk or a queue, why would the caller care about it? ]

Right, that is pretty pointless.

-- 
Jens Axboe

