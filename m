Return-Path: <linux-kernel-owner+w=401wt.eu-S935216AbZKYXkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935216AbZKYXkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 18:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935207AbZKYXkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 18:40:04 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:51616 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935206AbZKYXkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 18:40:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=woTpoDUTEE1LH41Bxy0seogZnGdi3QICD3bbuA6wxPzgm9XpNcgUzcssACtgRb5KGr
         eBdvQZBq7VVgQzbEeBttJkLEmSj4+8a49Vg9tHxuk2QDRkSnhmaLeKShIzDSmvkDOo79
         /nTMsbMk1EpNN2WLuKTGemrtEvAEjhNoNGuHE=
Subject: Re: [PATCH] Port ricoh_mmc from driver to pci quirk.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Philip Langdale <philipl@overt.org>, Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20091125113501.1f4d42b9.akpm@linux-foundation.org>
References: <1259021583.16650.9.camel@maxim-laptop>
	 <20091123162119.3777e14d@fido2.homeip.net>
	 <1259160947.10147.1.camel@maxim-laptop>
	 <1259161121.10147.4.camel@maxim-laptop>
	 <20091125085324.1ef9ae1f@fido2.homeip.net>
	 <20091125113501.1f4d42b9.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 01:40:01 +0200
Message-ID: <1259192401.15916.48.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 11:35 -0800, Andrew Morton wrote: 
> On Wed, 25 Nov 2009 08:53:24 -0800
> Philip Langdale <philipl@overt.org> wrote:
> 
> > On Wed, 25 Nov 2009 16:58:41 +0200
> > Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > 
> > > >From 5c5e6f5ab1a5a09a430f410cab4b160a5e65501c Mon Sep 17 00:00:00
> > > >2001
> > > From: Maxim Levitsky <maximlevitsky@gmail.com>
> > > Date: Wed, 25 Nov 2009 16:37:46 +0200
> > > Subject: [PATCH] Port ricoh_mmc from driver to pci quirk.
> > >  This is much cleaner and correct solution
> 
> This patch actually fixes a bug but the changelog forgot to tell us
> this important fact.
> 
> > I'm fine with the concept, but when I originally started work on
> > Ricoh support, Pierre specifically didn't want a pci quirk.
> > 
> > Pierre wrote:
> > > I'd rather we didn't. The current style of quirks are bad enough,
> > > making them even more vendor or device specific is a bit more than I'm
> > > willing to accept right now (seriously, how hard can it be to follow
> > > the damn spec?).
> 
> Can the bug be fixed by other means, within ricoh_mmc.c?
> 
> It's a bit sad to add a lump of code to everyone's kernel like this -
> what percentage of those machines actually have a ricoh mmc controller?

You have valid point here.
However let me explain the situation:

We have a device with 5 functions,
One of the functions is propertary MMC contoller that writing driver for
will be a coolosal waste of time, because it can be disabled.

However, when it is disabled, it actually vanishes, and all pci
functions that belong to controller decrease by one.

Example: 
07:00.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 05)
07:00.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
07:00.2 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev 12)
07:00.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 12)
07:00.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev ff)

However the correct listing is:
07:00.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 05)
07:00.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 22)
07:00.2 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 12)
07:00.3 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 12)


PCI core can handle hotplug, but it sure can't handle the sudden shift
in function numbers.

Thus the disable step should be done before it enumerates the device, as
my patch does, and unfortunately this can't be module.
Up to now this driver did work, because both functions whose numbers are
affected didn't have a driver, but I am going soon to implement one
driver, and maybe another too.

Of course, I can put that under config condition, that users that are
sure that have no such device could save few hundreds of bytes.
However a distro probably will enable this option.

I also agree that I need to print some notice to user about device being
disabled.

Aside from being almost an 1:1 copy of original driver, this patch was
sort of RFC, so I update it soon.

Best regards,
Maxim Levitsky

