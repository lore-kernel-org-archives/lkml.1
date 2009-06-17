Return-Path: <linux-kernel-owner+w=401wt.eu-S1760511AbZFQUGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511AbZFQUGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbZFQUF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:05:56 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:34655 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbZFQUFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:05:54 -0400
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in
 resources trees
From: Andrew Patterson <andrew.patterson@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
In-Reply-To: <alpine.LFD.2.01.0906171047050.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio>
	 <4A38B3B4.1020304@jp.fujitsu.com> <20090617134311.GR19977@parisc-linux.org>
	 <alpine.LFD.2.01.0906170922380.16802@localhost.localdomain>
	 <1245260533.8234.241.camel@bluto.andrew>
	 <alpine.LFD.2.01.0906171047050.16802@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 14:08:36 -0600
Message-Id: <1245269316.8234.270.camel@bluto.andrew>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 11:12 -0700, Linus Torvalds wrote:
> 
> On Wed, 17 Jun 2009, Andrew Patterson wrote:
> > 
> > I tried Mathew's patch.  It did not help.  Here are the resources with
> > the applied patch:
> > 
> > 0000000-fdffffff : PCI Bus 0000:c3
> 
>   ^^^^
> I think you missed the initial 'f' in your cut-and-paste.
> 
> >   f0000000-fdffffff : PCI Bus 0000:c2
> >     f0000000-f00fffff : 0000:c3:00.1
> >       f0000000-f00fffff : qla2xxx
> >     f0100000-f01fffff : 0000:c3:00.0
> >       f0100000-f01fffff : qla2xxx
> >     f0200000-f023ffff : 0000:c3:00.1
> >     f0240000-f027ffff : 0000:c3:00.0
> >     f0280000-f0283fff : 0000:c3:00.1
> >       f0280000-f0283fff : qla2xxx
> >     f0284000-f0287fff : 0000:c3:00.0
> >       f0284000-f0287fff : qla2xxx
> > 
> > Note we still have the incorrect parenting problem.  
> 
> Hmm.
> 
> > At Mathew's suggestion, I added some trace code using the following
> > patch:
> > 
> > diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> > index 3039fcb..e2d2814 100644
> > --- a/drivers/pci/setup-res.c
> > +++ b/drivers/pci/setup-res.c
> > @@ -99,11 +99,12 @@ void pci_update_resource(struct pci_dev *dev, int resno)
> >  int pci_claim_resource(struct pci_dev *dev, int resource)
> >  {
> >         struct resource *res = &dev->resource[resource];
> > -       struct resource *root = NULL;
> > +       struct resource *root;
> >         char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
> >         int err;
> >  
> > -       root = pcibios_select_root(dev, res);
> > +       root = pci_find_parent_resource(dev, res);
> > +       dev_printk(KERN_EMERG, &dev->dev, "%s: root = %pR, res = %pR\n", __func__, root, res);
> 
> I'd really like to have seen the name of the resource too.
> 

I can do that.

> Just showing the resource ranges is kind of pointless when they match.
> 
> But I'm starting to have a suspicion here:
> 
> > PCI: Scanning bus 0000:c2
> > pci 0000:c2:00.0: found [103c:403b] class 000604 header type 01
> > pci 0000:c2:00.0: calling quirk_resource_alignment+0x0/0x3a0
> > pci 0000:c2:00.0: calling pci_fixup_video+0x0/0x280
> > pci 0000:c2:00.0: PME# supported from D0 D3hot D3cold
> > pci 0000:c2:00.0: PME# disabled
> > PCI: Fixups for bus 0000:c2
> > pci 0000:c2:00.0: scanning behind bridge, config fbc3c2, pass 0
> > PCI: Scanning bus 0000:c3
> > pci 0000:c3:00.0: found [1077:2532] class 000c04 header type 00
> > pci 0000:c3:00.0: reg 10 io port: [0x1100-0x11ff]
> > pci 0000:c3:00.0: reg 14 64bit mmio: [0xf0284000-0xf0287fff]
> > pci 0000:c3:00.0: reg 1c 64bit mmio: [0xf0100000-0xf01fffff]
> > pci 0000:c3:00.0: reg 30 32bit mmio: [0xf0240000-0xf027ffff]
> > pci 0000:c3:00.0: calling quirk_resource_alignment+0x0/0x3a0
> > pci 0000:c3:00.0: calling pci_fixup_video+0x0/0x280
> > pci 0000:c3:00.1: found [1077:2532] class 000c04 header type 00
> > pci 0000:c3:00.1: reg 10 io port: [0x1000-0x10ff]
> > pci 0000:c3:00.1: reg 14 64bit mmio: [0xf0280000-0xf0283fff]
> > pci 0000:c3:00.1: reg 1c 64bit mmio: [0xf0000000-0xf00fffff]
> > pci 0000:c3:00.1: reg 30 32bit mmio: [0xf0200000-0xf023ffff]
> > pci 0000:c3:00.1: calling quirk_resource_alignment+0x0/0x3a0
> > pci 0000:c3:00.1: calling pci_fixup_video+0x0/0x280
> > PCI: Fixups for bus 0000:c3
> > pci 0000:c2:00.0: bridge io port: [0x1000-0xffff]
> > pci 0000:c2:00.0: bridge 32bit mmio: [0xf0000000-0xfdffffff]
> > pci 0000:c2:00.0: bridge 64bit mmio pref: [0x80780000000-0x807ffffffff]
> > pci 0000:c2:00.0: pci_claim_resource: root = [0x00-0xffffffffffffffff], res = [0x8001000-0x800ffff]
> > pci 0000:c2:00.0: pci_claim_resource: root = [0x000000-0xffffffffffffffff], res = [0xf0000000-0xfdffffff]
> > pci 0000:c2:00.0: pci_claim_resource: root = [0x000000-0xffffffffffffffff], res = [0x80780000000-0x807ffffffff]
> > pci 0000:c3:00.0: pci_claim_resource: root = [0x8001000-0x800ffff], res = [0x8001100-0x80011ff]
> > pci 0000:c3:00.0: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf0284000-0xf0287fff]
> > pci 0000:c3:00.0: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf0100000-0xf01fffff]
> > pci 0000:c3:00.0: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf0240000-0xf027ffff]
> > pci 0000:c3:00.1: pci_claim_resource: root = [0x8001000-0x800ffff], res = [0x8001000-0x80010ff]
> > pci 0000:c3:00.1: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf0280000-0xf0283fff]
> > pci 0000:c3:00.1: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf0000000-0xf00fffff]
> > pci 0000:c3:00.1: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf0200000-0xf023ffff]
> > PCI: Bus scan for 0000:c3 returning with max=c3
> > pci 0000:c2:00.0: scanning behind bridge, config fbc3c2, pass 1
> > PCI: Bus scan for 0000:c2 returning with max=fb
> 
> You're not actually showing the case where you have that error case of
> "0xf0000000-0xfdffffff" inside another "0xf0000000-0xfdffffff"
> 
> IOW, that one is done in some totally different place, not in 
> 'pci_claim_resource()' at all.
> 
> So no wonder it makes no difference when pci_claim_resource() is fixed.
> 
> This is why I'd really like to see the output of my test-patch. It would 
> show exactly _where_ that resource is inserted, and the whole call-chain.
> 
> I'm appending a version that only does it for resources that have names 
> starting with "PCI Bus", so it should be less noisy. But again, it's 
> totally untested.
> 

Here you go (I can provide the full boot log if needed). Note, there is
nothing for c3 here:

.
.
.

ACPI: PCI Root Bridge [L007] (0000:c2)
------------[ cut here ]------------
WARNING: at kernel/resource.c:147 __set_parent+0xc0/0xe0()
Hardware name: server rx6600                   
__request_resource: parent of 'PCI Bus 0000:c2 I/O Ports
08000000-0800ffff' is 'PCI mem'
Modules linked in:

Call Trace:
 [<a000000100015b70>] show_stack+0x50/0xa0
                                sp=e0000100603dfb30 bsp=e0000100603d9188
 [<a000000100015bf0>] dump_stack+0x30/0x60
                                sp=e0000100603dfd00 bsp=e0000100603d9170
 [<a00000010006fa00>] warn_slowpath_common+0xc0/0x100
                                sp=e0000100603dfd00 bsp=e0000100603d9138
 [<a00000010006fb30>] warn_slowpath_fmt+0x90/0xc0
                                sp=e0000100603dfd00 bsp=e0000100603d90d8
 [<a00000010007ef40>] __set_parent+0xc0/0xe0
                                sp=e0000100603dfd40 bsp=e0000100603d90a0
 [<a00000010007f060>] __request_resource+0x100/0x160
                                sp=e0000100603dfd40 bsp=e0000100603d9078
 [<a00000010007f3e0>] __insert_resource+0x20/0x2a0
                                sp=e0000100603dfd40 bsp=e0000100603d9038
 [<a00000010007f990>] insert_resource+0x30/0x80
                                sp=e0000100603dfd40 bsp=e0000100603d9010
 [<a000000100a008d0>] add_window+0x490/0x6a0
                                sp=e0000100603dfd40 bsp=e0000100603d8fa0
 [<a0000001005b2250>] acpi_walk_resources+0x1f0/0x340
                                sp=e0000100603dfd90 bsp=e0000100603d8f60
 [<a000000100a00110>] pci_acpi_scan_root+0x210/0x3e0
                                sp=e0000100603dfda0 bsp=e0000100603d8f18
 [<a0000001009e95c0>] acpi_pci_root_add+0x5c0/0x8c0
                                sp=e0000100603dfdc0 bsp=e0000100603d8ed8
 [<a000000100555420>] acpi_device_probe+0xa0/0x3c0
                                sp=e0000100603dfde0 bsp=e0000100603d8e98
 [<a0000001006395a0>] driver_probe_device+0x180/0x2a0
                                sp=e0000100603dfde0 bsp=e0000100603d8e68
 [<a0000001006397a0>] __driver_attach+0xe0/0x140
                                sp=e0000100603dfde0 bsp=e0000100603d8e38
 [<a000000100637aa0>] bus_for_each_dev+0xa0/0x120
                                sp=e0000100603dfde0 bsp=e0000100603d8e00
 [<a0000001006391e0>] driver_attach+0x40/0x60
                                sp=e0000100603dfdf0 bsp=e0000100603d8dd8
 [<a000000100638840>] bus_add_driver+0x1a0/0x540
                                sp=e0000100603dfdf0 bsp=e0000100603d8d90
 [<a00000010063a0b0>] driver_register+0x210/0x3a0
                                sp=e0000100603dfdf0 bsp=e0000100603d8d48
 [<a000000100558d30>] acpi_bus_register_driver+0x50/0x80
                                sp=e0000100603dfdf0 bsp=e0000100603d8d28
 [<a000000100cd1740>] acpi_pci_root_init+0x20/0x60
                                sp=e0000100603dfdf0 bsp=e0000100603d8d10
 [<a00000010000a630>] do_one_initcall+0xb0/0x2a0
                                sp=e0000100603dfdf0 bsp=e0000100603d8cd0
 [<a000000100c9c630>] kernel_init+0x310/0x3c0
                                sp=e0000100603dfe30 bsp=e0000100603d8c88
 [<a000000100014390>] kernel_thread_helper+0x30/0x60
                                sp=e0000100603dfe30 bsp=e0000100603d8c60
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e0000100603dfe30 bsp=e0000100603d8c60
---[ end trace 4eaa2a86a8e2da42 ]---
------------[ cut here ]------------
WARNING: at kernel/resource.c:147 __set_parent+0xc0/0xe0()
Hardware name: server rx6600                   
__request_resource: parent of 'PCI Bus 0000:c2' is 'PCI IO'
Modules linked in:

Call Trace:
 [<a000000100015b70>] show_stack+0x50/0xa0
                                sp=e0000100603dfb30 bsp=e0000100603d9188
 [<a000000100015bf0>] dump_stack+0x30/0x60
                                sp=e0000100603dfd00 bsp=e0000100603d9170
 [<a00000010006fa00>] warn_slowpath_common+0xc0/0x100
                                sp=e0000100603dfd00 bsp=e0000100603d9138
 [<a00000010006fb30>] warn_slowpath_fmt+0x90/0xc0
                                sp=e0000100603dfd00 bsp=e0000100603d90d8
 [<a00000010007ef40>] __set_parent+0xc0/0xe0
                                sp=e0000100603dfd40 bsp=e0000100603d90a0
 [<a00000010007f060>] __request_resource+0x100/0x160
                                sp=e0000100603dfd40 bsp=e0000100603d9078
 [<a00000010007f3e0>] __insert_resource+0x20/0x2a0
                                sp=e0000100603dfd40 bsp=e0000100603d9038
 [<a00000010007f990>] insert_resource+0x30/0x80
                                sp=e0000100603dfd40 bsp=e0000100603d9010
 [<a000000100a00a20>] add_window+0x5e0/0x6a0
                                sp=e0000100603dfd40 bsp=e0000100603d8fa0
 [<a0000001005b2250>] acpi_walk_resources+0x1f0/0x340
                                sp=e0000100603dfd90 bsp=e0000100603d8f60
 [<a000000100a00110>] pci_acpi_scan_root+0x210/0x3e0
                                sp=e0000100603dfda0 bsp=e0000100603d8f18
 [<a0000001009e95c0>] acpi_pci_root_add+0x5c0/0x8c0
                                sp=e0000100603dfdc0 bsp=e0000100603d8ed8
 [<a000000100555420>] acpi_device_probe+0xa0/0x3c0
                                sp=e0000100603dfde0 bsp=e0000100603d8e98
 [<a0000001006395a0>] driver_probe_device+0x180/0x2a0
                                sp=e0000100603dfde0 bsp=e0000100603d8e68
 [<a0000001006397a0>] __driver_attach+0xe0/0x140
                                sp=e0000100603dfde0 bsp=e0000100603d8e38
 [<a000000100637aa0>] bus_for_each_dev+0xa0/0x120
                                sp=e0000100603dfde0 bsp=e0000100603d8e00
 [<a0000001006391e0>] driver_attach+0x40/0x60
                                sp=e0000100603dfdf0 bsp=e0000100603d8dd8
 [<a000000100638840>] bus_add_driver+0x1a0/0x540
                                sp=e0000100603dfdf0 bsp=e0000100603d8d90
 [<a00000010063a0b0>] driver_register+0x210/0x3a0
                                sp=e0000100603dfdf0 bsp=e0000100603d8d48
 [<a000000100558d30>] acpi_bus_register_driver+0x50/0x80
                                sp=e0000100603dfdf0 bsp=e0000100603d8d28
 [<a000000100cd1740>] acpi_pci_root_init+0x20/0x60
                                sp=e0000100603dfdf0 bsp=e0000100603d8d10
 [<a00000010000a630>] do_one_initcall+0xb0/0x2a0
                                sp=e0000100603dfdf0 bsp=e0000100603d8cd0
 [<a000000100c9c630>] kernel_init+0x310/0x3c0
                                sp=e0000100603dfe30 bsp=e0000100603d8c88
 [<a000000100014390>] kernel_thread_helper+0x30/0x60
                                sp=e0000100603dfe30 bsp=e0000100603d8c60
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e0000100603dfe30 bsp=e0000100603d8c60
---[ end trace 4eaa2a86a8e2da43 ]---
------------[ cut here ]------------
WARNING: at kernel/resource.c:147 __set_parent+0xc0/0xe0()
Hardware name: server rx6600                   
__request_resource: parent of 'PCI Bus 0000:c2' is 'PCI mem'
Modules linked in:

Call Trace:
 [<a000000100015b70>] show_stack+0x50/0xa0
                                sp=e0000100603dfb30 bsp=e0000100603d9188
 [<a000000100015bf0>] dump_stack+0x30/0x60
                                sp=e0000100603dfd00 bsp=e0000100603d9170
 [<a00000010006fa00>] warn_slowpath_common+0xc0/0x100
                                sp=e0000100603dfd00 bsp=e0000100603d9138
 [<a00000010006fb30>] warn_slowpath_fmt+0x90/0xc0
                                sp=e0000100603dfd00 bsp=e0000100603d90d8
 [<a00000010007ef40>] __set_parent+0xc0/0xe0
                                sp=e0000100603dfd40 bsp=e0000100603d90a0
 [<a00000010007f060>] __request_resource+0x100/0x160
                                sp=e0000100603dfd40 bsp=e0000100603d9078
 [<a00000010007f3e0>] __insert_resource+0x20/0x2a0
                                sp=e0000100603dfd40 bsp=e0000100603d9038
 [<a00000010007f990>] insert_resource+0x30/0x80
                                sp=e0000100603dfd40 bsp=e0000100603d9010
 [<a000000100a00a20>] add_window+0x5e0/0x6a0
                                sp=e0000100603dfd40 bsp=e0000100603d8fa0
 [<a0000001005b2250>] acpi_walk_resources+0x1f0/0x340
                                sp=e0000100603dfd90 bsp=e0000100603d8f60
 [<a000000100a00110>] pci_acpi_scan_root+0x210/0x3e0
                                sp=e0000100603dfda0 bsp=e0000100603d8f18
 [<a0000001009e95c0>] acpi_pci_root_add+0x5c0/0x8c0
                                sp=e0000100603dfdc0 bsp=e0000100603d8ed8
 [<a000000100555420>] acpi_device_probe+0xa0/0x3c0
                                sp=e0000100603dfde0 bsp=e0000100603d8e98
 [<a0000001006395a0>] driver_probe_device+0x180/0x2a0
                                sp=e0000100603dfde0 bsp=e0000100603d8e68
 [<a0000001006397a0>] __driver_attach+0xe0/0x140
                                sp=e0000100603dfde0 bsp=e0000100603d8e38
 [<a000000100637aa0>] bus_for_each_dev+0xa0/0x120
                                sp=e0000100603dfde0 bsp=e0000100603d8e00
 [<a0000001006391e0>] driver_attach+0x40/0x60
                                sp=e0000100603dfdf0 bsp=e0000100603d8dd8
 [<a000000100638840>] bus_add_driver+0x1a0/0x540
                                sp=e0000100603dfdf0 bsp=e0000100603d8d90
 [<a00000010063a0b0>] driver_register+0x210/0x3a0
                                sp=e0000100603dfdf0 bsp=e0000100603d8d48
 [<a000000100558d30>] acpi_bus_register_driver+0x50/0x80
                                sp=e0000100603dfdf0 bsp=e0000100603d8d28
 [<a000000100cd1740>] acpi_pci_root_init+0x20/0x60
                                sp=e0000100603dfdf0 bsp=e0000100603d8d10
 [<a00000010000a630>] do_one_initcall+0xb0/0x2a0
                                sp=e0000100603dfdf0 bsp=e0000100603d8cd0
 [<a000000100c9c630>] kernel_init+0x310/0x3c0
                                sp=e0000100603dfe30 bsp=e0000100603d8c88
 [<a000000100014390>] kernel_thread_helper+0x30/0x60
                                sp=e0000100603dfe30 bsp=e0000100603d8c60
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e0000100603dfe30 bsp=e0000100603d8c60
---[ end trace 4eaa2a86a8e2da44 ]---
------------[ cut here ]------------
WARNING: at kernel/resource.c:147 __set_parent+0xc0/0xe0()
Hardware name: server rx6600                   
__request_resource: parent of 'PCI Bus 0000:c2' is 'PCI mem'
Modules linked in:

Call Trace:
 [<a000000100015b70>] show_stack+0x50/0xa0
                                sp=e0000100603dfb30 bsp=e0000100603d9188
 [<a000000100015bf0>] dump_stack+0x30/0x60
                                sp=e0000100603dfd00 bsp=e0000100603d9170
 [<a00000010006fa00>] warn_slowpath_common+0xc0/0x100
                                sp=e0000100603dfd00 bsp=e0000100603d9138
 [<a00000010006fb30>] warn_slowpath_fmt+0x90/0xc0
                                sp=e0000100603dfd00 bsp=e0000100603d90d8
 [<a00000010007ef40>] __set_parent+0xc0/0xe0
                                sp=e0000100603dfd40 bsp=e0000100603d90a0
 [<a00000010007f060>] __request_resource+0x100/0x160
                                sp=e0000100603dfd40 bsp=e0000100603d9078
 [<a00000010007f3e0>] __insert_resource+0x20/0x2a0
                                sp=e0000100603dfd40 bsp=e0000100603d9038
 [<a00000010007f990>] insert_resource+0x30/0x80
                                sp=e0000100603dfd40 bsp=e0000100603d9010
 [<a000000100a00a20>] add_window+0x5e0/0x6a0
                                sp=e0000100603dfd40 bsp=e0000100603d8fa0
 [<a0000001005b2250>] acpi_walk_resources+0x1f0/0x340
                                sp=e0000100603dfd90 bsp=e0000100603d8f60
 [<a000000100a00110>] pci_acpi_scan_root+0x210/0x3e0
                                sp=e0000100603dfda0 bsp=e0000100603d8f18
 [<a0000001009e95c0>] acpi_pci_root_add+0x5c0/0x8c0
                                sp=e0000100603dfdc0 bsp=e0000100603d8ed8
 [<a000000100555420>] acpi_device_probe+0xa0/0x3c0
                                sp=e0000100603dfde0 bsp=e0000100603d8e98
 [<a0000001006395a0>] driver_probe_device+0x180/0x2a0
                                sp=e0000100603dfde0 bsp=e0000100603d8e68
 [<a0000001006397a0>] __driver_attach+0xe0/0x140
                                sp=e0000100603dfde0 bsp=e0000100603d8e38
 [<a000000100637aa0>] bus_for_each_dev+0xa0/0x120
                                sp=e0000100603dfde0 bsp=e0000100603d8e00
 [<a0000001006391e0>] driver_attach+0x40/0x60
                                sp=e0000100603dfdf0 bsp=e0000100603d8dd8
 [<a000000100638840>] bus_add_driver+0x1a0/0x540
                                sp=e0000100603dfdf0 bsp=e0000100603d8d90
 [<a00000010063a0b0>] driver_register+0x210/0x3a0
                                sp=e0000100603dfdf0 bsp=e0000100603d8d48
 [<a000000100558d30>] acpi_bus_register_driver+0x50/0x80
                                sp=e0000100603dfdf0 bsp=e0000100603d8d28
 [<a000000100cd1740>] acpi_pci_root_init+0x20/0x60
                                sp=e0000100603dfdf0 bsp=e0000100603d8d10
 [<a00000010000a630>] do_one_initcall+0xb0/0x2a0
                                sp=e0000100603dfdf0 bsp=e0000100603d8cd0
 [<a000000100c9c630>] kernel_init+0x310/0x3c0
                                sp=e0000100603dfe30 bsp=e0000100603d8c88
 [<a000000100014390>] kernel_thread_helper+0x30/0x60
                                sp=e0000100603dfe30 bsp=e0000100603d8c60
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e0000100603dfe30 bsp=e0000100603d8c60
---[ end trace 4eaa2a86a8e2da45 ]---
pci 0000:c2:00.0: PME# supported from D0 D3hot D3cold
pci 0000:c2:00.0: PME# disabled
------------[ cut here ]------------
WARNING: at kernel/resource.c:147 __set_parent+0xc0/0xe0()
Hardware name: server rx6600                   
__insert_resource: parent of 'PCI Bus 0000:c2' is ''
Modules linked in:

Call Trace:
 [<a000000100015b70>] show_stack+0x50/0xa0
                                sp=e0000100603dfb70 bsp=e0000100603d92b0
 [<a000000100015bf0>] dump_stack+0x30/0x60
                                sp=e0000100603dfd40 bsp=e0000100603d9298
 [<a00000010006fa00>] warn_slowpath_common+0xc0/0x100
                                sp=e0000100603dfd40 bsp=e0000100603d9260
 [<a00000010006fb30>] warn_slowpath_fmt+0x90/0xc0
                                sp=e0000100603dfd40 bsp=e0000100603d9200
 [<a00000010007ef40>] __set_parent+0xc0/0xe0
                                sp=e0000100603dfd80 bsp=e0000100603d91c0
 [<a00000010007f590>] __insert_resource+0x1d0/0x2a0
                                sp=e0000100603dfd80 bsp=e0000100603d9180
 [<a00000010007f990>] insert_resource+0x30/0x80
                                sp=e0000100603dfd80 bsp=e0000100603d9158
 [<a00000010052c560>] pci_claim_resource+0xc0/0x160
                                sp=e0000100603dfd80 bsp=e0000100603d9110
 [<a0000001009ffd20>] pcibios_fixup_resources+0x200/0x240
                                sp=e0000100603dfd80 bsp=e0000100603d90b8
 [<a0000001009ffe20>] pcibios_fixup_bus+0x60/0x140
                                sp=e0000100603dfd90 bsp=e0000100603d9088
 [<a0000001009e4610>] pci_scan_child_bus+0x130/0x2c0
                                sp=e0000100603dfd90 bsp=e0000100603d9048
 [<a0000001009e3eb0>] pci_scan_bridge+0x350/0x980
                                sp=e0000100603dfd90 bsp=e0000100603d8fd8
 [<a0000001009e46b0>] pci_scan_child_bus+0x1d0/0x2c0
                                sp=e0000100603dfda0 bsp=e0000100603d8f98
 [<a0000001009e47f0>] pci_scan_bus_parented+0x50/0xa0
                                sp=e0000100603dfda0 bsp=e0000100603d8f60
 [<a000000100a00150>] pci_acpi_scan_root+0x250/0x3e0
                                sp=e0000100603dfda0 bsp=e0000100603d8f18
 [<a0000001009e95c0>] acpi_pci_root_add+0x5c0/0x8c0
                                sp=e0000100603dfdc0 bsp=e0000100603d8ed8
 [<a000000100555420>] acpi_device_probe+0xa0/0x3c0
                                sp=e0000100603dfde0 bsp=e0000100603d8e98
 [<a0000001006395a0>] driver_probe_device+0x180/0x2a0
                                sp=e0000100603dfde0 bsp=e0000100603d8e68
 [<a0000001006397a0>] __driver_attach+0xe0/0x140
                                sp=e0000100603dfde0 bsp=e0000100603d8e38
 [<a000000100637aa0>] bus_for_each_dev+0xa0/0x120
                                sp=e0000100603dfde0 bsp=e0000100603d8e00
 [<a0000001006391e0>] driver_attach+0x40/0x60
                                sp=e0000100603dfdf0 bsp=e0000100603d8dd8
 [<a000000100638840>] bus_add_driver+0x1a0/0x540
                                sp=e0000100603dfdf0 bsp=e0000100603d8d90
 [<a00000010063a0b0>] driver_register+0x210/0x3a0
                                sp=e0000100603dfdf0 bsp=e0000100603d8d48
 [<a000000100558d30>] acpi_bus_register_driver+0x50/0x80
                                sp=e0000100603dfdf0 bsp=e0000100603d8d28
 [<a000000100cd1740>] acpi_pci_root_init+0x20/0x60
                                sp=e0000100603dfdf0 bsp=e0000100603d8d10
 [<a00000010000a630>] do_one_initcall+0xb0/0x2a0
                                sp=e0000100603dfdf0 bsp=e0000100603d8cd0
 [<a000000100c9c630>] kernel_init+0x310/0x3c0
                                sp=e0000100603dfe30 bsp=e0000100603d8c88
 [<a000000100014390>] kernel_thread_helper+0x30/0x60
                                sp=e0000100603dfe30 bsp=e0000100603d8c60
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e0000100603dfe30 bsp=e0000100603d8c60
---[ end trace 4eaa2a86a8e2da46 ]---

.
.
.

GSI 85 (level, low) -> CPU 4 (0x0400) vector 77
qla2xxx 0000:c3:00.0: PCI INT A -> GSI 85 (level, low) -> IRQ 77
qla2xxx 0000:c3:00.0: MSI-X vector count: 31
qla2xxx 0000:c3:00.0: Found an ISP2532, irq 77, iobase
0xc0000000f0284000
qla2xxx 0000:c3:00.0: Configuring PCI space...
qla2xxx 0000:c3:00.0: Configure NVRAM parameters...
qla2xxx 0000:c3:00.0: Verifying loaded RISC code...
qla2xxx 0000:c3:00.0: firmware: requesting ql2500_fw.bin
qla2xxx 0000:c3:00.0: FW: Loading via request-firmware...
qla2xxx 0000:c3:00.0: Allocated (64 KB) for FCE...
qla2xxx 0000:c3:00.0: Allocated (64 KB) for EFT...
qla2xxx 0000:c3:00.0: Allocated (1350 KB) for firmware dump...
scsi13 : qla2xxx
qla2xxx 0000:c3:00.0: 
 QLogic Fibre Channel HBA Driver: 8.03.01-k3
  QLogic HPAJ764A - HP 8Gb Dual Channel PCI-e 2.0 FC HBA
  ISP2532: PCIe (2.5GT/s x4) @ 0000:c3:00.0 hdma+, host#=13, fw=4.04.05
(85)
GSI 86 (level, low) -> CPU 5 (0x0500) vector 80
qla2xxx 0000:c3:00.1: PCI INT B -> GSI 86 (level, low) -> IRQ 80
qla2xxx 0000:c3:00.1: MSI-X vector count: 31
qla2xxx 0000:c3:00.1: Found an ISP2532, irq 80, iobase
0xc0000000f0280000
qla2xxx 0000:c3:00.1: Configuring PCI space...
qla2xxx 0000:c3:00.1: Configure NVRAM parameters...
qla2xxx 0000:c3:00.1: Verifying loaded RISC code...
qla2xxx 0000:c3:00.1: FW: Loading via request-firmware...
qla2xxx 0000:c3:00.1: Allocated (64 KB) for FCE...
qla2xxx 0000:c3:00.1: Allocated (64 KB) for EFT...
qla2xxx 0000:c3:00.1: Allocated (1350 KB) for firmware dump...
scsi14 : qla2xxx
qla2xxx 0000:c3:00.1: 
 QLogic Fibre Channel HBA Driver: 8.03.01-k3
  QLogic HPAJ764A - HP 8Gb Dual Channel PCI-e 2.0 FC HBA
  ISP2532: PCIe (2.5GT/s x4) @ 0000:c3:00.1 hdma+, host#=14, fw=4.04.05
(85)
.
.
.

> 		Linus
> 
> ---
>  kernel/resource.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/resource.c b/kernel/resource.c
> index ac5f3a3..023ba7a 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -140,6 +140,14 @@ __initcall(ioresources_init);
>  
>  #endif /* CONFIG_PROC_FS */
>  
> +#define set_parent(x,p) __set_parent(__FUNCTION__, x, p)
> +static void __set_parent(const char *fn, struct resource *x, struct resource *parent)
> +{
> +	WARN(!strncmp(x->name, "PCI Bus", 7),
> +		"%s: parent of '%s' is '%s'\n", fn, x->name, parent ? parent->name : "none");
> +	x->parent = parent;
> +}
> +
>  /* Return the conflict entry if you can't request it */
>  static struct resource * __request_resource(struct resource *root, struct resource *new)
>  {
> @@ -159,7 +167,7 @@ static struct resource * __request_resource(struct resource *root, struct resour
>  		if (!tmp || tmp->start > end) {
>  			new->sibling = tmp;
>  			*p = new;
> -			new->parent = root;
> +			set_parent(new, root);
>  			return NULL;
>  		}
>  		p = &tmp->sibling;
> @@ -395,13 +403,13 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
>  			break;
>  	}
>  
> -	new->parent = parent;
> +	set_parent(new, parent);
>  	new->sibling = next->sibling;
>  	new->child = first;
>  
>  	next->sibling = NULL;
>  	for (next = first; next; next = next->sibling)
> -		next->parent = new;
> +		set_parent(next, new);
>  
>  	if (parent->child == first) {
>  		parent->child = new;
> 
-- 
Andrew Patterson
Hewlett-Packard

