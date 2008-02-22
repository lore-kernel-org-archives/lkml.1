Return-Path: <linux-kernel-owner+w=401wt.eu-S934921AbYBVUJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934921AbYBVUJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933344AbYBVUHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:07:50 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:47038 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933814AbYBVUHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:07:46 -0500
Date: Fri, 22 Feb 2008 21:07:57 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       kay.sievers@vrfy.org, Michael_E_Brown@dell.com, rdreier@cisco.com,
       htejun@gmail.com
Subject: Re: [GIT PATCH] driver core fixes against 2.6.25-rc2 git
Message-ID: <20080222200757.GD7154@uranus.ravnborg.org>
References: <20080221234649.GB7128@kroah.com> <20080222075625.GA2660@uranus.ravnborg.org> <20080222195652.GA6395@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080222195652.GA6395@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 11:56:52AM -0800, Greg KH wrote:
> On Fri, Feb 22, 2008 at 08:56:25AM +0100, Sam Ravnborg wrote:
> > Hi Greg.
> > 
> > On Thu, Feb 21, 2008 at 03:46:49PM -0800, Greg KH wrote:
> > > Here are a few driver core fixes against your current git tree that fix some
> > > more problems that have cropped up:
> > > 	- shutdown problem due to logic problem with cpufreq usage of
> > > 	  kobjects.
> > > 	- build fix for powerpc due to previous kobject changes.
> > > 	- runtime errors when CONFIG_SYSFS=n
> > > 	- UIO code now works properly from my previous messups
> > > 	- proper encoding of the ja_JP stable_kernel_rules.txt file
> > > 	- updates to the stable_kernel_rules.txt file
> > > 	- mark ide=reverse as obsolete in preparation of 2.6.26 (Bart
> > > 	  wanted this to go in through my tree as I have the .26 patches
> > > 	  pending.)
> > > 	- other minor fixes.
> > 
> > 
> > Do we have any outstanding issues with section mismatch warnings in PCI Core?
> > I am as always optimistic and hope to get down to zero warnings soon.
> 
> I do not know, I saw your patches earlier and thought that they were
> going in through another tree for some reason.  If you still see any
> remaining, please send me the needed patches again.
I looked and notice there were actually only one.
Andrew picked it up but I have attached it here again.
Then I leave the decision to you.

	Sam

>From 426451c7c5d9447384b129ee3a750f66c0413a13 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 17 Feb 2008 10:45:28 +0100
Subject: [PATCH 25/27] pci: fix section mismatch warning in pci_scan_child_bus

Fix following warning:
WARNING: vmlinux.o(.text+0x47bdb1): Section mismatch in reference from the function pci_scan_child_bus() to the function .devinit.text:pcibios_fixup_bus()

We had plenty of functions that could be annotated __devinit but
due to the former restriction that annotated symbols could not
be annotated they were not so.
So annotate these function and fix the references from the
pci/hotplug/* code to silence the resuting warnings.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
---
 drivers/pci/hotplug-pci.c              |    2 +-
 drivers/pci/hotplug/acpiphp_glue.c     |    2 +-
 drivers/pci/hotplug/cpci_hotplug_pci.c |    2 +-
 drivers/pci/hotplug/pciehp_pci.c       |    2 +-
 drivers/pci/hotplug/shpchp_pci.c       |    2 +-
 drivers/pci/probe.c                    |    8 ++++----
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/hotplug-pci.c b/drivers/pci/hotplug-pci.c
index a590ef6..4d4a644 100644
--- a/drivers/pci/hotplug-pci.c
+++ b/drivers/pci/hotplug-pci.c
@@ -4,7 +4,7 @@
 #include "pci.h"
 
 
-unsigned int pci_do_scan_bus(struct pci_bus *bus)
+unsigned int __devinit pci_do_scan_bus(struct pci_bus *bus)
 {
 	unsigned int max;
 
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index cf22f9e..5e50008 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1085,7 +1085,7 @@ static int acpiphp_bus_trim(acpi_handle handle)
  * This function should be called per *physical slot*,
  * not per each slot object in ACPI namespace.
  */
-static int enable_device(struct acpiphp_slot *slot)
+static int __ref enable_device(struct acpiphp_slot *slot)
 {
 	struct pci_dev *dev;
 	struct pci_bus *bus = slot->bridge->pci_bus;
diff --git a/drivers/pci/hotplug/cpci_hotplug_pci.c b/drivers/pci/hotplug/cpci_hotplug_pci.c
index 5e9be44..dddac96 100644
--- a/drivers/pci/hotplug/cpci_hotplug_pci.c
+++ b/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -250,7 +250,7 @@ int cpci_led_off(struct slot* slot)
  * Device configuration functions
  */
 
-int cpci_configure_slot(struct slot* slot)
+int __ref cpci_configure_slot(struct slot* slot)
 {
 	struct pci_bus *parent;
 	int fn;
diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index dd50713..9372a84 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -167,7 +167,7 @@ static void program_fw_provided_values(struct pci_dev *dev)
 	}
 }
 
-static int pciehp_add_bridge(struct pci_dev *dev)
+static int __ref pciehp_add_bridge(struct pci_dev *dev)
 {
 	struct pci_bus *parent = dev->bus;
 	int pass, busnr, start = parent->secondary;
diff --git a/drivers/pci/hotplug/shpchp_pci.c b/drivers/pci/hotplug/shpchp_pci.c
index 0a6b25e..a69a215 100644
--- a/drivers/pci/hotplug/shpchp_pci.c
+++ b/drivers/pci/hotplug/shpchp_pci.c
@@ -96,7 +96,7 @@ static void program_fw_provided_values(struct pci_dev *dev)
 	}
 }
 
-int shpchp_configure_device(struct slot *p_slot)
+int __ref shpchp_configure_device(struct slot *p_slot)
 {
 	struct pci_dev *dev;
 	struct pci_bus *parent = p_slot->ctrl->pci_dev->subordinate;
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4d23b9f..5ffd610 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -286,7 +286,7 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 	}
 }
 
-void pci_read_bridge_bases(struct pci_bus *child)
+void __devinit pci_read_bridge_bases(struct pci_bus *child)
 {
 	struct pci_dev *dev = child->self;
 	u8 io_base_lo, io_limit_lo;
@@ -472,7 +472,7 @@ static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
  * them, we proceed to assigning numbers to the remaining buses in
  * order to avoid overlaps between old and new bus numbers.
  */
-int pci_scan_bridge(struct pci_bus *bus, struct pci_dev * dev, int max, int pass)
+int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev * dev, int max, int pass)
 {
 	struct pci_bus *child;
 	int is_cardbus = (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS);
@@ -1008,7 +1008,7 @@ int pci_scan_slot(struct pci_bus *bus, int devfn)
 	return nr;
 }
 
-unsigned int pci_scan_child_bus(struct pci_bus *bus)
+unsigned int __devinit pci_scan_child_bus(struct pci_bus *bus)
 {
 	unsigned int devfn, pass, max = bus->secondary;
 	struct pci_dev *dev;
@@ -1116,7 +1116,7 @@ err_out:
 	return NULL;
 }
 
-struct pci_bus *pci_scan_bus_parented(struct device *parent,
+struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 		int bus, struct pci_ops *ops, void *sysdata)
 {
 	struct pci_bus *b;
-- 
1.5.4.rc3.14.g44397

