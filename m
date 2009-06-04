Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbZFDF61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbZFDF61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZFDF6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:58:15 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:7259 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZFDF6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:58:14 -0400
Subject: [PATCH v2 00/11] Dynamic ACPI-PCI binding
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Date: Wed, 03 Jun 2009 23:58:16 -0600
Message-ID: <20090604054504.18802.21690.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

I hope this isn't too late for the .31 merge window. If so, no big deal;
this patchset isn't urgent, it's just a nice cleanup that was inspired
from investigating the recent bug in acpi_pci_bind() (fixed by dacd254).

This patch series eliminates static boot-time binding of ACPI
and PCI devices, and introduces an API to perform this lookup
during runtime.

This change has the following advantages:

	- eliminates struct acpi_device vs struct pci_dev lifetime issues
	- lays groundwork for eliminating .bind/.unbind from acpi_device_ops
	- lays more groundwork for eliminating .start from acpi_device_ops
	  and thus simplifying ACPI drivers
  	- whacks out a lot of code

This patchset is based on lenb/test (66c74fa1d4), and has been boot
tested on ia64 and x86. I also performed physical PCI hotplug tests
using acpiphp on ia64. I do not have an acpiphp-capable x86 platform.

I didn't test the changes in the video driver either, as I don't have
the hardware.

v1 -> v2
	- rearrange series into a more logical order
	- much simpler acpi_is_root_bridge() implementation
	- no longer export acpi_pci_find_root()
	- no longer leak memory in acpi_get_pci_dev()
	- no longer leak references in acpi_pci_unbind/acpi_pci_bind
	- convert video driver to use acpi_get_pci_dev()
	- kill off acpi_get_physical_pci_device()
	- incorporate Bjorn's other comments. :)

---

Alex Chiang (11):
      ACPI: kill acpi_get_physical_pci_device()
      ACPI: video: convert to acpi_get_pci_dev
      ACPI: kill acpi_get_pci_id
      PCI Hotplug: acpiphp: convert to acpi_get_pci_dev
      ACPI: acpi_pci_unbind should clean up properly after acpi_pci_bind
      ACPI: simplify acpi_pci_irq_del_prt() API
      ACPI: simplify acpi_pci_irq_add_prt() API
      ACPI: eviscerate pci_bind.c
      ACPI: Introduce acpi_get_pci_dev()
      ACPI: Introduce acpi_is_root_bridge()
      ACPI: make acpi_pci_bind() static


 drivers/acpi/glue.c                |   40 -----
 drivers/acpi/pci_bind.c            |  315 +++++-------------------------------
 drivers/acpi/pci_irq.c             |   17 +-
 drivers/acpi/pci_root.c            |  112 ++++++++++++-
 drivers/acpi/video.c               |    6 -
 drivers/acpi/video_detect.c        |    9 +
 drivers/pci/hotplug/acpi_pcihp.c   |   40 -----
 drivers/pci/hotplug/acpiphp_glue.c |   27 +--
 include/acpi/acpi_bus.h            |    2 
 include/acpi/acpi_drivers.h        |   10 -
 include/linux/pci_hotplug.h        |    1 
 11 files changed, 179 insertions(+), 400 deletions(-)

