Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab0BSR6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:58:21 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:9873 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab0BSR6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:58:19 -0500
Subject: [PATCH v1 0/7] resource, PNPACPI: add bus number and window support
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adam Belay <abelay@mit.edu>
Date: Fri, 19 Feb 2010 10:58:17 -0700
Message-ID: <20100219175655.9199.30691.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add a new resource type, IORESOURCE_BUS, and a new resource flag,
IORESOURCE_WINDOW, and PNPACPI support that uses them.

IORESOURCE_BUS is for PCI bus number ranges.  For bridge devices, ACPI reports
secondary bus number ranges in _CRS descriptors, but we currently ignore them.
Adding this resource type will allow us to handle those descriptors in PNPACPI.

IORESOURCE_WINDOW is also for bridges: ACPI reports the regions that the bridge
forwards to its secondary bus.  We have _CRS parsing code in pci_root.c that
handles these window descriptors, but PNPACPI currently ignores them.  Adding
this flag bit will allow PNPACPI to deal with the windows correctly.

No drivers use PNP bus or window resources yet, but ultimately, I would like to
drop the _CRS parsing code from pci_root.c and rely on PNPACPI to do it for us.
The current effect of this series is to change /sys/bus/pnp/.../resources (and
"lspnp -v" output) from this:

    00:00 PNP0a03 PCI bus
	state = active

to this:

    00:00 PNP0a03 PCI bus
	state = active
	    bus 0x0-0x0
	    io 0x0-0xcff window
	    io 0x0-0x2cfe window
	    io 0x3b0-0x3bb window
	    io 0x3c0-0x3df window
	    mem 0xf5d00000-0xf6ffffff window
	    mem disabled
	    mem 0xa0000-0xbffff window

---

Bjorn Helgaas (7):
      resource: expand IORESOURCE_TYPE_BITS to make room for bus resource type
      vsprintf: clarify comments for printf_spec flags
      vsprintf: move %pR resource printf_specs off the stack
      resource: add bus number support
      resource: add window support
      PNPACPI: add window support
      PNPACPI: add bus number support


 drivers/pnp/base.h             |    3 ++
 drivers/pnp/interface.c        |    7 +++--
 drivers/pnp/pnpacpi/rsparser.c |   49 ++++++++++++++++++++++----------
 drivers/pnp/resource.c         |   27 +++++++++++++++++
 drivers/pnp/support.c          |    4 ++-
 include/linux/ioport.h         |   18 ++++++------
 lib/vsprintf.c                 |   62 +++++++++++++++++++++++++---------------
 7 files changed, 119 insertions(+), 51 deletions(-)
