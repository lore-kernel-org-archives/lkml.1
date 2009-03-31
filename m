Return-Path: <linux-kernel-owner+w=401wt.eu-S1762213AbZCaPX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762213AbZCaPX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758854AbZCaPXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:23:09 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:14817 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758736AbZCaPXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:23:07 -0400
Subject: [PATCH 00/15] PCI Hotplug: cpqphp cleanups
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:23:05 -0600
Message-ID: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

This is my first pass at cleaning up cpqphp. Why? I dunno, I found
some old hardware and thought it might be fun to clean up a crufty
old driver.

This series is mostly whitespace and style fixes. A few functions
have been reworked so they aren't indented quite so much. I expect
that the first few patches will be very hard to read because there's
so much code movement, but it does help with readability towards the
end of the series.

At the end of the series, we start to see some more interesting
changes. For one, we no longer call pcibios_get_irq_routing_table
nearly as often.

The other is removing the pci_find_slot() interface. I'm still in
the process of untangling exactly what the lifetime rules are for
a pci_dev in cpqphp, but this is a good step forward, and also
finally gets rid of the last in-tree caller of pci_find_slot(), which
would be nice for 2.6.30. Also, this means that cpqphp no longer
depends on PCI_LEGACY.

The current functional state of cpqphp is broken. We are able to load
the module and successfully power off cards. We have some issues when
we try to power them back on though, because commit b81d988c "broke"
cpqphp and we get BAR collisions when we try to hot-add. However, I
use "broke" very loosely, as I agree with Bjorn's commit, and cpqphp
is doing horrible things like essentially duplicating a lot of the
PCI core, incorrectly, I might add. Once I rip out some more of the
PCI code in cpqphp, I expect hot-add to work again.

I plan on untangling that in the next phase of cleanups.

I've successfully tested my changes on my DL580g2. No functional
regressions (compared to behavior since b81d988c).

Anyhow, please consider applying this series for the current merge
window. I'd like to be able to turn off PCI_LEGACY. :)

Thanks!

/ac

---

Alex Chiang (15):
      PCI: remove deprecated pci_find_slot() interface
      PCI Hotplug: cpqphp: don't use pci_find_slot()
      PCI Hotplug: cpqphp: constify slot_name()
      PCI Hotplug: cpqphp: eliminate dead code - PCI_ScanBusNonBridge
      PCI Hotplug: cpqphp: clean up accesses to pcibios_get_irq_routing_table()
      PCI Hotplug: cpqphp: refactor cpqhp_save_config
      PCI Hotplug: cpqphp: style cleanups
      PCI Hotplug: cpqphp: refactor cpqphp_save_slot_config
      PCI Hotplug: cpqphp: clean up cpqphp_ctrl.c
      PCI Hotplug: cpqphp: refactor cpqhp_probe
      PCI Hotplug: cpqphp: eliminate stray braces
      PCI Hotplug: cpqphp: remove useless prototypes in cpqphp_core.c
      PCI Hotplug: cpqphp: obey 80 column convention in cpqphp.h
      PCI Hotplug: cpqphp: fix comment style
      PCI Hotplug: cpqphp: stray whitespace cleanups


 drivers/pci/hotplug/Kconfig        |    2 
 drivers/pci/hotplug/cpqphp.h       |  167 +++--
 drivers/pci/hotplug/cpqphp_core.c  | 1101 +++++++++++++++++-------------------
 drivers/pci/hotplug/cpqphp_ctrl.c  |  371 ++++++------
 drivers/pci/hotplug/cpqphp_nvram.c |   97 ++-
 drivers/pci/hotplug/cpqphp_pci.c   |  599 ++++++++++----------
 drivers/pci/search.c               |   30 -
 include/linux/pci.h                |    8 
 8 files changed, 1162 insertions(+), 1213 deletions(-)

