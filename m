Return-Path: <linux-kernel-owner+w=401wt.eu-S1758741AbZFQRjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741AbZFQRjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbZFQRjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:39:32 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:17631 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbZFQRjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:39:31 -0400
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in
 resources trees
From: Andrew Patterson <andrew.patterson@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
In-Reply-To: <alpine.LFD.2.01.0906170922380.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio>
	 <4A38B3B4.1020304@jp.fujitsu.com> <20090617134311.GR19977@parisc-linux.org>
	 <alpine.LFD.2.01.0906170922380.16802@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 11:42:13 -0600
Message-Id: <1245260533.8234.241.camel@bluto.andrew>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 09:23 -0700, Linus Torvalds wrote:
> 
> On Wed, 17 Jun 2009, Matthew Wilcox wrote:
> > 
> > Anyway, this should fix pci_claim_resource (untested):
> 
> Ack. This looks very sane. I'll happily commit this, but would be even 
> happier to hear that it got some testing too, so I'll hold off for a 
> while.
> 

I tried Mathew's patch.  It did not help.  Here are the resources with
the applied patch:

0000000-fdffffff : PCI Bus 0000:c3
  f0000000-fdffffff : PCI Bus 0000:c2
    f0000000-f00fffff : 0000:c3:00.1
      f0000000-f00fffff : qla2xxx
    f0100000-f01fffff : 0000:c3:00.0
      f0100000-f01fffff : qla2xxx
    f0200000-f023ffff : 0000:c3:00.1
    f0240000-f027ffff : 0000:c3:00.0
    f0280000-f0283fff : 0000:c3:00.1
      f0280000-f0283fff : qla2xxx
    f0284000-f0287fff : 0000:c3:00.0
      f0284000-f0287fff : qla2xxx

Note we still have the incorrect parenting problem.  

At Mathew's suggestion, I added some trace code using the following
patch:

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 3039fcb..e2d2814 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -99,11 +99,12 @@ void pci_update_resource(struct pci_dev *dev, int resno)
 int pci_claim_resource(struct pci_dev *dev, int resource)
 {
        struct resource *res = &dev->resource[resource];
-       struct resource *root = NULL;
+       struct resource *root;
        char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
        int err;
 
-       root = pcibios_select_root(dev, res);
+       root = pci_find_parent_resource(dev, res);
+       dev_printk(KERN_EMERG, &dev->dev, "%s: root = %pR, res = %pR\n", __func__, root, res);
 
        err = -EINVAL;
        if (root != NULL)


And here is the output:

PCI: Scanning bus 0000:c2
pci 0000:c2:00.0: found [103c:403b] class 000604 header type 01
pci 0000:c2:00.0: calling quirk_resource_alignment+0x0/0x3a0
pci 0000:c2:00.0: calling pci_fixup_video+0x0/0x280
pci 0000:c2:00.0: PME# supported from D0 D3hot D3cold
pci 0000:c2:00.0: PME# disabled
PCI: Fixups for bus 0000:c2
pci 0000:c2:00.0: scanning behind bridge, config fbc3c2, pass 0
PCI: Scanning bus 0000:c3
pci 0000:c3:00.0: found [1077:2532] class 000c04 header type 00
pci 0000:c3:00.0: reg 10 io port: [0x1100-0x11ff]
pci 0000:c3:00.0: reg 14 64bit mmio: [0xf0284000-0xf0287fff]
pci 0000:c3:00.0: reg 1c 64bit mmio: [0xf0100000-0xf01fffff]
pci 0000:c3:00.0: reg 30 32bit mmio: [0xf0240000-0xf027ffff]
pci 0000:c3:00.0: calling quirk_resource_alignment+0x0/0x3a0
pci 0000:c3:00.0: calling pci_fixup_video+0x0/0x280
pci 0000:c3:00.1: found [1077:2532] class 000c04 header type 00
pci 0000:c3:00.1: reg 10 io port: [0x1000-0x10ff]
pci 0000:c3:00.1: reg 14 64bit mmio: [0xf0280000-0xf0283fff]
pci 0000:c3:00.1: reg 1c 64bit mmio: [0xf0000000-0xf00fffff]
pci 0000:c3:00.1: reg 30 32bit mmio: [0xf0200000-0xf023ffff]
pci 0000:c3:00.1: calling quirk_resource_alignment+0x0/0x3a0
pci 0000:c3:00.1: calling pci_fixup_video+0x0/0x280
PCI: Fixups for bus 0000:c3
pci 0000:c2:00.0: bridge io port: [0x1000-0xffff]
pci 0000:c2:00.0: bridge 32bit mmio: [0xf0000000-0xfdffffff]
pci 0000:c2:00.0: bridge 64bit mmio pref: [0x80780000000-0x807ffffffff]
pci 0000:c2:00.0: pci_claim_resource: root = [0x00-0xffffffffffffffff], res = [0x8
001000-0x800ffff]
pci 0000:c2:00.0: pci_claim_resource: root = [0x000000-0xffffffffffffffff], res = 
[0xf0000000-0xfdffffff]
pci 0000:c2:00.0: pci_claim_resource: root = [0x000000-0xffffffffffffffff], res = 
[0x80780000000-0x807ffffffff]
pci 0000:c3:00.0: pci_claim_resource: root = [0x8001000-0x800ffff], res = [0x80011
00-0x80011ff]
pci 0000:c3:00.0: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf02
84000-0xf0287fff]
pci 0000:c3:00.0: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf01
00000-0xf01fffff]
pci 0000:c3:00.0: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf02
40000-0xf027ffff]
pci 0000:c3:00.1: pci_claim_resource: root = [0x8001000-0x800ffff], res = [0x80010
00-0x80010ff]
pci 0000:c3:00.1: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf02
80000-0xf0283fff]
pci 0000:c3:00.1: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf00
00000-0xf00fffff]
pci 0000:c3:00.1: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf02
00000-0xf023ffff]
PCI: Bus scan for 0000:c3 returning with max=c3
pci 0000:c2:00.0: scanning behind bridge, config fbc3c2, pass 1
PCI: Bus scan for 0000:c2 returning with max=fb



> 		Linus
> 
-- 
Andrew Patterson
Hewlett-Packard

