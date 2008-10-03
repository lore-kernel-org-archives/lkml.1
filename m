Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbYJCXRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbYJCXRi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 19:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYJCXR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 19:17:29 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:37579 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbYJCXR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 19:17:28 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v4 00/15] PCI: let the core manage slot names
To: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Fri, 03 Oct 2008 17:17:27 -0600
Message-ID: <20081003230125.9989.31145.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is v4 of the series that implements a series of changes
that allows the PCI core to manage slot names, rather than
individual hotplug drivers.

Thank you to Kenji-san and Taku-san for testing and finding my bugs.
Thanks to Willy for helping me out with the locking issues in
pci_hp_register.

Again, I have tested by loading pci_slot, acpiphp, and fakephp in various
combinations, and using the new dup_slots=1 param to fakephp. I also had:

CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y

and didn't see any complaints.

This series applies against Jesse's linux-next branch. I just fetched his
branch and peeked at it, and based on the log, my series _should_ apply
with minimal fuzz (but I didn't do a rebase because I didn't think to
check until writing this mail ;).

It would be great if folks could give one last (hopefully!) review.

Thanks.

/ac

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

Alex Chiang (15):
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
      PCI Hotplug: serialize pci_hp_register/deregister
      PCI Hotplug core: add 'name' param pci_hp_register interface


 drivers/pci/hotplug/acpiphp.h           |    9 +-
 drivers/pci/hotplug/acpiphp_core.c      |   32 +++--
 drivers/pci/hotplug/cpci_hotplug.h      |    6 +
 drivers/pci/hotplug/cpci_hotplug_core.c |   75 +++++--------
 drivers/pci/hotplug/cpci_hotplug_pci.c  |    4 -
 drivers/pci/hotplug/cpqphp.h            |   13 +-
 drivers/pci/hotplug/cpqphp_core.c       |   43 +++----
 drivers/pci/hotplug/fakephp.c           |   26 +++-
 drivers/pci/hotplug/ibmphp.h            |    5 -
 drivers/pci/hotplug/ibmphp_ebda.c       |   19 +--
 drivers/pci/hotplug/pci_hotplug_core.c  |   68 ++++++------
 drivers/pci/hotplug/pciehp.h            |    9 +-
 drivers/pci/hotplug/pciehp_core.c       |   49 +++-----
 drivers/pci/hotplug/pciehp_ctrl.c       |   53 +++++----
 drivers/pci/hotplug/pciehp_hpc.c        |    1 
 drivers/pci/hotplug/rpaphp_slot.c       |    9 +-
 drivers/pci/hotplug/sgi_hotplug.c       |   18 +--
 drivers/pci/hotplug/shpchp.h            |    9 +-
 drivers/pci/hotplug/shpchp_core.c       |   52 +++------
 drivers/pci/hotplug/shpchp_ctrl.c       |   48 ++++----
 drivers/pci/slot.c                      |  181 +++++++++++++++++++++++--------
 include/linux/pci.h                     |    9 +-
 include/linux/pci_hotplug.h             |   11 +-
 23 files changed, 407 insertions(+), 342 deletions(-)

