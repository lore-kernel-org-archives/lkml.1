Return-Path: <linux-kernel-owner+w=401wt.eu-S1760172AbZC3Uya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760172AbZC3Uya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbZC3UyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 16:54:21 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:30585 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbZC3UyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 16:54:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=pBdIYWW12hf5facllA5w6pYcKAn4zltVisqJx3lB/pQWbnypV3hQTuz+YfML2BKz1u
         jhaSKANb/R/V+6p5zG7u6XUeyVNWzChG/uMxMTy37hmuFOFcV/+HF5H+jiGhGqbvPUez
         XVUb9TFcm52HXgZ1UIp2ivtynMjVmmqcWGdR0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 5/7] vfs: Add  wbcflush sysfs knob to disable storage device writeback cache flushes
Date: Mon, 30 Mar 2009 22:56:12 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090327-dirty; KDE/4.2.1; i686; ; )
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Fernando Luis =?iso-8859-1?q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       chris.mason@oracle.com, david@fromorbit.com, tj@kernel.org
References: <alpine.LFD.2.00.0903241218130.3032@localhost.localdomain> <20090330175953.GY5178@kernel.dk> <49D118E5.4060209@garzik.org>
In-Reply-To: <49D118E5.4060209@garzik.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903302256.17738.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009, Jeff Garzik wrote:
> Jens Axboe wrote:
> > On Mon, Mar 30 2009, Jeff Garzik wrote:
> >> Jens Axboe wrote:
> >>> On Mon, Mar 30 2009, Bartlomiej Zolnierkiewicz wrote:
> >>>> On Monday 30 March 2009, Fernando Luis Vázquez Cao wrote:
> >>>>> Add a sysfs knob to disable storage device writeback cache flushes.
> >>>> The horde of casual desktop users (with me included) would probably prefer
> >>>> having two settings -- one for filesystem barriers and one for fsync().
> >>>>
> >>>> IOW I prefer higher performance at the cost of risking losing few last
> >>>> seconds/minutes of work in case of crash / powerfailure but I would still
> >>>> like to have the filesystem in the consistent state after such accident.
> >>> The knob is meant to control whether we really need to send a flush to
> >>> the device or not, so it's an orthogonal issue to what you are talking
> >>> about. For battery backed caches, we never need to flush. This knob is
> >>> useful IFF we have devices with write back caches that STILL do a cache
> >>> flush.
> >> How do installers and/or kernels detect a battery-backed cache that does
> >> not need flush?
> > 
> > They obviously can't, otherwise it would not be an issue at all. And
> > whether it's an issue is up for debate, until someone can point at such
> > a device. You could add a white/blacklist.
> 
> Sorry, I guess I misinterpreted your dual "IFF" statement :)
> 
> I completely agree that the suggested knob, for disabling cache flush 
> for these battery-backed devices, is at the present time addressing an 
> entirely theoretical argument AFAICS.

Guys, please look at the patch in the context of whole patchset posted
not the current Linus' tree context only.

Patch #4 adds mandatory cache flush to fsync() (based on earlier Jeff's
submission I guess) and patch #5 (this patch) adds a knob to disable cache
flushing completely.

If patch #4 is going to be ever applied I want to have an option to disable
mandatory cache flushing on fsync() -- I don't need it and I don't want it
on my desktop (+ I somehow believe I'm not the only one).  OTOH I do need it
and I do want it on my server (+ to be on by default).

Actually legacy fsync() syscall is pretty bad interface in itself because:

	a) it is synchronous

	b) operates only on a single fd

and it encourages some pretty stupid (performance wise) usages like
calling fsync() after every mail fetched.  Adding mandatory cache flush
to it only makes things worse (again looking from performance POV).

BTW in Linux world we never made any guarantees for fsync() on devices
using write caching:

$ man fsync
...
       If  the  underlying  hard disk has write caching enabled, then the data
       may not really be on  permanent  storage  when  fsync()  /  fdatasync()
       return.
...

aio_fsync() looks a bit better on a paper but no filesystem implements
it currently...
