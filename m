Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbXKNLr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbXKNLr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:47:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbXKNLrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:47:47 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60920 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbXKNLrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:47:46 -0500
Message-ID: <473ADF46.3020207@jp.fujitsu.com>
Date: Wed, 14 Nov 2007 20:43:02 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
Cc: gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       matthew@wil.cx, richard.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
References: <20071113000853.GA13341@ldl.fc.hp.com>
In-Reply-To: <20071113000853.GA13341@ldl.fc.hp.com>
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried the series of patches and I encountered some problems.
Since I don't have enough time to investigate them, I can only
report them at present. My environment was ia64 machine with 64
hotplug slots (shpc & pcie). Those slots can be handled by
acpiphp too, though I have not tried it yet.

- Problem(1)
  Two kind of Call Traces were displayed so many times at the
  boot time. Those are attached below. I guess it relate to
  the ACPI Namespace definition.

- Problem(2)
  Many of the shpc slot initializations failed with the
  following error messages. I guess the cause is Problem(1).

  shpchp: pci_hp_register failed with error -17
  shpchp: shpchp: slot initialization failed

- Problem(3)
  All of the pcie slot initializations failed with the
  following error messages. I guess the cause is Problem(1).

  pciehp: pci_hp_register failed with error -17
  pciehp: pciehp: slot initialization failed

BTW, I have some comments about the patches.

- I think your patches assume that all the hotplug slots have
  ACPI _SUN method regardless of the hotplug controller type,
  because pci_slot.c is the only place to call pci_slot_create().
  But I think there are hotplug slots without _SUN. If the
  hotplug slot doesn't have _SUN, slot initialization by the
  hotplug controller driver doesn't work (does it?), because
  there are no slot directory.

- I think pci_slot.o should be kernel module so that users can
  select to enable or disable this functionality.

Here is the Call Trace mentioned above:

Unable to register kobject 1024<3>pci_slot: pci_create_slot returned -22
ACPI: Invalid ACPI Bus context for device <NULL>
sysfs: duplicate filename '1024' can not be created
WARNING: at fs/sysfs/dir.c:424 sysfs_add_one()

Call Trace:
 [<a000000100014b60>] show_stack+0x40/0xa0
                                sp=e000014101befaf0 bsp=e000014101be0f60
 [<a000000100014bf0>] dump_stack+0x30/0x60
                                sp=e000014101befcc0 bsp=e000014101be0f48
 [<a0000001001d6990>] sysfs_add_one+0xb0/0x240
                                sp=e000014101befcc0 bsp=e000014101be0f18
 [<a0000001001d7900>] create_dir+0x80/0x100
                                sp=e000014101befcc0 bsp=e000014101be0ee0
 [<a0000001001d7a30>] sysfs_create_dir+0xb0/0x100
                                sp=e000014101befce0 bsp=e000014101be0ec0
 [<a0000001003b4f50>] kobject_add+0x250/0x460
                                sp=e000014101befcf0 bsp=e000014101be0e80
 [<a0000001003b52d0>] kobject_register+0x50/0xa0
                                sp=e000014101befcf0 bsp=e000014101be0e58
 [<a0000001003d6f40>] pci_create_slot+0x140/0x260
                                sp=e000014101befcf0 bsp=e000014101be0e10
 [<a00000010043acd0>] register_slot+0x170/0x1c0
                                sp=e000014101befcf0 bsp=e000014101be0dc0
 [<a000000100419ef0>] acpi_ns_walk_namespace+0x2b0/0x300
                                sp=e000014101befd20 bsp=e000014101be0d50
 [<a000000100415a50>] acpi_walk_namespace+0x90/0xc0
                                sp=e000014101befd20 bsp=e000014101be0d00
 [<a00000010043ab20>] acpi_pci_slot_add+0x1c0/0x200
                                sp=e000014101befd20 bsp=e000014101be0cd8
 [<a0000001004367e0>] acpi_pci_register_driver+0xe0/0x160
                                sp=e000014101befd30 bsp=e000014101be0ca8
 [<a000000100920620>] acpi_pci_slot_init+0x20/0x40
                                sp=e000014101befd30 bsp=e000014101be0c90
 [<a0000001008f06e0>] kernel_init+0x460/0x7e0
                                sp=e000014101befd30 bsp=e000014101be0c48
 [<a000000100013110>] kernel_thread_helper+0x30/0x60
                                sp=e000014101befe30 bsp=e000014101be0c20
 [<a0000001000089c0>] start_kernel_thread+0x20/0x40
                                sp=e000014101befe30 bsp=e000014101be0c20
kobject_add failed for 1024 with -EEXIST, don't try to register things with the
same name in the same directory.

Call Trace:
 [<a000000100014b60>] show_stack+0x40/0xa0
                                sp=e000014101befb20 bsp=e000014101be0ed8
 [<a000000100014bf0>] dump_stack+0x30/0x60
                                sp=e000014101befcf0 bsp=e000014101be0ec0
 [<a0000001003b50e0>] kobject_add+0x3e0/0x460
                                sp=e000014101befcf0 bsp=e000014101be0e80
 [<a0000001003b52d0>] kobject_register+0x50/0xa0
                                sp=e000014101befcf0 bsp=e000014101be0e58
 [<a0000001003d6f40>] pci_create_slot+0x140/0x260
                                sp=e000014101befcf0 bsp=e000014101be0e10
 [<a00000010043acd0>] register_slot+0x170/0x1c0
                                sp=e000014101befcf0 bsp=e000014101be0dc0
 [<a000000100419ef0>] acpi_ns_walk_namespace+0x2b0/0x300
                                sp=e000014101befd20 bsp=e000014101be0d50
 [<a000000100415a50>] acpi_walk_namespace+0x90/0xc0
                                sp=e000014101befd20 bsp=e000014101be0d00
 [<a00000010043ab20>] acpi_pci_slot_add+0x1c0/0x200
                                sp=e000014101befd20 bsp=e000014101be0cd8
 [<a0000001004367e0>] acpi_pci_register_driver+0xe0/0x160
                                sp=e000014101befd30 bsp=e000014101be0ca8
 [<a000000100920620>] acpi_pci_slot_init+0x20/0x40
                                sp=e000014101befd30 bsp=e000014101be0c90
 [<a0000001008f06e0>] kernel_init+0x460/0x7e0
                                sp=e000014101befd30 bsp=e000014101be0c48
 [<a000000100013110>] kernel_thread_helper+0x30/0x60
                                sp=e000014101befe30 bsp=e000014101be0c20
 [<a0000001000089c0>] start_kernel_thread+0x20/0x40
                                sp=e000014101befe30 bsp=e000014101be0c20
Unable to register kobject 1024<3>pci_slot: pci_create_slot returned -22


Thanks,
Kenji Kaneshige


Alex Chiang ????????:
> Hello,
> 
> [this patch series touches a few subsystems; hopefully I got all
> the right maintainers]
> 
> Recently, Matthew Wilcox sent out the following mail about PCI
> slots:
> 
>   http://marc.info/?l=linux-pci&m=119432330418980&w=2
> 
> The following patch series is a rough first cut at implementing
> the ideas he outlined, namely, that PCI slots are physical
> objects that we care about, independent of their hotplug
> capabilities.
> 
> We introduce a struct pci_slot as a first-class citizen, and turn
> hotplug_slot into a subsidiary structure. A brief glimpse at the
> potential for cleanup is given, as we modify the existing hotplug
> drivers and remove the multiple get_address() methods. Certainly
> more cleanup can be done with this new structure.
> 
> Additionally, we introduce an ACPI PCI slot driver, which will
> detect all physical PCI slots in the system (as described by
> ACPI). De-coupling the notion of a physical slot from its hotplug
> capability allows users to understand the physical geography of
> their machines, whether their slots are hotpluggable or not.
> 
> This patch series builds heavily on Willy's prior work (with a
> bit of the typical refresh needed when aiming at the moving
> target of the kernel). The ACPI PCI slot driver is new.
> 
> I have tested this series on both ia64 (hp rx6600) and x86 (hp
> dl380g). On ia64, system firmware provides _SUN methods for the
> PCI slots and we get entries in /sys/bus/pci/slots/. On my x86
> machine, firmware didn't seem to provide a _SUN, so we don't get
> any entries in /sys/bus/pci/slots/, but nothing really bad
> happens either. ;)
> 
> Comments/feedback are appreciated.
> 
> Thanks.
> 
> /ac
> 
> 
> 


