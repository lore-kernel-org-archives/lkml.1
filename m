Return-Path: <linux-kernel-owner+w=401wt.eu-S1753913AbXLIJug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbXLIJug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 04:50:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXLIJu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 04:50:27 -0500
Received: from gate.crashing.org ([63.228.1.57]:36054 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbXLIJu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 04:50:26 -0500
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1197185091.6572.38.camel@pasglop>
References: <200710122305.l9CN5tFI008240@hera.kernel.org>
	 <1196899818.7033.11.camel@pasglop>
	 <200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net>
	 <1196917447.7033.17.camel@pasglop>
	 <200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net>
	 <1196922262.7033.33.camel@pasglop>  <20071209021231.GA13729@linux-mips.org>
	 <1197185091.6572.38.camel@pasglop>
Content-Type: text/plain
Date: Sun, 09 Dec 2007 20:49:54 +1100
Message-Id: <1197193794.6572.52.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> If that is the case though (that is it can't issue low ioport cycles),
> how would have the fd6e7321...  worked in the first place ? Hrm...
> strange. My understanding is that all that patch does is put junk in the
> pci_dev resource structures :-) Maybe that's enough to cause the PCI
> layer later on to be unhappy about them and reassign the BARs to some
> place that works ? In which case, you are right, a better approach is a
> quirk on this specific platform, or even better, mark 0...0x10000000
> busy in ioport_resources and let the generic code clash & re-assign...

  .../...

In fact, I see a deeper problem with Bart's original patch that moved
the "fixup" the PCI probe.

The code now replaces the content of the resource structures with the
hard-decoded legacy addresses for any IDE controller in legacy mode,
just losing whatever was there (the real BAR value).

On some platforms, like PowerPC (and it might be the same problem MIPS
has, I don't know for sure), we have a quirk that puts those controller
back into native mode. But so far, those quirks didn't change the
resources as they were supposed to contain the proper BAR values that
would, from then, be used.

Now that those values have been overriden in the resources, when the
controller is switched to native mode, it will answer to the BAR values
that no longer match the content of the resources and the driver will
fail.

So I think we have a deeper breakage here. I'll dig some machines for
which we do that tomorrow and see what exactly is going on. It's mostly
older machines so if there's a breakage, it has easily gone under the
radar.

I suspect any platform with such a quirk to turn IDE controllers into
native mode will now -also- need to put back the BAR values in the
struct resource, and do so -before- the platform fixup happens, that is
from a header quirk.

Cheers,
Ben.


