Return-Path: <linux-kernel-owner+w=401wt.eu-S1763046AbYFXPSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763046AbYFXPSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 11:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759876AbYFXPSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 11:18:06 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:11363 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759650AbYFXPSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 11:18:05 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [PATCH] Re: regression, 2.6.26-rc7, pnp: quirk_system_pci_resources()
Date: Tue, 24 Jun 2008 09:17:35 -0600
User-Agent: KMail/1.9.9
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <485C6388.1050903@keyaccess.nl> <485D356A.402@keyaccess.nl> <485D86BD.5050803@keyaccess.nl>
In-Reply-To: <485D86BD.5050803@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806240917.35773.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 June 2008 4:54:53 pm Rene Herman wrote:
> On 21-06-08 19:07, Rene Herman wrote:
> > On 21-06-08 04:12, Rene Herman wrote:
> >> I have been running with pnpacpi=off due to testing ISAPnP/PnPBIOS but
> >> when testing some other ACPI related problem tonight I removed that
> >> and found that unfortunately something seems to have regressed. My
> >> soundcard driver (snd-es1968) won't load anymore on current mainline:
> >>
> >> ===
> >> ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 10 (level,
> >> low) -> IRQ 10
> >> PCI: Unable to reserve I/O region #1:100@de00 for device 0000:00:0a.0
> >> ACPI: PCI interrupt for device 0000:00:0a.0 disabled
> >> ES1968 (ESS Maestro): probe of 0000:00:0a.0 failed with error -16
> >> ===
> >>
> >> 00:01 (PNP0c02) is keeping its I/O region occupied:
> >>
> >> ===
> >> # cat /sys/bus/pnp/devices/00\:01/resources
> >> state = active
> >> io 0xde00-0xde03
> >> ===
> >>
> >> Sound used to work back when I wasn't yet booting with pnpacpi=off but
> >> I don't quite recall when I started doing that nor have I looked yet
> >> at why quirk_system_pci_resources() isn't doing its job. I'll
> >> investigate if you need me to but thought I'd first throw a heap of
> >> information your way and hope you'll have a patch for me when I wake
> >> up :-/
> >
> > Well, why the quirk wasn't helping is fairly obvious -- but given that I
> > definitely didn't need anything like this on .25 I wonder why PnPACPI is
> > all of a sudden claiming those 4 ports in the first place.
> >
> > As in, this works for me and might not be bogus due to the symmetry and
> > all but still needs some head scratching. In any case, I do definitely
> > need something for .26...
> >
> > I'll go recompile .25 onto here and see if's just my BIOS being funny or
> > something to do with the kernel.
> >
> > Signed-off-by: Rene Herman <rene.herman@gmail.com>
>
> My BIOS is being funny. I all of a sudden have the same behaviour back
> on .25 and .24. Quite frankly, I haven't a single clue what's going on
> and why my BIOS is grabbing 0xde00-0xde03. The BIOS didn't change, it's
> BIOS SETTINGS didn't change. I did remove the soundcard, booted without
> it and put it back later (same slot) which may have triggered some odd
> BIOS reconfig. Already tried resetting the ESCD which isn't making a
> difference.
>
> You'll have to decide if the patch as posted in parent makes sense. I
> guess it's not a kernel regression as such after all, but I do still
> need something like it to have my soundcard functional.

I think your patch makes sense, and you can add my ack.

I do have the feeling that the reason we need the quirk is because
we aren't handling those PNP device resources quite correctly in
the first place.  But I don't have any good ideas about what's wrong
yet.

My first thought was that those regions might be marked as
ACPI_PRODUCER resources (i.e., the PNP device forwards transactions
in that region to a downstream device).  In that case, the PNP device
is really a bridge, and it shouldn't reserve the region (or at least
should not mark it as busy).  But I think we currently ignore
ACPI_PRODUCER resources completely, so I don't see how that could
cause this problem.

Bjorn
