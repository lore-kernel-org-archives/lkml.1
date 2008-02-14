Return-Path: <linux-kernel-owner+w=401wt.eu-S1758837AbYBNW6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbYBNW6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbYBNW6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:58:25 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50423 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480AbYBNW6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:58:24 -0500
Date: Thu, 14 Feb 2008 14:57:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
cc: Robert Hancock <hancockr@shaw.ca>,
       Andrew Morton <akpm@linux-foundation.org>, avuton@gmail.com,
       yakui.zhao@intel.com, shaohua.li@intel.com, trenn@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: a7839e96 (PNP: increase max resources) breaks my ALSA intel8x0
 sound card
In-Reply-To: <200802141528.53446.bjorn.helgaas@hp.com>
Message-ID: <alpine.LFD.1.00.0802141456370.6110@woody.linux-foundation.org>
References: <fa.Kmpf0B4W44W1VefIME7+BnfUouY@ifi.uio.no> <200802141401.24723.bjorn.helgaas@hp.com> <alpine.LFD.1.00.0802141323130.6110@woody.linux-foundation.org> <200802141528.53446.bjorn.helgaas@hp.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 14 Feb 2008, Bjorn Helgaas wrote:
> > 
> > [   22.906610] system 00:08: iomem range 0xfebfe000-0xfebfec00 has been reserved
> > [   22.906654] system 00:08: iomem range 0xfebfa000-0xfebfac00 has been reserved
> 
> The PNP resource fits entirely inside the PCI bus resource, so the PNP
> insertion will only fail if the sound driver has already been loaded.

Ok, it does indeed fit entirely in (and the discussion about "clashing" 
misled me - the PCI resource doesn't actually clash, it's just a subset). 
And the problem then ends up that the PnP thing adds resources to inside 
the PCI resource. It shouldn't. It's crap.

It should insert the resource to the root resource (or a bridge resource), 
or not at all. If somebody else has already inserted a real device 
resource, we already know about it, and the PnP information is going to be 
just making things worse.

The *really* basic issue is that PnP and ACPI generally report utter crap. 
We should always totally ignore them EXCEPT AS A WAY TO AVOID _NEW_ 
ALLOCATIONS.

That's the only valid reason to believe in ACPI: we don't know what the 
hell it's talking about, but we _do_ know that we shouldn't be allocating 
new resources over it (because if it actually happens to be correct, it is 
some random scary stuff that we obviously didn't find out about).

But the moment we have better information (where "we actually scanned the 
hardware" is the very definition of better information), we should always 
totally discard any ACPI crud. It's guaranteed to be worse than what we 
already know about.

That's all I ever wanted. To have ACPI realize that it should never ever 
mess with something we know better about.

			Linus
