Return-Path: <linux-kernel-owner+w=401wt.eu-S1751896AbXLIMi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbXLIMi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 07:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbXLIMiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 07:38:19 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:22558 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbXLIMiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 07:38:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=nZuOvp1Ih+XWfcvltnog348ANZk8/OPpwwtwqOzFIo9YkYiLOEHhuxrFkRcGdpR39A1lx+Y5O+k98P/kaeahLq+MqTTExVeYcyLzfRCn9ba3G/fVqq1AKPWUY0kTu9MBgiZ4z5WDFxy5gIl7t21Gojr+ZVrGy9a8qMDO9K2trE4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: benh@kernel.crashing.org
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
Date: Sun, 9 Dec 2007 13:46:25 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Ralf Baechle <ralf@linux-mips.org>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <200710122305.l9CN5tFI008240@hera.kernel.org> <1197185091.6572.38.camel@pasglop> <1197193794.6572.52.camel@pasglop>
In-Reply-To: <1197193794.6572.52.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712091346.25532.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 December 2007, Benjamin Herrenschmidt wrote:
> 
> > If that is the case though (that is it can't issue low ioport cycles),
> > how would have the fd6e7321...  worked in the first place ? Hrm...
> > strange. My understanding is that all that patch does is put junk in the
> > pci_dev resource structures :-) Maybe that's enough to cause the PCI
> > layer later on to be unhappy about them and reassign the BARs to some
> > place that works ? In which case, you are right, a better approach is a
> > quirk on this specific platform, or even better, mark 0...0x10000000
> > busy in ioport_resources and let the generic code clash & re-assign...
> 
>   .../...
> 
> In fact, I see a deeper problem with Bart's original patch that moved
> the "fixup" the PCI probe.

I don't remember changing anything there, could you remind me what it was
exactly (commit number or patch name)?

> The code now replaces the content of the resource structures with the
> hard-decoded legacy addresses for any IDE controller in legacy mode,
> just losing whatever was there (the real BAR value).
> 
> On some platforms, like PowerPC (and it might be the same problem MIPS
> has, I don't know for sure), we have a quirk that puts those controller
> back into native mode. But so far, those quirks didn't change the
> resources as they were supposed to contain the proper BAR values that
> would, from then, be used.
> 
> Now that those values have been overriden in the resources, when the
> controller is switched to native mode, it will answer to the BAR values
> that no longer match the content of the resources and the driver will
> fail.
> 
> So I think we have a deeper breakage here. I'll dig some machines for
> which we do that tomorrow and see what exactly is going on. It's mostly
> older machines so if there's a breakage, it has easily gone under the
> radar.
> 
> I suspect any platform with such a quirk to turn IDE controllers into
> native mode will now -also- need to put back the BAR values in the
> struct resource, and do so -before- the platform fixup happens, that is
> from a header quirk.
> 
> Cheers,
> Ben.
