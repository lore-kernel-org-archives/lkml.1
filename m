Return-Path: <linux-kernel-owner+w=401wt.eu-S1754533Ab0AZRco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab0AZRco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 12:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996Ab0AZRcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 12:32:43 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:20517 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab0AZRcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 12:32:42 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
Date: Tue, 26 Jan 2010 10:32:35 -0700
User-Agent: KMail/1.9.10
Cc: Jeff Garrett <jeff@jgarrett.org>, Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Myron Stowe <myron.stowe@hp.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Ingo Molnar <mingo@elte.hu>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <20100126071912.GA7543@jgarrett.org> <201001261348.59508.rjw@sisk.pl>
In-Reply-To: <201001261348.59508.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001261032.37053.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 January 2010 05:48:59 am Rafael J. Wysocki wrote:
> On Tuesday 26 January 2010, Jeff Garrett wrote:
> > On Sun, Jan 24, 2010 at 11:04:38PM +0100, Rafael J. Wysocki wrote:
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.32.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15124
> > > Subject		: PCI host bridge windows ignored (works with pci=use_crs)
> > > Submitter	: Jeff Garrett <jeff@jgarrett.org>
> > > Date		: 2010-01-13 5:37 (12 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=126336296600307&w=4
> > > Handled-By	: Yinghai Lu <yinghai@kernel.org>
> > > 		  Bjorn Helgaas <bjorn.helgaas@hp.com>
> > 
> > This regression should still be listed.  No patch to test yet.
> ...
> IIRC, we already know how to fix this ...

As far as I know, we do NOT know how to fix this.

This regression occurred when we added intel_bus.c because it's not
yet smart enough to determine the correct host bridge apertures.
Here's what it thinks the bridge aperture is and the Radeon BAR:

  IOH bus: 00 index 1 mmio: [e0000000, fdffffff]
  pci 0000:04:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]

The IOH aperture is obviously not big enough to cover the Radeon BAR.
But the host bridge _CRS tells us this:

  pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
  pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]

which IS big enough, and we know the bridge is in fact forwarding the
[mem 0xd0000000-0xdfffffff 64bit pref] region, because the Radeon works
when Jeff boots with "pci=use_crs".

I'm quite concerned about this for .33 because I don't think Jeff's
configuration (Dell desktop with Intel x58 and large graphics device)
is unusual.

The benefit of intel_bus.c is on machines with multiple IOHs, where we
need to figure out which address ranges go to which IOHs so we can
program downstream devices correctly.  But even there, _CRS should give
us the information we need, so "pci=use_crs" should make these machines
work.

I think we should remove intel_bus.c before .33.  It's breaking boxes
and we don't know how to fix it.  Even if we do find out how to fix it,
I think we should move toward using _CRS instead, because that's what
Windows uses and it's an easy way for the firmware to tell us about
platform quirks.

Bjorn
