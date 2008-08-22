Return-Path: <linux-kernel-owner+w=401wt.eu-S1754729AbYHVH6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729AbYHVH6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 03:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYHVH6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 03:58:25 -0400
Received: from [93.163.65.50] ([93.163.65.50]:29312 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbYHVH6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 03:58:24 -0400
Date: Fri, 22 Aug 2008 09:58:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Eric Sandeen <sandeen@sandeen.net>, Milan Broz <mbroz@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       "MASON,CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: Mount ext3 with barrier=1 doesn't send real barrier bio?
Message-ID: <20080822075821.GS20055@kernel.dk>
References: <48A5F5C6.2090204@redhat.com> <48ACAADD.2010104@sandeen.net> <874p5eqa6h.fsf@devron.myhome.or.jp> <20080822063823.GR20055@kernel.dk> <87pro1xzkd.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pro1xzkd.fsf@devron.myhome.or.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22 2008, OGAWA Hirofumi wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> >> This should be ((rw & RW_MASK) == WRITE) too?  Anyway, this seems change
> >> behavior of submit_bh(WRITE_BARRIER) (maybe reiserfs only), it wouldn't
> >> be your intent...
> >
> > Yes, I believe the simpler and more correct fix is:
> >
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 38653e3..16b2263 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -2926,14 +2926,13 @@ int submit_bh(int rw, struct buffer_head * bh)
> >  	BUG_ON(!buffer_mapped(bh));
> >  	BUG_ON(!bh->b_end_io);
> >  
> > -	if (buffer_ordered(bh) && (rw == WRITE))
> > +	if (buffer_ordered(bh) && (rw & WRITE))
> >  		rw = WRITE_BARRIER;
> 
> I see. But, umm..., this means WRITE_SYNC with barrier was deprecated?
> Or typo?

It was supposed to read rw |= WRITE_BARRIER :-)

-- 
Jens Axboe

