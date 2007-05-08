Return-Path: <linux-kernel-owner+w=401wt.eu-S967834AbXEHNwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967834AbXEHNwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967803AbXEHNwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:52:04 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:55410 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967189AbXEHNwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:52:03 -0400
Date: Tue, 8 May 2007 15:49:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New Mitsumi legacy CD-ROM driver
Message-ID: <20070508134944.GO4163@kernel.dk>
References: <464045F0.3040906@gmail.com> <20070508103524.GH4163@kernel.dk> <46407D75.7050603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46407D75.7050603@gmail.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08 2007, Rene Herman wrote:
> >Yeah, I think it's pointless to support highmem. And as long as you
> >don't call blk_queue_bounce_limit() to actively enable highmem, you are
> >not going to receive a bio/request with highmem pages.
> 
> Yep, the driver is setting BLK_BOUNCE_ANY.

Yes I noticed, which means you are not getting anything bounced and that
you will need to handle highmem mapping.

> >The block layer wil bounce any highmem pages before it reaches you. So
> >for a driver like this, I would recommend just forgetting the mapping
> >aspect.
> 
> Okay, I agree highmem doesn't make any practical sense for this driver but 
> I'm not really sure what it would gain. if !CONFIG_HIGHMEM the 
> bvec_kmap_irq turns info "(page_address((bvec)->bv_page) + 
> (bvec)->bv_offset)" directly anyway. I am a bit unsure about it all but 
> it's not the case that we can then leave out the entire 
> bio_for_each_segnment() loop is it?

The key is that you have to have interrupts disabled for the highmem
case, which may complicate your driver (or just make it perform worse,
from the system POV). If you let the block layer bounce, then you can
just use page_address() and don't worry about disabling interrupts. The
way I see it:

- Either you are using an ancient system with that drive, where you will
  never see highmem.

- Or, it's a newer system and the nerd in you likes to play with ancient
  CD-ROM drives. That box may have highmem, but it can also bounce
  memory thousands of times faster than the mitsumi drive can dish out
  the data.

IOW, you are always better off not supporting highmem for this driver.
The fact that it also simplifies the handling is a bonus.

> (generic kernels with HIGHMEM enabled are I guess an argument...)

Yeah, that is true.

> >I don't have time to review your driver right now, but I will applaud
> >your effort to write a maintenable mitsumi driver! Basically all the old
> >cdrom drivers are utter crap, so they are destined for removal.
> 
> I noticed by the way there was a bit too much emphasis on the "I" in this 
> message; it's in fact Pekka Enberg who  started this and did the core stuff!

Well thanks to both of you, then :-)

> Yes ,the current legacy CD-ROM drivers really are complete crap by now. 
> Once this mitsumi driver is in final shape it should serve as a nice 
> template for the few other types that I'd like to keep supported and the 
> rest can just go.

Fine with me... As far as I am concerned, you are now the legacy CD-ROM
driver maintainer :-)

-- 
Jens Axboe

