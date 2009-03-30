Return-Path: <linux-kernel-owner+w=401wt.eu-S1761241AbZC3UtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241AbZC3UtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZC3UtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:49:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52069 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753584AbZC3UtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:49:06 -0400
Date: Mon, 30 Mar 2009 13:36:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: =?ISO-8859-15?Q?Fernando_Luis_V=E1zquez_Cao?= 
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
In-Reply-To: <20090330201732.GB5178@kernel.dk>
Message-ID: <alpine.LFD.2.00.0903301331320.4093@localhost.localdomain>
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk>
 <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain> <20090330201732.GB5178@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Mar 2009, Jens Axboe wrote:
> > 
> > It has _nothing_ to do with 'reckless'. It has everything to do with 'you 
> > can't do anything about it'.
> 
> No, but you better damn well inform of such a discovery!

Well, if that's the issue, then just add a printk to that 
'blkdev_issue_flush()', and now you have that informational message in 
_one_ place, instead of havign each filesystem having to do it over and 
over again.

> > No. Returning an error just means that now the box is useless. Nobody can 
> > do anything about it. Not the admin, not the driver writer, not anybody. 
> 
> What, that's nonsense. The admin can certainly check whether it's an
> issue or not, and he should.

If it's just informational, then again - why should the filesystem care?

Returning an error to the caller is never the right thing to do. The 
caller can't do anything sane about it.

If you argue that the admin wants to know, then sure, make that

                if (bio_flagged(bio, BIO_EOPNOTSUPP))
        -               ret = -EOPNOTSUPP;
        +               set_queue_noflush(q);

"set_queue_noflush()" function print a warning message when it sets the 
bit.

Problem solved.

> That's different from handling it in the kernel or in the application, 
> but you have to inform about it. I honestly cannot fathom why you don't 
> think that is important.

I cannot fathom why you can _possibly_ think that this is something that 
can and must be done something about in the caller. When the caller 
obviously has no real option except to ignore the error _anyway_.

That was always my point. Returning an error is INSANE, because ther is no 
valid thing that the caller can possibly do.

If you want it logged, fine. But THAT DOES NOT CHANGE ANYTHING. It would 
still be wrong to return the error, since the caller _still_ can't do 
anything about it.

		Linus
