Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYKCRz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYKCRz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 12:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751474AbYKCRzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 12:55:11 -0500
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:12499 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbYKCRzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 12:55:09 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: PCI allocation changes (was: Linux 2.6.28-rc3)
Date: Mon, 3 Nov 2008 18:55:04 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Rene Herman <rene.herman@gmail.com>
References: <alpine.LFD.2.00.0811021430240.3459@nehalem.linux-foundation.org>
In-reply-To: <alpine.LFD.2.00.0811021430240.3459@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811031855.05858.elendil@planet.nl>
X-OriginalArrivalTime: 03 Nov 2008 17:55:06.0423 (UTC) FILETIME=[4E1B0470:01C93DDD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The one change I'm personally most interested in is the impact of the
> resource handling changes: since 2.6.27 we've changed the order in
> which we scan resources on x86, so that PCI scanning now sets up its
> resources before we do the e820 resouce entries. That, in turn, can
> cause changes in where we allocate PCI devices.
>
> We already found and fixed one regression that caused, but I really am
> very interested in getting wide testing of the new order across as wide
> a range of machines as possible. It would be especially interesting to
> hear from people who have older machines, which are often
> under-represented in the early -rc testing.

I've done some checks on my two laptops: a new HP 2510p and an oldish
Toshiba Satellite A40.
Bottom line is that the change looks good on both systems and as a bonus
it is probably responsible for fixing #11550: "pnp: Huge number of io
resource overlap" for the Toshiba [1].

Details below as 3 separate cases. The last one is related to #11550.

Cheers,
FJP

[1] http://bugzilla.kernel.org/show_bug.cgi?id=11550
    http://marc.info/?l=linux-kernel&m=122095745403793&w=4

HP 2510p
========
No changes in /proc/ioports; change in /proc/iomem between .27 and .28-rc3
(kernel size related changes omitted):
<snip>
 fec00000-fec00fff : IOAPIC 0
   fec00000-fec00fff : reserved
+    fec00000-fec000ff : pnp 00:0c
 fed00000-fed003ff : HPET 0
 fed20000-fed99fff : reserved
+  fed20000-fed3ffff : pnp 00:0c
+  fed45000-fed8ffff : pnp 00:0c
+  fed90000-fed99fff : pnp 00:0c
 feda0000-fedbffff : reserved
+  feda0000-fedbffff : pnp 00:0d
 fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
+    fee00000-fee00fff : pnp 00:0d
 ffb00000-ffbfffff : reserved
+  ffb00000-ffbfffff : pnp 00:0a
 fff00000-ffffffff : reserved
+  fff00000-ffffffff : pnp 00:0a
</snip>

Changes in dmesg between .27 and .28-rc3:
# Strange flip from 32bit to 64bit, may be unrelated
-PCI: 0000:00:02.0 reg 18 32bit mmio: [d0000000, dfffffff]
+pci 0000:00:02.0: reg 18 64bit mmio: [0xd0000000-0xdfffffff]
[...]
-system 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
-system 00:0a: iomem range 0xfff00000-0xffffffff could not be reserved
+system 00:0a: iomem range 0xffb00000-0xffbfffff has been reserved
+system 00:0a: iomem range 0xfff00000-0xffffffff has been reserved
[...]
-system 00:0c: iomem range 0xfec00000-0xfec000ff could not be reserved
-system 00:0c: iomem range 0xfed20000-0xfed3ffff could not be reserved
-system 00:0c: iomem range 0xfed45000-0xfed8ffff could not be reserved
-system 00:0c: iomem range 0xfed90000-0xfed99fff could not be reserved
+system 00:0c: iomem range 0xfec00000-0xfec000ff has been reserved
+system 00:0c: iomem range 0xfed20000-0xfed3ffff has been reserved
+system 00:0c: iomem range 0xfed45000-0xfed8ffff has been reserved
+system 00:0c: iomem range 0xfed90000-0xfed99fff has been reserved
[...]
-system 00:0d: iomem range 0xfeda0000-0xfedbffff could not be reserved
-system 00:0d: iomem range 0xfee00000-0xfee00fff could not be reserved
+system 00:0d: iomem range 0xfeda0000-0xfedbffff has been reserved
+system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved


Toshiba Satellite A40 with BIOS set to "initialize all PCI devices"
===================================================================
No changes in /proc/ioports; change in /proc/iomem between .27-rc7 and
.28-rc3 (kernel size related changes omitted):
<snip>
 1ef50000-1effffff : reserved
+  1ef50000-1effffff : pnp 00:00
 20000000-27ffffff : 0000:00:02.1
 28000000-2bffffff : PCI Bus 0000:01
   28000000-2bffffff : PCI CardBus 0000:02
-fec00000-fec00fff : reserved
+fec00000-fec00fff : IOAPIC 0
+  fec00000-fec00fff : reserved
+    fec00000-fec00fff : pnp 00:00
 fec10000-fec1ffff : reserved
+  fec10000-fec1ffff : pnp 00:00
 feda0000-fedbffff : reserved
+  feda0000-fedbffff : pnp 00:00
 fee00000-fee00fff : Local APIC
   fee00000-fee00fff : reserved
+    fee00000-fee00fff : pnp 00:00
 ffb00000-ffbfffff : reserved
+  ffb00000-ffbfffff : pnp 00:00
 ffe80000-ffffffff : reserved
+  ffe80000-ffffffff : pnp 00:00
</snip>

Changes in dmesg between .27-rc7 and .28-rc3:
# I still get an overlap issue for BAR4:
 pci 0000:00:1d.0: BAR 4: can't allocate resource
 pci 0000:00:1d.1: BAR 4: can't allocate resource
-system 00:00: iomem range 0x0-0x9ffff could not be reserved
-system 00:00: iomem range 0xe0000-0xeffff could not be reserved
-system 00:00: iomem range 0xf0000-0xfffff could not be reserved
-system 00:00: iomem range 0x100000-0x1ef3ffff could not be reserved
+pnp 00:00: mem resource (0x0-0x9ffff) overlaps 0000:00:02.1 BAR 0 (0x0-0x7ffffff), disabling
+pnp 00:00: mem resource (0xe0000-0xeffff) overlaps 0000:00:02.1 BAR 0 (0x0-0x7ffffff), disabling
+pnp 00:00: mem resource (0xf0000-0xfffff) overlaps 0000:00:02.1 BAR 0 (0x0-0x7ffffff), disabling
+pnp 00:00: mem resource (0x100000-0x1ef3ffff) overlaps 0000:00:02.1 BAR 0 (0x0-0x7ffffff), disabling
+pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1d.0 BAR 4 (0x0-0x1f), disabling
+pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1d.1 BAR 4 (0x0-0x1f), disabling
# But otherwise a number of resources now do get listed as being reserved
# (with only the first remaining stubborn):
 system 00:00: iomem range 0x1ef40000-0x1ef4ffff could not be reserved
-system 00:00: iomem range 0x1ef50000-0x1effffff could not be reserved
-system 00:00: iomem range 0xfec10000-0xfec1ffff could not be reserved
-system 00:00: iomem range 0xfeda0000-0xfedbffff could not be reserved
-system 00:00: iomem range 0xfec00000-0xfec00fff could not be reserved
-system 00:00: iomem range 0xfee00000-0xfee00fff could not be reserved
-system 00:00: iomem range 0xffb00000-0xffbfffff could not be reserved
-system 00:00: iomem range 0xffe80000-0xffffffff could not be reserved
+system 00:00: iomem range 0x1ef50000-0x1effffff has been reserved
+system 00:00: iomem range 0xfec10000-0xfec1ffff has been reserved
+system 00:00: iomem range 0xfeda0000-0xfedbffff has been reserved
+system 00:00: iomem range 0xfec00000-0xfec00fff has been reserved
+system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
+system 00:00: iomem range 0xffb00000-0xffbfffff has been reserved
+system 00:00: iomem range 0xffe80000-0xffffffff has been reserved
 system 00:08: ioport range 0x1e0-0x1ef has been reserved
 system 00:08: ioport range 0x480-0x48f has been reserved
 system 00:08: ioport range 0x680-0x6ff has been reserved

Toshiba Satellite A40 with BIOS set to let PCI devices be "Set up by OS"
========================================================================
This is where I used to see #11550. I now get the exact same /proc/io{mem,ports}
as with the "initialize all PCI devices" BIOS setting. It very much looks
as if the two devices that caused the "io resource overlap" messages now
get activated much earlier.

This shows best in a diff between the dmesgs for .28-rc2 and .28-rc3. Here are
the relevant bits for the two devices (Intel ICH4 sound controller and modem):
# I now immediately get good resources assigned:
-pci 0000:00:1f.5: reg 10 io port: [0x00-0xff]
-pci 0000:00:1f.5: reg 14 io port: [0x00-0x3f]
-pci 0000:00:1f.5: reg 18 32bit mmio: [0x000000-0x0001ff]
-pci 0000:00:1f.5: reg 1c 32bit mmio: [0x000000-0x0000ff]
+pci 0000:00:1f.5: reg 10 io port: [0xbe00-0xbeff]
+pci 0000:00:1f.5: reg 14 io port: [0xbdc0-0xbdff]
+pci 0000:00:1f.5: reg 18 32bit mmio: [0xcfdffe00-0xcfdfffff]
+pci 0000:00:1f.5: reg 1c 32bit mmio: [0xcfdffd00-0xcfdffdff]
 pci 0000:00:1f.5: PME# supported from D0 D3hot D3cold
 pci 0000:00:1f.5: PME# disabled
-pci 0000:00:1f.6: reg 10 io port: [0x00-0xff]
-pci 0000:00:1f.6: reg 14 io port: [0x00-0x7f]
+pci 0000:00:1f.6: reg 10 io port: [0xba00-0xbaff]
+pci 0000:00:1f.6: reg 14 io port: [0xb980-0xb9ff]
 pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
 pci 0000:00:1f.6: PME# disabled
[...]
# The block of 78 "io resource overlap" messages are now gone:
-pnp 00:08: io resource (0x2e-0x2f) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
-pnp 00:08: io resource (0x62-0x62) overlaps 0000:00:1f.5 BAR 0 (0x0-0xff), disabling
[75 similar messages omitted]
-pnp 00:08: io resource (0x72-0x77) overlaps 0000:00:1f.6 BAR 1 (0x0-0x7f), disabling
[... much later]
# Apparently there is no longer any need to enable the device:
 Intel ICH 0000:00:1f.5: power state changed by ACPI to D0
-Intel ICH 0000:00:1f.5: enabling device (0000 -> 0003)
 Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 Intel ICH 0000:00:1f.5: setting latency timer to 64
 Intel ICH Modem 0000:00:1f.6: power state changed by ACPI to D0
 Intel ICH Modem 0000:00:1f.6: PCI INT B -> GSI 17 (level, low) -> IRQ 17
 Intel ICH Modem 0000:00:1f.6: setting latency timer to 64

So, is this due to Linus' patch, or some other change between -rc2 and -rc3?
