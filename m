Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbZIMW6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbZIMW6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 18:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZIMW6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 18:58:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:48107 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbZIMW6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 18:58:32 -0400
Message-ID: <4AAD78C6.2010300@kernel.org>
Date: Sun, 13 Sep 2009 15:57:10 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matthew Wilcox <matthew@wil.cx>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] pci: overwite pci bridge res regs to get big range
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



found one system:
[   71.120590] pci 0000:40:05.0: scanning behind bridge, config 4f4a40, pass 0
[   71.138283] PCI: Scanning bus 0000:4a
[   71.140341] pci 0000:4a:00.0: found [15b3:6278] class 000c06 header type 00
[   71.157173] pci 0000:4a:00.0: reg 10 64bit mmio: [0x000000-0x0fffff]
[   71.161697] pci 0000:4a:00.0: reg 18 64bit mmio pref: [0x000000-0x7fffff]
[   71.179403] pci 0000:4a:00.0: reg 20 64bit mmio pref: [0x000000-0xfffffff]
[   71.185366] pci 0000:4a:00.0: calling quirk_resource_alignment+0x0/0x1dd
[   71.200846] pci 0000:4a:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[   71.219623] PCI: Fixups for bus 0000:4a
[   71.222194] pci 0000:40:05.0: bridge 32bit mmio: [0xcf000000-0xcf0fffff]
[   71.238662] pci 0000:40:05.0: bridge 64bit mmio pref: [0xcd800000-0xcdffffff]
[   71.255793] PCI: Bus scan for 0000:4a returning with max=4a

device need big pref mmio, but BIOS doesn't allocate mmio to it, but the bridge
already have small mmio range programmed.
later kernel will not allocate resource to that to the device
[   99.574030] pci 0000:4a:00.0: BAR 4: can't allocate mem resource [0xd0000000-0xcdffffff]
[   99.580102] pci 0000:4a:00.0: BAR 2: got res [0xcd800000-0xcdffffff] bus [0xcd800000-0xcdffffff] flags 0x12120c
[   99.602307] pci 0000:4a:00.0: BAR 2: moved to bus [0xcd800000-0xcdffffff] flags 0x12120c
[   99.615991] pci 0000:4a:00.0: BAR 0: got res [0xcf000000-0xcf0fffff] bus [0xcf000000-0xcf0fffff] flags 0x120204
[   99.634499] pci 0000:4a:00.0: BAR 0: moved to bus [0xcf000000-0xcf0fffff] flags 0x120204
[   99.654318] pci 0000:40:05.0: PCI bridge, secondary bus 0000:4a
[   99.658766] pci 0000:40:05.0:   IO window: disabled
[   99.675478] pci 0000:40:05.0:   MEM window: 0xcf000000-0xcf0fffff
[   99.681663] pci 0000:40:05.0:   PREFETCH window: 0x000000cd800000-0x000000cdffffff

so try to get big range in pci bridge if there is no child use that range.
with te patch will get
[   99.104525] pci 0000:4a:00.0: BAR 4: got res [0xfc080000000-0xfc08fffffff] bus [0xfc080000000-0xfc08fffffff] flags 0x12120c
[   99.123624] pci 0000:4a:00.0: BAR 4: moved to bus [0xfc080000000-0xfc08fffffff] flags 0x12120c
[   99.131977] pci 0000:4a:00.0: BAR 2: got res [0xfc090000000-0xfc0907fffff] bus [0xfc090000000-0xfc0907fffff] flags 0x12120c
[   99.149788] pci 0000:4a:00.0: BAR 2: moved to bus [0xfc090000000-0xfc0907fffff] flags 0x12120c
[   99.169248] pci 0000:4a:00.0: BAR 0: got res [0xc0200000-0xc02fffff] bus [0xc0200000-0xc02fffff] flags 0x120204
[   99.189508] pci 0000:4a:00.0: BAR 0: moved to bus [0xc0200000-0xc02fffff] flags 0x120204
[   99.206402] pci 0000:40:05.0: PCI bridge, secondary bus 0000:4a
[   99.210637] pci 0000:40:05.0:   IO window: disabled
[   99.224856] pci 0000:40:05.0:   MEM window: 0xc0200000-0xc03fffff
[   99.230019] pci 0000:40:05.0:   PREFETCH window: 0x000fc080000000-0x000fc097ffffff

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -299,8 +299,17 @@ static struct resource *find_free_bus_re
 		r = bus->resource[i];
 		if (r == &ioport_resource || r == &iomem_resource)
 			continue;
-		if (r && (r->flags & type_mask) == type && !r->parent)
-			return r;
+		if (r && (r->flags & type_mask) == type) {
+			if (!r->parent)
+				return r;
+			/*
+			 * if there is no child under that, we should release
+			 * and use it. don't need to reset it, pbus_size_* will
+			 * set it again
+			 */
+			if (!r->child && !release_resource(r))
+				return r;
+		}
 	}
 	return NULL;
 }
