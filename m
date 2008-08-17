Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953AbYHQAO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbYHQAO2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 20:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYHQAOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 20:14:19 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:44575 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbYHQAOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 20:14:18 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 00/13] PCI: let the core manage slot names
To: jbarnes@virtuousgeek.org, kaneshige.kenji@jp.fujitsu.com, matthew@wil.cx,
       kristen.c.accardi@intel.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Date: Sat, 16 Aug 2008 18:14:17 -0600
Message-ID: <20080816235504.5461.20733.stgit@blender.achiang>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements a series of changes that allows the
PCI core to manage slot names, rather than individual hotplug
drivers.

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

I've compile tested every driver, including sgi, rpaphp, and ibmphp. 

I've runtime tested acpiphp and pciehp, as I only have access to
platforms that support those two drivers.

I would love it if Kenji-san could test the duplicate slot name
logic for me, as I don't have access to platforms with that
behavior.

I think this *might* be 2.6.27 material, because the original
impetus for this change was a user (Pierre Ossman) complaining
that 2.6.27 required him to pass a parameter to pciehp in order
to successfully load the module.

Although the diffstat is large, don't be fooled. The significant
portion of the additions come from the duplicate slot logic in the
PCI core. And of those changes, they were 40% comments, so it looks
like more was added than is truly the case.
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


 drivers/pci/hotplug/acpiphp.h           |    9 ++-
 drivers/pci/hotplug/acpiphp_core.c      |   37 +++++++-----
 drivers/pci/hotplug/cpci_hotplug.h      |    6 ++
 drivers/pci/hotplug/cpci_hotplug_core.c |   75 ++++++++++---------------
 drivers/pci/hotplug/cpci_hotplug_pci.c  |    4 +
 drivers/pci/hotplug/cpqphp.h            |   13 ++--
 drivers/pci/hotplug/cpqphp_core.c       |   41 +++++++-------
 drivers/pci/hotplug/fakephp.c           |   19 ++++--
 drivers/pci/hotplug/ibmphp.h            |    5 +-
 drivers/pci/hotplug/ibmphp_ebda.c       |   20 +++----
 drivers/pci/hotplug/pci_hotplug_core.c  |   29 ++++------
 drivers/pci/hotplug/pciehp.h            |   11 ++--
 drivers/pci/hotplug/pciehp_core.c       |   34 +++++------
 drivers/pci/hotplug/pciehp_ctrl.c       |   48 ++++++++--------
 drivers/pci/hotplug/pciehp_hpc.c        |   10 ---
 drivers/pci/hotplug/rpaphp.h            |   10 ++-
 drivers/pci/hotplug/rpaphp_core.c       |    6 +-
 drivers/pci/hotplug/rpaphp_pci.c        |    4 +
 drivers/pci/hotplug/rpaphp_slot.c       |   26 +++------
 drivers/pci/hotplug/sgi_hotplug.c       |   19 ++----
 drivers/pci/hotplug/shpchp.h            |    9 ++-
 drivers/pci/hotplug/shpchp_core.c       |   46 +++++----------
 drivers/pci/hotplug/shpchp_ctrl.c       |   48 ++++++++--------
 drivers/pci/slot.c                      |   93 +++++++++++++++++++++++++------
 include/linux/pci.h                     |    5 ++
 include/linux/pci_hotplug.h             |   13 +++-
 26 files changed, 328 insertions(+), 312 deletions(-)

