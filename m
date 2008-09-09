Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbYIIKAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbYIIKAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbYIIKAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:00:07 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:39923 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYIIKAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:00:05 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 00/13] PCI: let the core manage slot names
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 09 Sep 2008 04:00:02 -0600
Message-ID: <20080909091813.29542.85613.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

This is v2 of the series that implements a series of changes
that allows the PCI core to manage slot names, rather than
individual hotplug drivers.

It addresses comments raised during the first round of review,
most notably the bug that Kenji-san found of possible false name
collisions.

This series applies against linux-next.

I'm including the previous explanation/justification to remind
folks of the raison d'etre for this patchset.

Thanks.

/ac

There are several benefits to this approach:

        1) The core can prevent duplicate slot names on systems
           with broken firmware.

        2) Since the kobject core keeps a copy of the slot name,
           there is no need for each driver to manage a separate
           copy, especially since the core can rename slots from
           underneath drivers. We save runtime memory by only
           referencing the kobject name.

        2.a) The PCI hotplug core doesn't need its own reference
             for slot name either.

        3) Individual hotplug drivers become just a little bit
           simpler by pushing as many kzalloc() calls for 'name'
           down into the PCI core as possible.

---

Alex Chiang (13):
      PCI: Hotplug core: remove 'name'
      PCI: shcphp: remove 'name' parameter
      PCI: SGI Hotplug: stop managing bss_hotplug_slot->name
      PCI: rpaphp: stop managing hotplug_slot->name
      PCI: pciehp: remove 'name' parameter
      PCI: ibmphp: stop managing hotplug_slot->name
      PCI: fakephp: remove 'name' parameter
      PCI: cpqphp: stop managing hotplug_slot->name
      PCI: cpci_hotplug: stop managing hotplug_slot->name
      PCI: acpiphp: remove 'name' parameter
      PCI, PCI Hotplug: introduce slot_name helpers
      PCI: prevent duplicate slot names
      PCI Hotplug core: add 'name' param pci_hp_register interface


 drivers/pci/hotplug/acpiphp.h           |    9 +-
 drivers/pci/hotplug/acpiphp_core.c      |   32 +++++---
 drivers/pci/hotplug/cpci_hotplug.h      |    6 ++
 drivers/pci/hotplug/cpci_hotplug_core.c |   74 +++++++-------------
 drivers/pci/hotplug/cpci_hotplug_pci.c  |    4 +
 drivers/pci/hotplug/cpqphp.h            |   13 +--
 drivers/pci/hotplug/cpqphp_core.c       |   40 +++++------
 drivers/pci/hotplug/fakephp.c           |   18 +++--
 drivers/pci/hotplug/ibmphp.h            |    5 +
 drivers/pci/hotplug/ibmphp_ebda.c       |   19 ++---
 drivers/pci/hotplug/pci_hotplug_core.c  |   38 ++++++----
 drivers/pci/hotplug/pciehp.h            |    9 ++
 drivers/pci/hotplug/pciehp_core.c       |   40 ++++-------
 drivers/pci/hotplug/pciehp_ctrl.c       |   48 ++++++-------
 drivers/pci/hotplug/pciehp_hpc.c        |    1 
 drivers/pci/hotplug/rpaphp.h            |   10 ++-
 drivers/pci/hotplug/rpaphp_core.c       |    6 +-
 drivers/pci/hotplug/rpaphp_pci.c        |    4 +
 drivers/pci/hotplug/rpaphp_slot.c       |   26 ++-----
 drivers/pci/hotplug/sgi_hotplug.c       |   18 ++---
 drivers/pci/hotplug/shpchp.h            |    9 ++
 drivers/pci/hotplug/shpchp_core.c       |   42 ++++-------
 drivers/pci/hotplug/shpchp_ctrl.c       |   48 ++++++-------
 drivers/pci/slot.c                      |  117 ++++++++++++++++++++++++++-----
 include/linux/pci.h                     |    8 ++
 include/linux/pci_hotplug.h             |   13 ++-
 26 files changed, 354 insertions(+), 303 deletions(-)

