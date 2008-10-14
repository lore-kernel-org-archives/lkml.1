Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYJNHSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYJNHSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbYJNHSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:18:21 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:36799 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbYJNHST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:18:19 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v6 00/17] PCI: let the core manage slot names
To: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Tue, 14 Oct 2008 01:17:52 -0600
Message-ID: <20081014065843.23686.52391.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v6 of the series that implements a series of changes
that allows the PCI core to manage slot names, rather than
individual hotplug drivers.

This version fixes the problem that Kenji-san pointed out of
multiple hotplug drivers trying to claim the same slot and rename
them as well. It implements his suggestion that pci_create_slot
take a struct hotplug_slot * param.

Note that pci_create_slot doesn't actually _do_ anything with the
'hotplug' arg, it merely uses it as a signal that renaming might
be required. Arguably, the same thing could have been accomplished
with the 'rename' param from v5, but I think passing 'hotplug' makes
it more explicit that only hotplug drivers should be setting it (and
that only they are allowed to rename detected slots for legacy reasons).

Note again, that pci_hp_register is still the one managing the
->hotplug callback. pci_create_slot does _not_ set the callback.

I don't particularly like the fact that pci_create_slot has to peek
and see if the ->hotplug callback is set, but I'm slowly coming to
the conclusion that this code is just going to be a little ugly
because of all these conflicting requirements.

I've tested by loading pci_slot, fakephp (dup_slots=1), and acpiphp;
and verifying that:

	- duplicate slot names are avoided
	- hotplug drivers can override detection driver names
	- multiple hotplug drivers cannot claim the same slot

no matter what order or combination you load or unload the drivers.

Kenji-san, please take a look and let me know what you think. This
series is based off of Jesse's latest linux-next branch (99f82734).

Thanks!

/ac

v5 -> v6:
	- change 'rename' param to a 'hotplug' param
	- add Kenji-san's pci_hp_mutex cleanup to patch series
	- pci_create_slot now returns -EBUSY to pci_hp_register

v4 -> v5:
        - add 'rename' param to pci_create_slot
        - make use of 'rename' param in pci_create_slot
        - remove v4 serialization
        - remove crap false name collsion code from v2 and v3
        - rpaphp uses kstrdup (Thanks to Pekka Enberg for suggestion)

v3 -> v4:
        - Do not access hotplug_slot_name() before name initialization
        - Serialize pci_hp_register/deregister

v2 -> v3:
        - incorporate Willy's code review comments
        - fix possible memory leak, pointed out by Rolf Eike Beer
        - make false name collision detection work for empty slots
        - add 'dup_slots' module_param to fakephp to help debug all this ;)

v1 -> v2:
        - fix possible false name collisions

---

Alex Chiang (16):
      PCI Hotplug: fakephp: add duplicate slot name debugging
      PCI: Hotplug core: remove 'name'
      PCI: shcphp: remove 'name' parameter
      PCI: SGI Hotplug: stop managing bss_hotplug_slot->name
      PCI: rpaphp: kmalloc/kfree slot->name directly
      PCI: pciehp: remove 'name' parameter
      PCI: ibmphp: stop managing hotplug_slot->name
      PCI: fakephp: remove 'name' parameter
      PCI: cpqphp: stop managing hotplug_slot->name
      PCI: cpci_hotplug: stop managing hotplug_slot->name
      PCI: acpiphp: remove 'name' parameter
      PCI, PCI Hotplug: introduce slot_name helpers
      PCI: prevent duplicate slot names
      PCI: update pci_create_slot() to take a 'hotplug' param
      PCI: rename pci_update_slot_number to pci_renumber_slot
      PCI Hotplug core: add 'name' param pci_hp_register interface

Kenji Kaneshige (1):
      PCI Hotplug: serialize pci_hp_register and pci_hp_deregister


 drivers/acpi/pci_slot.c                 |    2 
 drivers/pci/hotplug/acpiphp.h           |    9 +-
 drivers/pci/hotplug/acpiphp_core.c      |   32 +++---
 drivers/pci/hotplug/cpci_hotplug.h      |    6 +
 drivers/pci/hotplug/cpci_hotplug_core.c |   75 ++++++---------
 drivers/pci/hotplug/cpci_hotplug_pci.c  |    4 -
 drivers/pci/hotplug/cpqphp.h            |   13 +--
 drivers/pci/hotplug/cpqphp_core.c       |   43 ++++----
 drivers/pci/hotplug/fakephp.c           |   26 +++--
 drivers/pci/hotplug/ibmphp.h            |    5 -
 drivers/pci/hotplug/ibmphp_ebda.c       |   19 +---
 drivers/pci/hotplug/pci_hotplug_core.c  |   64 ++++--------
 drivers/pci/hotplug/pciehp.h            |    9 +-
 drivers/pci/hotplug/pciehp_core.c       |   49 +++------
 drivers/pci/hotplug/pciehp_ctrl.c       |   53 ++++++----
 drivers/pci/hotplug/pciehp_hpc.c        |    1 
 drivers/pci/hotplug/rpaphp_slot.c       |   10 +-
 drivers/pci/hotplug/sgi_hotplug.c       |   18 +--
 drivers/pci/hotplug/shpchp.h            |    9 +-
 drivers/pci/hotplug/shpchp_core.c       |   52 ++++------
 drivers/pci/hotplug/shpchp_ctrl.c       |   48 +++++----
 drivers/pci/slot.c                      |  160 +++++++++++++++++++++++--------
 include/linux/pci.h                     |   10 ++
 include/linux/pci_hotplug.h             |   11 +-
 24 files changed, 382 insertions(+), 346 deletions(-)

