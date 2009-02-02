Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbZBBUae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbZBBUae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbZBBUaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:30:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:32951 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982AbZBBUaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:30:13 -0500
Subject: Re: PCI PM: Restore standard config registers of all devices early
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andreas Schwab <schwab@suse.de>
In-Reply-To: <alpine.LFD.2.00.0902020902320.4704@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org>
	 <1233568479.18767.86.camel@pasglop>
	 <alpine.LFD.2.00.0902020902320.4704@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 07:29:40 +1100
Message-Id: <1233606580.18767.93.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I think you'll need to move the clock gating thing to be a sysdev 
> suspend/resume event, which gets done really early along with things like 
> core timekeeping etc. We kind of hit that already with the USB driver, 
> where CONFIG_PPC does all kinds of wrong things:

But I want the gating to be tied to the device. IE. If the device is
ever suspended on its own, or the driver removed, I want the clocks
off. Ideally, I want USB autosuspend to be able to clock gate or that
sort of thing .. 

I'd rather hook it up inside pci_set_power_state()...

> inside the hcd-pci.c driver. If that whole thing was a sysdev feature, you 
> wouldn't need that kind of insane "do my own arch-specific thing in a 
> generic driver" thing. AND waking it up would work too.
> 
> I'm assuming this is exactly the kind of thing that is now biting you?

I don't know yet what is biting us, though I suppose so. I only saw
Andreas report before going to bed yesterday ;-)

I wouldn't need a sysdev if I was going to put the gating under arch
control, I could just do that from various arch code I already have
there doing bits and pieces. But I like it being tied to the driver, it
makes more sense in many ways to have a driver control the clocks of its
device. Maybe the best approach is to stick a hook into
pci_set_power_state() ...  This should really be the very first thing to
happen, even before whacking back the BARs.

Cheers,
Ben.


