Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbZFQSMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbZFQSMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZFQSMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:12:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749AbZFQSMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:12:14 -0400
Date: Wed, 17 Jun 2009 11:12:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Patterson <andrew.patterson@hp.com>
cc: Matthew Wilcox <matthew@wil.cx>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in resources
 trees
In-Reply-To: <1245260533.8234.241.camel@bluto.andrew>
Message-ID: <alpine.LFD.2.01.0906171047050.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio>  <4A38B3B4.1020304@jp.fujitsu.com> <20090617134311.GR19977@parisc-linux.org>  <alpine.LFD.2.01.0906170922380.16802@localhost.localdomain> <1245260533.8234.241.camel@bluto.andrew>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, Andrew Patterson wrote:
> 
> I tried Mathew's patch.  It did not help.  Here are the resources with
> the applied patch:
> 
> 0000000-fdffffff : PCI Bus 0000:c3

  ^^^^
I think you missed the initial 'f' in your cut-and-paste.

>   f0000000-fdffffff : PCI Bus 0000:c2
>     f0000000-f00fffff : 0000:c3:00.1
>       f0000000-f00fffff : qla2xxx
>     f0100000-f01fffff : 0000:c3:00.0
>       f0100000-f01fffff : qla2xxx
>     f0200000-f023ffff : 0000:c3:00.1
>     f0240000-f027ffff : 0000:c3:00.0
>     f0280000-f0283fff : 0000:c3:00.1
>       f0280000-f0283fff : qla2xxx
>     f0284000-f0287fff : 0000:c3:00.0
>       f0284000-f0287fff : qla2xxx
> 
> Note we still have the incorrect parenting problem.  

Hmm.

> At Mathew's suggestion, I added some trace code using the following
> patch:
> 
> diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
> index 3039fcb..e2d2814 100644
> --- a/drivers/pci/setup-res.c
> +++ b/drivers/pci/setup-res.c
> @@ -99,11 +99,12 @@ void pci_update_resource(struct pci_dev *dev, int resno)
>  int pci_claim_resource(struct pci_dev *dev, int resource)
>  {
>         struct resource *res = &dev->resource[resource];
> -       struct resource *root = NULL;
> +       struct resource *root;
>         char *dtype = resource < PCI_BRIDGE_RESOURCES ? "device" : "bridge";
>         int err;
>  
> -       root = pcibios_select_root(dev, res);
> +       root = pci_find_parent_resource(dev, res);
> +       dev_printk(KERN_EMERG, &dev->dev, "%s: root = %pR, res = %pR\n", __func__, root, res);

I'd really like to have seen the name of the resource too.

Just showing the resource ranges is kind of pointless when they match.

But I'm starting to have a suspicion here:

> PCI: Scanning bus 0000:c2
> pci 0000:c2:00.0: found [103c:403b] class 000604 header type 01
> pci 0000:c2:00.0: calling quirk_resource_alignment+0x0/0x3a0
> pci 0000:c2:00.0: calling pci_fixup_video+0x0/0x280
> pci 0000:c2:00.0: PME# supported from D0 D3hot D3cold
> pci 0000:c2:00.0: PME# disabled
> PCI: Fixups for bus 0000:c2
> pci 0000:c2:00.0: scanning behind bridge, config fbc3c2, pass 0
> PCI: Scanning bus 0000:c3
> pci 0000:c3:00.0: found [1077:2532] class 000c04 header type 00
> pci 0000:c3:00.0: reg 10 io port: [0x1100-0x11ff]
> pci 0000:c3:00.0: reg 14 64bit mmio: [0xf0284000-0xf0287fff]
> pci 0000:c3:00.0: reg 1c 64bit mmio: [0xf0100000-0xf01fffff]
> pci 0000:c3:00.0: reg 30 32bit mmio: [0xf0240000-0xf027ffff]
> pci 0000:c3:00.0: calling quirk_resource_alignment+0x0/0x3a0
> pci 0000:c3:00.0: calling pci_fixup_video+0x0/0x280
> pci 0000:c3:00.1: found [1077:2532] class 000c04 header type 00
> pci 0000:c3:00.1: reg 10 io port: [0x1000-0x10ff]
> pci 0000:c3:00.1: reg 14 64bit mmio: [0xf0280000-0xf0283fff]
> pci 0000:c3:00.1: reg 1c 64bit mmio: [0xf0000000-0xf00fffff]
> pci 0000:c3:00.1: reg 30 32bit mmio: [0xf0200000-0xf023ffff]
> pci 0000:c3:00.1: calling quirk_resource_alignment+0x0/0x3a0
> pci 0000:c3:00.1: calling pci_fixup_video+0x0/0x280
> PCI: Fixups for bus 0000:c3
> pci 0000:c2:00.0: bridge io port: [0x1000-0xffff]
> pci 0000:c2:00.0: bridge 32bit mmio: [0xf0000000-0xfdffffff]
> pci 0000:c2:00.0: bridge 64bit mmio pref: [0x80780000000-0x807ffffffff]
> pci 0000:c2:00.0: pci_claim_resource: root = [0x00-0xffffffffffffffff], res = [0x8001000-0x800ffff]
> pci 0000:c2:00.0: pci_claim_resource: root = [0x000000-0xffffffffffffffff], res = [0xf0000000-0xfdffffff]
> pci 0000:c2:00.0: pci_claim_resource: root = [0x000000-0xffffffffffffffff], res = [0x80780000000-0x807ffffffff]
> pci 0000:c3:00.0: pci_claim_resource: root = [0x8001000-0x800ffff], res = [0x8001100-0x80011ff]
> pci 0000:c3:00.0: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf0284000-0xf0287fff]
> pci 0000:c3:00.0: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf0100000-0xf01fffff]
> pci 0000:c3:00.0: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf0240000-0xf027ffff]
> pci 0000:c3:00.1: pci_claim_resource: root = [0x8001000-0x800ffff], res = [0x8001000-0x80010ff]
> pci 0000:c3:00.1: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf0280000-0xf0283fff]
> pci 0000:c3:00.1: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf0000000-0xf00fffff]
> pci 0000:c3:00.1: pci_claim_resource: root = [0xf0000000-0xfdffffff], res = [0xf0200000-0xf023ffff]
> PCI: Bus scan for 0000:c3 returning with max=c3
> pci 0000:c2:00.0: scanning behind bridge, config fbc3c2, pass 1
> PCI: Bus scan for 0000:c2 returning with max=fb

You're not actually showing the case where you have that error case of
"0xf0000000-0xfdffffff" inside another "0xf0000000-0xfdffffff"

IOW, that one is done in some totally different place, not in 
'pci_claim_resource()' at all.

So no wonder it makes no difference when pci_claim_resource() is fixed.

This is why I'd really like to see the output of my test-patch. It would 
show exactly _where_ that resource is inserted, and the whole call-chain.

I'm appending a version that only does it for resources that have names 
starting with "PCI Bus", so it should be less noisy. But again, it's 
totally untested.

		Linus

---
 kernel/resource.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index ac5f3a3..023ba7a 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -140,6 +140,14 @@ __initcall(ioresources_init);
 
 #endif /* CONFIG_PROC_FS */
 
+#define set_parent(x,p) __set_parent(__FUNCTION__, x, p)
+static void __set_parent(const char *fn, struct resource *x, struct resource *parent)
+{
+	WARN(!strncmp(x->name, "PCI Bus", 7),
+		"%s: parent of '%s' is '%s'\n", fn, x->name, parent ? parent->name : "none");
+	x->parent = parent;
+}
+
 /* Return the conflict entry if you can't request it */
 static struct resource * __request_resource(struct resource *root, struct resource *new)
 {
@@ -159,7 +167,7 @@ static struct resource * __request_resource(struct resource *root, struct resour
 		if (!tmp || tmp->start > end) {
 			new->sibling = tmp;
 			*p = new;
-			new->parent = root;
+			set_parent(new, root);
 			return NULL;
 		}
 		p = &tmp->sibling;
@@ -395,13 +403,13 @@ static struct resource * __insert_resource(struct resource *parent, struct resou
 			break;
 	}
 
-	new->parent = parent;
+	set_parent(new, parent);
 	new->sibling = next->sibling;
 	new->child = first;
 
 	next->sibling = NULL;
 	for (next = first; next; next = next->sibling)
-		next->parent = new;
+		set_parent(next, new);
 
 	if (parent->child == first) {
 		parent->child = new;
