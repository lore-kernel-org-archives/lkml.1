Return-Path: <linux-kernel-owner+w=401wt.eu-S1753162AbZCIFtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbZCIFtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 01:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZCIFsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 01:48:40 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:46801 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbZCIFsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 01:48:39 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v3 00/11] PCI core learns hotplug
To: jbarnes@virtuousgeek.org
Cc: xyzzy@speakeasy.org, djwong@us.ibm.com, shimada-yxb@necst.nec.co.jp,
       rjw@sisk.pl, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 08 Mar 2009 23:48:35 -0600
Message-ID: <20090309052933.3918.86601.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v3 of the patch series that introduces function-level hotplug 
to the PCI core. It is against Jesse's linux-next branch.

I've been doing lots of testing, and found and fixed several small
buglets, both in my code and elsewhere in PCI. In order to test this
patchset, you will also need these patches:

	http://thread.gmane.org/gmane.linux.kernel.pci/3437
	http://lkml.org/lkml/2009/3/7/173

There is still one major bug somewhere that shows up only when using
the PCIe portdriver (that is, any time PCIe support is built into
the kernel). You get an oops during multiple remove/rescan cycles,
especially on devices with an internal bridge.

This symptom does not appear on the exact same hardware topology, removing
and rescanning the exact same device, when not using the PCIe port driver.

I'm still not sure what's going on, so if anyone wants to play with
this series, I'd truly appreciate any help.

Thanks.

/ac

v2 -> v3:
	- properly remove device with internal bridge
	- added Kenji Kaneshige's pci_is_root_bus() interface
	- dropped whitespace cleanups for another time

v1 -> v2:
	- incorporated lots of Trent Piepho's work
	- beefed up pci_do_scan_bus as heavy lifter for rescanning
	- small bugfixes folded into earlier patches to get everything working
---

Alex Chiang (7):
      PCI Hotplug: schedule fakephp for feature removal
      PCI Hotplug: rename legacy_fakephp to fakephp
      PCI: Introduce /sys/bus/pci/devices/.../rescan
      PCI: Introduce /sys/bus/pci/devices/.../remove
      PCI: Introduce /sys/bus/pci/rescan
      PCI: beef up pci_do_scan_bus()
      PCI: always scan child buses

Kenji Kaneshige (1):
      PCI: pci_is_root_bus helper

Trent Piepho (3):
      PCI Hotplug: restore fakephp interface with complete reimplementation
      PCI: pci_scan_slot() returns newly found devices
      PCI: don't scan existing devices


 Documentation/ABI/testing/sysfs-bus-pci    |   27 ++
 Documentation/feature-removal-schedule.txt |   32 ++
 Documentation/filesystems/sysfs-pci.txt    |    9 +
 drivers/pci/hotplug-pci.c                  |   16 +
 drivers/pci/hotplug/fakephp.c              |  443 +++++++---------------------
 drivers/pci/pci-sysfs.c                    |   89 ++++++
 drivers/pci/probe.c                        |   74 ++---
 include/linux/pci.h                        |    9 +
 8 files changed, 321 insertions(+), 378 deletions(-)

