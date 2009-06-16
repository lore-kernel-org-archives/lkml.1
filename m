Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbZFPWE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbZFPWE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZFPWES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:04:18 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:11252 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbZFPWER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:04:17 -0400
Subject: [PATCH 0/1] Recurse when searching for empty slots in resources trees
To: linux-pci@vger.kernel.org
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Date: Tue, 16 Jun 2009 16:04:20 -0600
Message-ID: <20090616220419.14021.84524.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently ran into a resource collision problem where PCI hot-plug
operations are failing for certain PCI topologies.  One case
illustrating the problem is using a QLogic PCIe HBA in a slot with a
PCIe root port as its parent bus.  Here is an abbreviated lspci output
for this topology:

-+-[0000:c2]---00.0-[0000:c3-fb]--+-00.0  QLogic Corp. 8Gb Fibre Channel HBA
 |                                \-00.1  QLogic Corp. 8Gb Fibre Channel HBA



c2:00.0 PCI bridge: PCIe Root Port (prog-if 00 [Normal decode])
	Bus: primary=c2, secondary=c3, subordinate=fb, sec-latency=0
	I/O behind bridge: 00001000-0000ffff
	Memory behind bridge: f0000000-fdffffff
	Prefetchable memory behind bridge: 0000080780000000-00000807ffffffff

c3:00.0 Fibre Channel: QLogic Corp. 8Gb Fibre Channel HBA
	Region 0: I/O ports at 8001100 [size=256]
	Region 1: Memory at f0284000 (64-bit, non-prefetchable) [size=16K]
	Region 3: Memory at f0100000 (64-bit, non-prefetchable) [size=1M]
	Expansion ROM at f0240000 [disabled] [size=256K]

c3:00.1 Fibre Channel: QLogic Corp. 8Gb Fibre Channel HBA
	Region 0: I/O ports at 8001000 [size=256]
	Region 1: Memory at f0280000 (64-bit, non-prefetchable) [size=16K]
	Region 3: Memory at f0000000 (64-bit, non-prefetchable) [size=1M]
	Expansion ROM at f0200000 [disabled] [size=256K]

After boot, the resource tree looks like:

f0000000-fdffffff : PCI Bus 0000:c3
  f0000000-fdffffff : PCI Bus 0000:c2
    f0000000-f00fffff : 0000:c3:00.1
      f0000000-f00fffff : qla2xxx
    f0100000-f01fffff : 0000:c3:00.0
      f0100000-f01fffff : qla2xxx
    f0200000-f023ffff : 0000:c3:00.1
    f0240000-f027ffff : 0000:c3:00.0
    f0280000-f0283fff : 0000:c3:00.1
      f0280000-f0283fff : qla2xxx
    f0284000-f0287fff : 0000:c3:00.0
      f0284000-f0287fff : qla2xxx

Note that PCI Bus 0000:c2 is a child of PCI Bus 0000:c3 and has an
identical address range.

When performing a PCI physical hot add and replace, logical hot add
and replace, or PCI error recovery of one the QLogic card functions in
the above topology, we get the following error messages (PCI debug in on):

GSI 85 (level, low) -> CPU 6 (0x0600) vector 87 unregistered
PCI: Scanning bus 0000:c2
pcieport-driver 0000:c2:00.0: scanning behind bridge, config fbc3c2, pass 0
PCI: Scanning bus 0000:c3
pci 0000:c3:00.0: found [1077:2532] class 000c04 header type 00
pci 0000:c3:00.0: reg 10 io port: [0x1100-0x11ff]
pci 0000:c3:00.0: reg 14 64bit mmio: [0xf0284000-0xf0287fff]
pci 0000:c3:00.0: reg 1c 64bit mmio: [0xf0100000-0xf01fffff]
pci 0000:c3:00.0: reg 30 32bit mmio: [0xf0240000-0xf027ffff]
pci 0000:c3:00.0: calling quirk_resource_alignment+0x0/0x3a0
pci 0000:c3:00.0: calling pci_fixup_video+0x0/0x280
PCI: Bus scan for 0000:c3 returning with max=c3
pcieport-driver 0000:c2:00.0: scanning behind bridge, config fbc3c2, pass 1
PCI: Bus scan for 0000:c2 returning with max=fb
pci 0000:c3:00.0: BAR 3: can't allocate mem resource [0xfe000000-0xfdffffff]
pci 0000:c3:00.0: BAR 6: got res [0x80780000000-0x8078003ffff] bus [0x80780000000-0x8078003ffff] flags 0x27200
pci 0000:c3:00.0: BAR 1: can't allocate mem resource [0xfe000000-0xfdffffff]
pci 0000:c3:00.0: BAR 0: got res [0x8001100-0x80011ff] bus [0x1100-0x11ff] flags 0x20101
pci 0000:c3:00.0: BAR 0: moved to bus [0x1100-0x11ff] flags 0x20101
GSI 85 (level, low) -> CPU 0 (0x0000) vector 87
qla2xxx 0000:c3:00.0: PCI INT A -> GSI 85 (level, low) -> IRQ 87
qla2xxx 0000:c3:00.0: region #1 not an MMIO resource (0000:c3:00.0), aborting
qla2xxx 0000:c3:00.0: PCI INT A disabled
GSI 85 (level, low) -> CPU 0 (0x0000) vector 87 unregistered
qla2xxx: probe of 0000:c3:00.0 failed with error -12

And the hot add operation fails. This failure is due to how PCI BAR
address resources are assigned in the parent buses.

BAR resources for PCI devices are allocated during hot add operations
using pci_allocate_resource() which calls find_resource() to find
empty resource slots and allocate_resource() to insert the resource in
the tree. Both find_resource() and allocate_resource() only search the
immediate child and its siblings of the root resource passed to it,
(f0000000-fdffffff : PCI Bus 0000:c3 in this example). The child
(f0000000-fdffffff : PCI Bus 0000:c2) has the same exact address range
resulting in a conflict and eventually returning -EBUSY.  This
patchset changes find_resource() and allocate_resource() to
recursively search the resource tree below the root so the appropriate
entry is then located.

A similar problem was found in:

http://thread.gmane.org/gmane.linux.kernel/768526/

This patch does not address the possibly incorrect parenting of
identical resource ranges found in the above discussion, but it does
"fix" the problem when this condition occurs for the hot plug case.

Diff stats:

 kernel/resource.c |   59 +++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 48 insertions(+), 11 deletions(-)

--
Andrew Patterson
