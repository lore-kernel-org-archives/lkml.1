Return-Path: <linux-kernel-owner+w=401wt.eu-S933821AbZGQAUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821AbZGQAUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 20:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933682AbZGQAUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 20:20:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:35103 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933681AbZGQAUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 20:20:44 -0400
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Airlie <airlied@gmail.com>, Tiago Vignatti <tiago.vignatti@nokia.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@redhat.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090716094855.455c3f77@lxorguk.ukuu.org.uk>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
	 <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
	 <20090714153509.51bbec27@lxorguk.ukuu.org.uk>
	 <21d7e9970907152125i52dc3f4dqd540f7d65667cfb5@mail.gmail.com>
	 <20090716094855.455c3f77@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 10:20:10 +1000
Message-Id: <1247790010.27937.71.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 09:48 +0100, Alan Cox wrote:
> 
> > >> +             pdev = vga_default_device();
> > >
> > > What if the BIOS provided device was hot unplugged ?
> > 
> > we just use the pdev as a cookie, if it was hot unplugged we'll
> > have gotten a callback to remove it from the VGA device list
> > and the lookup which happens 5 lines later inside the spinlock
> > will fail.
> 
> What if I inserted a new device - the allocator might give me a new
> device with the same pointer if its reusing the same slab entry for
> that
> size. Unlikely but given a zillion boxes this starts to occur 8(

The original proof-of concept draft code I wrote (and this is -very-
close to it :-) didn't quite handle hotplug of the default device. That
does need to be sorted.

But then, I have a hard time finding any useful locking to use vs. PCI
hotplug, so it's a non trivial matter.

> Not commented on - but a serious question would be "do we actually
> care enough or are there really devices with just I/O and just vga
> memory access used ?"

I honestly cannot remember why I split the 4 resource types that way
back then. I have the nagging feeling that I had a good reason to do so
but it totally eludes me today :-)

The one main thing I wanted was to keep legacy vs. standard resources so
that the all the portions of a driver (DDX, DRM, etc...) that use
standard resources can continue to lock/unlock just these, without
having to know whether one of the elements disable legacy decoding (or
is trying to request it again).

But maybe somebody with a fresh new look on all this will rightfully say
"fuck it, that's too complicated" and turn the whole thing into a single
token to pass around.

> Your cookie validity is suspect I fear. 

Yes, it is sadly.

> Also holding the device reference means you stop that exact set of
> resources being reissued too early and
> you (or clients) scribbling on them through unfortunate timing. So I
> think you actually do need to grab references properly, Doesn't make
> the
> code much more complex that I can see.
> 
Well, we are in the device addition/removal path, so the list of vga
devices doesn't need to hold a reference here. However, we probably need
to make sure we take one when we peek something from that list.

Cheers,
Ben.

