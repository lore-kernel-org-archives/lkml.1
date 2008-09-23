Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYIWQp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYIWQp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 12:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYIWQpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 12:45:16 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:44368 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbYIWQpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 12:45:14 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v3 00/14] PCI: let the core manage slot names
To: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 23 Sep 2008 10:45:13 -0600
Message-ID: <20080923163753.12628.98683.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse, Kenji, et al,

This is v3 of the series that implements a series of changes
that allows the PCI core to manage slot names, rather than
individual hotplug drivers.

v2 -> v3:
	- incorporate Willy's code review comments
	- fix possible memory leak, pointed out by Rolf Eike Beer
	- make false name collision detection work for empty slots
	- add 'dup_slots' module_param to fakephp to help debug all this ;)

v1 -> v2:
	- fix possible false name collisions

This series applies against linux-next. I've tested this by loading
pci_slot and various hotplug drivers to ensure that the hotplug drivers
can successfully override the pci_slot names.

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

Alex Chiang (14):
      PCI Hotplug: fakephp: add duplicate slot name debugging
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
 drivers/pci/hotplug/acpiphp_core.c      |   32 +++---
 drivers/pci/hotplug/cpci_hotplug.h      |    6 +
 drivers/pci/hotplug/cpci_hotplug_core.c |   74 +++++---------
 drivers/pci/hotplug/cpci_hotplug_pci.c  |    4 -
 drivers/pci/hotplug/cpqphp.h            |   13 +-
 drivers/pci/hotplug/cpqphp_core.c       |   42 ++++----
 drivers/pci/hotplug/fakephp.c           |   25 +++--
 drivers/pci/hotplug/ibmphp.h            |    5 -
 drivers/pci/hotplug/ibmphp_ebda.c       |   19 +---
 drivers/pci/hotplug/pci_hotplug_core.c  |   62 ++++++------
 drivers/pci/hotplug/pciehp.h            |    9 +-
 drivers/pci/hotplug/pciehp_core.c       |   41 +++-----
 drivers/pci/hotplug/pciehp_ctrl.c       |   53 +++++-----
 drivers/pci/hotplug/pciehp_hpc.c        |    1 
 drivers/pci/hotplug/rpaphp.h            |   10 +-
 drivers/pci/hotplug/rpaphp_core.c       |    6 +
 drivers/pci/hotplug/rpaphp_pci.c        |    4 -
 drivers/pci/hotplug/rpaphp_slot.c       |   26 ++---
 drivers/pci/hotplug/sgi_hotplug.c       |   18 +--
 drivers/pci/hotplug/shpchp.h            |    9 +-
 drivers/pci/hotplug/shpchp_core.c       |   42 +++-----
 drivers/pci/hotplug/shpchp_ctrl.c       |   48 ++++-----
 drivers/pci/slot.c                      |  167 +++++++++++++++++++++++--------
 include/linux/pci.h                     |    9 +-
 include/linux/pci_hotplug.h             |   13 ++
 26 files changed, 401 insertions(+), 346 deletions(-)

