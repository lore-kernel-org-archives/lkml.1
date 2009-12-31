Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbZLaSG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbZLaSG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 13:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZLaSGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 13:06:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46173 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbZLaSGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 13:06:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [origin tree build failure] Re: [git pull] PCI fixes
Date: Thu, 31 Dec 2009 19:06:35 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091228081002.71f0e3b9@jbarnes-x200> <20091231122617.GA3508@elte.hu>
In-Reply-To: <20091231122617.GA3508@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912311906.35704.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 31 December 2009, Ingo Molnar wrote:
> 
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > The following changes since commit 8bea8672edfca7ec5f661cafb218f1205863b343:
> >   Stephen Rothwell (1):
> >         mfd: compile fix for twl4030 renaming
> > 
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus
> > 
> > A few misc fixes.  A few people have run into the CLS bug so far, which Csaba
> > kindly provided a fix for (detection of PCI cache line size is a good
> > improvement, but it will fail in some cases due to a virtualized or buggy
> > platform).
> > 
> > This set also adds the device specific reset quirk code from Dexuan;
> > needed for some devices especially in virtualized environments.
> > 
> > Benjamin Herrenschmidt (1):
> >       PCI/cardbus: Add a fixup hook and fix powerpc
> > 
> > Csaba Henk (1):
> >       PCI: Handle case when no pci device can provide cache line size hint
> > 
> > Detlef Riekenberg (1):
> >       vgaarbiter: fix a typo in the vgaarbiter Documentation
> > 
> > Dexuan Cui (3):
> >       PCI: support device-specific reset methods
> >       PCI: add Intel USB specific reset method
> >       PCI: add Intel 82599 Virtual Function specific reset method
> > 
> > Jiri Slaby (1):
> >       PCI: fix section mismatch on update_res()
> > 
> > Rafael J. Wysocki (1):
> >       PCI/PM: Propagate wake-up enable for PCIe devices too
> > 
> > Stefan Assmann (2):
> >       PCI: change PCI nomenclature in drivers/pci/ (comment changes)
> >       PCI: change PCI nomenclature in drivers/pci/ (non-comment changes)
> > 
> >  Documentation/vgaarbiter.txt           |    2 +-
> >  arch/powerpc/kernel/pci-common.c       |   13 +++++++
> >  arch/x86/pci/bus_numa.c                |    2 +-
> >  drivers/pci/hotplug/shpchp.h           |    2 +-
> >  drivers/pci/intel-iommu.c              |    6 ++--
> >  drivers/pci/intr_remapping.c           |    2 +-
> >  drivers/pci/pci-acpi.c                 |   10 +----
> >  drivers/pci/pci.c                      |   30 +++++++++++++++--
> >  drivers/pci/pci.h                      |    8 ++++
> >  drivers/pci/pcie/aer/Kconfig.debug     |    4 +-
> >  drivers/pci/pcie/aer/aer_inject.c      |    6 ++--
> >  drivers/pci/pcie/aer/aerdrv.c          |    2 +-
> >  drivers/pci/pcie/aer/aerdrv_acpi.c     |    2 +-
> >  drivers/pci/pcie/aer/aerdrv_core.c     |    6 ++--
> >  drivers/pci/pcie/aer/aerdrv_errprint.c |    4 +-
> >  drivers/pci/pcie/aspm.c                |    4 +-
> >  drivers/pci/pcie/portdrv_pci.c         |    2 +-
> >  drivers/pci/quirks.c                   |   57 +++++++++++++++++++++++++++++++-
> >  drivers/pci/search.c                   |    6 ++--
> >  drivers/pcmcia/cardbus.c               |    2 +-
> >  include/linux/pci.h                    |    3 ++
> >  21 files changed, 135 insertions(+), 38 deletions(-)
> 
> FYI, a commit in this tree broke today's -tip build on x86:
> 
>  drivers/built-in.o: In function `pci_dev_reset':
>  pci.c:(.text+0x95ed): undefined reference to `pci_dev_reset_methods'
>  pci.c:(.text+0x95fd): undefined reference to `pci_dev_reset_methods'
> 
> I wont have time to bisect it today but wanted to give you a heads up.

This quite obviously is an upshot of

commit b9c3b266411d27f1a6466c19d146d08db576bfea
Author: Dexuan Cui <dexuan.cui@intel.com>
Date:   Mon Dec 7 13:03:21 2009 +0800

    PCI: support device-specific reset methods

and happens because you don't have CONFIG_PCI_QUIRKS defined in your
(random?) .configs.

The patch below should fix it.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PCI: Fix build if quirks are not enabled

After commit b9c3b266411d27f1a6466c19d146d08db576bfea
(PCI: support device-specific reset methods) kernel building is
broken if CONFIG_PCI_QUIRKS is unset.

Fix this by moving pci_dev_specific_reset() to drivers/pci/quirks.c
and providing an empty replacement for !CONFIG_PCI_QUIRKS builds.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/pci/pci.c    |   15 ---------------
 drivers/pci/pci.h    |    2 +-
 drivers/pci/quirks.c |   19 ++++++++++++++++++-
 3 files changed, 19 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -2684,14 +2684,31 @@ static int reset_intel_82599_sfp_virtfn(
 
 #define PCI_DEVICE_ID_INTEL_82599_SFP_VF   0x10ed
 
-struct pci_dev_reset_methods pci_dev_reset_methods[] = {
+static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82599_SFP_VF,
 		 reset_intel_82599_sfp_virtfn },
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
 		reset_intel_generic_dev },
 	{ 0 }
 };
+
+int pci_dev_specific_reset(struct pci_dev *dev, int probe)
+{
+	struct pci_dev_reset_methods *i;
+
+	for (i = pci_dev_reset_methods; i->reset; i++) {
+		if ((i->vendor == dev->vendor ||
+		     i->vendor == (u16)PCI_ANY_ID) &&
+		    (i->device == dev->device ||
+		     i->device == (u16)PCI_ANY_ID))
+			return i->reset(dev, probe);
+	}
+
+	return -ENOTTY;
+}
+
 #else
 void pci_fixup_device(enum pci_fixup_pass pass, struct pci_dev *dev) {}
+int pci_dev_specific_reset(struct pci_dev *dev, int probe) { return -ENOTTY; }
 #endif
 EXPORT_SYMBOL(pci_fixup_device);
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -2430,21 +2430,6 @@ static int pci_parent_bus_reset(struct p
 	return 0;
 }
 
-static int pci_dev_specific_reset(struct pci_dev *dev, int probe)
-{
-	struct pci_dev_reset_methods *i;
-
-	for (i = pci_dev_reset_methods; i->reset; i++) {
-		if ((i->vendor == dev->vendor ||
-		     i->vendor == (u16)PCI_ANY_ID) &&
-		    (i->device == dev->device ||
-		     i->device == (u16)PCI_ANY_ID))
-			return i->reset(dev, probe);
-	}
-
-	return -ENOTTY;
-}
-
 static int pci_dev_reset(struct pci_dev *dev, int probe)
 {
 	int rc;
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -328,6 +328,6 @@ struct pci_dev_reset_methods {
 	int (*reset)(struct pci_dev *dev, int probe);
 };
 
-extern struct pci_dev_reset_methods pci_dev_reset_methods[];
+extern int pci_dev_specific_reset(struct pci_dev *dev, int probe);
 
 #endif /* DRIVERS_PCI_H */
