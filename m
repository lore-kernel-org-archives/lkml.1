Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab0BTIIG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 03:08:06 -0500
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:31684 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752022Ab0BTIIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 03:08:01 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=18jMIyAT3wcppZz7k9P1pa16qTSS+wPi3agl3JGhVAsBMnI/mEWNwaUtlyp2t050F8e/h5TQoaIK78JFvirP5/lbOr+4Lw8bp6IWZj73dBKryBF8kla5mNH6QOMvIShMS9FswWLMdK48f74hDQ5XQG7xKKs2PlVCcwzAysRuhcs=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: YDOcVZEVM1nJRKJza_7EfV0I3Novdx6ZArB7UScgIyeS_uyFwwuiFRpTa83v5xhulRLLqU0G8EFSy3ScN.EfEpbmjk3wt5bViUxP1bsHU8LypF_b80mynFGr3HKKE142GApXk6J5.ncogQorQYXMp0sbSxGbBTx4d3LUx0_3mZ0uzG3lTwW5uMvfJspYxjhI346Tqdb4oF4i6hPdtWXzh24IwEUv0T3tI5R8b4MvWDl4I_GvLsIUIscdL1DqDJqoaGn82TBW4Bs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
Date: Sat, 20 Feb 2010 00:07:59 -0800
User-Agent: KMail/1.9.10
Cc: Greg KH <greg@kroah.com>, "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Linux-usb" <linux-usb@vger.kernel.org>
References: <4B7CAF95.6020306@gmail.com> <201002192139.46189.david-b@pacbell.net> <51f3faa71002192315ia84786eo1138bf9ab3417f2d@mail.gmail.com>
In-Reply-To: <51f3faa71002192315ia84786eo1138bf9ab3417f2d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <201002200008.00048.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 February 2010, Robert Hancock wrote:
> > That's a good summary of the high points.  Testing was potentially an
> > issue, but it never quite got that far.  So I have no idea if there are
> > systems where EHCI advertises 64-bit DMA support but that support is
> > broken (e.g. "Yet Another Hardware Mechanism MS-Windows Ignores", so that
> > only Linux would ever trip over the relevant BIOS breakage).
> 
> According to one Microsoft page I saw, Windows XP did not implement
> the 64-bit addressing feature in EHCI. I haven't found any information
> on whether any newer Windows versions do or not.

Note that it's pure speculation on my part whether or not any such
BIOS setup is needed.  One would hope it wouldn't be required ...
but then engineers have been known to create all sorts of options
that require tweaking ... and trigger errors when the options aren't
stroked in the right way.


> > I won't attempt to go into details, but I recall a few basic issues:
> >
> >  * Not all clients or implementors of the "dma mask" mechanism agreed
> >   on what it was supposed to achieve.  Few, for example, really used
> >   it as a mask ... and it rarely affects allocation of buffers that
> >   will later get used for DMA.
> >
> >  * Confusing semantics for the various types of DMA restriction which
> >   hardware may impose, and upper layers in driver stacks would thus
> >   need (in some cases) to cope with.
> 
> I think this is pretty well nailed down at this point. I suspect the
> confusion partly comes from the expectation that driver code should be
> able to use dma_supported to test a particular mask against what a
> device had been configured for. This function is really meant for use
> in arch code, not for drivers.

If so, that suggests a minor hole in the DMA interface, since drivers
do need such info.

As you note, mask manipulation can be done in drivers ... but on the flip
side, such things are a bit error prone and deserve API wrappers.  (Plus,
there's the whole confusion about whether it's really a "mask", where a
given bit flags whether that address line is valid.  Seems more like using
a bitstring of N ones as a representation of N, where only N matters.)


> >  * How to pass such restrictions up the driver stack ... as for example
> >   that NETIF_* flag.  ISTR there was some block layer issue too, but
> >   at this remove I can't remember any details at all.  (If networking
> >   and the block layer can use 64-bit DMA, I can't imagine many other
> >   subsystems would deliver wins as big.)  For example, how would one
> >   pass up the knowledge that a driver for a particular USB peripheral
> >   across a few hubs) can do DMA to/from address 0x1234567890abcdef, but
> >   the same driver can't do that for an otherwise identical peripheral
> >   connected through a different HCD?
> 
> I think this logic is also in place, for the most part. The DMA mask
> from the HCD appears to be propagated into the USB device, and then
> into the interface objects.

Yeah, I recall thinking about that stuff way back when... intended to
set that up correctly.  IT was at least partially tested.


> For usb-storage, the SCSI layer 
> automatically sets the bounce limit based on the device passed into
> it, so the right thing gets done. The networking layer seems like it
> would need explicit handling in the drivers - I think basically a
> check if the device interface's DMA mask was set to DMA_BIT_MASK(64)
> and if so, set the HIGHDMA flag.

Another example of how roundabout all that stuff is.  "64" being the
relevant number, in contrast to something less.  So if for example the
DMA address bus width is 48 bits, things will be strange.

I wonder why the two layers don't adopt the same approach ... seemingly
they're making different assumptions about driver behavior, suggesting
that one of them may well be overly optimistic.

- Dave
