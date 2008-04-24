Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYDXWqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYDXWqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 18:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754769AbYDXWpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 18:45:54 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:37635 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbYDXWpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 18:45:53 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 22/53] PNP: factor pnp_init_resource_table() and pnp_clean_resource_table()
Date: Thu, 24 Apr 2008 16:45:50 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080418204955.342963315@ldl.fc.hp.com> <200804211710.38660.bjorn.helgaas@hp.com> <480E5246.5000804@keyaccess.nl>
In-Reply-To: <480E5246.5000804@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241645.51454.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2008 03:01:58 pm Rene Herman wrote:
> On 22-04-08 01:10, Bjorn Helgaas wrote:
> >> Getting things working also needs setting pnp_res->index (to nport, nmem, 
> >> nirq, ndma in pnp_assign_resources) so that the isapnp_set_resources which 
> >> follows sets to the correct hardware index, but at that point position in 
> >> the list and the index are mixing together in unhealthy ways -- in the 
> >> pnp_assign_foo helpers, pnp_get_resource(.., idx) just get the "idx-th" 
> >> resource of the correct type in the list but it seems it really should be 
> >> getting the resource of the correct type with its ->index set to "idx".
> > 
> > I don't mind setting pnp_res->index in the generic pnp_assign_* code.
> > We have to do that already in pnp_set_current_resources() (the /sys
> > interface), and I don't see a good way around it.
> > 
> > In pnp_assign_resources(), we currently assume that all independent
> > options appear before any dependent ones because we compute nport,
> > nmem, etc by iterating through the independent options first.  Then
> > we use those nport, nmem, etc values as the "index" (CSR index for
> > ISAPNP, nth resource type in the template for PNPBIOS and PNPACPI).
> > I don't know whether this assumption is in the spec, but at least
> > we've assumed it for a long time.
> 
> Did this just address my position/index worry above?

Here's something interesting.  I was mistaken about the ordering
of independent vs. dependent options coming from BIOS -- I have
several examples where the dependent ones come first, including
this one:

    pnp 00:0a: parse resource options
    pnp 00:0a: new independent option
    pnp 00:0a: new dependent option (priority 0x1)
    pnp 00:0a:   io  min 0x3f8 max 0x3f8 align 1 size 8 flags 0x1
    pnp 00:0a: new dependent option (priority 0x1)
    pnp 00:0a:   io  min 0x2e8 max 0x2e8 align 1 size 8 flags 0x1
    pnp 00:0a: new dependent option (priority 0x1)
    pnp 00:0a:   io  min 0x2f8 max 0x2f8 align 1 size 8 flags 0x1
    pnp 00:0a: new dependent option (priority 0x1)
    pnp 00:0a:   io  min 0x3e8 max 0x3e8 align 1 size 8 flags 0x1
    pnp 00:0a: end dependent options
    pnp 00:0a:   irq bitmask 00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000000,00000cf8 flags 0x1
    pnp 00:0a:   io  min 0x100 max 0x130 align 16 size 8 flags 0x1
    pnp 00:0a:   dma bitmask 0xe flags 0x2
    pnp 00:0a: Plug and Play ACPI device, IDs SMCf010 (disabled)

The interesting thing here is that this IRDA device comes up disabled,
and we use pnp_assign_resources() before enabling it.  But we
assign independent options first, so we end up reversing the order
of these IO regions:

    state = active
    io 0x100-0x107
    io 0x2e8-0x2ef
    irq 5
    dma 1

The driver for this device (smsc-ircc2.c) currently can't claim it
via PNP, but by long painful trial and error, I figured out last
summer that I could get the PNP claim code to work if I manually
swapped the IO regions!

I haven't done anything about this yet, but it sure looks to me like
we need to preserve the order of the independent/dependent options
as we get them from the BIOS.

Bjorn
