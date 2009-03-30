Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbZC3URp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbZC3URp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbZC3URf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:17:35 -0400
Received: from brick.kernel.dk ([93.163.65.50]:49540 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884AbZC3URf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:17:35 -0400
Date: Mon, 30 Mar 2009 22:17:32 +0200
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
Message-ID: <20090330201732.GB5178@kernel.dk>
References: <49D02328.7060108@oss.ntt.co.jp> <49D0258A.9020306@garzik.org> <49D03377.1040909@oss.ntt.co.jp> <49D0B535.2010106@oss.ntt.co.jp> <49D0B687.1030407@oss.ntt.co.jp> <alpine.LFD.2.00.0903301028400.3948@localhost.localdomain> <20090330175544.GX5178@kernel.dk> <alpine.LFD.2.00.0903301120200.3948@localhost.localdomain> <20090330185414.GZ5178@kernel.dk> <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903301242040.4093@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30 2009, Linus Torvalds wrote:
> 
> 
> On Mon, 30 Mar 2009, Jens Axboe wrote:
> > 
> > Sorry, I just don't see much point to doing it this way instead. So now
> > the fs will have to check a queue bit after it has issued the flush, how
> > is that any better than having the 'error' returned directly?
> 
> No.
> 
> Now the fs SHOULD NEVER CHECK AT ALL.
> 
> Either it did the ordering, or the FS cannot do anything about it. 
> 
> That's the point. EOPNOTSUPP is n ot a useful error message. You can't 
> _do_ anything about it.

My point is that some file systems may or may not have different paths
or optimizations depending on whether barriers are enabled and working
or not. Apparently that's just reiserfs and Chris says we can remove it,
so it is probably a moot point.

And that is for the barrier write btw, NOT blkdev_issue_flush(). For the
latter it obviously doesn't matter if you return -EOPNOTSUPP or not, as
long as you warn. And before you yell on, please read on below...

> > > Sure, the device may or may not re-order things, but since the caller 
> > > can't know, and can't really do a thing about it _anyway_, you're just 
> > > better off not even confusing anybody.
> > 
> > I'd call that a pretty reckless approach to data integrity, honestly.
> 
> It has _nothing_ to do with 'reckless'. It has everything to do with 'you 
> can't do anything about it'.

No, but you better damn well inform of such a discovery!

> > You HAVE to issue an error in this case.
> 
> No. Returning an error just means that now the box is useless. Nobody can 
> do anything about it. Not the admin, not the driver writer, not anybody. 

What, that's nonsense. The admin can certainly check whether it's an
issue or not, and he should. That's different from handling it in the
kernel or in the application, but you have to inform about it. I
honestly cannot fathom why you don't think that is important.

> Ok, so a device didn't support flushing. We don't know why, we don't know 
> if it needed it, we simply don't know. There's nothing to do. But 
> returning an error to user mode is unacceptable, because that will result 
> in everything just -failing-. 
> 
> And total failure is much worse than "we don't know whether the thing 
> serialized".

That is not what I meant with returning it to the user. My point was
that you have to notify that the error occured, which means putting a
printk() (or whatever) in that blkdev_issue_flush(). I guess most of the
miscommunication stems from this, I don't want -EOPNOTSUPP returned to
user space, but I want some notification that tells the admin that this
device doesn't support flushes. And if the file systems use the same
path for barrier or no barriers, then it's perfectly fine to have them
share the very same "flush doesn't work bit" and the same single warning
that we don't know whether ordering is preserved on this device or not.

IOW, what I'm advocating is just a simple:

@@
        if (err == -EOPNOTSUPP) {
+               if (!is_queue_noflush(q)) {
+                       warn();
                        set_queue_noflush(q);
                }
        }

change to the pseudo-patch you posted.

-- 
Jens Axboe

