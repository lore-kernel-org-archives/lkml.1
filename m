Return-Path: <linux-kernel-owner+w=401wt.eu-S1760249AbYHFFH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbYHFFH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753977AbYHFFHs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:07:48 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:10659 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbYHFFHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:07:47 -0400
Date: Tue, 5 Aug 2008 23:07:45 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH 0/7] Fixups for duplicate slot names
Message-ID: <20080806050745.GA31319@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Pierre Ossman <drzeus-list@drzeus.cx>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>
> With this change, kobject_init_and_add() called in
> pci_create_slot() will show stack trace if a hotplug driver
> attempts to register multiple slot with the same name. That is,
> stack trace will be shown on the platform that wrongly assing
> the physical slot number to multiple slots. I'm very sorry, but
> I don't have enough time to consider how to fix it today.

Hello Kenji-san,

You are obviously correct about my prior bad patch that simply
removed the check in pci_hp_register() for duplicate names.

I also talked with Willy, and he thought that the proper way to
fix all these issues was not in the individual drivers, but in
the PCI core, which I agree with.

Here is a patch series that attempts to implement Willy's
suggestion.

Patches 1--6 convert the callers of pci_hp_register/pci_create_slot
from a static char name[] to a dynamically kmalloc'ed char *name.

There are also cleanups in the individual drivers to remove the
_slot_with_bus parameters.

Patch 7/7 implements the collision rename logic. It's not the
prettiest thing in the world, so your comments are welcome. :)

It's getting late here and I haven't had time to really test it,
other than a quick compile test, but I wanted to try and send it
so that you could take a look and possibly try it. ;)

These patches apply on top of Linus's latest tree.

Thanks!

/ac

 drivers/acpi/pci_slot.c                |   15 ++++++-
 drivers/pci/hotplug/acpiphp.h          |    2 -
 drivers/pci/hotplug/acpiphp_core.c     |   18 +++++----
 drivers/pci/hotplug/fakephp.c          |   16 ++++++--
 drivers/pci/hotplug/pci_hotplug_core.c |    4 --
 drivers/pci/hotplug/pciehp.h           |    6 +--
 drivers/pci/hotplug/pciehp_core.c      |    7 ---
 drivers/pci/hotplug/pciehp_hpc.c       |   19 ++++-----
 drivers/pci/hotplug/pcihp_skeleton.c   |   12 ++++--
 drivers/pci/hotplug/shpchp.h           |    5 +-
 drivers/pci/hotplug/shpchp_core.c      |   29 ++++----------
 drivers/pci/slot.c                     |   65 +++++++++++++++++++++++++++++----
 include/linux/pci.h                    |    3 -
 13 files changed, 124 insertions(+), 77 deletions(-)

