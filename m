Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbXBFLwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbXBFLwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 06:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXBFLwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 06:52:51 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:53114 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbXBFLwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 06:52:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TJRvs/KSIX3w5R2ECNi5r6ZP2uSwmNF0Y6dt4JPJp0neA1uhZqZQDJvijlJ/o5FscaHWc8PviJjEfAkydM3X+H+a/rIx/63eige62UqDP8vnypZMSlUMOt/coIk5gFYgpYBMg+GDhkibM303tITXYXUs4Ht2Dp0aBjx2ssFuY3E=
Message-ID: <1a297b360702060352y3faa0f46i7c4a01499fae2eff@mail.gmail.com>
Date: Tue, 6 Feb 2007 15:52:47 +0400
From: "Manu Abraham" <abraham.manu@gmail.com>
To: "Grant Grundler" <grundler@parisc-linux.org>
Subject: Re: 2.6.20 PCI Cannot allocate resource region 2
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, greg@kroah.com
In-Reply-To: <1a297b360702060313n34a8f941oebf9f373630b070f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1a297b360702041709l3b0309c7y8fcd33df1d487889@mail.gmail.com>
	 <20070206045528.GA4228@colo.lackof.org>
	 <20070206050331.GB4228@colo.lackof.org>
	 <20070205213339.80239a22.akpm@linux-foundation.org>
	 <20070206084638.GB20752@colo.lackof.org>
	 <1a297b360702060313n34a8f941oebf9f373630b070f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, Manu Abraham <abraham.manu@gmail.com> wrote:
> On 2/6/07, Grant Grundler <grundler@parisc-linux.org> wrote:
> > On Mon, Feb 05, 2007 at 09:33:39PM -0800, Andrew Morton wrote:
> > > On Mon, 5 Feb 2007 22:03:31 -0700 Grant Grundler <grundler@parisc-linux.org> wrote:
> > >
> > > > On Mon, Feb 05, 2007 at 09:55:28PM -0700, Grant Grundler wrote:
> > > > ...
> > > > > >         Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> > > > > >         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR+ <PERR+
> > > > > >         Latency: 0, Cache Line Size 0c
> > > > > >         BIST is running
> > > > >
> > > > > BIST is required to complete in 2 seconds. Either with success or failure.
> > > > > I expect BIOS to have complained before launching grub/lilo.
> > > >
> > > > Gregkh,
> > > > I just realized linux-pci bus scan should ignore devices (print a warning)
> > > > which have BIST set.  Want a patch for this?
> > > >
> > > > Slight risk some previously "working" device which violates the
> > > > spec might get ignored...but I hope there aren't too many of those.
> > >
> > > Should we wait two seconds before declaring the device dead?
> > > To see whether it will come back?
> >
> > Hrm...my thought was BIOS should already be doing that...but I just
> > realised 2 seconds have elapsed if Manu can collect "lspci" output showing
> > "BIST is running". I think the fact that BIST is not "running" in the
> > 2.6.20-rc7 lspci output is just coincidental. The config space for that
> > device is full of similar garbage in both cases regardless how long
> > it took.
> >
> > Maybe BIOS is clobbering BIST when writing latency timer or cacheline size
> > register and BIOS is not being careful to clear or disable the other
> > bytes in that same 32-bit word?
> >
> > PCI is by nature a 32-bit wide config space and "byte enables"
> > are used to mask off bytes we want to ignore.  If the chipset
> > or BIOS config access routines aren't careful, they could accidentally
> > modify other values in the same 32-bit word when only one byte was
> > intended to be changed.
> >
> > The code in pci_set_cacheline_size() uses byte enables but is only
> > called by pci_set_mwi(). 82 different .c files (124 instances) access
> > PCI_LATENCY_TIMER.  Of those, 68 are pci_write_config_byte() calls.
> > But I really only care about the calls what would apply get invoked
> > for 1822:4e35. My guess is this one always gets invoked:
> >   ./arch/i386/pci/i386.c: pci_write_config_byte(dev, PCI_LATENCY_TIMER, lat);
> >
> > since the offending device is "Mantis DTV PCI Bridge Controller [Ver 1.0]".
> > (http://pci-ids.ucw.cz/iii/?i=1822)
> > pci_enable_bridges() -> pci_set_master() -> pcibios_set_master().
> >
> > Manu, can you add code to pci_enable_bridges() to dump information about
> > which bridges are getting enabled _before_ pci_set_master() is called?
> >
> > I'm interested in a hex dump of the first 8  32-bit words of
> > PCI config space for each device.
> >
>
> attaching a dump of the regs (on 2.6.17.7) as well as the diff
>


The device now works, used the demodulator driver alongwith the bridge driver.

inlined the log

regards,
manu


[17181623.040000] gpif status: 6000  irqcfg: 0000
[17181623.040000] irq: 18, latency: 64
[17181623.040000]  memory: 0xefeff000, mmio: 0xe18f4000
[17181623.040000] found a UNKNOWN PCI UNKNOWN device on (02:0a.0),
[17181623.040000]     Mantis Rev 1 [1822:0031], irq: 18, latency: 64
[17181623.040000]     memory: 0xefeff000, mmio: 0xe18f4000
[17181623.040000]         mantis_i2c_write: Address=[0x50] <W>[ 08 ]
[17181623.040000]         mantis_i2c_read:  Address=[0x50] <R>[ 00 00
00 00 00 00 ]
[17181623.044000]     MAC Address=[00:00:00:00:00:00]
[17181623.044000] mantis_alloc_buffers (0): DMA=0x186b0000
cpu=0xd86b0000 size=65536
[17181623.044000] mantis_alloc_buffers (0): RISC=0x1c3af000
cpu=0xdc3af000 size=1000
[17181623.044000] DVB: registering new adapter (Mantis dvb adapter).
[17181623.564000] mantis_frontend_init (0): Probing for STB0899
(DVB-S/DSS/DVB-S2)
[17181623.564000] stb0899_write_regs [0xf1b6]: 02
[17181623.564000]         mantis_i2c_write: Address=[0x68] <W>[ f1 b6 02 ]
[17181623.564000] stb0899_write_regs [0xf1c2]: 00
[17181623.564000]         mantis_i2c_write: Address=[0x68] <W>[ f1 c2 00 ]
[17181623.568000] stb0899_write_regs [0xf1c3]: 00
[17181623.568000]         mantis_i2c_write: Address=[0x68] <W>[ f1 c3 00 ]
[17181623.568000]         mantis_i2c_write: Address=[0x68] <W>[ f0 00 ]
[17181623.568000]         mantis_i2c_read:  Address=[0x68] <R>[ 82 ]
[17181623.568000] stb0899_read_reg: Reg=[0xf000], data=82
[17181623.568000] stb0899_get_dev_id: Device ID=[8], Release=[2]
[17181623.568000]         mantis_i2c_write: Address=[0x68] <W>[ f3 fc
00 04 00 00 ]
[17181623.572000]         mantis_i2c_write: Address=[0x68] <W>[ f3 34 ]
[17181623.572000]         mantis_i2c_read:  Address=[0x68] <R>[ 31 44 4d 44 ]
[17181623.572000]         mantis_i2c_write: Address=[0x68] <W>[ f3 34 ]
[17181623.572000]         mantis_i2c_read:  Address=[0x68] <R>[ 31 44 4d 44 ]
[17181623.576000] stb0899_read_s2reg Device=[0xf3fc], Base
address=[0x00000400], Offset=[0xf334], Data=[0x444d4431]
[17181623.576000]         mantis_i2c_write: Address=[0x68] <W>[ f3 fc
00 04 00 00 ]
[17181623.576000]         mantis_i2c_write: Address=[0x68] <W>[ f3 00 ]
[17181623.576000]         mantis_i2c_read:  Address=[0x68] <R>[ 01 00 00 00 ]
[17181623.580000]         mantis_i2c_write: Address=[0x68] <W>[ f3 3c ]
[17181623.580000]         mantis_i2c_read:  Address=[0x68] <R>[ 01 00 00 00 ]
[17181623.580000] stb0899_read_s2reg Device=[0xf3fc], Base
address=[0x00000400], Offset=[0xf33c], Data=[0x00000001]
[17181623.580000] stb0899_get_dev_id: Demodulator Core ID=[DMD1], Version=[1]
[17181623.580000]         mantis_i2c_write: Address=[0x68] <W>[ fa fc
00 08 00 00 ]
[17181623.584000]         mantis_i2c_write: Address=[0x68] <W>[ fa 00 ]
[17181623.584000]         mantis_i2c_read:  Address=[0x68] <R>[ 4c 00 00 00 ]
[17181623.588000]         mantis_i2c_write: Address=[0x68] <W>[ fa 2c ]
[17181623.588000]         mantis_i2c_read:  Address=[0x68] <R>[ 31 43 45 46 ]
[17181623.588000] stb0899_read_s2reg Device=[0xfafc], Base
address=[0x00000800], Offset=[0xfa2c], Data=[0x46454331]
[17181623.588000]         mantis_i2c_write: Address=[0x68] <W>[ fa fc
00 08 00 00 ]
[17181623.592000]         mantis_i2c_write: Address=[0x68] <W>[ fa 34 ]
[17181623.592000]         mantis_i2c_read:  Address=[0x68] <R>[ 01 00 00 00 ]
[17181623.592000]         mantis_i2c_write: Address=[0x68] <W>[ fa 34 ]
[17181623.592000]         mantis_i2c_read:  Address=[0x68] <R>[ 01 00 00 00 ]
[17181623.596000] stb0899_read_s2reg Device=[0xfafc], Base
address=[0x00000800], Offset=[0xfa34], Data=[0x00000001]
[17181623.596000] stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]
[17181623.596000] stb0899_attach: Attaching STB0899
[17181623.596000] mantis_frontend_init (0): found STB0899
DVB-S/DSS/DVB-S2 frontend @0x68
[17181623.596000] mantis_frontend_init (0): Probing for STB6100 tuner
[17181623.596000] stb6100_attach: Attaching
[17181623.596000] mantis_frontend_init (0): found STB6100 tuner @0x60
[17181623.596000] mantis_frontend_init (0): Probing for LNBP21 SEC
[17181623.596000]         mantis_i2c_write: Address=[0x08] <W>[ 40 ]
[17181623.596000] DVB: registering frontend 0 (STB0899 Multistandard)...
