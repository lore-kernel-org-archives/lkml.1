Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbYLCLVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbYLCLVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 06:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYLCLV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 06:21:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45427 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbYLCLVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 06:21:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Wed, 3 Dec 2008 12:20:36 +0100
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812030840.25539.rjw@sisk.pl> <200812030852.36437.rjw@sisk.pl>
In-Reply-To: <200812030852.36437.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812031220.36711.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 3 of December 2008, Rafael J. Wysocki wrote:
> On Wednesday, 3 of December 2008, Rafael J. Wysocki wrote:
> > On Wednesday, 3 of December 2008, Linus Torvalds wrote:
> > > 
> > > On Wed, 3 Dec 2008, Rafael J. Wysocki wrote:
> > > > 
> > > > Here's the output of 'lspci -vvxxx':
> > > 
> > > Ok, I'm not finding any documented quirks that would be memory regions, 
> > > and in fact it doesn't look like there is even any remotely likely 32-bit 
> > > valies that might be pointers in your PCI config space that look remotely 
> > > like they might be conflicting in the area of MMIO space that we allocate 
> > > PCI resources from (ie 0x88000000-0x92000000).
> > > 
> > > Of course, any odd MMIO regions might be descibed by some insane model 
> > > that doesn't look like an aligned 32-bit value, but that's unlikely.
> > > 
> > > So I'm still not seeing anything wrong in there.
> > > 
> > > > I'll run the 'pci=cbmemsize=4M' test tomorrow (need to have some sleep).
> > > 
> > > Sure. It will be interesting to see if it makes any difference.
> > 
> > It didn't help (failure in the 4th consecutive hibernation/resume cycle).
> 
> Moreover, to check if the problem may be related to the prefetch window,
> I added the appended patch on top of -rc7 (instead of the previous debug
> patch), which resulted in the following layout in /proc/iomem:
> 
> 88000000-8dffffff : PCI Bus 0000:03
>   88000000-8bffffff : PCI CardBus 0000:04
>   8c000000-8c003fff : 0000:03:0b.1
>   8c004000-8c004fff : 0000:03:0b.0
>     8c004000-8c004fff : yenta_socket
>   8c005000-8c0057ff : 0000:03:0b.1
>     8c005000-8c0057ff : firewire_ohci
>   8c005800-8c0058ff : 0000:03:0b.3
>     8c005800-8c0058ff : mmc0
>   8c400000-8c7fffff : PCI CardBus 0000:04
> 
> and the first hibernation-resume cycle failed.
> 
> Thanks,
> Rafael
> 
> ---
>  drivers/pci/setup-bus.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> Index: linux-2.6/drivers/pci/setup-bus.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/setup-bus.c
> +++ linux-2.6/drivers/pci/setup-bus.c
> @@ -353,6 +353,25 @@ static int pbus_size_mem(struct pci_bus 
>  			r_size = resource_size(r);
>  			/* For bridges size != alignment */
>  			align = resource_alignment(r);
> +			if (r->flags & IORESOURCE_PREFETCH) {
> +				resource_size_t expected_align;
> +
> +				expected_align = (i < PCI_BRIDGE_RESOURCES) ?
> +							r_size : r->start;
> +				if (align != expected_align) {
> +					dev_warn(&dev->dev,
> +						"BAR %d [%llx-%llx] "
> +						"alignment issue: flags=%lx "
> +						"align=%llx (%llx)\n", i,
> +						(unsigned long long)r->start,
> +						(unsigned long long)r->end,
> +						r->flags,
> +						(unsigned long long)align,
> +						(unsigned long long)expected_align);
> +					/* Hacky and wrong, but trying to keep things */
> +					align = expected_align;
> +				}
> +			}
>  			order = __ffs(align) - 20;
>  			if (order > 11) {
>  				dev_warn(&dev->dev, "BAR %d bad alignment %llx: "
> --

Now _that_ seems interesting.

I noticed that on this particular box my first patch is equivalent to replacing
IORESOURCE_SIZEALIGN with IORESOURCE_STARTALIGN in two places under the last
'if()' in pci_bus_size_cardbus(), so I wondered what would happen if we only
allocated the prefetchable region in there.  Following that, I did:

--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -432,12 +432,14 @@ static void pci_bus_size_cardbus(struct 
 	 */
 	if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0) {
 		b_res[2].start = 0;
-		b_res[2].end = pci_cardbus_mem_size - 1;
+		b_res[2].end = pci_cardbus_mem_size * 2 - 1;
 		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH | IORESOURCE_SIZEALIGN;
 
+#if 0
 		b_res[3].start = 0;
 		b_res[3].end = pci_cardbus_mem_size - 1;
 		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
+#endif
 	} else {
 		b_res[3].start = 0;
 		b_res[3].end = pci_cardbus_mem_size * 2 - 1;

(well, I didn't have to allocate twice the size but that was to check if the
size of the allocation was going to matter), which resulted in the appended
/proc/iomem.

Then, voila!, I'm not able to reproduce the hibernation-resume failure.

This appears to mean that:
(1) The sizes of the allocations and the locations of devices in the memory
    address space don't matter here.
(2) The presence and size of the prefetchable memory window don't matter here.
(3) What matters is the presence of non-prefetchable memory window on the
    supposedly transparent bridge.  Namely, if the window is there, resume from
    hibernation occasionally fails (again, the size of the window and the
    location of it in the memory address space doesn't seem to matter).

So, apparently, on this box (and I guess on Frans' too) we could avoid the
problem if we didn't allocate the non-prefetchable memory window in
pci_bus_size_cardbus(), but I guess that wouldn't be generally correct.

Also, I would be happy to actually understand _why_ this happens.

Thanks,
Rafael

---
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000e0000-000eedff : reserved
000eee00-000eefff : ACPI Non-volatile Storage
000ef000-000fffff : reserved
00100000-7f74ffff : System RAM
  00200000-00450486 : Kernel code
  00450487-00603c37 : Kernel data
  00678000-00784d3b : Kernel bss
7f750000-7fffffff : reserved
  7f750000-7f75ffff : pnp 00:00
  7f760000-7f7fffff : pnp 00:00
  7f800000-7fffffff : pnp 00:00
88000000-8fffffff : PCI Bus 0000:03 <-- the prefetchable window
  88000000-8fffffff : PCI CardBus 0000:04 <-- the prefetchable window
90000000-900fffff : PCI Bus 0000:03
  90000000-90003fff : 0000:03:0b.1
  90004000-90004fff : 0000:03:0b.0
    90004000-90004fff : yenta_socket
  90005000-900057ff : 0000:03:0b.1
    90005000-900057ff : firewire_ohci
  90005800-900058ff : 0000:03:0b.3
    90005800-900058ff : mmc0
90100000-9017ffff : 0000:00:02.1
90180000-90183fff : 0000:00:1b.0
  90180000-90183fff : ICH HD audio
90184000-90184fff : Intel Flush Page
90400000-907fffff : PCI CardBus 0000:04 <-- last interesting line
e0000000-efffffff : 0000:00:02.0
  e0000000-e07affff : vesafb
f0000000-f3ffffff : PCI MMCONFIG 0
  f0000000-f3ffffff : pnp 00:01
fec00000-fec17fff : reserved
  fec00000-fec17fff : pnp 00:00
    fec00000-fec00fff : IOAPIC 0
fec20000-fec27fff : reserved
  fec20000-fec27fff : pnp 00:00
fed00000-fed003ff : HPET 0
  fed00000-fed003ff : reserved
fed14000-fed19fff : reserved
  fed14000-fed19fff : pnp 00:00
fed1c000-fed8ffff : reserved
  fed1c000-fed1ffff : pnp 00:00
  fed20000-fed3ffff : pnp 00:00
  fed45000-fed8ffff : pnp 00:00
feda0000-fedbffff : reserved
  feda0000-fedbffff : pnp 00:00
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
    fee00000-fee00fff : pnp 00:00
ff800000-ff8fffff : PCI Bus 0000:02
  ff8fe000-ff8fffff : 0000:02:00.0
    ff8fe000-ff8fffff : iwlagn
ff900000-ff9fffff : PCI Bus 0000:01
  ff9e0000-ff9fffff : 0000:01:00.0
    ff9e0000-ff9fffff : e1000e
ffa00000-ffbfffff : reserved
  ffa00000-ffbfffff : pnp 00:00
ffc3f800-ffc3fbff : 0000:00:1f.2
  ffc3f800-ffc3fbff : ahci
ffc3fc00-ffc3ffff : 0000:00:1d.7
  ffc3fc00-ffc3ffff : ehci_hcd
ffc40000-ffc7ffff : 0000:00:02.0
ffc80000-ffcfffff : 0000:00:02.0
ffd00000-ffffffff : reserved
  ffd00000-ffffffff : pnp 00:00
