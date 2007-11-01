Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbXKAMjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbXKAMjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 08:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbXKAMix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 08:38:53 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:33755 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752528AbXKAMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 08:38:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aFqRfXOU4WSQ5Ut4z2wbTEI2Pr95TRNl/dgo289T8l2kUAOD5qNNGo8NRZIuXCBCwPuKxK+avJS3fJ5YY6lH2lFIo5QCy3PHwOVKuXDIvVN+LUObR6XrbRZMaVLKUhf8dspS0RVvYz7OfiBxEKP9LGl7f8TVwDxzQljkRtOo+2w=  ;
X-YMail-OSG: aVUB5bYVM1mlDGmK9PUKfIl1bQieD0H_mNxl7WmckfTgYD5ceFSXYy8jQaF7.pCBWOx1agcZLt969GzJ8N6cMPcqzYuMa28XmOFk9M6IAvVrl.1Q7cU-
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: dealing with barriers (was Re: [PATCH] firewire: fw-core: enforce write order when updating fw_device.generation)
Date: Thu, 1 Nov 2007 22:32:09 +1100
User-Agent: KMail/1.9.5
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Kristian =?iso-8859-1?q?H=F8gsberg?= <krh@redhat.com>
References: <tkrat.66a8b3070e07d80f@s5r6.in-berlin.de> <200711011453.35268.nickpiggin@yahoo.com.au> <4729A1BF.8010800@s5r6.in-berlin.de>
In-Reply-To: <4729A1BF.8010800@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711012232.10090.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2007 20:51, Stefan Richter wrote:
> Nick Piggin wrote:
> > On Thursday 01 November 2007 12:49, Stefan Richter wrote:
> >> fw_device.node_id and fw_device.generation are accessed without mutexes.
> >> We have to ensure that all readers will get to see node_id updates
> >> before generation updates.
> >
> > Hi, a few points:
>
> Thanks, this is appreciated.
>
> > - can change it to use spinlocks instead? This would be most
> >   preferable.
>
> It could be done, but I don't find it preferable for this purpose.
> Although the struct members in question are basically part of fw-core's
> API (kernel-internal API), there won't be a lot of places which access
> these members.
>
> (Besides, lockless algorithms are essential to FireWire driver code
> everywhere where CPU and controller interact.  So IMO these lockless
> accesses don't constitute a whole new level of complexity in these
> drivers.)

Fair enough.


> > - if not, you need comments.
>
> So far I tended to disagree every time when checkpatch.pl bugged me
> about barriers without comments.  But maybe that was because I had a
> wrong idea of what kind of comment should go there.  There would
> certainly be no value in a comment which effectively says "trust me, I
> know we need a barrier here".  However, thinking about it again, it
> occurs to me that I should add the following comments:
>
>   1.) At respective struct type definitions:  A comment on how struct
>       members are to be accessed and why.

That's something that can be really helpful I think, yes.


>   2.) At the occurrences of rmb() and wmb():  A comment on which
>       accesses the particular barrier divides.  This is in order to get
>       the barriers properly updated (i.e. moved or removed) when
>       surrounding code is reordered, APIs reworked, or whatever.

Yes, this is the main thing to comment at the actual site of the barirer.
Although it isn't always 100% clear with locks either (because you might 
do some non-critical operatoins inside a lock section), it just tends to
be clearer what it is being locked, and what other paths are being locked
against.

So describing what accesses are being ordered is good. Also a brief
description of how the lockless read-side works, if it's not obvious
(or you've already described that in your #1).


> Of course this division of the Why and the What only applies to accesses
> like those in the patch --- i.e. API-like data types which aren't
> abstracted by accessor functions --- while there may be other
> requirements on comments for other usage types of barriers.
>
> Or am I still wrong in my judgment of how barriers should be documented?

I think what you've said sounds good. I think that even memory barriers
within some subsystem can use commenting, even if only a line or two.


> > - you also seem to be missing rmb()s now. I see a couple in the
> >   firewire directory, but nothing that seems to be ordering loads
> >   of these particular fields.
>
> That's right.  Of course the wmb()s don't make sense if the reader side
> isn't fixed up accordingly.  I did this for all places which I spotted
> yesterday in the patches
> "firewire: fw-core: react on bus resets while the config ROM is being
> fetched", http://lkml.org/lkml/2007/10/31/464  (Hmm, this has an unclear
> changelog.)
> "firewire: fw-sbp2: enforce read order of device generation and node
> ID", http://lkml.org/lkml/2007/10/31/465

Ah, right, didn't see them. Thanks, that looks more useful now ;)


> I didn't fold all these patches into one because these two other patches
> include also other changes to the respective read sides.  I should have
> pointed this out in this first patch.

Sure. I might personally still separate out the memory ordering fix
and put all the rmb and wmb in a single patch, but that's no big
deal.


> Also, it could be that I have overlooked one more reader last night; I
> will reexamine it.
>
> > - use smp_*mb() if you are just ordering regular cacheable RAM
> >   accesses.
>
> Hmm, right.  Looks like the smp_ variants are indeed the right thing to
> do here.

OK.


> > Also, diffstat is a bit wrong... maybe you posted the wrong version?
>
> Oops, this happened when I worked on what became the "fw-core: react on
> bus resets..." patch.  So the diffstat is wrong but...

Ah, that's no problem. I manage to screw up patches in much worse
ways than this, don't worry ;)

Thanks,
Nick
