Return-Path: <linux-kernel-owner+w=401wt.eu-S1761124AbZJMTXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761124AbZJMTXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761095AbZJMTXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:23:46 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:17871 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761085AbZJMTXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:23:43 -0400
Subject: [PATCH v2 0/9] PCI, PNP: print resources consistently
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Joe Perches <joe@perches.com>, Len Brown <lenb@kernel.org>
Date: Tue, 13 Oct 2009 13:21:55 -0600
Message-ID: <20091013192040.22336.84876.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These enhance %pR so we can print resource types and flags more easily.
This doesn't really add anything (other than a couple new messages
about host bridge apertures), but hopefully it will make things more
consistent and a bit easier to debug.  Sample change (with "pci=use_crs"):

    -pci 0000:00:03.0: reg 10 32bit mmio: [0xf6000000-0xf6ffffff]
    -pci 0000:00:03.0: reg 14 io port: [0x2400-0x24ff]
    -pci 0000:00:03.0: reg 18 32bit mmio: [0xf5ff0000-0xf5ff0fff]
    -pci 0000:00:03.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
    +pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cff]
    +pci_root PNP0A03:00: host bridge window [io  0x0000-0x2cfe]
    +pci_root PNP0A03:00: host bridge window [io  0x03b0-0x03bb]
    +pci_root PNP0A03:00: host bridge window [io  0x03c0-0x03df]
    +pci_root PNP0A03:00: host bridge window [mem 0xf5d00000-0xf6ffffff]
    +pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
    +pci 0000:00:03.0: reg 10: [mem 0xf6000000-0xf6ffffff]
    +pci 0000:00:03.0: reg 14: [io  0x2400-0x24ff]
    +pci 0000:00:03.0: reg 18: [mem 0xf5ff0000-0xf5ff0fff]
    +pci 0000:00:03.0: reg 30: [mem 0x00000000-0x0001ffff pref]

Changes from initial post to v2:
    - tidied vsprintf stack buffer to shrink and compute size more accurately
      (Joe Perches)
    - use %pR for decoding, %pr for "raw" (with type and flags) instead of
      adding %pRt and %pRf
    - split cleanup from printk changes for easier review

I plan some future patches to add more messages and change some dev_dbg()
to dev_info(), so this series is strictly to change the resource formatting.

---

Bjorn Helgaas (9):
      vsprintf: fix io/mem resource width
      vsprintf: add %pR support for IRQ and DMA resources
      vsprintf: add %pR decoding and %pr for raw struct resource
      PCI: set IORESOURCE_MEM_64 before printing resource
      PCI: trivial bridge resource factorization
      PCI: print resources consistently with %pR
      x86/PCI: print resources consistently with %pR
      ia64/PCI: print resources consistently with %pR
      PNP: print resources consistently with %pR


 arch/ia64/pci/pci.c     |   24 ++++++++++---
 arch/x86/pci/acpi.c     |   15 ++++++--
 arch/x86/pci/i386.c     |   13 +++----
 drivers/pci/pci.c       |    4 +-
 drivers/pci/probe.c     |   29 +++++-----------
 drivers/pci/quirks.c    |    2 +
 drivers/pci/setup-bus.c |   82 +++++++++++++++++++-------------------------
 drivers/pci/setup-res.c |   20 +++++------
 drivers/pnp/quirks.c    |   13 ++-----
 drivers/pnp/resource.c  |   10 ++---
 drivers/pnp/support.c   |   43 +++--------------------
 drivers/pnp/system.c    |   14 +++-----
 lib/vsprintf.c          |   87 ++++++++++++++++++++++++++++++++++++++---------
 13 files changed, 183 insertions(+), 173 deletions(-)

-- 
Bjorn
