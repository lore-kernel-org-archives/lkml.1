Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905Ab0A0UqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab0A0UqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:46:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424Ab0A0UqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:46:05 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:29590 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab0A0UqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:03 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
Date: Wed, 27 Jan 2010 13:45:48 -0700
User-Agent: KMail/1.9.10
Cc: Yinghai Lu <yinghai@kernel.org>, Jeff Garrett <jeff@jgarrett.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Myron Stowe <myron.stowe@hp.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Ingo Molnar <mingo@elte.hu>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <201001270945.17113.bjorn.helgaas@hp.com> <20100127085337.6ff06f6e@jbarnes-piketon>
In-Reply-To: <20100127085337.6ff06f6e@jbarnes-piketon>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001271345.54454.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 January 2010 09:53:37 am Jesse Barnes wrote:
> On Wed, 27 Jan 2010 09:45:15 -0700
> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> 
> > On Tuesday 26 January 2010 03:57:31 pm Yinghai Lu wrote:
> > > [PATCH] x86/pci: don't use ioh resource if only have one ioh
> > > 
> > > some system could use reosurce out of IOH resources when only one ioh is there.
> > > 
> > > could be BIOS have wrong IOH resources and not enable them.
> > 
> > The subtractive decode theory makes sense and would explain what's
> > happening, but I don't like this patch.
> > 
> > If we assume that this really is a subtractive decode issue, this
> > patch approaches it the wrong way.  We need to know whether a
> > particular host bridge is configured for subtractive decode.  This
> > patch tests whether we have more than one host bridge, which is quite
> > a different question.
> > 
> > Imagine these system configurations:
> > 
> >   1) a single host bridge with subtractive decode
> >   2) a single host bridge with only positive decode
> >   3) multiple host bridges with subtractive decode enabled on one
> >   4) multiple host bridges with only positive decode
> > 
> > This patch will break if we encounter configs 2 or 3.  In config 2,
> > this patch assumes the bridge performs subtractive decode, so we
> > think the bridge forwards more address space than it actually does.
> > If we try to use that address space, the device will never see the
> > accesses.  In config 3, this patch assumes there's no subtractive
> > decode, so we would see Jeff's problem all over again.
> 
> Right, but OTOH:
>   - multiple IOH has already been tested with the intel_bus.c code
>   - we want to move to using _CRS data in these cases instead

> So do you have any objection to applying this patch for 2.6.33 and then
> moving away from intel_bus.c in .34 (assuming we can get _CRS working
> well on the same machines where intel_bus.c was needed)?

Without intel_bus.c, we essentially assume config 1 all the time.
If we keep intel_bus.c and this patch for .33, things should work
for configs 1 and 4.  Adding support for config 4 is good.

The bad part is that for config 4, intel_bus.c covers up any defects
in the _CRS or the Linux code that interprets it.  The reason Yinghai
added intel_bus.c in the first place was to work around a defect in
this area[1].  Keeping it will make it harder to fix the underlying
issue that keeps us from turning on _CRS for that box.

Bjorn

[1] http://lkml.org/lkml/2009/10/6/371
