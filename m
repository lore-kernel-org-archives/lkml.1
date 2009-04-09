Return-Path: <linux-kernel-owner+w=401wt.eu-S932393AbZDIMG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbZDIMG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761543AbZDIMGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:06:45 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54861 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759579AbZDIMGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:06:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gDXhaH55fJqCNOe9l9HtMOdUjTaj80rAOB0CaYlSpnz4oDbPizmoSCTjR5a5i2IrjA
         gBoXV439VuZdNpbjMfC0nyyozDEAhhfCGPpxPtXU+c1WiVP9IOF9Y9aeHc+TBULubeno
         +EbB9uUpeI0NhA8eA3u15frUnxFPHK8jbXZ7o=
Subject: Re: [BISECTED] [REGRESSION] can't anymore even do a
 s2ram-s2disk-s2ram cycle on acer aspire 5720G
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>
In-Reply-To: <200904071724.49145.rjw@sisk.pl>
References: <1239061976.4705.16.camel@maxim-laptop>
	 <200904071724.49145.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 15:06:35 +0300
Message-Id: <1239278795.7235.8.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 17:24 +0200, Rafael J. Wysocki wrote:
> On Tuesday 07 April 2009, Maxim Levitsky wrote:
> > Hi,
> 
> Hi,
> 
> > This is first time, I am actually happy about a regression....
> > 
> > I have a notebook, aspire 5720G that fails to do two suspends to ram in
> > row.
> > 
> > for example I can do s2ram->s2disk->s2ram->...
> > but can't s2ram->s2ram.
> > 
> > Well that at least was the situation till now.
> > Also there is no way to debug this - bios doesn't pass control back to
> > linux on failed resume. I tried probably every guess I could come with.
> > 
> > Now, after a commit a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 which I
> > finally bisected, I can't anymore do two suspends to ram at all,
> > regardless of suspend to disk in between. Also bios doesn't pass control
> > when resume fails.
> 
> I wonder what happens if the in-between s2disk is in the "shutdown" mode.
> Theoretically, it should work as a cold boot, so the second s2ram should work
> in this case.
> 
> > I actually did 3 bisects, as I had to find fixes to 2 more s2ram bugs
> > that were fixed.
> > the fixes are:
> > 
> > a0e280e0f33f6c859a235fb69a875ed8f3420388
> > 1e70c7f7a9d4a3d2cc78b40e1d7768d99cd79899
> 
> Commit a0d4922da2e4ccb0973095d8d29f36f6b1b5f703 has been modified quite a bit
> by some later commits due to regressions it introduced.
> 
> > Now, why I am happy about this:
> > It seems that a suspend cycle changes something that explodes on next
> > resume. a s2disk cycle cleared this, but not anymore, thus the poison
> > must be somehow connected to the
> > a0d4922da2e4ccb0973095d8d29f36f6b1b5f703
> 
> Hint: it would be a lot easier to read the message if you included the subjects
> of the commits too. :-)
> 
Sure, sorry ;-)

> > PCI state?? I tried restoring it from saved file, (created on suspend)
> > but this didn't help.
> > (Only a single register, which looks like a clear or write register
> > changed).
> > 
> > 
> > Also this commits narrows down the search, now it is clear that this is
> > usb related. No wonder bios pokes at usb on resume and stalls.....
> > 
> > 
> > It could even be connected to bios handoff, maybe we don't do that on
> > resume?
> > 
> > (Note: this regression is present all way to latest -git)
> 
> I'm not sure if we really should consider this as a regression.  s2ram clearly
> didn't work correctly on your machine before and the s2disk in between
> is not really relevant here IMO.
Yet, this allowed me at least lalf the time to do s2ram.
s2disk eats battery, if I suspend the system for short time


> 
> > What do you think?
> 
> Well, not much apart from the observation that the problem with s2ram on your
> machine is probably related to USB.  In fact, on Intel chipsets there seem to
> be some strange links between the USB controllers (most notably EHCI) and
> the core chipset that don't appear to be well documented and this may be the
> case in which they show up.  Dunno.

Sorry for late reply,

I now semi-bisected, the change inside this patch.

First, UHCI doesn't affect anything.

Then, if I move 'late' suspend functions inside normal ones, everything
returns works like it used to be (I need to retest this statement, I did
other changes too).


Also, I got a idea about, think about this:
my notebook has a webcam, a usb UVC webcam.

Fact that it has firmware, can't be argued, it has to be true.
Suppose its firmware is stored in bios?
In this case, bios would load it on resume from ram, thus it will need
fully functional ehci controller.
We do something wrong, or more correctly, bios has some wrong
assumptions (read assume windows driver) about ehci state.


Best regards,
	Maxim Levitsky


