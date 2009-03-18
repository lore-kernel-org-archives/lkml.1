Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbZCRWjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbZCRWjl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbZCRWj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:39:29 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:2551 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbZCRWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:39:28 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v4 00/12] PCI core learns hotplug
To: jbarnes@virtuousgeek.org
Cc: shimada-yxb@necst.nec.co.jp, achiang@hp.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 18 Mar 2009 16:39:25 -0600
Message-ID: <20090318222426.887.1008.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're getting close to the new merge window, and I _think_ this
patch series is ready for consideration. Notably:

	- multiple rescans/removes of devices with and without bridges
	- verified that resource allocation after multiple remove/rescan
	  cycles is the same as what we had during initial boot
	- fixes the complete suckage of fakephp (that I created)
	- doesn't affect existing hotplug drivers
	- tested on x86 and ia64 platforms

Please review, and consider testing. For testing ease, you can pull
from my git branch:

	git://git.kernel.org/pub/scm/linux/kernel/git/achiang/pci-hotplug.git
	branch 'test-20090318' is what you want

Note, this test branch does contain the small assorted patches in AER
and the PCIe portdriver that I fixed along the way, but does not contain
the sysfs callback mutex that I introduced to protect myself from
Vegard Nossum. ;) If you want to hammer away at the sysfs interface,
please apply this patch on top:

	http://thread.gmane.org/gmane.linux.kernel/806648

What I'm continuing to do:

	- investigate converting existing hotplug drivers to use
	  new pci_rescan_bus() interface

Thanks.

/ac

v3 -> v4:
	- protect sysfs interfaces with mutex
	- undo changes in pci_do_scan_bus
	- introduce pci_rescan_bus instead
	- do not initialize bridges more than once

v2 -> v3:
	- properly remove device with internal bridge
	- added Kenji Kaneshige's pci_is_root_bus() interface
	- dropped whitespace cleanups for another time

v1 -> v2:
	- incorporated lots of Trent Piepho's work
	- beefed up pci_do_scan_bus as heavy lifter for rescanning
	- small bugfixes folded into earlier patches to get everything working

---

Alex Chiang (8):
      PCI Hotplug: schedule fakephp for feature removal
      PCI Hotplug: rename legacy_fakephp to fakephp
      PCI: Introduce /sys/bus/pci/devices/.../rescan
      PCI: Introduce /sys/bus/pci/devices/.../remove
      PCI: Introduce /sys/bus/pci/rescan
      PCI: Introduce pci_rescan_bus()
      PCI: do not initialize bridges more than once
      PCI: always scan child buses

Kenji Kaneshige (1):
      PCI: pci_is_root_bus helper

Trent Piepho (3):
      PCI Hotplug: restore fakephp interface with complete reimplementation
      PCI: pci_scan_slot() returns newly found devices
      PCI: don't scan existing devices


 Documentation/ABI/testing/sysfs-bus-pci    |   27 ++
 Documentation/feature-removal-schedule.txt |   32 ++
 Documentation/filesystems/sysfs-pci.txt    |   10 +
 drivers/pci/hotplug/fakephp.c              |  443 +++++++---------------------
 drivers/pci/pci-driver.c                   |    1 
 drivers/pci/pci-sysfs.c                    |   95 ++++++
 drivers/pci/pci.h                          |    6 
 drivers/pci/probe.c                        |  103 ++++---
 drivers/pci/setup-bus.c                    |    3 
 include/linux/pci.h                        |   12 +
 10 files changed, 358 insertions(+), 374 deletions(-)

