Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbXEaXr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbXEaXr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbXEaXrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:47:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:37184 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbXEaXrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:47:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nyRZkh3hN/PMsBLG9oMb2MopMcwF2B8bNtfmKczQ86GEpCsOAzS7W6ZPfP2BnRBEeWAk2TBLLimZ/kft65cUkRcGcF+ufYt3eDcmQ8CKgU3w2EqHhZkGS63oXtGKOUn0+0BN7t7QsZgho37UX2kcE7/5GCGaGoPBd2URbgaD/oI=
Message-ID: <6278d2220705311647l48dfcfdbkb826826e11dccef4@mail.gmail.com>
Date: Fri, 1 Jun 2007 00:47:14 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Mark Lord" <liml@rtr.ca>
Subject: Re: Compact Flash performance...
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Jeff Garzik" <jeff@garzik.org>
In-Reply-To: <465F4D4E.6050305@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>
	 <465E3FF0.9010709@rtr.ca>
	 <6278d2220705310222rde9ad28ndfd8feced84a3c6f@mail.gmail.com>
	 <465EBE20.6090803@rtr.ca>
	 <6278d2220705311025q6ee030e2kd44b7302a50ac902@mail.gmail.com>
	 <465F360D.6020603@rtr.ca>
	 <6278d2220705311439x40f7b1c1l7cef54acd2e8fcea@mail.gmail.com>
	 <465F4D4E.6050305@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 31/05/07, Mark Lord <liml@rtr.ca> wrote:
> Daniel J Blueman wrote:
> > On 31/05/07, Mark Lord <liml@rtr.ca> wrote:
> >> Daniel J Blueman wrote:
> >> > Whoops, yes. Here is the expected data:
> > [snip]
> >>
> >> Thanks.  I'll use that data to update/validate future versions of hdparm.
> >> At UDMA66, it *should* be capable of the 40MByte/sec realm of readback
> >> perf,
> >> assuming the card itself is really that fast.
> >
> > hdparm in the other identify mode does list the UDMA3/4 modes twice
> > [1], which looks odd.
> >
> >> I don't know too much about the specifics, though, but perhaps the
> >> card is only capable of full speed in PIO6, which requires special
> >> cabling
> >> and is currently unsupported in libata (?).
> >
> > Seems less likely, as the Extreme IV reader (and another) supports
> > UDMA mode 4; in PIO mode 6, they apparently top out at 17MB/s [2],
> > which seems reasonable.
> >
> >> Another factor, is that hdparm performs discrete, non-overlapping,
> >> reads of 1MByte chunks for its timing test.  Some drives cannot achieve
> >> full performance with such (relatively) large gaps between IO's.
> >
> > 100MB transfers still achieve 32MB/s:
> >
> > # dd if=/dev/sdb of=/dev/null bs=100000k count=10
> > 10+0 records in
> > 10+0 records out
> > 1024000000 bytes (1.0 GB) copied, 31.9328 seconds, 32.1 MB/s
> >
> >> Also, just for fun, you could try "hdparm --direct -t /dev/sdb"
> >
> > # hdparm --direct -t /dev/sdb
> >
> > /dev/sdb:
> > Timing O_DIRECT disk reads:   96 MB in  3.05 seconds =  31.47 MB/sec
> >
> > It is conceivable that the controller in the two particular readers
> > which get 40MB/s are doing some kind of prefetching, but seems seems
> > like an extreme gain.
>
> Okay, here's the new hdparm information for this:
>
[snip]
>            *    CFA advanced modes: pio5 *pio6
>
> So, udma4 and pio6 are the fastest supported speeds.
> According to the CFA specifications (v4.1), either of those modes
> requires SHORT cables and special handling.   You probably have
> regular (16-18") cables, and libata doesn't support PIO6,
> and the motherboard chipset may not support the "special handling"
> requirements in other ways.  Also, only one device on the cable.

It makes sense for Linux to default to normal cable lengths in absence
of some mechanism to detect or specify this; in this case my CF card
is plugged directly into the motherboard with a CF adapter [1], so one
device, short traces. Anyway, I'd imagine the "special handling" and
other requirements have been introduced/influenced by vendors, so
possibly more special-cased than possible here.

> I see from your earlier posting that libata selected UDMA/66 (udma4)
> for the device though, since libata doesn't know that your cable
> is too long.  And that mode is working, so that's probably as good
> as it gets on that particular motherboard chipset.

I couldn't find a kernel parameter to specify if I have a long/short
cable. Is there a way?

> Some cards may perform better when their "memory" interface is used
> instead of the "I/O" interface, or vice-versa.  I'm not sure which
> of the two methods was selected by libata (probably the "memory" interface).
>
> There is also a "PC-Card" style interface with shared-memory,
> which some USB readers *may* use as an alternative to the standard
> IDE/ATA style interface.
>
> Cheers

Thanks for the detail in the other mails too; it's useful,
  Daniel

--- [1]

http://img.inkfrog.com/pix/kitty.wun/Female_CF_type3.jpg
-- 
Daniel J Blueman
