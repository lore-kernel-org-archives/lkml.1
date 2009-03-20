Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbZCTU4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbZCTU4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbZCTUzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:55:54 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:29989 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbZCTUzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:55:53 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v5 00/13] PCI core learns hotplug
To: jbarnes@virtuousgeek.org
Cc: achiang@hp.com, kaneshige.kenji@jp.fujitsu.com, xyzzy@speakeasy.org,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 20 Mar 2009 14:55:50 -0600
Message-ID: <20090320204327.12275.43010.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is v5 of this series that addresses the review comments from v4.

I've pushed out a new test tree that contains the updated series for
testing. The tree consists of:

	Linus's v2.6.28
	+ Jesse's linux-next queue (as of 19 March 2009)
	+ the 13 patches in this series

It does not contain the sysfs callback patch that is required for
interface torture tests. That can be had here:

	http://thread.gmane.org/gmane.linux.kernel/806648

You can pull my tree here:

  git://git.kernel.org/pub/scm/linux/kernel/git/achiang/pci-hotplug.git test-20090319

This is also a nice chance to test the shiny new patchwork instance
that we have running on kernel.org that we hope to use for linux-pci
in the future:

	http://patchwork.kernel.org/project/linux-pci/list/

I still haven't figured out the locking issue that Kenji-san pointed
out from last time, because I haven't been able to reproduce it.

Any further testing/review is welcomed and appreciated.

Thanks!

/ac

v4 -> v5:
	- acquire pci_bus_sem when walking device list in pci_rescan_bus
	- keep CONFIG_HOTPLUG (instead of CONFIG_HOTPLUG_PCI)
	- comment why we need device_schedule_callback()
	- remove CAP_SYS_ADMIN check
	- do not remove primary bus in remove_callback()
	- do not enable bridges multiple times
	- checkpatch cleanups

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

Alex Chiang (9):
      PCI Hotplug: schedule fakephp for feature removal
      PCI Hotplug: rename legacy_fakephp to fakephp
      PCI: Introduce /sys/bus/pci/devices/.../rescan
      PCI: Introduce /sys/bus/pci/devices/.../remove
      PCI: Introduce /sys/bus/pci/rescan
      PCI: Introduce pci_rescan_bus()
      PCI: do not enable bridges more than once
      PCI: do not initialize bridges more than once
      PCI: always scan child buses

Kenji Kaneshige (1):
      PCI: pci_is_root_bus helper

Trent Piepho (3):
      PCI Hotplug: restore fakephp interface with complete reimplementation
      PCI: pci_scan_slot() returns newly found devices
      PCI: don't scan existing devices


 Documentation/ABI/testing/sysfs-bus-pci    |   27 ++
 Documentation/feature-removal-schedule.txt |   33 ++
 Documentation/filesystems/sysfs-pci.txt    |   10 +
 drivers/pci/bus.c                          |    6 
 drivers/pci/hotplug/fakephp.c              |  443 +++++++---------------------
 drivers/pci/pci-driver.c                   |    1 
 drivers/pci/pci-sysfs.c                    |   81 +++++
 drivers/pci/pci.h                          |    6 
 drivers/pci/probe.c                        |  112 +++++--
 drivers/pci/setup-bus.c                    |    3 
 include/linux/pci.h                        |   12 +
 11 files changed, 356 insertions(+), 378 deletions(-)

