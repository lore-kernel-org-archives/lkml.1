Return-Path: <linux-kernel-owner+w=401wt.eu-S1761384AbZFQURg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761384AbZFQURg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 16:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760369AbZFQUR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 16:17:27 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49349 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbZFQUR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 16:17:26 -0400
Date: Wed, 17 Jun 2009 14:17:28 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Patterson <andrew.patterson@hp.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in
	resources trees
Message-ID: <20090617201727.GV19977@parisc-linux.org>
References: <20090616220419.14021.84524.stgit@bob.kio> <4A38B3B4.1020304@jp.fujitsu.com> <20090617134311.GR19977@parisc-linux.org> <alpine.LFD.2.01.0906170922380.16802@localhost.localdomain> <1245260533.8234.241.camel@bluto.andrew> <alpine.LFD.2.01.0906171047050.16802@localhost.localdomain> <1245269316.8234.270.camel@bluto.andrew> <alpine.LFD.2.01.0906171309500.16802@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906171309500.16802@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 01:12:42PM -0700, Linus Torvalds wrote:
> On Wed, 17 Jun 2009, Andrew Patterson wrote:
> > > 
> > > This is why I'd really like to see the output of my test-patch. It would 
> > > show exactly _where_ that resource is inserted, and the whole call-chain.
> > > 
> > > I'm appending a version that only does it for resources that have names 
> > > starting with "PCI Bus", so it should be less noisy. But again, it's 
> > > totally untested.
> > > 
> > 
> > Here you go (I can provide the full boot log if needed). Note, there is
> > nothing for c3 here:
> 
> Ok, so that means it got inserted into the resource tree some other way 
> entirely. Or maybe the name got changed after-the-fact. Both of which 
> imply that something is really really wrong.

Yes.

> The ones your trace _does_ show are the ones that got inserted correctly 
> and aren't buggy. Can anybody see how that buggy resource got inserted?

Carefully studying the results of git grep insert_resource doesn't show
too many options.  Most are in code which doesn't get executed on ia64.
add_window is the only one which looks even remotely plausible, and
that's only supposed to be called for root bridges.

I did notice that pcibios_setup_root_windows() is being called too late.
It's currently called after pci_scan_bus_parented() when it needs to be
called from pcibios_fixup_bus() [ie during the scan_bus, before child
busses are scanned].

Andrew's currently testing this patch:


diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 61f1af5..ae5ee8a 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -371,8 +371,6 @@ pci_acpi_scan_root(struct acpi_device *device, int domain, int bus)
 	 * such quirk. So we just ignore the case now.
 	 */
 	pbus = pci_scan_bus_parented(NULL, bus, &pci_root_ops, controller);
-	if (pbus)
-		pcibios_setup_root_windows(pbus, controller);
 
 	return pbus;
 
@@ -490,6 +488,8 @@ pcibios_fixup_bus (struct pci_bus *b)
 	if (b->self) {
 		pci_read_bridge_bases(b);
 		pcibios_fixup_bridge_resources(b->self);
+	} else {
+		pcibios_setup_root_windows(b, b->sysdata);
 	}
 	list_for_each_entry(dev, &b->devices, bus_list)
 		pcibios_fixup_device_resources(dev);

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
