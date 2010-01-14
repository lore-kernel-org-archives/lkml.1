Return-Path: <linux-kernel-owner+w=401wt.eu-S932285Ab0ANSIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab0ANSIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 13:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932236Ab0ANSIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 13:08:09 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:30353 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab0ANSIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 13:08:05 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: 2.6.33-rc3: pci host bridge windows ignored (works with pci=use_crs)
Date: Thu, 14 Jan 2010 11:08:02 -0700
User-Agent: KMail/1.9.10
Cc: Jeff Garrett <jeff@jgarrett.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       David Airlie <airlied@linux.ie>
References: <20100113053736.GA6720@jgarrett.org> <20100113132407.GA11350@jgarrett.org> <4B4ECBCE.1010502@kernel.org>
In-Reply-To: <4B4ECBCE.1010502@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001141108.03129.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 January 2010 12:46:22 am Yinghai Lu wrote:
> On 01/13/2010 05:24 AM, Jeff Garrett wrote:
> > On Wed, Jan 13, 2010 at 12:45:17AM -0800, Yinghai Lu wrote:
> >> On Wed, Jan 13, 2010 at 12:44 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> >>> On Tue, Jan 12, 2010 at 9:37 PM, Jeff Garrett <jeff@jgarrett.org> wrote:
> >>>> Took a stab at getting the right emails.  If I missed anyone, sorry...
> >>>>
> >>>> I have a desktop machine with a radeon HD 4850, and on recent kernels
> >>>> the radeon driver has failed with the message "No valid linear
> >>>> framebuffer address".  lspci on the broken configuration showed the
> >>>> first memory region at d0000000 of the radeon card to be ignored.  dmesg
> >>>> showed there to be a host bridge window at that address which was also
> >>>> ignored.

> >>> it seems HW IOH only can use [e000000 - fdffffff] under that bridge...
> >>>
> >>> and _CRS said the peer root bus could use [c000000 - dfffffff]
> >>>
> >>> could be that we need to check other register to decide if we can use
> >>> reading from ioh reg directly.

> not sure why [0xc000000 - 0xcffffff] should work with 00:07.0
> 
> checked with intel doc, that is out of scope to LMMIOL register...
> 
> really don't know how it works with your platform.

I wonder about that [mem 0xc0000000-0xcfffffff] range, too.  But as
far as I can tell, we don't actually try to use that anywhere yet.
(We assign part of that range to the 00:1c.0 bridge to bus 03, but
I don't see any devices actually using it.)

One problem I see is that _CRS includes the [mem 0xd0000000-0xdfffffff]
range, but intel_bus.c didn't find it.  We DO need this range for the
Radeon, and the Radeon works with "pci=use_crs", so the host bridge must
be routing it.

I think this must be a detail of the Intel host bridge, not something
specific to Jeff's Dell system.  This problem should affect all systems
using that host bridge.

  PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)

  ACPI: PCI Root Bridge [PCI0] (0000:00)
  pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
  pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]

  IOH bus: [00, fb]
  IOH bus: 00 index 1 mmio: [e0000000, fdffffff]

  pci 0000:00:07.0: PCI bridge to [bus 04-04]
  pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
  pci 0000:04:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]

Another problem is that intel_bus.c didn't remove the MMCONFIG region
[mem 0xe0000000-0xefffffff] from the window.  I think there's code there
to do that, but there must be something wrong with it.

Bjorn
