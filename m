Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYIDFdg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYIDFdg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 01:33:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYIDFd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 01:33:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52882 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310AbYIDFd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 01:33:26 -0400
Date: Wed, 3 Sep 2008 22:33:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: linux-next: Tree for September 3
Message-Id: <20080903223318.84b6ce8b.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809032201510.3378@nehalem.linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
	<20080903214634.ea17ff53.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809032201510.3378@nehalem.linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008 22:21:54 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 3 Sep 2008, Andrew Morton wrote:
> >
> > The Vaio says:
> > 
> > calling  init_acpi_pm_clocksource+0x0/0x14a
> > initcall init_acpi_pm_clocksource+0x0/0x14a returned 0 after 32 msecs
> > calling  pcibios_assign_resources+0x0/0x70
> > pci 0000:06:05.0: BAR 9 too large: 0x00000000000000-0x00000003ffffff
> 
> Hmm. This should not be a new warning, afaik.
> 
> But it looks totally bogus.
> 
> The code does:
> 
> 	r_size = r->end - r->start + 1;
> 	/* For bridges size != alignment */
> 	align = (i < PCI_BRIDGE_RESOURCES) ? r_size : r->start;
> 	order = __ffs(align) - 20;
> 	if (order > 11) {
> 		dev_warn(&dev->dev, "BAR %d too large: "
> 			"%#016llx-%#016llx\n", i,
> 			(unsigned long long)r->start,
> 			(unsigned long long)r->end);
> 
> and the thing is, that's a bridge resource, so it chooses r_start as the 
> alignment. Which is zero. so now __ffs(align) returns a bogus value, and 
> you get the bogus warning.
> 
> But CARDBUS bridges are _different_ from normal PCI bridges, and the 
> alignment value isn't r->start. Strictly speaking it's not r_size either, 
> it's always a fixed alignment of 4096 for MMIO bridging, i think. Maybe. 
> Whatever. But our resource handling code can't handle that, and always 
> wants either size alignment or start alignment.
> 
> But for cardbus bridges, we should be doing size alignment, and the 
> problem is that that code doesn't do the proper "resource_alignment()" 
> use.
> 
> Can you apply this patch, just to see if it fixes things.

Below..

> And do you know when this started happening? It shouldn't have been all 
> that recent. Maybe you haven't tried your Vaio in a while?

Yes, the Vaio had a vacation in New York.  Last kernel it booted was
2.6.26-rc8-mm1.

--- x	2008-09-03 21:38:24.000000000 -0700
+++ y	2008-09-03 22:29:04.000000000 -0700
...
@@ -503,15 +503,15 @@
 calling  init_acpi_pm_clocksource+0x0/0x14a
 initcall init_acpi_pm_clocksource+0x0/0x14a returned 0 after 32 msecs
 calling  pcibios_assign_resources+0x0/0x70
-pci 0000:06:05.0: BAR 9 too large: 0x00000000000000-0x00000003ffffff
 pci 0000:06:05.0: CardBus bridge, secondary bus 0000:07
 pci 0000:06:05.0:   IO window: 0x002400-0x0024ff
 pci 0000:06:05.0:   IO window: 0x002800-0x0028ff
-pci 0000:06:05.0:   MEM window: 0x54000000-0x57ffffff
+pci 0000:06:05.0:   PREFETCH window: 0x50000000-0x53ffffff
+pci 0000:06:05.0:   MEM window: 0x58000000-0x5bffffff
 pci 0000:00:1e.0: PCI bridge, secondary bus 0000:06
 pci 0000:00:1e.0:   IO window: 0x2000-0x2fff
 pci 0000:00:1e.0:   MEM window: 0xb0100000-0xb01fffff
-pci 0000:00:1e.0:   PREFETCH window: disabled
+pci 0000:00:1e.0:   PREFETCH window: 0x00000050000000-0x00000053ffffff
 pci 0000:00:1e.0: setting latency timer to 64
 pci 0000:06:05.0: power state changed by ACPI to D0
 found new irq_cfg for irq 21
@@ -522,13 +522,13 @@
 bus: 00 index 1 mmio: [0, ffffffff]
 bus: 06 index 0 io port: [2000, 2fff]
 bus: 06 index 1 mmio: [b0100000, b01fffff]
-bus: 06 index 2 mmio: [0, 0]
+bus: 06 index 2 mmio: [50000000, 53ffffff]
 bus: 06 index 3 io port: [0, ffff]
 bus: 06 index 4 mmio: [0, ffffffff]
 bus: 07 index 0 io port: [2400, 24ff]
 bus: 07 index 1 io port: [2800, 28ff]
-bus: 07 index 2 mmio: [0, 3ffffff]
-bus: 07 index 3 mmio: [54000000, 57ffffff]
+bus: 07 index 2 mmio: [50000000, 53ffffff]
+bus: 07 index 3 mmio: [58000000, 5bffffff]
 initcall pcibios_assign_resources+0x0/0x70 returned 0 after 0 msecs
 calling  inet_init+0x0/0x1c3
 NET: Registered protocol family 2

also...


@@ -860,16 +860,11 @@
 sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
  sda: sda1 sda2 sda3 < sda5 sda6 >
 sd 2:0:0:0: [sda] Attached SCSI disk
-initcall piix_init+0x0/0x27 returned 0 after 1128 msecs
+initcall piix_init+0x0/0x27 returned 0 after 1136 msecs
 calling  nonstatic_sysfs_init+0x0/0xf
 initcall nonstatic_sysfs_init+0x0/0xf returned 0 after 0 msecs
 calling  yenta_socket_init+0x0/0x16
 yenta_cardbus 0000:06:05.0: CardBus bridge found [104d:818f]
-yenta_cardbus 0000:06:05.0: CardBus bridge, secondary bus 0000:07
-yenta_cardbus 0000:06:05.0:   IO window: 0x002400-0x0024ff
-yenta_cardbus 0000:06:05.0:   IO window: 0x002800-0x0028ff
-yenta_cardbus 0000:06:05.0:   PREFETCH window: 0x50400000-0x507fffff
-yenta_cardbus 0000:06:05.0:   MEM window: 0x54000000-0x57ffffff
 yenta_cardbus 0000:06:05.0: Using CSCINT to route CSC interrupts to PCI
 yenta_cardbus 0000:06:05.0: Routing CardBus interrupts to PCI
 yenta_cardbus 0000:06:05.0: TI: mfunc 0x01001b22, devctl 0x64
@@ -878,7 +873,8 @@
 pci_bus 0000:06: Raising subordinate bus# of parent bus (#06) from #07 to #0a
 yenta_cardbus 0000:06:05.0: pcmcia: parent PCI bridge I/O window: 0x2000 - 0x2fff
 yenta_cardbus 0000:06:05.0: pcmcia: parent PCI bridge Memory window: 0xb0100000 - 0xb01fffff
-initcall yenta_socket_init+0x0/0x16 returned 0 after 499 msecs
+yenta_cardbus 0000:06:05.0: pcmcia: parent PCI bridge Memory window: 0x50000000 - 0x53ffffff
+initcall yenta_socket_init+0x0/0x16 returned 0 after 492 msecs
 calling  mon_init+0x0/0xee
 initcall mon_init+0x0/0xee returned 0 after 0 msecs
 calling  i8042_init+0x0/0x357

Full dmesg: http://userweb.kernel.org/~akpm/dmesg-sony-2.txt
