Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbZF3JLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbZF3JLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 05:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZF3JLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 05:11:17 -0400
Received: from aun.it.uu.se ([130.238.12.36]:39997 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbZF3JLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 05:11:15 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19017.53428.834539.389495@pilspetsen.it.uu.se>
Date: Tue, 30 Jun 2009 10:45:40 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
In-Reply-To: <4A496D4B.3040608@kernel.org>
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>
	<19013.29264.623540.275538@pilspetsen.it.uu.se>
	<4A45A5C1.5080701@zytor.com>
	<19013.59956.144640.331854@pilspetsen.it.uu.se>
	<20090629022911.GC20297@lackof.org>
	<4A484A8A.9020704@zytor.com>
	<19016.41349.636663.515540@pilspetsen.it.uu.se>
	<20090629112155.GJ5480@parisc-linux.org>
	<19016.44061.600652.676183@pilspetsen.it.uu.se>
	<4A490804.3040609@zytor.com>
	<4A494478.7020304@kernel.org>
	<4A494E3C.70304@kernel.org>
	<4A495C0D.2020807@zytor.com>
	<4A4966EF.6010809@kernel.org>
	<alpine.LFD.2.01.0906291820060.3605@localhost.localdomain>
	<4A496D4B.3040608@kernel.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu writes:
 > Linus Torvalds wrote:
 > > 
 > > On Mon, 29 Jun 2009, Yinghai Lu wrote:
 > >> +		end = round_up(start, ram_alignment(start)) - 1;
 > >> +		if (start > (resource_size_t)end)
 > >>  			continue;
 > >> -		reserve_region_with_split(&iomem_resource, start,
 > >> -						  end - 1, "RAM buffer");
 > >> +		reserve_region_with_split(&iomem_resource, (resource_size_t)start,
 > >> +					  (resource_size_t)end, "RAM buffer");
 > > 
 > > Hmm. You shouldn't need the casts with reserve_region_with_split(), and 
 > > they just make things uglier.
 > > 
 > > Also, I wonder if we should do something like this instead
 > > 
 > > 	#define MAX_RESOURCE_SIZE ((resource_size_t)-1)
 > > 
 > > 	...
 > > 	end = round_up(start, ram_alignment(start)) - 1;
 > > 	if (end > MAX_RESOURCE_SIZE)
 > > 		end = MAX_RESOURCE_SIZE;
 > > 	if (start > end)
 > > 		continue;
 > > 
 > > Because otherwise we'll just be ignoring resources that cross the resource 
 > > size boundary, which sounds wrong.
 > > 
 > > We _could_ have a RAM resource that crosses the 4GB boundary, after all.
 > > 
 > > Yeah, it doesn't happen much in practice, because usually the 3G-4G range 
 > > is left for PCI mappings etc, so we might never hit this in practice, but 
 > > still, this sounds like a more correct thing to do.
 > > 
 > > It also avoids the cast. We simply cap the end to the max that 
 > > 'resource_size_t' can hold.
 > 
 > Mikael, please try this on your system, and send out /proc/iomem
 > 
 > Thanks
 > 
 > Yinghai
 > 
 > [PATCH] x86: add boundary check for 32bit res before expand e820 resource to alignment
 > 
 > fix hang with HIGHMEM_64G and 32bit resource.
 > 
 > according to hpa and Linus, use (resource_size_t)-1 to fend off big ranges.
 > 
 > Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Thanks, 2.6.31-rc1 vanilla (which didn't boot) plus this one does boot.
/proc/iomem now looks as follows:

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
80000000-800000ff : 0000:00:1f.3
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
