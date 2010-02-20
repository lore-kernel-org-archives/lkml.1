Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab0BTFju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 00:39:50 -0500
Received: from smtp103.sbc.mail.gq1.yahoo.com ([67.195.15.62]:29921 "HELO
	smtp103.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751168Ab0BTFjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 00:39:48 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BuVGzI7RVDMZfKn76/bF/fq1YeRnSVX8BLWqDR4x42F4bCCNac+f1CJQ0C1d9WjtbkhQ6f1f2bCVob1e6ujeX+LrnImtDJQfkzi7PWUPm13bJL/A02Su7TBsM/XV/qbKT1fja3S76O6/WZtDpx9VRvklUWVEA3QqsI9hp1a6yKY=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: 2Q7b6E0VM1lFUTM6wdzHFUe.gIdYOH5sf_usX882JpPFHgj3BBvlImtoDzs1rRLqTOV7Sxi2PgDmQIu9M6DCs1enol_rBDZN5Fm1G03ZxTvhA_mQhlauQm9q3.pQMSz1VLPG1AbPtlE7lTi8GFMXAE3YUnUo4exkPhJjmozgF1Qy2Xkj2dIdv5wr5crbgoberjH1OhUwO9f.ELHak4lLsa04RKCW9CSSj_VKm31LHHhy05f4ScCU6hWBWb4Te5bAdM1F2_pVDYw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [PATCH 2.6.34] ehci-hcd: add option to enable 64-bit DMA support
Date: Fri, 19 Feb 2010 21:39:45 -0800
User-Agent: KMail/1.9.10
Cc: Greg KH <greg@kroah.com>, "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Linux-usb" <linux-usb@vger.kernel.org>
References: <4B7CAF95.6020306@gmail.com> <20100218052223.GA13254@kroah.com> <51f3faa71002181633w1649a648s37ae73da342d0c3f@mail.gmail.com>
In-Reply-To: <51f3faa71002181633w1649a648s37ae73da342d0c3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201002192139.46189.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 February 2010, Robert Hancock wrote:
> >
> > But we disabled it on purpose, because of problems, do we want those
> > problems again?
> 
> AFAICS, it was disabled because of problems with kernel code, not with
> hardware (and it appears the issue was with the code that detected the
> expanded DMA mask in the USB device driver code, not the HCD driver).
> CCing David Brownell who may know more.

That's a good summary of the high points.  Testing was potentially an
issue, but it never quite got that far.  So I have no idea if there are
systems where EHCI advertises 64-bit DMA support but that support is
broken (e.g. "Yet Another Hardware Mechanism MS-Windows Ignores", so that
only Linux would ever trip over the relevant BIOS breakage).

I won't attempt to go into details, but I recall a few basic issues:

 * Not all clients or implementors of the "dma mask" mechanism agreed
   on what it was supposed to achieve.  Few, for example, really used
   it as a mask ... and it rarely affects allocation of buffers that
   will later get used for DMA.

 * Confusing semantics for the various types of DMA restriction which
   hardware may impose, and upper layers in driver stacks would thus
   need (in some cases) to cope with.

 * How to pass such restrictions up the driver stack ... as for example
   that NETIF_* flag.  ISTR there was some block layer issue too, but
   at this remove I can't remember any details at all.  (If networking
   and the block layer can use 64-bit DMA, I can't imagine many other
   subsystems would deliver wins as big.)  For example, how would one
   pass up the knowledge that a driver for a particular USB peripheral
   across a few hubs) can do DMA to/from address 0x1234567890abcdef, but
   the same driver can't do that for an otherwise identical peripheral
   connected through a different HCD?

 * There were probably a few PCI-specific issues too.  I don't think
   at that time there were many users of 64-bit DMA which weren't
   specific to PCI.  Wanting to use the generic DMA calls for such
   stuff wasn't really done back then.  But ... the USB stack uses
   the generic calls, and drivers sitting on top of usbcore (and its
   tightly coupled HCDs) will never issue PCI-specific calls, since
   they need to work on systems that don't even have PCI.

I basically think that if the controller can do 64-bit DMA, it should
be enabling it by default ... assuming the software stack can handle
that.  (What would be the benefit of adding needless restrictions,
and making systems needlessly apply bounce buffering.)  So while I'd
like to see the 64-bit DMA working, it should IMO be done without any
options to cause trouble/confusion.

But at that time it wasn't straightforward to manage 64-bit DMA except
in the very lowest level PCI drivers.  That is, EHCI could do it ...
but driver layers on top of it had no good way to do their part.  For
example, when they manage DMA mappings themselves.)

- Dave

