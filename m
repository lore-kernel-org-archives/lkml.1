Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbZAENux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbZAENux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZAENu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:50:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54814 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbZAENuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:50:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86 PCI: Do not use interrupt links for devices using MSI-X
Date: Mon, 5 Jan 2009 14:50:27 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-tst; KDE/4.1.3; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200901042308.42625.rjw@sisk.pl> <20090105130439.GA6014@elte.hu>
In-Reply-To: <20090105130439.GA6014@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901051450.28310.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > pcibios_enable_device() and pcibios_disable_device() don't handle
> > IRQs for devices that have MSI enabled and it should tread the
> 
> s/tread/treat

Ah, thanks.

> > devices with MSI-X enabled in the same way.
> > 
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > ---
> >  arch/x86/pci/common.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> looks good - Jesse, what do you think?
> 
> Rafael, i'm curious is this in response to some regression/bug? Did some 
> box or driver get confused by us enabling/disabling the GSI? Some IRQ 
> flood perhaps?

Well, I don't have any MSI-X capable boxes around. :-)

I was just reviewing the code and spotted this.

> btw., there's a small observation:
> 
> > +     if (!dev->msi_enabled && !dev->msix_enabled)
> 
> maybe a "pci_has_gsi_irq()" wrapper would make these checks cleaner and 
> would make things more robust, should there be any new IRQ delivery method 
> be introduced in the future?

Well, perhaps something like the patch below?

Thanks,
Rafael

---
Subject: x86 PCI: Do not use interrupt links for devices using MSI-X (rev. 2)
From: Rafael J. Wysocki <rjw@sisk.pl>

pcibios_enable_device() and pcibios_disable_device() don't handle
IRQs for devices that have MSI enabled and it should treat the
devices with MSI-X enabled in the same way.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/pci/common.c |    4 ++--
 include/linux/pci.h   |    9 +++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/pci/common.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/common.c
+++ linux-2.6/arch/x86/pci/common.c
@@ -551,14 +551,14 @@ int pcibios_enable_device(struct pci_dev
 	if ((err = pci_enable_resources(dev, mask)) < 0)
 		return err;
 
-	if (!dev->msi_enabled)
+	if (!pci_msi_enabled(dev))
 		return pcibios_enable_irq(dev);
 	return 0;
 }
 
 void pcibios_disable_device (struct pci_dev *dev)
 {
-	if (!dev->msi_enabled && pcibios_disable_irq)
+	if (!pci_msi_enabled(dev) && pcibios_disable_irq)
 		pcibios_disable_irq(dev);
 }
 
Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -274,6 +274,15 @@ static inline void pci_add_saved_cap(str
 	hlist_add_head(&new_cap->next, &pci_dev->saved_cap_space);
 }
 
+#ifdef CONFIG_PCI_MSI
+static inline bool pci_msi_enabled(struct pci_dev *pci_dev)
+{
+	return dev->msi_enabled || dev->msix_enabled;
+}
+#else
+static inline bool pci_msi_enabled(struct pci_dev *pci_dev) { return false; }
+#endif
+
 /*
  *  For PCI devices, the region numbers are assigned this way:
  *

