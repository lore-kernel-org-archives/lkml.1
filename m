Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZF2L5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZF2L5c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 07:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZF2L5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 07:57:23 -0400
Received: from aun.it.uu.se ([130.238.12.36]:58998 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZF2L5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 07:57:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19016.44061.600652.676183@pilspetsen.it.uu.se>
Date: Mon, 29 Jun 2009 13:57:17 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Mikael Pettersson <mikpe@it.uu.se>, "H. Peter Anvin" <hpa@zytor.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
	x86
In-Reply-To: <20090629112155.GJ5480@parisc-linux.org>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>
	<19013.29264.623540.275538@pilspetsen.it.uu.se>
	<4A45A5C1.5080701@zytor.com>
	<19013.59956.144640.331854@pilspetsen.it.uu.se>
	<20090629022911.GC20297@lackof.org>
	<4A484A8A.9020704@zytor.com>
	<19016.41349.636663.515540@pilspetsen.it.uu.se>
	<20090629112155.GJ5480@parisc-linux.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox writes:
 > On Mon, Jun 29, 2009 at 01:12:05PM +0200, Mikael Pettersson wrote:
 > > H. Peter Anvin writes:
 > >  > Grant Grundler wrote:
 > >  > > On Sat, Jun 27, 2009 at 11:45:24AM +0200, Mikael Pettersson wrote:
 > >  > > ...
 > >  > >>   fff00000-fffffffe : pnp 00:09
 > >  > >> 100000000-1ffffffff : System RAM
 > >  > >> 200000000-ffffffffffffffff : RAM buffer
 > >  > >>
 > >  > >> With 2.6.30 things look similar, except 2.6.30 does not show the
 > >  > >> last "200000000-ffffffffffffffff : RAM buffer" line.
 > >  > > 
 > >  > > BIOS e280 table didn't report that line.
 > >  > > I expect it's created by arch/x86/kernel/e820.c:
 > >  > > 1398         /*
 > >  > > 1399          * Try to bump up RAM regions to reasonable boundaries to
 > >  > > 1400          * avoid stolen RAM:
 > >  > > 1401          */
 > >  > > 1402         for (i = 0; i < e820.nr_map; i++) {
 > >  > > 1403                 struct e820entry *entry = &e820_saved.map[i];
 > >  > > 1404                 resource_size_t start, end;
 > >  > > 1405 
 > >  > > 1406                 if (entry->type != E820_RAM)
 > >  > > 1407                         continue;
 > >  > > 1408                 start = entry->addr + entry->size;
 > >  > > 1409                 end = round_up(start, ram_alignment(start));
 > >  > > 1410                 if (start == end)
 > >  > > 1411                         continue;
 > >  > > 1412                 reserve_region_with_split(&iomem_resource, start,
 > >  > > 1413                                                   end - 1, "RAM buffer");
 > >  > > 1414         }
 > >  > > 
 > >  > 
 > >  > OK, this seems more than a wee bit strange, to say the least.  We
 > >  > shouldn't be reserving the entire address space; this is legitimate I/O
 > >  > space.
 > >  > 
 > >  > However, the reservation suddenly being improper for the root resource
 > >  > would definitely make things unhappy...
 > > 
 > > Reverting the two e820 changes in 2.6.31-rc1,
 > > 5d423ccd7ba4285f1084e91b26805e1d0ae978ed and then
 > > 45fbe3ee01b8e463b28c2751b5dcc0cbdc142d90,
 > > but keeping the iomem_resource.end cap change, makes 2.6.31-rc1
 > > work on my HIGHMEM64G machine.
 > > 
 > > Seems the e820 and the iomem_resource.end changes are Ok in
 > > isolation but break when combined.
 > 
 > With the e820 change reverted, what does /proc/iomem look like?

00000000-0009ebff : System RAM
0009ec00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000ccfff : Video ROM
000e4000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-7ff8ffff : System RAM
  00100000-002e022e : Kernel code
  002e022f-0038aaf7 : Kernel data
  003d8000-003fc9f3 : Kernel bss
7ff90000-7ff9dfff : ACPI Tables
7ff9e000-7ffdffff : ACPI Non-volatile Storage
7ffe0000-7fffffff : reserved
88000000-880000ff : 0000:00:1f.3
bff00000-dfefffff : PCI Bus 0000:01
  c0000000-cfffffff : 0000:01:00.0
e0000000-efffffff : PCI MMCONFIG 0 [00-ff]
  e0000000-efffffff : pnp 00:0e
febfe000-febfec00 : pnp 00:09
fec00000-fec00fff : IOAPIC 0
  fec00000-fec00fff : pnp 00:0b
fed00000-fed003ff : HPET 0
fed14000-fed19fff : pnp 00:01
fed1c000-fed1ffff : pnp 00:09
fed20000-fed8ffff : pnp 00:09
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:0b
ff800000-ff8fffff : PCI Bus 0000:01
  ff8c0000-ff8dffff : 0000:01:00.0
  ff8e0000-ff8effff : 0000:01:00.1
  ff8f0000-ff8fffff : 0000:01:00.0
ff900000-ff9fffff : PCI Bus 0000:02
  ff9ffc00-ff9ffcff : 0000:02:02.0
    ff9ffc00-ff9ffcff : 8139too
ffaf8000-ffafbfff : 0000:00:1b.0
  ffaf8000-ffafbfff : ICH HD audio
ffaff000-ffaff3ff : 0000:00:1d.7
  ffaff000-ffaff3ff : ehci_hcd
ffaff400-ffaff7ff : 0000:00:1a.7
  ffaff400-ffaff7ff : ehci_hcd
ffaff800-ffafffff : 0000:00:1f.2
  ffaff800-ffafffff : ahci
ffb00000-ffffffff : reserved
  ffb00000-ffbfffff : pnp 00:09
  fff00000-fffffffe : pnp 00:09
100000000-1ffffffff : System RAM
