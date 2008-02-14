Return-Path: <linux-kernel-owner+w=401wt.eu-S933917AbYBNW1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933917AbYBNW1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756757AbYBNW1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:27:16 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:5768 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbYBNW1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:27:15 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0 sound card
Date: Thu, 14 Feb 2008 15:28:52 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <200802141401.24723.bjorn.helgaas@hp.com> <alpine.LFD.1.00.0802141323130.6110@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0802141323130.6110@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802141528.53446.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008 02:37:15 pm Linus Torvalds wrote:
> 
> On Thu, 14 Feb 2008, Bjorn Helgaas wrote:
> > 
> > That means the PNP system driver has to be registered after the PCI
> > driver.
> 
> After the PCI *subsystem*
> 
> Here's the actual problem:
> 
> [   31.133141] PCI: Unable to reserve mem region #1:4000@febf8000 for device 0000:00:1b.0
> 
> and here is what the resource tree *should* look like:
> 
> 	febf8000-febfbfff : 0000:00:1b.0
> 	  febf8000-febfbfff : ICH HD audio
> 
> that's with a working sound driver.
> 
> Notice how there is *two* resources there: there's the PCI bus resource 
> itself, the one called 0000:00:1b.0 (which was active at boot), and there 
> is the "driver resource" that nests inside of it ("ICH HD audio").
> 
> The PCI bus resource is created and inserted into the resource when the 
> PCI bus discovery happens - long before the driver comes along at all.
> 
> And the problem is this ABSOLUTE CRAP that happened much earlier:
> 
> [   22.906610] system 00:08: iomem range 0xfebfe000-0xfebfec00 has been reserved
> [   22.906654] system 00:08: iomem range 0xfebfa000-0xfebfac00 has been reserved
> 
> which happens
>  (a) before the PCI bus probing

I don't think so.  pci_scan_bus_parented() happened earlier, here:

[   22.875359] ACPI: PCI Root Bridge [PCI0] (0000:00)

and pcibios_init() is a subsys_initcall() that happens before the PNP
system driver registers via fs_initcall() (I had this order wrong in a
previous email).

> This has everything to do with the fact that the PnP layer is  a piece of 
> crap and overrides/messes with the *correct* resources that we found 
> during PCI bus probing.

There are clearly problems with PNP.  I'm trying to help improve the
situation.

> So here is (for the *fifth* time) what PnP should do:
> 
>  - only try to insert its resources *after* the PCI bus probing has 
>    happened

That already happens.

>  - and if that fails, LET THE CRAP FAIL instead of making the *good* code 
>    fail!

The PNP resource fits entirely inside the PCI bus resource, so the PNP
insertion will only fail if the sound driver has already been loaded.

It seems like we're talking past each other.  Would anybody else like
to step in and help explain this to me?  Maybe a fresh viewpoint will
help me find a clue.

Bjorn
