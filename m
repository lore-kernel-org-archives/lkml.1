Return-Path: <linux-kernel-owner+w=401wt.eu-S1761458AbZCaGCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761458AbZCaGCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758200AbZCaGBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:01:48 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34682 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbZCaGBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:01:47 -0400
Date: Tue, 31 Mar 2009 08:01:43 +0200
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
Message-ID: <20090331060143.GF5178@kernel.dk>
References: <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk> <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk> <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30 2009, Linus Torvalds wrote:
> 
> 
> On Mon, 30 Mar 2009, Jens Axboe wrote:
> > > 
> > > It has _nothing_ to do with 'reckless'. It has everything to do with 'you 
> > > can't do anything about it'.
> > 
> > No, but you better damn well inform of such a discovery!
> 
> Well, if that's the issue, then just add a printk to that 
> 'blkdev_issue_flush()', and now you have that informational message in 
> _one_ place, instead of havign each filesystem having to do it over and 
> over again.

Right, that's exactly what I want :-)

> > > No. Returning an error just means that now the box is useless. Nobody can 
> > > do anything about it. Not the admin, not the driver writer, not anybody. 
> > 
> > What, that's nonsense. The admin can certainly check whether it's an
> > issue or not, and he should.
> 
> If it's just informational, then again - why should the filesystem care?
> 
> Returning an error to the caller is never the right thing to do. The 
> caller can't do anything sane about it.
> 
> If you argue that the admin wants to know, then sure, make that
> 
>                 if (bio_flagged(bio, BIO_EOPNOTSUPP))
>         -               ret = -EOPNOTSUPP;
>         +               set_queue_noflush(q);
> 
> "set_queue_noflush()" function print a warning message when it sets the 
> bit.
> 
> Problem solved.
> 
> > That's different from handling it in the kernel or in the application, 
> > but you have to inform about it. I honestly cannot fathom why you don't 
> > think that is important.
> 
> I cannot fathom why you can _possibly_ think that this is something that 
> can and must be done something about in the caller. When the caller 
> obviously has no real option except to ignore the error _anyway_.
> 
> That was always my point. Returning an error is INSANE, because ther is no 
> valid thing that the caller can possibly do.
> 
> If you want it logged, fine. But THAT DOES NOT CHANGE ANYTHING. It would 
> still be wrong to return the error, since the caller _still_ can't do 
> anything about it.

I don't want to return -EOPNOTSUPP, I think this thread has become
increasingly confusing. And it's probably largely due to me mixing write
barriers into it, if we stick purely to blkdev_issue_flush(), then
logging a warning and returning 0 is perfectly fine with me. My
objection was to ignoring the "I can't flush" error in the first place,
not returning 0.

-- 
Jens Axboe

