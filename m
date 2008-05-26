Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbYEZVK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbYEZVK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 17:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYEZVKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 17:10:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56383 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbYEZVKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 17:10:51 -0400
Date: Mon, 26 May 2008 18:10:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Alan Cox <alan@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video4linux: Push down the BKL
Message-ID: <20080526181027.1ff9c758@gaivota>
In-Reply-To: <20080526202317.GA12793@devserv.devel.redhat.com>
References: <20080522223700.2f103a14@core>
	<20080526135951.7989516d@gaivota>
	<20080526202317.GA12793@devserv.devel.redhat.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 16:23:17 -0400
Alan Cox <alan@redhat.com> wrote:

>  The next step can be to add the obvious locks inside video_ioctl2_unlocked(). Like, for
> > example, locking the VIDIOC_S calls, if someone is calling the corresponding
> > VIDIOC_G or VIDIOC_TRY ones.  
> 
> Concentrate on the dats structures not the code - its one of those oft
> quoted and very true rules - "lock data not code"

True. I'm thinking on locking the data that is being GET/SET by VIDIOC_foo ioctls.

I can see a few strategies for removing KBL.

The hardest and optimal scenario is to look inside all drivers, fix the locks
(and pray for a further patch to not break them). I'm afraid that this is a long
term strategy.

There are also other strategies that will also produce non-optimal results, but
may avoid the usage of BKL.

For example, a very simple scenario would simply replace BKL by one mutex.
This way, just one ioctl could be handled at the same time. This is something
dumb, but will free the machine to do other tasks while an ioctl is being
executed. I bet this would work with all (or almost all) drivers. I don't see
any big drawback of this scenario, from the userspace POV.

Smarter scenarios can be designed if you use different mutexes for different
groups of data, at video_ioctl2 level.

Of course, at video_ioctl2 level, you don't see the real data. However, you'll
see data blocks. For example, if you're calling a VIDIOC_S_CROP, you're
certainly changing whatever data structures you have that changes crop window.
A concurrent call to VIDIOC_G_CROP needs to be blocked, otherwise the get will
return a data that is being changing. IMO, such trivial dependencies can be
safely handled at vidioc_ioctl2.

We may try to group VIDIOC functions into some mutexes to avoid bad usages. For
example, one mutex for ioctl's that touches on video buffers. This will lock on
calls for iocls like VIDIOC_DBUF, VIDIOC_REQBUF, etc.

We take some care with ioctls that would affect all groups of data,
like VIDIOC_S_STD. This ioctl will likely change several data structures that
affects other get operations, like changing resolution. It may also need to
stop and/or return -EBUSY, if video buffers are mmapped.

Such scenarios wouldn't avoid the need of implementing a few locks at the
drivers, but will make driver's live simpler.
 
> I'll tidy these up later in the week as I get time and merge them against
> a current linux-next tree in bits with the rework done.

Seems fine to me ;)

Cheers,
Mauro
