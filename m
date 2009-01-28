Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbZA1V7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbZA1V7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 16:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZA1V7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 16:59:06 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:17608 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbZA1V7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 16:59:05 -0500
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH 00/10] PCI core learns 'hotplug'
To: jbarnes@virtuousgeek.org
Cc: xyzzy@speakeasy.org, djwong@us.ibm.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 28 Jan 2009 14:59:02 -0700
Message-ID: <20090128213814.28003.34634.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A while ago, Darrick Wong posted a patch for fakephp that kicked off
some controversy:

	http://thread.gmane.org/gmane.linux.kernel/761944

The issue was that I broke the fakephp interface back in the 2.6.27
timeframe. After some discussion on the lists, Trent Piepho sent some
patches, and I proposed a solution incorporating those patches.

This is my first cut at making everyone happy. In summary, it:

	- introduces /sys/bus/pci/devices/.../remove for function level
	  hot-remove
	
	- introduces /sys/bus/pci/devices/.../rescan to rescan the PCI
	  hierarchy, starting at that device and descending to all children

	- introduces /sys/bus/pci/rescan to rescan the entire PCI hierarchy

	- restores the pre-2.6.27 fakephp interface for userspace compatability

Some notes:

	- I did review Rolf Eike Beer's dummyphp patch at his request. It
	  won't work for the same reasons that we cannot fix the existing
	  fakephp driver -- both use the PCI hotplug API, namely
	  pci_hp_register(), which enforces the semantic of "only one
	  slots/ entry per physical slot", which clearly does not allow
	  multiple entries for multi-function devices. One side note, Trent's
	  new fakephp driver is also much smaller and cleaner, but the
	  real reason is dummyphp uses the PCI hotplug API.

	  I hope this reasoning is fair, but if folks disagree, I'm happy
	  to discuss

	- I've been testing this patchset on my ia64 machines, which Linus
	  has called "an insane mess of PCI bridges"[1], and it seems to
	  work well. I'm just starting to test on some x86 machines, and
	  have been noticing some issues with BAR collisions, so this is
	  definitely a work-in-progress.

	- Also, you might be wondering, "how does this patchset interact
	  with existing hotplug drivers, like acpiphp or pciehp?" The answer
	  is, "poorly". :(

	  If you use the new PCI core removal/rescan and then try to modify
	  the slot using acpiphp, you get an oops. My impression is that
	  this behavior is the same as pre-2.6.27, where you could have
	  loaded fakephp and acpiphp, removed the device with fakephp,
	  and encountered an oops with acpiphp.

	  2.6.27 enforced the rule of "one hotplug driver per slot", at the
	  cost of the fakephp breakage (which started this whole discussion).

	  So, I'm not sure what to do about this. The way that we remove
	  devices today, using pci_remove_bus_device() doesn't lend itself
	  to safety very well, since it will just start removing devices
	  from the bus without checking anything.

	  Maybe we need some other API, or maybe we just live with the
	  limitation of, "if you use PCI core hotplug, don't use the
	  other hotplug drivers and vice versa".

	- Finally, a note to Jesse, even if this patchset is rejected,
	  I'd recommend taking the ASPM fix, as that is just a pure bugfix.
	  It could probably go into .29.

Thanks. Comments welcome.

/ac

1: http://lkml.org/lkml/2008/12/13/196
---

Alex Chiang (9):
      PCI: more whitespace cleanups
      PCI Hotplug: schedule fakephp for feature removal
      PCI Hotplug: rename legacy_fakephp to fakephp
      PCI: Introduce /sys/bus/pci/devices/.../rescan
      PCI: Introduce /sys/bus/pci/rescan
      PCI: Introduce /sys/bus/pci/devices/.../remove
      PCI: properly clean up ASPM link state on device remove
      PCI: always scan child buses
      PCI: don't scan existing devices

Trent Piepho (1):
      PCI Hotplug: restore fakephp interface with complete reimplementation


 Documentation/ABI/testing/sysfs-bus-pci    |   27 ++
 Documentation/feature-removal-schedule.txt |   32 ++
 drivers/pci/hotplug/fakephp.c              |  438 +++++++---------------------
 drivers/pci/pci-sysfs.c                    |   98 ++++++
 drivers/pci/pcie/aspm.c                    |    4 
 drivers/pci/probe.c                        |   68 +++-
 drivers/pci/remove.c                       |    4 
 7 files changed, 303 insertions(+), 368 deletions(-)

