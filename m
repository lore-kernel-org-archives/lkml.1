Return-Path: <linux-kernel-owner+w=401wt.eu-S1031145AbXD3MAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031145AbXD3MAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 08:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031152AbXD3MAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 08:00:47 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:64246 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031145AbXD3MAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 08:00:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=F/oWoTnbyrXM4vZaPYyg+ONy8zPlIzwGtaLmFuK6AlRXSgCqE12LkCY9Otw2R1cG+LdJsVJ8RHYtXib32dI1NF/qfeZdn+elo4vnwXKaFqGA1BciLcDivRiBTXXTZ7uIOeFShN8O9k8V88E9sEyyoHwoRc5psFUiX6Ey5kvlGDM=
Message-ID: <a781481a0704300500i8dfbfd8ic60e615e8b43f89e@mail.gmail.com>
Date: Mon, 30 Apr 2007 17:30:31 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same time?
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704300551130.2275@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0704280937060.24917@localhost.localdomain>
	 <20070430001311.84d0291f.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0704300445460.17536@localhost.localdomain>
	 <Pine.LNX.4.61.0704301048390.22744@yvahk01.tjqt.qr>
	 <Pine.LNX.4.64.0704300551130.2275@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
> On Mon, 30 Apr 2007, Jan Engelhardt wrote:
> >
> > >> > drivers/scsi/aic7xxx_old.c:  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
> > >> > drivers/message/i2o/device.c:   resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
> > >> >
> > >> >   clarification?
> > >>
> > >> GFP_ATOMIC implies that the memory comes from the zones which
> > >> GFP_KERNEL also uses.  So the above usage of GFP_KERNEL is redundant
> > >> and should be removed.
> >
> > include/linux/gfp.h:
> > #define GFP_ATOMIC (__GFP_HIGH)
> > #define GFP_KERNEL (__GFP_WAIT | __GFP_IO | __GFP_FS)
> >
> > So combining GFP_ATOMIC with GFP_KERNEL gives you
> > "allow io, allow fs, allow waiting, and use emergency pools when it's getting
> > tight"
> > which to me looks like a valid, but probably unwanted combination.

Yes. This all appears to be a case of some unfortunate naming used
here. GFP_KERNEL (== GFP_that_can_sleep, as defined currently) clearly
*cannot* go with GFP_ATOMIC (== GFP_that_cannot_sleep, for atomic
contexts, which is why GFP_ATOMIC exists). But the way these are
defined presently means that their combination is *not* invalid
(although of dubious usability).

As a matter of style, the author there could've written (GFP_KERNEL |
__GFP_HIGH) instead, but I'm not sure how much sense that makes
because once we specify GFP_KERNEL, we essentially bring out the heavy
weaponry to *make* some free space for ourselves if it isn't there
already (and we're prepared to sleep when all that happens) -- so
where's the need left to scavenge into emergency pools anymore?
__GFP_HIGH only makes sense for poor atomic contexts for whom sleeping
(when we try_to_free other pages to satisfy our allocation request) is
not an option, which is precisely how things are presently.

> at this point, maybe i'll just leave this in the hands of those who
> know far more about it than i do.  but, while we're here, are there
> any *other* combinations that wouldn't make any sense?  might as well
> check for those in my cleanup script as well.

What combinations make sense for a particular user must be left to him
and his usage context. So although (GFP_KERNEL | GFP_ATOMIC) does not
make sense in the way these are generally used (or were invented for),
but the combination *as defined presently* is not "invalid". I'm not
sure whether we really need to bother with putting in any checks in
__alloc_pages() -- this is only nonsensical usage at worst, not a bug.

> p.s.  as a suggestion that borders on overkill, one could always add a
> configuration debugging option that, when set, compiles code into
> kmalloc() that does a sanity check on its type flag arguments.

Eek.

> > >hang on ... based on an email i just got, is that reference to
> > >GFP_KERNEL "redundant" or "conflicting"?  big difference there.  and
> > >is the proper fix to remove "GFP_KERNEL" in both cases?

Not necessarily. I haven't looked around that code you mentioned, but
the solution is pretty simple:

1. If you're in_atomic() context, that GFP_KERNEL is a BUG and *must*
be removed.

2. If not, that GFP_ATOMIC is redundant / nonsensical and *can* be removed.
