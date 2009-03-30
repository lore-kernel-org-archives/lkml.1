Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbZC3T7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbZC3T7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbZC3T6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:58:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754159AbZC3T6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:58:51 -0400
Date: Mon, 30 Mar 2009 12:45:55 -0700 (PDT)
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
In-Reply-To: <20090330185414.GZ5178@kernel.dk>
Message-ID: <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain>
References: <20090329082507.GA4242@infradead.org> <49D01F94.6000101@oss.ntt.co.jp> <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp>
 <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk> <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Mar 2009, Jens Axboe wrote:
> 
> Sorry, I just don't see much point to doing it this way instead. So now
> the fs will have to check a queue bit after it has issued the flush, how
> is that any better than having the 'error' returned directly?

No.

Now the fs SHOULD NEVER CHECK AT ALL.

Either it did the ordering, or the FS cannot do anything about it. 

That's the point. EOPNOTSUPP is n ot a useful error message. You can't 
_do_ anything about it.

> > Sure, the device may or may not re-order things, but since the caller 
> > can't know, and can't really do a thing about it _anyway_, you're just 
> > better off not even confusing anybody.
> 
> I'd call that a pretty reckless approach to data integrity, honestly.

It has _nothing_ to do with 'reckless'. It has everything to do with 'you 
can't do anything about it'.

> You HAVE to issue an error in this case.

No. Returning an error just means that now the box is useless. Nobody can 
do anything about it. Not the admin, not the driver writer, not anybody. 

Ok, so a device didn't support flushing. We don't know why, we don't know 
if it needed it, we simply don't know. There's nothing to do. But 
returning an error to user mode is unacceptable, because that will result 
in everything just -failing-. 

And total failure is much worse than "we don't know whether the thing 
serialized".

			Linus
