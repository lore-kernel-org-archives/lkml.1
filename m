Return-Path: <linux-kernel-owner+w=401wt.eu-S1751731AbXBFIqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbXBFIqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbXBFIqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:46:48 -0500
Received: from colo.lackof.org ([198.49.126.79]:57860 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731AbXBFIqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:46:47 -0500
Date: Tue, 6 Feb 2007 01:46:38 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Grant Grundler <grundler@parisc-linux.org>,
       Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, greg@kroah.com
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Message-ID: <20070206084638.GB20752@colo.lackof.org>
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com> <20070206045528.GA4228@colo.lackof.org> <20070206050331.GB4228@colo.lackof.org> <20070205213339.80239a22.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205213339.80239a22.akpm@linux-foundation.org>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 09:33:39PM -0800, Andrew Morton wrote:
> On Mon, 5 Feb 2007 22:03:31 -0700 Grant Grundler <grundler@parisc-linux.org> wrote:
> 
> > On Mon, Feb 05, 2007 at 09:55:28PM -0700, Grant Grundler wrote:
> > ...
> > > > 	Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> > > > 	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR+ <PERR+
> > > > 	Latency: 0, Cache Line Size 0c
> > > > 	BIST is running
> > > 
> > > BIST is required to complete in 2 seconds. Either with success or failure.
> > > I expect BIOS to have complained before launching grub/lilo.
> > 
> > Gregkh,
> > I just realized linux-pci bus scan should ignore devices (print a warning)
> > which have BIST set.  Want a patch for this?
> > 
> > Slight risk some previously "working" device which violates the
> > spec might get ignored...but I hope there aren't too many of those.
> 
> Should we wait two seconds before declaring the device dead?
> To see whether it will come back?

Hrm...my thought was BIOS should already be doing that...but I just
realised 2 seconds have elapsed if Manu can collect "lspci" output showing
"BIST is running". I think the fact that BIST is not "running" in the
2.6.20-rc7 lspci output is just coincidental. The config space for that
device is full of similar garbage in both cases regardless how long
it took.

Maybe BIOS is clobbering BIST when writing latency timer or cacheline size
register and BIOS is not being careful to clear or disable the other
bytes in that same 32-bit word?

PCI is by nature a 32-bit wide config space and "byte enables"
are used to mask off bytes we want to ignore.  If the chipset
or BIOS config access routines aren't careful, they could accidentally
modify other values in the same 32-bit word when only one byte was
intended to be changed.

The code in pci_set_cacheline_size() uses byte enables but is only
called by pci_set_mwi(). 82 different .c files (124 instances) access
PCI_LATENCY_TIMER.  Of those, 68 are pci_write_config_byte() calls.
But I really only care about the calls what would apply get invoked
for 1822:4e35. My guess is this one always gets invoked:
  ./arch/i386/pci/i386.c: pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);

since the offending device is "Mantis DTV PCI Bridge Controller [Ver 1.0]".
(http://pci-ids.ucw.cz/iii/?i=1822)
pci_enable_bridges() -> pci_set_master() -> pcibios_set_master().

Manu, can you add code to pci_enable_bridges() to dump information about
which bridges are getting enabled _before_ pci_set_master() is called?

I'm interested in a hex dump of the first 8  32-bit words of
PCI config space for each device.


BTW, I wasn't planning declaring the device as dead. I just wanted to
pretend it didn't exist and then let something else (user space? timeout?)
trigger a rescan of that bus/"slot". That trigger could come in a successive
patch which also removes the 2 second polling loop.

grant
