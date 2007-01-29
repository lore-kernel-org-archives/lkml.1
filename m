Return-Path: <linux-kernel-owner+w=401wt.eu-S932941AbXA2Whk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbXA2Whk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 17:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbXA2Whk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 17:37:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59870 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932941AbXA2Whd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 17:37:33 -0500
Date: Mon, 29 Jan 2007 14:37:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
In-Reply-To: <1170109401.29240.49.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0701291431320.3611@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0701241847360.25027@woody.linux-foundation.org> 
 <1169931333.17469.125.camel@localhost.localdomain>  <20070129113159.7ad22e4c@freekitty>
  <1170101430.29240.34.camel@localhost.localdomain>  <20070129133849.1b523226@freekitty>
 <1170109401.29240.49.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Jan 2007, Thomas Gleixner wrote:
> 
> Reverting commit 44ade178249fe53d055fd92113eaa271e06acddd, which added
> this hackery in the first place, makes the device survive
> suspend/resume.

I suspect some BIOSes do *not* screw up the MSI thing on resume, and 
others do.

I would suggest that the real fix is to not do that kind of hackery at 
suspend/resume time (because we can't know what the heck the BIOS does), 
and instead just do one of two cases:

 - since MSI is known to be broken for the sky2 driver due to firmware 
   bugs, just disable it by default if CONFIG_PM is enabled. The 
   advantages of MSI just aren't all that compelling. Possibly add a 
   command line option to force MSI to be enabled regardless.

   Simple, direct, and should work for everybody.

 - Just add a command line to disable MSI for people that it breaks for. 

   I don't actually like this one. It defaults to the unsafe behaviour, 
   and while that makes sense in a "well, your machine is broken anyway" 
   kind of way, the thing is, the advantages of MSI just aren't big enough 
   to warrant defaulting to a known-unsafe thing, even if only a small 
   percentage of machines are affected.

With _eventually_ maybe having a third possible situation:

 - some way of figuring it out dynamically.

The third case doesn't seem to be very likely in the short term, though, 
which is why I'd suggest one of the first two (the first one being 
probably the best one).

Comments?

		Linus
