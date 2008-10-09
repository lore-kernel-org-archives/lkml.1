Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbYJIEql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbYJIEql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751398AbYJIEqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:46:31 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:29459 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbYJIEqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:46:30 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v5 00/16] PCI: let the core manage slot names
To: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 08 Oct 2008 22:46:29 -0600
Message-ID: <20081009043140.8678.44164.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is v5 of the series that implements a series of changes
that allows the PCI core to manage slot names, rather than
individual hotplug drivers.

Thanks again to Kenji-san for continuing to point out that my
previous attempts were racy and had horrible, complicated code. :)
And thanks to Willy for reviewing my poor attempt at introducing
locking.

I've decided to do them both a favor and take a new approach that
does not change any locking semantics in any of the existing interfaces
today (pci_hp_register, pci_hp_deregister, pci_create_slot).

Keep in mind that the problems we're trying to solve are:

	- possible duplicate slot names from firmware
	- allow hotplug drivers to override detection driver slot names

The race that Kenji-san points out occurs during slot creation, where
both a detection driver and hotplug driver try to create a slot at
the same time, with different names.

The solution is to combine slot creation _and_ slot rename into one
atomic operation via an updated pci_create_slot() API. pci_create_slot
is already serialized, so that's a good start.

We add a 'rename' parameter to pci_create_slot. The hotplug drivers set
it to 1. The detection drivers set it to 0. Now, when trying to create
a new slot:

	- check to see if it's already been created
	- if yes, and we want a rename, then go ahead and rename it
	- if yes, and we don't care about the name, then just return
	- if no, then create the slot normally

This logic is fully described in the changelog in patch 04/16. I believe
it is a much simpler approach than the earlier crap I was producing.

I tested this series with the pci_slot driver and fakephp dup_slots=1
with multiple loads and unloads in different order, and it all seemed
to work.

I _hope_ this is the last round. ;)

Thanks!

/ac

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
      PCI: update pci_create_slot() to take a 'rename' param
      PCI: rename pci_update_slot_number to pci_renumber_slot
      PCI Hotplug core: add 'name' param pci_hp_register interface


 drivers/acpi/pci_slot.c                 |    2 
 drivers/pci/hotplug/acpiphp.h           |    9 +-
 drivers/pci/hotplug/acpiphp_core.c      |   32 ++++---
 drivers/pci/hotplug/cpci_hotplug.h      |    6 +
 drivers/pci/hotplug/cpci_hotplug_core.c |   75 ++++++----------
 drivers/pci/hotplug/cpci_hotplug_pci.c  |    4 -
 drivers/pci/hotplug/cpqphp.h            |   13 +--
 drivers/pci/hotplug/cpqphp_core.c       |   43 ++++-----
 drivers/pci/hotplug/fakephp.c           |   26 ++++-
 drivers/pci/hotplug/ibmphp.h            |    5 -
 drivers/pci/hotplug/ibmphp_ebda.c       |   19 +---
 drivers/pci/hotplug/pci_hotplug_core.c  |   30 ++----
 drivers/pci/hotplug/pciehp.h            |    9 +-
 drivers/pci/hotplug/pciehp_core.c       |   49 ++++------
 drivers/pci/hotplug/pciehp_ctrl.c       |   53 ++++++-----
 drivers/pci/hotplug/pciehp_hpc.c        |    1 
 drivers/pci/hotplug/rpaphp_slot.c       |   10 +-
 drivers/pci/hotplug/sgi_hotplug.c       |   18 +---
 drivers/pci/hotplug/shpchp.h            |    9 +-
 drivers/pci/hotplug/shpchp_core.c       |   52 ++++-------
 drivers/pci/hotplug/shpchp_ctrl.c       |   48 +++++-----
 drivers/pci/slot.c                      |  150 ++++++++++++++++++++++++-------
 include/linux/pci.h                     |    9 +-
 include/linux/pci_hotplug.h             |   11 +-
 24 files changed, 359 insertions(+), 324 deletions(-)

