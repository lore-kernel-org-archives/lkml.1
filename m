Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbXLWFTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbXLWFTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 00:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422AbXLWFSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 00:18:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58134 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751409AbXLWFSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 00:18:53 -0500
Date: Sat, 22 Dec 2007 21:18:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
In-Reply-To: <476DEC66.9050701@garzik.org>
Message-ID: <alpine.LFD.0.9999.0712222109560.21557@woody.linux-foundation.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org>
 <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DE07A.4000204@garzik.org> <476DE19F.5040702@garzik.org> <alpine.LFD.0.9999.0712222040520.21557@woody.linux-foundation.org> <476DEC66.9050701@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 23 Dec 2007, Jeff Garzik wrote:
> 
> Then let's do it right:  disable mmconfig by default on x86, and enable it
> when passed "pci=mmconfig".

I'm certainly ok with that, but then you say:

> > And yes, if you want the capability following to notice automatically when
> > capabilities really do go into the 0x100+ range, that's fine. I suspect 
> 
> Yes, we /must/ do this checking, if we don't already.

Hell no. If the user asked for mmconfig to be disabled, it needs to be 
disabled, because it may well be broken and non-working. It's better to 
not see some capabilities than to lock up the machine.

So what is it? Is it "some machines do it automatically when needed" or is 
it "always disabled"?

You seem to now say that "always disabled by default" isn't good either.

What do I need to do to convince you that the *right* thing to do is:

 - disabled by default, unless user *explicitly* asks for it with 
   "pci=mmconfig"

 - but certain events will enable it automatically, unless the user 
   *explicitly* said (or we had a quirk that explicitly disabled it) 
   something like pci=mmconfig

See what I'm saying? You don't really seem to be disagreeing. It seems to 
be, in fact, exactly what you want.

I'm saying that yes, the PCI capability code might be one such "enable 
mmconfig if not explicitly disabled" user.

But I also suspect that some drivers might want to do it, and I'm almost 
certain that some DMI quirks will want to do it (ie "I recognize this 
machine, and this machine is from 2011, and wants MMCONFIG"). So we need 
to have an interface for those quirks or other events to also do it, it 
cannot be just a "PCI capabilities do it".

Quite frankly, the fewer drivers that do it, the happier I am. Maybe *no* 
drivers will do it. If so, "Hallelujah, brother, give me an Amen!". But we 
clearly want an interface for _some_ things to say "we might want to have 
mmconfig". Maybe it's only PCI capabilities. 

Regardless. Even if *no* driver ever does it, the logical interface will 
clearly be "pci_enable_mmio(pdev)".

You can then argue all you want against individual drivers actually ever 
using it, and I'll support you on that. I think MMCONFIG was/is a total 
waste of everybodys time.

			Linus
