Return-Path: <linux-kernel-owner+w=401wt.eu-S1761577AbZDGP12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761577AbZDGP12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761418AbZDGPY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:24:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54629 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761399AbZDGPY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:24:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [BISECTED] [REGRESSION] can't anymore even do a s2ram-s2disk-s2ram cycle on acer aspire 5720G
Date: Tue, 7 Apr 2009 17:24:48 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-usb" <linux-usb@vger.kernel.org>
References: <1239061976.4705.16.camel@maxim-laptop>
In-Reply-To: <1239061976.4705.16.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904071724.49145.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Maxim Levitsky wrote:
> Hi,

Hi,

> This is first time, I am actually happy about a regression....
> 
> I have a notebook, aspire 5720G that fails to do two suspends to ram in
> row.
> 
> for example I can do s2ram->s2disk->s2ram->...
> but can't s2ram->s2ram.
> 
> Well that at least was the situation till now.
> Also there is no way to debug this - bios doesn't pass control back to
> linux on failed resume. I tried probably every guess I could come with.
> 
> Now, after a commit a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 which I
> finally bisected, I can't anymore do two suspends to ram at all,
> regardless of suspend to disk in between. Also bios doesn't pass control
> when resume fails.

I wonder what happens if the in-between s2disk is in the "shutdown" mode.
Theoretically, it should work as a cold boot, so the second s2ram should work
in this case.

> I actually did 3 bisects, as I had to find fixes to 2 more s2ram bugs
> that were fixed.
> the fixes are:
> 
> a0e280e0f33f6c859a235fb69a875ed8f3420388
> 1e70c7f7a9d4a3d2cc78b40e1d7768d99cd79899

Commit a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 has been modified quite a bit
by some later commits due to regressions it introduced.

> Now, why I am happy about this:
> It seems that a suspend cycle changes something that explodes on next
> resume. a s2disk cycle cleared this, but not anymore, thus the poison
> must be somehow connected to the
> a0d4922da2e4ccb0973095d8d29f36f6b1b5f703

Hint: it would be a lot easier to read the message if you included the subjects
of the commits too. :-)

> PCI state?? I tried restoring it from saved file, (created on suspend)
> but this didn't help.
> (Only a single register, which looks like a clear or write register
> changed).
> 
> 
> Also this commits narrows down the search, now it is clear that this is
> usb related. No wonder bios pokes at usb on resume and stalls.....
> 
> 
> It could even be connected to bios handoff, maybe we don't do that on
> resume?
> 
> (Note: this regression is present all way to latest -git)

I'm not sure if we really should consider this as a regression.  s2ram clearly
didn't work correctly on your machine before and the s2disk in between
is not really relevant here IMO.

> What do you think?

Well, not much apart from the observation that the problem with s2ram on your
machine is probably related to USB.  In fact, on Intel chipsets there seem to
be some strange links between the USB controllers (most notably EHCI) and
the core chipset that don't appear to be well documented and this may be the
case in which they show up.  Dunno.

Thanks,
Rafael
